import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:barter_it/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:barter_it/models/item.dart';
import 'package:barter_it/myconfig.dart';
import 'WishlistScreen.dart';
import 'BarterRecordScreen.dart';
import 'SearchDetailsScreen.dart';

// for searching or browsing items available to trade

class SearchTabScreen extends StatefulWidget {
  final User user;

  const SearchTabScreen({super.key, required this.user});

  @override
  State<SearchTabScreen> createState() => _SearchTabScreenState();
}

class _SearchTabScreenState extends State<SearchTabScreen> {
  String maintitle = "Search";
  List<Item> itemList = <Item>[]; //The array for assigning the loaded items
  late double screenHeight, screenWidth;
  late int axiscount = 2;
  int numofpage = 1, curpage = 1;
  int numberofresult = 0;
  var color;
  int wishlistqty = 0;

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadItems(1);
    print("Search");
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
          IconButton(
              onPressed: () {
                showsearchDialog();
              },
              icon: const Icon(Icons.search)),
          TextButton.icon(
            icon: const Icon(
              color: Colors.white,
              Icons.shopping_cart_outlined,
            ), // Your icon here
            label: Text(wishlistqty.toString()), // Your text here
            onPressed: () {
              if (wishlistqty > 0) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (content) => WishlistScreen(
                              user: widget.user,
                            )));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("No item in wishlist")));
              }
            },
          ),
          PopupMenuButton(
              // add icon, by default "3 dot" icon
              // icon: Icon(Icons.book)
              itemBuilder: (context) {
            return [
              const PopupMenuItem<int>(
                value: 0,
                child: Text("My Barter Request"),
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
                      builder: (content) => BarterRecordScreen(
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
                      ..color = Color.fromARGB(255, 218, 96, 198),
                  ),
                  strutStyle: const StrutStyle(fontWeight: FontWeight.bold)),
            )
          : Column(children: [
              Container(
                height: 24,
                color: Theme.of(context).colorScheme.primary,
                alignment: Alignment.center,
                child: Text(
                  "$numberofresult Items Available for Barter!",
                  style: const TextStyle(color: Colors.white, fontSize: 18),
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
                              onTap: () async {
                                Item useritem =
                                    Item.fromJson(itemList[index].toJson());
                                await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (content) =>
                                            SearchDetailsScreen(
                                              user: widget.user,
                                              useritem: useritem,
                                            )));
                                loadItems(1);
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
                                //    "RM ${double.parse(itemList[index].itemPrice.toString()).toStringAsFixed(2)}",
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
                      ))),
              SizedBox(
                height: 50,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: numofpage,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    if ((curpage - 1) == index) {
                      color = Colors.purple;
                    } else {
                      color = Colors.black;
                    }
                    return TextButton(
                        onPressed: () {
                          curpage = index + 1;
                          loadItems(index + 1);
                        },
                        child: Text(
                          (index + 1).toString(),
                          style: TextStyle(color: color, fontSize: 18),
                        ));
                  },
                ),
              ),
            ]),
    );
  }

  void loadItems(int pageno) {
    //print(pageno);
    http.post(Uri.parse("${MyConfig().SERVER}/barter_it/php/load_items.php"),
        body: {
          "wishlistuserid": widget.user.id,
          "pageno": pageno.toString()
        }).then((response) {
      //print(response.body);
      log(response.body);
      itemList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          print(numofpage);
          numofpage =
              int.parse(jsondata['numofpage']); //get the number of pages
          numberofresult = int.parse(jsondata['numberofresult']);
          print(numberofresult);
          var extractdata = jsondata['data'];
          wishlistqty = int.parse(jsondata['wishlistqty'].toString());
          print(wishlistqty);

          //Items that are loaded assigned to the list array
          extractdata['items'].forEach((v) {
            itemList.add(Item.fromJson(v));
          });
          print(itemList[0].itemName);
          setState(() {});
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text(
                  "Data Loading Failed"))); //If failed to receive data from http request
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                "Data Loading Failed"))); //If failed to receive data from http request
      }
    });
  }

  void showsearchDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: const Text(
            "Search for Item Name/Type/Location",
            style: TextStyle(),
          ),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(
                controller: searchController,
                decoration: const InputDecoration(
                    labelText: 'Search',
                    labelStyle: TextStyle(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2.0),
                    ))),
            const SizedBox(
              height: 4,
            ),
            ElevatedButton(
                onPressed: () {
                  String search = searchController.text;
                  searchItem(search);
                  Navigator.of(context).pop();
                },
                child: const Text("Search"))
          ]),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Clear",
                style: TextStyle(),
              ),
              onPressed: () {
                searchController.text = "";
              },
            ),
            TextButton(
              child: const Text(
                "Close",
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

  void searchItem(String search) {
    http.post(Uri.parse("${MyConfig().SERVER}/barter_it/php/load_items.php"),
        body: {
          "wishlistuserid": widget.user.id,
          "search": search
        }).then((response) {
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
          setState(() {});
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                "Data Loading Failed"))); //If failed to receive data from http request
      }
    });
  }
}
