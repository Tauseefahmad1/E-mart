import 'package:emart_app/consts/consts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget OrderStatus({icon, color, title, showDone}) {
  return ListTile(
    leading: Icon(
      icon,
      color: color,
    ).box.border(color: color).make(),
    trailing: SizedBox(
      height: 100,
      width: 120,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          "$title".text.color(darkFontGrey).make(),
          showDone
              ? Icon(
                  icon,
                  color: color,
                )
                  .box
                  .border(color: color)
                  .roundedSM
                  .padding(EdgeInsets.all(4))
                  .make()
              : Container(),
        ],
      ),
    ),
  );
}
