

import 'package:flutter/services.dart';
import 'package:tfleet/locale/app_localizations.dart';
import 'package:tfleet/main.dart';
import 'package:tfleet/model/passenger/address.dart';
import 'package:tfleet/model/passenger/child.dart';
import 'package:tfleet/service/passenger/address_service.dart';
import 'package:tfleet/service/passenger/child_service.dart';
import 'package:tfleet/utils/format_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:tfleet/utils/global.dart';
import 'package:tfleet/view/feedback/page_feedback.dart';
import 'package:tfleet/view/passenger/app/service_page.dart';
import 'package:tfleet/view/passenger/component/address_profile.dart';
import 'package:tfleet/view/passenger/component/child_profile.dart';
import 'package:tfleet/view/passenger/component/children_card.dart';

class ChildrenPage extends StatefulWidget {
  const ChildrenPage({Key? key}) : super(key: key);

  @override
  State<ChildrenPage> createState() => _ChildrenPageState();
}

class _ChildrenPageState extends State<ChildrenPage> {

  final List<Child> _childrenList = [];

  bool loading = true;
  bool error = false;
  bool replace = true;
  bool hasMore = true;
  String errorMsg = '';

  late EasyRefreshController _easyRefreshController;

  @override
  void initState() {
    super.initState();
    _easyRefreshController = EasyRefreshController();
    _getChildrenList();
  }

  @override
  void dispose() {
    _easyRefreshController.dispose();
    super.dispose();
  }

  Future _onRefresh() async {
    await _getChildrenList();
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

  Future _getChildrenList() async {
    if (Global.yourChildren.isNotEmpty) {
      _childrenList.clear();
      _childrenList.addAll(Global.yourChildren);
    } else {
      var children = await ChildService.getChildren(Global.getUserId()!);
      for(Map<String, dynamic> childJson in children) {
        Child child = Child.fromJson(childJson);
        _childrenList.add(child);
        Global.yourChildren.add(child);
      }
    }
    if (mounted) {
      setState(() {});
    }
  }

  void _onDelete(Child child) {
    setState(() {
      _childrenList.remove(child);
      Global.yourChildren.remove(child);
    });
  }

  @override
  Widget build(BuildContext context) {

    DateTime now = DateTime.now();
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
    return Scaffold(
      body: Column(
        children: [
          Stack(
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
                    'Your Children',
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
          ),
          const SizedBox(height: 30,),
          Expanded(
            child: EasyRefresh(
              firstRefresh: false,
              firstRefreshWidget: const PageFeedBack(firstRefresh: false).build(),
              emptyWidget: PageFeedBack(
                loading: loading,
                error: error,
                empty: _childrenList.isEmpty,
                errorMsg: errorMsg,
                onErrorTap: () => {} /*_easyRefreshController.callRefresh()*/,
                onEmptyTap: () => {} /*_easyRefreshController.callRefresh()*/,
              ).build(),
              footer: ClassicalFooter(),
              controller: _easyRefreshController,
              enableControlFinishRefresh: false,
              enableControlFinishLoad: true,
              onRefresh: _onRefresh,
              // onLoad: _onLoad,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _childrenList.length + 1,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  if (index == _childrenList.length) {
                    return _buildAddButton(context);
                  }
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ChildrenCard(child: _childrenList[index], onDelete: _onDelete,),
                      SizedBox(height: fitSize(15)),
                    ],
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 40,),
          // _buildAddButton(context),
        ],
      ),
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return Container(
      height: fitSize(112.5),
      margin: const EdgeInsets.only(left:50, top: 30, right: 50),
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith((states) => const Color(0xffE40947)),
            shape: MaterialStateProperty.all(const StadiumBorder(
                side: BorderSide(style: BorderStyle.none)))),
        child: Text('Add Child',
            style: TextStyle(
                color: Colors.white,
                fontSize: fitSize(50)
            )),
        onPressed: () {
          if (Global.getAddress() != null) {
            Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const ChildProfile(),
                      )).then((value) {
              if (value) {
                setState(() {
                  _childrenList.clear();
                  _childrenList.addAll(Global.yourChildren);
                });
                // if (mounted) {
                //   Navigator.pushReplacement(context, MaterialPageRoute(
                //     builder: (context) => const ServicePage(fromAdd: true),
                //   ));
                // }
              }
            });
          } else {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const AddressProfile(),
            ));
          }
        },
      ),
    );
  }
}
