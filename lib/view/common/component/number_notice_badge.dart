

import 'package:flutter/material.dart';
import 'package:tfleet/utils/format_utils.dart';

class NumberNoticeBadge extends StatelessWidget {
  const NumberNoticeBadge({Key? key, this.size, required this.count, }) : super(key: key);

  final double? size;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center, height: size ?? fitSize(40), width: size ?? fitSize(40),
        decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(100.0)),
        child: Text(count > 99 ? '...' : '$count', style: const TextStyle(color: Colors.white, fontSize: 12.0)),
    );
  }
}


