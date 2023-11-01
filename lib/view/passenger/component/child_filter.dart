

import 'package:flutter/material.dart';
import 'package:tfleet/locale/app_localizations.dart';
import 'package:tfleet/model/passenger/child.dart';
import 'package:tfleet/service/passenger/child_service.dart';
import 'package:tfleet/utils/format_utils.dart';
import 'package:tfleet/utils/global.dart';
import 'package:tfleet/utils/t_color.dart';


class ChildFilter extends StatefulWidget {
  const ChildFilter({Key? key, required this.checkboxSelectedList, required this.onFiltered}) : super(key: key);

  final Map<String, bool> checkboxSelectedList;
  final Function onFiltered;

  @override
  State<ChildFilter> createState() => _ChildFilterState();
}

class _ChildFilterState extends State<ChildFilter> {



  final List<String> _children = [];

  _getChildren() async {
    if (Global.getUserId() != null) {
      List list = await ChildService.getChildren(Global.getUserId()!);
      for(Map<String, dynamic> childJson in list) {
        Child child = Child.fromJson(childJson);
        _children.add(child.name);
        widget.checkboxSelectedList[child.name] = false;
      }
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getChildren();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left_outlined),
                onPressed: () {
                  Navigator.pop(context);
                  widget.onFiltered();
                },
              ),
              TextButton(
                  onPressed: () {
                    setState(() {
                      widget.checkboxSelectedList.updateAll((key, value) => false);
                    });
                  },
                  child: Text(AppLocalizations.of(context)?.clear ?? 'Clear', style: const TextStyle(color: Colors.blue),)
              )
            ],
          ),
          SizedBox(height: fitSize(10),),
          Container(height: fitSize(3), color: TColor.inactive),
          ListView.separated(
              shrinkWrap: true,
              separatorBuilder: (BuildContext context, int index) {
                return Divider(
                  height: fitSize(1.25),
                  color: Colors.grey,
                );
              },
              itemCount: _children.length,
              itemBuilder: (context, index) {
                return CheckboxListTile(
                  onChanged: (isCheck) {
                    setState(() {
                      widget.checkboxSelectedList[_children[index]] = isCheck!;
                    });
                  },
                  selected: false,
                  checkColor: Colors.black,
                  value: widget.checkboxSelectedList[_children[index]],
                  title: Text(_children[index],
                      style: TextStyle(
                        fontSize: fitSize(40),
                      )),
                  controlAffinity: ListTileControlAffinity.leading,
                );
              }
          ),
        ]);
  }
}
