
import 'package:flutter/material.dart';

import '../../utils/format_utils.dart';

enum ImageType {
  error,
  network,
  empty,
  loading,
}

const List<String> imageList = [
  'assets/image/common/error.png',
  'assets/image/common/network.png',
  'assets/image/common/empty.png',
  'assets/image/common/logo.png',
];

class FeedBack extends StatelessWidget {
  final ImageType imageType;
  final String? description;
  final bool showButton;
  final String? buttonText;
  final VoidCallback? onTap;

  const FeedBack({
    Key? key,
    this.imageType = ImageType.loading,
    this.description,
    this.showButton = false,
    this.buttonText,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imageList[imageType.index],
            width: toRpx(size: 128),
            fit: BoxFit.fitWidth,
            // color: imageType.index == 2 ? Colors.grey : null,
          ),
          const SizedBox(height: 10,),
          Offstage(
            offstage: description == null || description!.isEmpty,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                  '$description',
                style: const TextStyle(
                    fontSize: 18,
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.bold,
                    color: Color(0xffafafaf)
                ),
              ),
            ),
          ),
          Offstage(
            offstage: !showButton || buttonText == null || buttonText!.isEmpty,
            child: Column(
              children: [
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: onTap,
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.resolveWith((states) => const Color(0xffE40947)),
                  ),
                  child: Text('$buttonText'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}