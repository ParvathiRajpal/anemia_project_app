import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:core';

class accuracyCard extends StatefulWidget {
  double? accuracy;

  accuracyCard({required this.accuracy, Key? key}) : super(key: key);

  @override
  State<accuracyCard> createState() => _accuracyCardState();
}

class _accuracyCardState extends State<accuracyCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 7 * MediaQuery.of(context).size.width / 8,
      margin: const EdgeInsets.only(left: 22, right: 22,top: 15, bottom: 20),
      child: Card(
        elevation: 7,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Padding(
          padding:
              const EdgeInsets.only(top: 10, left: 14, right: 18, bottom: 25),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(left: 20, top: 18),
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: AssetImage('assets/images/nn.png'),
                      fit: BoxFit.fitHeight,
                    ),
                  ),
              ),
              Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 40, top: 22),
                    child: Text(
                      'Accuracy',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontFamily: 'Raleway-Regular',
                          fontSize: 22,
                          letterSpacing: 1,
                          fontWeight: FontWeight.normal,
                          color: Colors.black87,
                          height: 1),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 40, top: 25),
                    child: Text(
                      widget.accuracy!=null?'${widget.accuracy} %':'',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 22,
                          letterSpacing: 1,
                          fontWeight: FontWeight.normal,
                          color: Colors.black87,
                          height: 1),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
