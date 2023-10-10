import 'dart:developer';
import 'package:chat_app/common/widget/error_page.dart';
import 'package:chat_app/common/widget/loader.dart';
import 'package:chat_app/features/auth/controller/auth_controller.dart';
import 'package:chat_app/features/landing/page/landing_page.dart';
import 'package:chat_app/router.dart';
import 'package:chat_app/screens/mobile_layout_screen.dart';
import 'package:chat_app/utils/custom_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: darkMode,
        onGenerateRoute: generateRoute,
        home: ref.watch(userDataAuthProvider).when(
              data: (data) {
                log('${data?.name}');
                if (data == null) {
                  return const LandingPage();
                } else {
                  return const MobileLayoutScreen();
                }
              },
              error: (error, stackTrace) {
                return ErrorPage(error: '$error');
              },
              loading: () => const LoaderWidget(),
            )
        // const LandingPage(),
        // const ResponsiveLayout(
        //   mobileScreenLayout: MobileLayoutScreen(),
        //   webScreenLayout: WebLayoutScreen(),
        // ),
        );
  }
}
