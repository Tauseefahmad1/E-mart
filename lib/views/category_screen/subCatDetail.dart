import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_app/controllers/product_controller.dart';
import 'package:emart_app/services/firestore_services.dart';
import 'package:emart_app/views/category_screen/items_detail.dart';
import 'package:emart_app/widgets_commons/bg_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:emart_app/consts/consts.dart';

class SubCategoryDetail extends StatefulWidget {
  final String? title;
  const SubCategoryDetail({Key? key, required this.title}) : super(key: key);

  @override
  State<SubCategoryDetail> createState() => _SubCategoryDetailState();
}

class _SubCategoryDetailState extends State<SubCategoryDetail> {
  final controller = Get.put(ProductController());
  late Stream<QuerySnapshot> productStream;

  @override
  void initState() {
    super.initState();
    productStream = FireStoreServices.getSubCategoryProductsQuery(widget.title!)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return bgWidget(Scaffold(
      appBar: AppBar(
        title: Text(widget.title!, style: TextStyle(fontFamily: bold)),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          20.heightBox,
          StreamBuilder<QuerySnapshot>(
            stream: productStream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Expanded(
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(redColor),
                    ),
                  ),
                );
              } else if (snapshot.data!.docs.isEmpty) {
                return Expanded(
                  child: "No products found....."
                      .text
                      .fontFamily(semibold)
                      .size(18)
                      .color(darkFontGrey)
                      .makeCentered(),
                );
              } else {
                var data = snapshot.data!.docs;
                return Expanded(
                  child: GridView.builder(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: data.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisExtent: 250,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                    ),
                    itemBuilder: (context, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.network(
                            data[index]['p_imgs'][0],
                            height: 150,
                            width: 200,
                            fit: BoxFit.cover,
                          ),
                          Text(
                            data[index]['p_name'],
                            style: TextStyle(
                              fontFamily: semibold,
                              color: darkFontGrey,
                            ),
                          ),
                          10.heightBox,
                          Text(
                            data[index]["p_price"].toString(),
                            style: TextStyle(
                              color: redColor,
                              fontFamily: bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      )
                          .box
                          .white
                          .margin(EdgeInsets.symmetric(horizontal: 4))
                          .roundedSM
                          .outerShadowSm
                          .padding(EdgeInsets.all(9))
                          .make()
                          .onTap(() {
                        controller.checkIfFav(data[index]);
                        Get.to(() => ItemDetails(
                              title: data[index]['p_name'],
                              data: data[index],
                            ));
                      });
                    },
                  ),
                );
              }
            },
          ),
        ],
      ),
    ));
  }
}
