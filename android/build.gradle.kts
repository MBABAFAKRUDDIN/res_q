plugins {

    // ...


    // Add the dependency for the Google services Gradle plugin

    id("com.google.gms.google-services") version "4.4.2" apply false

}
buildscript {
    repositories {
        google() // Google's Maven repository
        mavenCentral() // Central repository for dependencies
    }
    dependencies {
        classpath("com.android.tools.build:gradle:7.3.0") // Keep your Gradle version
        classpath("com.google.gms:google-services:4.3.10") // Firebase dependency
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}


