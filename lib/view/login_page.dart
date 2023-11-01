

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart' as notification;
import 'package:tfleet/locale/app_localizations.dart';
import 'package:tfleet/main.dart';
import 'package:tfleet/utils/format_utils.dart';
import 'package:tfleet/utils/toast.dart';
import 'package:tfleet/view/driver/driver_app_page.dart';
import 'package:tfleet/view/register_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:tfleet/view/subcon/subcon_app_page.dart';

import '../service/user_service.dart';
import '../utils/global.dart';
import 'passenger/passenger_app_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final GlobalKey _formKey = GlobalKey<FormState>();
  String _account = '', _password = '';
  bool _isObscure = true;
  Color _eyeColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return Scaffold(

      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: fitSize(50)),
            children: [
              const SizedBox(height: kToolbarHeight), // 距离顶部一个工具栏的高度
              SizedBox(height: fitSize(100)),
              _buildLogo(), // Login
              SizedBox(height: fitSize(100)),
              _buildTitle(),
              _buildSlogan(),
              SizedBox(height: fitSize(100)),
              buildEmailTextField(), // 输入邮箱
              SizedBox(height: fitSize(75)),
              buildPasswordTextField(context), // 输入密码
              buildForgetPasswordText(context), // 忘记密码
              SizedBox(height: fitSize(100)),
              buildLoginButton(context), // 登录按钮
              SizedBox(height: fitSize(75)),
              buildRegisterText(context), // 注册
            ],
          ),
        ),
      ),
    );

  }

  Widget _buildLogo() {
    return Padding( // 设置边距
        padding: EdgeInsets.all(fitSize(20)),
        child: Image.asset(
          'assets/image/common/logo.png',
          width: MediaQuery.of(context).size.width*0.6187,
          height: MediaQuery.of(context).size.width*0.5467,
        ));
  }

  Widget _buildTitle() {
    return const Align(
      alignment: Alignment.center,
      child: Text(
        'Zheng Xing Yun',
        style: TextStyle(
          color: Color(0xff39393A),
          fontSize: 28,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.bold
        ),
      ),
    );
  }

  Widget _buildSlogan() {
    return const Align(
      alignment: Alignment.center,
      child: Text(
        'Move around effectively',
        style: TextStyle(
            color: Color(0xff39393A),
            fontSize: 16,
            fontFamily: 'Roboto',
        ),
      ),
    );
  }

  Widget buildEmailTextField() {
    return Container(
      margin: const EdgeInsets.only(left: 24, right: 24),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(width: 1, color: const Color(0xffE3E3E3))
      ),
      child: TextFormField(
        decoration: InputDecoration(
            labelText: AppLocalizations.of(context)?.account ?? 'Account',
          contentPadding: const EdgeInsets.only(left: 10, right: 10),
          border: InputBorder.none,
        ),
        validator: (v) {
/*        var emailReg = RegExp(
              r"[\w!#$%&'*+/=?^_`{|}~-]+(?:\.[\w!#$%&'*+/=?^_`{|}~-]+)*@(?:[\w](?:[\w-]*[\w])?\.)+[\w](?:[\w-]*[\w])?");
          if (!emailReg.hasMatch(v!)) {
            return '请输入正确的邮箱地址';
          }*/
        },
        onChanged: (v) {
          _account = v;
        },
        onEditingComplete: (){
          FocusScope.of(context).nextFocus();
        },
        onSaved: (v) => _account = v!.trim(),
        style: TextStyle(fontSize: fitSize(40)),
      ),
    );
  }

  Widget buildPasswordTextField(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 24, right: 24),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(width: 1, color: const Color(0xffE3E3E3))
      ),
      child: TextFormField(
          obscureText: _isObscure, // 是否显示文字
          onSaved: (v) => _password = v!.trim(),
          style: TextStyle(fontSize: fitSize(40)),
          onEditingComplete: (){
            FocusScope.of(context).unfocus();
          },
          // onFieldSubmitted: (value) {
          //   _login(_account, _password);
          // },
          validator: (v) {
            if (v!.isEmpty) {
              return AppLocalizations.of(context)?.pleaseKeyInPass ?? 'Please key in password.';
            }
          },
          decoration: InputDecoration(
              labelText: AppLocalizations.of(context)?.password ?? 'Password',
              contentPadding: const EdgeInsets.only(left: 10, right: 10),
              border: InputBorder.none,
              suffixIcon: IconButton(
                icon: Icon(
                  Icons.remove_red_eye,
                  color: _eyeColor,
                ),
                onPressed: () {
                  // 修改 state 内部变量, 且需要界面内容更新, 需要使用 setState()
                  setState(() {
                    _isObscure = !_isObscure;
                    _eyeColor = (_isObscure
                        ? Colors.grey
                        : Theme.of(context).iconTheme.color)!;
                  });
                },
              ))),
    );
  }

  Widget buildForgetPasswordText(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: fitSize(20)),
      child: Align(
        alignment: Alignment.centerRight,
        child: TextButton(
          onPressed: () {
            _showForgotPasswordConfirmDialog(context);
          },
          child: Text(AppLocalizations.of(context)?.forgotPassword ?? 'Forgot password？',
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: fitSize(35),
                fontFamily: 'Kanit'
              )
          ),
        ),
      ),
    );
  }

  Widget buildLoginButton(BuildContext context) {
    return Align(
      child: SizedBox(
        height: fitSize(115),
        width: fitSize(675),
        child: ElevatedButton(
          style: ButtonStyle(
            // 设置圆角
            backgroundColor: MaterialStateProperty.resolveWith((states) => const Color(0xffE40947)),
              shape: MaterialStateProperty.all(const StadiumBorder(
                  side: BorderSide(style: BorderStyle.none)))),
          child: Text(AppLocalizations.of(context)?.login ?? 'Login',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: fitSize(50)
              )),
          onPressed: () {
            // 表单校验通过才会继续执行
            if ((_formKey.currentState as FormState).validate()) {
              (_formKey.currentState as FormState).save();
              //TODO 执行登录方法
              _login(_account, _password);
            }
          },
        ),
      ),
    );
  }

  Widget buildRegisterText(context) {
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: fitSize(25), bottom: 75),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(AppLocalizations.of(context)?.noAccount ?? 'No account? '),
            GestureDetector(
              child: Text(AppLocalizations.of(context)?.tapToRegister ?? 'Tap to register', style: const TextStyle(color: Color(0xff008d41))),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RegisterPage(title: AppLocalizations.of(context)?.register ??'Register',fromEdit: false,),
                  ),
                ).then((value) /* => value ? _loginUponRegister() : null*/
                  {
                    print('Upon register: $value');
                    if (value){
                      String title = 'Welcome Onboard ZXY';
                      String content = 'Hi ${Global.username()}, your account has been created. Welcome Onboard ZXY School Bus Platform, hope you can enjoy our service. thank you for choosing us';
                      flutterLocalNotificationsPlugin.show(
                        0,
                        title,
                        content,
                        notification.NotificationDetails(
                          android: notification.AndroidNotificationDetails(
                            channel.id,
                            channel.name,
                            priority: const notification.Priority(1),
                            importance: const notification.Importance(5)
                          ),
                        )
                      );
                      Global.saveWelcomeMsg(title, content, DateTime.now(), 1);
                      Global.isOpenedByNotification = true;
                    }
                  }
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Future<void> _setupToken() async {
    if (Global.fcmToken == null) {
      String? token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        Global.saveFcmToken(token);
        UserService.saveFcmToken(token);
      }
    }
    FirebaseMessaging.instance.onTokenRefresh.listen((event) {
      Global.saveFcmToken(event);
    });
  }

  _loginUponRegister() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => _getPage(Global.getRole()),
      ),
    );
  }

  _getPage (int role) {
    switch (role) {
      case 1:
        return const PassengerAppPage();
      case 2:
      case 4:
        return const DriverAppPage();
      case 3:
        return const SubconAppPage();
        default:
          return const PassengerAppPage();
    }
  }

  Future _login(String account, String password) async {
    var response = await UserService.login(account, password);
    if (response['msg'] == 'success') {
      await Global.init();
      Global.saveClientID(account);
      Global.saveUserId(response['data']['id']);
      Global.saveUsername(response['data']['name']);
      if (response['data']['email'] != null) {
        Global.saveEmail(response['data']['email']);
      }
      Global.saveUrl(response['data']['url']);
      Global.savePassword(response['data']['password']);
      Global.saveRole(response['data']['roleId']);
      Global.saveLoginStatus();
      Global.setAttendanceOff(response['data']['attendanceOff']);
      await _setupToken();
      if (mounted) {
        Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => _getPage(Global.getRole()),
                ),
              );
      }
    } else if (response['msg'] == 'Invalid credentials'){
      Toast.toast(context,msg: AppLocalizations.of(context)?.invalidCredential ?? 'Invalid Credentials.',position: ToastPostion.center);
    } else if (response['msg'] == 'Does not exist'){
      Toast.toast(context,msg: AppLocalizations.of(context)?.accountDoesNotExist ?? 'Account does not exist.',position: ToastPostion.center);
    } else {
      Toast.toast(context,msg: response['msg'],position: ToastPostion.center);
    }
  }

  Future<bool?> _showForgotPasswordConfirmDialog(BuildContext buildContext) async {
    var mobileReg = RegExp(
        r'^[8-9][0-9]{7}$');
    if (!mobileReg.hasMatch(_account)) {
        Toast.toast(context,msg: 'Please key in valid mobile no.',position: ToastPostion.center, showTime: 3000);
      return false;
    }
    return showDialog<bool>(
      context: buildContext,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Confirm to reset password? Upon your confirmation, we will send a new password to your registered email.',
            softWrap: true,
            style: TextStyle(
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
                Navigator.of(context).pop();
                var response = await UserService.resetPassword(_account);
                if (response['code'] == 0) {
                  if (mounted) {
                    Toast.toast(buildContext, msg: 'Your password reset successfully. Please check your email.');
                  }
                } else {
                  if (mounted) {
                    Toast.toast(buildContext, msg: 'Password reset failed, due to ${response['msg']}. Please contact admin.');
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }
}
