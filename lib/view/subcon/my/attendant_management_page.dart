

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:tfleet/locale/app_localizations.dart';
import 'package:tfleet/model/user.dart';
import 'package:tfleet/service/user_service.dart';
import 'package:tfleet/utils/format_utils.dart';
import 'package:tfleet/utils/global.dart';
import 'package:tfleet/view/feedback/page_feedback.dart';
import 'package:tfleet/view/subcon/component/user_card.dart';
import 'package:tfleet/view/subcon/component/user_profile.dart';

class AttendantManagementPage extends StatefulWidget {
  const AttendantManagementPage({Key? key}) : super(key: key);

  @override
  State<AttendantManagementPage> createState() => _AttendantManagementPageState();
}

class _AttendantManagementPageState extends State<AttendantManagementPage> {

  final List<User> _attendantList = [];

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
    _attendantList.clear();
    await _getAttendantList();
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

  void _onDelete(User user) {
    setState(() {
      _attendantList.remove(user);
    });
  }

  Future _getAttendantList() async {
    Map<String, String> params = {};
    params['roleId'] = '4';
    params['ownerId'] = Global.getUserId()!.toString();
    var attendants = await UserService.listUser(params);
    for (Map<String, dynamic> attendantJson in attendants) {
      if (attendantJson['status'] > -1) {
        User attendant = User.fromJson(attendantJson);
        _attendantList.add(attendant);
      }
    }
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffE40947),
        title: Text(AppLocalizations.of(context)?.attendant ?? 'Attendants'),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: fitSize(25)),
            child: IconButton(
              icon: const Icon(Icons.add, color: Colors.white,),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => UserProfile(title: AppLocalizations.of(context)?.addAttendant ??'Add Attendant', type: 2,),
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
          empty: _attendantList.isEmpty,
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
          itemCount: _attendantList.length,
          // controller: _scrollController,
          // ignore: missing_return
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: [
                SizedBox(height: fitSize(5)),
                UserCard(user: _attendantList[index], onDelete: _onDelete, type: 2,)
              ],
            );
          },
        ),
      ),
    );
  }

}
