import 'package:flutter/material.dart';
import 'package:inventory_management_system_3/providers/add_provider.dart';
import 'package:provider/provider.dart';

class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    //final counter = Provider.of<CounterProvider>(context);
    var addprovider = context.watch<AddProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Counter Page"),
        backgroundColor: Colors.green,
        elevation: 20,
      ),
      body: Center(
        child: Text(
          textAlign: TextAlign.center,
          "You have pushed the button \n ${addprovider.count} times ",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addprovider.increment();
        },
        backgroundColor: const Color.fromARGB(255, 4, 131, 8),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
