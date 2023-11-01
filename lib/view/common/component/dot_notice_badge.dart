

import 'package:flutter/material.dart';
import 'package:tfleet/utils/format_utils.dart';

class DotNoticeBadge extends StatelessWidget {
  const DotNoticeBadge({Key? key, this.size}) : super(key: key);

  final double? size;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center, height: size ?? fitSize(30), width: size ?? fitSize(30),
      decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(100.0)),
    );
  }
}
