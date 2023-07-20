import 'package:flutter/material.dart';
import 'package:barter_it/models/user.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:barter_it/models/item.dart';
import 'package:http/http.dart' as http;
import 'package:barter_it/myconfig.dart';
import 'EditItemScreen.dart';
import 'AddNewItemscreen.dart';
import 'TradeRequestScreen.dart';
//import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

//for Offer screen

class OfferTabScreen extends StatefulWidget {
  final User user;
  const OfferTabScreen({super.key, required this.user});

  @override
  State<OfferTabScreen> createState() => _OfferTabScreenState();
}

class _OfferTabScreenState extends State<OfferTabScreen> {
  late double screenHeight, screenWidth;
  late int axiscount = 2;
  late List<Widget> tabchildren;
  String maintitle = "Your Item List";
  List<Item> itemList = <Item>[];

  @override
  void initState() {
    super.initState();
    loadOfferItems();
    print("Offer");
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
    if (screenWidth > 600) {
      axiscount = 3;
    } else {
      axiscount = 2;
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          maintitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 28,
            color: Colors.white,
            //fontStyle: FontStyle.italic,
          ),
          strutStyle: const StrutStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          PopupMenuButton(
              // add icon, by default "3 dot" icon
              // icon: Icon(Icons.book)
              itemBuilder: (context) {
            return [
              const PopupMenuItem<int>(
                value: 0,
                child: Text("Trade Requests"),
              ),
              // const PopupMenuItem<int>(
              //   value: 1,
              //   child: Text("New"),
              // ),
            ];
          }, onSelected: (value) async {
            if (value == 0) {
              if (widget.user.id.toString() == "na") {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Please login/register an account")));
                return;
              }
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (content) => TradeRequestScreen(
                            user: widget.user,
                          )));
            } else if (value == 1) {
            } else if (value == 2) {}
          }),
        ],
      ),
      body: itemList.isEmpty
          ? Center(
              child: Text("No Data Found!",
                  style: TextStyle(
                    fontSize: 40,
                    fontStyle: FontStyle.italic,
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 3
                      ..color = Color.fromARGB(255, 218, 96, 198)!,
                  ),
                  strutStyle: const StrutStyle(fontWeight: FontWeight.bold)),
            )
          : Column(children: [
              Container(
                height: 24,
                color: Theme.of(context).colorScheme.primary,
                alignment: Alignment.center,
                child: Text(
                  "${itemList.length} Items Found!",
                  style: const TextStyle(
                      color: Colors.white,
                      //fontStyle: FontStyle.italic,
                      //fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                      fontSize: 20),
                ),
              ),
              Expanded(
                  child: GridView.count(
                      crossAxisCount: axiscount,
                      children: List.generate(
                        itemList.length,
                        (index) {
                          return Card(
                            child: InkWell(
                              onLongPress: () {
                                onDeleteDialog(index);
                              },
                              onTap: () async {
                                Item singleitem =
                                    Item.fromJson(itemList[index].toJson());
                                await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (content) => EditItemScreen(
                                              user: widget.user,
                                              useritem: singleitem,
                                            )));
                                loadOfferItems();
                              },
                              child: Column(children: [
                                CachedNetworkImage(
                                  width: screenWidth,
                                  fit: BoxFit.cover,
                                  imageUrl:
                                      "${MyConfig().SERVER}/barter_it/assets/items/${itemList[index].itemId}_Image1.png",
                                  placeholder: (context, url) =>
                                      const LinearProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                                Text(
                                  itemList[index].itemName.toString(),
                                  style: const TextStyle(fontSize: 20),
                                ),
                                Text(
                                  itemList[index].itemType.toString(),
                                  style: const TextStyle(fontSize: 15),
                                ),

                                // Text(
                                //   "RM ${double.parse(itemList[index].itemPrice.toString()).toStringAsFixed(2)}",
                                //    style: const TextStyle(fontSize: 14),
                                //  ),
                                Text(
                                  "${itemList[index].itemQty} available",
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ]),
                            ),
                          );
                        },
                      )))
            ]),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            if (widget.user.id != "na") {
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (content) => AddNewItemscreen(
                            user: widget.user,
                          )));
              loadOfferItems();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Please login/register an account")));
            }
          },
          child: const Text(
            "+",
            style: TextStyle(fontSize: 32),
          )),
    );
  }

  void loadOfferItems() {
    //Disabled unregistered user for now
    /* if (widget.user.id == "na") {
      setState(() {
        // titlecenter = "Unregistered User";
      });
      return;
    }*/

    http.post(Uri.parse("${MyConfig().SERVER}/barter_it/php/load_items.php"),
        body: {"userid": widget.user.id}).then((response) {
      //print(response.body);
      log(response.body);
      itemList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          var extractdata = jsondata['data'];
          extractdata['items'].forEach((v) {
            itemList.add(Item.fromJson(v));
          });
          print(itemList[0].itemName);
        }
        setState(() {});
      }
    });
  }

  void onDeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Text(
            "Delete ${itemList[index].itemName}?",
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                deleteItem(index);
                Navigator.of(context).pop();
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

  void deleteItem(int index) {
    http.post(Uri.parse("${MyConfig().SERVER}/barter_it/php/delete_item.php"),
        body: {
          "userid": widget.user.id,
          "itemid": itemList[index].itemId
        }).then((response) {
      print(response.body);
      //itemList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Deleted Successfully!")));
          loadOfferItems();
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Failed")));
        }
      }
    });
  }
}
