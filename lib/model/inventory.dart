class Inventory {
  int? _id;
  String _name;
  String _description;
  double _quantity;
  double _price;

  Inventory({
    int? id,
    required String name,
    required String description,
    required double quantity,
    required double price,
  })  : _id = id,
        _name = name,
        _description = description,
        _quantity = quantity,
        _price = price;

  Inventory.fromMap(Map<String, dynamic> data)
      : _id = data['id'],
        _name = data['name'],
        _description = data['description'],
        _quantity = data['quantity'],
        _price = data['price'];

  Map<String, dynamic> toMap() {
    var map = {
      'name': _name,
      'description': _description,
      'quantity': _quantity,
      'price': _price,
    };
    if (_id != null) {
      map['id'] = _id as Object;
    }
    return map;
  }

  int? get id => _id;
  String get name => _name;
  String get description => _description;
  double get quantity => _quantity;
  double get price => _price;
}
