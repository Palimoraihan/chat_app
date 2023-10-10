import 'package:chat_app/common/utils/utils.dart';
import 'package:chat_app/common/widget/custom_btn.dart';
import 'package:chat_app/features/auth/controller/auth_controller.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../colors.dart';

class LoginPage extends ConsumerStatefulWidget {
  static const String routeName = '/login';
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final TextEditingController phoneController = TextEditingController();
  Country? country;

  @override
  void dispose() {
    phoneController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  void pickCountry() {
    showCountryPicker(
      context: context,
      onSelect: (value) {
        setState(() {
          country = value;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final sizeres = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: const Text(
          'Login Your Phone',
        ),
      ),
      body: 
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'This app need youre phone for verify your account',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
            
          ),
          SizedBox(
            height: 10,
            width: sizeres.width,
          ),
          TextButton(
            onPressed: () => pickCountry(),
            child: const Text('choose your contry'),
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Visibility(
                visible: country != null,
                child: Text('+${country?.phoneCode}'),
              ),
              const SizedBox(
                width: 10,
              ),
              Container(
                width: sizeres.width * 0.7,
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: messageColor),
                  ),
                ),
                child: TextField(
                  decoration: const InputDecoration(
                      hintText: 'Phone Number', border: InputBorder.none),
                  controller: phoneController,
                ),
              )
            ],
          ),
          SizedBox(
            height: sizeres.height /2,
          ),
          CustomBtn(
              onPressed: () {
                if (phoneController.text.isEmpty || country == null) {
                  showSnacbar(
                    ctx: context,
                    content: 'Your  number text and country code null',
                  );
                } else {
                  ref.read(authControllerProvider).signwithPhone(
                      context, '+${country!.phoneCode}${phoneController.text}');
                }
              },
              text: 'Login')
        ],
      ),
    
    );
  }
}
