import 'package:flutter/material.dart';
import 'employee.dart';
import 'employee_bloc.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /// create a Bloc object
  final EmployeeBloc _employeeBloc = EmployeeBloc();

  @override
  void dispose() {
    // TODO: implement dispose
    _employeeBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Employees"),
      ),
      body: Container(
        child: returnStreamBuilder(),
      ),
    );
  }

  returnStreamBuilder() {
    return StreamBuilder<List<Employee>>(
      stream: _employeeBloc.employeeListStream,
      builder: (BuildContext context, AsyncSnapshot<List<Employee>> snapshot) {
        return returnListView(snapshot.data);
      },
    );
  }

  returnListView(List<Employee> employees) {
    return ListView.builder(
      itemCount: employees.length,
      itemBuilder: (context, index) {
        return returnEmployeeCard(employees[index]);
      },
    );
  }

  returnEmployeeCard(Employee employee) {
    return Card(
      elevation: 2.5,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          returnEmployeeID(employee.id),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              returnEmployeeName(employee.name),
              returnEmployeeSalary(employee.salary),
            ],
          ),
          returnThumpUp(employee),
          returnThumpDown(employee),
        ],
      ),
    );
  }

  returnEmployeeID(int id) {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Text(
        id.toString(),
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  returnEmployeeName(String name) {
    return Container(
      child: Text(
        name,
        style: TextStyle(fontSize: 18),
      ),
    );
  }

  returnEmployeeSalary(double salary) {
    return Container(
      child: Text(
        "\$" + salary.toString(),
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  /// In either of the below two functions, this what happens under the hood

  /// 1. Since we setup a [bloc] object at the beginning of the application,
  /// we also setup the [StreamController] responsible to update the employee list
  /// whenever an increment or decrement occurs to one of the employee.

  /// 2. we associated with the [onPressed] function the [sink] of the
  /// [StreamController], which in turn is responsible to input data to the
  /// stream.

  /// 3. In the constructor of the [EmployeeBloc] class, we setup two listeners:
  /// a. one for incrementing the salary.
  /// b. the other for decrementing the salary.

  /// 4. Whenever the user presses on either of the buttons, the stream will
  /// be affected as follows: -
  /// a. If the triggering comes from [employeeSalaryIncrementSink], this means
  /// we have to increment the salary, since this sink listens to the main sink,
  /// and whenever it's triggered, it applies [_incrementSalary] function, and
  /// vice versa for decrementing. This causes the value to change, since the
  /// whole [StreamBuilder] needs to be rebuilt from scratch.

  returnThumpUp(Employee employee) {
    return Container(
      child: IconButton(
        icon: Icon(
          Icons.thumb_up,
          size: 25,
          color: Colors.green,
        ),
        onPressed: () {
          _employeeBloc.employeeSalaryIncrementSink.add(employee);
        },
      ),
    );
  }

  returnThumpDown(Employee employee) {
    return Container(
      child: IconButton(
        icon: Icon(
          Icons.thumb_down,
          size: 25,
          color: Colors.red,
        ),
        onPressed: () {
          _employeeBloc.employeeSalaryDecrementSink.add(employee);
        },
      ),
    );
  }
}
