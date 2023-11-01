

import 'package:flutter/material.dart';
import 'package:tfleet/locale/app_localizations.dart';
import 'package:tfleet/model/driver/trip.dart';
import 'package:tfleet/model/subcon/vehicle.dart';
import 'package:tfleet/model/user.dart';
import 'package:tfleet/service/driver/trip_service.dart';
import 'package:tfleet/service/subcon/vehicle_service.dart';
import 'package:tfleet/service/user_service.dart';
import 'package:tfleet/utils/format_utils.dart';
import 'package:tfleet/utils/global.dart';
import 'package:tfleet/utils/t_color.dart';
import 'package:tfleet/utils/toast.dart';
import 'package:tfleet/view/driver/component/trip_card.dart';
import 'package:tfleet/view/subcon/component/missed_trip_card.dart';

class AssignPage extends StatefulWidget {
  const AssignPage({Key? key, required this.trip}) : super(key: key);

  final Trip trip;

  @override
  State<AssignPage> createState() => _AssignPageState();
}

class _AssignPageState extends State<AssignPage> {

  final GlobalKey _formKey = GlobalKey<FormState>();

  final List<User> _driverList = [];
  final List<User> _attendantList = [];
  final List<Vehicle> _vehicleList = [];

  User? selectedDriver;
  User? selectedAttendant;
  Vehicle? selectedVehicle;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getDriverList();
    _getVehicleList();
    _getAttendantList();
  }

  void _getDriverList() async {
    Map<String, int> params = <String, int>{};
    params['status'] = 0;
    List rawDrivers = await UserService.getStaffs(params, 2);
    for (Map<String, dynamic> rawDriver in rawDrivers) {
      _driverList.add(User.fromJson(rawDriver));
    }
    if (mounted) {
      setState(() {});
    }
  }

  void _getVehicleList() async {
    Map<String, dynamic> params = <String, dynamic>{};
    params['status'] = 0;
    List rawVehicles = await VehicleService.getVehicles(params);
    for (Map<String, dynamic> rawVehicle in rawVehicles) {
      _vehicleList.add(Vehicle.fromJson(rawVehicle));
    }
    if (mounted) {
      setState(() {});
    }
  }

  void _getAttendantList() async {
    Map<String, int> params = <String, int>{};
    params['status'] = 0;
    List rawAttendants = await UserService.getStaffs(params, 4);
    for (Map<String, dynamic> rawAttendant in rawAttendants) {
      _attendantList.add(User.fromJson(rawAttendant));
    }
    if (mounted) {
      setState(() {});
    }
  }

  List<DropdownMenuItem<User>> generateDriverItemList() {
    final List<DropdownMenuItem<User>> items = <DropdownMenuItem<User>>[];
    if (_driverList.isNotEmpty) {
      for(User driver in _driverList) {
        final DropdownMenuItem<User> item = DropdownMenuItem(
          child: Text(driver.name), value: driver,);
        items.add(item);
        if (driver.id == widget.trip.driverId) {
          selectedDriver = driver;
        }
      }
    }
    return items;
  }

  List<DropdownMenuItem<User>> generateAttendantItemList() {
    final List<DropdownMenuItem<User>> items = <DropdownMenuItem<User>>[];
    if (_attendantList.isNotEmpty) {
      for(User attendant in _attendantList) {
        final DropdownMenuItem<User> item = DropdownMenuItem(
          child: Text(attendant.name), value: attendant,);
        items.add(item);
        if (attendant.id == widget.trip.attendantId) {
          selectedAttendant = attendant;
        }
      }
    }
    return items;
  }

  List<DropdownMenuItem<Vehicle>> generateVehicleItemList() {
    final List<DropdownMenuItem<Vehicle>> items = <DropdownMenuItem<Vehicle>>[];
    for(Vehicle vehicle in _vehicleList) {
      final DropdownMenuItem<Vehicle> item = DropdownMenuItem(
        child: Text(vehicle.vehicleNo), value: vehicle,);
      items.add(item);
      if (vehicle.vehicleNo == widget.trip.vehicleNo) {
        selectedVehicle = vehicle;
      }
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
              Icons.chevron_left,
            color: Color(0xff030303),
          ),
        ),
        title: Text(
            widget.trip.status == 0 ? (AppLocalizations.of(context)?.assignTrip ?? 'Assign trip') :
            (AppLocalizations.of(context)?.editAssignment ?? 'Edit Assignment'),
          style: const TextStyle(
              color: Color(0xff030303),
              fontWeight: FontWeight.bold,
              fontSize: 24,
              fontFamily: 'Raleway'
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: fitSize(50)),
          children: [
            MissedTripCard(trip: widget.trip),
            SizedBox(height: fitSize(75)),
            buildAssignDriverButton(),
            SizedBox(height: fitSize(75)),
            buildAssignAttendantButton(),
            SizedBox(height: fitSize(75)),
            buildAssignVehicleButton(),
            SizedBox(height: fitSize(75)),
            buildSubmitButton(context),
          ],
        ),
      ),
    );
  }

  Widget _vehicleNo() {
    return Container(
      margin: EdgeInsets.only(left: fitSize(20)),
      alignment: Alignment.centerLeft,
      child: Text(
        widget.trip.vehicleNo ?? '',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: fitSize(40),
          color: TColor.active,
          fontWeight: FontWeight.bold,
          decoration: widget.trip.status == 2 ? TextDecoration.none : TextDecoration.lineThrough,
        ),
      ),
    );
  }

  Widget _tripRoute() {
    return Container(
      margin: EdgeInsets.only(left: fitSize(20)),
      alignment: Alignment.centerLeft,
      child: RichText(
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(text: '${widget.trip.departure}', style: TextStyle(color: Colors.green, decoration: widget.trip.status == -1 ? TextDecoration.lineThrough : TextDecoration.none, fontWeight: FontWeight.bold)),
            TextSpan(text: ' ${AppLocalizations.of(context)?.to ?? ''} '),
            TextSpan(text: '${widget.trip.destination}', style: TextStyle(color: Colors.green, decoration: widget.trip.status == -1 ? TextDecoration.lineThrough : TextDecoration.none, fontWeight: FontWeight.bold))
          ],
          style: TextStyle(
            fontSize: fitSize(30),
            color: TColor.inactive,
          ),
        ),
      ),
    );
  }

  Widget _tripDuration() {
    return Container(
      margin: EdgeInsets.only(left: fitSize(30)),
      alignment: Alignment.centerLeft,
      child: RichText(
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(text: widget.trip.plannedStart.toString().replaceAll('.000Z', ''), style: const TextStyle(color: Colors.orange)),
            TextSpan(text: ' ${AppLocalizations.of(context)?.to ?? ''} '),
            TextSpan(text: widget.trip.plannedEnd.toString().replaceAll('.000Z', ''), style: const TextStyle(color: Colors.orange))
          ],
          style: TextStyle(
            fontSize: fitSize(30),
            color: TColor.inactive,
          ),
        ),
      ),
    );
  }

  Widget _buildTripDetailsText() {
    return Container(
      padding: EdgeInsets.only(left: fitSize(5), top: fitSize(40)),
      child: Column(
        children: [
          // _vehicleNo(),
          SizedBox(height: fitSize(12.5)),
          _tripRoute(),
          SizedBox(height: fitSize(12.5)),
          _tripDuration(),
        ],
      ),
    );
  }

  Widget buildAssignDriverButton() {
    return DropdownButton<User>(
      hint: Text(AppLocalizations.of(context)?.selectDriver ?? 'Select driver'),
      items: generateDriverItemList(),
      onChanged: (value) {
        setState(() {
          selectedDriver = value;
        });
      },
      isExpanded: true,
      value: selectedDriver,
    );
  }

  Widget buildAssignAttendantButton() {
    return DropdownButton<User>(
      hint: Text(AppLocalizations.of(context)?.selectAttendant ?? 'Select attendant'),
      items: generateAttendantItemList(),
      onChanged: (value) {
        setState(() {
          selectedAttendant = value;
        });
      },
      isExpanded: true,
      value: selectedAttendant,
    );
  }

  Widget buildAssignVehicleButton() {
    return DropdownButton<Vehicle>(
      hint: Text(AppLocalizations.of(context)?.selectVehicle ?? 'Select vehicle'),
      items: generateVehicleItemList(),
      onChanged: (value) {
        setState(() {
          selectedVehicle = value;
        });
      },
      isExpanded: true,
      value: selectedVehicle,
    );
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
          onPressed: () async {
            if ((_formKey.currentState as FormState).validate()) {
              (_formKey.currentState as FormState).save();
              await _assignTrip();
              if (mounted) {
                Navigator.of(context).pop();
              }
            }
          },
        ),
      ),
    );
  }

  Future<void> _assignTrip() async {
    if (selectedDriver == null) {
      Toast.toast(context,msg: AppLocalizations.of(context)?.pleaseAssignDriver ?? 'Please assign driver. ',position: ToastPostion.center);
      return;
    }
    if (selectedVehicle == null) {
      Toast.toast(context,msg: AppLocalizations.of(context)?.pleaseAssignVehicle ?? 'Please assign vehicle. ',position: ToastPostion.center);
      return;
    }
    Map<String, dynamic> params = <String, dynamic> {};
    params['id'] = widget.trip.id;
    params['vehicleNo'] = selectedVehicle!.vehicleNo;
    params['attendantId'] = selectedAttendant?.id;
    params['driverId'] = selectedDriver!.id;
    params['ownerId'] = Global.getUserId();
    params['status'] = 1;
    await TripService.updateTrip(params);
  }
}
