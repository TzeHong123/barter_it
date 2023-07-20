import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:barter_it/models/user.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:http/http.dart' as http;
import 'package:barter_it/myconfig.dart';
import 'package:carousel_slider/carousel_slider.dart';
//import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class AddNewItemscreen extends StatefulWidget {
  final User user;

  const AddNewItemscreen({super.key, required this.user});

  @override
  State<AddNewItemscreen> createState() => _AddNewItemscreenState();
}

class ImageConfig {
  String source;
  String path;

  ImageConfig({required this.source, required this.path});
}

class _AddNewItemscreenState extends State<AddNewItemscreen> {
  File? _image;

  final _formKey = GlobalKey<FormState>();
  late double screenHeight, screenWidth, cardwitdh;
  final TextEditingController _itemnameEditingController =
      TextEditingController();
  final TextEditingController _itemdescEditingController =
      TextEditingController();
  //final TextEditingController _itempriceEditingController =
  //    TextEditingController();
  final TextEditingController _itemqtyEditingController =
      TextEditingController();
  final TextEditingController _prstateEditingController =
      TextEditingController();
  final TextEditingController _prlocalEditingController =
      TextEditingController();
  String selectedType = "Type";
  List<String> itemlist = [
    "Type",
    "Clothes",
    "Toys",
    "Electrical appliances",
    "Kitchen utensils",
    "Smartphone",
    "Tablet",
    "Laptop",
    "Other",
  ];

  List<File?> inputImages = [null, null, null];
  List<String> pathAssets = [
    "assets/images/TakePicture.png",
    "assets/images/TakePicture.png",
    "assets/images/TakePicture.png",
  ];
  final CarouselController carouselController = CarouselController();
  int currentIndex = 0;

  late Position _currentPosition;
  String curaddress = "";
  String curstate = "";
  String prlat = "";
  String prlong = "";
  int activeIndex = 0;

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Add New Item",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
              //fontStyle: FontStyle.italic,
            ),
            strutStyle: StrutStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  _determinePosition();
                },
                icon: const Icon(Icons.refresh))
          ]),
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Flexible(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
              child: Card(
                child: ListView(
                  children: [
                    Stack(children: [
                      CarouselSlider(
                        options: CarouselOptions(
                          scrollPhysics: const BouncingScrollPhysics(),
                          autoPlay: true,
                          viewportFraction: 1.0,
                          onPageChanged: (index, reason) {
                            setState(() {
                              currentIndex = index;
                            });
                          },
                        ),
                        carouselController: carouselController,
                        items: [
                          for (var i = 0; i < inputImages.length; i++)
                            GestureDetector(
                              onTap: () {
                                _selectFromCamera(i);
                              },
                              child: Container(
                                width: screenWidth,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: inputImages[i] == null
                                        ? AssetImage(pathAssets[i])
                                        : FileImage(inputImages[i]!)
                                            as ImageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      Positioned(
                        bottom: 10,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: inputImages.asMap().entries.map((entry) {
                            return GestureDetector(
                              onTap: () =>
                                  carouselController.animateToPage(entry.key),
                              child: Container(
                                width: currentIndex == entry.key ? 17 : 7,
                                height: 7.0,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 3.0,
                                ),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: currentIndex == entry.key
                                        ? Colors.orange
                                        : Colors.blueGrey),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ])
                  ],
                ),
              ),
            )),
        Expanded(
          flex: 6,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.type_specimen),
                        const SizedBox(
                          width: 15,
                        ),
                        SizedBox(
                          height: 60,
                          child: DropdownButton(
                            value: selectedType,
                            onChanged: (newValue) {
                              setState(() {
                                selectedType = newValue!;
                                print(selectedType);
                              });
                            },
                            items: itemlist.map((selectedType) {
                              return DropdownMenuItem(
                                value: selectedType,
                                child: Text(
                                  selectedType,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                    TextFormField(
                        textInputAction: TextInputAction.next,
                        validator: (val) => val!.isEmpty || (val.length < 3)
                            ? "Item name must be longer than 3"
                            : null,
                        onFieldSubmitted: (v) {},
                        controller: _itemnameEditingController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                            labelText: 'Item Name',
                            labelStyle: TextStyle(fontWeight: FontWeight.bold),
                            icon: Icon(Icons.abc),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 2.0),
                            ))),
                    TextFormField(
                        textInputAction: TextInputAction.next,
                        validator: (val) => val!.isEmpty
                            ? "Item description must be at least 3 words."
                            : null,
                        onFieldSubmitted: (v) {},
                        maxLines: 4,
                        controller: _itemdescEditingController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                            labelText: 'Item Description',
                            alignLabelWithHint: true,
                            labelStyle: TextStyle(fontWeight: FontWeight.bold),
                            icon: Icon(
                              Icons.description,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 2.0),
                            ))),
                    Row(
                      children: [
                        //Price is removed for now
                        /*Flexible(
                          flex: 5,
                          child: TextFormField(
                              textInputAction: TextInputAction.next,
                              validator: (val) => val!.isEmpty
                                  ? "Item price must contain value"
                                  : null,
                              onFieldSubmitted: (v) {},
                              controller: _itempriceEditingController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  labelText: 'Item Price',
                                  labelStyle: TextStyle(),
                                  icon: Icon(Icons.money),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 2.0),
                                  ))),
                        ),*/
                        Flexible(
                          flex: 5,
                          child: TextFormField(
                              textInputAction: TextInputAction.next,
                              validator: (val) => val!.isEmpty
                                  ? "Quantity must be more than 0"
                                  : null,
                              controller: _itemqtyEditingController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  labelText: 'Item Quantity',
                                  labelStyle:
                                      TextStyle(fontWeight: FontWeight.bold),
                                  icon: Icon(Icons.numbers),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 2.0),
                                  ))),
                        ),
                      ],
                    ),
                    Row(children: [
                      Flexible(
                        flex: 5,
                        child: TextFormField(
                            textInputAction: TextInputAction.next,
                            validator: (val) => val!.isEmpty || (val.length < 3)
                                ? "Current State"
                                : null,
                            enabled: false,
                            controller: _prstateEditingController,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                                labelText: 'Current State',
                                labelStyle:
                                    TextStyle(fontWeight: FontWeight.bold),
                                icon: Icon(Icons.flag),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 2.0),
                                ))),
                      ),
                      Flexible(
                        flex: 5,
                        child: TextFormField(
                            textInputAction: TextInputAction.next,
                            enabled: false,
                            validator: (val) => val!.isEmpty || (val.length < 3)
                                ? "Current Locality"
                                : null,
                            controller: _prlocalEditingController,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                                labelText: 'Current Locality',
                                labelStyle:
                                    TextStyle(fontWeight: FontWeight.bold),
                                icon: Icon(Icons.map),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 2.0),
                                ))),
                      ),
                    ]),
                    const SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                      width: screenWidth / 1.2,
                      height: 50,
                      child: ElevatedButton(
                          onPressed: () {
                            insertDialog();
                          },
                          child: const Text("Insert Item")),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }

  List<String> imagesToBase64() {
    List<String> base64Images = [];

    for (var i = 0; i < inputImages.length; i++) {
      final image = inputImages[i];
      if (image != null) {
        List<int> imageBytes = File(image.path).readAsBytesSync();
        String base64Image = base64Encode(imageBytes);
        base64Images.add(base64Image);
      }
    }

    return base64Images;
  }

  Future<void> _selectFromCamera(int i) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 1200,
      maxWidth: 800,
    );

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      cropImage(i);
    } else {
      print('No image selected.');
    }
  }

  Future<void> cropImage(int i) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: _image!.path,
      aspectRatioPresets: [
        // CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        //CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.ratio3x2,
            lockAspectRatio: true),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );
    if (croppedFile != null) {
      File imageFile = File(croppedFile.path);
      _image = imageFile;
      // for (var i = 0; i < imgList.length; i++) {
      //   if (imgList[i] == ImageConfig(source: "ImageFile", path: image1path)) {
      //     imgList[i] = (ImageConfig(source: "File", path: croppedFile.path));
      //   }
      //   if (imgList[i] == ImageConfig(source: "ImageFile", path: image2path)) {
      //     imgList[i] = (ImageConfig(source: "File", path: croppedFile.path));
      //   }
      //   if (imgList[i] == ImageConfig(source: "ImageFile", path: image3path)) {
      //     imgList[i] = (ImageConfig(source: "File", path: croppedFile.path));
      //   }
      // }

      //Code to see image size
      //int? sizeInBytes = _image?.lengthSync();
      //double sizeInMb = sizeInBytes! / (1024 * 1024);
      //print(sizeInMb);

      setState(() {
        inputImages[i] = _image;
        //imgList[1]= (ImageConfig(source: "file", path: croppedFile.path));
      });
    }
  }

  void insertDialog() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Check your input")));
      return;
    }
    if (_image == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Please take picture")));
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: const Text(
            "Insert your item?",
            style: TextStyle(),
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                insertItem();
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

  void insertItem() {
    String itemname = _itemnameEditingController.text;
    String itemdesc = _itemdescEditingController.text;
    //String itemprice = _itempriceEditingController.text;
    String itemqty = _itemqtyEditingController.text;
    String state = _prstateEditingController.text;
    String locality = _prlocalEditingController.text;
    //String base64Image = base64Encode(_image!.readAsBytesSync());
    List<String> base64Images = imagesToBase64();

    http.post(Uri.parse("${MyConfig().SERVER}/barter_it/php/insert_item.php"),
        body: {
          "userid": widget.user.id.toString(),
          "itemname": itemname,
          "itemdesc": itemdesc,
          "type": selectedType,
          //"itemprice": itemprice,
          "itemqty": itemqty,
          "latitude": prlat,
          "longitude": prlong,
          "state": state,
          "locality": locality,
          // ignore: prefer_is_empty
          "image1": base64Images.length >= 1 ? base64Images[0] : '',
          "image2": base64Images.length >= 2 ? base64Images[1] : '',
          "image3": base64Images.length >= 3 ? base64Images[2] : '',
        }).then((response) {
      print(response.body);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Insert Success")));
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Insert Failed")));
        }
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Insert Failed")));
        Navigator.pop(context);
      }
    });
  }

  void _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }
    _currentPosition = await Geolocator.getCurrentPosition();

    _getAddress(_currentPosition);
  }

  _getAddress(Position pos) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(pos.latitude, pos.longitude);
    if (placemarks.isEmpty) {
      _prlocalEditingController.text = "Ipoh";
      _prstateEditingController.text = "Perak";
      prlat = "4.597479";
      prlong = "101.090106";
      setState(() {});
    } else {
      _prlocalEditingController.text = placemarks[0].locality.toString();
      _prstateEditingController.text =
          placemarks[0].administrativeArea.toString();
      prlat = _currentPosition.latitude.toString();
      prlong = _currentPosition.longitude.toString();
      setState(() {});
    }
    //setState(() {});
  }

  // Widget buildImage(String displayImage, int index) => Container(
  //     width: double.infinity,
  //     // margin: const EdgeInsets.symmetric(horizontal: 5),
  //     decoration: BoxDecoration(
  //         color: Color.fromARGB(255, 235, 220, 238),
  //         //border: Border.all(width: 1),
  //         image: DecorationImage(
  //           image: _image == null
  //               ? AssetImage(pathAsset)
  //               : FileImage(_image!) as ImageProvider,
  //           fit: BoxFit.contain,
  //         )));

  // Widget buildIndicator() => AnimatedSmoothIndicator(
  //       activeIndex: activeIndex,
  //       count: itemImages.length,
  //       effect: const ExpandingDotsEffect(
  //           dotHeight: 10, dotWidth: 10, activeDotColor: Colors.deepOrange),
  //     );
}
