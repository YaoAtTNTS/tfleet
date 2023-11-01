

import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:tfleet/locale/app_localizations.dart';
import 'package:tfleet/main.dart';
import 'package:tfleet/model/passenger/address.dart';
import 'package:tfleet/service/passenger/address_service.dart';
import 'package:tfleet/utils/format_utils.dart';
import 'package:tfleet/utils/global.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:tfleet/utils/toast.dart';
import 'package:tfleet/view/passenger/component/map_view.dart';

class AddressProfile extends StatefulWidget {
  const AddressProfile({Key? key}) : super(key: key);

  @override
  State<AddressProfile> createState() => _AddressProfileState();
}

class _AddressProfileState extends State<AddressProfile> {

  Address? _addressObject;

  final GlobalKey _formKey = GlobalKey<FormState>();
  String _name = '';
  String _unitNo = '';
  String _address = '';
  String _postalCode = '';
  double _longitude = 0.0;
  double _latitude = 0.0;
  // final TextEditingController _nameController = TextEditingController();
  // final TextEditingController _unitNoController = TextEditingController();
  // final TextEditingController _addressController = TextEditingController();
  // final TextEditingController _postalCodeController = TextEditingController();

  DateTime? _startDate;

  bool _showDatePicker = false;

  _refreshOnReturn () async {
    setState(() {
      Address? address = Global.getAddress();
      if (address != null) {
        _name = address.name ?? '';
        _address = address.address;
        _postalCode = address.postalCode;
        _longitude = address.longitude;
        _latitude = address.latitude;
      }
    });
  }

  Future _getAddress() async {
    if (_addressObject == null) {
      var addresses = await AddressService.getAddresses(Global.getUserId()!);
      for (Map<String, dynamic> addressJson in addresses) {
        if (addressJson['status'] == 0) {
          _addressObject = Address.fromJson(addressJson);
        } else if (addressJson['status'] == 1) {
          Global.hasPendingAddress = true;
          Global.pendingAddressCreatedAt = (addressJson['createdAt'] != null ? DateTime.parse(addressJson['createdAt']) : null);
        }
      }
      Global.saveAddress(_addressObject!);
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (Global.getAddress() != null) {
      _addressObject = Global.getAddress();
      _name = _addressObject!.name ?? '';
      _address = _addressObject!.address;
      _unitNo = _addressObject!.unitNo ?? '';
      _postalCode = _addressObject!.postalCode;
      _longitude = _addressObject!.longitude;
      _latitude = _addressObject!.latitude;
    } else {
      _getAddress();
    }

  }

  @override
  void dispose() {
    // _postalCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
    return Scaffold(
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildHeader(width),
                _addressObject != null ? buildDeclarationText() : Container(),
                SizedBox(height: fitSize(75)),
                buildPostalCodeTextField(),
                SizedBox(height: fitSize(75)),
                buildUnitNoTextField(),
                SizedBox(height: fitSize(75)),
                buildAddressDetailsTextField(),
                SizedBox(height: fitSize(75)),
                buildAddressNameTextField(),
                _buildServiceChangeStartDateAndConfirmField(),
                SizedBox(height: fitSize(125)),
                buildSubmitButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(double width) {
    return Container(
      width: width,
      height: width * 0.28,
      padding: const EdgeInsets.only(left: 20, right: 42),
      decoration: BoxDecoration(
          color: const Color(0xffe40947),
          borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
          Expanded(
            child: Text(
              _addressObject == null ? 'Register Address' : 'Update Address',
              style: const TextStyle(
                  fontSize: 24,
                  fontFamily: 'Lexend Deca',
                  fontWeight: FontWeight.bold,
                  color: Colors.white
              ),
            ),
          ),
          // IconButton(
          //     onPressed: () {
          //       Navigator.of(context).push(MaterialPageRoute(
          //         builder: (context) => MapView(),
          //       )).then((value) => value?_refreshOnReturn():null);
          //     },
          //     icon: Image.asset('assets/image/icon/map.png')
          // ),
        ],
      ),
    );
  }

  String _addressApprovalDate() {
    if (Global.pendingAddressCreatedAt != null) {
      return Global.pendingAddressCreatedAt!.add(const Duration(days: 14)).toString().substring(0,10);
    }
    return ' to be updated.';
  }

  Widget buildDeclarationText() {
    return Padding(
      padding: EdgeInsets.only(left: 20, top: fitSize(75), right: 20),
      child: Text(
          Global.hasPendingAddress ? 'Your new address is pending ZXY\'s approval now, the estimated date is ${_addressApprovalDate()}.' : 'Please kindly be noted the changes on your address will be subject to ZXY\'s approval, which may take minimum 2 weeks.',
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

  Widget buildAddressNameTextField() {
    return Container(
      margin: const EdgeInsets.only(left: 24, right: 24),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(width: 1, color: const Color(0xffE3E3E3))
      ),
      child: TextFormField(
        initialValue: _name,
        decoration: const InputDecoration(
            labelText: 'Building name',
          contentPadding: EdgeInsets.only(left: 10, right: 10),
          border: InputBorder.none,
        ),
        onEditingComplete: (){
          FocusScope.of(context).nextFocus();
        },
        onSaved: (v) => _name = v!.trim(),
      ),
    );
  }

  Widget buildUnitNoTextField() {
    return Container(
      margin: const EdgeInsets.only(left: 24, right: 24),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(width: 1, color: const Color(0xffE3E3E3))
      ),
      child: TextFormField(
        initialValue: _unitNo,
        decoration: InputDecoration(
            labelText: AppLocalizations.of(context)?.unitNo ?? 'Unit no',
          contentPadding: const EdgeInsets.only(left: 10, right: 10),
          border: InputBorder.none,
        ),
        onEditingComplete: (){
          FocusScope.of(context).nextFocus();
        },
        onSaved: (v) => _unitNo = v!.trim(),
      ),
    );
  }

  Widget buildAddressDetailsTextField() {
    return Container(
      margin: const EdgeInsets.only(left: 24, right: 24),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(width: 1, color: const Color(0xffE3E3E3))
      ),
      child: TextFormField(
        initialValue: _address,
        decoration: InputDecoration(
            labelText: AppLocalizations.of(context)?.streetName ?? 'Street name',
          contentPadding: const EdgeInsets.only(left: 10, right: 10),
          border: InputBorder.none,
        ),
        onEditingComplete: (){
          FocusScope.of(context).nextFocus();
        },
        validator: (v) {
          if (v!.isEmpty) {
            return AppLocalizations.of(context)?.pleaseKeyInAddress ?? 'Please key in address.';
          }
        },
        onSaved: (v) => _address = v!.trim(),
      ),
    );
  }

  Widget buildPostalCodeTextField() {
    return Container(
      margin: const EdgeInsets.only(left: 24, right: 24),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(width: 1, color: const Color(0xffE3E3E3))
      ),
      child: TextFormField(
        initialValue: _postalCode,
        decoration: InputDecoration(
            labelText: AppLocalizations.of(context)?.postalCode ?? 'Postal code',
          contentPadding: const EdgeInsets.only(left: 10, right: 10),
          border: InputBorder.none,
        ),
        validator: (v) {
          var mobileReg = RegExp(
              r'^[0-9]{6}$');
          if (!mobileReg.hasMatch(v!)) {
            return 'Invalid postal code.';
          }
        },
        onChanged: (v){
          if (!_showDatePicker) {
            setState(() {
              _showDatePicker = true;
            });
          }
        },
        onEditingComplete: (){
          FocusScope.of(context).nextFocus();
          setState(() {

          });
        },
        onSaved: (v) => _postalCode = v!.trim(),
      ),
    );
  }

  Widget _buildServiceChangeStartDateAndConfirmField() {
    if (_addressObject != null && _showDatePicker) {
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
          selectionMode: DateRangePickerSelectionMode.range,
          initialSelectedRange: PickerDateRange(
            _startDate,
            _startDate,)
      ),
    );
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    if (args.value.startDate != null && args.value.endDate == null) {
      _startDate = args.value.startDate;
    } else if (args.value.startDate != null && args.value.endDate != null) {
      _startDate = args.value.endDate;
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
            if ((_formKey.currentState as FormState).validate()) {
              (_formKey.currentState as FormState).save();
              if (_addressObject != null) {
                showConfirmDialog(context);
              } else {
                _addAddress();
              }
            }
          },
        ),
      ),
    );
  }

  Future<bool?> showConfirmDialog(BuildContext buildContext) async {
    return showDialog<bool>(
      context: buildContext,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Confirm to change address?',
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
                Navigator.of(context).pop();
                _addAddress();
              },
            ),
          ],
        );
      },
    );
  }

  Future _addAddress() async {
    if (Global.hasPendingAddress) {
      Toast.toast(context, msg: 'You already have pending address changes, please contact admin to cancel the existing change before you proceed to new changes.');
      return;
    }
    if (_longitude == 0.0 || _latitude == 0.0) {
      List<Location> list = await locationFromAddress(_address);
      _longitude = list[0].longitude;
      _latitude = list[0].latitude;
    }
    Address address = Address(
      userId: Global.getUserId()!,
      address: _address,
      postalCode: _postalCode,
      name: _name,
      unitNo: _unitNo,
      latitude: _latitude,
      longitude: _longitude,
      createdAt: _startDate
    );
    if (_addressObject != null) {
      address.id = _addressObject!.id!;
      Global.updateAddress(address);
      // Global.saveAddress(address);
      await AddressService.updateAddress(address);
    } else {
      Global.saveAddress(address);
      await AddressService.addAddress(address);
    }
    if (mounted) {
      Navigator.pop(context);
    }
  }

}
