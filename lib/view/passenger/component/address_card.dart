

import 'package:tfleet/locale/app_localizations.dart';
import 'package:tfleet/model/passenger/address.dart';
import 'package:tfleet/service/passenger/address_service.dart';
import 'package:tfleet/utils/t_color.dart';
import 'package:tfleet/utils/format_utils.dart';
import 'package:flutter/material.dart';
import 'package:tfleet/view/passenger/component/address_profile.dart';

class AddressCard extends StatefulWidget {
  const AddressCard({Key? key, required this.address, required this.onDelete}) : super(key: key);

  final Address address;
  final Function onDelete;
  @override
  State<AddressCard> createState() => _AddressCardState();
}

class _AddressCardState extends State<AddressCard> {


  Widget _name() {
    return Container(
      margin: EdgeInsets.only(left: fitSize(20)),
      alignment: Alignment.centerLeft,
      child: Text(
        widget.address.name ?? '',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: fitSize(40),
          color: TColor.active,
          fontWeight: FontWeight.bold
        ),
      ),
    );
  }

  Widget _address() {
    return Container(
      margin: EdgeInsets.only(left: fitSize(20)),
      alignment: Alignment.centerLeft,
      child: Text(
        widget.address.unitNo ?? '' ', ' + widget.address.address,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: fitSize(30),
          color: TColor.inactive,
        ),
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
                    padding: EdgeInsets.only(left: fitSize(5), top: fitSize(40)),
                    child: Column(
                      children: [
                        _name(),
                        SizedBox(height: fitSize(12.5)),
                        _address(),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    widthFactor: 1,
                    child: Container(
                      height: fitSize(2.5),
                      color: TColor.in3active,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: fitSize(25)),
                      child: IconButton(
                        icon: Icon(
                          Icons.edit,
                          size: fitSize(50),
                        ),
                        onPressed: () {
                          // Navigator.of(context).push(MaterialPageRoute(
                          //   builder: (context) => AddressProfile(title: AppLocalizations.of(context)?.editAddress ?? 'Edit Address', address: widget.address,),
                          // ));
                        },
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: fitSize(125)),
                      child: IconButton(
                        icon: Icon(
                          Icons.delete,
                          size: fitSize(50),
                        ),
                        onPressed: () {
                          showConfirmDialog(context);
                        },
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

  Future<bool?> showConfirmDialog(BuildContext buildContext) async {
    return showDialog<bool>(
      context: buildContext,
      builder: (context) {
        return AlertDialog(
          title: Text(
            AppLocalizations.of(context)?.confirmToRemoveAddress ?? 'Confirm to remove this address?',
            style: const TextStyle(
              fontWeight: FontWeight.normal,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(AppLocalizations.of(context)?.cancel ?? 'Cancel', style: TextStyle(fontSize: fitSize(40))),
              onPressed: () => Navigator.of(context).pop(), // 关闭对话框
            ),
            TextButton(
              child: Text(AppLocalizations.of(context)?.yes ?? 'Yes', style: TextStyle(fontSize: fitSize(40))),
              onPressed: () async {
                widget.onDelete(widget.address);
                AddressService.deleteAddress(widget.address.id!);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
