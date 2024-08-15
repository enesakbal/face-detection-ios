import 'dart:io';

import 'package:flutter/services.dart';

abstract class FaceDetectionManager {
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

  static const _channel = MethodChannel('com.example.faceDetectionIos/faceDetectionIos');
}
