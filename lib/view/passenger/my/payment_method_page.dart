

import 'package:tfleet/model/passenger/payment_method.dart';
import 'package:tfleet/utils/format_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:tfleet/view/feedback/page_feedback.dart';
import 'package:tfleet/view/passenger/component/payment_method_card.dart';

class PaymentMethodPage extends StatefulWidget {
  const PaymentMethodPage({Key? key}) : super(key: key);

  @override
  State<PaymentMethodPage> createState() => _PaymentMethodPageState();
}

class _PaymentMethodPageState extends State<PaymentMethodPage> {

  final List<PaymentMethod> _paymentMethodList = [];

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
    _getChildrenList();
  }

  @override
  void dispose() {
    _easyRefreshController.dispose();
    super.dispose();
  }

  Future _onRefresh() async {
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
    _paymentMethodList.add(PaymentMethod(method: 'Visa', no: ' 4500 ****'));
    _paymentMethodList.add(PaymentMethod(method: 'Ezlink', no: ' **** 258'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text('Payment Method'),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: fitSize(10.0)),
            child: Icon(Icons.add),
          )
        ],
      ),
      body: EasyRefresh(
        firstRefresh: true,
        firstRefreshWidget: PageFeedBack(firstRefresh: true).build(),
        emptyWidget: PageFeedBack(
          loading: loading,
          error: error,
          empty: _paymentMethodList.isEmpty,
          errorMsg: errorMsg,
          onErrorTap: () => _easyRefreshController.callRefresh(),
          onEmptyTap: () => _easyRefreshController.callRefresh(),
        ).build(),
        footer: ClassicalFooter(),
        controller: _easyRefreshController,
        enableControlFinishRefresh: false,
        enableControlFinishLoad: true,
        onRefresh: _onRefresh,
        onLoad: _onLoad,
        child: ListView.builder(
          itemCount: _paymentMethodList.length,
          // controller: _scrollController,
          // ignore: missing_return
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: [
                SizedBox(height: fitSize(5)),
                PaymentMethodCard(payment: _paymentMethodList[index])
              ],
            );
          },
        ),
      ),
    );
  }
}
