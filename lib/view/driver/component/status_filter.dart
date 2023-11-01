

import 'package:flutter/material.dart';
import 'package:tfleet/locale/app_localizations.dart';
import 'package:tfleet/utils/format_utils.dart';
import 'package:tfleet/utils/t_color.dart';


class StatusFilter extends StatefulWidget {
  const StatusFilter({Key? key, required this.checkboxSelectedList, this.onFiltered}) : super(key: key);

  final Map<String, bool> checkboxSelectedList;
  final onFiltered;

  @override
  State<StatusFilter> createState() => _StatusFilterState();
}

class _StatusFilterState extends State<StatusFilter> {

  final List<String> _statusList = ['Planned', 'Completed', 'In progress', 'Cancelled'];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for (var e in _statusList) {
      widget.checkboxSelectedList[e] = false;
    }
  }

  String getLocalizedStatusText(String key) {
    switch (key) {
      case 'Planned':
        return AppLocalizations.of(context)?.planned ?? 'Planned';
      case 'Completed':
        return AppLocalizations.of(context)?.completed ?? 'Completed';
      case 'In progress':
        return AppLocalizations.of(context)?.inProgress ?? 'In progress';
      case 'Cancelled':
        return AppLocalizations.of(context)?.password ?? 'Cancelled';
      default:
        return '';
    }
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
                  child: Text(AppLocalizations.of(context)?.clear ?? 'Clear', style: TextStyle(color: Colors.blue),)
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
              itemCount: _statusList.length,
              itemBuilder: (context, index) {
                return CheckboxListTile(
                  onChanged: (isCheck) {
                    setState(() {
                      widget.checkboxSelectedList[_statusList[index]] = isCheck!;
                    });
                  },
                  selected: false,
                  checkColor: Colors.black,
                  value: widget.checkboxSelectedList[_statusList[index]],
                  title: Text(getLocalizedStatusText(_statusList[index]),
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
