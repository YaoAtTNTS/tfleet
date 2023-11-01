

import 'package:flutter/services.dart';
import 'package:tfleet/locale/app_localizations.dart';
import 'package:tfleet/main.dart';
import 'package:tfleet/service/user_service.dart';
import 'package:tfleet/utils/format_utils.dart';
import 'package:flutter/material.dart';
import 'package:tfleet/utils/toast.dart';


class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {

  final GlobalKey _formKey = GlobalKey<FormState>();
  bool _isObscure = true;
  Color _eyeColor = Colors.grey;
  String? _oldPassword;
  String? _newPassword;
  String? _confirmPassword;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);

    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: GestureDetector(
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              child: Column(
                children: [
                  _buildHeader(),
                  SizedBox(height: fitSize(75)),
                  buildOldPasswordTextField(context),
                  SizedBox(height: fitSize(75)),
                  buildNewPasswordTextField(context),
                  SizedBox(height: fitSize(75)),
                  buildConfirmPasswordTextField(context),
                  SizedBox(height: fitSize(125)),
                  buildSubmitButton(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: width,
      height: width * 0.568,
      padding: const EdgeInsets.only(left: 20, right: 42),
      decoration: BoxDecoration(
          // color: const Color(0xffe40947),
          borderRadius: BorderRadius.circular(18)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.chevron_left,
              size: 30,
              color: Colors.black,
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                AppLocalizations.of(context)?.changePassword ?? 'Reset Password',
                style: const TextStyle(
                    fontSize: 32,
                    fontFamily: 'Lexend Deca',
                    fontWeight: FontWeight.bold,
                    color: Color(0xff080a0b)
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildOldPasswordTextField(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 24, right: 24),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(width: 1, color: const Color(0xffE3E3E3))
      ),
      child: TextFormField(
          obscureText: _isObscure, // 是否显示文字
          onSaved: (v) => _oldPassword = v!.trim(),
          onChanged: (v) => _oldPassword = v.trim(),
          onEditingComplete: (){
            FocusScope.of(context).nextFocus();
            FocusScope.of(context).nextFocus();
          },
          // onFieldSubmitted: (value) {
          //   _login(_account, _password);
          // },
          validator: (v) {
            if (v!.isEmpty) {
              return AppLocalizations.of(context)?.keyInOldPassword ?? 'Please key in old password.';
            }
          },
          decoration: InputDecoration(
              labelText: AppLocalizations.of(context)?.oldPassword ?? 'Old password',
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

  Widget buildNewPasswordTextField(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 24, right: 24),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(width: 1, color: const Color(0xffE3E3E3))
      ),
      child: TextFormField(
          obscureText: _isObscure, // 是否显示文字
          onSaved: (v) => _newPassword = v!.trim(),
          onChanged: (v) => _newPassword = v.trim(),
          onEditingComplete: (){
            FocusScope.of(context).nextFocus();
            FocusScope.of(context).nextFocus();
          },
          // onFieldSubmitted: (value) {
          //   _login(_account, _password);
          // },
          validator: (v) {
            if (v!.isEmpty) {
              return AppLocalizations.of(context)?.keyInNewPassword  ?? 'Please key in new password.';
            }
          },
          decoration: InputDecoration(
              labelText: AppLocalizations.of(context)?.newPassword ?? 'New password',
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

  Widget buildConfirmPasswordTextField(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 24, right: 24),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(width: 1, color: const Color(0xffE3E3E3))
      ),
      child: TextFormField(
          obscureText: _isObscure, // 是否显示文字
          onSaved: (v) => _confirmPassword = v!.trim(),
          onChanged: (v) => _confirmPassword = v.trim(),
          onEditingComplete: (){
            FocusScope.of(context).nextFocus();
            FocusScope.of(context).nextFocus();
          },
          // onFieldSubmitted: (value) {
          //   _login(_account, _password);
          // },
          validator: (v) {
            if (v!.isEmpty) {
              return AppLocalizations.of(context)?.pleaseConfirmPass ?? 'Please confirm password.';
            }
            if (v != _newPassword) {
              return 'Password does not match.';
            }
          },
          decoration: InputDecoration(
              labelText: AppLocalizations.of(context)?.confirmPassword ?? 'Confirm password',
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

  Widget buildSubmitButton(BuildContext context) {
    return Align(
      child: Container(
        height: fitSize(112.5),
        width: fitSize(675),
        margin: const EdgeInsets.only(bottom: 75),
        child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith((states) => const Color(0xffE40947)),
              shape: MaterialStateProperty.all(const StadiumBorder(
                  side: BorderSide(style: BorderStyle.none)))),
          child: Text(AppLocalizations.of(context)?.submit ?? 'Submit',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: fitSize(50)
              )),
          onPressed: () async {
            if ((_formKey.currentState as FormState).validate()) {
              if (_newPassword != _confirmPassword) {
                return;
              }
              (_formKey.currentState as FormState).save();
              var msg = await UserService.changePassword(_oldPassword!, _newPassword!);
              if (msg == 'Wrong old password.') {
                Toast.toast(context, msg: 'Wrong old password.', showTime: 2000);
              } else {
                Navigator.pop(context);
              }
            }
          },
        ),
      ),
    );
  }
}
