

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:tfleet/locale/app_localizations.dart';
import 'package:tfleet/model/subcon/vehicle.dart';
import 'package:tfleet/service/subcon/vehicle_service.dart';
import 'package:tfleet/utils/format_utils.dart';
import 'package:tfleet/utils/global.dart';
import 'package:tfleet/view/feedback/page_feedback.dart';
import 'package:tfleet/view/subcon/component/vehicle_card.dart';
import 'package:tfleet/view/subcon/component/vehicle_profile.dart';

class VehicleManagementPage extends StatefulWidget {
  const VehicleManagementPage({Key? key}) : super(key: key);

  @override
  State<VehicleManagementPage> createState() => _VehicleManagementPageState();
}

class _VehicleManagementPageState extends State<VehicleManagementPage> {

  final List<Vehicle> _vehicleList = [];

  late EasyRefreshController _easyRefreshController;

  bool loading = true;
  bool error = false;
  bool replace = true;
  bool hasMore = true;
  String errorMsg = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _easyRefreshController = EasyRefreshController();
  }

  @override
  void dispose() {
    _easyRefreshController.dispose();
    super.dispose();
  }

  Future _onRefresh() async {
    _vehicleList.clear();
    await _getVehicleList();
    if (error) {
      setState(() => error = false);
    }
    _easyRefreshController.resetLoadState();
  }

  Future _onLoad() async {
   // if (hasMore) {
   // }
    //_easyRefreshController.finishLoad(noMore: !hasMore);
  }

  void _onDelete(Vehicle vehicle) {
    setState(() {
      _vehicleList.remove(vehicle);
    });
  }

  Future _getVehicleList() async {
    Map<String, dynamic> params = {};
    params['ownerId'] = Global.getUserId()!;
    params['status'] = 0;
    var vehicles = await VehicleService.getVehicles(params);
    for (Map<String, dynamic> vehicleJson in vehicles) {
      Vehicle vehicle = Vehicle.fromJson(vehicleJson);
      _vehicleList.add(vehicle);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffE40947),
        title: const Text(
          'Vehicles',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 24,
              fontFamily: 'Raleway'
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: fitSize(25)),
            child: IconButton(
              icon: const Icon(Icons.add, color: Colors.white,),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const VehicleProfile(),
                ));
              },
            ),
          )
        ],
      ),
      body: EasyRefresh(
        firstRefresh: true,
        firstRefreshWidget: PageFeedBack(firstRefresh: true).build(),
        emptyWidget: PageFeedBack(
          loading: loading,
          error: error,
          empty: _vehicleList.isEmpty,
          errorMsg: errorMsg,
          onErrorTap: () => {} /*_easyRefreshController.callRefresh()*/,
          onEmptyTap: () => {} /*_easyRefreshController.callRefresh()*/,
        ).build(),
        footer: ClassicalFooter(),
        controller: _easyRefreshController,
        enableControlFinishRefresh: false,
        enableControlFinishLoad: true,
        onRefresh: _onRefresh,
        onLoad: _onLoad,
        child: ListView.builder(
          itemCount: _vehicleList.length,
          // controller: _scrollController,
          // ignore: missing_return
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: [
                SizedBox(height: fitSize(5)),
                VehicleCard(vehicle: _vehicleList[index], onDelete: _onDelete, )
              ],
            );
          },
        ),
      ),
    );
  }
}
