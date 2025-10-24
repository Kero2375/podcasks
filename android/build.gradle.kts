allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)

    // fix for ISAR: Namespace not specified. Specify a namespace in the module's build file
    val ISAR_SDK_VERSION = 35
    val DEFAULT_SDK_VERSION = 36
    afterEvaluate {
        if (extensions.findByName("android") != null) {
            val sdkVersion = when (project.name) {
                "isar_flutter_libs" -> ISAR_SDK_VERSION
                else -> DEFAULT_SDK_VERSION
            }

            extensions.configure<com.android.build.gradle.BaseExtension>("android") {
                compileSdkVersion(sdkVersion)
                defaultConfig {
                    targetSdkVersion(sdkVersion)
                }
                if (namespace == null) {
                    namespace = group.toString()
                }
            }
        }
    }
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
