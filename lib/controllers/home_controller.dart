import 'package:emart_app/consts/firebase_consts.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit

    super.onInit();
    getUsername();
  }
// variables and controllers

  var CurrentNavIndex = 0.obs;
  var username = '';
  var featuredLsit = [];
  var searchController = TextEditingController();

  //
  getUsername() async {
    var n = await firestore
        .collection(usersCollections)
        .where('id', isEqualTo: currentUser!.uid)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        return value.docs.single['name'];
      }
    });
    username = n;
  }
}
