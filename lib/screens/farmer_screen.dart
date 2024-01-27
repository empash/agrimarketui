import 'dart:convert';
import 'dart:io';

import 'package:agrimarket/constants/consts.dart';
import 'package:agrimarket/screens/farmer_dashboard.dart';
import 'package:agrimarket/screens/farmer_marketplace.dart';
import 'package:agrimarket/screens/farmer_subsidy.dart';
import 'package:agrimarket/screens/service_book.dart';
import 'package:agrimarket/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart' as html;

class FarmerScreen extends StatefulWidget {
  const FarmerScreen({Key? key}) : super(key: key);

  @override
  State<FarmerScreen> createState() => _FarmerScreenState();
}

class _FarmerScreenState extends State<FarmerScreen> {
  int _activeIndex = 0;

  bool isFetching = false;

  void _toggleFetching(bool value) {
    setState(() {
      isFetching = value;
    });
  }

  void _onItemTapped(int value) {
    setState(() {
      _activeIndex = value;
    });
  }

  final List _widgetList = [
    {'widget': const FarmerDashboard(), 'title': 'dasbhoard'},
    {'widget': const ServiceBook(), 'title': 'Services'},
    {'widget': const FarmerMarketplace(), 'title': 'Market'},
    {'widget': const FarmerSubsidy(), 'title': 'Subsidy'},
  ];

  void uploadImage(File imageFile) async {
    _toggleFetching(true);
    var url = Uri.https(Constants.rootUrl, '/file/upload');

    // Open the image file
    List<int> imageBytes = await imageFile.readAsBytes();

    // Create a multipart request
    var request = http.MultipartRequest('POST', url);

    // Attach the image file to the request
    request.files.add(http.MultipartFile.fromBytes(
      'image',
      imageBytes,
      filename: 'image.jpg', // You can change the filename if needed
    ));

    // Send the request
    try {
      http.Response response =
          await http.Response.fromStream(await request.send());

      var result = jsonDecode(response.body);

      // Handle the response
      if (response.statusCode == 200) {
        _showResponseDialog('Image uploaded successfully', result['message']);
      } else {
        _showResponseDialog('Image Scan Results', result['message']);
      }
    } catch (e) {
      _showResponseDialog('Error uploading image: $e', '');
    } finally {
      _toggleFetching(false);
    }
  }

  void _showResponseDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: html.HtmlWidget(content),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _activeIndex == 0
          ? null
          : AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => _onItemTapped(0),
              ),
              surfaceTintColor: Colors.transparent,
              title: Text(Utils.capitalize(_widgetList[_activeIndex]['title'])),
            ),
      body: SafeArea(
          child: Stack(
        children: [
          _widgetList[_activeIndex]['widget'],
          Visibility(
            visible: isFetching,
            child: Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        ],
      )),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.category), label: 'Services'),
          BottomNavigationBarItem(icon: Icon(Icons.shop), label: 'Marketplace'),
          BottomNavigationBarItem(
              icon: Icon(Icons.pix_rounded), label: 'Subsidy'),
        ],
        currentIndex: _activeIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.lightBlue,
        unselectedItemColor: Colors.grey,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return SizedBox(
                  height: 150,
                  child: Column(
                    children: [
                      ListTile(
                        onTap: () async {
                          // scan image
                          final ImagePicker picker = ImagePicker();
                          final XFile? photo = await picker.pickImage(
                              source: ImageSource.camera);
                          if (photo != null) {
                            File imageFile = File(photo.path);
                            if (context.mounted) Navigator.of(context).pop();
                            uploadImage(imageFile);
                          }
                        },
                        leading: const Icon(Icons.search),
                        title: const Text('Take Image'),
                      ),
                      ListTile(
                        onTap: () async {
                          // upload image
                          final ImagePicker picker = ImagePicker();
                          final XFile? image = await picker.pickImage(
                              source: ImageSource.gallery);
                          if (image != null) {
                            File imageFile = File(image.path);
                            if (context.mounted) Navigator.of(context).pop();
                            uploadImage(imageFile);
                          }
                        },
                        leading: const Icon(Icons.upload),
                        title: const Text('From Gallery'),
                      ),
                    ],
                  ),
                );
              });
        },
        child: const Icon(
          Icons.cloud_upload_rounded,
          color: Colors.lightBlue,
          size: 40,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
