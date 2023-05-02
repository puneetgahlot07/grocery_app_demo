import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_nude_detector/flutter_nude_detector.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:image_picker/image_picker.dart';
import 'package:profanity_filter/profanity_filter.dart';

class Home extends StatefulWidget {
  static String routeName = "/Home";
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final filter = ProfanityFilter();
  bool error = false;
  Future<String> _getModel(String assetPath) async {
    if (Platform.isAndroid) {
      return 'flutter_assets/$assetPath';
    }
    return assetPath;
    // final path = '${(await getApplicationSupportDirectory()).path}/$assetPath';
    // await Directory(dirname(path)).create(recursive: true);
    // final file = io.File(path);
    // if (!await file.exists()) {
    //   final byteData = await rootBundle.load(assetPath);
    //   await file.writeAsBytes(byteData.buffer
    //       .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    // }
    // return file.path;
  }

  late ImageLabeler imageLabeler;

  void _initializeLabeler() async {
    const path = 'assets/ml_models.nude.tflite';
    final modelPath = await _getModel(path);
    final options = LocalLabelerOptions(modelPath: modelPath);
    imageLabeler = ImageLabeler(options: options);
    log(imageLabeler.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: ListView(
        children: [
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 6,
              vertical: 6,
            ),
            child: TextField(
              decoration: const InputDecoration(
                label: Text("Enter Text"),
              ),
              onChanged: (val) {
                if (filter.hasProfanity(val)) {
                  setState(() {
                    error = true;
                  });
                } else {
                  error = false;
                  setState(() {});
                }
              },
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          if (error)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Bad String", style: TextStyle(color: Colors.red))
              ],
            ),
          SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: ElevatedButton(
                onPressed: () {
                  pickImage();
                },
                child: Text("Add Image")),
          ),
          // if (_containsNudity)
          // Text("Bad String", style: TextStyle(color: Colors.red)),
          if (image != null)
            Image.file(
              image!,
              height: 300,
            ),
          // NudityStatusChip(containsNudity: _containsNudity),
        ],
      ),
    );
  }

  File? image;
  bool _containsNudity = false;

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      // setState(() => ;
      final hasNudity = await FlutterNudeDetector.detect(path: image.path);
      log(hasNudity.toString());
      setState(() {
        this.image = imageTemp;
        _containsNudity = hasNudity;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }
}

class NudityStatusChip extends StatelessWidget {
  /// NudityStatusChip constructor
  const NudityStatusChip({required this.containsNudity, super.key});

  /// Variable that indicate if image contains nudity or not
  final bool containsNudity;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: containsNudity ? Colors.red : Colors.green,
        borderRadius: const BorderRadius.all(
          Radius.circular(
            32,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        child: Text(
          containsNudity ? 'Contains nudity!' : 'Does not contain nudity',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
