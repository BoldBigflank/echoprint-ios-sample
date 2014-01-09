This is an upgraded version of the Echoprint Sample iOS Project

- Modernized Objective-C
- Modernized UIKit and other legacy project files
- Updated ASIHTTP to more current version
- Added Cocoapods

The project requires a depdendency on libechoprint-codegen-ios.a

Run pod install to setup the pod files.

Follow this to compile libechoprint-codegen-ios.a for yourself: http://stackoverflow.com/questions/12135898/echoprint-ios-missing-framework.

Requires the BOOST C++ libraries. 

Unfortunately the available instructions are all for pre-XCODE 5. I had to update the compiler under build settings to avoid some errors about llvm43 not being available.

I ultimately got frustrated fighting with Boost linker errors and looked elesewhere for my audio finger printing needs. Try this article: http://bleepsandpops.com/post/7453509622/using-the-echoprint-audio-fingerprinter-on-os-x-or-ios.


