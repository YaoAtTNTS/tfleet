

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tfleet/locale/app_localizations.dart';
import 'package:tfleet/main.dart';
import 'package:tfleet/model/user.dart';
import 'package:tfleet/service/user_service.dart';
import 'package:tfleet/utils/format_utils.dart';
import 'package:tfleet/utils/global.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key, required this.title, this.user, required this.type}) : super(key: key);

  final int type;
  final String title;
  final User? user;

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {

  final GlobalKey _formKey = GlobalKey<FormState>();
  bool _isObscure = true;
  Color _eyeColor = Colors.grey;
  String _name = '';
  String _account = '';
  String _password = '';

  bool _accountExisted = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.user != null) {
      _account = widget.user!.account;
      _name = widget.user!.name;
      _password = widget.user!.password;
    }
  }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);

    return Scaffold(
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(),
              SizedBox(height: fitSize(75)),
              buildAccountTextField(),
              SizedBox(height: fitSize(75)),
              _accountExisted ? Text(
                AppLocalizations.of(context)?.mobileAlreadyExisted ?? 'Mobile already existed',
                style: const TextStyle(color: Colors.red),
              ) : Container(),
              buildNameTextField(),
              SizedBox(height: fitSize(75)),
              buildPasswordTextField(context),
              SizedBox(height: fitSize(75)),
              buildConfirmPasswordTextField(context),
              SizedBox(height: fitSize(75)),
              buildSubmitButton(context),
              SizedBox(height: fitSize(75)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: width,
      height: width * 0.568,
      padding: const EdgeInsets.only(left: 42, right: 42),
      decoration: BoxDecoration(
          color: const Color(0xffe40947),
          borderRadius: BorderRadius.circular(18)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: kToolbarHeight,),
          IconButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            icon: const Icon(
              Icons.chevron_left,
              size: 30,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20,),
          Text(
            widget.user == null ? 'Register ${widget.type == 1 ? 'Driver' : 'Attendant'}' : widget.user!.name,
            style: const TextStyle(
                fontSize: 24,
                fontFamily: 'Lexend Deca',
                fontWeight: FontWeight.bold,
                color: Colors.white
            ),
          ),
          const SizedBox(height: 10,),
          Text(
            widget.user == null ? 'Fill in your ${widget.type == 1 ? 'driver' : 'attendant'} profile' : 'Update your profile',
            style: const TextStyle(
                fontSize: 16,
                fontFamily: 'Lexend Deca',
                color: Colors.white
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAccountTextField() {
    return Container(
      margin: const EdgeInsets.only(left: 24, right: 24),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(width: 1, color: const Color(0xffE3E3E3))
      ),
      child: TextFormField(
        initialValue: _account,
        decoration: InputDecoration(
            labelText: AppLocalizations.of(context)?.account ?? 'Account',
          contentPadding: const EdgeInsets.only(left: 10, right: 10),
          border: InputBorder.none,
        ),
        validator: (v) {
          var mobileReg = RegExp(
              r'^[8-9][0-9]{7}$');
          if (!mobileReg.hasMatch(v!)) {
            return 'Invalid mobile no.';
          }
        },
        onEditingComplete: (){
          FocusScope.of(context).nextFocus();
        },
        onSaved: (v) => _account = v!.trim(),
      ),
    );
  }

  Widget buildNameTextField() {
    return Container(
      margin: const EdgeInsets.only(left: 24, right: 24),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(width: 1, color: const Color(0xffE3E3E3))
      ),
      child: TextFormField(
        initialValue: _name,
        decoration: InputDecoration(
            labelText: AppLocalizations.of(context)?.username ??'Username',
          contentPadding: const EdgeInsets.only(left: 10, right: 10),
          border: InputBorder.none,
        ),
        onEditingComplete: (){
          FocusScope.of(context).nextFocus();
        },
        onSaved: (v) => _name = v!.trim(),
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
          initialValue: _password,
          obscureText: _isObscure, // 是否显示文字
          onSaved: (v) => _password = v!.trim(),
          onChanged: (v) => _password = v.trim(),
          onEditingComplete: (){
            FocusScope.of(context).nextFocus();
            FocusScope.of(context).nextFocus();
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

  Widget buildConfirmPasswordTextField(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 24, right: 24),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(width: 1, color: const Color(0xffE3E3E3))
      ),
      child: TextFormField(
          initialValue: _password,
          obscureText: _isObscure,
          onSaved: (v) => {},
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
            if (v != _password) {
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
          onPressed: () {
            if ((_formKey.currentState as FormState).validate()) {
              (_formKey.currentState as FormState).save();
              if (widget.user != null) {
                _updateProfile();
              } else {
                _register();
              }
            }
          },
        ),
      ),
    );
  }

  Future _register() async {
    User user = User(account: _account, name: _name, password: _password, url: null, role: widget.type == 1 ? 2 : 4, ownerId: Global.getUserId());
    int id = await UserService.addUser(user);
    if (id == 0) {
      setState(() {
        _accountExisted = true;
      });
      return;
    }
    Navigator.pop(context, true);
  }

  Future _updateProfile() async {
    Map<String, dynamic> params = {};
    if (_name != widget.user!.name && _name != '') {
      params['name'] = _name;
    }
    if (_account != widget.user!.account && _account != '') {
      params['account'] = _account;
    }
    if (_password != widget.user!.password && _password != '') {
      params['password'] = _password;
    }
    params['id'] = widget.user!.id.toString();
    var updateUser = await UserService.updateUser(params);
    if (updateUser == -2) {
      setState(() {
        _accountExisted = true;
      });
    } else {
      Navigator.pop(context, true);
    }
  }
}
