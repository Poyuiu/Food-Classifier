import 'dart:io';
import 'dart:ui';

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
  int? _len;
  final String _cannot = 'Cannot Detect It';

  final List<List<double>> _foodInfo = [
    [482, 10.3, 14.9, 77, 0.832, 65],
    [533, 12, 26.6, 61.4, 1.29, 79],
    [542, 12.9, 28.3, 59, 0.739, 69],
    [620, 16.8, 19.1, 95.2, 1.012, 79],
    [459, 9.6, 11.8, 78.7, 0.755, 68],
    [575, 12.4, 17, 93.2, 0.965, 79],
    [537, 14.1, 27.4, 58.7, 0.869, 69],
    [454, 16.1, 15, 63.8, 1.15, 79],
    [615, 15.8, 34, 61.4, 0.932, 69],
    [442, 17.8, 14.2, 60.7, 0.822, 79],
    [531, 10.7, 20.1, 76.7, 0.735, 65],
    [500, 14.4, 23.1, 58.6, 0.928, 79],
    [375, 23.5, 24.8, 14.6, 1.108, 69]
  ];

  final List<String> _foodName = [
    '義美蝦仁炒飯',
    '青醬野菇義大利麵',
    '青醬蛤蠣義大利麵',
    '素三杯炒飯',
    '素三杯嫩菇拌飯',
    '薑黃素炒飯',
    '奶油培根義大利麵',
    '雙醬雞肉義大利麵',
    '番茄肉醬義大利麵',
    '番茄牛肉義大利麵',
    '義美鮭魚炒飯',
    '桂冠培根義大利麵',
    '麻辣臭豆腐'
  ];
  // TODOTODOTODO
  // OUR MODEL DISPLAY

  void loadModel() async {
    String? res = await Tflite.loadModel(
        model: 'assets/model_unquant2.tflite', labels: 'assets/labels2.txt');
    setState(() {});
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
                ? _len == 0
                    ? Text(_cannot,
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ))
                    : _displayFoodInfo(int.parse(_result![0]['label']))
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

  Widget _displayFoodInfo(final int item) => TextButton(
        // style:
            // ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.deepPurple),),
        onPressed: () => showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            // contentPadding: const EdgeInsets.only(left: 10.0, right: 10.0),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))),
            title: Text(
              _foodName[item],
              style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            content: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                //position
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    '熱量： ${_foodInfo[item][0]}卡',
                    style: const TextStyle(fontSize: 24, color: Colors.indigo),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    '脂肪： ${_foodInfo[item][2]}克',
                    style: const TextStyle(fontSize: 24, color: Colors.indigo),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    '碳水： ${_foodInfo[item][3]}克',
                    style: const TextStyle(fontSize: 24, color: Colors.indigo),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    '鈉含量： ${_foodInfo[item][4]}克',
                    style: const TextStyle(fontSize: 24, color: Colors.indigo),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    '蛋白質： ${_foodInfo[item][1]}克',
                    style: const TextStyle(fontSize: 24, color: Colors.indigo),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    '價格： ${_foodInfo[item][5]}元',
                    style: const TextStyle(fontSize: 24, color: Colors.indigo),
                  )
                ]),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text(
                  'Nice',
                  style: TextStyle(fontSize: 20, color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
        child: const Text(
          'More Information',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.deepPurple),
        ),
      );
}
