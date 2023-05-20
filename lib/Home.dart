import 'dart:io';
import 'dart:ui';
import 'dart:core';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';
import 'package:anemia_project_app/components/BottomNavBar.dart';
import 'package:anemia_project_app/components/Accuracy_card.dart';
import 'package:anemia_project_app/components/upload_img_btn.dart';
import 'package:anemia_project_app/components/CheckResults.dart';
import 'package:image_picker/image_picker.dart';
import 'package:anemia_project_app/classifier/classifier_holder.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tflite_flutter_helper_plus/tflite_flutter_helper_plus.dart';
import 'classifier/accuracy.dart';
import 'classifier/classifier.dart';
import 'components/result.dart';
import 'image_model.dart';

final picker = ImagePicker();
String? imagePath;
File? image;

enum WidgetMarker { One, Two, Three }


class Home extends StatefulWidget {
  static const String id = '/home';
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  WidgetMarker selectedCard = WidgetMarker.One;
  bool _isButtonPressed = false;
  double? accuracy;
  var logger = Logger();
  late File _image;
  // late List _results;
  // late final double? accuracy;
  bool imageSelect=false;

  Category? category;

   final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Classifier _classifier = ClassifierHolder.getClassifier();

  @override
  void initState()  {
    super.initState();
    // _classifier = ClassifierFloat();
  }


  Future imageClassification(File image)
  async {
    // final SharedPreferences prefs = await _prefs;
    setState(() {
      _image=image;
      imageSelect=true;
      _predict();
      // accuracy = prefs.getDouble('accuracy');
    });
  }

  void _predict() async {
    img.Image imageInput = img.decodeImage(_image.readAsBytesSync())!;
    var pred = await _classifier.predict(imageInput);

    setState(() {
      category = pred as Category?;
    });


    String imagePath = 'assets/images/${category?.label}/';
    accuracy = await evaluate(_classifier,imagePath,"${category?.label}");
    accuracy=(accuracy!*100)!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 20),
              color: Colors.transparent,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 25, bottom: 10, top: 30, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Dashboard',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 25,
                              fontFamily: 'Roboto-Medium',
                              letterSpacing: 1,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                              height: 1),
                        ),
                        Container(
                          padding: EdgeInsets.only(bottom: 5),
                          child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.settings,
                              size: 30,
                              color: Color(0xff45539F),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  accuracyCard(
                    accuracy: accuracy,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 15, bottom: 10, right: 10),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 20,
                              ),
                              child: getCustomCard(),
                            ),
                            checkResults(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.only(top: 5),
                height: 4,
                width: MediaQuery.of(context).size.width,
                color: Color(0xffff6F8EFC),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(
        index: 0,context: context,
      ),
    );
  }


  Future<void> _openGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      image = File(pickedFile.path);
      if (image != null) {
        imagePath = image?.path;
        print('Image picked: ${pickedFile.path}');
      } else {
        print('Failed to create File object.');
      }
    } else {
      print('No image selected.');
    }
  }


  Widget getCustomCard() {
    switch (selectedCard) {
      case WidgetMarker.One:
        return UploadButton(
          onPress: () async {
            await _openGallery();
            setState(() {
              selectedCard = WidgetMarker.Two;
              _isButtonPressed = true;
            });
          },
        );
      case WidgetMarker.Two:
        return _isButtonPressed && imagePath != null
            ? Image_Model(
          caller: "Widget2",
          imagePath: imagePath!,
          text: "Find Result",
          c:0xff6F8EFC,
          onPress: () {
            setState(() {
              selectedCard = WidgetMarker.Three;
              imageClassification(image!);
            });
          },
        ) : Text("Please select an image from the gallery.");
      case WidgetMarker.Three:
        return summary(
          imagePath: imagePath,
          maxLines: 5,
          anemia: category?.label=='ida'?"detected":"nil",
          onPress: () {},
          t1: "${category?.score.toStringAsFixed(3)}",
          text:
          "${category?.label}",
        );
    }
  }


}
