

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tfleet/utils/constants.dart';

class ProfileImage extends StatelessWidget {
  const ProfileImage({Key? key, required this.size, required this.url}) : super(key: key);

  final double size;
  final String? url;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: ClipOval(
        child: CachedNetworkImage(
          placeholder: (context, url) => const SizedBox(
            child: Center(child: CircularProgressIndicator()),
          ),
          imageUrl: url ?? Constants.PROFILE_IMAGE_DEFAULT_URL,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
