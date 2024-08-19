# Face Detection with Vision

An Example of Face Detection with Vision in Flutter.

## How it works
Using MethodChannel to communicate between Flutter and Native code, we can use the Vision API to detect faces in images.

Check my Medium article for more details: [Face Detection with Vision in Flutter](https://medium.com/@enesakbal00/flutter-face-detection-on-ios-with-vision-7d6eda867541)

```swift
import UIKit
import Flutter
import Vision

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let faceDetectionChannel = FlutterMethodChannel(name: "com.example.faceDetectionIos/faceDetectionIos", binaryMessenger: controller.binaryMessenger)
    
    faceDetectionChannel.setMethodCallHandler({(call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      if call.method == "getFaceCountFromImage" {
        if let imagePath = call.arguments as? String {
          self.detectFacesFromImage(imagePath: imagePath, result: result)
        }
      } else {
        result(FlutterMethodNotImplemented)
      }
    })

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }


private func detectFacesFromImage(imagePath: String, result: @escaping FlutterResult) {
    let imageURL = URL(fileURLWithPath: imagePath)
    guard let image = CIImage(contentsOf: imageURL) else {
      result(FlutterError(code: "UNAVAILABLE", message: "Cannot load image", details: nil))
      return
    }
    
    let faceDetectionRequest = VNDetectFaceRectanglesRequest { (request, error) in
      guard error == nil else {
        result(FlutterError(code: "ERROR", message: error?.localizedDescription, details: nil))
        return
      }
      
      let faceCount = request.results?.count ?? 0
      result(faceCount)
    }
    
    #if targetEnvironment(simulator)
    faceDetectionRequest.usesCPUOnly = true
    #endif
    
    let handler = VNImageRequestHandler(ciImage: image, options: [:])
    do {
      try handler.perform([faceDetectionRequest])
    } catch {
      result(FlutterError(code: "ERROR", message: "Face detection failed", details: error.localizedDescription))
    }
  }
}
```


## Usage
```dart
import 'dart:io';

import 'package:flutter/services.dart';

abstract class FaceDetectionManager {
  static const _channel = MethodChannel('com.example.faceDetectionIos/faceDetectionIos');

  static Future<int> detectFaceFromImage(String imagePath) async {
    try {
      if (Platform.isIOS) {
        final faceCount = await _channel.invokeMethod<int>('getFaceCountFromImage', imagePath);

        if (faceCount == null) {
          throw 'Face count is null';
        }

        return faceCount;
      } else if (Platform.isAndroid) {
        //* You can use the Google ML Kit for Android or iOS to detect faces in an image.
        //* See details here: https://developers.google.com/ml-kit/vision/face-detection
      }

      throw UnsupportedError('Unsupported platform');
    } catch (e) {
      rethrow;
    }
  }
}
```


### Set Up
- Clone Project
```bash
git clone https://github.com/enesakbal/face-detection-ios.git
```

- ```flutter run```

---


## Contact Me
[![LinkedIn](https://img.shields.io/badge/linkedin-0A66C2?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/enesakbl/)
[![Medium](https://img.shields.io/badge/Medium-12100E?style=for-the-badge&logo=medium&logoColor=white)](https://medium.com/@enesakbal00)

enesakbal00@gmail.com

created by ea.