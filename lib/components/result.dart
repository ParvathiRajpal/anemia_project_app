import 'dart:io';
import 'package:anemia_project_app/components/prop_value_text.dart';
import 'package:anemia_project_app/components/prop_value_widget.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import 'ImageListTile.dart';

class summary extends StatefulWidget {
  final String? imagePath;
  final VoidCallback onPress;
  int maxLines;
  String text;
  String t1;
  String anemia;

  summary(
      {required this.imagePath,
      required this.onPress,
      required this.t1,
      required this.anemia,
      required this.text,
      required this.maxLines});

  @override
  State<summary> createState() => _summaryState();
}

class _summaryState extends State<summary> {
  late File file;

  @override
  void initState() {
    super.initState();
    file = File(widget.imagePath!);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            margin: EdgeInsets.only(left:20,right: 30,bottom: 50),
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left:40,right: 100, top: 15, bottom: 20),
                  child: Text(
                    "Test \nImage:",
                    style: TextStyle(
                        fontSize: 20,
                        letterSpacing: 1,
                        fontWeight: FontWeight.w300,
                        height: 1),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 10, top: 20, bottom: 20),
                  width: 80,
                  height: 80,
                  child: Image.file(
                    file,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 22, top: 5,bottom: 10),
            child: Text(
              "Result:",
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontSize: 22,
                  letterSpacing: 1,
                  fontWeight: FontWeight.normal,
                  color: Color(0xff45539F),
                  height: 1),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 16),
            child: Column(
              children: [
                Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        fit: FlexFit.loose,
                        child: Container(
                          width: 80,
                          height: 80,
                          child: Image.file(
                            file,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 25),
                        width: 200,
                        child: Text(
                          widget.text,
                          maxLines: widget.maxLines,
                          overflow: TextOverflow.ellipsis,
                          textDirection: TextDirection.ltr,
                        ),
                      ),
                    ]),
                Container(
                  margin: const EdgeInsets.only(
                      top: 50, bottom: 12, left: 24, right: 12),
                  padding: EdgeInsets.only(right: 20),
                  child: propValueWidget(
                    widget1: const textProperty(
                      t: 'Lorem Ipsum:',
                      c: blue,
                    ),
                    widget2: textValue(
                      t: widget.t1,
                      c: black,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                      top: 12, bottom: 12, left: 24, right: 12),
                  padding: EdgeInsets.only(right: 20),
                  child: propValueWidget(
                    widget1: textProperty(t: 'Anemia: ', c: blue),
                    widget2: textValue(t: widget.anemia, c: Colors.red),
                  ),
                ),
                Container(
                  margin:
                      EdgeInsets.only(left: 10, top: 50, bottom: 15, right: 15),
                  child: SizedBox(
                    width: 370,
                    height: 1,
                    child: const DecoratedBox(
                      decoration: const BoxDecoration(
                        color: Colors.black26,
                      ),
                    ),
                  ),
                ),
                ImageListTile(
                  imagePath: widget.imagePath!,
                  caller: "Widget3",
                  text: "Revaluate Result",
                  c: 0xff45539F,
                  onPress: widget.onPress,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}