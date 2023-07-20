import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:barter_it/models/record.dart';
import 'package:barter_it/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:barter_it/myconfig.dart';

import 'RecordDetailsScreen.dart';

class BarterRecordScreen extends StatefulWidget {
  final User user;
  const BarterRecordScreen({super.key, required this.user});

  @override
  State<BarterRecordScreen> createState() => _BarterRecordScreenState();
}

class _BarterRecordScreenState extends State<BarterRecordScreen> {
  late double screenHeight, screenWidth, cardwitdh;

  String status = "Loading...";
  List<Record> recordList = <Record>[];
  @override
  void initState() {
    super.initState();
    loadtraderrecords();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: const Text("Your Record")),
      body: Container(
        child: recordList.isEmpty
            ? Container()
            : Column(
                children: [
                  SizedBox(
                    width: screenWidth,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
                      child: Row(
                        children: [
                          Flexible(
                              flex: 7,
                              child: Row(
                                children: [
                                  const CircleAvatar(
                                    backgroundImage: AssetImage(
                                      "assets/images/profile.png",
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    "Hello ${widget.user.name}!",
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              )),
                          Expanded(
                            flex: 3,
                            child: Row(children: [
                              IconButton(
                                icon: const Icon(Icons.notifications),
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: const Icon(Icons.search),
                                onPressed: () {},
                              ),
                            ]),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Text(
                    "Your Current Record",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                      child: ListView.builder(
                          itemCount: recordList.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              onTap: () async {
                                if (recordList[index].recordStatus !=
                                    "pending") {
                                  Record tradeRecord = Record.fromJson(
                                      recordList[index].toJson());
                                  await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (content) =>
                                              RecordDetailsScreen(
                                                record: tradeRecord,
                                              )));
                                  loadtraderrecords();
                                } else {
                                  Fluttertoast.showToast(
                                      msg:
                                          "Please wait for Owner's Confirmation",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      fontSize: 16.0);
                                }
                              },
                              leading: CircleAvatar(
                                  child: Text((index + 1).toString())),
                              title: Text(
                                  "Record ID: ${recordList[index].recordId}"),
                              trailing: const Icon(Icons.arrow_forward),
                              subtitle: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            "Status: ${recordList[index].recordStatus}")
                                      ]),
                                  // Column(
                                  //   children: [
                                  //     Text(
                                  //       "RM ${double.parse(recordList[index].orderPaid.toString()).toStringAsFixed(2)}",
                                  //       style: const TextStyle(
                                  //           fontSize: 16,
                                  //           fontWeight: FontWeight.bold),
                                  //     ),
                                  //     const Text("")
                                  //   ],
                                  // )
                                ],
                              ),
                            );
                          })),
                ],
              ),
      ),
    );
  }

  //  Text(orderList[index].orderBill.toString()),
  //                               Text(orderList[index].orderStatus.toString()),
  //                               Text(orderList[index].orderPaid.toString()),

  void loadtraderrecords() {
    http.post(
        Uri.parse("${MyConfig().SERVER}/barter_it/php/load_traderRecord.php"),
        body: {"traderid": widget.user.id}).then((response) {
      log(response.body);
      //recordList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          recordList.clear();
          var extractdata = jsondata['data'];
          extractdata['records'].forEach((v) {
            recordList.add(Record.fromJson(v));
          });
        } else {
          status = "Please register an account first";
          setState(() {});
          Navigator.of(context).pop();
          Fluttertoast.showToast(
              msg: "No record found",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              fontSize: 16.0);
        }
        setState(() {});
      }
    });
  }
}
