import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monscolis/core/widgets/custom_button.dart';

void main() {
  group('CustomButton', () {
    testWidgets('renders correctly with text and icon',
        (WidgetTester tester) async {
      const buttonText = 'Test Button';
      const buttonIcon = Icons.add;
      var pressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              text: buttonText,
              icon: buttonIcon,
              onPressed: () => pressed = true,
            ),
          ),
        ),
      );

      // Verify button text and icon are rendered
      expect(find.text(buttonText), findsOneWidget);
      expect(find.byIcon(buttonIcon), findsOneWidget);

      // Verify button is enabled and clickable
      await tester.tap(find.byType(CustomButton));
      expect(pressed, isTrue);
    });

    testWidgets('renders correctly when disabled',
        (WidgetTester tester) async {
      const buttonText = 'Test Button';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              text: buttonText,
              onPressed: null, // Disabled button
            ),
          ),
        ),
      );

      // Verify button is rendered but disabled
      final button = tester.widget<ElevatedButton>(
        find.byType(ElevatedButton),
      );
      expect(button.onPressed, isNull);
    });

    testWidgets('shows loading indicator when isLoading is true',
        (WidgetTester tester) async {
      const buttonText = 'Test Button';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              text: buttonText,
              isLoading: true,
              onPressed: () {},
            ),
          ),
        ),
      );

      // Verify loading indicator is shown and text is hidden
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text(buttonText), findsNothing);
    });

    testWidgets('applies custom styles correctly', (WidgetTester tester) async {
      const buttonText = 'Test Button';
      const customColor = Colors.red;
      const customTextStyle = TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              text: buttonText,
              color: customColor,
              textStyle: customTextStyle,
              onPressed: () {},
            ),
          ),
        ),
      );

      // Verify custom styles are applied
      final button = tester.widget<ElevatedButton>(
        find.byType(ElevatedButton),
      );
      expect(
        button.style?.backgroundColor?.resolve({}),
        equals(customColor),
      );

      final text = tester.widget<Text>(find.text(buttonText));
      expect(text.style?.fontSize, equals(customTextStyle.fontSize));
      expect(text.style?.fontWeight, equals(customTextStyle.fontWeight));
    });

    testWidgets('handles long text correctly', (WidgetTester tester) async {
      const longText =
          'This is a very long button text that should be handled gracefully';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 200, // Constrained width
              child: CustomButton(
                text: longText,
                onPressed: () {},
              ),
            ),
          ),
        ),
      );

      // Verify text is rendered without overflow
      expect(find.text(longText), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('maintains minimum tap target size',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              text: 'Test',
              onPressed: () {},
            ),
          ),
        ),
      );

      // Verify minimum tap target size (48x48 pixels)
      final buttonSize = tester.getSize(find.byType(CustomButton));
      expect(buttonSize.height, greaterThanOrEqualTo(48.0));
      expect(buttonSize.width, greaterThanOrEqualTo(48.0));
    });
  });
}
