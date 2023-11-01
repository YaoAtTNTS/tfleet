

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:tfleet/model/driver/salary.dart';
import 'package:tfleet/utils/format_utils.dart';
import 'package:tfleet/utils/t_color.dart';
import 'package:tfleet/view/driver/component/salary_card.dart';

class SalaryPage extends StatefulWidget {
  const SalaryPage({Key? key}) : super(key: key);

  @override
  State<SalaryPage> createState() => _SalaryPageState();
}

class _SalaryPageState extends State<SalaryPage> {
  String _selectedDate = '';
  String _dateCount = '';
  String _range = '';
  String _rangeCount = '';

  List<Salary> _salaryList = [];
  bool _showDatePicker = false;

  Future _getSalaryList() async {
    List<int> ids = [1,2,3,4, 5];
    List<double> salaries = [1835.5, 1835.5, 1935.5, 2035.5, 1935.5];
    List<double> tripsAmounts = [4.5,5,4.5,5,4.5];
    List<String> months = ['Nov 22', 'Oct 22', 'Sep 22', 'Aug 22', 'Jul 22'];
    for (int i=0; i<5; i++) {
      Salary salary = Salary(id: ids[i], salary: salaries[i], tripsAmount: tripsAmounts[i], month: months[i]);
      _salaryList.add(salary);
    }
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    /// The argument value will return the changed date as [DateTime] when the
    /// widget [SfDateRangeSelectionMode] set as single.
    ///
    /// The argument value will return the changed dates as [List<DateTime>]
    /// when the widget [SfDateRangeSelectionMode] set as multiple.
    ///
    /// The argument value will return the changed range as [PickerDateRange]
    /// when the widget [SfDateRangeSelectionMode] set as range.
    ///
    /// The argument value will return the changed ranges as
    /// [List<PickerDateRange] when the widget [SfDateRangeSelectionMode] set as
    /// multi range.
    setState(() {
      if (args.value is PickerDateRange) {
        _range = '${DateFormat('dd/MM/yyyy').format(args.value.startDate)} -'
        // ignore: lines_longer_than_80_chars
            ' ${DateFormat('dd/MM/yyyy').format(args.value.endDate ?? args.value.startDate)}';
      } else if (args.value is DateTime) {
        _selectedDate = args.value.toString();
      } else if (args.value is List<DateTime>) {
        _dateCount = args.value.length.toString();
      } else {
        _rangeCount = args.value.length.toString();
      }
    });
  }
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getSalaryList();
  }

  @override
  Widget build(BuildContext context) {
    DateTime halfYearAgo = DateTime.now().subtract(const Duration(days: 183));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text('Salary Details'),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: fitSize(25)),
            child: IconButton(
              icon: const Icon(Icons.graphic_eq_outlined),
              onPressed: () {},
            ),
          )
        ],
      ),
      body: Column(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _showDatePicker = !_showDatePicker;
              });
            },
            child: Container(
              width: MediaQuery.of(context).size.width*0.9,
              margin: EdgeInsets.only(top: fitSize(40)),
              padding: EdgeInsets.all(fitSize(40)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(fitSize(12.5))),
                color: TColor.in3active,
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.calendar_view_month,
                  ),
                  SizedBox(width: fitSize(40),),
                  Text(
                    '${halfYearAgo.month} ${halfYearAgo.year} to ${DateTime.now().month} ${DateTime.now().year}',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: fitSize(40)
                    ),
                  ),
                ],
              ),
            ),
          ),
          _showDatePicker ? SfDateRangePicker(
            onSelectionChanged: _onSelectionChanged,
            selectionMode: DateRangePickerSelectionMode.range,
            initialSelectedRange: PickerDateRange(
                DateTime.now().subtract(const Duration(days: 4)),
                DateTime.now().add(const Duration(days: 3))),
          ) : Container(),
          Expanded(
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    SizedBox(height: fitSize(30)),
                    SalaryCard(salary: _salaryList[index])
                  ],
                );
              }),
          ),
        ],
      ),
    );
  }
}
