// import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:inventory_management_system_3/model/SQLHelper.dart';
import 'package:inventory_management_system_3/model/inventory.dart';
import 'package:inventory_management_system_3/views/counterpage.dart';
import 'package:inventory_management_system_3/views/detailspage.dart';
import 'package:inventory_management_system_3/views/settingspage.dart';
import 'package:inventory_management_system_3/widgets/main_drawer.dart';
import 'package:inventory_management_system_3/widgets/new_item.dart';
// import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SQLHelper _sqlHelper = SQLHelper();
  // List<Inventory> _inventoryItems = []; // for firebase
  // List<Inventory> displayedItems =
  //     []; // items to display in ListView for firebase
  List<Map<String, dynamic>> allItems = [];
  List<Map<String, dynamic>> items = [];
  TextEditingController toSearch = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    //for sqlite
    _refreshInventories();
  }

  // @override
  // void initState() {
  //   super.initState();
  //   //for firebase
  //   _loadInventories();
  //   _isLoading = false;
  // }

  //for firebase
  // void _loadInventories() async {
  //   final url = Uri.https('flutter-prep-d4ea8-default-rtdb.firebaseio.com',
  //       'inventory-list.json');
  //   final response = await http.get(url);
  //   final Map<String, dynamic> itemData = json.decode(response.body);
  //   final List<Inventory> loadedItems = [];
  //   for (final item in itemData.entries) {
  //     loadedItems.add(Inventory(
  //       id: item.key, // String id from Firebase
  //       name: item.value['name'],
  //       description: item.value['description'],
  //       quantity: item.value['quantity'],
  //       price: item.value['price'],
  //     ));
  //   }
  //   setState(() {
  //     _inventoryItems = loadedItems;
  //     displayedItems = List.from(loadedItems); // Initially display all items
  //   });
  // }

//for sqlite
  void _refreshInventories() async {
    final data = await _sqlHelper.getItems();
    setState(() {
      allItems = data;
      items = List.from(allItems);
      _isLoading = false;
    });
  }

  // Filter search results for firebase
  // void filterSearch(String query) {
  //   if (query.isNotEmpty) {
  //     setState(() {
  //       displayedItems = _inventoryItems
  //           .where(
  //               (item) => item.name.toLowerCase().contains(query.toLowerCase()))
  //           .toList();
  //     });
  //   } else {
  //     setState(() {
  //       displayedItems = List.from(_inventoryItems); // Reset to show all items
  //     });
  //   }
  // }

  //filter search for sqlite

  void filterSearch(String query) {
    if (query.isNotEmpty) {
      setState(() {
        items = allItems
            .where((item) =>
                item['name'].toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    } else {
      setState(() {
        items = List.from(allItems); // Reset to show all items
      });
    }
  }

  //for Sqlite
  void openBottomSheet({Inventory? inventory}) {
    showModalBottomSheet(
      context: context,
      builder: (context) => NewItem(inventory: inventory),
      isScrollControlled: true,
    ).then((_) {
      _refreshInventories(); //for sqlite
    });
  }

  //For Firebase
  // void openBottomSheet({Inventory? inventory}) async {
  //   showModalBottomSheet(
  //     context: context,
  //     builder: (context) => NewItem(inventory: inventory),
  //     isScrollControlled: true,
  //   );
  //   _loadInventories();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Inventory Items"),
        backgroundColor: Colors.green,
        elevation: 20,
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      drawer: MainDrawer(onSelectScreen: _setScreen),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    onChanged: filterSearch,
                    controller: toSearch,
                    decoration: const InputDecoration(
                      labelText: "Search",
                      hintText: "Search..",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(25),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: items.isEmpty
                      ? Center(
                          child: Text(
                            'No items !!!',
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer,
                                    ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: items.length, //for sqlite
                          itemBuilder: (context, index) {
                            var item = items[index];
                            // itemCount: displayedItems.length, //for firebase
                            // itemBuilder: (context, index) {
                            //   //for firebase
                            //   var item = displayedItems[index]; //for firebase
                            return Dismissible(
                              key: ValueKey(item['id']), // for sqlite
                              // key: ValueKey(item.id), // for firebase
                              onDismissed: (direction) {
                                _sqlHelper.deleteItem(item['id']); // for sqlite
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Item deleted"),
                                  ),
                                );
                                _refreshInventories();
                              },
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      //for sqlite
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              DetailsPage(item: item)));

                                  // Navigator.push(
                                  //     // for firebase
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) =>
                                  //             DetailsPage(item: item.toMap())));
                                },
                                child: Card(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondaryContainer,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 30,
                                      vertical: 20,
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item['name'], //sqlite
                                                // item.name, //firebase
                                                overflow: TextOverflow.ellipsis,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge!
                                                    .copyWith(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onPrimaryContainer,
                                                      fontSize: 28,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                              ),
                                              Text(
                                                'Description: ${item['description']}', //sqlite
                                                // 'Description: ${item.description}', // firebase
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                                maxLines: 1,
                                              ),
                                              Text(
                                                'Quantity:  ${item['quantity'].toString()}', //sqlite
                                                // 'Quantity:  ${item.quantity.toString()}', // for firebase
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                'Price: \$ ${item['price'].toString()}', //sqlite
                                                // 'Price: \$ ${item.price.toString()}', // for firebase
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            Icons.edit,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimaryContainer,
                                          ),
                                          onPressed: () => openBottomSheet(
                                            inventory: Inventory.fromMap(
                                                item), //sqlite
                                            // inventory: item,//firebase
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete_forever,
                                            color: Colors.red,
                                          ),
                                          onPressed: () {
                                            _sqlHelper.deleteItem(
                                                item['id']); //sqlite
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text("Item deleted"),
                                              ),
                                            );
                                            _refreshInventories();
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    //mainAxisSize: MainAxisSize.min,
                    children: [
                      FloatingActionButton(
                        onPressed: openBottomSheet,
                        backgroundColor:
                            Theme.of(context).colorScheme.secondaryContainer,
                        child: const Text(
                          "+Add",
                          style: TextStyle(
                            fontSize: 15,
                            //fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  void _setScreen(String identifier) {
    Navigator.pop(context);
    if (identifier == 'settings') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SettingsPage(),
        ),
      );
    } else if (identifier == 'counter') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const CounterPage(),
        ),
      );
    }
  }
}
