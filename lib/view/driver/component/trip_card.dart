

import 'package:flutter/material.dart';
import 'package:tfleet/locale/app_localizations.dart';
import 'package:tfleet/model/driver/trip.dart';
import 'package:tfleet/service/driver/trip_service.dart';
import 'package:tfleet/utils/format_utils.dart';
import 'package:tfleet/utils/t_color.dart';
import 'package:tfleet/utils/toast.dart';

class TripCard extends StatefulWidget {
  const TripCard({Key? key, required this.trip}) : super(key: key);

  final Trip trip;
  @override
  State<TripCard> createState() => _TripCardState();
}

class _TripCardState extends State<TripCard> {


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
          decoration: widget.trip.status == -1 ? TextDecoration.lineThrough : TextDecoration.none ,
        ),
      ),
    );
  }

  Widget _routeNo() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20),
      height: 24,
      width: 60,
      decoration: BoxDecoration(
        color: const Color(0xffe40947),
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.center,
      child: Text(
        widget.trip.routeNo,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontFamily: 'Lexend'
        ),
      ),
    );
  }

  Widget _tripRoute() {
    return Container(
      margin: EdgeInsets.only(left: fitSize(20)),
      alignment: Alignment.centerLeft,
      child: Text(
        '${widget.trip.departure} to ${widget.trip.destination}',
        softWrap: true,
        style: const TextStyle(
            color: Colors.black,
            fontFamily: 'Lexend',
            fontSize: 16
        ),
      ),
    );
  }

  Widget _tripStartTime() {
    return Container(
      margin: EdgeInsets.only(left: fitSize(30)),
      alignment: Alignment.centerLeft,
      child: Text(
          widget.trip.status == 4 ? dateToAlphaTime(widget.trip.startedAt?.toLocal().toString()): dateToAlphaTime(widget.trip.plannedStart?.add(Duration(minutes: widget.trip.adjustment)).toLocal().toString()),
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
              padding: EdgeInsets.only(left: fitSize(5), top: fitSize(40)),
              child: Column(
                children: [
                  _tripStartTime(),
                  SizedBox(height: fitSize(12.5)),
                  Expanded(child: _tripRoute()),
                  SizedBox(height: fitSize(12.5)),
                ],
              ),
            ),
          ),
          _routeNo(),
          const SizedBox(width: 15),
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
            AppLocalizations.of(context)?.confirmRemoveThisTrip ?? 'Confirm to remove this trip?',
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
                TripService.deleteTrip(widget.trip.id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
