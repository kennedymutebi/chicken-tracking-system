plugins.whenPluginAdded {
    if (this is com.android.build.gradle.AppPlugin || this is com.android.build.gradle.LibraryPlugin) {
        extensions.configure<com.android.build.gradle.BaseExtension> {
            compileSdkVersion(34)
            ndkVersion = "29.0.13113456"

            defaultConfig {
                minSdkVersion(23)  // <-- Add this here
                ndk {
                    abiFilters.clear()
                    abiFilters.addAll(listOf("armeabi-v7a", "arm64-v8a"))
                }
            }

            packagingOptions {
                pickFirst("**/libc++_shared.so")
                pickFirst("**/libjsc.so")
            }
        }
    }
}
