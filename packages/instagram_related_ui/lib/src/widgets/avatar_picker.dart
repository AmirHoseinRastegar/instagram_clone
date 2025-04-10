import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:ui/ui.dart';

/// AvatarImagePicker displays a circular avatar image that can be uploaded
/// from the device.
///
/// Tapping the avatar opens an image picker to select a new image.
/// Provides option to compress images before uploading.
class AvatarImagePicker extends StatelessWidget {
  const AvatarImagePicker({
    this.compress = true,
    this.radius = 64,
    this.addButtonRadius = 18,
    this.placeholderSize = 54,
    this.withPlaceholder = true,
    this.onUpload,
    super.key,
    this.imageBytes,
  });

  final Uint8List? imageBytes;
  final void Function(Uint8List, File)? onUpload;
  final bool compress;
  final double radius;
  final double addButtonRadius;
  final double placeholderSize;
  final bool withPlaceholder;

  /// Picks an image from the device's gallery or camera and passes the image
  /// bytes and file to the provided callback.
  ///
  /// Handles compressing the image before returning it.
  Future<void> _pickImage(BuildContext context) async {
    
  }

  @override
  Widget build(BuildContext context) {
    return Tappable.faded(
      onTap: () => _pickImage.call(context),
      child: Stack(
        children: [
          CircleAvatar(
            radius: radius,
            backgroundColor: Colors.grey.shade500,
            backgroundImage:
                imageBytes == null ? null : MemoryImage(imageBytes!),
            child: imageBytes != null
                ? null
                : withPlaceholder
                    ? Icon(
                        Icons.person,
                        size: placeholderSize,
                      )
                    : null,
          ),
          Positioned(
            bottom: 4,
            right: 4,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
                border: Border.all(
                  width: 2,
                  color: context.reversedAdaptiveColor,
                ),
              ),
              child: const Icon(
                Icons.add,
                size: AppSize.iconSizeSmall,
              ),
            ),
          ),
        ],
      ),
    );
  }
}