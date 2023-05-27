import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_ml_vision/google_ml_vision.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

class OCRScreen extends StatefulWidget {
  const OCRScreen({Key? key}) : super(key: key);

  @override
  State<OCRScreen> createState() => _OCRScreenState();
}

class _OCRScreenState extends State<OCRScreen> {
  bool isimageSelected = false;
  bool textScanning = false;
  XFile? imageFile;
  String scannedText = '';

  void getImage() async {
    try{
      final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
      if(pickedImage != null){
        textScanning = true;
        imageFile = pickedImage;
        isimageSelected = true;
        setState(() {
          getRecognisedText(pickedImage);
        });
      }
    }catch (e){
      textScanning = false;
      imageFile = null;
      setState(() {

      });
      scannedText = "Error occurred while after loading image form gallery.";
    }
  }

  void getRecognisedText(XFile image) async{
    //final inputImage = InputImage.fromFilePath(image.path);
    //final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    //final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
    final GoogleVisionImage visionImage = GoogleVisionImage.fromFilePath(imageFile!.path);
    final TextRecognizer textRecognizer = GoogleVision.instance.textRecognizer();
    final VisionText visionText = await textRecognizer.processImage(visionImage);
    textRecognizer.close();
    scannedText = "";
    for(TextBlock block in visionText.blocks) {
      for(TextLine line in block.lines) {
        scannedText = '$scannedText${line.text}\n';
      }
    }
    textScanning = false;
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.15),
              if(textScanning == true)... [
                const LinearProgressIndicator(),
              ]else...[
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: isimageSelected == true ? ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child:  Image.file(File(imageFile!.path))
                  ) : Lottie.network('https://assets3.lottiefiles.com/packages/lf20_GxMZME.json'),
                ),
              ],

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  height: 80,
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () {
                            getImage();
                          },
                          child: const Icon(
                              Icons.image_rounded,
                            color: Colors.grey,
                            size: 28,
                          ),
                        ),
                        const Icon(
                            Icons.photo_camera_rounded,
                          color: Colors.grey,
                          size: 28,
                        )
                      ],
                    ),
                  ),
                ),
              ),

              Text(
                scannedText
              )
            ],
          ),
        ),
      ),
    );

  }
}
