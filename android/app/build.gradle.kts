plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin") // Flutter Gradle Plugin
    id("com.google.gms.google-services")   // Google Services Plugin
}

android {
    namespace = "com.example.res_q"
    compileSdk = 35  // Update to 35 to match dependency requirements
    defaultConfig {
        applicationId = "com.example.res_q"
        minSdk = 23  // Keep minSdk at 23
        targetSdk = 35  // Update to 35
        versionCode = 1
        versionName = "1.0"
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = "11"
    }

    buildTypes {
        dependencies {

            // Import the Firebase BoM

            implementation(platform("com.google.firebase:firebase-bom:33.10.0"))


            // TODO: Add the dependencies for Firebase products you want to use

            // When using the BoM, don't specify versions in Firebase dependencies

            implementation("com.google.firebase:firebase-analytics")


            // Add the dependencies for any other desired Firebase products

            // https://firebase.google.com/docs/android/setup#available-libraries

        }
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

