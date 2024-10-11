package com.example.ws_germany_ae3

import android.app.Activity
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.provider.MediaStore
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.InputStream

class MainActivity: FlutterActivity() {
    private val PICK_IMAGE = 100;
    private var resultCallback: MethodChannel.Result? = null;

    private val CHANNEL = "image_picker_channel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                call, result -> if (call.method == "pickImage") {
            openGallery()
            resultCallback = result
        } else {
            result.notImplemented()
        }
        }
    }

    private  fun openGallery() {
        val gallery = Intent(Intent.ACTION_PICK, MediaStore.Images.Media.EXTERNAL_CONTENT_URI)
        startActivityForResult(gallery, PICK_IMAGE)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)

        if (resultCode == Activity.RESULT_OK && requestCode == PICK_IMAGE) {
            val imageUri: Uri? = data?.data
            if (imageUri != null) {
                val inputStream: InputStream? = contentResolver.openInputStream(imageUri)
                val imageBytes: ByteArray? = inputStream?.readBytes()
                resultCallback?.success(imageBytes)
            } else {
                resultCallback?.error("ERROR", "Failed to pick image", null)
            }
        }
    }
}
