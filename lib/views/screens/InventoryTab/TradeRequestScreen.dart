import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:barter_it/models/record.dart';
import 'package:barter_it/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:barter_it/myconfig.dart';

import 'RequestDetailsScreen.dart';

class TradeRequestScreen extends StatefulWidget {
  final User user;
  const TradeRequestScreen({super.key, required this.user});

  @override
  State<TradeRequestScreen> createState() => _TradeRequestScreenState();
}

class _TradeRequestScreenState extends State<TradeRequestScreen> {
  late double screenHeight, screenWidth, cardwitdh;

  String status = "Loading...";
  List<Record> recordList = <Record>[];
  @override
  void initState() {
    super.initState();
    loadownerrecords();
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
                                    "Hello, ${widget.user.name}!",
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
                                Record tradeRecord =
                                    Record.fromJson(recordList[index].toJson());
                                await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (content) =>
                                            RequestDetailsScreen(
                                              user: widget.user,
                                              record: tradeRecord,
                                            )));
                                loadownerrecords();
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

  void loadownerrecords() {
    http.post(
        Uri.parse("${MyConfig().SERVER}/barter_it/php/load_ownerRecord.php"),
        body: {"ownerid": widget.user.id}).then((response) {
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
