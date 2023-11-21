import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_app/consts/list.dart';
import 'package:emart_app/controllers/product_controller.dart';
import 'package:emart_app/views/policies_screen/policy%20and%20services.dart';
import 'package:emart_app/views/video_screen/VideoScreen.dart';
import 'package:emart_app/views/chat_screen/chat_screen.dart';
import 'package:emart_app/widgets_commons/our_button.dart';
import 'package:emart_app/consts/consts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:emart_app/consts/consts.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

class ItemDetails extends StatefulWidget {
  final String? title;
  final dynamic data;
  const ItemDetails({Key? key, required this.title, this.data})
      : super(key: key);

  @override
  State<ItemDetails> createState() => _ItemDetailsState();
}

class _ItemDetailsState extends State<ItemDetails> {
  double? averageRating;

  void updateFirestore(double ratingValue, String docId) async {
    String collectionName = 'products';

    // Get the Firestore document reference
    DocumentReference docRef =
        FirebaseFirestore.instance.collection(collectionName).doc(docId);

    // Update the document in Firestore
    await docRef.update({
      'p_rating': FieldValue.arrayUnion([ratingValue.toString()])
    });
  }

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProductController());
    return WillPopScope(
      onWillPop: () async {
        controller.resetValues();
        return true;
      },
      child: Scaffold(
        backgroundColor: lightGrey,
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                controller.resetValues();
                Get.back();
              },
              icon: Icon(Icons.arrow_back)),
          title: widget.title!.text.color(darkFontGrey).fontFamily(bold).make(),
          actions: [
            IconButton(
                onPressed: () {
                  controller.resetValues();
                },
                icon: Icon(
                  Icons.share,
                )),
            Obx(
              () => IconButton(
                  onPressed: () {
                    if (controller.isFav.value) {
                      controller.removToWishlist(widget.data.id, context);
                    } else {
                      controller.addToWishlist(widget.data.id, context);
                    }
                  },
                  icon: Icon(
                    Icons.favorite,
                    color: controller.isFav.value ? redColor : darkFontGrey,
                  )),
            )
          ],
        ),
        body: Column(
          children: [
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //swiper section
                    VxSwiper.builder(
                        autoPlay: true,
                        itemCount: widget.data["p_imgs"].length,
                        aspectRatio: 16 / 9,
                        viewportFraction: 1.8,
                        height: 350,
                        itemBuilder: (context, index) {
                          return Image.network(
                            widget.data['p_imgs'][index],
                            width: double.infinity,
                            fit: BoxFit.cover,
                          );
                        }),
                    10.heightBox,
                    // title and detail screen
                    widget.title!.text
                        .size(16)
                        .color(darkFontGrey)
                        .fontFamily(semibold)
                        .make(),
                    10.heightBox,

                    StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('products')
                          .doc(widget.data.id)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          // Get the data from the snapshot
                          Map<String, dynamic>? data =
                              snapshot.data?.data() as Map<String, dynamic>?;
                          // Convert the list of strings to a list of doubles
                          List<double> doubleRatingValues = (data?['p_rating']
                                  as List<dynamic>)
                              .map((value) => double.parse(value.toString()))
                              .toList();
                          // Calculate the average
                          double average =
                              doubleRatingValues.reduce((a, b) => a + b) /
                                  doubleRatingValues.length;
                          // Return the rating widget with the average value
                          return VxRating(
                            value: average,
                            onRatingUpdate: (value) {
                              updateFirestore(
                                  double.parse(value), widget.data.id);
                            },
                            normalColor: textfieldGrey,
                            selectionColor: golden,
                            isSelectable: true,
                            count: 5,
                            maxRating: 5,
                            size: 24,
                            stepInt: false,
                          );
                        } else if (snapshot.hasError) {
                          // Return an error widget if there is an error
                          return Text('Something went wrong');
                        } else {
                          // Return a loading widget if there is no data yet
                          return CircularProgressIndicator();
                        }
                      },
                    ),

                    10.heightBox,
                    "${widget.data['p_price']}"
                        .numCurrency
                        .text
                        .color(redColor)
                        .fontFamily(bold)
                        .size(16)
                        .make(),

                    10.heightBox,
                    Row(
                      children: [
                        Expanded(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            "Seller".text.white.fontFamily(semibold).make(),
                            5.heightBox,
                            "${widget.data["p_seller"]}"
                                .text
                                .color(darkFontGrey)
                                .size(16)
                                .fontFamily(semibold)
                                .make()
                          ],
                        )),
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.message_rounded,
                            color: darkFontGrey,
                          ).onTap(() {
                            print(averageRating);
                            Get.to(() => ChatScreen(), arguments: [
                              widget.data['p_seller'],
                              widget.data['vendor_id']
                            ]);
                          }),
                        )
                      ],
                    )
                        .box
                        .height(60)
                        .padding(EdgeInsets.symmetric(horizontal: 16))
                        .color(textfieldGrey)
                        .make(),
                    // color Section
                    20.heightBox,
                    Obx(() => Column(
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: 100,
                                  child:
                                      "Color".text.color(textfieldGrey).make(),
                                ),
                                Flexible(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Wrap(
                                      spacing:
                                          8, // horizontal gap between children
                                      runSpacing:
                                          8, // vertical gap between lines
                                      children: List.generate(
                                        widget.data['p_colors'].length,
                                        (index) => Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            VxBox()
                                                .size(40, 40)
                                                .roundedFull
                                                .color(Color(
                                                        widget.data['p_colors']
                                                            [index])
                                                    .withOpacity(1.0))
                                                .make()
                                                .onTap(() {
                                              controller
                                                  .changeColorIndex(index);
                                            }),
                                            Visibility(
                                              visible: index ==
                                                  controller.colorIndex.value,
                                              child: const Icon(
                                                Icons.done,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ).box.padding(EdgeInsets.all(8)).make(),

                            //  quantity row

                            Row(
                              children: [
                                SizedBox(
                                  width: 100,
                                  child: "Quantity :"
                                      .text
                                      .color(textfieldGrey)
                                      .make(),
                                ),
                                Obx(
                                  () => Row(
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            controller.decreaseQuantity();
                                            controller.calculateTotalPrice(
                                                int.parse(
                                                    widget.data['p_price']));
                                          },
                                          icon: Icon(Icons.remove)),
                                      controller.quantity.value.text
                                          .size(16)
                                          .color(darkFontGrey)
                                          .fontFamily(bold)
                                          .make(),
                                      IconButton(
                                          onPressed: () {
                                            controller.increaseQuantity(
                                                int.parse(
                                                    widget.data['p_quantity']));
                                            controller.calculateTotalPrice(
                                                int.parse(
                                                    widget.data['p_price']));
                                          },
                                          icon: Icon(Icons.add)),
                                      10.widthBox,
                                      "${widget.data['p_quantity']} - available"
                                          .text
                                          .color(darkFontGrey)
                                          .make(),
                                    ],
                                  ),
                                )
                              ],
                            ).box.padding(EdgeInsets.all(8)).make(),
                            // total rows
                            Row(
                              children: [
                                SizedBox(
                                  width: 100,
                                  child: "Total :"
                                      .text
                                      .color(textfieldGrey)
                                      .make(),
                                ),
                                "${controller.totalPrice.value}"
                                    .numCurrency
                                    .text
                                    .color(redColor)
                                    .fontFamily(bold)
                                    .size(16)
                                    .make()
                              ],
                            ).box.padding(EdgeInsets.all(8)).make(),
                          ],
                        )).box.white.shadowSm.make(),
                    10.heightBox,
                    // descripton Section
                    "Description "
                        .text
                        .fontFamily(semibold)
                        .color(darkFontGrey)
                        .make(),
                    10.heightBox,
                    "${widget.data['p_desc']}".text.color(darkFontGrey).make(),
                    10.heightBox,
                    ListView(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      children: List.generate(
                          itemDetailButtonList.length,
                          (index) => ListTile(
                                title: itemDetailButtonList[index]
                                    .text
                                    .fontFamily(semibold)
                                    .color(darkFontGrey)
                                    .make(),
                                trailing: Icon(Icons.arrow_forward),
                                onTap: () {
                                  switch (index) {
                                    case 0:
                                      Get.to(() => VideoScreen(
                                            data: widget.data,
                                          ));
                                      break;
                                    case 1:
                                      Get.to(() => PolicyServicesScreen());
                                      break;
                                    case 2:
                                      Get.to(() => PolicyServicesScreen());
                                      break;
                                    case 3:
                                      Get.to(() => PolicyServicesScreen());
                                      break;
                                  }
                                },
                              )),
                    ),

                    // products may like Section
                    20.heightBox,
                    productsyoumaylike.text
                        .fontFamily(bold)
                        .size(16)
                        .color(darkFontGrey)
                        .make(),

                    10.heightBox,
                    //  copied from home screen
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(
                            6,
                            (index) => Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      imgP1,
                                      width: 150,
                                      fit: BoxFit.cover,
                                    ),
                                    10.heightBox,
                                    "Laptop 4GB/64GB"
                                        .text
                                        .fontFamily(semibold)
                                        .color(darkFontGrey)
                                        .make(),
                                    10.heightBox,
                                    "\$600"
                                        .text
                                        .color(redColor)
                                        .fontFamily(bold)
                                        .size(16)
                                        .make()
                                  ],
                                )
                                    .box
                                    .white
                                    .margin(EdgeInsets.symmetric(horizontal: 4))
                                    .roundedSM
                                    .padding(EdgeInsets.all(9))
                                    .make()),
                      ),
                    )
                  ],
                ),
              ),
            )),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ourButton(
                  color: redColor,
                  onPress: () {
                    if (controller.quantity > 0) {
                      controller.addToCart(
                          title: widget.data['p_name'],
                          img: widget.data['p_imgs'][0],
                          sellername: widget.data['p_seller'],
                          color: widget.data['p_colors']
                              [controller.colorIndex.value],
                          qty: controller.quantity.value,
                          tprice: controller.totalPrice.value,
                          context: context,
                          vendorID: widget.data['vendor_id']);
                      VxToast.show(context, msg: "Added to cart");
                    } else {
                      VxToast.show(context,
                          msg:
                              "Minimum 1 product is required or Color is Missing");
                    }
                  },
                  textColor: whiteColor,
                  title: "Add to cart"),
            )
          ],
        ),
      ),
    );
  }
}
