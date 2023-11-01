

import 'package:flutter/material.dart';
import 'package:tfleet/locale/app_localizations.dart';
import 'package:tfleet/service/user_service.dart';
import 'package:tfleet/utils/format_utils.dart';

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(AppLocalizations.of(context)?.changePassword ?? 'Change Password'),
      ),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: fitSize(50)),
          children: [
            const SizedBox(height: kToolbarHeight), // 距离顶部一个工具栏的高度
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
    );
  }

  Widget buildOldPasswordTextField(BuildContext context) {
    return TextFormField(
        obscureText: _isObscure, // 是否显示文字
        onSaved: (v) => _oldPassword = v!.trim(),
        onEditingComplete: (){
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
            )));
  }

  Widget buildNewPasswordTextField(BuildContext context) {
    return TextFormField(
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
            return AppLocalizations.of(context)?.keyInNewPassword ?? 'Please key in new password.';
          }
        },
        decoration: InputDecoration(
            labelText: AppLocalizations.of(context)?.newPassword ?? 'New password',
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
            )));
  }

  Widget buildConfirmPasswordTextField(BuildContext context) {
    return TextFormField(
        obscureText: _isObscure, // 是否显示文字
        onSaved: (v) => _confirmPassword = v!.trim(),
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
            )));
  }

  Widget buildSubmitButton(BuildContext context) {
    return Align(
      child: Container(
        height: fitSize(112.5),
        width: fitSize(675),
        margin: const EdgeInsets.only(bottom: 75),
        child: ElevatedButton(
          style: ButtonStyle(
            // 设置圆角
              shape: MaterialStateProperty.all(const StadiumBorder(
                  side: BorderSide(style: BorderStyle.none)))),
          child: Text(AppLocalizations.of(context)?.submit ??'Submit',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: fitSize(50)
              )),
          onPressed: () {
            // 表单校验通过才会继续执行
            if ((_formKey.currentState as FormState).validate()) {
              if (_newPassword != _confirmPassword) {
                return;
              }
              (_formKey.currentState as FormState).save();
              UserService.changePassword(_oldPassword!, _newPassword!);
              Navigator.pop(context);
            }
          },
        ),
      ),
    );
  }
}
