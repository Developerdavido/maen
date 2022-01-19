import 'package:maen/widgets/constants.dart';
import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData data;
  final String initialValue;
  final Function(String) onChanged;
  final Function(String) validator;
  final Function(String) onSubmitted;
  final FocusNode focusNode;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final bool isPasswordField;

  CustomInput({Key key, this.initialValue, this.keyboardType,  this.controller, this.data, this.hintText,this.validator,this.onSubmitted, this.onChanged, this.focusNode, this.textInputAction, this.isPasswordField}): super (key: key);

  @override
  Widget build(BuildContext context) {
    bool _isPasswordField = isPasswordField ?? false;
    final Color icon_color = Color(0xFF8E93FF);

    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 24.0,
      ),
      decoration: BoxDecoration(
        color: Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(12.0)
      ),
      child: TextFormField(
        controller: controller,
        obscureText: _isPasswordField,
        focusNode: focusNode,
        onChanged: onChanged,
        onFieldSubmitted: onSubmitted,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        initialValue: initialValue,
        validator: validator,
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(data,
          color: icon_color,),
          hintText: hintText ?? "Hint Text...",
          contentPadding: EdgeInsets.symmetric(
            horizontal: 24.0,
            vertical: 20.0,
          ),
          focusColor: Theme.of(context).primaryColor,
        ),
        style: Constants.regularDarkText,
      ),
    );
  }
}
