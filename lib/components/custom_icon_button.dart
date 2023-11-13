import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
class CustomIconButton extends StatelessWidget {
   CustomIconButton({Key? key, required this.icon, required this.onPressed})
    :super(key: key);

final IconData icon;
final void Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed, 
    icon: Icon(icon, size: 50, 
    color: AppColors.white,));
  }
}