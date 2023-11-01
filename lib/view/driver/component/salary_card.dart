

import 'package:flutter/material.dart';
import 'package:tfleet/model/driver/salary.dart';
import 'package:tfleet/model/driver/trip.dart';
import 'package:tfleet/utils/format_utils.dart';
import 'package:tfleet/view/driver/component/salary_trip_card.dart';

class SalaryCard extends StatefulWidget {
  const SalaryCard({Key? key, required this.salary}) : super(key: key);

  final Salary salary;
  @override
  State<SalaryCard> createState() => _SalaryCardState();
}

class _SalaryCardState extends State<SalaryCard> {

  bool isFolded = true;
  List<Trip> _tripsOfMonth = [];

  Future _getTripsOfMonth() async {
    List<int> ids = [1,2,3,4,5];
    List<String> vehicleNos = ['PC2012A', 'PB3122C', 'PC2012A', 'PB3122C', 'PC2012A'];
    List<double> startLats = [1.33211, 1.33211, 1.33211, 1.33211, 1.33211];
    List<double> startLons = [103.89198, 103.89198, 103.89198, 103.89198, 103.89198];
    List<String> departures = ['Oxley Bizhub 2', 'Oxley Bizhub 2', 'Oxley Bizhub 2', 'Oxley Bizhub 2', 'Oxley Bizhub 2'];
    List<double> endLats = [1.33656, 1.32326, 1.33656, 1.32326, 1.33656];
    List<double> endLons = [103.92129, 103.86495, 103.92129, 103.86495,103.92129];
    List<String> destinations = ['Damai Primary School', 'Bendemeer Primary School', 'Damai Primary School', 'Bendemeer Primary School', 'Damai Primary School'];
    List<int> statuses = [2,2,2,2,2];
    List<DateTime> startedAts = [DateTime(2022,12,1,8,30,19),DateTime(2022,12,1,13,30,14),DateTime(2022,12,2,8,30,24),DateTime(2022,12,2,13,30,37),DateTime(2022,12,3,8,30,8)];
    List<DateTime> endedAts = [DateTime(2022,12,1,8,50,19),DateTime(2022,12,1,14,10,12),DateTime(2022,12,2,9,05,31),DateTime(2022,12,2,14,09,33),DateTime(2022,12,3,9,10,18)];

    for (int i = 0; i < 5; i++) {
      Trip trip = Trip(
        id: ids[i],
        driverId: 1,
        type: 1,
        vehicleNo: vehicleNos[i],
        plannedPax: 20,
        boardPax: 20,
        alightPax: 20,
        startLat: startLats[i],
        startLon: startLons[i],
        departure: departures[i],
        endLat: endLats[i],
        endLon: endLons[i],
        destination: destinations[i],
        status: statuses[i],
        createdAt: null,
        plannedStart: null,
        plannedEnd: null,
        startedAt: startedAts[i] ,
        endedAt: endedAts[i],
        attendantId: null,
        routeId: 1,
        remark: '', ownerId: null,
        adjustment: 0,
        routeNo: 'A1'
      );
      trip.isFullTrip = trip.endedAt!.isAfter(trip.startedAt!.add(const Duration(minutes: 30)));
      _tripsOfMonth.add(trip);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            if (isFolded) {
              if (_tripsOfMonth.isEmpty) {
                await _getTripsOfMonth();
              }
              setState(() {
                isFolded = false;
              });
            } else {
              setState(() {
                isFolded = true;
              });
            }
          },
            child: Container(
              width: MediaQuery.of(context).size.width*0.9,
              padding: EdgeInsets.all(fitSize(40)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(fitSize(12.5))),
                color: Colors.lightGreen,
              ),
              child: Row(
                children: [
                  Text(
                    widget.salary.month,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: fitSize(40)
                    ),
                  ),
                  SizedBox(width: fitSize(40),),
                  Text(
                    'Salary: ${widget.salary.salary}',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: fitSize(40)
                    ),
                  ),
                  SizedBox(width: fitSize(40),),
                  Text(
                    'Total trips: ${widget.salary.tripsAmount}',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: fitSize(40)
                    ),
                  ),
                ],
              ),
            )
        ),
        isFolded ? Container() : ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _tripsOfMonth.length,
          // controller: _scrollController,
          // ignore: missing_return
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: [
                SalaryTripCard(trip: _tripsOfMonth[index], )
              ],
            );
          },
        ),
      ],
    );
  }
}
