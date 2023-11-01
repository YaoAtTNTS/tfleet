

import 'package:flutter/material.dart';

class RepeatableDayItem extends StatefulWidget {
  const RepeatableDayItem({Key? key, required this.onSelectionChange, required this.index, required this.title, }) : super(key: key);

  final int index;
  final String title;
  final Function onSelectionChange;

  @override
  State<RepeatableDayItem> createState() => _RepeatableDayItemState();
}

class _RepeatableDayItemState extends State<RepeatableDayItem> {

  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isSelected = !_isSelected;
          widget.onSelectionChange(widget.index, _isSelected);
        });
      },
      child: Text(
        widget.title,
        style: TextStyle(
            color: _isSelected ? const Color(0xffF52C65) : const Color(0xff030303),
            fontFamily: 'Lexend Deca',
            fontWeight: _isSelected ? FontWeight.w600 : FontWeight.w400
        ),
      ),
    );
  }
}
