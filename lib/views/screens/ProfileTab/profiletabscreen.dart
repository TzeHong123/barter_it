import 'dart:math';
import 'dart:convert';
import 'dart:io';
//import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:barter_it/myconfig.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:barter_it/models/user.dart';
import 'package:barter_it/views/screens/loginscreen.dart';
import 'package:barter_it/views/screens/registrationscreen.dart';
import 'package:barter_it/views/screens/ProfileTab/CreditScreen.dart';
import 'package:intl/intl.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

// for profile screen

class ProfileTabScreen extends StatefulWidget {
  final User user;

  const ProfileTabScreen({super.key, required this.user});

  @override
  State<ProfileTabScreen> createState() => _ProfileTabScreenState();
}

class _ProfileTabScreenState extends State<ProfileTabScreen> {
  late List<Widget> tabchildren;
  String maintitle = "Profile";
  late double screenHeight, screenWidth, cardWidth;
  File? _image;
  var pathAsset = "assets/images/profile.png";
  final df = DateFormat('dd/MM/yyyy');
  //var val = 50;
  bool isDisable = false;
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _phoneCtrl = TextEditingController();
  final TextEditingController _oldPassCtrl = TextEditingController();
  final TextEditingController _newPassCtrl = TextEditingController();
  Random random = Random();
  int val = -1;
  List<String> creditType = ["1", "5", "10", "50", "25", "50", "100", "1000"];

  @override
  void initState() {
    super.initState();
    if (widget.user.id == "na") {
      isDisable = true;
    } else {
      isDisable = false;
    }

    _nameCtrl.text = widget.user.name.toString();
    _phoneCtrl.text = widget.user.phone.toString();
    print("Profile");
  }

  @override
  void dispose() {
    super.dispose();
    print("dispose");
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      cardWidth = screenWidth;
    } else {
      cardWidth = screenWidth * 0.75;
    }

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(title: const Text("Profile")),
        body: Column(children: [
          Padding(
              padding: const EdgeInsets.all(4.0),
              child: Card(
                child: SizedBox(
                  height: screenHeight * 0.25,
                  child: Row(
                    children: [
                      Flexible(
                        flex: 4,
                        child: SizedBox(
                            height: screenHeight * 0.20,
                            child: GestureDetector(
                              onTap: isDisable ? null : _updateImageDialog,
                              child: Container(
                                width: screenWidth,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: _image == null
                                        ? AssetImage(pathAsset)
                                        : FileImage(_image!) as ImageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              //  child: CachedNetworkImage(
                              //     imageUrl:
                              //         "${MyConfig().SERVER}/barter_it/assets/profile/${widget.user.id}.png?v=$val",
                              //     placeholder: (context, url) =>
                              //         const LinearProgressIndicator(),
                              //     errorWidget: (context, url, error) =>
                              //         Image.network(
                              //           "${MyConfig().SERVER}/barter_it/assets/profile/0.png",
                              //           scale: 2,
                              //         )),
                            )),
                      ),
                      // "${MyConfig().SERVER}/barter_it/images/profiles/${widget.user.id}.png",
                      //"${MyConfig().SERVER}/barter_it/assets/profiles/${widget.user.id}.png?v=$val",
                      Flexible(
                          flex: 6,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(widget.user.name.toString(),
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              const Padding(
                                padding: EdgeInsets.fromLTRB(0, 2, 0, 8),
                                child: Divider(
                                  color: Colors.blueGrey,
                                  height: 2,
                                  thickness: 2.0,
                                ),
                              ),
                              Table(
                                columnWidths: const {
                                  0: FractionColumnWidth(0.3),
                                  1: FractionColumnWidth(0.7)
                                },
                                defaultVerticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                children: [
                                  TableRow(children: [
                                    const Icon(Icons.email),
                                    Text(widget.user.email.toString()),
                                  ]),
                                  TableRow(children: [
                                    const Icon(Icons.phone),
                                    Text(widget.user.phone.toString()),
                                  ]),
                                  TableRow(children: [
                                    const Icon(Icons.currency_exchange),
                                    Text("${widget.user.credit} Credits"),
                                  ]),
                                  TableRow(children: [
                                    const Icon(Icons.date_range),
                                    Text(df.format(DateTime.parse(
                                        widget.user.datereg.toString()))),
                                  ]),
                                  // widget.user.datereg.toString() == ""
                                  //     ? TableRow(children: [
                                  //         const Icon(Icons.date_range),
                                  //         Text(df.format(DateTime.parse(
                                  //             widget.user.datereg.toString())))
                                  //       ])
                                  //     : TableRow(children: [
                                  //         const Icon(Icons.date_range),
                                  //         Text(df.format(DateTime.now()))
                                  //       ]),
                                ],
                              ),
                            ],
                          ))
                    ],
                  ),
                ),
              )),
          Flexible(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 5, 10, 5),
                child: Column(
                  children: [
                    Container(
                      width: screenWidth,
                      alignment: Alignment.center,
                      color: Theme.of(context).backgroundColor,
                      child: const Padding(
                        padding: EdgeInsets.fromLTRB(0, 2, 0, 2),
                        child: Text("PROFILE SETTINGS",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                    ),
                    Expanded(
                        child: ListView(
                            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                            shrinkWrap: true,
                            children: [
                          MaterialButton(
                            onPressed: isDisable ? null : buyCreditPage,
                            child: const Text("BUY CREDIT"),
                          ),
                          MaterialButton(
                            onPressed: isDisable ? null : _updateNameDialog,
                            child: const Text("EDIT NAME"),
                          ),
                          const Divider(
                            height: 2,
                          ),
                          MaterialButton(
                            onPressed: isDisable ? null : _updatePhoneDialog,
                            child: const Text("EDIT PHONE NUMBER"),
                          ),
                          MaterialButton(
                            onPressed: isDisable ? null : _changePassDialog,
                            child: const Text("CHANGE PASSWORD"),
                          ),
                          const Divider(
                            height: 2,
                          ),
                          MaterialButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (content) =>
                                          const RegistrationScreen()));
                            },
                            child: const Text("REGISTRATION"),
                          ),
                          const Divider(
                            height: 2,
                          ),
                          MaterialButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (content) =>
                                          const LoginScreen()));
                            },
                            child: const Text("LOGIN"),
                          ),
                          const Divider(
                            height: 2,
                          ),
                          const Divider(
                            height: 2,
                          ),
                          MaterialButton(
                            onPressed: isDisable ? null : _logoutDialog,
                            child: const Text("LOGOUT"),
                          ),
                        ])),
                  ],
                ),
              )),
        ]),
      ),
    );
  }

//                           onPressed: () {
//                                 Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                         builder: (content) =>
//                                             const RegistrationScreen()));
//                               },
//                               child: const Text("REGISTRATION"),

  Future<void> buyCreditPage() async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => CreditScreen(
                  user: widget.user,
                )));
    _loadNewCredit();
  }

  void _loadNewCredit() {
    http.post(Uri.parse("${MyConfig().SERVER}/barter_it/php/load_user.php"),
        body: {"userid": widget.user.id}).then((response) {
      var jsonResponse = json.decode(response.body);
      if (response.statusCode == 200 && jsonResponse['status'] == "success") {
        final jsonResponse = json.decode(response.body);
        //print(response.body);
        User newuser = User.fromJson(jsonResponse['data']);
        widget.user.credit = newuser.credit;
        setState(() {});
      }
    });
  }

  _updateImageDialog() {
    if (widget.user.id == "na") {
      Fluttertoast.showToast(
          msg: "Please login/register your account first",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 16.0);
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
            title: const Text(
              "Select from",
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton.icon(
                    onPressed: () => {
                          Navigator.of(context).pop(),
                          _galleryPicker(),
                        },
                    icon: const Icon(Icons.browse_gallery),
                    label: const Text("Gallery")),
                TextButton.icon(
                    onPressed: () =>
                        {Navigator.of(context).pop(), _cameraPicker()},
                    icon: const Icon(Icons.camera_alt),
                    label: const Text("Camera")),
              ],
            ));
      },
    );
  }

  _galleryPicker() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 800,
      maxWidth: 800,
    );
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      cropImage();
    }
  }

  _cameraPicker() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 800,
      maxWidth: 800,
    );
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      cropImage();
    }
  }

  Future<void> cropImage() async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: _image!.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );
    if (croppedFile != null) {
      File imageFile = File(croppedFile.path);
      _image = imageFile;
      _updateProfileImage(_image);
    }
  }

  void _updateProfileImage(image) {
    String base64Image = base64Encode(image!.readAsBytesSync());
    http.post(
        Uri.parse("${MyConfig().SERVER}/barter_it/php/update_profile.php"),
        body: {
          "userid": widget.user.id,
          "image": base64Image,
        }).then((response) {
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
        val = random.nextInt(1000);
        setState(() {});
        DefaultCacheManager manager = DefaultCacheManager();
        manager.emptyCache(); //clears all data in cache.
      } else {
        Fluttertoast.showToast(
            msg: "Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
      }
    });
  }

  void _updateNameDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Do you wish to change your name?",
            style: TextStyle(),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameCtrl,
                decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your new name';
                  }
                  return null;
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                String newname = _nameCtrl.text;
                _updateName(newname);
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _updateName(String newname) {
    http.post(
        Uri.parse("${MyConfig().SERVER}/barter_it/php/update_profile.php"),
        body: {
          "userid": widget.user.id,
          "newname": newname,
        }).then((response) {
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        Fluttertoast.showToast(
            msg: "Name updated succesfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
        setState(() {
          widget.user.name = newname;
        });
      } else {
        Fluttertoast.showToast(
            msg: "Failed to update name",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
      }
    });
  }

  void _updatePhoneDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Change Phone?",
            style: TextStyle(),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _phoneCtrl,
                keyboardType: const TextInputType.numberWithOptions(),
                decoration: InputDecoration(
                    labelText: 'Phone',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter new your phone';
                  }
                  return null;
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                String newphone = _phoneCtrl.text;
                _updatePhone(newphone);
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _updatePhone(String newphone) {
    http.post(
        Uri.parse("${MyConfig().SERVER}/barter_it/php/update_profile.php"),
        body: {
          "userid": widget.user.id,
          "newphone": newphone,
        }).then((response) {
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        Fluttertoast.showToast(
            msg: "Phone number updated",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
        setState(() {
          widget.user.phone = newphone;
        });
      } else {
        Fluttertoast.showToast(
            msg: "Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
      }
    });
  }

  void _changePassDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Change Password?",
            style: TextStyle(),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _oldPassCtrl,
                obscureText: true,
                decoration: InputDecoration(
                    labelText: 'Old Password',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              ),
              const SizedBox(height: 5),
              TextFormField(
                controller: _newPassCtrl,
                obscureText: true,
                decoration: InputDecoration(
                    labelText: 'New Password',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                changePass();
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void changePass() {
    http.post(
        Uri.parse("${MyConfig().SERVER}/barter_it/php/update_profile.php"),
        body: {
          "userid": widget.user.id,
          "oldpass": _oldPassCtrl.text,
          "newpass": _newPassCtrl.text,
        }).then((response) {
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        Fluttertoast.showToast(
            msg: "Password changed succesfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
        setState(() {});
      } else {
        Fluttertoast.showToast(
            msg: "Failed to change password",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
      }
    });
  }

  void _logoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Logout?",
            style: TextStyle(),
          ),
          content: const Text("Are your sure?"),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                // SharedPreferences prefs = await SharedPreferences.getInstance();
                // await prefs.setString('email', '');
                // await prefs.setString('pass', '');
                // await prefs.setBool('remember', false);
                // User user = User(
                //     id: "0",
                //     email: "unregistered@email.com",
                //     name: "unregistered",
                //     address: "na",
                //     phone: "0123456789",
                //     regdate: "0",
                //     credit: '0');
                // ignore: use_build_context_synchronously
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (content) => const LoginScreen()));
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
