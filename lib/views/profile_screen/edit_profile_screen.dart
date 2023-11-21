import 'dart:io';

import 'package:emart_app/consts/colors.dart';
import 'package:emart_app/consts/consts.dart';
import 'package:emart_app/consts/images.dart';
import 'package:emart_app/controllers/profile_controller.dart';
import 'package:emart_app/widgets_commons/bg_widget.dart';
import 'package:emart_app/widgets_commons/customTextField.dart';
import 'package:emart_app/widgets_commons/our_button.dart';

import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:get/get.dart';

class EditProfileScreen extends StatelessWidget {
  final dynamic data;
  const EditProfileScreen({Key? key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<ProfileController>();

    return bgWidget(Scaffold(
      appBar: AppBar(),
      body: Obx(() => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // if data image Url and controller path is empty
                  data['imageUrl'] == '' && controller.profileImagePath.isEmpty
                      ? Image.asset(
                          imgProfile2,
                          width: 80,
                          fit: BoxFit.cover,
                        ).box.roundedFull.clip(Clip.antiAlias).make()
                      // if data image is not empty but controller is
                      : data['imageUrl'] != "" &&
                              controller.profileImagePath.isEmpty
                          ? Image.network(
                              data['imageUrl'],
                              width: 80,
                              fit: BoxFit.cover,
                            ).box.roundedFull.clip(Clip.antiAlias).make()

                          // if both are empty
                          : Image.file(
                              File(
                                controller.profileImagePath.value,
                              ),
                              width: 80,
                              fit: BoxFit.cover,
                            ).box.roundedFull.clip(Clip.antiAlias).make(),
                  10.heightBox,
                  ourButton(
                      color: redColor,
                      onPress: () {
                        controller.changeImage(context);
                      },
                      textColor: whiteColor,
                      title: "Change"),
                  Divider(),
                  20.heightBox,
                  customTextField(
                    controller: controller.nameController,
                    hint: NameHint,
                    title: name,
                    isPass: false,
                  ),
                  10.heightBox,
                  customTextField(
                    controller: controller.oldPasswordController,
                    hint: passwordHint,
                    title: oldPassword,
                    isPass: true,
                  ),
                  10.heightBox,
                  customTextField(
                    controller: controller.newPasswordController,
                    hint: passwordHint,
                    title: newPassword,
                    isPass: true,
                  ),
                  20.heightBox,
                  controller.isLoading.value
                      ? CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(redColor),
                        )
                      : SizedBox(
                          width: context.screenWidth - 55,
                          child: ourButton(
                              color: redColor,
                              onPress: () async {
                                controller.isLoading(true);

                                // if image is selected

                                if (controller.profileImagePath.isNotEmpty) {
                                  await controller.uploadProfileImage();
                                } else {
                                  controller.profileImageLink =
                                      data['imageUrl'];
                                }
                                // if old pass matches with database

                                if (data['password'] ==
                                    controller.oldPasswordController.text) {
                                  await controller.changeAuthPassword(
                                    email: data['email'],
                                    password:
                                        controller.oldPasswordController.text,
                                    newPassword:
                                        controller.newPasswordController.text,
                                  );

                                  await controller.updateProfile(
                                      imgUrl: controller.profileImageLink,
                                      name: controller.nameController.text,
                                      password: controller
                                          .newPasswordController.text);
                                  VxToast.show(context,
                                      msg: "Profile Updated Successfully");
                                } else {
                                  VxToast.show(context,
                                      msg: "Wrong Old Password");
                                  controller.isLoading(false);
                                }
                              },
                              textColor: whiteColor,
                              title: "Save"),
                        )
                ],
              ))
          .box
          .white
          .shadowSm
          .padding(EdgeInsets.all(16))
          .margin(EdgeInsets.only(top: 50, left: 12, right: 12))
          .rounded
          .make(),
    ));
  }
}
