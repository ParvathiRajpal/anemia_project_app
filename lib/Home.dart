import 'dart:io';
import 'package:flutter/material.dart';
import 'package:anemia_project_app/components/BottomNavBar.dart';
import 'package:anemia_project_app/components/Accuracy_card.dart';
import 'package:anemia_project_app/components/upload_img_btn.dart';
import 'package:anemia_project_app/components/CheckResults.dart';
import 'package:anemia_project_app/components/ImageListTile.dart';
import 'package:image_picker/image_picker.dart';
import 'components/result.dart';

final picker = ImagePicker();
String? imagePath;
File? _image;

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
                  ibCard(
                    accuracy: '--',
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
      _image = File(pickedFile.path);
      if (_image != null) {
        imagePath = _image?.path;
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
            ? ImageListTile(
          caller: "Widget2",
          imagePath: imagePath!,
          text: "Find Result",
          c:0xff6F8EFC,
          onPress: () {
            setState(() {
              selectedCard = WidgetMarker.Three;
            });
          },
        ) : Text("Please select an image from the gallery.");
       case WidgetMarker.Three:
        return summary(
          imagePath: imagePath,
          // file: file,
          maxLines: 5,
          anemia: "detected",
          onPress: () {},
          t1: "Igigs sudjds",
          text:
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.",
        );
    }
    return getCustomCard();
  }

}
