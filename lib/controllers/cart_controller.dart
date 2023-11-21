import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_app/consts/consts.dart';
import 'package:emart_app/controllers/home_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  var totalP = 0.obs;
  // text controllers
  var addressController = TextEditingController();
  var cityController = TextEditingController();
  var stateController = TextEditingController();
  var postalController = TextEditingController();
  var phoneController = TextEditingController();
  var paymentIndex = 0.obs;
  late dynamic productSnapshot;
  var products = [];
  var vendors = [];
  var placingOrder = false.obs;
  var controller = Get.put(HomeController());

  // functions
  calculate(data) {
    totalP = 0.obs;
    for (var i = 0; i < data.length; i++) {
      totalP.value = totalP.value + int.parse(data[i]['tprice'].toString());
    }
  }

  changePaymentIndex(index) {
    paymentIndex.value = index;
  }

  String r = Random().nextInt(999999).toString().padLeft(6, '0');
  placemyOrder({required orderPaymentMethod, required totalAmount}) async {
    placingOrder(true);
    await getProductDetails();
    await firestore.collection(ordersCollections).doc().set({
      'order_code': r,
      'order_by': currentUser!.uid,
      'order_by_name': controller.username,
      'order_by_email': currentUser!.email,
      'order_by_address': addressController.text,
      'order_by_state': stateController.text,
      'order_by_city': cityController.text,
      'order_by_phone': phoneController.text,
      'order_by_postalcode': postalController.text,
      "shipping_method": "Home Delivery",
      'payment_method': orderPaymentMethod,
      'order_date': DateTime.now(),
      'order_placed': true,
      'order_confirmed': false,
      'order_delivered': false,
      'order_on_delivery': false,
      'total_amount': totalAmount.toString(),
      'orders': FieldValue.arrayUnion(products),
      'vendors': FieldValue.arrayUnion(vendors),
      'paid': "UnPaid"
    });
    placingOrder(false);
  }

  getProductDetails() {
    products.clear();
    vendors.clear();
    for (var i = 0; i < productSnapshot.length; i++) {
      products.add({
        'color': productSnapshot[i]['color'],
        'img': productSnapshot[i]['img'],
        'vendor_id': productSnapshot[i]['vendor_id'],
        'tprice': productSnapshot[i]['tprice'],
        'qty': productSnapshot[i]['qty'],
        'title': productSnapshot[i]['title']
      });
      vendors.add(productSnapshot[i]['vendor_id']);
    }
  }

  clearCart() {
    for (var i = 0; i < productSnapshot.length; i++) {
      firestore.collection(cartCollections).doc(productSnapshot[i].id).delete();
    }
  }

  // Expirement

  Map<String, dynamic>? paymentIntentData;

  Future<void> makePayment(BuildContext context,
      {String? amount, required orderPaymentMethod}) async {
    try {
      paymentIntentData = await createPaymentIntent(amount, 'USD');
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret:
                      paymentIntentData!['client_secret'],
                  applePay: true,
                  googlePay: true,
                  testEnv: true,
                  style: ThemeMode.dark,
                  merchantCountryCode: 'US',
                  merchantDisplayName: 'EMS'))
          .then((value) {})
          .catchError((e) {
        print("Error is $e");
      });

      ///now finally display payment sheeet
      displayPaymentSheet(context, amount, orderPaymentMethod);
    } catch (e, s) {
      print('exception:');
      print("\n");
      print("$e");
      print("\n");

      print("$s");
    }
  }

  displayPaymentSheet(
    BuildContext context,
    String? amount,
    orderPaymentMethod,
  ) async {
    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection('orders');

    try {
      await Stripe.instance
          .presentPaymentSheet(
              parameters: PresentPaymentSheetParameters(
        clientSecret: paymentIntentData!['client_secret'],
        confirmPayment: true,
      ))
          .then((newValue) async {
        placingOrder(true);
        await getProductDetails();
        collectionRef.doc().set(
          {
            'order_code': r,
            'order_by': currentUser!.uid,
            'order_by_name': controller.username,
            'order_by_email': currentUser!.email,
            'order_by_address': addressController.text,
            'order_by_state': stateController.text,
            'order_by_city': cityController.text,
            'order_by_phone': phoneController.text,
            'order_by_postalcode': postalController.text,
            "shipping_method": "Home Delivery",
            'payment_method': orderPaymentMethod,
            'order_date': DateTime.now(),
            'order_placed': true,
            'order_confirmed': false,
            'order_delivered': false,
            'order_on_delivery': false,
            'total_amount': amount,
            'orders': FieldValue.arrayUnion(products),
            'vendors': FieldValue.arrayUnion(vendors),
            'paid': 'Paid',
          },
        );
        placingOrder(false);

        paymentIntentData = null;
      }).onError((error, stackTrace) {
        print('Exception/DISPLAYPAYMENTSHEET==> $error $stackTrace');
      });
    } on StripeException catch (e) {
      print('Exception/DISPLAYPAYMENTSHEET==> $e');
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                content: Text("Cancelled "),
              ));
    } catch (e) {
      print('$e');
    }
  }

//  Future<Map<String, dynamic>>
  createPaymentIntent(String? amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
      };
      print(body);
      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization': 'Bearer $secretKey',
            'Content-Type': 'application/x-www-form-urlencoded'
          });
      print('Create Intent reponse ===> ${response.body.toString()}');
      return jsonDecode(response.body);
    } catch (err) {
      print('err charging user: ${err.toString()}');
    }
  }
}
