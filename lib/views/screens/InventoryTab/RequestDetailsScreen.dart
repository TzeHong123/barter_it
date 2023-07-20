// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:barter_it/myconfig.dart';
import 'package:barter_it/models/recordDetails.dart';
import 'package:barter_it/models/record.dart';
import 'package:http/http.dart' as http;
import 'package:barter_it/models/user.dart';

class RequestDetailsScreen extends StatefulWidget {
  final Record record;
  final User user;
  const RequestDetailsScreen(
      {super.key, required this.user, required this.record});

  @override
  State<RequestDetailsScreen> createState() => _RequestDetailsScreenState();
}

// ignore: duplicate_ignore
class _RequestDetailsScreenState extends State<RequestDetailsScreen> {
  List<RecordDetails> recorddetailsList = <RecordDetails>[];
  late double screenHeight, screenWidth;
  String selectStatus = "Pending";
  //Set<Marker> markers = {};
  List<String> statusList = [
    "Pending",
    "Accepted",
    "Completed",
  ];
  late User user = User(
      id: "na",
      name: "na",
      email: "na",
      phone: "na",
      datereg: "na",
      password: "na",
      otp: "na");
  var pickupLatLng;
  String picuploc = "Not selected";
  //var _pickupPosition;

  @override
  void initState() {
    super.initState();
    loadtrader();
    loadrecorddetails();
    //selectStatus = widget.record.recordStatus.toString();
    // if (widget.record.recordLat.toString() == "") {
    //   picuploc = "Not selected";
    //   _pickupPosition = const CameraPosition(
    //     target: LatLng(6.4301523, 100.4287586),
    //     zoom: 12.4746,
    //   );
    // } else {
    //   picuploc = "Selected";
    //   pickupLatLng = LatLng(double.parse(widget.record.recordLat.toString()),
    //       double.parse(widget.record.recordLng.toString()));
    //   _pickupPosition = CameraPosition(
    //     target: pickupLatLng,
    //     zoom: 18.4746,
    //   );
    //   MarkerId markerId1 = const MarkerId("1");
    //   markers.clear();
    //   markers.add(Marker(
    //     markerId: markerId1,
    //     position: pickupLatLng,
    //     icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    //   ));
    // }
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: const Text("Record Details")),
      body: Column(children: [
        SizedBox(
          //flex: 3,
          height: screenHeight / 5.5,
          child: Card(
              child: Row(
            children: [
              Container(
                margin: const EdgeInsets.all(4),
                width: screenWidth * 0.3,
                child: Image.asset(
                  "assets/images/profile.png",
                ),
              ),
              Column(
                children: [
                  user.id == "na"
                      ? const Center(
                          child: Text("Loading..."),
                        )
                      : Padding(
                          padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Trader name: ${user.name}",
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              Text("Phone: ${user.phone}",
                                  style: const TextStyle(
                                    fontSize: 14,
                                  )),
                              Text("Record ID: ${widget.record.recordId}",
                                  style: const TextStyle(
                                    fontSize: 14,
                                  )),
                              // Text(
                              //   "Total Paid: ${widget.record..toString()} Credits",
                              //   style: const TextStyle(
                              //     fontSize: 14,
                              //   ),
                              // ),
                              Text("Status: ${widget.record.recordStatus}",
                                  style: const TextStyle(
                                    fontSize: 14,
                                  )),
                            ],
                          ),
                        )
                ],
              )
            ],
          )),
        ),
        Container(
            color: const Color.fromARGB(255, 231, 150, 245),
            padding: const EdgeInsets.all(8),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "Requested Item",
                  style: const TextStyle(
                      //color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ) //),
                //Text(picuploc)
              ],
            )),
        recorddetailsList.isEmpty
            ? Container()
            : Expanded(
                flex: 7,
                child: ListView.builder(
                    itemCount: recorddetailsList.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(children: [
                            CachedNetworkImage(
                              width: screenWidth / 3,
                              fit: BoxFit.cover,
                              imageUrl:
                                  "${MyConfig().SERVER}/barter_it/assets/items/${recorddetailsList[index].itemId}_Image1.png",
                              placeholder: (context, url) =>
                                  const LinearProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    recorddetailsList[index]
                                        .itemName
                                        .toString(),
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Quantity: ${recorddetailsList[index].recorddetailQty}",
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Paid: ${recorddetailsList[index].recorddetailPaid} Credits",
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            )
                          ]),
                        ),
                      );
                    })),
        SizedBox(
          // color: Colors.red,
          width: screenWidth,
          height: screenHeight * 0.1,
          child: Card(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text("Set trade status"),
                  DropdownButton(
                    itemHeight: 60,
                    value: selectStatus,
                    onChanged: (newValue) {
                      setState(() {
                        selectStatus = newValue.toString();
                      });
                    },
                    items: statusList.map((selectStatus) {
                      return DropdownMenuItem(
                        value: selectStatus,
                        child: Text(
                          selectStatus,
                        ),
                      );
                    }).toList(),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        String? phoneNo = widget.user.phone;
                        submitStatus(selectStatus, phoneNo);
                      },
                      child: const Text("Submit"))
                ]),
          ),
        )
      ]),
    );
  }

  void loadrecorddetails() {
    http.post(
        Uri.parse(
            "${MyConfig().SERVER}/barter_it/php/load_ownerRecordDetails.php"),
        body: {
          "ownerid": widget.record.ownerId,
          "recordid": widget.record.recordId,
        }).then((response) {
      log(response.body);
      //recordList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          var extractdata = jsondata['data'];
          extractdata['recorddetails'].forEach((v) {
            recorddetailsList.add(RecordDetails.fromJson(v));
          });
        } else {
          // status = "Please register an account first";
          // setState(() {});
        }
        setState(() {});
      }
    });
  }

  void loadtrader() {
    http.post(Uri.parse("${MyConfig().SERVER}/barter_it/php/load_user.php"),
        body: {
          "userid": widget.record.traderId,
        }).then((response) {
      log(response.body);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          user = User.fromJson(jsondata['data']);
        }
      }
      setState(() {});
    });
  }

  void submitStatus(String st, String? ownerPhone) {
    print(widget.record.recordId);
    http.post(
        Uri.parse("${MyConfig().SERVER}/barter_it/php/set_recordstatus.php"),
        body: {
          "recordid": widget.record.recordId,
          "status": st,
          "owner_phone": ownerPhone
        }).then((response) {
      log(response.body);
      //recordList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
        } else {}
        widget.record.recordStatus = st;
        selectStatus = st;
        setState(() {});
        Fluttertoast.showToast(
            msg: "Request Status Updated",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
      }
    });
  }

  // void loadMapDialog() {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return StatefulBuilder(
  //         builder: (context, setState) {
  //           return AlertDialog(
  //             title: const Text("Select your pickup location"),
  //             content: GoogleMap(
  //               mapType: MapType.normal,
  //               initialCameraPosition: _pickupPosition,
  //               markers: markers.toSet(),
  //             ),
  //             actions: <Widget>[
  //               TextButton(
  //                 onPressed: () => Navigator.pop(context),
  //                 child: const Text("Cancel"),
  //               ),
  //               TextButton(
  //                 onPressed: () {
  //                   if (pickupLatLng == null) {
  //                     Fluttertoast.showToast(
  //                         msg: "Please select pickup location from map",
  //                         toastLength: Toast.LENGTH_SHORT,
  //                         gravity: ToastGravity.CENTER,
  //                         timeInSecForIosWeb: 1,
  //                         fontSize: 16.0);
  //                     return;
  //                   } else {
  //                     Navigator.pop(context);
  //                     picuploc = "Selected";
  //                   }
  //                 },
  //                 child: const Text("Select"),
  //               ),
  //             ],
  //           );
  //         },
  //       );
  //     },
  //   ).then((val) {
  //     setState(() {});
  //   });
  // }
}
