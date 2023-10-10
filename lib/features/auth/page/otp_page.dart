import 'package:chat_app/features/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../colors.dart';
import '../../../common/widget/custom_btn.dart';

class OtpPage extends ConsumerWidget {
  static const String routeName = '/otp';
  final String verifId;
  const OtpPage({super.key, required this.verifId});
  void verifOtp(WidgetRef ref, BuildContext context, String userOtp) {
    ref.read(authControllerProvider).verifyOtp(
          context,
          verifId,
          userOtp,
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sizer = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: const Text(
          'Verify Your Number',
        ),
        elevation: 0,
      ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 20,
            width: sizer.width,
          ),
          const Text('We have sent an SMS with a code'),
          Container(
            width: sizer.width * 0.5,
            decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: messageColor))),
            child: TextField(
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                hintText: '- - - - -',
                hintStyle: TextStyle(fontSize: 30),
              ),
              onChanged: (value) {
                print('any val');
                if (value.length == 6) {
                  print('send');
                  verifOtp(ref, context, value.trim());
                }
              },
              keyboardType: TextInputType.phone,
            ),
          ),
          SizedBox(
            height: sizer.height * 0.6,
          ),
          CustomBtn(onPressed: () {
                  // verifOtp(ref, context, value.trim());

          }, text: 'Login'),
        ],
      ),
    );
  }
}
