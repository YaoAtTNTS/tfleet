

import 'package:tfleet/locale/app_localizations.dart';
import 'package:tfleet/model/passenger/address.dart';
import 'package:tfleet/service/passenger/address_service.dart';
import 'package:tfleet/utils/format_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:tfleet/utils/global.dart';
import 'package:tfleet/view/feedback/page_feedback.dart';
import 'package:tfleet/view/passenger/component/address_card.dart';
import 'package:tfleet/view/passenger/component/address_profile.dart';



class AddressPage extends StatefulWidget {
  const AddressPage({Key? key}) : super(key: key);

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {


  final List<Address> _addressList = [];

  late EasyRefreshController _easyRefreshController;

  bool loading = true;
  bool error = false;
  bool replace = true;
  bool hasMore = true;
  String errorMsg = '';

  @override
  void initState() {
    super.initState();
    _easyRefreshController = EasyRefreshController();
    // _getAddressList();
  }

  @override
  void dispose() {
    _easyRefreshController.dispose();
    super.dispose();
  }

  Future _onRefresh() async {
    _addressList.clear();
    await _getAddressList();
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

  Future _getAddressList() async {
/*    if (Global.getAddresses().isNotEmpty) {
      _addressList.addAll(Global.getAddresses());
    } else {

    }*/
    var addresses = await AddressService.getAddresses(Global.getUserId()!);
    for (Map<String, dynamic> addressJson in addresses) {
      Address address = Address.fromJson(addressJson);
      _addressList.add(address);
    }
    // Global.saveAddress(_addressList);
    if (mounted) {
      setState(() {});
    }
  }

  void _onDelete(Address address) {
    setState(() {
      _addressList.remove(address);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(AppLocalizations.of(context)?.address ?? 'Address'),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: fitSize(25)),
            child: IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                // Navigator.of(context).push(MaterialPageRoute(
                //   builder: (context) => AddressProfile(title: AppLocalizations.of(context)?.addAddress ??'Add Address'),
                // ));
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
          empty: _addressList.isEmpty,
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
          itemCount: _addressList.length,
          // controller: _scrollController,
          // ignore: missing_return
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: [
                SizedBox(height: fitSize(5)),
                AddressCard(address: _addressList[index], onDelete: _onDelete,)
              ],
            );
          },
        ),
      ),
    );
  }
}
