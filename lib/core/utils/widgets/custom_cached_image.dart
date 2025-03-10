import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../constants/app_assets.dart';

class CustomImage extends StatelessWidget {
  final String? imageUrl; // URL for network images
  final String? assetPath; // Path for local assets
  final String? placeholderAsset; // Placeholder image path
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Widget? errorWidget;

  const CustomImage({
    super.key,
    this.imageUrl,
    this.assetPath,
    this.placeholderAsset = AppImages.placeHolder,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.errorWidget,
  }) : assert(imageUrl != null || assetPath != null, "Provide either an imageUrl or assetPath");

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(8),
      child: _buildImage(),
    );
  }

  Widget _buildImage() {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: imageUrl!,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, url) => Image.asset(
          placeholderAsset!,
          width: width,
          height: height,
          fit: fit,
        ),
        errorWidget: (context, url, error) => errorWidget ??
            Icon(Icons.error, size: width != null ? width! / 2 : 40, color: Colors.red),
      );
    } else if (assetPath != null && assetPath!.isNotEmpty) {
      return Image.asset(
        assetPath!,
        width: width,
        height: height,
        fit: fit,
      );
    }
    // Fallback if no valid source is provided
    return Image.asset(
      placeholderAsset!,
      width: width,
      height: height,
      fit: fit,
    );
  }
}
