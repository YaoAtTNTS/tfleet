

import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tfleet/locale/app_localizations.dart';
import 'package:tfleet/main.dart';
import 'package:tfleet/service/passenger/file_service.dart';
import 'package:tfleet/service/user_service.dart';
import 'package:tfleet/utils/constants.dart';
import 'package:tfleet/utils/format_utils.dart';
import 'package:tfleet/utils/global.dart';
import 'package:tfleet/utils/t_color.dart';

class FullImage extends StatefulWidget {
  const FullImage({Key? key, required this.url, required this.name, required this.fromUser}) : super(key: key);

  final String? url;
  final String name;
  final bool fromUser;

  @override
  State<FullImage> createState() => _FullImageState();
}

class _FullImageState extends State<FullImage> {

  String? _url;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.url);
    _url = widget.url;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: width,
        margin: const EdgeInsets.only(top: kToolbarHeight),
        color: TColor.holder,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: () {
                  showConfirmDialog(context);
                },
                child: CachedNetworkImage(
                  width: width,
                  height: MediaQuery.of(context).size.height,
                  placeholder: (context, url) => SizedBox(
                    width: fitSize(250),
                    height: fitSize(250),
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  imageUrl: _url ?? Constants.PROFILE_IMAGE_DEFAULT_URL,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              right: fitSize(50),
              top: fitSize(40),
              child: IconButton(
                icon: const Icon(
                    Icons.cancel,
                  color: Color(0xffE40947),
                  size: 40,
                ),
                onPressed: () {
                  Navigator.of(context).pop(_url);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool?> showConfirmDialog(BuildContext buildContext) async {
    return showDialog<bool>(
      context: buildContext,
      builder: (context) {
        return AlertDialog(
          content: Container(
            padding: EdgeInsets.only(top: fitSize(100)),
            height: 120,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildIconButton(context, 'Gallery', Icons.photo_library),
                _buildIconButton(context, 'Camera', Icons.photo_camera),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context)?.cancel ?? 'Cancel'),
            ),
          ],
          actionsAlignment: MainAxisAlignment.end,

        );
      },
    );
  }

  Widget _buildIconButton(BuildContext context, String name, IconData icon) {
    return Column(
      children: <Widget>[
        GestureDetector(
          excludeFromSemantics: true,
          onTap: () {
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
            Navigator.of(context).pop();
          },
          child: Container(
            width: fitSize(150),
            height: fitSize(150),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: TColor.holder, borderRadius: BorderRadius.circular(fitSize(25))),
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
    );
  }

  void _onImageButtonPressed(ImageSource source, {required BuildContext context}) async {
    final _imageFile = await _imagePicker.pickImage(
      source: source,

    );
    Uint8List bytes = await _imageFile!.readAsBytes();
    uploadFace(bytes, (count, total) {
      setState(() {});
    });
  }


  Future uploadFace(Uint8List data, void Function(int count, int total)? onProgress) async {
    String? oldUrl = widget.url;
    Dio dio = Dio();
    Map<String, dynamic> map = {};
    MultipartFile file = MultipartFile.fromBytes(data, filename: '${getDate()}${getRandom(4)}.jpg');
    map['file'] = file;
    map['contentType'] = 'image/jpeg';
    FormData formData = FormData.fromMap(map);
    Options opt = Options(
        followRedirects: false,
        validateStatus: (status) { return status! < 500; });
    String url = (await dio.post('${Constants.SERVER_IP}:${Constants.SERVER_PORT}/api/file/upload', data: formData, options: opt, onSendProgress: onProgress)).data.toString();
    if (widget.fromUser) {
      Map<String, dynamic> user = <String, dynamic> {};
      user['url'] = url;
      user['id'] = Global.getUserId().toString();
      UserService.updateUser(user);
    }
    if (mounted) {
      setState(() {
              _url = url;
            });
    }
    if (oldUrl != null) {
      FileService.delete(oldUrl.substring(oldUrl.lastIndexOf('/') + 1));
    }
  }
}
