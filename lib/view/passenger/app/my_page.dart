

import 'package:cached_network_image/cached_network_image.dart';
import 'package:tfleet/locale/app_localizations.dart';
import 'package:tfleet/service/user_service.dart';
import 'package:tfleet/utils/constants.dart';
import 'package:tfleet/utils/t_color.dart';
import 'package:tfleet/utils/format_utils.dart';
import 'package:tfleet/utils/global.dart';
import 'package:tfleet/view/full_image.dart';
import 'package:tfleet/view/login_page.dart';
import 'package:tfleet/view/passenger/app/children_page.dart';
import 'package:tfleet/view/passenger/app/leave_page.dart';
import 'package:tfleet/view/passenger/app/service_page.dart';
import 'package:tfleet/view/passenger/component/address_profile.dart';
import 'package:tfleet/view/passenger/my/address_page.dart';
import 'package:tfleet/view/passenger/my/invoice_page.dart';
import 'package:tfleet/view/passenger/my/payment_method_page.dart';
import 'package:tfleet/view/passenger/component/change_password_page.dart';
import 'package:tfleet/view/passenger/my/static_content_page.dart';
import 'package:tfleet/view/register_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

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
                  builder: (context) => FullImage(name: Global.username() ?? '', url: Global.url(), fromUser: true),
                )).then((value) => null);
              },
              child: */ClipOval(
                child: CachedNetworkImage(
                  placeholder: (context, url) => Container(
                    child: Center(child: const CircularProgressIndicator()),
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
            AppLocalizations.of(context)?.settings ?? 'Settings',
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

  Widget _footer(String text, int index) {
    return Container(
      padding: EdgeInsets.only(left: fitSize(40), top: fitSize(25)),
      alignment: Alignment.centerLeft,
      child: InkWell(
        onTap: () {
          if (index > 0) {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => StaticContentPage(text: text, index: index),
            ));
          }
        },
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

  Widget _toggle(String icon, String text) {
    return Container(
      padding: EdgeInsets.only(left: fitSize(20), top: fitSize(25)),
      alignment: Alignment.centerLeft,
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
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: fitSize(40),
                fontWeight: FontWeight.bold,
                color: TColor.active,
              ),
            ),
          ),
          Switch(
              value: Global.attendanceOff() == 0,
              onChanged: (v) {
                _showConfirmAttendanceOffDialog(context, v);
                // Map<String, dynamic> params = {};
                // params['attendanceOff'] = v ? 0 : 1;
                // Global.setAttendanceOff(v? 0: 1);
                // params['id'] = Global.getUserId().toString();
                // UserService.updateUser(params);
                // if (mounted) {
                //   setState(() {});
                // }
              },
            activeColor: const Color(0xffe40947),
          ),
        ],
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
          _item('assets/image/icon/student.png', 'Passenger management', onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const ChildrenPage(),
            ));
          }),
          _item('assets/image/icon/leave.png', 'Special schedule', onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const LeavePage(),
            ));
          }),
          _item('assets/image/icon/route.png', 'Service change', onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const ServicePage(fromAdd: false,),
            ));
          }),
          _item('assets/image/icon/address.png', 'Address management', onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const AddressProfile(),
            ));
          }),
          _item('assets/image/icon/invoice.png', 'Invoice management', onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const InvoicePage(),
            ));
          }),
          _item('assets/image/icon/account.png', 'Edit profile', onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => RegisterPage(title: 'Edit Profile', fromEdit: true,),
            ));
          }),
          _item('assets/image/icon/credential.png', 'Change password', onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const ChangePasswordPage(),
            ));
          }),
          // _item('assets/image/icon/payment.png', 'Payment method', onTap: () {
          //   Navigator.of(context).push(MaterialPageRoute(
          //     builder: (context) => const PaymentMethodPage(),
          //   ));
          // }),
          _toggle('assets/image/icon/notification.png', 'Notification for attendance'),
          _item('assets/image/common/empty.png', AppLocalizations.of(context)?.signOut ?? 'Sign out', onTap: (){ showConfirmDialog(context);}),
          SizedBox(height: fitSize(50)),
          Container(
            height: 1,
            color: TColor.in3active,
          ),
          _footer('Help Center', 3),
          _footer(AppLocalizations.of(context)?.privacyPolicy ?? 'Privacy Policy', 2),
          _footer(AppLocalizations.of(context)?.termsCondition ?? 'Terms & Condition', 1),
          _footer(AppLocalizations.of(context)?.version ?? 'VERSION: 1.0.0', 0),
          Container(margin: const EdgeInsets.only(bottom: 75),)
        ],
      ),
    );
  }

  Future<bool?> _showConfirmAttendanceOffDialog(BuildContext buildContext, bool v) async {
    return showDialog<bool>(
      context: buildContext,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Confirm to turn ${Global.attendanceOff() == 0? 'off' : 'on'} notification for attendance?',
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
                Map<String, dynamic> params = {};
                params['attendanceOff'] = v ? 0 : 1;
                Global.setAttendanceOff(v? 0: 1);
                params['id'] = Global.getUserId().toString();
                UserService.updateUser(params);
                // if (mounted) {
                //   setState(() {});
                // }
                // Map<String, dynamic> params = {};
                // if (Global.attendanceOff() == 0) {
                //   params['attendanceOff'] = 1;
                //   Global.setAttendanceOff(1);
                // } else {
                //   params['attendanceOff'] = 0;
                //   Global.setAttendanceOff(0);
                // }
                // params['id'] = Global.getUserId().toString();
                // UserService.updateUser(params);
                Navigator.pop(context);
                if (buildContext.mounted) {
                  setState(() {});
                }
              },
            ),
          ],
        );
      },
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
