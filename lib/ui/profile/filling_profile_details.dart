import 'dart:typed_data';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import '../../constants/colors.dart';
import '../../constants/utils.dart';
import '../../services/user_model.dart';

class FillProfilePage extends StatefulWidget {
  FillProfilePage({Key? key}) : super(key: key);

  @override
  State<FillProfilePage> createState() => _FillProfilePageState();
}

class _FillProfilePageState extends State<FillProfilePage> {
  final formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cnicController = TextEditingController();
  //Address
  final _sectorController = TextEditingController();
  final _phaseController = TextEditingController();
  final _streetController = TextEditingController();
  final _houseNoController = TextEditingController();

  Uint8List? _image;

  void selectImage() async {
    Uint8List? img = await pickImage(ImageSource.gallery);
    if (img != null) {
      setState(() {
        _image = img;
      });
    }
  }

  void saveProfile() async {

    if (_image != null &&
        _fullNameController.text.isNotEmpty &&
        _phoneController.text.isNotEmpty &&
        _cnicController.text.isNotEmpty &&
        _sectorController.text.isNotEmpty &&
        _phaseController.text.isNotEmpty &&
        _streetController.text.isNotEmpty &&
        _houseNoController.text.isNotEmpty) {
      if( _phoneController.text.length != 11 || _cnicController.text.length != 13){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Please enter valid phone number and cnic',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
      else if(_phaseController.text.isEmpty && _streetController.text.isEmpty && _houseNoController.text.isEmpty){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Please enter complete address',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
      else{
        showDialog(
          context: context,
          barrierDismissible: false, // Prevent dialog from closing on outside tap
          builder: (context) {
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        );
        print('inside fill profile');
        String resp = await StoreData().saveUserProfileData(
          name: _fullNameController.text,
          phone: _phoneController.text,
          cnic: _cnicController.text,
          file: _image!,
          sector: _sectorController.text,
          phase: _phaseController.text,
          street: _streetController.text,
          houseNo: _houseNoController.text,
        ).whenComplete(() {
          tokenSetNew(FirebaseAuth.instance.currentUser!.uid.toString());
          Navigator.of(context).pop(); // Dismiss the dialog
          final snackBar = SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: 'Success!',
              message: 'Details saved successfully!',
              contentType: ContentType.success,
            ),
          );
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(snackBar);
          //Navigator.of(context).pop();
          Navigator.pushNamedAndRemoveUntil(context, '/home',(route) => false);
        });
      }

    } else {
      // Show snackbar to ensure user selects image and enters all details
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please select an image and enter all details.',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  tokenSetNew(String userId) {
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    _firebaseMessaging.subscribeToTopic('user');
    _firebaseMessaging.getToken().then((value) {
      CollectionReference users =
      FirebaseFirestore.instance.collection('userProfile');

      users
          .doc(userId)
          .update({'token': value.toString()})
          .then((value) => print("User Updated"))
          .catchError((error) => print("Failed to update user: $error"));
    }).onError((error, stackTrace) {
      print(error);
      /// add snackbar
      //CustomAlertDialogs.showFailuresDailog(context,error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                'Enter your details below:',
                style: TextStyle(
                  fontFamily: 'Montserrat Medium',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: kTextColor,
                ),
              ),
              Stack(
                children: [
                  CircleAvatar(
                    radius: MediaQuery.of(context).size.height * 0.08,
                    backgroundImage: _image != null
                        ? MemoryImage(_image!)
                        : AssetImage('lib/assets/images/avatar.png') as ImageProvider<Object>?,

                  ),
                  Positioned(
                    child: IconButton(
                      onPressed: selectImage,
                      icon: Icon(Icons.camera_alt),
                    ),
                    bottom: 0,
                    right: 0,
                  )
                ],
              ),
              SizedBox(height: 50),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    customTextField(
                      "Name",
                      _fullNameController,
                      prefixIcon: Icon(Icons.person),
                    ),
                    SizedBox(height: 20),
                    customTextField(
                      "Cnic",
                      _cnicController,
                      prefixIcon: Icon(Icons.document_scanner_rounded),
                    ),
                    SizedBox(height: 20),
                    customTextField(
                      "Phone",
                      _phoneController,
                      prefixIcon: Icon(Icons.phone),
                    ),
                    SizedBox(height: 20),
                    customTextField(
                      "Sector",
                      _sectorController,
                      prefixIcon: Icon(Icons.person),
                    ),
                    SizedBox(height: 20),
                    customTextField(
                      "Phase",
                      _phaseController,
                      prefixIcon: Icon(Icons.person),
                    ),
                    SizedBox(height: 20),
                    customTextField(
                      "Street No",
                      _streetController,
                      prefixIcon: Icon(Icons.person),
                    ),
                    SizedBox(height: 20),
                    customTextField(
                      "House No",
                      _houseNoController,
                      prefixIcon: Icon(Icons.person),
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.07,
                      child: ElevatedButton(
                        onPressed: saveProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryColor,
                          side: BorderSide.none,
                          shape: const StadiumBorder(),
                        ),
                        child: Text(
                          'Save',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget customTextField(String title, TextEditingController controller,
      {Icon? prefixIcon}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: title,
        labelStyle: TextStyle(
          fontFamily: 'Circular',
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: kTextColor,
        ),
        prefixIcon: prefixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 2, color: kPrimaryColor),
        ),
      ),
      keyboardType: title == "Cnic" || title == "Phone" ? TextInputType.number : TextInputType.text, // Numeric keyboard for CNIC and phone
      inputFormatters: title == "Cnic" || title == "Phone"
          ? [
        FilteringTextInputFormatter.digitsOnly, // Allow only numeric input
        LengthLimitingTextInputFormatter(
            title == "Cnic" ? 13 : 11), // Limit input to 13 characters for CNIC and 11 characters for phone
      ]
          : null, // For other fields, allow any input
      validator: (value) {
        if (value!.isEmpty) {
          return 'Field is Empty';
        }
        // Perform length validation for CNIC and phone
        if (title == "Cnic" && value.length != 13) {
          return 'CNIC must be 13 digits long';
        }
        if (title == "Phone" && value.length != 11) {
          return 'Phone number must be 11 digits long';
        }
        return null;
      },
    );
  }


}
