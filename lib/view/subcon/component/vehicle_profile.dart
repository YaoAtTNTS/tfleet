

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tfleet/locale/app_localizations.dart';
import 'package:tfleet/main.dart';
import 'package:tfleet/model/subcon/vehicle.dart';
import 'package:tfleet/service/subcon/vehicle_service.dart';
import 'package:tfleet/utils/format_utils.dart';
import 'package:tfleet/utils/global.dart';

class VehicleProfile extends StatefulWidget {
  const VehicleProfile({Key? key, this.vehicle, }) : super(key: key);

  final Vehicle? vehicle;

  @override
  State<VehicleProfile> createState() => _VehicleProfileState();
}

class _VehicleProfileState extends State<VehicleProfile> {

  final GlobalKey _formKey = GlobalKey<FormState>();
  String _vehicleNo = '';
  String _capacity = '';
  String _make = '';
  String _model = '';
  String _type = '';

  bool _vehicleExisted = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.vehicle != null) {
      _vehicleNo = widget.vehicle!.vehicleNo;
      _capacity = '${widget.vehicle!.capacity}';
      _make = widget.vehicle!.make;
      _model = widget.vehicle!.model;
      _type = widget.vehicle!.type;
    }
  }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);

    return Scaffold(
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(),
              SizedBox(height: fitSize(75)),
              buildVehicleNoTextField(),
              SizedBox(height: fitSize(75)),
              _vehicleExisted ? Text(
                AppLocalizations.of(context)?.mobileAlreadyExisted ?? 'Vehicle already existed',
                style: const TextStyle(color: Colors.red),
              ) : Container(),
              buildCapacityTextField(),
              SizedBox(height: fitSize(75)),
              buildMakeTextField(),
              SizedBox(height: fitSize(75)),
              buildModelTextField(),
              SizedBox(height: fitSize(75)),
              buildTypeTextField(),
              SizedBox(height: fitSize(75)),
              buildSubmitButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: width,
      height: width * 0.568,
      padding: const EdgeInsets.only(left: 42, right: 42),
      decoration: BoxDecoration(
          color: const Color(0xffe40947),
          borderRadius: BorderRadius.circular(18)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: kToolbarHeight,),
          IconButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            icon: const Icon(
              Icons.chevron_left,
              size: 30,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20,),
          Text(
            widget.vehicle == null ? 'Register Vehicle' : widget.vehicle!.vehicleNo,
            style: const TextStyle(
                fontSize: 24,
                fontFamily: 'Lexend Deca',
                fontWeight: FontWeight.bold,
                color: Colors.white
            ),
          ),
          const SizedBox(height: 10,),
          const Text(
            'Fill in your vehicle profile',
            style: TextStyle(
                fontSize: 16,
                fontFamily: 'Lexend Deca',
                color: Colors.white
            ),
          ),
        ],
      ),
    );
  }

  Widget buildVehicleNoTextField() {
    return Container(
      margin: const EdgeInsets.only(left: 24, right: 24),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(width: 1, color: const Color(0xffE3E3E3))
      ),
      child: TextFormField(
        initialValue: _vehicleNo,
        decoration: InputDecoration(
            labelText: AppLocalizations.of(context)?.account ?? 'Account',
          contentPadding: const EdgeInsets.only(left: 10, right: 10),
          border: InputBorder.none,
        ),
        onEditingComplete: (){
          FocusScope.of(context).nextFocus();
        },
        onSaved: (v) => _vehicleNo = v!.trim(),
      ),
    );
  }

  Widget buildCapacityTextField() {
    return Container(
      margin: const EdgeInsets.only(left: 24, right: 24),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(width: 1, color: const Color(0xffE3E3E3))
      ),
      child: TextFormField(
        initialValue: _capacity,
        validator: (v) {
          if (!v!.contains(RegExp(r'^[0-9.]+$'))) {
            return 'Capacity must be numeric only.';
          }
        },
        decoration: InputDecoration(
            labelText: 'Capacity',
          contentPadding: const EdgeInsets.only(left: 10, right: 10),
          border: InputBorder.none,
        ),
        onEditingComplete: (){
          FocusScope.of(context).nextFocus();
        },
        onSaved: (v) => _capacity = v!.trim(),
      ),
    );
  }

  Widget buildMakeTextField() {
    return Container(
      margin: const EdgeInsets.only(left: 24, right: 24),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(width: 1, color: const Color(0xffE3E3E3))
      ),
      child: TextFormField(
        initialValue: _make,
        decoration: InputDecoration(
          labelText: 'Make',
          contentPadding: const EdgeInsets.only(left: 10, right: 10),
          border: InputBorder.none,
        ),
        onEditingComplete: (){
          FocusScope.of(context).nextFocus();
        },
        onSaved: (v) => _make = v!.trim(),
      ),
    );
  }

  Widget buildModelTextField() {
    return Container(
      margin: const EdgeInsets.only(left: 24, right: 24),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(width: 1, color: const Color(0xffE3E3E3))
      ),
      child: TextFormField(
        initialValue: _model,
        decoration: InputDecoration(
          labelText: 'Model',
          contentPadding: const EdgeInsets.only(left: 10, right: 10),
          border: InputBorder.none,
        ),
        onEditingComplete: (){
          FocusScope.of(context).nextFocus();
        },
        onSaved: (v) => _model = v!.trim(),
      ),
    );
  }

  Widget buildTypeTextField() {
    return Container(
      margin: const EdgeInsets.only(left: 24, right: 24),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(width: 1, color: const Color(0xffE3E3E3))
      ),
      child: TextFormField(
        initialValue: _type,
        decoration: InputDecoration(
          labelText: 'Type',
          contentPadding: const EdgeInsets.only(left: 10, right: 10),
          border: InputBorder.none,
        ),
        onEditingComplete: (){
          FocusScope.of(context).nextFocus();
        },
        onSaved: (v) => _type = v!.trim(),
      ),
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
          onPressed: () {
            if ((_formKey.currentState as FormState).validate()) {
              (_formKey.currentState as FormState).save();
              if (widget.vehicle != null) {
                _updateProfile();
              } else {
                _register();
              }
            }
          },
        ),
      ),
    );
  }


  Future _register() async {
    Vehicle vehicle = Vehicle(vehicleNo: _vehicleNo, make: _make, model: _model, type: _type, capacity: int.parse(_capacity), ownerId: Global.getUserId()!, ownerName: Global.username()!, defaultDriverId: null, status: 0);
    String id = await VehicleService.addVehicle(vehicle);
    if (id == '0') {
      setState(() {
        _vehicleExisted = true;
      });
      return;
    }
    if (mounted) {
      Navigator.pop(context, true);
    }
  }

  Future _updateProfile() async {
    Vehicle vehicle = Vehicle(vehicleNo: _vehicleNo, make: _make, model: _model, type: _type, capacity: int.parse(_capacity), ownerId: widget.vehicle!.ownerId,
        ownerName: widget.vehicle!.ownerName, defaultDriverId: widget.vehicle!.defaultDriverId, status: widget.vehicle!.status);

    vehicle.id = widget.vehicle!.id;
    VehicleService.updateVehicle(vehicle);
    Navigator.pop(context, true);
  }
}
