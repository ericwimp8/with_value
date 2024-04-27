import 'package:flutter/material.dart';
import 'package:with_value/with_value.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return WithValue<String>(
      value: 'Hello, World!',
      child: MaterialApp(
        title: 'WithValue Example',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return WithValueUpdate(
      notifier: Incrementer(),
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('WithValue Example'),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  WithValue.of<String>(context),
                ),
                Text(
                  WithValueUpdate.of<Incrementer>(context).value.toString(),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    WithValueUpdate.of<Incrementer>(context).increment();
                  },
                  child: const Text('Increment'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    WithValueUpdate.of<Incrementer>(context).decrement();
                  },
                  child: const Text('Increment Async'),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class Incrementer with ChangeNotifier {
  int _value = 0;
  int get value => _value;

  void increment() {
    _value++;
    notifyListeners();
  }

  void decrement() {
    _value--;
    notifyListeners();
  }
}
