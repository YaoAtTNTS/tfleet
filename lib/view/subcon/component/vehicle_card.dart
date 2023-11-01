

import 'package:flutter/material.dart';
import 'package:tfleet/locale/app_localizations.dart';
import 'package:tfleet/model/subcon/vehicle.dart';
import 'package:tfleet/service/subcon/vehicle_service.dart';
import 'package:tfleet/utils/format_utils.dart';

class VehicleCard extends StatefulWidget {
  const VehicleCard({Key? key, required this.vehicle, required this.onDelete}) : super(key: key);

  final Vehicle vehicle;
  final Function onDelete;

  @override
  State<VehicleCard> createState() => _VehicleCardState();
}

class _VehicleCardState extends State<VehicleCard> {


  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xffFFFFDD),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: Text(
              widget.vehicle.vehicleNo,
              softWrap: true,
              style: const TextStyle(
                color: Color(0xff1E1F26),
                fontWeight: FontWeight.bold,
                fontFamily: 'Sora',
                fontSize: 18,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: Text(
              '${widget.vehicle.capacity}',
              softWrap: true,
              style: const TextStyle(
                color: Color(0xff1E1F26),
                fontWeight: FontWeight.bold,
                fontFamily: 'Sora',
                fontSize: 18,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
            },
            child: Center(
              child: IconButton(
                icon: const Icon(
                  Icons.delete,
                  size: 30,
                  color: Color(0xffE40947),
                ),
                onPressed: () {
                  showConfirmDialog(context);
                },
              ),
            ),
          ),
        ],
      ),
    ) ;
  }

  Future<bool?> showConfirmDialog(BuildContext buildContext) async {
    return showDialog<bool>(
      context: buildContext,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Confirm to remove this vehicle?',
            style: TextStyle(
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
                widget.onDelete(widget.vehicle);
                VehicleService.deleteVehicle(widget.vehicle.id!);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

}
