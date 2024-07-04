import 'package:flutter/material.dart';
//import 'package:inventory_management_system_2/views/settingspage.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key, required this.onSelectScreen});

  final void Function(String identifier) onSelectScreen;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primaryContainer,
                Theme.of(context).colorScheme.primaryContainer.withOpacity(0.8),
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.bottomLeft,
            )),
            child: Row(
              children: [
                Icon(
                  Icons.store,
                  size: 55,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  "Invento",
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                )
              ],
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.home,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
            title: Text(
              "Home",
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontSize: 18,
                  ),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.inventory,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
            title: Text(
              "Inventory",
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontSize: 18,
                  ),
            ),
            onTap: () {
              //Navigator.pop(context);
              onSelectScreen('inventory_items');
            },
          ),
          ListTile(
            leading: Icon(
              Icons.settings,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
            title: Text(
              "Settings",
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontSize: 18,
                  ),
            ),
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => const SettingsPage(),
              //   ),
              // );
              onSelectScreen('settings');
            },
          ),
           ListTile(
            leading: Icon(
              Icons.add,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
            title: Text(
              "Counter",
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontSize: 18,
                  ),
            ),
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => const SettingsPage(),
              //   ),
              // );
              onSelectScreen('counter');
            },
          )
        ],
      ),
    );
  }
}
