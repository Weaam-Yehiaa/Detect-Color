
import 'dart:io';

import 'package:detect_color/say_result.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
  bool _hasRunModel=false;
  File? _image;
  List? _result;
  final _picker=ImagePicker();

  //for loading model
  void loadModel()async{
    await Tflite.loadModel(
        model: 'assets/model_unquant.tflite',
      labels:'assets/labels.txt',
    );
  }

  @override
  void initState() {
    loadModel();
    super.initState();
  }

  @override
  void dispose() {
    Tflite.close();
    _hasRunModel=false;
    super.dispose();
  }
  //function for detection color
  // we download the color detection db
  //by defining the color classes, we generate and download the trained model
  void detectionColor(final File image)async{
    var result=await Tflite.runModelOnImage(
      path: image.path,
      numResults: 9,
      threshold: 0.6,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    setState(() {
      _result=result;
      sayResult(_result![0]['label']);
      _hasRunModel=true;
    });
  }

  void pickCameraImage()async{
    var image=await _picker.pickImage(source: ImageSource.camera);
    if(image==null)return null;
    setState(() {
      _image=File(image.path);
    });
    detectionColor(_image!);
  }
  
  void pickGalleryImage()async{
    var image=await _picker.pickImage(source: ImageSource.gallery);
    if(image==null)return null;
    setState(() {
      _image=File(image.path);
    });
    detectionColor(_image!);
  }
  
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Machine Learning'),
      ),
      body: _body(context),
    );
  }

  Widget _body(final BuildContext context)=>Container(
    width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height,
    child: Column(
      children: [
        _mediumVerticalSpacer(),
        _hasRunModel?Column(
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
              child: Text('${_result![0]['label']}',
              style: const TextStyle(
                color: Colors.purple,
                fontWeight: FontWeight.bold,
                fontSize: 32,),),
            ),
          ],
        ):const Text(
          'Color Detection',
          style: TextStyle(
          color: Colors.blueAccent,
            fontSize: 32,
            fontWeight: FontWeight.w600,
        ),
        ),
        Expanded(child: _selectionButtons()),
      ],
    ),
  );

  Widget _selectionButtons()=>Column(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      _selectionPhoto('Capture Photo', pickCameraImage),
      _mediumVerticalSpacer(),
      _selectionPhoto('Select Photo', pickGalleryImage),
      _mediumVerticalSpacer(),
    ],

  );
  Widget _selectionPhoto(final String label, final VoidCallback onTap )=>Column(
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
          child: Text(label,style: const TextStyle(color: Colors.white),),
        ),
      ),
    ],
  );
  Widget _mediumVerticalSpacer() => const SizedBox(
    height: 20,
  );
}
