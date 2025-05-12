import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttervpndemo/core/service/theme/theme_helper.dart';
import 'package:fluttervpndemo/ui/helper/ui_helpers.dart';

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField({
    super.key,
    required this.textEditingController,
    this.enabled = true,
    this.maxLines,
    this.minLines,
    this.maxLength,
    this.onChanged,
    this.validator,
    this.hintText,
    this.backgroundColor,
    this.obscureText = false,
    this.textInputAction,
    this.onComplete,
    this.showLengthCounter,
    this.suffixIcon,
  });

  final TextEditingController textEditingController;
  final bool enabled;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final String? hintText;
  final Color? backgroundColor;
  final bool obscureText;
  final TextInputAction? textInputAction;
  final VoidCallback? onComplete;
  final bool? showLengthCounter;
  final Widget? suffixIcon;

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  int textLength = 0;
  late bool obscureTextBool;

  @override
  void initState() {
    super.initState();
    obscureTextBool = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.textEditingController,
      textInputAction: widget.textInputAction,
      enabled: widget.enabled,
      minLines: widget.minLines,
      maxLines: widget.maxLines,
      maxLength: widget.maxLength,
      onChanged: (String value) {
        setState(() => textLength = value.length);
        if (widget.onChanged != null) widget.onChanged!(value);
      },
      onEditingComplete: widget.onComplete,
      style: TextStyle(fontSize: FontSizeValue.normal),
      validator: widget.validator,
      obscureText: obscureTextBool,
      decoration: InputDecoration(
        counterText: '',
        suffixStyle: TextStyle(fontSize: FontSizeValue.small),
        suffixText: widget.obscureText
            ? null
            : (widget.maxLength != null && widget.showLengthCounter == true)
                ? '$textLength/${widget.maxLength.toString()}'
                : null,
        suffixIcon: widget.suffixIcon ??
            (widget.obscureText
                ? IconButton(
                    splashRadius: 20.r,
                    icon: Icon(
                      !obscureTextBool ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                      size: 17.r,
                    ),
                    onPressed: () => setState(() => obscureTextBool = !obscureTextBool),
                  )
                : null),
        contentPadding: EdgeInsets.symmetric(horizontal: 0.03.sw, vertical: 0.02.sh),
        filled: true,
        fillColor: widget.backgroundColor ?? context.colorScheme.surfaceBright,
        focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r), borderSide: BorderSide(color: context.customColorScheme.primaryRed)),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r), borderSide: BorderSide(color: context.customColorScheme.primaryRed)),
        disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r), borderSide: BorderSide.none),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r), borderSide: BorderSide.none),
        hintText: widget.hintText,
        hintStyle: TextStyle(
          fontSize: FontSizeValue.normal,
          color: context.customColorScheme.txtGrey,
        ),
      ),
    );
  }
}
