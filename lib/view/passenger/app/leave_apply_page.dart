

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:multi_select_flutter/chip_field/multi_select_chip_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:tfleet/locale/app_localizations.dart';
import 'package:tfleet/model/passenger/child.dart';
import 'package:tfleet/model/passenger/leave.dart';
import 'package:tfleet/service/passenger/leave_service.dart';
import 'package:tfleet/utils/format_utils.dart';
import 'package:tfleet/utils/t_color.dart';
import 'package:tfleet/utils/toast.dart';
import 'package:tfleet/view/passenger/component/repeat_days_selector.dart';

class LeaveApplyPage extends StatefulWidget {
  const LeaveApplyPage({Key? key, required this.child, required this.onSubmit}) : super(key: key);

  final Child child;
  final Function onSubmit;

  @override
  State<LeaveApplyPage> createState() => _LeaveApplyPageState();
}

class _LeaveApplyPageState extends State<LeaveApplyPage> {

  final GlobalKey _formKey = GlobalKey<FormState>();

  DateTime? _startDate ;
  DateTime? _endDate ;

  final List<String> _leaveTypes = ['ECA', 'Holiday', 'MC', 'Pickup', 'Sending'];
  static final List<String> _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'];
  List<dynamic> _daysSelected = [];
  final _items = _days
      .map((v) => MultiSelectItem<String>(v, v))
      .toList();

  String? _selectLeaveType;

  List<DropdownMenuItem<String>> _generateLeaveTypeList() {
    final List<DropdownMenuItem<String>> items = <DropdownMenuItem<String>>[];
    for(String leave in _leaveTypes) {
      final DropdownMenuItem<String> item = DropdownMenuItem(
        value: leave,
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Text(leave),
        ),);
      items.add(item);
    }
    return items;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Widget _buildLeaveSelectionField() {
    return Container(
      margin: const EdgeInsets.only(left: 24, right: 24),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(width: 1, color: const Color(0xffE3E3E3))
      ),
      child: DropdownButton<String>(
        underline: Container(),
        hint: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Text(
              AppLocalizations.of(context)?.selectLeave ?? 'Select leave type',
            style: const TextStyle(
                fontSize: 16
            ),
          ),
        ),
        items: _generateLeaveTypeList(),
        onChanged: (value) {
          setState(() {
            _selectLeaveType = value;
          });
        },
        isExpanded: true,
        value: _selectLeaveType,
      ),
    );
  }

  Widget _buildRepeatDaysPickerField() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20),
      child: MultiSelectChipField(
        items: _items,
        initialValue: const [],
        title: const Text(
          'Select repeat days',
          style: TextStyle(
            color: Colors.white,
              fontSize: 16
          ),
        ),
        headerColor: const Color(0xffE40947),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xffE40947), width: 1.8),
          borderRadius: BorderRadius.circular(10)
        ),
        selectedChipColor: const Color(0xff008D41),
        selectedTextStyle: const TextStyle(color: Colors.white),
        onTap: (values) {
          _daysSelected = values;
        },
      ),
    );
  }

  int _convertLeaveType(String type) {
    switch (type) {
      case 'ECA':
        return 1;
      case 'Holiday':
        return 2;
      case 'MC':
        return 3;
      case 'Pickup':
        return 4;
      case 'Sending':
        return 5;
      default:
        return 0;
    }
  }

  int _convertDay2Number(String day) {
    switch (day) {
      case 'Mon':
        return 1;
      case 'Tue':
        return 2;
      case 'Wed':
        return 3;
      case 'Thu':
        return 4;
      case 'Fri':
        return 5;
      default:
        return 0;
    }
  }

  String? _repeatDaysText() {
    if (_daysSelected.isNotEmpty) {
      List<int> repeatDays = [];
      for (String e in _daysSelected) {
        repeatDays.add(_convertDay2Number(e));
      }
      return repeatDays.join(';');
    }
    return null;
  }

  _submitLeave() async {
    if (_selectLeaveType == null) {
      Toast.toast(context, msg: AppLocalizations.of(context)?.selectLeave ?? 'Select leave type.', position: ToastPostion.center);
      return;
    }
    if (_startDate == null || _endDate == null) {
      Toast.toast(context, msg: 'Select leave period.', position: ToastPostion.center);
      return;
    }

    int type = _convertLeaveType(_selectLeaveType!);
    if (type > 1 && type < 4) {
      Leave leave = Leave(childId: widget.child.id!, type: type, start: _startDate!, end: _endDate!, status: 0);
      await LeaveService.addLeave(leave);
    } else {
      String? repeatDays = _repeatDaysText();
      if (repeatDays == null ) {
        Leave leave = Leave(childId: widget.child.id!, type: type, start: _startDate!, end: _endDate!, status: 0);
        await LeaveService.addLeave(leave);
      } else {
        Map<String, dynamic> leaveParams = {
          'childId': widget.child.id,
          'type': type,
          'start': _startDate!.toIso8601String().substring(0, 10),
          'end': _endDate!.toIso8601String().substring(0, 10),
          'repeatDays': repeatDays
        };
        await LeaveService.addRepeatableLeaves(jsonEncode(leaveParams));
      }
    }
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  Widget buildSubmitButton(BuildContext context) {
    return Align(
      child: Container(
        height: fitSize(112.5),
        width: fitSize(675),
        margin: const EdgeInsets.only(bottom: 75),
        child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith((states) => const Color(0xffE40947)),
              shape: MaterialStateProperty.all(const StadiumBorder(
                  side: BorderSide(style: BorderStyle.none)))),
          child: Text(AppLocalizations.of(context)?.submit ?? 'Submit',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: fitSize(50)
              )),
          onPressed: () {
            // 表单校验通过才会继续执行
            if ((_formKey.currentState as FormState).validate()) {
              (_formKey.currentState as FormState).save();
              _submitLeave();
            }
          },
        ),
      ),
    );
  }


  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {

    if (args.value.startDate != null && args.value.endDate == null) {
      _startDate = args.value.startDate;
      _endDate = args.value.startDate;
    } else if (args.value.startDate != null && args.value.endDate != null) {
      setState(() {
            _startDate = args.value.startDate;
            _endDate = args.value.endDate;
          });
    }
  }

  Widget _calendarView() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: SfDateRangePicker(
        onSelectionChanged: _onSelectionChanged,
        selectionMode: DateRangePickerSelectionMode.range,
        initialSelectedRange: PickerDateRange(
            _startDate,
            _endDate,)
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 20),
            alignment: Alignment.centerLeft,
            child: Text(
              'Apply Leave for ${widget.child.name}',
              style: const TextStyle(
                color: Color(0xff030303),
                fontSize: 18,
                fontFamily: 'Lexend Deca',
              ),
            ),
          ),
          SizedBox(height: fitSize(125)),
          _buildLeaveSelectionField(),
          SizedBox(height: fitSize(75)),
          _calendarView(),
          SizedBox(height: fitSize(75)),
          _buildRepeatDaysPickerField(),
          SizedBox(height: fitSize(75)),
          buildSubmitButton(context),
        ],
      ),
    );
  }
}
