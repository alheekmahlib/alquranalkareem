package com.alheekmah.alquranalkareem.alquranalkareem

import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: android.os.Bundle?) {
        super.onCreate(savedInstanceState)
        // Force-load ONNX Runtime classes from the main thread.
        // Without this, JNI FindClass("ai/onnxruntime/TensorInfo") fails
        // on some Android devices when called from a background thread.
        try {
            Class.forName("ai.onnxruntime.TensorInfo")
            Class.forName("ai.onnxruntime.OnnxTensor")
            Class.forName("ai.onnxruntime.OrtEnvironment")
            Class.forName("ai.onnxruntime.OrtSession")
        } catch (_: Exception) {}
    }
}
