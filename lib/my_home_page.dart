import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';

import 'package:tflite/tflite.dart';

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
  // res, len is for debugging
  String? _res;
  int? _len;
  String _cannot = 'Cannot Detect It';

  // TODOTODOTODO
  // OUR MODEL DISPLAY

  void loadModel() async {
    String? res = await Tflite.loadModel(
        model: 'assets/model_unquant2.tflite', labels: 'assets/labels2.txt');
    setState(() {
      _res = res;
    });
  }

  @override
  void initState() {
    loadModel();
    super.initState();
  }

  @override
  void dispose() {
    Tflite.close();
    _hasRunModel = false;
    super.dispose();
  }

  void foodClassifier(final File image) async {
    var result = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 5,
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5,
    );

    setState(() {
      _result = result;
      _hasRunModel = true;
      _len = _result!.length;
    });
  }

  void pickCameraImage() async {
    var image = await _picker.pickImage(source: ImageSource.camera);
    if (image == null) return null;
    setState(() {
      _image = File(image.path);
    });
    foodClassifier(_image!);
  }

  void pickGalleryImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return null;
    setState(() {
      _image = File(image.path);
    });
    foodClassifier(_image!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Microwave Food Classifier'),
      ),
      body: _body(context),
    );
  }

  Widget _body(final BuildContext context) => Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            // _mediumVerticalSpacer(),
            // _hasRunModel
            // ? Column(
            //     children: [
            //       SizedBox(
            //         height: 300,
            //         width: MediaQuery.of(context).size.width,
            //         child: Image.file(_image!),
            //       ),
            //       _mediumVerticalSpacer(),
            //       Container(
            //         padding: const EdgeInsets.all(20),
            //         decoration: BoxDecoration(
            //           border: Border.all(color: Colors.grey),
            //         ),
            //         child: Text(
            //           '${_result![0]['label']}',
            //           style: const TextStyle(
            //             color: Colors.purple,
            //             fontWeight: FontWeight.bold,
            //             fontSize: 30,
            //           ),
            //         ),
            //       )
            //     ],
            //   )
            // : const Text(
            //     'Food Classifier',
            //     style: TextStyle(
            //       color: Colors.blueAccent,
            //       fontSize: 32,
            //       fontWeight: FontWeight.w600,
            //     ),
            //   ),
            _selectionButtons(),
            _mediumVerticalSpacer(),
            _image != null
                ? Image.file(
                    _image!,
                    cacheHeight: 400,
                    cacheWidth: 300,
                  )
                : const Text(
                    'No Image Selected',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Colors.black87),
                  ),
            _mediumVerticalSpacer(),
            _hasRunModel
                ? Text('${_len == 0 ? _cannot : _result![0]['label']}',
                    style: const TextStyle(
                      color: Colors.purple,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ))
                : _mediumVerticalSpacer(),
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
              width: 170,
              padding: const EdgeInsets.all(8),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      );
}
