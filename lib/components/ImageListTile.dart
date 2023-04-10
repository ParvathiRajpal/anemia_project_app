import 'dart:io';
import 'package:anemia_project_app/components/image_desc.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'login_button.dart';

class ImageListTile extends StatelessWidget {
  final String imagePath;
  final String caller;
  String text;
  int c;
  final VoidCallback onPress;

  ImageListTile({required this.imagePath,required this.onPress,required this.text, required this.caller,required this.c});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FileSystemEntity>(
      future: Future.value(File(imagePath)),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final file = snapshot.data as File;
          print("File path: ${file.path}");
          if (file.existsSync()) {
            return Container(
              height: 100,
              margin: EdgeInsets.only(top:15,left: 20, right: 35,bottom: 20),
              child: Row(
                children: [
                  img(file:file, text:imagePath, maxLines: 1,),
                  Container(
                    margin: EdgeInsets.only(left: 25, right: 2, bottom: 10),
                    child: LoginButton(
                      text: text,
                      onPress: onPress,
                      w: MediaQuery.of(context).size.width - 90,
                      color: c,
                      textColor: 0xFFffffff,
                      highlight: 0xff451EB7,
                    ),
                  ),
                ],
              ),
            );
          } else {
            print("File does not exist");
            return Text("Error loading image");
          }
        } else if (snapshot.hasError) {
          print("Future error: ${snapshot.error}");
          return Text("Error loading image");
        } else {
          return SizedBox(
            width: 50,
            height: 50,
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

