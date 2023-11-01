

import 'package:flutter/material.dart';
import 'package:tfleet/model/driver/trip.dart';
import 'package:tfleet/utils/format_utils.dart';
import 'package:tfleet/utils/t_color.dart';

class SalaryTripCard extends StatefulWidget {
  const SalaryTripCard({Key? key, required this.trip}) : super(key: key);

  final Trip trip;
  @override
  State<SalaryTripCard> createState() => _SalaryTripCardState();
}

class _SalaryTripCardState extends State<SalaryTripCard> {


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
            TextSpan(text: '${widget.trip.departure}', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
            const TextSpan(text: ' to '),
            TextSpan(text: '${widget.trip.destination}', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold))
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
            TextSpan(text: widget.trip.startedAt.toString().replaceAll('.000Z', ''), style: const TextStyle(color: Colors.orange)),
            const TextSpan(text: ' to '),
            TextSpan(text: widget.trip.endedAt.toString().replaceAll('.000Z', ''), style: const TextStyle(color: Colors.orange))
          ],
          style: TextStyle(
            fontSize: fitSize(30),
            color: TColor.inactive,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: fitSize(200),
      child: Row(
        children: [
          SizedBox(width: fitSize(12.5)),
          Expanded(
            flex: 1,
            child: Stack(
                children: [
                  Container(
                    padding: EdgeInsets.only(left: fitSize(5), top: fitSize(40)),
                    child: Column(
                      children: [
                        _vehicleNo(),
                        SizedBox(height: fitSize(12.5)),
                        _tripRoute(),
                        SizedBox(height: fitSize(12.5)),
                        _tripDuration(),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: fitSize(25)),
                      child: Text(
                        '+\$${widget.trip.isFullTrip ? '30 for 1' : '15 for 0.5'} trip',
                        style: TextStyle(
                          fontSize: fitSize(40),
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontStyle: FontStyle.italic
                        ),
                      ),
                    ),
                  ),
                ]
            ),
          ),
        ],
      ),
    );
  }
}
