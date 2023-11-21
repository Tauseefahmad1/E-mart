import 'package:emart_app/consts/colors.dart';
import 'package:flutter/material.dart';

class PolicyServicesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: Text(
          "Policy and Services",
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Privacy Policy",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed commodo, mauris id cursus rutrum, nisi ipsum dignissim justo, eget lacinia metus massa at urna. Morbi ut porttitor nisi. Nullam eget lacus auctor, vestibulum velit at, aliquet ipsum.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              "Terms and Conditions",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed commodo, mauris id cursus rutrum, nisi ipsum dignissim justo, eget lacinia metus massa at urna. Morbi ut porttitor nisi. Nullam eget lacus auctor, vestibulum velit at, aliquet ipsum.",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
