import 'package:emart_app/consts/list.dart';
import 'package:emart_app/controllers/auth_controller.dart';
import 'package:emart_app/views/auth_screen/signUp_screen.dart';
import 'package:emart_app/views/home_screen/home.dart';
import 'package:emart_app/widgets_commons/applogo.dart';
import 'package:emart_app/widgets_commons/bg_widget.dart';
import 'package:emart_app/widgets_commons/customTextField.dart';
import 'package:emart_app/widgets_commons/our_button.dart';
import 'package:flutter/material.dart';
import 'package:emart_app/consts/consts.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(AuthController());

    //text controllers

    return bgWidget(Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          children: [
            (context.screenHeight * 0.1).heightBox,
            applogoWidget(),
            10.heightBox,
            "Log in to $appname".text.fontFamily(bold).white.size(18).make(),
            10.heightBox,
            Obx(() => Column(
                      children: [
                        customTextField(
                            title: email,
                            hint: emailHint,
                            isPass: false,
                            controller: controller.emailController),
                        customTextField(
                            title: password,
                            hint: passwordHint,
                            isPass: true,
                            controller: controller.passwordController),
                        Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                                onPressed: () {},
                                child: forgetPass.text.make())),
                        5.heightBox,
                        controller.isLoading.value
                            ? CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation(redColor),
                              )
                            : ourButton(
                                color: redColor,
                                title: login,
                                textColor: whiteColor,
                                onPress: () async {
                                  controller.isLoading(true);
                                  await controller
                                      .loginMethod(context: context)
                                      .then((value) {
                                    if (value != null) {
                                      VxToast.show(context, msg: loggedIn);
                                      controller.isLoading(false);
                                      Get.offAll(() => Home());
                                    } else {
                                      controller.isLoading(false);
                                    }
                                  });
                                }).box.width(context.screenWidth - 50).make(),
                        5.heightBox,
                        createNewAccount.text.color(fontGrey).make(),
                        5.heightBox,
                        ourButton(
                            color: redColor,
                            title: signUp,
                            textColor: whiteColor,
                            onPress: () {
                              Get.to(() => SignUpScreen());
                            }).box.width(context.screenWidth - 50).make(),
                        5.heightBox,
                        loginWith.text.color(fontGrey).make(),
                        15.heightBox,
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                                2,
                                (index) => Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CircleAvatar(
                                        backgroundColor: lightGrey,
                                        radius: 28,
                                        child: Image.asset(
                                          socialIconList[index],
                                          width: 30,
                                        ),
                                      ),
                                    )))
                      ],
                    ))
                .box
                .white
                .rounded
                .padding(const EdgeInsets.all(16))
                .width(context.screenWidth - 70)
                .shadowSm
                .make()
          ],
        ),
      ),
    ));
  }
}
