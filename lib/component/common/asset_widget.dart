import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AssetWidget extends StatelessWidget{
  final String assetName;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Color? color;
  final Alignment alignment;
  final String? semanticsLabel;

  const AssetWidget(this.assetName, {super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.color,
    this.alignment = Alignment.center,
    this.semanticsLabel,
  });

  Widget get loadingAsset {
    return SizedBox(
      width: width,
      height: height,
      key: key,
      child: Center(
        child: CircularProgressIndicator(
          color: color,
          semanticsLabel: semanticsLabel,
        ),
      ),
    );
  }

  Widget get errorAsset {
    return SizedBox(
      width: width,
      height: height,
      child: Icon(
        Icons.error,
        key: key,
        color: color,
        semanticLabel: semanticsLabel,
      ),
    );
  }

  Widget frameWidget(BuildContext context, Widget child, int? frame, bool wasSynchronouslyLoaded) {
    if (wasSynchronouslyLoaded) {
      return child;
    }
    return AnimatedOpacity(
      child: child,
      opacity: frame == null ? 0 : 1,
      duration: const Duration(seconds: 1),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isSvg = assetName.toLowerCase().endsWith('.svg');
    final bool isNetwork = assetName.startsWith('http');
    final asset = "assets/icons/$assetName";

    if (isSvg) {
      return isNetwork ? SvgPicture.network(
        assetName,
        key: key,
        width: width,
        height: height,
        fit: fit,
        color: color,
        alignment: alignment,
        semanticsLabel: semanticsLabel,
        placeholderBuilder: (BuildContext context) => loadingAsset,
      ) : SvgPicture.asset(
        asset,
        key: key,
        width: width,
        height: height,
        fit: fit,
        color: color,
        alignment: alignment,
        semanticsLabel: semanticsLabel,
        placeholderBuilder: (BuildContext context) => loadingAsset,
      );
    } else {
      return isNetwork ? Image.network(
        assetName,
        key: key,
        width: width,
        height: height,
        fit: fit,
        color: color,
        alignment: alignment,
        semanticLabel: semanticsLabel,
        frameBuilder: frameWidget,
        loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) return child;
          return loadingAsset;
        },
        errorBuilder: (context, error, stackTrace) => errorAsset,
      ) : Image.asset(
        asset,
        key: key,
        width: width,
        height: height,
        fit: fit,
        color: color,
        alignment: alignment,
        semanticLabel: semanticsLabel,
        frameBuilder: frameWidget,
        errorBuilder: (context, error, stackTrace) => errorAsset,
      );
    }
  }
}