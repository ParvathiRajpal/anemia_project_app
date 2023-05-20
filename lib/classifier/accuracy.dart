import 'dart:ui';
import 'dart:convert';
import 'classifier.dart';
import 'classifier_float.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as path;
import 'package:flutter/services.dart';
import 'package:tflite_flutter_helper_plus/tflite_flutter_helper_plus.dart';


Future<double> evaluate(Classifier classifier,String imagePath, String dataLabel) async {

  int correctPredictions = 0;
  Category? category;
  List<String> imageAssetNames = await getImagePathsFromDirectory(
      path.basename(imagePath)); // use basename instead of splitting the path
  print(imagePath);
  print(imageAssetNames.length);
  for (int i = 0; i < imageAssetNames.length; i++) {
    String assetName = imageAssetNames[i];
    String testLabel = path.basenameWithoutExtension(imagePath); // use basenameWithoutExtension instead of splitting the path
    print(i);
    ByteData imageData = await rootBundle.load(assetName);
    img.Image image = img.decodeImage(imageData.buffer.asUint8List())!;
    var prediction = await classifier.predictForMultipleInputs(image);
    category = prediction as Category?;
    print("${category?.label}");
    if (category?.label == testLabel) {
      correctPredictions++;
    }
  }
  correctPredictions += (dataLabel == category?.label) ? 1 : -1;
  double accuracy = correctPredictions / (imageAssetNames.length + 1);

  return accuracy;
}

Future<List<String>> getImagePathsFromDirectory(String fileName) async {
  final List<String> imagePaths = [];
  final String manifestContent = await rootBundle.loadString('AssetManifest.json');
  final Map<String, dynamic> manifestMap = json.decode(manifestContent);

  for (String key in manifestMap.keys) {
    if (key.endsWith('.jpg') && key.contains('assets/images/$fileName/')) {
      String imagePath = key.replaceAll('packages/anemia_project_app/', '');
      print(imagePath);
      imagePaths.add(imagePath);
    }
  }

  return imagePaths;
}
