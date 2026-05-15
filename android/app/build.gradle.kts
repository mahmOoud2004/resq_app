plugins {
    id("com.android.application")
    id("kotlin-android")

    // The Flutter Gradle Plugin must be applied
    // after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {

    namespace = "com.example.resq_app"

    compileSdk = 36

    ndkVersion = flutter.ndkVersion

    compileOptions {

        sourceCompatibility =
            JavaVersion.VERSION_17

        targetCompatibility =
            JavaVersion.VERSION_17

        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget =
            JavaVersion.VERSION_17.toString()
    }

    defaultConfig {

        applicationId =
            "com.example.resq_app"

        minSdk =
            flutter.minSdkVersion

        targetSdk =
            36

        versionCode =
            flutter.versionCode

        versionName =
            flutter.versionName
    }

    buildTypes {

        release {

            isMinifyEnabled = false
            isShrinkResources = false

            signingConfig =
                signingConfigs.getByName(
                    "debug"
                )
        }
    }
}

flutter {
    source = "../.."
}

dependencies {

    coreLibraryDesugaring(
        "com.android.tools:desugar_jdk_libs:2.1.4"
    )

    implementation(
        "com.google.mlkit:text-recognition-chinese:16.0.0"
    )

    implementation(
        "com.google.mlkit:text-recognition-devanagari:16.0.0"
    )

    implementation(
        "com.google.mlkit:text-recognition-japanese:16.0.0"
    )

    implementation(
        "com.google.mlkit:text-recognition-korean:16.0.0"
    )
}