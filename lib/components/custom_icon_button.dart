import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
class CustomIconButton extends StatelessWidget {
  CustomIconButton({Key? key, required this.icon}) : super(key: key);
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {},
        icon: Icon(
          icon,
          size: 50,
          color: AppColors.white,
        ));
  }
}