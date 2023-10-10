import 'package:chat_app/common/widget/error_page.dart';
import 'package:chat_app/features/auth/page/login_page.dart';
import 'package:chat_app/features/auth/page/otp_page.dart';
import 'package:chat_app/features/select_contact/page/select_contact_page.dart';
import 'package:chat_app/features/chat/page/mobile_chat_page.dart';
import 'package:chat_app/screens/user_information_screen.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case LoginPage.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const LoginPage(),
      );
    case OtpPage.routeName:
      final verifId = routeSettings.arguments as String;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => OtpPage(verifId: verifId),
      );
    case UserInformationScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const UserInformationScreen(),
      );
    case SelectContactPage.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const SelectContactPage(),
      );
    case MobileChatPage.routeName:
      final argument = routeSettings.arguments as Map<String, dynamic>;
      final name = argument['name'];
      final uid = argument['uid'];
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => MobileChatPage(name:name, uid:uid),
      );
    default:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) =>
            const Scaffold(body: ErrorPage(error: 'Not Found Page')),
      );
  }
}
