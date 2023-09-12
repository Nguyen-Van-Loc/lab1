class User{
  int _id;
  String _name;
  String _address;
  String _phone;

  User(this._id, this._name, this._address, this._phone);

  String get phone => _phone;

  set phone(String value) {
    _phone = value;
  }

  String get address => _address;

  set address(String value) {
    _address = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }
}