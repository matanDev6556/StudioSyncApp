import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:studiosync/core/theme/app_style.dart';

class CustomImageWidget extends StatelessWidget {
  final String? imageUrl;
  final double height;
  final double width;

  final bool isLoading; // New isLoading flag
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final BoxFit boxFit;
  final IconData defaultIcon;

  const CustomImageWidget({
    Key? key,
    this.imageUrl,
    this.width = 120.0,
    this.height = 150.0,
    this.isLoading = false, // Set isLoading default to false
    this.onEdit,
    this.onDelete,
    this.boxFit = BoxFit.cover,
    this.defaultIcon = Icons.person, // Default placeholder icon
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            color: Colors.grey[200], // Background color for the placeholder
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: isLoading // Show loading indicator if isLoading is true
                ? Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          AppStyle.deepBlackOrange),
                    ),
                  )
                : imageUrl != null && imageUrl!.isNotEmpty
                    ? Image.network(
                        imageUrl!,
                        height: height.h,
                        width: width.w,
                        fit: boxFit,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(
                            child: LinearProgressIndicator(),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          // Display the default icon if image fails to load
                          return Icon(
                            defaultIcon,
                            size: height * 0.5,
                            color: Colors.grey[400],
                          );
                        },
                      )
                    : Center(
                        // Show the default icon when imageUrl is empty or null
                        child: Icon(
                          defaultIcon,
                          size: height * 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
          ),
        ),
        if (onEdit != null)
          Positioned(
            bottom: 0,
            right: 0,
            child: Row(
              children: [
                if (onDelete !=
                    null) // Show delete icon only if onDelete is provided
                  GestureDetector(
                    onTap: onDelete,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Icon(
                        Icons.delete,
                        color: Colors.red,
                        size: 25.w,
                      ),
                    ),
                  ),
                SizedBox(width: 8.w), // Spacing between edit and delete icons
                GestureDetector(
                  onTap: onEdit,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Icon(
                      Icons.edit,
                      color: Colors.orange,
                      size: 25.w,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
