/// 1: IMPORTS
/// 2: List of EMPLOYEES
/// 3: Stream Controllers
/// 4: Stream Sink getter
/// 5: Constructor - add data && listen to changes
/// 6: Core functions
/// 7: Dispose - in order to free resources

import 'dart:async';
import 'employee.dart';

class EmployeeBloc {
  /// Sink to add to the pipe
  /// Stream to output to the pipe
  /// The [pipe] is the data flow. Data goes from the [sink]
  /// port, then they get outputted from the [stream] port.

  List<Employee> _employees = [
    Employee(1, 'Employee 1 ', 2000),
    Employee(2, 'Employee 2 ', 3000),
    Employee(3, 'Employee 3 ', 4000),
  ];

  final _employeeListStreamController = StreamController<List<Employee>>();

  /// for increment and decrement the salary.
  /// Personal note: I think the rule of thumb here: for whatever data, we should
  /// create an object from StreamController

  final _employeeSalaryIncrementStreamController = StreamController<Employee>();
  final _employeeSalaryDecrementStreamController = StreamController<Employee>();

  /// Getters

  /// This is used to get the output of the stream regarding the employee list.
  Stream<List<Employee>> get employeeListStream =>
      _employeeListStreamController.stream;

  /// This is used to provide data to the pipe (through the sink port), in order
  /// to get processed by the pipe, and then outputted from the other end
  /// (i.e., stream)
  StreamSink<List<Employee>> get employeeListSink =>
      _employeeListStreamController.sink;

  /// Now it's time to set sinks for the increment and decrement actions.
  StreamSink<Employee> get employeeSalaryIncrementSink =>
      _employeeSalaryIncrementStreamController.sink;

  StreamSink<Employee> get employeeSalaryDecrementSink =>
      _employeeSalaryDecrementStreamController.sink;

  /// Notice that we didn't have to create any [stream] for them, since here
  /// we're intersted only in the input, hence we used sinks only.

  /// Constructor

  EmployeeBloc(){
    /// Initialize the data
    _employeeListStreamController.add(_employees);
    /// Setup listeners, in order to listen to changes.
    _employeeSalaryIncrementStreamController.stream.listen(_incrementSalary);
    _employeeSalaryDecrementStreamController.stream.listen(_decrementSalary);

  }

  /// In this section of the code, I see potential implementations as follow: -
  /// 1. Add products/combos/gift cards to the order.
  /// 2. Delete products/combos from the order.
  /// 3. Modify existing products/combos.
  /// 4. Close the order.
  _incrementSalary(Employee employee){
    double currentSalary = employee.salary;
    double incrementPercentage = currentSalary * .2;
    _employees[employee.id - 1].salary = currentSalary + incrementPercentage;
    /// Add the modified list to the sink
    employeeListSink.add(_employees);
  }

  _decrementSalary(Employee employee){
    double currentSalary = employee.salary;
    double decrementPercentage = currentSalary * .2;
    _employees[employee.id - 1].salary = currentSalary - decrementPercentage;
    /// Add the modified list to the sink
    employeeListSink.add(_employees);
  }

  void dispose(){
    print("The dispose function is being called\n");
    _employeeListStreamController.close();
    _employeeSalaryIncrementStreamController.close();
    _employeeSalaryDecrementStreamController.close();
    print("We're exiting the dispose function...\n-------------\n");
  }

// jdjjdjdj

}
