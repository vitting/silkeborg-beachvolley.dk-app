#Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

#Firebase Funtions / Auth / Analytics / Storage / Messaging
-keepattributes EnclosingMethod
-keepattributes InnerClasses

#Firebase Auth / Storage
-keepattributes Signature
-keepattributes *Annotation*

#Firebase firestore
# Keep custom model classes
-keep class com.google.firebase.example.fireeats.model.** { *; }

#Firebase Messaging
-dontwarn com.google.android.gms.measurement.AppMeasurement*
-keepclassmembers class * extends com.google.android.gms.internal.measurement.zzyv {
  <fields>;
}

# https://github.com/firebase/FirebaseUI-Android/issues/1175
-dontwarn okio.**
-dontwarn retrofit2.Call
-dontnote retrofit2.Platform$IOS$MainThreadExecutor
-keep class android.support.v7.widget.RecyclerView { *; }

#Firebase functions
# https://github.com/firebase/FirebaseUI-Android/issues/1227
-dontwarn com.firebase.ui.auth.data.remote.**