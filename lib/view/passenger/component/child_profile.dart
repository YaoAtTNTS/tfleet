

import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:multi_select_flutter/chip_field/multi_select_chip_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:tfleet/locale/app_localizations.dart';
import 'package:tfleet/main.dart';
import 'package:tfleet/model/driver/pickup_point.dart';
import 'package:tfleet/model/passenger/address.dart';
import 'package:tfleet/model/passenger/child.dart';
import 'package:tfleet/model/passenger/school.dart';
import 'package:tfleet/service/passenger/address_service.dart';
import 'package:tfleet/service/passenger/child_service.dart';
import 'package:tfleet/service/passenger/file_service.dart';
import 'package:tfleet/service/passenger/school_service.dart';
import 'package:tfleet/utils/constants.dart';
import 'package:tfleet/utils/t_color.dart';
import 'package:tfleet/utils/format_utils.dart';
import 'package:tfleet/utils/global.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tfleet/utils/toast.dart';
import 'package:tfleet/view/common/profile_image.dart';
import 'package:tfleet/view/full_image.dart';
import 'package:tfleet/view/passenger/my/address_page.dart';

class ChildProfile extends StatefulWidget {
  const ChildProfile({Key? key, this.child}) : super(key: key);

  final Child? child;

  @override
  State<ChildProfile> createState() => _ChildProfileState();
}

class _ChildProfileState extends State<ChildProfile> {

  final GlobalKey _formKey = GlobalKey<FormState>();
  String _name = '';
  String? _url;
  String _cardId = '';
  int _gender = 1;
  String _clazz = '';

  static final List<String> _services = ['AM', 'PM'];

  final _items = _services
      .map((v) => MultiSelectItem<String>(v, v))
      .toList();

  List<dynamic> _servicesSelected = [];

  final Map<String, String> _schoolMap = {};

  String? selectSchoolValue;

  final List<bool> _selecteds = [true, false];

  final ImagePicker _imagePicker = ImagePicker();

  List<DropdownMenuItem<String>> generateSchoolList() {
    final List<DropdownMenuItem<String>> items = <DropdownMenuItem<String>>[];
    List<String> values = _schoolMap.values.toList();
    if (values.isNotEmpty) {
      for(String school in values) {
        final DropdownMenuItem<String> item = DropdownMenuItem(
          value: school,
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(school),
          ),);
        items.add(item);
      }
    }
    return items;
  }

  // _getAddressList() async {
  //   var addresses = await AddressService.getAddresses(Global.getUserId()!);
  //   for (Map<String, dynamic> addressJson in addresses) {
  //     _address = Address.fromJson(addressJson);
  //     break;
  //   }
  //   if (_address == null) {
  //     Navigator.of(context).push(MaterialPageRoute(
  //       builder: (context) => const AddressPage(),
  //     ));
  //   }
  // }

  _getSchoolList() async {
    _schoolMap.clear();
    var schools = await SchoolService.getSchools();
    for (Map<String, dynamic> raw in schools) {
      School school = School.fromJson(raw);
      _schoolMap[school.code] = school.name;
    }
    if (widget.child != null) {
      if (mounted) {
        setState(() {
          selectSchoolValue ??= _schoolMap[widget.child!.school];
        });
      }
    } else {
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _getAddressList();
    _getSchoolList();
    if (widget.child != null) {
      _name = widget.child!.name;
      _clazz = widget.child!.clazz;
      _selecteds[0] = widget.child!.gender == 1;
      _selecteds[1] = widget.child!.gender == 2;
      _url = widget.child!.url;
      if (widget.child!.requestedService != null) {
        List<String> split = widget.child!.requestedService!.split(';');
        for (String s in split) {
          _servicesSelected.add(_num2service(s));
        }
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
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
                _buildProfileImage(),
                SizedBox(height: fitSize(75)),
                _buildNameTextField(),
                SizedBox(height: fitSize(75)),
                buildSchoolSelectionField(),
                SizedBox(height: fitSize(75)),
                buildClazzNameTextField(),
                SizedBox(height: fitSize(75)),
                buildGenderSelectionFiled(),
                SizedBox(height: fitSize(75)),
                _buildServicePickerField(),
                SizedBox(height: fitSize(75)),
                _buildSubmitButton(context),
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
          Text(
            widget.child == null ? 'Child Register' : widget.child!.name,
            style: const TextStyle(
                fontSize: 24,
                fontFamily: 'Lexend Deca',
                fontWeight: FontWeight.bold,
                color: Colors.white
            ),
          ),
          const SizedBox(height: 10,),
          const Text(
            'Fill in your child profile',
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

  Widget _buildProfileImage() {
    if (_url != null && _url!.isNotEmpty) {
      return Container(
        width: width,
        alignment: Alignment.topCenter,
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => FullImage(url: _url, name: _name, fromUser: false)));
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
            labelText: AppLocalizations.of(context)?.passengerName ?? 'Child name',
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

  Widget buildGenderSelectionFiled() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _selecteds[0] = true;
              _selecteds[1] = false;
              _gender = 1;
            });
          },
          child: Container(
            width: 139,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: _selecteds[0] ? const Color(0xffE40947) : Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(width: 2, color: const Color(0xffE40947))
            ),
            child: Text(
              'Boy',
              style: TextStyle(
                  color: _selecteds[0] ? Colors.white : const Color(0xffE40947),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Lexend Deca'
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              _selecteds[0] = false;
              _selecteds[1] = true;
              _gender = 2;
            });
          },
          child: Container(
            width: 139,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: _selecteds[1] ? const Color(0xffE40947) : Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(width: 1, color: const Color(0xffE40947))
            ),
            child: Text(
              'Girl',
              style: TextStyle(
                color: _selecteds[1] ? Colors.white : const Color(0xffE40947),
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: 'Lexend Deca'
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget buildSchoolSelectionField() {
     return Container(
       margin: const EdgeInsets.only(left: 24, right: 24),
       decoration: BoxDecoration(
           borderRadius: BorderRadius.circular(24),
           border: Border.all(width: 1, color: const Color(0xffE3E3E3))
       ),
       child: DropdownButton<String>(
         underline: Container(),
         hint: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Text(
              AppLocalizations.of(context)?.selectSchool ?? 'Select school',
            style: const TextStyle(
              fontSize: 16
            ),
          ),
        ),
        items: generateSchoolList(),
        onChanged: (value) {
          setState(() {
            selectSchoolValue = value;
          });
        },
        isExpanded: true,
        value: selectSchoolValue,
    ),
     );
  }

  Widget buildClazzNameTextField() {
    return Container(
      margin: const EdgeInsets.only(left: 24, right: 24),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(width: 1, color: const Color(0xffE3E3E3))
      ),
      child: TextFormField(
        initialValue: _clazz,
        decoration: InputDecoration(
            labelText: AppLocalizations.of(context)?.clazzName ?? 'Class name',
          contentPadding: const EdgeInsets.only(left: 10, right: 10),
          border: InputBorder.none,
        ),
        onEditingComplete: (){
          FocusScope.of(context).nextFocus();
        },
        onSaved: (v) => _clazz = v!.trim(),
      ),
    );
  }

  Widget _buildIconButton(BuildContext context, String name, IconData icon) {
    return Column(
      children: <Widget>[
        GestureDetector(
          excludeFromSemantics: true,
          onTap: () {
            Navigator.of(context).pop();
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
            child: Text(name == 'Gallery' ? AppLocalizations.of(context)?.gallery ?? 'Gallery' :  AppLocalizations.of(context)?.camera ?? 'Camera',
                style: TextStyle(fontSize: fitSize(30), color: Colors.grey[600])))
      ],
    ) ;
  }

  void _onImageButtonPressed(ImageSource source, {required BuildContext context}) async {
    final _imageFile = await _imagePicker.pickImage(
      source: source,

    );
    Uint8List bytes = await _imageFile!.readAsBytes();
    _uploadFace(bytes, (count, total) {
      if (count == total) {
        setState(() {});
      }
    });
  }

  Future _uploadFace(Uint8List data, void Function(int count, int total)? onProgress) async {
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
    var response = await dio.post('${Constants.SERVER_IP}:${Constants.SERVER_PORT}/api/file/upload', data: formData, options: opt, onSendProgress: onProgress);
    _url = response.data.toString();
    widget.child?.url = _url;
    setState(() {});
    if (oldUrl != null) {
      await FileService.delete(oldUrl.substring(oldUrl.lastIndexOf('/') + 1));
    }
  }

  String _requestedService() {
    String requested = '';
    Iterator<dynamic> iterator = _servicesSelected.iterator;
    if (iterator.moveNext()) {
      requested += _service2num(iterator.current);
      while (iterator.moveNext()){
        requested += ';${_service2num(iterator.current)}';
      }
    }
    return requested;
  }

  String _service2num(String service) {
    switch(service) {
      case 'AM':
        return '1';
      case 'PM':
        return '2';
      // case 'ECA':
      //   return '3';
      default:
        return '';
    }
  }

  String _num2service(String num) {
    switch(num) {
      case '1':
        return 'AM';
      case '2':
        return 'PM';
      // case '3':
      //   return 'ECA';
      default:
        return '';
    }
  }

  Widget _buildServicePickerField() {
    return widget.child == null ? Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20),
      child: MultiSelectChipField(
        items: _items,
        initialValue: _servicesSelected,
        title: const Text(
          'Select services',
          style: TextStyle(
              color: Colors.white,
              fontSize: 16
          ),
        ),
        headerColor: const Color(0xffE40947),
        decoration: BoxDecoration(
            border: Border.all(color: const Color(0xffE40947), width: 1.8),
            borderRadius: BorderRadius.circular(10)
        ),
        selectedChipColor: const Color(0xff008D41),
        selectedTextStyle: const TextStyle(color: Colors.white),
        onTap: (values) {
          setState(() {
            _servicesSelected = values;
          });
        },
      ),
    ) : Container();
  }


  Widget _buildSubmitButton(BuildContext context) {
    return Container(
      height: fitSize(112.5),
      width: fitSize(675),
      margin: const EdgeInsets.only(bottom: 75, right: 30),
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith((states) => const Color(0xffE40947)),
            shape: MaterialStateProperty.all(const StadiumBorder(
                side: BorderSide(style: BorderStyle.none))
            )
        ),
        child: Text(AppLocalizations.of(context)?.submit ?? 'Submit',
            style: TextStyle(
                color: Colors.white,
                fontSize: fitSize(50)
            )),
        onPressed: () {
          // 表单校验通过才会继续执行
          if ((_formKey.currentState as FormState).validate()) {
            (_formKey.currentState as FormState).save();
            _addChild();
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

  Future _addChild() async {
    if (Global.getAddress() == null) {
      Toast.toast(context, msg: 'Please create address first.', position: ToastPostion.center);
      return;
    }
    if (selectSchoolValue == null) {
      Toast.toast(context, msg: AppLocalizations.of(context)?.selectSchool ?? 'Select school.', position: ToastPostion.center);
      return;
    }
    if (_requestedService() == '') {
      Toast.toast(context, msg: 'Please select service first.', position: ToastPostion.center);
      return;
    }
    String? school;
    for (MapEntry entry in _schoolMap.entries) {
      if (entry.value == selectSchoolValue) {
        school = entry.key;
        break;
      }
    }
    if (school == null) {
      if (selectSchoolValue == null) {
        Toast.toast(context, msg: 'Invalid school.', position: ToastPostion.center);
        return;
      }
    }
    Child child = Child(userId: Global.getUserId()!, name: _name, school: school!, address: Global.getAddress()!, area: '', url: _url, cardId: _cardId, clazz: _clazz, gender: _gender,
      requestedService: _requestedService(), status: 0);
    if (widget.child != null) {
      child.id = widget.child!.id!;
      await ChildService.updateChild(child);
      widget.child!.name = child.name;
      widget.child!.url = child.url;
      widget.child!.clazz = child.clazz;
      widget.child!.gender = child.gender;
      // Global.yourChildren.remove(widget.child!);
      // Global.yourChildren.add(child);
    } else {
      var response = await ChildService.addChild(child);
      child.id = response['id'];
      child.sid = response['sid'];
      Global.yourChildren.add(child);
    }
    if (mounted) {
      Navigator.pop(context, true);
    }
  }

}
