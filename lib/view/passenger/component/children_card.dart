

import 'package:cached_network_image/cached_network_image.dart';
import 'package:tfleet/locale/app_localizations.dart';
import 'package:tfleet/model/passenger/child.dart';
import 'package:tfleet/service/passenger/child_service.dart';
import 'package:tfleet/utils/constants.dart';
import 'package:tfleet/utils/global.dart';
import 'package:tfleet/utils/t_color.dart';
import 'package:tfleet/utils/format_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:tfleet/view/driver/component/student_profile.dart';
import 'package:tfleet/view/passenger/app/leave_apply_page.dart';
import 'package:tfleet/view/passenger/component/child_profile_view.dart';

import 'child_profile.dart';

class ChildrenCard extends StatefulWidget {
  const ChildrenCard({Key? key, required this.child, required this.onDelete}) : super(key: key);

  final Child child;
  final Function onDelete;

  @override
  State<ChildrenCard> createState() => _ChildrenCardState();
}

class _ChildrenCardState extends State<ChildrenCard> {

  Widget _avatar() {
    return Container(
      width: fitSize(150),
      height: fitSize(150),
      decoration: BoxDecoration(
        color: TColor.page,
        borderRadius: BorderRadius.circular(fitSize(100)),
      ),
      child: ClipOval(
        child: CachedNetworkImage(
          placeholder: (context, url) => SizedBox(
            width: fitSize(125),
            height: fitSize(125),
            child: const Center(child: CircularProgressIndicator()),
          ),
          imageUrl: widget.child.url ?? Constants.PROFILE_IMAGE_DEFAULT_URL,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  // Widget _name() {
  //   return Container(
  //     margin: EdgeInsets.only(left: fitSize(20)),
  //     alignment: Alignment.centerLeft,
  //     child: Text(
  //       widget.child.name,
  //       maxLines: 1,
  //       overflow: TextOverflow.ellipsis,
  //       style: TextStyle(
  //         fontSize: fitSize(40),
  //         color: TColor.active,
  //         fontWeight: FontWeight.bold
  //       ),
  //     ),
  //   );
  // }

  String _serviceApprovalDate() {
    if (widget.child.updatedAt != null) {
      return widget.child.updatedAt!.add(const Duration(days: 14)).toString().substring(0,10);
    }
    return ' to be updated.';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => StudentProfile(child: widget.child),
        ));
      },
      onLongPress: () {
        if (widget.child.status == 0) {
          showConfirmDialog(context);
        }
      },
      child: Container(
        color: const Color(0xffFFFFDD),
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _avatar(),
            const SizedBox(width: 10,),
            Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.child.name ?? '',
                      style: const TextStyle(
                          color: Color(0xff0D1F2D),
                          fontFamily: 'Lexend Deca',
                          fontWeight: FontWeight.w500,
                          fontSize: 16
                      ),
                    ),
                    widget.child.status == 1 ? Text(
                      'The termination for ${widget.child.name} is pending ZXY\'s approval now, the estimated date is ${_serviceApprovalDate()}.',
                      style: const TextStyle(
                          color: Color(0xffE40947),
                          fontFamily: 'Lexend Deca',
                          fontWeight: FontWeight.w500,
                          fontSize: 14
                      ),
                    ) :
                    (widget.child.requestedService != widget.child.assignedService) ?
                    Text(
                      'The service request for ${widget.child.name} is pending ZXY\'s approval now, the estimated date is ${_serviceApprovalDate()}.',
                      style: const TextStyle(
                          color: Color(0xffE40947),
                          fontFamily: 'Lexend Deca',
                          fontWeight: FontWeight.w500,
                          fontSize: 14
                      ),
                    ) : const Text(
                      'Live',
                      style: TextStyle(
                          color: Color(0xff008D41),
                          fontFamily: 'Lexend Deca',
                          fontWeight: FontWeight.w500,
                          fontSize: 14
                      ),
                    ) ,
                  ],
                ),
            ),
            IconButton(
              icon: const Icon(
                Icons.edit,
                size: 32,
                color: Color(0xffF52C65),
              ),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ChildProfile(child: widget.child,),
                ));
              },
            ),
            const SizedBox(width: 10,)
          ],
        ),
      ),
    );
  }

  Future<bool?> showConfirmDialog(BuildContext buildContext) async {
    return showDialog<bool>(
      context: buildContext,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Confirm to terminate the services for this child?',
            style: TextStyle(
              fontWeight: FontWeight.normal,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(AppLocalizations.of(context)?.cancel ?? 'Cancel', style: TextStyle(fontSize: fitSize(40))),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text(AppLocalizations.of(context)?.yes ?? 'Yes', style: TextStyle(fontSize: fitSize(40))),
              onPressed: () async {
                widget.child.status = 1;
                ChildService.deleteChild(widget.child.id!);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
