

import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:tfleet/locale/app_localizations.dart';
import 'package:tfleet/model/driver/pickup_point.dart';
import 'package:tfleet/model/passenger/address.dart';
import 'package:tfleet/model/passenger/child.dart';
import 'package:tfleet/service/driver/pickup_point_service.dart';
import 'package:tfleet/service/passenger/address_service.dart';
import 'package:tfleet/service/passenger/child_service.dart';
import 'package:tfleet/service/passenger/file_service.dart';
import 'package:tfleet/utils/constants.dart';
import 'package:tfleet/utils/t_color.dart';
import 'package:tfleet/utils/format_utils.dart';
import 'package:tfleet/utils/global.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tfleet/view/full_image.dart';
import 'package:tfleet/view/passenger/app/leave_apply_page.dart';
import 'package:tfleet/view/passenger/app/leave_page.dart';
import 'package:tfleet/view/passenger/my/address_page.dart';

class ChildProfileView extends StatefulWidget {
  const ChildProfileView({Key? key, required this.child}) : super(key: key);

  final Child child;

  @override
  State<ChildProfileView> createState() => _ChildProfileViewState();
}

class _ChildProfileViewState extends State<ChildProfileView> {

  PickupPoint? _dropoffPoint;
  PickupPoint? _pickupPoint;
  PickupPoint? _ecaPoint;
  String? _address;

  void _getPickupAndDropoffPoint() async {
    if (widget.child.pickupPointIds != null && widget.child.pickupPointIds!.isNotEmpty) {
      for (int id in widget.child.pickupPointIds!) {
        var raw = await PickupPointService.getPickupPoint(id);
        if (raw != null) {
          switch(raw['type']) {
            case 1:
              _pickupPoint = PickupPoint.fromJson(raw);
              break;
            case 2:
              _dropoffPoint = PickupPoint.fromJson(raw);
              break;
            case 3:
              _ecaPoint = PickupPoint.fromJson(raw);
              break;
          }
        }
      }
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _address = widget.child.address.name ?? (AppLocalizations.of(context)?.unknown ?? 'Unknown');
    _getPickupAndDropoffPoint();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(widget.child.name),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: fitSize(50)),
        children: [
          SizedBox(height: kToolbarHeight), // 距离顶部一个工具栏的高度
          buildApplyLeaveButton(),
          SizedBox(height: fitSize(75)),
          _pickupPoint != null ? buildPickupPointField(AppLocalizations.of(context)?.pickupPoint ?? 'Pickup Point', _pickupPoint!) : Container(),
          SizedBox(height: fitSize(75)),
          _dropoffPoint != null ? buildPickupPointField(AppLocalizations.of(context)?.dropoffPoint ?? 'Dropoff Point', _dropoffPoint!) : Container(),
          SizedBox(height: fitSize(75)),
          _ecaPoint != null ? buildPickupPointField('ECA Dropoff Point', _ecaPoint!) : Container(),
          buildStuNameTextField(),
          SizedBox(height: fitSize(75)),
          buildGenderFiled(),
          SizedBox(height: fitSize(75)),
          buildSchoolNameTextField(),
          SizedBox(height: fitSize(75)),
          buildAddressTextField(),
          SizedBox(height: fitSize(75)),
          buildAreaTextField(),
          SizedBox(height: fitSize(75)),
          buildProfileImageText(),
          SizedBox(height: fitSize(12.5)),
          buildProfileImage(),
          SizedBox(height: fitSize(75)),
        ],
      ),
    );
  }

  Widget buildApplyLeaveButton() {
    return Container(
      alignment: Alignment.centerRight,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: ButtonStyleButton.allOrNull<Color>(Colors.blueAccent),
        ),
        onPressed: () {
          // Navigator.of(context).push(MaterialPageRoute(
          //     builder: (context) => LeavePage(child: widget.child))
          // );
        },
        child: const Text('Leave'),
      ),
    );
  }

  Widget buildPickupPointField(String title, PickupPoint point) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$title: ${point.name}',
          style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold
          ),
        ),
        SizedBox(height: fitSize(50)),
        Text(
          'Route No: ${point.routeNo ?? 'Unknown'}',
          style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold
          ),
        ),
        SizedBox(height: fitSize(50)),
        Text(
          '${AppLocalizations.of(context)?.eta??'ETA'}: ${point.eta~/60 < 10 ? '0':''}${point.eta~/60}:${point.eta%60 < 10 ? '0':''}${point.eta%60}',
          style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold
          ),
        ),
        SizedBox(height: fitSize(100)),
      ],
    );
  }

  Widget buildStuNameTextField() {
    return Text(
      '${AppLocalizations.of(context)?.passengerName ?? 'Child name'}: ${widget.child.name}',
      style: const TextStyle(
          fontSize: 18,
      ),
    );
  }

  Widget buildGenderFiled() {
    if (widget.child.gender == 1) {
      return Text(
        '${AppLocalizations.of(context)?.gender ?? 'Gender'}: ${AppLocalizations.of(context)?.male ?? 'Male'}',
        style: const TextStyle(
            fontSize: 18,
        ),
      );
    } else {
      return Text(
        '${AppLocalizations.of(context)?.gender ?? 'Gender'}: ${AppLocalizations.of(context)?.female ?? 'Female'}',
        style: const TextStyle(
            fontSize: 18,
        ),
      );
    }
  }

  Widget buildSchoolNameTextField() {
    return Text(
      '${AppLocalizations.of(context)?.schoolName ?? 'School name'}: ${widget.child.school}',
      style: const TextStyle(
          fontSize: 18,
      ),
    );
  }

  Widget buildClazzNameTextField() {
    return Text(
      '${AppLocalizations.of(context)?.clazzName ?? 'Class name'}: ${widget.child.clazz}',
      style: const TextStyle(
          fontSize: 18,
      ),
    );
  }

  Widget buildAddressTextField() {
    return Text(
      '${AppLocalizations.of(context)?.address ?? 'Address'}: $_address',
      style: const TextStyle(
          fontSize: 18,
      ),
    );
  }

  Widget buildAreaTextField() {
    if (widget.child.area!= null) {
      return Text(
            '${AppLocalizations.of(context)?.area ?? 'Area'}: ${widget.child.area}',
        style: const TextStyle(
            fontSize: 18,
        ),
          );
    }
    return Container();
  }

  Widget buildProfileImageText() {
    if (widget.child.url != null) {
      return Text(
            AppLocalizations.of(context)?.profileImage ?? 'Profile image',
            style: TextStyle(
              color: TColor.inactive,
              fontSize: fitSize(40)
            ),
          );
    }
    return Container();
  }

  Widget buildProfileImage() {
    return widget.child.url == null ? Container() : Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(fitSize(12.5))),
          border: Border.all(
              style: BorderStyle.solid
          )
      ),
      width: MediaQuery.of(context).size.width*0.8,
      height: fitSize(500),
      child: uploadedImage(),
    );
  }

  Widget uploadedImage () {
    return CachedNetworkImage(
      height: fitSize(500),
      placeholder: (context, url) => Container(
        width: fitSize(250),
        height: fitSize(250),
        child: const Center(child: CircularProgressIndicator()),
      ),
      imageUrl: widget.child.url!,
      fit: BoxFit.contain,
    );
  }

}
