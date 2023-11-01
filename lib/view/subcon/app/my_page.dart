

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:tfleet/locale/app_localizations.dart';
import 'package:tfleet/model/user.dart';
import 'package:tfleet/service/user_service.dart';
import 'package:tfleet/utils/constants.dart';
import 'package:tfleet/utils/event.dart';
import 'package:tfleet/utils/format_utils.dart';
import 'package:tfleet/utils/global.dart';
import 'package:tfleet/utils/t_color.dart';
import 'package:tfleet/view/driver/my/payout_page.dart';
import 'package:tfleet/view/driver/my/salary_page.dart';
import 'package:tfleet/view/full_image.dart';
import 'package:tfleet/view/login_page.dart';
import 'package:tfleet/view/passenger/component/change_password_page.dart';
import 'package:tfleet/view/subcon/component/user_profile.dart';
import 'package:tfleet/view/subcon/my/attendant_management_page.dart';
import 'package:tfleet/view/subcon/my/driver_management_page.dart';
import 'package:tfleet/view/register_page.dart';
import 'package:tfleet/view/subcon/my/vehicle_management_page.dart';

class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {

  Widget _title() {
    return Padding(
      padding: EdgeInsets.all(fitSize(40)),
      child: Row(
        children: [
          Container(
            width: fitSize(100),
            height: fitSize(100),
            padding: EdgeInsets.all(fitSize(5)),
            decoration: BoxDecoration(
              color: TColor.page,
              borderRadius: BorderRadius.circular(fitSize(100)),
            ),
            child: /*GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => FullImage(name: Global.username() ?? '', url: Global.url(), fromUser: true,),
                )).then((value) => null);
              },
              child: */ClipOval(
                child: CachedNetworkImage(
                  placeholder: (context, url) => Container(
                    child: const Center(child: CircularProgressIndicator()),
                    width: fitSize(100),
                    height: fitSize(100),
                  ),
                  imageUrl: networkImageToDefault(Global.url() ?? Constants.PROFILE_IMAGE_DEFAULT_URL),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          // ),
          SizedBox(width: fitSize(25)),
          Text(
            AppLocalizations.of(context)?.settings ??'Settings',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: fitSize(60),
              fontWeight: FontWeight.bold,
              color: TColor.active,
            ),
          )
        ],
      ),
    );
  }

  Widget _item(String icon, String item, {VoidCallback? onTap}) {
    return Padding(
      padding: EdgeInsets.all(fitSize(20)),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            padding: EdgeInsets.all(fitSize(20)),
            decoration: BoxDecoration(
              color: TColor.page,
              borderRadius: BorderRadius.circular(fitSize(100)),
            ),
            child: Image.asset(
              icon,
              color: Colors.black38,
            ),
          ),
          SizedBox(width: fitSize(25)),
          InkWell(
            onTap: onTap,
            child: Text(
              item,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: fitSize(40),
                fontWeight: FontWeight.bold,
                color: TColor.active,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _footer(String text, {VoidCallback? onTap}) {
    return Container(
      padding: EdgeInsets.only(left: fitSize(40), top: fitSize(25)),
      alignment: Alignment.centerLeft,
      child: InkWell(
        onTap: onTap,
        child: Text(
          text,
          style: TextStyle(
              color: TColor.inactive,
              fontSize: fitSize(35)
          ),
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: fitSize(150),),
          _title(),
          SizedBox(height: fitSize(50),),
          _item('assets/image/icon/driver.png', AppLocalizations.of(context)?.driverManagement ?? 'Driver management', onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const DriverManagementPage(),
            ));
          }),
          _item('assets/image/icon/attendant.png', AppLocalizations.of(context)?.attendantManagement ?? 'Attendant management', onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const AttendantManagementPage(),
            ));
          }),
          _item('assets/image/icon/bus.png', 'Vehicle management', onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const VehicleManagementPage(),
            ));
          }),
          _item('assets/image/icon/account.png', AppLocalizations.of(context)?.editProfile ?? 'Edit Profile', onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => UserProfile(title: AppLocalizations.of(context)?.editProfile ?? 'Edit Profile',
                user: User(id: Global.getUserId(), account: Global.clientID() ?? '', name: Global.username() ?? '', password: Global.password() ?? '', role: 3), type: 3,),
            ));
          }),
          _item('assets/image/icon/credential.png', AppLocalizations.of(context)?.changePassword ?? 'Change password', onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const ChangePasswordPage(),
            ));
          }),
          _item('assets/image/common/empty.png', AppLocalizations.of(context)?.signOut ?? 'Sign out', onTap: (){ showConfirmDialog(context);}),
          SizedBox(height: fitSize(50)),
          Container(
            height: 1,
            color: TColor.in3active,
          ),
          _footer('Help Center'),
          _footer(AppLocalizations.of(context)?.privacyPolicy ??'Privacy Policy'),
          _footer(AppLocalizations.of(context)?.termsCondition ?? 'Terms & Condition'),
          _footer(AppLocalizations.of(context)?.version ?? 'VERSION: 1.0.0'),
          Container(margin: const EdgeInsets.only(bottom: 75),)
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
            AppLocalizations.of(context)?.confirmSignOut ?? 'Confirm to sign out?',
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
                await UserService.logout(Global.getUserId()!);
                Global.clear();
                event.off('PENDING');
                event.off('ASSIGNED');
                event.off('MISSED');
                if (mounted) {
                  Navigator.of(context).pop();
                  Navigator.of(buildContext).pushReplacement(MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ));
                }
              },
            ),
          ],
        );
      },
    );
  }

}
