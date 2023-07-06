import 'package:flutter/material.dart';
import 'package:whizz/src/common/constants/constants.dart';

class QuizFormField extends StatelessWidget {
  const QuizFormField({
    super.key,
    this.keyboardType,
    this.onChanged,
    this.hintText,
    this.suffixIcon,
    this.prefixIcon,
    this.maxLines,
    this.maxLength,
    this.label,
  });

  final TextInputType? keyboardType;
  final void Function(String)? onChanged;
  final String? hintText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final int? maxLines;
  final int? maxLength;
  final Widget? label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 12,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
        ),
        borderRadius: BorderRadius.circular(
          Constants.kPadding.toDouble() / 2,
        ),
      ),
      child: TextFormField(
        keyboardType: keyboardType,
        onChanged: onChanged,
        style: Constants.textSubtitle,
        minLines: 1,
        maxLines: maxLines ?? 1,
        maxLength: maxLength,
        
        decoration: InputDecoration(
          hintText: hintText,
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
          isDense: true,
          contentPadding: EdgeInsets.zero,
          border: InputBorder.none,
          label: label,
        ),
      ),
    );
  }
}

class QuizDropDownField extends StatelessWidget {
  const QuizDropDownField({
    super.key,
    required this.onChanged,
    required this.items,
    this.label,
  });

  final void Function(Object?)? onChanged;
  final Widget? label;

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 12,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
        ),
        borderRadius: BorderRadius.circular(
          Constants.kPadding.toDouble() / 2,
        ),
      ),
      child: DropdownButtonFormField<String>(
        items: items
            .map<DropdownMenuItem<String>>(
              (val) => DropdownMenuItem(
                value: val,
                child: Text(val),
              ),
            )
            .toList(),
        onChanged: onChanged,
        value: items[0],
        decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.zero,
          label: label,
          border: InputBorder.none,
        ),
      ),
    );
  }
}