library with_value;

import 'package:flutter/material.dart';

/// A specialized [InheritedNotifier] for managing state with a [ChangeNotifier].
///
/// This widget is designed to provide an instance of a [ChangeNotifier] down the widget tree,
/// allowing its descendants to listen to changes and rebuild accordingly.
///
/// Generics:
///   T - The type of the `ChangeNotifier` being provided.
///   K - The type of the `ChangeNotifier` when using the `of` method.
///
/// Parameters:
///   [notifier] specifies the [ChangeNotifier] instance to provide to the widgets in the subtree.
///   IMPORTANT: To ensure the proper functionality of updateShouldNotify, the provided notifier should override the `==` and `hashCode` methods,
///   or [shouldNotify] should be provided.
///   [child] is the widget below this widget in the tree. This widget can access the provided value.
///   [key] is an optional key that controls how one widget replaces another widget in the tree.
///   [shouldNotify]  is an optional callback to determine if dependents should be notified about updates.
///
/// [WithValueUpdate] includes a [WithValueUpdate.of] to retrieve the nearest [WithValueUpdate] up the widget tree
/// and return its [notifier]. If the `InheritedNotifier` is not found, a `AssertionError` is thrown.
///
/// Example Usage:
///
/// ```dart
/// class MyNotifier extends ChangeNotifier {
///   int value = 0;
///
/// @override
/// bool operator ==(Object other) {
///   if (identical(this, other)) return true;
///
///   return other is MyNotifier && other.value == value;
/// }
///
///   @override
///   int get hashCode => value.hashCode;
/// }
///
/// // Wrap your widget tree with [WithValueUpdate] and provide an instance of MyNotifier
/// Widget build(BuildContext context) {
///   return WithValueUpdate<MyNotifier>(
///     notifier: MyNotifier(),
///     child: MyApp(),
///   );
/// }
///
/// // Access the notifier in a descendant widget
/// class MyWidget extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) {
///     final myNotifier = WithValueUpdate.of<MyNotifier>(context);
///     return Text(myNotifier.value.toString());
///   }
/// }
/// ```
class WithValueUpdate<T extends Listenable> extends InheritedNotifier<T> {
  const WithValueUpdate({
    required T super.notifier,
    required super.child,
    this.shouldNotify,
    super.key,
  });

  /// An optional callback to determine if dependents should be notified about updates.
  final bool Function(
    WithValueUpdate<T> oldWidget,
    WithValueUpdate<T> newWidget,
  )? shouldNotify;

  /// Retrieves the nearest [WithValueUpdate] up the widget tree and returns its [notifier].
  /// Throws a [AssertionError] if no [WithValueUpdate] is found with the appropriate type.
  ///
  /// [context] - The build context from which the widget tree is accessed.
  static K of<K extends ChangeNotifier>(
    BuildContext context,
  ) {
    final result =
        context.dependOnInheritedWidgetOfExactType<WithValueUpdate<K>>();
    // TODO(ericwimp): implement this as listen: false for usage inside initState
    // final foo = context
    //     .getElementForInheritedWidgetOfExactType<WithUpdate<K>>()!
    //     .widget as InheritedWidget;
    assert(
      result != null,
      '$K was not found in the widget tree. Make sure to wrap your widget tree with a WithValueUpdate<$K>.',
    );

    return result!.notifier!;
  }

  /// Retrieves the nearest [WithValueUpdate] up the widget tree and returns.
  /// Throws a [AssertionError] if no [WithValueUpdate] is found with the appropriate type.
  ///
  /// [context] - The build context from which the widget tree is accessed.
  static K notifierOf<K extends InheritedNotifier>(
    BuildContext context,
  ) {
    final result = context.dependOnInheritedWidgetOfExactType<K>();
    // TODO(ericwimp): implement this as listen: false for usage inside initState
    // final foo = context
    //     .getElementForInheritedWidgetOfExactType<WithUpdate<K>>()!
    //     .widget as InheritedWidget;
    assert(
      result != null,
      '$K was not found in the widget tree. Make sure to wrap your widget tree with a $K.',
    );

    return result!;
  }

  // IMPORTANT: To ensure proper functionality, the provided notifier should override the `==` and `hashCode` methods.
  // or [shouldNotify] should be provided.
  @override
  bool updateShouldNotify(WithValueUpdate<T> oldWidget) =>
      shouldNotify?.call(oldWidget, this) ?? oldWidget.notifier != notifier;
}

/// A Flutter widget that inherits from [InheritedWidget] to provide a specific value down the widget tree.
///
/// This widget is generic and can be used with any type of value. It is particularly useful
/// for providing data directly to multiple widgets in the subtree without having to pass
/// the data through multiple widget constructors.
///
/// Generics:
///   T - The type of the value being provided down the widget tree.
///
/// Parameters:
///   [value] - The data value to be provided to the widgets in the subtree.
///   IMPORTANT: To ensure proper functionality, if the value is not a primitive type, it should override the `==` and `hashCode` methods.
///   [child] - The widget below this widget in the tree. This widget can access the provided value.
///   [key] - An optional key that controls how one widget replaces another widget in the tree.
///
/// [WithValue] includes [WithValue.of] to retrieve the nearest [WithValue] up the widget tree
/// and return its [value]. If the `InheritedWidget` is not found, a `AssertionError` is thrown.
///
/// Example Usage:
///
/// ```dart
/// WithValue<int>(
///   value: 42,
///   child: MyWidget(),
/// )
/// ```
///
/// To retrieve the value:
/// ```dart
/// // Access the value in a descendant widget
/// int value = WithValue.of<int>(context);
/// ```
class WithValue<T> extends InheritedWidget {
  const WithValue({
    required super.child,
    required this.value,
    super.key,
  });

  /// The value provided to the subtree.
  final T value;

  /// Retrieves the value of type [T] from the nearest ancestor [WithValue] widget.
  ///
  /// Throws an AssertionError if the [WithValue] widget is not found in the widget tree.
  static T of<T>(BuildContext context) {
    final result = maybeOf<T>(context);
    assert(
      result != null,
      'WithValue<$T> was not found in the widget tree. Make sure to wrap your widget tree with a Withvalue<$T>.',
    );
    return result!;
  }

  /// Attempts to retrieve the value of type [T] from the nearest ancestor [WithValue] widget.
  ///
  /// Returns null if the [WithValue] widget is not found in the widget tree.
  static T? maybeOf<T>(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<WithValue<T>>()?.value;
  }

  /// IMPORTANT: To ensure proper functionality if `value` is not a primitive type it should override the `==` and `hashCode` methods.
  @override
  bool updateShouldNotify(WithValue<T> oldWidget) {
    return oldWidget.value != value;
  }
}
