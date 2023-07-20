import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:barter_it/models/wishlist.dart';
import 'package:barter_it/models/user.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:barter_it/myconfig.dart';

class WishlistScreen extends StatefulWidget {
  final User user;

  const WishlistScreen({super.key, required this.user});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  List<Wishlist> wishList = <Wishlist>[];
  late double screenHeight, screenWidth;
  late int axiscount = 2;
  //double totalprice = 0.0;

  @override
  void initState() {
    super.initState();
    loadwishlist();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        //centerTitle: true,
        title: const Text("Your wishlist"),
        actions: [
          TextButton.icon(
              label: Text(
                "${widget.user.credit} Credits",
                style: const TextStyle(fontSize: 15, color: Colors.white),
              ),
              icon: const Icon(
                color: Colors.white,
                Icons.currency_exchange,
              ), // Your icon here
              // Your text here
              onPressed: () {})
        ],
      ),
      body: Column(
        children: [
          wishList.isEmpty
              ? Container()
              : Expanded(
                  child: ListView.builder(
                      itemCount: wishList.length,
                      itemBuilder: (context, index) {
                        return Card(
                            child: InkWell(
                          //padding: const EdgeInsets.all(8.0),
                          // GestureDetector(
                          onTap: () {
                            //print(wishList[index].wishlistQty.toString());
                            sendBarterRequestDialog(index);
                          },
                          child: Row(
                            children: [
                              CachedNetworkImage(
                                width: screenWidth / 3,
                                fit: BoxFit.cover,
                                imageUrl:
                                    "${MyConfig().SERVER}/barter_it/assets/items/${wishList[index].itemId}_Image1.png",
                                placeholder: (context, url) =>
                                    const LinearProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                              Flexible(
                                flex: 4,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        wishList[index].itemName.toString(),
                                        style: const TextStyle(
                                            fontSize: 21,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        wishList[index].itemType.toString(),
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          IconButton(
                                              onPressed: () {},
                                              icon: const Icon(Icons.remove)),
                                          Text(wishList[index]
                                              .wishlistQty
                                              .toString()),
                                          IconButton(
                                            onPressed: () {},
                                            icon: const Icon(Icons.add),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // const SizedBox(
                              //   width: 50,
                              // ),
                              IconButton(
                                  onPressed: () {
                                    deleteDialog(index);
                                  },
                                  // ignore: prefer_const_constructors
                                  icon: Icon(Icons.delete))
                            ],
                          ),
                        ));
                      })),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Container(
          //       height: 70,
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: [
          //           //    Text("Total Price RM " + totalprice.toStringAsFixed(2)),
          //           ElevatedButton(onPressed: () {}, child: Text("Check Out"))
          //         ],
          //       )),
          // )
        ],
      ),
    );
  }

  void loadwishlist() {
    http.post(Uri.parse("${MyConfig().SERVER}/barter_it/php/load_wishlist.php"),
        body: {
          "userid": widget.user.id,
        }).then((response) {
      print(response.body);
      // log(response.body);
      wishList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          var extractdata = jsondata['data'];
          extractdata['wishlists'].forEach((v) {
            wishList.add(Wishlist.fromJson(v));
            //  totalprice = totalprice +
            //     double.parse(extractdata["wishlists"]["wishlist_price"].toString());
          });

          wishList.forEach((element) {
            //  totalprice =
            //      totalprice + double.parse(element.wishlistPrice.toString());
          });
          //print(itemList[0].itemName);
        }
        setState(() {});
      }
    });
  }

  void deleteDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: const Text(
            "Delete this item from your wishlist?",
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
                deleteWishlist(index);
                //registerUser();
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

  void deleteWishlist(int index) {
    http.post(
        Uri.parse("${MyConfig().SERVER}/barter_it/php/delete_wishlist.php"),
        body: {
          "wishlistid": wishList[index].wishlistId,
        }).then((response) {
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          loadwishlist();
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Delete Success")));
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Delete Failed")));
        }
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Delete Failed")));
      }
    });
  }

  void updateWishlist(int index, int newqty) {
    http.post(
        Uri.parse("${MyConfig().SERVER}/barter_it/php/update_wishlist.php"),
        body: {
          "wishlistid": wishList[index].wishlistId,
          "newqty": newqty.toString()
        }).then((response) {
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Quantity updated")));
          loadwishlist();
        } else {}
      } else {}
    });
  }

  void sendBarterRequestDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: const Text(
            "Send Request to owner to Barter for item?",
            style: TextStyle(),
          ),
          content: const Text("Are you sure? \n(3 Credits will be deducted)",
              style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _sendBarterRequest(index);
                //registerUser();
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

  void _sendBarterRequest(int index) {
    String tradeStatus = "pending";
    int newcreditValue = (int.parse(widget.user.credit!) - 3);

    if (newcreditValue >= 0) {
      String newCredit = newcreditValue.toString();
      http.post(
          Uri.parse("${MyConfig().SERVER}/barter_it/php/sendBarterRequest.php"),
          body: {
            "wishlistid": wishList[index].wishlistId,
            "userid": widget.user.id,
            "ownerid": wishList[index].ownerId,
            "status": tradeStatus,
            "itemid": wishList[index].itemId,
            "itemqty": wishList[index].wishlistQty,
            //"newCredit": newCredit
          }).then((response) {
        if (response.statusCode == 200) {
          var jsondata = jsonDecode(response.body);
          if (jsondata['status'] == 'success') {
            _updateCredit(newCredit);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text(
                    "Request sent, please wait for owner to reply to your request")));
            deleteWishlist(index);
            loadwishlist();
          } else {
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text("Request Failed")));
          }
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Request Failed")));
        }
      });
    } else {
      Fluttertoast.showToast(
          msg:
              "Your Credit is not enough, please purchase credit at Profile Tab",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          fontSize: 16.0);
      return;
    }
  }

  void _updateCredit(String newCredit) {
    http.post(
        Uri.parse("${MyConfig().SERVER}/barter_it/php/update_profile.php"),
        body: {
          "userid": widget.user.id,
          "newCredit": newCredit
        }).then((response) {
      var jsonResponse = json.decode(response.body);
      if (response.statusCode == 200 && jsonResponse['status'] == "success") {
        setState(() {
          widget.user.credit = newCredit;
        });
      } else {
        Navigator.pop(context);
        Fluttertoast.showToast(
            msg: "Purchase Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
      }
    });
  }
}
