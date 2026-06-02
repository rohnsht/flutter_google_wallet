package np.com.rohanshrestha.flutter_google_wallet

import android.app.Activity
import android.app.Activity.RESULT_CANCELED
import android.app.Activity.RESULT_OK
import android.content.Intent
import android.util.Log
import com.google.android.gms.common.api.CommonStatusCodes
import com.google.android.gms.pay.Pay
import com.google.android.gms.pay.PayApiAvailabilityStatus
import com.google.android.gms.pay.PayClient
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry

private const val TAG = "Flutter Google Wallet"
private const val METHOD_CHANNEL_NAME = "np.com.rohanshrestha/flutter_google_wallet"
private const val METHOD_IS_AVAILABLE = "isAvailable"
private const val METHOD_SAVE_PASSES = "savePasses"
private const val METHOD_SAVE_PASSES_JWT = "savePassesJwt"
private const val REQUEST_CODE = 1001

/** FlutterGoogleWalletPlugin */
class FlutterGoogleWalletPlugin : FlutterPlugin, MethodCallHandler,
    PluginRegistry.ActivityResultListener, ActivityAware {

    private var activity: Activity? = null
    private var currentResult: Result? = null
    private lateinit var channel: MethodChannel
    private lateinit var walletClient: PayClient

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, METHOD_CHANNEL_NAME)
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(
        call: MethodCall, result: Result
    ) {
        when (call.method) {
            METHOD_IS_AVAILABLE -> checkIsAvailable()
            METHOD_SAVE_PASSES ->
                walletClient.savePasses(
                    call.argument<String>("passJson")!!,
                    activity!!,
                    REQUEST_CODE
                )

            METHOD_SAVE_PASSES_JWT ->
                walletClient.savePassesJwt(
                    call.argument<String>("passJwt")!!,
                    activity!!,
                    REQUEST_CODE
                )

            else -> result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    private fun checkIsAvailable() {
        walletClient
            .getPayApiAvailabilityStatus(PayClient.RequestType.SAVE_PASSES)
            .addOnSuccessListener { status ->
                handleSuccess(status == PayApiAvailabilityStatus.AVAILABLE)
            }
            .addOnFailureListener { exception ->
                handleError(CommonStatusCodes.ERROR.toString(), exception.message)
            }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        Log.d(TAG, "onActivityResult: $resultCode")
        if (requestCode == REQUEST_CODE) {
            when (resultCode) {
                RESULT_OK -> handleSuccess(true)
                RESULT_CANCELED -> handleSuccess(false)
                PayClient.SavePassesResult.SAVE_ERROR ->
                    data?.let { intentData ->
                        val error = intentData.getStringExtra(PayClient.EXTRA_API_ERROR_MESSAGE)
                        handleError(resultCode.toString(), error)
                    }

                else -> handleError(
                    CommonStatusCodes.INTERNAL_ERROR.toString(),
                    "Unknown error saving pass"
                )
            }
            return true
        }
        return false
    }

    private fun handleSuccess(result: Boolean) {
        Log.d(TAG, "handleSuccess: $result")
        currentResult?.success(result)
        currentResult = null
    }

    private fun handleError(code: String, message: String?) {
        Log.d(TAG, "handleError: $code / $message")
        currentResult?.error(code, message, null)
        currentResult = null
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
        walletClient = Pay.getClient(activity!!)
        binding.addActivityResultListener(this)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
        binding.addActivityResultListener(this)
    }

    override fun onDetachedFromActivity() {
        activity = null
    }
}
