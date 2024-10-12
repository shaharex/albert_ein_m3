package com.example.ws_germany_ae3

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.provider.MediaStore
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import org.json.JSONArray
import org.json.JSONObject
import java.io.InputStream

class MainActivity : FlutterActivity() {
    private val PICK_IMAGE = 100;
    private var resultCallback: MethodChannel.Result? = null;

    private val CHANNEL = "image_picker_channel"
    private val CHANNELSH = "com.sharedpref"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            if (call.method == "pickImage") {
                openGallery()
                resultCallback = result
            } else {
                result.notImplemented()
            }
        }

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNELSH
        ).setMethodCallHandler { call, result ->
            if (call.method == "saveUserProfile") {

                val sharedPref = getSharedPreferences("FlutterSharedPref", Context.MODE_PRIVATE)
                val profileString = sharedPref.getString("userProfiles", "[]")
                val profiles = JSONArray(profileString)
                val newProfile = JSONObject().apply {
                    put("username", call.argument<String>("username"))
                    put("image", call.argument<String>("image"))
                    put("description", call.argument<String>("description"))
                }

                var profileExists = false
                for (i in 0 until profiles.length()) {
                    val profile = profiles.getJSONObject(i)
                    if (profile.getString("username") == newProfile.getString("username")) {
                        profiles.put(i, newProfile)
                        profileExists = true
                        break
                    }
                }
                if (!profileExists) {
                    profiles.put(newProfile)
                }

                with(sharedPref.edit()) {
                    putString("userProfiles", profiles.toString())
                    apply()
                }
                result.success(null)

            } else if (call.method == "getUserProfile") {
                val username = call.argument<String>("username")
                val sharedPref = getSharedPreferences("FlutterSharedPref", Context.MODE_PRIVATE)
                val profielsString = sharedPref.getString("userProfiles", "[]")
                val profiles = JSONArray(profielsString)

                for (i in 0 until profiles.length()) {
                    val profile = profiles.getJSONObject(i)
                    if (profile.getString("username") == username) {
                        result.success(mapOf(
                            "image" to profile.getString("image"),
                            "description" to profile.getString("description")
                        ))
                        return@setMethodCallHandler
                    }
                }

                result.error("NO_DATA", "No user profile found sorry", null)
            }
            else {
                result.notImplemented()
            }
        }
    }

    private fun openGallery() {
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
