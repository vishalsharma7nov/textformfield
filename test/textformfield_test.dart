import 'package:app_theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:textformfield/textformfield.dart';

CustomTextFormField _field(
  TextEditingController controller, {
  TextInputAction action = TextInputAction.done,
  Iterable<String>? autofillHints,
  String? errorText,
}) =>
    CustomTextFormField(
      controller: controller,
      hasFocus: (_) {},
      onChanged: (_) {},
      onEditingComplete: () {},
      textInputAction: action,
      autofillHints: autofillHints,
      errorText: errorText,
    );

Widget _app(List<Widget> children) =>
    MaterialApp(home: Scaffold(body: Column(children: children)));

void main() {
  testWidgets('passes autofill hints to the text field', (tester) async {
    await tester.pumpWidget(_app([
      _field(TextEditingController(),
          autofillHints: const [AutofillHints.email]),
    ]));

    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.autofillHints, [AutofillHints.email]);
  });

  testWidgets('next moves focus to the following field', (tester) async {
    final first = TextEditingController();
    final second = TextEditingController();
    await tester.pumpWidget(_app([
      _field(first, action: TextInputAction.next),
      _field(second),
    ]));

    await tester.tap(find.byType(TextField).first);
    await tester.testTextInput.receiveAction(TextInputAction.next);
    await tester.pump();

    final focused = tester.widget<EditableText>(find.byType(EditableText).last);
    expect(focused.focusNode.hasFocus, isTrue);
  });

  testWidgets('shows the error under the field', (tester) async {
    await tester.pumpWidget(_app([
      _field(TextEditingController(), errorText: 'Enter a valid email'),
    ]));

    expect(find.text('Enter a valid email'), findsOneWidget);
  });

  testWidgets('no error text by default', (tester) async {
    await tester.pumpWidget(_app([_field(TextEditingController())]));

    expect(find.byKey(CustomTextFormField.errorKey), findsNothing);
  });

  testWidgets('follows the dark palette for text and box', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(extensions: const [AppPalette.dark]),
        home: Scaffold(body: _field(TextEditingController())),
      ),
    );

    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.style?.color, AppPalette.dark.black900);

    final box = tester.widget<Container>(
      find
          .ancestor(
              of: find.byType(TextField), matching: find.byType(Container))
          .first,
    );
    final decoration = box.decoration! as BoxDecoration;
    expect(decoration.color, AppPalette.dark.greyColor);
    expect((decoration.border! as Border).top.color, AppPalette.dark.grey100);
  });

  testWidgets('focused border follows the theme brand colour', (tester) async {
    final theme = AppTheme.dark(season: SeasonalTheme.halloween);
    await tester.pumpWidget(
      MaterialApp(
        theme: theme,
        home: Scaffold(body: _field(TextEditingController())),
      ),
    );

    final field = tester.widget<TextField>(find.byType(TextField));
    final border = field.decoration!.focusedBorder! as OutlineInputBorder;
    expect(
        border.borderSide.color, theme.extension<BrandColors>()!.brandPrimary);
  });
}
