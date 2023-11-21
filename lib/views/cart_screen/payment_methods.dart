import 'package:emart_app/consts/consts.dart';
import 'package:emart_app/consts/list.dart';
import 'package:emart_app/controllers/cart_controller.dart';
import 'package:emart_app/views/home_screen/home.dart';
import 'package:emart_app/views/home_screen/home_screen.dart';
import 'package:emart_app/widgets_commons/our_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

const stripeIndex = 1;

class PaymentMethods extends StatelessWidget {
  const PaymentMethods({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(CartController());

    return Obx(() => Scaffold(
          resizeToAvoidBottomInset: false,
          bottomNavigationBar: SizedBox(
            height: 60,
            child: controller.placingOrder.value
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ourButton(
                    color: redColor,
                    onPress: () async {
                      if (controller.paymentIndex.value == stripeIndex) {
                        await controller.makePayment(context,
                            orderPaymentMethod:
                                paymentMethods[controller.paymentIndex.value],
                            amount: controller.totalP.string);
                        await Future.delayed(Duration(seconds: 30));
                        await controller.clearCart();
                        await Get.offAll(Home());
                        VxToast.show(context,
                            msg: "Order Placed Successfully !");
                      } else {
                        await controller.placemyOrder(
                          orderPaymentMethod:
                              paymentMethods[controller.paymentIndex.value],
                          totalAmount: controller.totalP.value,
                        );
                        await controller.clearCart();
                        Get.offAll(Home());
                        VxToast.show(context,
                            msg: "Order Placed Successfully !");
                      }
                    },
                    textColor: whiteColor,
                    title: "Place my order"),
          ),
          backgroundColor: whiteColor,
          appBar: AppBar(
            title: "Choose Payment Methods"
                .text
                .fontFamily(semibold)
                .color(darkFontGrey)
                .make(),
          ),
          body: Padding(
            padding:
                const EdgeInsets.only(top: 60, bottom: 12, left: 12, right: 12),
            child: Obx(() => Column(
                  children: [
                    Column(
                      children:
                          List.generate(paymentMethodsImgs.length, (index) {
                        return GestureDetector(
                          onTap: () {
                            controller.changePaymentIndex(index);
                          },
                          child: Container(
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: controller.paymentIndex == index
                                        ? redColor
                                        : Colors.transparent,
                                    width: 6)),
                            margin: EdgeInsets.only(bottom: 12),
                            child:
                                Stack(alignment: Alignment.topRight, children: [
                              Image.asset(
                                paymentMethodsImgs[index],
                                width: double.infinity,
                                height: 120,
                                fit: BoxFit.cover,
                              ),
                              controller.paymentIndex == index
                                  ? Transform.scale(
                                      scale: 1.3,
                                      child: Checkbox(
                                          activeColor: Colors.green,
                                          value: true,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(50)),
                                          onChanged: (value) {}),
                                    )
                                  : Container()
                            ]),
                          ),
                        );
                      }),
                    ),
                  ],
                )),
          ),
        ));
  }
}
