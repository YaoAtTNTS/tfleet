

import 'package:flutter/material.dart';
import 'package:tfleet/locale/app_localizations.dart';
import 'package:tfleet/model/driver/trip.dart';
import 'package:tfleet/service/driver/trip_service.dart';
import 'package:tfleet/utils/format_utils.dart';
import 'package:tfleet/utils/t_color.dart';
import 'package:tfleet/view/subcon/app/assign_page.dart';

class AssignedTripCard extends StatefulWidget {
  const AssignedTripCard({Key? key, required this.trip, }) : super(key: key);

  final Trip trip;
  @override
  State<AssignedTripCard> createState() => _AssignedTripCardState();
}

class _AssignedTripCardState extends State<AssignedTripCard> {


  Widget _vehicleNo() {
    return widget.trip.vehicleNo != null ? Container(
      margin: EdgeInsets.only(left: fitSize(20)),
      alignment: Alignment.centerLeft,
      child: Text(
        widget.trip.vehicleNo!,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontSize: 16,
          color: Color(0xffFF6600),
          fontWeight: FontWeight.w500,
          fontFamily: 'Lexend'
        ),
      ),
    ) : Container();
  }

  Widget _driverName() {
    return widget.trip.driverName != null ? Container(
      margin: EdgeInsets.only(left: fitSize(20)),
      alignment: Alignment.centerLeft,
      child: Text(
        widget.trip.driverName!,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
            fontSize: 16,
            color: Color(0xffFF6600),
            fontWeight: FontWeight.w500,
            fontFamily: 'Lexend'
        ),
      ),
    ) : Container();
  }

  Widget _attendantName() {
    return widget.trip.attendantName != null ? Container(
      margin: EdgeInsets.only(left: fitSize(20)),
      alignment: Alignment.centerLeft,
      child: Text(
        widget.trip.attendantName!,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
            fontSize: 16,
            color: Color(0xffF52C65),
            fontWeight: FontWeight.w600,
            fontFamily: 'Lexend'
        ),
      ),
    ) : Container();
  }

  Widget _tripRoute() {
    return Container(
      margin: EdgeInsets.only(left: fitSize(20)),
      alignment: Alignment.centerLeft,
      child: Text(
        '${widget.trip.departure} to ${widget.trip.destination}',
        softWrap: true,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
            color: Colors.black,
            fontFamily: 'Lexend',
            fontSize: 16
        ),
      ),
    );
  }

  Widget _tripDuration() {
    return Container(
      margin: EdgeInsets.only(left: fitSize(30), bottom: 5),
      alignment: Alignment.centerLeft,
      child: Text(
          '${dateToAlphaTime(widget.trip.plannedStart?.add(Duration(minutes: widget.trip.adjustment)).toString())} - ${dateToAlphaTime(widget.trip.plannedEnd?.add(Duration(minutes: widget.trip.adjustment)).toString())}',
        style: const TextStyle(
            color: Color(0xff7b7b7b),
            fontFamily: 'Lexend',
            fontSize: 14
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.trip.visible ? Container(
      height: fitSize(200),
      margin: EdgeInsets.only(left: 21, right: 20),
      decoration: BoxDecoration(
        color: const Color(0xfff2f5f7),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Row(
        children: [
          SizedBox(width: 15),
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.only(left: fitSize(5), top: fitSize(30)),
              child: Column(
                children: [
                  _tripDuration(),
                  _tripRoute(),
                ],
              ),
            ),
          ),
          Container(
            width: 80,
            padding: EdgeInsets.only(top: fitSize(30)),
            child: Column(
              children: [
                _vehicleNo(),
                _driverName(),
                _attendantName(),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: fitSize(25), right: fitSize(25)),
            child: IconButton(
              icon: const Icon(
                Icons.edit,
                color: Color(0xffF52C65),
                size: 30,
              ),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AssignPage(trip: widget.trip),
                ));
              },
            ),
          ),
        ],
      ),
    ) : Container();
  }

  Future<bool?> showConfirmDialog(BuildContext buildContext) async {
    return showDialog<bool>(
      context: buildContext,
      builder: (context) {
        return AlertDialog(
          title: Text(
            AppLocalizations.of(context)?.confirmRejectThisTrip ?? 'Confirm to reject this trip ?',
            style: const TextStyle(
              fontWeight: FontWeight.normal,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(AppLocalizations.of(context)?.cancel ?? 'Cancel', style: TextStyle(fontSize: fitSize(40))),
              onPressed: () => Navigator.of(context).pop(), // 关闭对话框
            ),
            TextButton(
              child: Text(AppLocalizations.of(context)?.yes ?? 'Yes', style: TextStyle(fontSize: fitSize(40))),
              onPressed: () async {
                await TripService.rejectTrip(widget.trip.id);
              },
            ),
          ],
        );
      },
    );
  }
}
