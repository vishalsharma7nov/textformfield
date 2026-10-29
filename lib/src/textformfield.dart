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

  /// Lets the OS fill the field, e.g. [AutofillHints.email] or
  /// [AutofillHints.oneTimeCode].
  final Iterable<String>? autofillHints;

  /// Shown under the field while non-null. The fixed [height] leaves no room
  /// for [validator] messages inside the box, so screens pass errors here.
  final String? errorText;

  static const Key errorKey = ValueKey('custom-text-form-field-error');

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
    this.hintTextColor,
    this.prefixStyle,
    this.contentPadding = EdgeInsets.zero,
    this.autoFocus = false,
    this.textCapitalization = TextCapitalization.none,
    this.focusNode,
    this.textAlignVertical,
    this.autofillHints,
    this.errorText,
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
        final errorText = widget.errorText;
        final colors = context.colors;
        final field = Container(
          decoration: BoxDecoration(
            color: colors.greyColor,
            borderRadius: BorderRadius.all(
              Radius.circular(widget.containerBorderRadius),
            ),
            border: Border.all(
              color: colors.grey100,
            ),
          ),
          height: widget.height,
          width: widget.width,
          child: Focus(
            // Only reports focus; Next must land on the text field inside.
            skipTraversal: true,
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
              style: TextStyle(
                color: colors.black900,
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
                      fillColor: isFilled ? colors.white000 : colors.greyColor,
                      hintText: widget.hintText,
                      contentPadding: widget.contentPadding,
                      hintStyle: TextStyle(
                        fontSize: widget.hintFontSize,
                        color: widget.hintTextColor ?? colors.black,
                      ),
                      errorStyle: TextStyle(
                        color: colors.errorColor,
                        fontSize: 14,
                        height: .1,
                      ),
                      prefixIcon: widget.prefixIcon,
                      prefixText: widget.prefixText,
                      prefixStyle: widget.prefixStyle,
                      suffixIcon: widget.suffixIcon,
                      border: InputBorder.none,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                        borderSide: BorderSide(
                          width: 2,
                          color: context.brand.brandPrimary,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                        borderSide: BorderSide(
                          width: 1.5,
                          color: colors.errorColor,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                        borderSide: BorderSide(
                          width: 1.5,
                          color: colors.errorColor,
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
                if (widget.textInputAction == TextInputAction.next) {
                  FocusScope.of(context).nextFocus();
                } else {
                  FocusScope.of(context).unfocus();
                }
                _isFilled.value = false;
                widget.onEditingComplete();
              },
              validator: widget.validator,
              autofillHints: widget.autofillHints,
            ),
          ),
        );
        if (errorText == null) return field;
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            field,
            Padding(
              padding: const EdgeInsetsDirectional.only(top: 6, start: 4),
              child: Semantics(
                liveRegion: true,
                child: Text(
                  errorText,
                  key: CustomTextFormField.errorKey,
                  style: TextStyle(color: colors.errorColor, fontSize: 13),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  onChangedValue(value) {
    return value;
  }
}
