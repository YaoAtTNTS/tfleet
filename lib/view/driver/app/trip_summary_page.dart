

import 'package:flutter/material.dart';
import 'package:tfleet/model/driver/trip.dart';
import 'package:tfleet/utils/format_utils.dart';
import 'package:tfleet/utils/global.dart';
import 'package:tfleet/utils/t_color.dart';

class TripSummaryPage extends StatefulWidget {
  const TripSummaryPage({Key? key, required this.trip}) : super(key: key);

  final Trip trip;

  @override
  State<TripSummaryPage> createState() => _TripSummaryPageState();
}

class _TripSummaryPageState extends State<TripSummaryPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Widget _title() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 80,
          padding: const EdgeInsets.only(left: 20.0),
          child: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.chevron_left,
              color: Colors.black,
              size: 36,
            ),
          ),
        ),
        const Expanded(
            child: Text(
              'Trip Summary',
              style: TextStyle(
                  color: Color(0xff030303),
                  fontSize: 24,
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.bold
              ),
            ),
        ),
        const SizedBox(width: 80,)
      ],
    );
  }

  Widget _tripDate() {
    return Text(
      widget.trip.date ?? '',
      style: const TextStyle(
          color: Color(0xff030303),
          fontSize: 18,
          fontFamily: 'Lexend',
          fontWeight: FontWeight.bold
      ),
    );
  }

  Widget _routeNo() {
    return Row(
      children: [
        const Icon(
          Icons.route,
          color: Color(0xff7b7b7b),
          size: 18,
        ),
        SizedBox(width: 5,),
        Text(
          'Route No: ${widget.trip.routeNo}',
          style: const TextStyle(
              color: Color(0xffff6600),
              fontSize: 13,
              fontFamily: 'Lexend',
              fontWeight: FontWeight.bold
          ),
        ),
      ],
    );
  }

  Widget _period() {
    return Row(
      children: [
        const Icon(
          Icons.query_builder,
          color: Color(0xff7b7b7b),
          size: 18,
        ),
        SizedBox(width: 5,),
        Text(
          '${dateToAlphaTime(widget.trip.startedAt.toString())} - ${dateToAlphaTime(widget.trip.endedAt.toString())}',
          style: const TextStyle(
              color: Color(0xffff6600),
              fontSize: 13,
              fontFamily: 'Lexend',
              fontWeight: FontWeight.bold
          ),
        ),
      ],
    );
  }

  Widget _startDelay() {
    int delay = widget.trip.startedAt!.difference(widget.trip.plannedStart!).inMinutes;
    return RichText(
      text: TextSpan(
        children: <TextSpan>[
          delay < 2 ?
          const TextSpan(text: ' No Delay ', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)) :
          TextSpan(text: ' Delayed $delay minutes', style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        ],
        style: TextStyle(
          fontSize: fitSize(30),
          color: TColor.inactive,
        ),
      ),
    );
  }

  Widget _endDelay() {
    int delay = widget.trip.endedAt!.difference(widget.trip.plannedEnd!).inMinutes;
    return RichText(
      text: TextSpan(
        children: <TextSpan>[
          delay < 2 ?
          const TextSpan(text: ' No Delay ', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)) :
          TextSpan(text: ' Delayed $delay minutes', style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        ],
        style: TextStyle(
          fontSize: fitSize(30),
          color: TColor.inactive,
        ),
      ),
    );
  }

  Widget _routeDetails() {
    return Text(
      '${widget.trip.departure} to ${widget.trip.destination}',
      style: const TextStyle(
          color: Color(0xff030303),
          fontSize: 14,
          fontFamily: 'Lexend',
          fontWeight: FontWeight.bold
      ),
    );
  }

  Widget _individualPax(String title, int amount, int color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '$amount',
          style: TextStyle(
              color: Color(color),
              fontSize: 14,
              fontFamily: 'Sora',
              fontWeight: FontWeight.bold
          ),
        ),
        SizedBox(height: 5,),
        Text(
          title,
          style: TextStyle(
              color: Color(color),
              fontSize: 11,
              fontFamily: 'Lexend',
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: kToolbarHeight,),
            _title(),
            const SizedBox(height: 50,),
            _tripDate(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _routeNo(),
                _period()
              ],
            ),
            _routeDetails(),
            const SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _individualPax('Students', widget.trip.plannedPax, 0xff667AB0),
                _individualPax('Pickup', widget.trip.boardPax, 0xff008D41),
                _individualPax('Dropped', widget.trip.alightPax, 0xffFF6600),
                _individualPax('No board', (widget.trip.plannedPax - widget.trip.boardPax - (widget.trip.absentPax??0)), 0xffFF6600),
                _individualPax('Absence', widget.trip.absentPax ?? 0, 0xffE40947),
              ],
            )
          ],
        ),
      ),
    );
  }
}
