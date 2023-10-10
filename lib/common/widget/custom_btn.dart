import 'package:flutter/material.dart';

class CustomBtn extends StatelessWidget {
  final void Function()? onPressed;
  final String text;
  const CustomBtn({super.key,required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width/1.5,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(text,style: Theme.of(context).textTheme.labelMedium,),
      ),
    );
  }
}