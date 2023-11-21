import 'package:emart_app/consts/consts.dart';
import 'package:emart_app/consts/list.dart';
import 'package:emart_app/controllers/auth_controller.dart';
import 'package:emart_app/views/home_screen/home.dart';
import 'package:emart_app/widgets_commons/applogo.dart';
import 'package:emart_app/widgets_commons/bg_widget.dart';
import 'package:emart_app/widgets_commons/our_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets_commons/customTextField.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool? isCheck = false;
  var controller = Get.put(AuthController());

  //text controller

  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var passwordRetypeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return bgWidget(Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
          child: Column(
            children: [
              (context.screenHeight * 0.1).heightBox,
              applogoWidget(),
              10.heightBox,
              "Join  the $appname".text.fontFamily(bold).white.size(18).make(),
              10.heightBox,
              Obx(() => Column(
                        children: [
                          customTextField(
                              title: name,
                              hint: NameHint,
                              controller: nameController,
                              isPass: false),
                          customTextField(
                              title: email,
                              hint: emailHint,
                              controller: emailController,
                              isPass: false),
                          customTextField(
                              title: password,
                              hint: passwordHint,
                              controller: passwordController,
                              isPass: true),
                          customTextField(
                              title: retypePassword,
                              hint: passwordHint,
                              controller: passwordRetypeController,
                              isPass: true),
                          Row(
                            children: [
                              Checkbox(
                                activeColor: redColor,
                                value: isCheck,
                                onChanged: (newValue) {
                                  setState(() {
                                    isCheck = newValue;
                                  });
                                },
                              ),
                              10.widthBox,
                              Expanded(
                                child: RichText(
                                    text: const TextSpan(children: [
                                  TextSpan(
                                      text: "I agree to the ",
                                      style: TextStyle(
                                          fontFamily: regular,
                                          color: fontGrey)),
                                  TextSpan(
                                      text: termsAndConditions,
                                      style: TextStyle(
                                          fontFamily: regular,
                                          color: redColor)),
                                  TextSpan(
                                      text: " & ",
                                      style: TextStyle(
                                          fontFamily: regular,
                                          color: fontGrey)),
                                  TextSpan(
                                      text: privacyPolicy,
                                      style: TextStyle(
                                          fontFamily: regular, color: redColor))
                                ])),
                              ),
                            ],
                          ),
                          5.heightBox,
                          controller.isLoading.value
                              ? CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation(redColor),
                                )
                              : ourButton(
                                  color: isCheck == true ? redColor : lightGrey,
                                  title: signUp,
                                  textColor: whiteColor,
                                  onPress: () async {
                                    controller.isLoading(true);
                                    if (isCheck != false) {
                                      try {
                                        await controller.SignUpMethod(
                                                context: context,
                                                email: emailController.text,
                                                password:
                                                    passwordController.text)
                                            .then((value) {
                                          return controller.storeUserData(
                                            email: emailController.text,
                                            password: passwordController.text,
                                            name: nameController.text,
                                          );
                                        }).then((value) {
                                          VxToast.show(context, msg: loggedIn);
                                          return Get.offAll(() => Home());
                                        });
                                      } catch (e) {
                                        auth.signOut();
                                        VxToast.show(context, msg: loggedOut);
                                        controller.isLoading(false);
                                      }
                                    }
                                  }).box.width(context.screenWidth - 50).make(),
                          10.heightBox,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RichText(
                                  text: TextSpan(children: [
                                TextSpan(
                                    text: AlreadyHaveAccount,
                                    style: TextStyle(
                                        fontFamily: bold, color: fontGrey)),
                                TextSpan(
                                    text: login,
                                    style: TextStyle(
                                        fontFamily: bold, color: redColor))
                              ])).onTap(() {
                                Get.back();
                              }),
                            ],
                          )
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
        )));
  }
}
