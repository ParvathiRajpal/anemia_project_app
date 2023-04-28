import 'dart:collection';
import 'dart:math';
import 'dart:typed_data';
import 'package:image/image.dart';
import 'package:collection/collection.dart';
import 'package:logger/logger.dart';
import 'package:tflite_flutter_plus/tflite_flutter_plus.dart';
import 'package:tflite_flutter_helper_plus/tflite_flutter_helper_plus.dart';

abstract class Classifier {
  late Interpreter interpreter;
  late InterpreterOptions _interpreterOptions;

  late List<int> _inputShape;
  late List<int> _outputShape;

  late TensorImage _inputImage;
  late TensorBuffer _outputBuffer;

  late TfLiteType _inputType;
  late TfLiteType _outputType;

  final String _labelsFileName = './assets/labels.txt';

  final int _labelsLength = 2;

  late var _probabilityProcessor;

  late List<String> labels;

  late String predictedClass;

  String get modelName;

  NormalizeOp get preProcessNormalizeOp;
  NormalizeOp get postProcessNormalizeOp;

  Classifier({int? numThreads}) {
    _interpreterOptions = InterpreterOptions();

    if (numThreads != null) {
      _interpreterOptions.threads = numThreads;
    }

    loadModel();
    loadLabels();
  }

  Future<void> loadModel() async {
    try {
      interpreter =
      await Interpreter.fromAsset(modelName, options: _interpreterOptions);
      print('Interpreter Created Successfully');

      _inputShape = interpreter.getInputTensor(0).shape;
      // _outputShape = interpreter.getOutputTensor(0).shape;
      _inputType = interpreter.getInputTensor(0).type;
      interpreter = await Interpreter.fromAsset(modelName, options: _interpreterOptions);
      interpreter.allocateTensors();
      var outputDetails = interpreter.getOutputTensors();
      _outputShape = outputDetails[0].shape.toList();

      _outputType = interpreter.getOutputTensor(0).type;

      _outputBuffer = TensorBuffer.createFixedSize(_outputShape, _outputType);
      _probabilityProcessor =
          TensorProcessorBuilder().add(postProcessNormalizeOp).build();
    } catch (e) {
      print('Unable to create interpreter, Caught Exception: ${e.toString()}');
    }
  }

  Future<void> loadLabels() async {
    labels = await FileUtil.loadLabels(_labelsFileName);
    print("labels.length= ${labels.length}");
    print("labelsLength= ${_labelsLength}");
    print("labels ${labels.first}");
    if (labels.length == _labelsLength) {
      print('Labels loaded successfully');
    } else {
      print('Unable to load labels');
    }
  }

  TensorImage _preProcess() {
    int cropSize = 150;
    return ImageProcessorBuilder()
        .add(ResizeWithCropOrPadOp(cropSize, cropSize))
        .add(ResizeOp(
        _inputShape[1], _inputShape[2], ResizeMethod.nearestneighbour))
        .add(preProcessNormalizeOp)
        .build()
        .process(_inputImage);
  }

  Object predict(Image image) {
    final pres = DateTime.now().millisecondsSinceEpoch;
    _inputImage = TensorImage(_inputType);
    _inputImage.loadImage(image);
    _inputImage = _preProcess();
    final pre = DateTime.now().millisecondsSinceEpoch - pres;

    print('Time to load image: $pre ms');

    final runs = DateTime.now().millisecondsSinceEpoch;
    interpreter.run(_inputImage.buffer, _outputBuffer.getBuffer());
    print('Output shape: ${_outputShape}');
    print('Labels length: ${labels.length}');

    final run = DateTime.now().millisecondsSinceEpoch - runs;

    print('Time to run inference: $run ms');
    // List<dynamic> outputList = [0.2, 0.8];
    // List<double> outputDoubleList = outputList.map<double>((e) => e.toDouble()).toList();
    // Float32List outputFloatList = Float32List.fromList(outputDoubleList);

       _outputBuffer = TensorBuffer.createFixedSize([1, 2], TfLiteType.float32);
     double labeledProb = TensorLabel.fromList(
         labels, _probabilityProcessor.process(_outputBuffer))
         .getMapWithFloatValue()
         .values
         .first;

     if(labeledProb>0)
       predictedClass = labels[1];
     else
       predictedClass = labels[0];

      return Category(predictedClass, labeledProb);

  }

  void close() {
    interpreter.close();
  }
}

