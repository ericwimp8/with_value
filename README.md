## IMPORTANT

This is a simple state management library used in packages. I don't want to rely on Provider as a dependency.

The selector is straight out of Provider.

There is no support for this package; please use Provider if you want InheritedWidget as state management.

## WithValue

- `WithValue` is an `InheritedWidget` that allows you to provide a value to a subtree of widgets and retrieve that value using `WithValue.of<T>(context)`.
- Make sure to override the `==` and `hashCode` methods for non-primitive types to ensure proper functionality.
- Example usage:

```dart
WithValue<int>(
  value: 42,
  child: MyWidget(),
)

int value = WithValue.of<int>(context);
```

## Usage

- `WithValueUpdate` is an `InheritedNotifier` that allows you to provide and update a value to a subtree of widgets and retrieve that value using `WithValueUpdate.of<T>(context)`.
- Make sure to override the `==` and `hashCode` methods for non-primitive types to ensure proper functionality.
- Example usage:

```dart
WithValueUpdate<MyNotifier>(
  notifier: myNotifier,
  child: MyWidget(),
)

MyNotifier notifier = WithValueUpdate.of<MyNotifier>(context);

```
