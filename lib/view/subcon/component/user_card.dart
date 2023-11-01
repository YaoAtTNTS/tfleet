

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tfleet/locale/app_localizations.dart';
import 'package:tfleet/model/user.dart';
import 'package:tfleet/service/user_service.dart';
import 'package:tfleet/utils/constants.dart';
import 'package:tfleet/utils/format_utils.dart';
import 'package:tfleet/utils/t_color.dart';
import 'package:tfleet/view/subcon/component/user_profile.dart';
import 'package:tfleet/view/subcon/component/user_profile_view.dart';

class UserCard extends StatefulWidget {
  const UserCard({Key? key, required this.user, required this.onDelete, required this.type}) : super(key: key);

  final int type;
  final User user;
  final Function onDelete;
  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {

  Widget _avatar() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => UserProfileView(user: widget.user, type: widget.type,)
            )
        );
      },
      child: Container(
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
            imageUrl: widget.user.url ?? Constants.PROFILE_IMAGE_DEFAULT_URL,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  // Widget _presenceLabel() {
  //   if (widget.user.isAbsent) {
  //     return Container(
  //       height: 20,
  //       width: 76,
  //       decoration: BoxDecoration(
  //           color: const Color(0xffE40947),
  //           borderRadius: BorderRadius.circular(5)
  //       ),
  //       alignment: Alignment.center,
  //       child: const Text(
  //         'Absent',
  //         style: TextStyle(
  //             color: Colors.white,
  //             fontSize: 12,
  //             fontFamily: 'Lexend',
  //             fontWeight: FontWeight.bold
  //         ),
  //       ),
  //     );
  //   }
  //   return Container(
  //     height: 20,
  //     width: 76,
  //     decoration: BoxDecoration(
  //         color: const Color(0xff008D41),
  //         borderRadius: BorderRadius.circular(5)
  //     ),
  //     alignment: Alignment.center,
  //     child: Text(
  //       widget.pupType == 1 ? 'On Board' : 'Alight',
  //       style: const TextStyle(
  //           color: Colors.white,
  //           fontSize: 12,
  //           fontFamily: 'Lexend',
  //           fontWeight: FontWeight.bold
  //       ),
  //     ),
  //   );
  // }

  Widget _name() {
    return Container(
      margin: EdgeInsets.only(left: fitSize(20)),
      alignment: Alignment.centerLeft,
      child: Text(
        widget.user.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            fontSize: fitSize(50),
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
        widget.user.account,
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
      color: const Color(0xffFFFFDD),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          _avatar(),
          const SizedBox(width: 10,),
          Expanded(
            child: Text(
              widget.user.name,
              softWrap: true,
              style: const TextStyle(
                color: Color(0xff1E1F26),
                fontWeight: FontWeight.bold,
                fontFamily: 'Sora',
                fontSize: 18,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
            },
            child: Center(
              child: IconButton(
                icon: const Icon(
                  Icons.delete,
                  size: 30,
                  color: Color(0xffE40947),
                ),
                onPressed: () {
                  showConfirmDialog(context);
                },
              ),
            ),
          ),
        ],
      ),
    ) ;
  }

  Future<bool?> showConfirmDialog(BuildContext buildContext) async {
    return showDialog<bool>(
      context: buildContext,
      builder: (context) {
        return AlertDialog(
          title: Text(
            widget.type == 1 ? (AppLocalizations.of(context)?.confirmToRemoveDriver ?? 'Confirm to remove this driver?') :
            (AppLocalizations.of(context)?.confirmToRemoveAttendant ?? 'Confirm to remove this attendant?'),
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
                widget.onDelete(widget.user);
                UserService.deleteUser(widget.user.id!);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
