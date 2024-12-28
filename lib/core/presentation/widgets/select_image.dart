import 'package:flutter/material.dart';
import 'package:studiosync/core/presentation/theme/app_style.dart';

class SelectImageWidget extends StatelessWidget {
  final Function? onTap;
  final String? imagePath; // Changed to follow Dart naming conventions
  final double height;
  final double width;

  const SelectImageWidget({
    super.key,
    required this.onTap,
    required this.imagePath,
    this.height = 100, // Default height
    this.width = 100, // Default width
  });

  @override
  Widget build(BuildContext context) {
    debugPrint('build SelectImageWidget');
    return GestureDetector(
      onTap: () {
        onTap!();
      },
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: AppStyle.backGrey2,
          borderRadius: BorderRadius.circular(15),
        ),
        child: imagePath == null || imagePath!.isEmpty
            ? Center(
                child: Icon(
                  Icons.camera_alt_rounded,
                  size: 50,
                  color: AppStyle.backGrey3,
                ),
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  imagePath!,
                  fit: BoxFit.cover,
                  frameBuilder:
                      (context, child, frame, wasSynchronouslyLoaded) {
                    return child;
                  },
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) {
                      return child; // Image loaded successfully
                    }
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                (loadingProgress.expectedTotalBytes ?? 1)
                            : null,
                      ),
                    ); // Show loading indicator while the image is loading
                  },
                  errorBuilder: (BuildContext context, Object error,
                      StackTrace? stackTrace) {
                    return Center(
                      child: Icon(
                        Icons.error,
                        color: AppStyle.backGrey3,
                      ),
                    ); // Show an error icon if the image fails to load
                  },
                ),
              ),
      ),
    );
  }
}
