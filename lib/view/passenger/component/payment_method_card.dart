

import 'package:tfleet/model/passenger/payment_method.dart';
import 'package:tfleet/utils/t_color.dart';
import 'package:tfleet/utils/format_utils.dart';
import 'package:flutter/material.dart';


class PaymentMethodCard extends StatefulWidget {
  const PaymentMethodCard({Key? key, required this.payment}) : super(key: key);

  final PaymentMethod payment;
  @override
  State<PaymentMethodCard> createState() => _PaymentMethodCardState();
}

class _PaymentMethodCardState extends State<PaymentMethodCard> {


  Widget _cardNo() {
    return Container(
      margin: EdgeInsets.only(left: fitSize(20)),
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(
            widget.payment.method == 'Visa' ? 'assets/image/common/visa.png' : 'assets/image/common/ezlink.png',
            width: fitSize(100),
            height: fitSize(100),
          ),
          Text(
            widget.payment.no,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: fitSize(40),
                color: TColor.active,
                fontWeight: FontWeight.bold
            ),
          ),
        ],
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
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: fitSize(25)),
                    child: _cardNo(),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    widthFactor: 1,
                    child: Container(
                      height: 1,
                      color: TColor.in3active,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: fitSize(25)),
                      child: Icon(
                        Icons.edit,
                        size: fitSize(50),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: fitSize(125)),
                      child: Icon(
                        Icons.delete,
                        size: fitSize(50),
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
