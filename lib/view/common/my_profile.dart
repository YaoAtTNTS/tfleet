

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tfleet/locale/app_localizations.dart';
import 'package:tfleet/main.dart';
import 'package:tfleet/model/user.dart';
import 'package:tfleet/service/user_service.dart';
import 'package:tfleet/utils/constants.dart';
import 'package:tfleet/utils/format_utils.dart';
import 'package:tfleet/utils/global.dart';
import 'package:tfleet/view/common/profile_image.dart';
import 'package:tfleet/view/full_image.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {

  bool _isObscure = true;
  Color _eyeColor = Colors.grey;
  String _name = '';
  String _email = '';
  String _account = '';
  String? _url;
  String _password = '';
  String _confirmPassword = '';

  final GlobalKey _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _name = widget.user.name;
    _account = widget.user.account;
    _password = widget.user.password;
    _confirmPassword = widget.user.password;
    _url = widget.user.url;
  }

  @override
  Widget build(BuildContext context) {

    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    width: width,
                    height: width * 0.568,
                    decoration: BoxDecoration(
                      color: const Color(0xffe40947),
                      borderRadius: BorderRadius.circular(18)
                    ),
                  ),
                  Positioned(
                    left: 40,
                      top: 48,
                      child: IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(
                          Icons.chevron_left,
                          size: 30,
                            color: Colors.white,
                        ),
                      ),
                  ),
                  Positioned(
                      top: 48,
                      child: Container(
                        width: width,
                        alignment: Alignment.topCenter,
                          child: GestureDetector(
                            onTap: () {
                              if (_url != null && _url!.isNotEmpty) {
                                Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context) =>
                                        FullImage(url: _url, name: _name, fromUser: true))
                                );
                              } else {
                                _showBottomModal();
                              }
                            },
                              child: ProfileImage(size: 72, url: widget.user.url))
                      ),
                  ),
                  Positioned(
                    top: 140,
                      child: Container(
                        width: width,
                        alignment: Alignment.topCenter,
                        child: Text(
                          widget.user.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontFamily: 'Lexend Deca',
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                          ),
                        ),
                      )
                  ),
                ],
              ),
              SizedBox(height: width*0.072,),
              Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildNameField(),
                    const SizedBox(height: 20,),
                    _buildMobileField(),
                    const SizedBox(height: 20,),
                    // _buildPasswordTextField(),
                    const SizedBox(height: 20,),
                    // _buildConfirmPasswordTextField(),
                    const SizedBox(height: 40,),
                    _buildSubmitButton(width),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMobileField() {
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
        onEditingComplete: (){
          FocusScope.of(context).nextFocus();
        },
        onSaved: (v) => _account = v!.trim(),
      ),
    );
  }

  Widget _buildNameField() {
    return Container(
      margin: const EdgeInsets.only(left: 24, right: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(width: 1, color: const Color(0xffE3E3E3))
      ),
      child: TextFormField(
        initialValue: _name,
        decoration: InputDecoration(
            labelText: AppLocalizations.of(context)?.username ?? 'Name',
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

  Widget _buildPasswordTextField() {
    return Container(
      margin: const EdgeInsets.only(left: 24, right: 24),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(width: 1, color: const Color(0xffE3E3E3))
      ),
      child: TextFormField(
        initialValue: _password,
          obscureText: _isObscure,
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

  Widget _buildConfirmPasswordTextField() {
    return Container(
      margin: const EdgeInsets.only(left: 24, right: 24),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(width: 1, color: const Color(0xffE3E3E3))
      ),
      child: TextFormField(
          obscureText: _isObscure,
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

  Widget _buildSubmitButton(double width) {
    return Container(
      margin: const EdgeInsets.only(left: 24, right: 24, bottom: 75),
      width: width,
      decoration: BoxDecoration(
        color: const Color(0xffE40947),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(width: 1, color: const Color(0xffE3E3E3))
      ),
      child: TextButton(
        child: Text(AppLocalizations.of(context)?.submit ?? 'Submit',
            style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Lexend Deca',
                fontWeight: FontWeight.bold,
                fontSize: 16
            )),
        onPressed: () {
          if ((_formKey.currentState as FormState).validate()) {
            (_formKey.currentState as FormState).save();
            _updateProfile();
          }
        },
      ),
    );
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
            padding: const EdgeInsets.only(top: 60),
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
            width: 60,
            height: 60,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Icon(
              icon,
              size: 28,
            ),
          ),
        ),
        Container(
            margin: const EdgeInsets.only(top: 3),
            child: Text(name == 'Gallery' ? AppLocalizations.of(context)?.gallery ?? 'Gallery' : AppLocalizations.of(context)?.camera ?? 'Camera',
                style: TextStyle(fontSize: 12, color: Colors.grey[600])))
      ],
    ) ;
  }

  void _onImageButtonPressed(ImageSource source, {required BuildContext context}) async {
    final imageFile = await ImagePicker().pickImage(
      source: source,

    );
    Uint8List bytes = await imageFile!.readAsBytes();
    uploadFace(bytes, (count, total) {
      if (count == total) {
        setState(() {});
      }
    });
  }

  Future uploadFace(Uint8List data, void Function(int count, int total)? onProgress) async {
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
    if (_account != Global.clientID() && _account != '') {
      params['mobile'] = _account;
      Global.saveClientID(_account);
    }
    params['id'] = Global.getUserId().toString();
    UserService.updateUser(params);
    Navigator.pop(context);
  }

}
