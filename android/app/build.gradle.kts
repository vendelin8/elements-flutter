import java.util.Properties
import java.io.FileInputStream

plugins {
	id("com.android.application")
	id("kotlin-android")
	// The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
	id("dev.flutter.flutter-gradle-plugin")
}

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
val hasKeystore = keystorePropertiesFile.exists()
if (hasKeystore) {
	keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
	namespace = "io.github.vendelin8.elements"
	compileSdk = flutter.compileSdkVersion
	ndkVersion = flutter.ndkVersion

	compileOptions {
		sourceCompatibility = JavaVersion.VERSION_17
		targetCompatibility = JavaVersion.VERSION_17
	}

	kotlinOptions {
		jvmTarget = "17"
	}

	defaultConfig {
		applicationId = "io.github.vendelin8.elements"
		minSdk = flutter.minSdkVersion
		targetSdk = flutter.targetSdkVersion
		versionCode = flutter.versionCode
		versionName = flutter.versionName
	}

	signingConfigs {
		if (hasKeystore) {
			create("release") {
				keyAlias = keystoreProperties["keyAlias"]?.toString()
				keyPassword = keystoreProperties["keyPassword"]?.toString()
				storeFile = keystoreProperties["storeFile"]?.toString()?.let { file(it) }
				storePassword = keystoreProperties["storePassword"]?.toString()
				enableV2Signing = true
			}
			getByName("debug") {
				keyAlias = keystoreProperties["keyAlias"]?.toString()
				keyPassword = keystoreProperties["keyPassword"]?.toString()
				storeFile = keystoreProperties["storeFile"]?.toString()?.let { file(it) }
				storePassword = keystoreProperties["storePassword"]?.toString()
				enableV2Signing = true
			}
		}
	}

	buildTypes {
		getByName("debug") {
			if (hasKeystore) {
				signingConfig = signingConfigs.getByName("debug")
			}
		}
		getByName("release") {
			if (hasKeystore) {
				signingConfig = signingConfigs.getByName("release")
			}
			isMinifyEnabled = true
			isShrinkResources = true
			proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
		}
	}
}

flutter {
	source = "../.."
}

dependencies {
	implementation("org.jetbrains.kotlin:kotlin-stdlib-jdk7:2.3.20")
	coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:1.1.5")
}
