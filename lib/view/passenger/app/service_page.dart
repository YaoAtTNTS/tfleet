

import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:multi_select_flutter/chip_field/multi_select_chip_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:tfleet/locale/app_localizations.dart';
import 'package:tfleet/main.dart';
import 'package:tfleet/model/passenger/child.dart';
import 'package:tfleet/model/passenger/leave.dart';
import 'package:tfleet/service/passenger/child_service.dart';
import 'package:tfleet/service/passenger/leave_service.dart';
import 'package:tfleet/service/passenger/service_change_service.dart';
import 'package:tfleet/utils/constants.dart';
import 'package:tfleet/utils/format_utils.dart';
import 'package:tfleet/utils/global.dart';
import 'package:tfleet/utils/toast.dart';

class ServicePage extends StatefulWidget {
  const ServicePage({Key? key, required this.fromAdd}) : super(key: key);

  final bool fromAdd;

  @override
  State<ServicePage> createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {

  final List<Child> _childrenList = [];

  int _selectedChildIndex = 0;

  DateTime _startDate = DateTime.now();

  static final List<String> _services = ['AM', 'PM', 'ECA'];

  static final List<String> _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'];
  List<dynamic> _daysSelected = [];
  final _dayItems = _days
      .map((v) => MultiSelectItem<String>(v, v))
      .toList();

  final _items = _services
      .map((v) => MultiSelectItem<String>(v, v))
      .toList();

  final Map<int, List<dynamic>> _childServiceMap = {};

  final Map<int, String?> _childDeclarationMap = {};

  bool _isECASelected = false;


  Future _getChildrenList() async {
    if (Global.yourChildren.isNotEmpty) {
      _childrenList.addAll(Global.yourChildren);
    } else {
      var children = await ChildService.getChildren(Global.getUserId()!);
      for(Map<String, dynamic> childJson in children) {
        Child child = Child.fromJson(childJson);
        _childrenList.add(child);
        Global.yourChildren.add(child);
      }
    }
    for (Child child in _childrenList) {
      if (child.id == null) {
        continue;
      }
      _childServiceMap[child.id!] = [];
      if (child.requestedService != null) {
          List<String> split = child.requestedService!.split(';');
          for (String s in split) {
            _childServiceMap[child.id!]?.add(_num2service(s));
          }
      }
    }
    setState(() {});
  }

  Future _updateServiceChangeMap () async {
    for (Child child in _childrenList) {
      _childDeclarationMap[child.id!] = await _fetchServiceChange(child.id!);
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _getChildrenList();
    if (widget.fromAdd) {
      _selectedChildIndex = Global.yourChildren.length - 1;
      _childServiceMap[Global.yourChildren.last.id!] = [];
    }
    Future.delayed(Duration.zero, _updateServiceChangeMap);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildHeader(width),
            const SizedBox(height: 10,),
            _buildChildrenList(),
            const SizedBox(height: 10,),
            SizedBox(height: fitSize(75)),
            _buildDeclarationText(),
            _buildServicePickerField(),
            _isECASelected ? _buildRepeatDaysPickerField() : Container(),
            _buildServiceChangeStartDateAndConfirmField(),
            SizedBox(height: fitSize(75),),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTerminateButton(context),
                _buildSubmitButton(context),
              ],
            ),
            SizedBox(height: fitSize(125),),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(double width) {
    DateTime now = DateTime.now();
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          width: width,
          height: width * 0.28,
          decoration: BoxDecoration(
              color: const Color(0xffe40947),
              borderRadius: BorderRadius.circular(18)
          ),
        ),
        Positioned(
          left: 20,
          top: 34,
          child: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.chevron_left,
              size: 30,
              color: Colors.white,
            ),
          ),
        ),
        Positioned(
          top: 48,
          child: Container(
            width: width,
            alignment: Alignment.topCenter,
            child: const Text(
              'Service Management',
              style: TextStyle(
                  fontSize: 24,
                  fontFamily: 'Lexend Deca',
                  fontWeight: FontWeight.bold,
                  color: Colors.white
              ),
            ),
          ),
        ),
        Positioned(
            top: width*0.22,
            left: 7,
            child: Container(
              height: 2,
              width: width - 10,
              color: Colors.white,
            )
        ),
        Positioned(
            bottom: 4,
            left: 10,
            width: width - 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Welcome, ${Global.username()}',
                  style: const TextStyle(
                      fontSize: 13,
                      fontFamily: 'Lexend Deca',
                      color: Colors.white
                  ),
                ),
                Text(
                  '${dateToAlphaMonth(now.toString())} ${now.year}',
                  style: const TextStyle(
                      fontSize: 13,
                      fontFamily: 'Lexend Deca',
                      color: Colors.white
                  ),
                ),
              ],
            )
        ),
      ],
    );
  }

  Widget _buildChildrenList() {
    return Container(
      height: 72,
      margin: const EdgeInsets.only(left: 10, right: 10),
      // width: width,
      child: ListView.separated(
          itemCount: _childrenList.length,
          scrollDirection: Axis.horizontal,
          // physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedChildIndex = index;
                });
              },
              child: _buildChildCard(_selectedChildIndex == index, _childrenList[index].url),
            );
          }, separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(width: 10,);
      },
      ),
    );
  }

  Widget _buildChildCard(bool isSelected, String? url) {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: isSelected ? const Color(0xffE40947) : Colors.white),
        borderRadius: BorderRadius.circular(36),
      ),
      child: ClipOval(
        child: CachedNetworkImage(
          placeholder: (context, url) => const SizedBox(
            child: Center(child: CircularProgressIndicator()),
          ),
          imageUrl: url ?? Constants.PROFILE_IMAGE_DEFAULT_URL,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  String declaration() {
    Child child = _childrenList[_selectedChildIndex];
    if (_childDeclarationMap[child.id] == null) {
      return '';
    }
    if (_childDeclarationMap[child.id]=='') {
      return 'Your service change for ${child.name} is pending ZXY\'s approval, which may take minimum 2 weeks.';
    }
    return 'The new service for ${child.name} will be effective on ${_childDeclarationMap[child.id]}';
  }

  Widget _buildDeclarationText() {
    return Padding(
      padding: EdgeInsets.only(left: 20, top: fitSize(75), right: 20),
      child: Text(
        declaration(),
        softWrap: true,
        style: const TextStyle(
            fontSize: 16,
            fontFamily: 'Lexend Deca',
            fontWeight: FontWeight.w500,
            color: Color(0xffe40947)
        ),
      ),
    );
  }

  Widget _buildServicePickerField() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20),
      child: MultiSelectChipField(
        items: _items,
        initialValue: _childServiceMap[_childrenList[_selectedChildIndex].id] ?? [],
        title: Text(
          'Select services for ${_childrenList[_selectedChildIndex].name}',
          style: const TextStyle(
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
          setState(() {
            _childServiceMap[_selectedChildIndex] = values;
            if (values.contains('ECA')) {
              setState(() {
                _isECASelected = true;
              });
            } else {
              setState(() {
                _isECASelected = false;
              });
            }
          });
        },
      ),
    );
  }

  Widget _buildRepeatDaysPickerField() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20),
      child: MultiSelectChipField(
        items: _dayItems,
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

  Widget _buildServiceChangeStartDateAndConfirmField() {
    if (_childrenList[_selectedChildIndex].requestedService != _requestedService()) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 30, top: 10),
            child: Text('Please select the start date.'),
          ),
          _calendarView(),
        ],
      );
    }
    return Container();
  }

  Widget _calendarView() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: SfDateRangePicker(
          onSelectionChanged: _onSelectionChanged,
          selectionMode: DateRangePickerSelectionMode.single,
          initialDisplayDate: _startDate,
      ),
    );
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    if (args.value != null ) {
      _startDate = args.value;
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

  String _requestedService() {
    String requested = '';
    if (_childServiceMap[_selectedChildIndex] != null) {
      Iterator<dynamic> iterator = _childServiceMap[_selectedChildIndex]!.iterator;
      if (iterator.moveNext()) {
        requested += _service2num(iterator.current);
        while (iterator.moveNext()){
          requested += ';${_service2num(iterator.current)}';
        }
      }
    }
    return requested;
  }

  String _service2num(String service) {
    switch(service) {
      case 'AM':
        return '1';
      case 'PM':
        return '2';
      case 'ECA':
        return '3';
      default:
        return '';
    }
  }

  String _num2service(String num) {
    switch(num) {
      case '1':
        return 'AM';
      case '2':
        return 'PM';
      case '3':
        return 'ECA';
      default:
        return '';
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

  Widget _buildTerminateButton(BuildContext context) {
    return Container(
      height: fitSize(112.5),
      width: fitSize(375),
      margin: const EdgeInsets.only(left: 30, bottom: 75),
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith((states) => const Color(0xffE40947)),
            shape: MaterialStateProperty.all(const StadiumBorder(
                side: BorderSide(style: BorderStyle.none))
            )
        ),
        child: Text('Terminate',
            style: TextStyle(
                color: Colors.white,
                fontSize: fitSize(50)
            )),
        onPressed: () {
          showConfirmDialog(context);
        },
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return Container(
      height: fitSize(112.5),
      width: fitSize(375),
      margin: const EdgeInsets.only(bottom: 75, right: 30),
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith((
                states) => const Color(0xffE40947)),
            shape: MaterialStateProperty.all(const StadiumBorder(
                side: BorderSide(style: BorderStyle.none))
            )
        ),
        child: Text(AppLocalizations
            .of(context)
            ?.submit ?? 'Submit',
            style: TextStyle(
                color: Colors.white,
                fontSize: fitSize(50)
            )),
        onPressed: () {
          showConfirmSubmitDialog(context);
        },
      ),
    );
  }

  Future<String?> _fetchServiceChange(int childId) async {
    var data = await ServiceChangeService.fetchChange(Global.getUserId()!, childId);
    if (data == null) {
      return null;
    }
    if (data['effectiveDate'] == null) {
      return '';
    }
    return data['effectiveDate'];
  }

  _submitServiceChange() async {
    if (_childDeclarationMap[_childrenList[_selectedChildIndex].id] != null) {
      Toast.toast(context, msg: 'You already have pending service changes, please contact admin to cancel the existing change before you proceed to new changes.');
      return;
    }
    Map<String, dynamic> data = {};
    data['oldService'] = _childrenList[_selectedChildIndex].requestedService;
    data['newService'] = _requestedService();
    data['repeatDays'] = _repeatDaysText();
    if (data['oldService'] == data['newService']) {
      return;
    }
    if (_startDate != null) {
      data['startDate'] = _startDate.toString().substring(0,10);
    }
    data['userId'] = Global.getUserId();
    data['childId'] = _childrenList[_selectedChildIndex].id;
    int code = await ServiceChangeService.addChange(jsonEncode(data));
    if (code == 0) {
      if (mounted) {
        Toast.toast(context, msg: 'Service change request submitted.', bgColor: Colors.green);
      }
    }
  }

  Future<bool?> showConfirmSubmitDialog(BuildContext buildContext) async {
    return showDialog<bool>(
      context: buildContext,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Confirm to change service for this child?',
            style: TextStyle(
              fontWeight: FontWeight.normal,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(AppLocalizations.of(context)?.cancel ?? 'Cancel', style: TextStyle(fontSize: fitSize(40))),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text(AppLocalizations.of(context)?.yes ?? 'Yes', style: TextStyle(fontSize: fitSize(40))),
              onPressed: () async {
                _submitServiceChange();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool?> showConfirmDialog(BuildContext buildContext) async {
    if (_childDeclarationMap[_childrenList[_selectedChildIndex].id] != null) {
      Toast.toast(buildContext, msg: 'You have pending service change. Please contact admin to terminate.', showTime: 2000);
      return false;
    }
    return showDialog<bool>(
      context: buildContext,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Confirm to terminate the services for this child?',
            style: TextStyle(
              fontWeight: FontWeight.normal,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(AppLocalizations.of(context)?.cancel ?? 'Cancel', style: TextStyle(fontSize: fitSize(40))),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text(AppLocalizations.of(context)?.yes ?? 'Yes', style: TextStyle(fontSize: fitSize(40))),
              onPressed: () async {
                _childrenList[_selectedChildIndex].status = 1;
                ChildService.deleteChild(_childrenList[_selectedChildIndex].id!);
                Navigator.of(context).pop();
                Navigator.of(buildContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

}
