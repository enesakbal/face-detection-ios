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
    let faceDetectionChannel = FlutterMethodChannel(name: "face_detection", binaryMessenger: controller.binaryMessenger)
    
    faceDetectionChannel.setMethodCallHandler({(call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      if call.method == "getFaceCount" {
        if let imagePath = call.arguments as? String {
          self.detectFaces(imagePath: imagePath, result: result)
        }
      } else {
        result(FlutterMethodNotImplemented)
      }
    })

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }


private func detectFaces(imagePath: String, result: @escaping FlutterResult) {
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
