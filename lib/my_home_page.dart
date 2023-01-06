import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _hasRunModel = false;
  File? _image;
  List? _result;
  final _picker = ImagePicker();

  // TODOTODOTODO
  // OUR MODEL DISPLAY
  // void foodClassifier(final File image)async{
  //   var result = await
  // }

  void pickCameraImage() async {
    var image = await _picker.pickImage(source: ImageSource.camera);
    if (image == null) return null;
    setState(() {
      _image = File(image.path);
    });
  }

  void pickGalleryImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return null;
    setState(() {
      _image = File(image.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Machine Learning'),
      ),
      body: _body(context),
    );
  }

  Widget _body(final BuildContext context) => Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            _mediumVerticalSpacer(),
            _hasRunModel
                ? Column(
                    children: [
                      SizedBox(
                        height: 300,
                        width: MediaQuery.of(context).size.width,
                        child: Image.file(_image!),
                      ),
                      _mediumVerticalSpacer(),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Text(
                          '${_result![0]['label']}',
                          style: const TextStyle(
                            color: Colors.purple,
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                        ),
                      )
                    ],
                  )
                : const Text(
                    'Food Classifier',
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
            _selectionButtons()
          ],
        ),
      );

  Widget _mediumVerticalSpacer() => const SizedBox(
        height: 20,
      );

  Widget _selectionButtons() => Column(
        children: [
          _mediumVerticalSpacer(),
          _selectionPhoto('Capture Photo', pickCameraImage),
          _mediumVerticalSpacer(),
          _selectionPhoto('Select Photo', pickGalleryImage),
        ],
      );

  Widget _selectionPhoto(final String label, final VoidCallback onTap) =>
      Column(
        children: [
          GestureDetector(
            onTap: onTap,
            child: Container(
              width: 150,
              padding: const EdgeInsets.all(8),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      );
}
