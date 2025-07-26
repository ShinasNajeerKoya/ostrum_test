import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class LoadingCommentTile extends StatelessWidget {
  const LoadingCommentTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8.r)),
          child: Row(
            children: [
              Container(
                height: 48.h,
                width: 48.w,
                decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(40.r)),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Container(height: 160.h, width: 140.w, color: Colors.grey)],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
