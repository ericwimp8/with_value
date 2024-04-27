import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:with_value/src/with_value.dart';

void main() {
  testWidgets('WithValueUpdate.of finds the correct notifier',
      (WidgetTester tester) async {
    final notifier = TestNotifier(0);
    await tester.pumpWidget(
      WithValueUpdate<ChangeNotifier>(
        notifier: notifier,
        child: Container(),
      ),
    );

    final foundNotifier = WithValueUpdate.of<ChangeNotifier>(
        tester.element(find.byType(Container)));

    expect(foundNotifier, equals(notifier));
  });

  testWidgets('WithValueUpdate.of throws an error if not found',
      (WidgetTester tester) async {
    await tester.pumpWidget(Container());

    expect(
      () => WithValueUpdate.of<ChangeNotifier>(
          tester.element(find.byType(Container))),
      throwsA(isInstanceOf<FlutterError>()),
    );
  });

  testWidgets(
      'WithValueUpdate.updateShouldNotify returns true if shouldNotify returns true',
      (WidgetTester tester) async {
    final oldWidget = WithValueUpdate<TestNotifier>(
      notifier: TestNotifier(0),
      child: Container(),
      shouldNotify: (old) => true,
    );
    final newWidget = WithValueUpdate<TestNotifier>(
      notifier: TestNotifier(0),
      child: Container(),
      shouldNotify: (old) => true,
    );

    final result = newWidget.updateShouldNotify(oldWidget);
    final result0 = oldWidget.updateShouldNotify(oldWidget);

    expect(result, isTrue);
    expect(result0, isTrue);
  });

  testWidgets(
      'WithValueUpdate.updateShouldNotify returns false if shouldNotify returns false',
      (WidgetTester tester) async {
    final oldWidget = WithValueUpdate<ChangeNotifier>(
      notifier: TestNotifier(1),
      child: Container(),
      shouldNotify: (old) => false,
    );
    final newWidget = WithValueUpdate<ChangeNotifier>(
      notifier: TestNotifier(2),
      child: Container(),
      shouldNotify: (old) => false,
    );

    final result = newWidget.updateShouldNotify(oldWidget);
    final result0 = oldWidget.updateShouldNotify(oldWidget);
    expect(result, isFalse);
    expect(result0, isFalse);
  });

  testWidgets(
      'WithValueUpdate.updateShouldNotify returns true if notifiers are not equal',
      (WidgetTester tester) async {
    final oldWidget = WithValueUpdate<ChangeNotifier>(
      notifier: TestNotifier(1),
      child: Container(),
    );
    final newWidget = WithValueUpdate<ChangeNotifier>(
      notifier: TestNotifier(2),
      child: Container(),
    );

    final result = newWidget.updateShouldNotify(oldWidget);
    expect(result, isTrue);
  });
}

class TestNotifier extends ChangeNotifier {
  TestNotifier(this.value);
  final int value;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TestNotifier && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}
