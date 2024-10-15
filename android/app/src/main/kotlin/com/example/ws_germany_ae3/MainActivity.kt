package com.example.ws_germany_ae3

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.net.Uri
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
    private val CHANNELSS = "com.share"


    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        

        // method for picking image
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

        // user data and post data
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNELSH
        ).setMethodCallHandler { call, result ->
            when(call.method) {
                "saveUserProfile" -> {
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

                }

                "getUserProfile" -> {
                    val username = call.argument<String>("username")
                    val sharedPref = getSharedPreferences("FlutterSharedPref", Context.MODE_PRIVATE)
                    val profilesString = sharedPref.getString("userProfiles", "[]")
                    val profiles = JSONArray(profilesString)

                    for (i in 0 until profiles.length()) {
                        val profile = profiles.getJSONObject(i)
                        if (profile.getString("username") == username) {
                            result.success(
                                mapOf(
                                    "image" to profile.getString("image"),
                                    "description" to profile.getString("description")
                                )
                            )
                            return@setMethodCallHandler
                        }
                    }

                    result.error("NO_DATA", "No user profile found sorry", null)
                }

                "addPost" -> {
                    val sharedPref = getSharedPreferences("FlutterSharedPref", Context.MODE_PRIVATE)
                    val postsString = sharedPref.getString("posts", "[]")
                    val posts = JSONArray(postsString)
                    val newPost = JSONObject().apply {
                        put("username", call.argument<String>("username"))
                        put("userImage", call.argument<String>("userImage"))
                        put("postImage", call.argument<String>("postImage"))
                        put("postDescription", call.argument<String>("postDescription"))
                        put("likeCount", call.argument<Int>("likeCount"))
                        put("comments", JSONArray(call.argument<List<Any>>("comments")))
                    }

                    posts.put(newPost)


                    with(sharedPref.edit()) {
                        putString("posts", posts.toString())
                        apply()
                    }
                    result.success(null)
                }

                "getPostsData" -> {
                    val username = call.argument<String>("username")
                    val sharedPref = getSharedPreferences("FlutterSharedPref", Context.MODE_PRIVATE)
                    val postsString = sharedPref.getString("posts", "[]")
                    val posts = JSONArray(postsString)

                    for (i in 0 until posts.length()) {
                        val post = posts.getJSONObject(i)
                        if (post.getString("username") == username) {
                            val commentsArray = post.getJSONArray("comments")
                            val commentsList = ArrayList<String>()
                            for (j in 0 until commentsArray.length()) {
                                commentsList.add(commentsArray.getString(i))
                            }

                            result.success(
                                mapOf(
                                    "username" to post.getString("username"),
                                    "userImage" to post.getString("userImage"),
                                    "postImage" to post.getString("postImage"),
                                    "postDescription" to post.getString("postDescription"),
                                    "likeCount" to post.getInt("likeCount"),
                                    "comments" to commentsList,
                                )
                            )
                            return@setMethodCallHandler
                        }
                    }

                    result.error("NO_Data", "NO posts found bruh", null)
                }
                else -> result.notImplemented()
            }
        }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNELSS).setMethodCallHandler { call, result ->
            if (call.method == "share") {
                val text = call.argument<String>("text")
                if (text != null) {
                    shareText(text)
                    result.success("Share sheet opened")
                } else {
                    result.error("ERROR", "Text is null", null)
                }
            } else {
                result.notImplemented()
            }
        }

    }

    private fun shareText(text: String) {
        val sendIntent: Intent = Intent().apply {
            action = Intent.ACTION_SEND
            putExtra(Intent.EXTRA_TEXT, text)
            type = "text/plain"
        }
        val shareIntent = Intent.createChooser(sendIntent, null)
        startActivity(shareIntent)
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
