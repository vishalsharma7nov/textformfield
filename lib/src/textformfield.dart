part of '../textformfield.dart';

class CustomTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final double? width;
  final double height;
  final int maxLines;
  final Function() onEditingComplete;
  final String? hintText;
  final EdgeInsets padding;
  final TextInputType keyBoardType;
  final List<TextInputFormatter>? filteringTextInputFormatter;
  final TextInputAction textInputAction;
  final Function(String value) onChanged;
  final String? Function(String? value)? validator;
  final String? prefixText;
  final bool obscureText;
  final String? suffix;
  final double hintFontSize;
  final bool enabled;
  final EdgeInsets contentPadding;
  final double containerBorderRadius;
  final Widget? suffixIcon;
  final Icon? prefixIcon;
  final Color? hintTextColor;
  final TextStyle? prefixStyle;
  final Function(bool focus) hasFocus;
  final bool autoFocus;
  final TextCapitalization textCapitalization;
  final FocusNode? focusNode;
  final TextAlignVertical? textAlignVertical;

  const CustomTextFormField({
    super.key,
    this.width,
    required this.hasFocus,
    this.height = 48,
    required this.controller,
    this.hintFontSize = 14,
    this.obscureText = false,
    this.suffix,
    this.maxLines = 1,
    required this.onEditingComplete,
    this.hintText,
    required this.onChanged,
    this.validator,
    this.padding = EdgeInsets.zero,
    this.keyBoardType = TextInputType.text,
    this.filteringTextInputFormatter,
    this.prefixText,
    this.textInputAction = TextInputAction.done,
    this.enabled = true,
    this.containerBorderRadius = 0,
    this.suffixIcon,
    this.prefixIcon,
    this.hintTextColor = AppColor.blackColor,
    this.prefixStyle,
    this.contentPadding = EdgeInsets.zero,
    this.autoFocus = false,
    this.textCapitalization = TextCapitalization.none,
    this.focusNode,
    this.textAlignVertical,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool password = true;
  final ValueNotifier<bool> _isFilled = ValueNotifier(false);

  @override
  void dispose() {
    _isFilled.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _isFilled,
      builder: (context, isFilled, _) {
        return Container(
          decoration: BoxDecoration(
            color: isFilled ? AppColor.greyColor : AppColor.greyColor,
            borderRadius: BorderRadius.all(
              Radius.circular(widget.containerBorderRadius),
            ),
            border: Border.all(
              color: AppColor.grey100,
            ),
          ),
          height: widget.height,
          width: widget.width,
          child: Focus(
            onFocusChange: (hasFocus) {
              _isFilled.value = hasFocus;
              widget.hasFocus(hasFocus);
            },
            child: TextFormField(
              onTap: () {},
              focusNode: widget.focusNode,
              autofocus: widget.autoFocus,
              obscureText: widget.obscureText ? password : widget.obscureText,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              enabled: widget.enabled,
              textAlignVertical: widget.textAlignVertical,
              textCapitalization: widget.textCapitalization,
              style: const TextStyle(
                color: AppColor.black900,
              ),
              decoration: widget.maxLines != 1
                  ? InputDecoration.collapsed(
                      hintText: widget.hintText,
                      hintStyle: TextStyle(
                        fontSize: widget.hintFontSize,
                      ),
                    )
                  : InputDecoration(
                      filled: isFilled,
                      fillColor: isFilled ? AppColor.white000 : AppColor.greyColor,
                      hintText: widget.hintText,
                      contentPadding: widget.contentPadding,
                      hintStyle: TextStyle(
                        fontSize: widget.hintFontSize,
                        color: widget.hintTextColor,
                      ),
                      errorStyle: const TextStyle(
                        color: AppColor.errorColor,
                        fontSize: 14,
                        height: .1,
                      ),
                      prefixIcon: widget.prefixIcon,
                      prefixText: widget.prefixText,
                      prefixStyle: widget.prefixStyle,
                      suffixIcon: widget.suffixIcon,
                      border: InputBorder.none,
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                        borderSide: BorderSide(
                          width: 2,
                          color: AppColor.brandPrimary,
                        ),
                      ),
                      focusedErrorBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                        borderSide: BorderSide(
                          width: 1.5,
                          color: AppColor.errorColor,
                        ),
                      ),
                      errorBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                        borderSide: BorderSide(
                          width: 1.5,
                          color: AppColor.errorColor,
                        ),
                      ),
                    ),
              maxLines: widget.maxLines,
              scrollPadding: EdgeInsets.zero,
              onChanged: widget.onChanged,
              controller: widget.controller,
              keyboardType: widget.keyBoardType,
              textInputAction: widget.textInputAction,
              inputFormatters: widget.filteringTextInputFormatter,
              onTapOutside: (event) {
                FocusScope.of(context).unfocus();
              },
              onEditingComplete: () {
                FocusScope.of(context).unfocus();
                _isFilled.value = false;
                widget.onEditingComplete();
              },
              validator: widget.validator,
            ),
          ),
        );
      },
    );
  }

  onChangedValue(value) {
    return value;
  }
}
