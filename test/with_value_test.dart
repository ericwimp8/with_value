import 'package:flutter/material.dart';
import 'package:with_value/with_value.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('WithValue Widget Tests', () {
    testWidgets('Provides value to a child widget.',
        (WidgetTester tester) async {
      const int testValue = 42;

      await tester.pumpWidget(
        MaterialApp(
          home: WithValue<int>(
            value: testValue,
            child: Builder(
              builder: (BuildContext context) {
                return Text(WithValue.of<int>(context).toString());
              },
            ),
          ),
        ),
      );

      expect(find.text(testValue.toString()), findsOneWidget);
    });

    testWidgets(
        'throws assertion error if WithValue not found in the widget tree',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (BuildContext context) {
              expect(() => WithValue.of<int>(context), throwsAssertionError);
              return const Placeholder();
            },
          ),
        ),
      );
    });

    testWidgets('Does not rebuild when value does not change',
        (WidgetTester tester) async {
      final globalKey = GlobalKey();
      await tester.pumpWidget(
        TestWidget(
          key: globalKey,
          value: 0,
        ),
      );

      await tester.pumpWidget(
        TestWidget(
          key: globalKey,
          value: 0,
        ),
      );
      // Check parent widget rebuilds where value is set to the same value
      expect(find.text('2'), findsOneWidget);
      // Check child widget rebuilds where value should not trigger a rebuild
      expect(find.text('1'), findsOneWidget);
    });
  });
}

class TestWidget extends StatefulWidget {
  const TestWidget({super.key, required this.value});

  final int value;

  @override
  State<TestWidget> createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> {
  int rebuilds = 0;
  @override
  Widget build(BuildContext context) {
    rebuilds++;
    return MaterialApp(
      home: WithValue(
        value: widget.value,
        child: Builder(builder: (context) {
          return Column(
            children: [
              Text(rebuilds.toString()),
              const Child(),
            ],
          );
        }),
      ),
    );
  }
}

class Child extends StatefulWidget {
  const Child({
    super.key,
  });

  @override
  State<Child> createState() => _ChildState();
}

class _ChildState extends State<Child> {
  int rebuilds = 0;
  @override
  Widget build(BuildContext context) {
    WithValue.of<int>(context);
    rebuilds++;
    return Text(rebuilds.toString());
  }
}
