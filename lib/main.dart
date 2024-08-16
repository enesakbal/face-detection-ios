import 'package:face_detection_ios/face_detection_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() => runApp(const MainApp());

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final imagePicker = ImagePicker();

  String? selectedImagePath;
  int? faceCount;

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                //* Select Image from Gallery Button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        final file = await imagePicker.pickImage(source: ImageSource.gallery);

                        if (file != null) {
                          selectedImagePath = file.path;
                          faceCount = await FaceDetectionManager.detectFaceFromImage(selectedImagePath!);
                        }
                      } catch (e) {
                        debugPrint(e.toString());
                      }

                      setState(() {});
                    },
                    child: const Text(
                      'Select Image from Gallery',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                //* Take a Picture Button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        final file = await imagePicker.pickImage(source: ImageSource.camera);

                        if (file != null) {
                          selectedImagePath = file.path;

                          faceCount = await FaceDetectionManager.detectFaceFromImage(selectedImagePath!);
                        }

                        setState(() {});
                      } catch (e) {
                        debugPrint(e.toString());
                      }
                    },
                    child: const Text(
                      'Take a Picture',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //* Image Display
                Expanded(
                  child: Builder(
                    builder: (context) {
                      if (selectedImagePath == null) {
                        return const Center(child: Text('No image selected'));
                      }

                      return Image.asset(selectedImagePath!);
                    },
                  ),
                ),
                const SizedBox(height: 16),

                //* Face Count Text
                RichText(
                  text: TextSpan(
                    text: 'Face Count: ',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: '${faceCount ?? 'No face detected'}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                //* Selected Image Text
                RichText(
                  text: TextSpan(
                    text: 'Selected Image: ',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: (selectedImagePath?.split('/').last) ?? 'No image selected',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
