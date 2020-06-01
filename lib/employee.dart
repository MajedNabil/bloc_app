class Employee {
  int _id;
  String _name;
  double _salary;

  Employee(this._id, this._name, this._salary);

  // setters

  set salary(double value) {
    _salary = value;
  }

  set name(String value) {
    _name = value;
  }

  set id(int value) {
    _id = value;
  }

// getters
  double get salary => _salary;

  String get name => _name;

  int get id => _id;

}