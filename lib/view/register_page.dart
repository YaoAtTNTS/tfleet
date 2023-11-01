

import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:tfleet/locale/app_localizations.dart';
import 'package:tfleet/main.dart';
import 'package:tfleet/service/passenger/file_service.dart';
import 'package:tfleet/service/user_service.dart';
import 'package:tfleet/utils/constants.dart';
import 'package:tfleet/utils/format_utils.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tfleet/utils/toast.dart';
import 'package:tfleet/view/common/profile_image.dart';
import 'package:tfleet/view/full_image.dart';
import 'package:tfleet/view/passenger/my/static_content_page.dart';

import '../model/user.dart';
import '../utils/t_color.dart';
import '../utils/global.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key, required this.fromEdit, required this.title}) : super(key: key);

  final bool fromEdit;
  final String title;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {


  final GlobalKey _formKey = GlobalKey<FormState>();
  bool _isObscure = true;
  Color _eyeColor = Colors.grey;
  String _name = '';
  String _email = '';
  String _account = '';
  String? _alterAccount;
  String? _url;
  String _password = '';

  bool _tncChecked = false;

  final ImagePicker _imagePicker = ImagePicker();

  bool _accountExisted = false;
  bool _alterAccountExisted = false;

  final List<bool> _selecteds = [false, true, false, false];

  bool _showImageSelectionIcons = false;

  String? _token;

  _getToken() async {
    _token = await FirebaseMessaging.instance.getToken();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.fromEdit) {
      _account = Global.clientID() ?? '';
      _name = Global.username() ?? '';
      _email = Global.email() ?? '';
      _url = Global.url();
    } else {
      _getToken();
    }
  }

  @override
  Widget build(BuildContext context) {

    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
    return Scaffold(
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildHeader(width),
                SizedBox(height: fitSize(75)),
                _buildProfileImage(width),
                SizedBox(height: fitSize(75)),
                _buildAccountTextField(),
                SizedBox(height: fitSize(75)),
                _accountExisted ? Text(
                  AppLocalizations.of(context)?.mobileAlreadyExisted ?? 'Mobile already existed',
                  style: const TextStyle(color: Colors.red),
                ) : Container(),
                _buildAlterAccountTextField(),
                SizedBox(height: fitSize(75)),
                _alterAccountExisted ? Text(
                  'Second mobile already existed',
                  style: const TextStyle(color: Colors.red),
                ) : Container(),
                _buildNameTextField(),
                SizedBox(height: fitSize(75)),
                _buildEmailTextField(),
                SizedBox(height: fitSize(75)),
                _buildPasswordTextField(context),
                SizedBox(height: fitSize(75)),
                _buildConfirmPasswordTextField(context),
                // SizedBox(height: fitSize(75)),
                // buildProfileImageText(),
                // SizedBox(height: fitSize(12.5)),
                // buildProfileImage(),
                SizedBox(height: widget.fromEdit ? fitSize(75) : 0),
                widget.fromEdit ? Container() : buildCheckTnc(),
                SizedBox(height: fitSize(75)),
                buildSubmitButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(double width) {
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
          const Text(
            'Parent Register',
            style: TextStyle(
                fontSize: 24,
                fontFamily: 'Lexend Deca',
                fontWeight: FontWeight.bold,
                color: Colors.white
            ),
          ),
          const SizedBox(height: 10,),
          const Text(
            'Join today to keep track of your child\'s shuttling',
            style: TextStyle(
                fontSize: 16,
                fontFamily: 'Lexend Deca',
                color: Colors.white
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImage(double width) {
    if (_url != null && _url!.isNotEmpty) {
      return Container(
        width: width,
        alignment: Alignment.topCenter,
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => FullImage(url: _url, name: _name, fromUser: widget.fromEdit)));
          },
          child: ProfileImage(size: 72, url: _url),
        ),
      );
    }
    return GestureDetector(
      onTap: () {
        _showBottomModal();
      },
      child: Stack(
        children: [
          const Center(child: ProfileImage(size: 72, url: null)),
          Positioned(
            right: width/2 - 36,
            bottom: 0,
            child: const Icon(
              Icons.add_circle_sharp,
              color: Color(0xffE40947),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildAccountTextField() {
    return Container(
      margin: const EdgeInsets.only(left: 24, right: 24),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(width: 1, color: const Color(0xffE3E3E3))
      ),
      child: TextFormField(
        initialValue: _account,
        decoration: InputDecoration(
            labelText: AppLocalizations.of(context)?.account ?? 'Mobile No',
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

  Widget _buildAlterAccountTextField() {
    return Container(
      margin: const EdgeInsets.only(left: 24, right: 24),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(width: 1, color: const Color(0xffE3E3E3))
      ),
      child: TextFormField(
        initialValue: _alterAccount ?? '',
        decoration: const InputDecoration(
          labelText: 'Second Mobile No (Optional)',
          contentPadding: EdgeInsets.only(left: 10, right: 10),
          border: InputBorder.none,
        ),
        validator: (v) {
          var mobileReg = RegExp(
              r'^[8-9][0-9]{7}$');
          if (v != null && v.isNotEmpty && !mobileReg.hasMatch(v)) {
            return 'Invalid mobile no.';
          }
        },
        onEditingComplete: (){
          FocusScope.of(context).nextFocus();
        },
        onSaved: (v) => _alterAccount = v!.trim(),
      ),
    );
  }

  Widget _buildNameTextField() {
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

  Widget _buildEmailTextField() {
    return Container(
      margin: const EdgeInsets.only(left: 24, right: 24),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(width: 1, color: const Color(0xffE3E3E3))
      ),
      child: TextFormField(
        initialValue: _email,
        decoration: const InputDecoration(
            labelText: 'Email',
          contentPadding: EdgeInsets.only(left: 10, right: 10),
          border: InputBorder.none,
        ),
        validator: (v) {
          var emailReg = RegExp(
              r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
          if (!emailReg.hasMatch(v!)) {
            return 'Invalid email address.';
          }
        },
        onEditingComplete: (){
          FocusScope.of(context).nextFocus();
        },
        onSaved: (v) => _email = v!.trim(),
      ),
    );
  }

  Widget _buildPasswordTextField(BuildContext context) {
    return widget.fromEdit? Container() : Container(
      margin: const EdgeInsets.only(left: 24, right: 24),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(width: 1, color: const Color(0xffE3E3E3))
      ),
      child: TextFormField(
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

  Widget _buildConfirmPasswordTextField(BuildContext context) {
    return widget.fromEdit ? Container() : Container(
      margin: const EdgeInsets.only(left: 24, right: 24),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(width: 1, color: const Color(0xffE3E3E3))
      ),
      child: TextFormField(
          obscureText: _isObscure, // 是否显示文字
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

  // Widget uploadedImage () {
  //   return _url != null ? CachedNetworkImage(
  //     width: MediaQuery.of(context).size.width*0.8,
  //     placeholder: (context, url) => Container(
  //       child: const Center(child: CircularProgressIndicator()),
  //       width: fitSize(250),
  //       height: fitSize(250),
  //     ),
  //     imageUrl: _url!,
  //     fit: BoxFit.cover,
  //   ) : Container();
  // }

  Widget _buildIconButton(BuildContext buildContext, String name, IconData icon) {
    return Column(
      children: <Widget>[
        GestureDetector(
          excludeFromSemantics: true,
          onTap: () {
            Navigator.of(buildContext).pop();
            switch (name) {
              case 'Gallery':
                _onImageButtonPressed(ImageSource.gallery, context: context);
                break;
              case 'Camera':
                _onImageButtonPressed(ImageSource.camera, context: context);
                break;
              default:
                break;
            }
          },
          child: Container(
            width: fitSize(150),
            height: fitSize(150),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(fitSize(25))),
            child: Icon(
              icon,
              size: fitSize(70),
            ),
          ),
        ),
        Container(
            margin: EdgeInsets.only(top: fitSize(7.5)),
            child: Text(name == 'Gallery' ? AppLocalizations.of(context)?.gallery ?? 'Gallery' : AppLocalizations.of(context)?.camera ?? 'Camera',
                style: TextStyle(fontSize: fitSize(30), color: Colors.grey[600])))
      ],
    ) ;
  }

  void _onImageButtonPressed(ImageSource source, {required BuildContext context}) async {
    final _imageFile = await _imagePicker.pickImage(
      source: source,

    );
    Uint8List bytes = await _imageFile!.readAsBytes();
    uploadFace(bytes, (count, total) {
      if (count == total) {
        setState(() {});
      }
    });
  }

  Future uploadFace(Uint8List data, void Function(int count, int total)? onProgress) async {
    String? oldUrl = _url;
    Dio dio = Dio();
    Map<String, dynamic> map = {};
    MultipartFile file = MultipartFile.fromBytes(data, filename: '${getDate()}${getRandom(4)}.jpg');
    map['file'] = file;
    map['contentType'] = 'image/jpeg';
    FormData formData = FormData.fromMap(map);
    Options opt = Options(
        followRedirects: false,
        validateStatus: (status) { return status! < 500; });
    _url = (await dio.post('${Constants.SERVER_IP}:${Constants.SERVER_PORT}/api/file/upload', data: formData, options: opt, onSendProgress: onProgress)).data.toString();
    setState(() {
      Global.saveUrl(_url);
    });
    if (oldUrl != null) {
      FileService.delete(oldUrl.substring(oldUrl.lastIndexOf('/') + 1));
    }
  }

  Widget buildCheckTnc () {
    return Container(
      margin: const EdgeInsets.only(left: 24, right: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Checkbox(
          value: _tncChecked,
          fillColor: MaterialStateProperty.resolveWith((states) => const Color(0xffE40947)),
          onChanged: (v) {
            setState(() {
              _tncChecked = !_tncChecked;
            });
          }
          ),
          Expanded(
            child: RichText(
              softWrap: true,
              text: TextSpan(
                children: <TextSpan>[
                  const TextSpan(text: 'I have read and accept '),
                  TextSpan(
                      text: 'Terms & Condition',
                      style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                      recognizer: TapGestureRecognizer()..onTap=(){
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => StaticContentPage(text: AppLocalizations.of(context)?.termsCondition ?? 'Terms & Condition', index: 3),
                          ));
                        },
                      ),
                  const TextSpan(text: ' and '),
                  TextSpan(
                      text: 'Privacy Policy',
                      style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                      recognizer: TapGestureRecognizer()..onTap=(){
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => StaticContentPage(text: AppLocalizations.of(context)?.privacyPolicy ?? 'Privacy Policy', index: 2),
                          ));
                        },
                  )
                ],
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xff5D5D5B),
                ),
              ),
            ),
          ),
        ],
      ),
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
            // 表单校验通过才会继续执行
            if ((_formKey.currentState as FormState).validate()) {
              (_formKey.currentState as FormState).save();
              if (widget.fromEdit) {
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
    if (!_tncChecked) {
      Toast.toast(context,msg: 'Please accept terms and condition, privacy policy before signing up.',position: ToastPostion.center);
      return;
    }
    if (_token == null) {
      Toast.toast(context,msg: 'Token is null.',position: ToastPostion.center);
      return;
    }
    if (_alterAccount != null && _alterAccount != '') {
      _account = '$_account/$_alterAccount';
    }
    User user = User(account: _account, name: _name, email:_email, password: _password, url: _url, role: 1, ownerId: 0, fcmToken: _token);
    int id = await UserService.addUser(user);
    if (id == -1) {
      setState(() {
        _alterAccountExisted = true;
      });
      return;
    }
    if (id == 0) {
      setState(() {
        _accountExisted = true;
      });
      return;
    }
    if (id > 0) {
      Global.saveUsername(_name);
      Navigator.of(context).pop(true);
    } else {
      Navigator.of(context).pop(false);
    }
    return;
    await Global.init();
    Global.saveClientID(_account);
    Global.saveUserId(id);
    Global.saveUsername(_name);
    if (_email.isNotEmpty) {
      Global.saveEmail(_email);
    }
    Global.savePassword(_password);
    if (_url != null) {
      Global.saveUrl(_url!);
    }
    Global.saveLoginStatus();
    Global.saveRole(1);
    await _setupToken();
    Navigator.pop(context, true);
  }

  Future _updateProfile() async {
    Map<String, dynamic> params = {};
    if (_name != Global.username() && _name != '') {
      params['name'] = _name;
      Global.saveUsername(_name);
    }
    if (_url != Global.url() && _url != '') {
      params['url'] = _url;
      Global.saveUrl(_url);
    }
    if (_email != Global.email() && _email != '') {
      params['email'] = _email;
      Global.saveEmail(_email);
    }
    params['id'] = Global.getUserId().toString();
    var updateUser = await UserService.updateUser(params);
    if (updateUser == -2) {
      setState(() {
        _accountExisted = true;
      });
    } else if (updateUser == -1) {
      setState(() {
        _alterAccountExisted = true;
      });
    } else {
      Navigator.pop(context);
    }
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

  Future _showBottomModal() async {
    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isDismissible: true,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Container(
          width: width,
          height: 180,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(top: fitSize(150)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildIconButton(context, 'Gallery', Icons.photo_library),
                _buildIconButton(context, 'Camera', Icons.photo_camera),
              ],
            ),
          ),
        );
      },
    );
  }

}
