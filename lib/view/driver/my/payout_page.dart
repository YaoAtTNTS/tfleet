

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:tfleet/model/driver/payout.dart';
import 'package:tfleet/utils/format_utils.dart';
import 'package:tfleet/utils/t_color.dart';
import 'package:tfleet/view/driver/component/payout_card.dart';

class PayoutPage extends StatefulWidget {
  const PayoutPage({Key? key}) : super(key: key);

  @override
  State<PayoutPage> createState() => _PayoutPageState();
}

class _PayoutPageState extends State<PayoutPage> {

  String _selectedDate = '';
  String _dateCount = '';
  String _range = '';
  String _rangeCount = '';

  List<Payout> _payoutList = [];
  bool _showDatePicker = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getPayoutList();
  }

  Future _getPayoutList() async {
    List<int> ids = [1,2,3,4,5];
    List<double> dues = [2100.05, 1980.25, 2015.35, 2106.85, 2001.45];
    List<double> paids = [0.0, 1980.25, 2015.35, 2106.85, 2001.45];
    List<DateTime> createdAts = [DateTime(2022,11,30,14,30,19), DateTime(2022,10,31,15,0,18), DateTime(2022,9,30,14,38,49), DateTime(2022,8,31,14,42,39), DateTime(2022,7,31,14,12,27)];
    List<String> months = ['Nov 2022', 'Oct 2022', 'Sep 2022', 'Aug 2022', 'Jul 2022'];
    List<DateTime?> paidAts = [null, DateTime(2022,10,31,17,0,18), DateTime(2022,9,30,14,38,49), DateTime(2022,8,31,14,42,39), DateTime(2022,7,31,14,12,27)];
    List<int> statuses = [1,2,2,2,2];
    for(int i = 0; i<5; i++) {
      Payout payout = Payout(
          id: ids[i],
          due: dues[i],
          paid: paids[i],
          month: months[i],
          createdAt: createdAts[i],
          paidAt: paidAts[i],
          status: statuses[i]
      );
      _payoutList.add(payout);
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
  Widget build(BuildContext context) {
    DateTime halfYearAgo = DateTime.now().subtract(const Duration(days: 183));
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          title: const Text('Payouts'),
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
              padding: EdgeInsets.all(fitSize(40)),
              margin: EdgeInsets.only(top: fitSize(40)),
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
              itemCount: _payoutList.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    SizedBox(height: fitSize(30)),
                    PayoutCard(payout: _payoutList[index])
                  ],
                );
              }),
          ),
        ],
      ),
    );
  }
}
