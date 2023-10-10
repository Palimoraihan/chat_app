import 'package:chat_app/colors.dart';
import 'package:chat_app/common/widget/custom_btn.dart';
import 'package:chat_app/features/auth/page/login_page.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  void navigateToLoginPage(BuildContext context) {
    Navigator.pushNamed(context, LoginPage.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final sizeres = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 15,
            ),
            const Text(
              'Welcome to WeTalk',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: sizeres.height / 9,
            ),
            Image.asset(
              'assets/img/bg.png',
              height: sizeres.height / 2.5,
              fit: BoxFit.cover,
              color: tabColor,
            ),
            SizedBox(
              height: sizeres.height / 9,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                'you can get new friends and talk with another user for new experiens',
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: sizeres.height / 10,
            ),
            CustomBtn(
                onPressed: () => navigateToLoginPage(context), text: 'Started')
          ],
        ),
      ),
    );
  }
}
