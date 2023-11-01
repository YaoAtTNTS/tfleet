

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:tfleet/locale/app_localizations.dart';
import 'package:tfleet/main.dart';
import 'package:tfleet/model/passenger/child.dart';
import 'package:tfleet/model/passenger/leave.dart';
import 'package:tfleet/service/passenger/child_service.dart';
import 'package:tfleet/service/passenger/leave_service.dart';
import 'package:tfleet/utils/constants.dart';
import 'package:tfleet/utils/format_utils.dart';
import 'package:tfleet/utils/global.dart';
import 'package:tfleet/view/common/profile_image.dart';
import 'package:tfleet/view/feedback/page_feedback.dart';
import 'package:tfleet/view/passenger/app/leave_apply_page.dart';
import 'package:tfleet/view/passenger/component/leave_card.dart';

class LeavePage extends StatefulWidget {
  const LeavePage({Key? key}) : super(key: key);

  @override
  State<LeavePage> createState() => _LeavePageState();
}

class _LeavePageState extends State<LeavePage> {

  final List<Child> _childrenList = [];
  // final List<Leave> _leaveList = [];

  final Map<int, List<Leave>> _childLeaveMap = {};

  int _selectedChildIndex = 0;

  bool _isViewRecords = true;

  bool _isUpdated = false;

  Future _getChildrenList() async {
    if (Global.yourChildren.isNotEmpty) {
      _childrenList.addAll(Global.yourChildren);
    } else {
      var children = await ChildService.getChildren(Global.getUserId()!);
      for(Map<String, dynamic> childJson in children) {
        Child child = Child.fromJson(childJson);
        _childrenList.add(child);
        Global.yourChildren.add(child);
      }
    }
  }

  Future _getLeaveList() async {
    // _leaveList.clear();
    if (!_isUpdated) {
      _isUpdated = true;
      _childLeaveMap.clear();
      await _getChildrenList();
      for (Child child in _childrenList) {
        _childLeaveMap[child.id!] = [];
        Map<String, dynamic> params = {};
        params['childId'] = child.id;
        var leaves = await LeaveService.getLeaves(params);
        for (Map<String, dynamic> leaveJson in leaves) {
          Leave leave = Leave.fromJson(leaveJson);
          _childLeaveMap[child.id]!.add(leave);
          // _leaveList.add(leave);
        }
      }
      if (mounted) {
        setState(() {});
      }
    }

  }

  void _onLeaveSubmit () {
    setState(() {
      _isViewRecords = true;
      _isUpdated = false;
    });
  }

  @override
  void initState() {
    super.initState();
    // _getLeaveList();
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildHeader(width),
            const SizedBox(height: 10,),
            _buildChildrenList(),
            const SizedBox(height: 10,),
            _isViewRecords ? _buildLeaveRecords() : LeaveApplyPage(onSubmit: _onLeaveSubmit, child: _childrenList[_selectedChildIndex], ),
            SizedBox(height: fitSize(75),),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(double width) {
    DateTime now = DateTime.now();
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          width: width,
          height: width * 0.28,
          decoration: BoxDecoration(
              color: const Color(0xffe40947),
              borderRadius: BorderRadius.circular(18)
          ),
        ),
        Positioned(
          left: 20,
          top: 34,
          child: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.chevron_left,
              size: 30,
              color: Colors.white,
            ),
          ),
        ),
        Positioned(
          top: 48,
          child: Container(
            width: width,
            alignment: Alignment.topCenter,
            child: const Text(
              'Leave Management',
              style: TextStyle(
                  fontSize: 24,
                  fontFamily: 'Lexend Deca',
                  fontWeight: FontWeight.bold,
                  color: Colors.white
              ),
            ),
          ),
        ),
        Positioned(
            top: width*0.22,
            left: 7,
            child: Container(
              height: 2,
              width: width - 10,
              color: Colors.white,
            )
        ),
        Positioned(
            bottom: 4,
            left: 10,
            width: width - 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Welcome, ${Global.username()}',
                  style: const TextStyle(
                      fontSize: 13,
                      fontFamily: 'Lexend Deca',
                      color: Colors.white
                  ),
                ),
                Text(
                  '${dateToAlphaMonth(now.toString())} ${now.year}',
                  style: const TextStyle(
                      fontSize: 13,
                      fontFamily: 'Lexend Deca',
                      color: Colors.white
                  ),
                ),
              ],
            )
        ),
      ],
    );
  }

  Widget _buildChildrenList() {
    return Container(
      height: 72,
      margin: const EdgeInsets.only(left: 10, right: 10),
      // width: width,
      child: ListView.separated(
          itemCount: _childrenList.length + 1,
          scrollDirection: Axis.horizontal,
          // physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            if (index == _childrenList.length) {
              return Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: const Color(0xffE40947),
                  borderRadius: BorderRadius.circular(36),
                ),
                child: _isViewRecords ? IconButton(
                  onPressed: () {
                    setState(() {
                      _isViewRecords = false;
                    });
                  },
                  icon: const Icon(Icons.holiday_village_outlined),
                ) : IconButton(
                    onPressed: () {
                      setState(() {
                        _isViewRecords = true;
                      });
                    }, icon: const Icon(Icons.list)),
              );
            }
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedChildIndex = index;
                });
              },
              child: _buildChildCard(_selectedChildIndex == index, _childrenList[index].url),
            );
          }, separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(width: 10,);
      },
      ),
    );
  }

  Widget _buildChildCard(bool isSelected, String? url) {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: isSelected ? const Color(0xffE40947) : Colors.white),
        borderRadius: BorderRadius.circular(36),
      ),
      child: ClipOval(
        child: CachedNetworkImage(
          placeholder: (context, url) => const SizedBox(
            child: Center(child: CircularProgressIndicator()),
          ),
          imageUrl: url ?? Constants.PROFILE_IMAGE_DEFAULT_URL,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildLeaveRecords() {
    return FutureBuilder<void>(
      future: _getLeaveList(),
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.done){
          if (_childrenList.isNotEmpty) {
            Child child = _childrenList[_selectedChildIndex];
            return _childLeaveMap[child.id]!.isNotEmpty ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    'Leave Records for ${child.name}',
                    style: const TextStyle(
                      color: Color(0xff030303),
                      fontSize: 18,
                      fontFamily: 'Lexend Deca',
                    ),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _childLeaveMap[child.id]!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        SizedBox(height: fitSize(5)),
                        GestureDetector(
                          onLongPress: () async {
                            bool? isConfirmed = await showConfirmDialog(context, index);
                            if (isConfirmed != null && isConfirmed) {
                              setState(() {
                                _childLeaveMap[child.id]!.removeAt(index);
                              });
                            }
                          },
                          child: LeaveCard(leave: _childLeaveMap[child.id]![index],),
                        )
                      ],
                    );
                  },
                ),
              ],
            ) : Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.only(left: 20),
              child: Text(
                'Currently no leave Records for ${child.name}',
                style: const TextStyle(
                  color: Color(0xff030303),
                  fontSize: 18,
                  fontFamily: 'Lexend Deca',
                ),
              ),
            );
          } else {
            return Container();
          }
        } else {
          return Container();
        }
      });
  }

  void _deleteLeave(int id) async {
    Map<String, dynamic> params = {};
    params['id'] = id;
    params['status'] = -1;
    await LeaveService.updateLeave(params);
  }

  Future<bool?> showConfirmDialog(BuildContext buildContext, int id) async {
    return showDialog<bool>(
      context: buildContext,
      builder: (context) {
        return AlertDialog(
          title: Text(
            AppLocalizations.of(context)?.confirmToDeleteLeave ?? 'Confirm to delete this leave?',
            style: const TextStyle(
              fontWeight: FontWeight.normal,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(AppLocalizations.of(context)?.cancel ?? 'Cancel', style: TextStyle(fontSize: fitSize(40))),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: Text(AppLocalizations.of(context)?.yes ?? 'Yes', style: TextStyle(fontSize: fitSize(40))),
              onPressed: () async {
                Navigator.of(context).pop(true);
                _deleteLeave(id);
              },
            ),
          ],
        );
      },
    );
  }

}
