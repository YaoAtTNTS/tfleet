

import 'package:flutter/material.dart';
import 'package:tfleet/model/driver/payout.dart';
import 'package:tfleet/utils/format_utils.dart';

class PayoutCard extends StatefulWidget {
  const PayoutCard({Key? key, required this.payout}) : super(key: key);

  final Payout payout;

  @override
  State<PayoutCard> createState() => _PayoutCardState();
}

class _PayoutCardState extends State<PayoutCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width*0.9,
      padding: EdgeInsets.all(fitSize(40)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(fitSize(12.5))),
        color: widget.payout.status == 2 ? Colors.lightGreen : Colors.red,
      ),
      child: Row(
        children: [
          Text(
            widget.payout.month,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: fitSize(40)
            ),
          ),
          SizedBox(width: fitSize(40),),
          Column(
            children: [
              Text(
                'Due: ${widget.payout.due}\n',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: fitSize(40)
                ),
              ),
              Text(
                'Paid: ${widget.payout.paid}',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: fitSize(40)
                ),
              ),
            ],
          ),
          SizedBox(width: fitSize(40),),
          Text(
            widget.payout.status == 2 ? 'Paid at:\n\n ${widget.payout.paidAt.toString().replaceAll('.000Z', '')}' : 'Pending',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: fitSize(30)
            ),
          ),
        ],
      ),
    );
  }
}
