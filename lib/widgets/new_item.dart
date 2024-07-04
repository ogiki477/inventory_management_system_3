// import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:inventory_management_system_3/model/SQLHelper.dart';
import 'package:inventory_management_system_3/model/inventory.dart';
// import 'package:http/http.dart' as http;

class NewItem extends StatefulWidget {
  final Inventory? inventory;

  const NewItem({super.key, this.inventory});

  @override
  State<NewItem> createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  final _formKey = GlobalKey<FormBuilderState>();
  final SQLHelper helper = SQLHelper();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          top: 15,
          left: 15,
          right: 15,
          bottom: MediaQuery.of(context).viewInsets.bottom + 120,
        ),
        child: FormBuilder(
          key: _formKey,
          initialValue: {
            'name': widget.inventory?.name,
            'description': widget.inventory?.description,
            'quantity': widget.inventory?.quantity.toString(),
            'price': widget.inventory?.price.toString(),
          },
          child: Column(
            children: [
              FormBuilderTextField(
                name: "name",
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: FormBuilderValidators.required(),
                decoration: const InputDecoration(
                  labelText: "Item Name",
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              FormBuilderTextField(
                name: "description",
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: FormBuilderValidators.required(),
                decoration: const InputDecoration(labelText: "Description"),
              ),
              const SizedBox(
                height: 10,
              ),
              FormBuilderTextField(
                name: "quantity",
                keyboardType: TextInputType.number,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
                decoration: const InputDecoration(
                  labelText: "Quantity",
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              FormBuilderTextField(
                name: "price",
                keyboardType: TextInputType.number,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: FormBuilderValidators.compose(
                    [FormBuilderValidators.required()]),
                decoration: const InputDecoration(
                    labelText: "Price", prefixText: "\$ "),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState?.saveAndValidate() ?? false) {
                        final formData = _formKey.currentState?.value;

                        var inventory = Inventory(
                          id: widget
                              .inventory?.id, // Use the existing id if updating
                          name: formData?['name'],
                          description: formData?['description'],
                          quantity: double.parse(formData?['quantity']),
                          price: double.parse(formData?['price']),
                        );

                        if (widget.inventory == null) {
                          await helper.createItem(inventory); // for sqflite
                          // final url = Uri.https(
                          //     'flutter-prep-d4ea8-default-rtdb.firebaseio.com',
                          //     'inventory-list.json');
                          // final response = await http.post(url,
                          //     headers: {
                          //       'Content-Type': 'application/json',
                          //     },
                          //     body: json.encode({
                          //       'name': formData?['name'],
                          //       'description': formData?['description'],
                          //       'quantity': double.parse(formData?['quantity']),
                          //       'price': double.parse(formData?['price']),
                          //     }));
                          // final resData = json.decode(response.body);
                        } else {
                          await helper.updateItem(inventory);
                        }

                        if (!context.mounted) {
                          return;
                        }

                        Navigator.pop(context);
                      }
                    },
                    child: Text(
                        widget.inventory == null ? "Add Item" : "Update Item"),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cancel"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
