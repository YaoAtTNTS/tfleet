

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tfleet/main.dart';
import 'package:tfleet/model/driver/trip.dart';
import 'package:tfleet/model/passenger/attendance.dart';
import 'package:tfleet/service/driver/trip_service.dart';
import 'package:tfleet/utils/constants.dart';

class TripDetailsPage extends StatelessWidget {
  const TripDetailsPage({Key? key, required this.attendance}) : super(key: key);

  final Attendance attendance;

  String _etaToTimeString(int eta) {
    return '${eta~/60<10 ? '0':''}${eta~/60}${eta%60<10 ? '0': ''}${eta%60}hrs';
  }

  Widget _avatar() {
    return GestureDetector(
      onTap: () {

      },
      child: Container(
        width: 50,
        height: 50,
        child: ClipOval(
          child: CachedNetworkImage(
            placeholder: (context, url) => const SizedBox(
              width: 40,
              height: 40,
              child: Center(child: CircularProgressIndicator()),
            ),
            imageUrl: Constants.PROFILE_IMAGE_DEFAULT_URL,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                width: width,
                height: width * 0.675,
                decoration: BoxDecoration(
                    color: const Color(0xffe40947),
                    borderRadius: BorderRadius.circular(18)
                ),
              ),
              Positioned(
                left: 67,
                  top: 61,
                  child: Column(
                    children: [
                      Text(
                        attendance.childName,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 21,
                          fontFamily: 'Lexend Deca'
                        ),
                      ),
                      const Text(
                          'From',
                        style: TextStyle(
                            color: Color(0xffffffdd),
                            fontSize: 16,
                            fontFamily: 'Lexend Deca'
                        ),
                      ),
                      Text(
                        attendance.boardPoint ?? '',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'Lexend Deca'
                        ),
                      ),
                      Container(
                        width: 280,
                          height: 1,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 11,),
                      const Text(
                        'To',
                        style: TextStyle(
                            color: Color(0xffffffdd),
                            fontSize: 16,
                            fontFamily: 'Lexend Deca'
                        ),
                      ),
                      Text(
                        attendance.alightPoint ?? '',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'Lexend Deca'
                        ),
                      ),
                    ],
                  ),
              ),
              Positioned(
                left: 43,
                  top: 111,
                  child: Column(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(10)
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 69,
                        color: Colors.white,
                      ),
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10)
                        ),
                      ),
                    ],
                  )
              ),
            ],
          ),
          const SizedBox(height: 32,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'BUS No: ${attendance.vehicleNo}\nRoute No: ${attendance.routeNo}',
                style: const TextStyle(
                  color: Color(0xff030303),
                  fontFamily: 'Lexend',
                  fontWeight: FontWeight.w500,
                  fontSize: 18
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(right: 36),
                child: Text(
                  'ETA: \n${_etaToTimeString(attendance.estBoard ?? 0)}',
                  style: const TextStyle(
                      color: Color(0xffff6600),
                      fontFamily: 'Lexend Deca',
                      fontWeight: FontWeight.w600,
                      fontSize: 22
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 42,),
          const Text(
            'Served by',
            style: TextStyle(
                color: Color(0xff030303),
                fontFamily: 'Lexend',
                fontWeight: FontWeight.w500,
                fontSize: 18
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _avatar(),
              Text(
                attendance.driverName ?? '',
                style: const TextStyle(
                    color: Color(0xff0D1F2D),
                    fontFamily: 'Lexend Deca',
                    fontWeight: FontWeight.w500,
                    fontSize: 16
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _avatar(),
              Text(
                attendance.attendantName ?? '',
                style: const TextStyle(
                    color: Color(0xff0D1F2D),
                    fontFamily: 'Lexend Deca',
                    fontWeight: FontWeight.w500,
                    fontSize: 16
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
