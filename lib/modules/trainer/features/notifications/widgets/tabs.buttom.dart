import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:studiosync/core/theme/app_style.dart';

import 'package:studiosync/modules/trainer/features/notifications/views/notifications_tab.dart';
import 'package:studiosync/modules/trainer/features/notifications/views/requests_tab.dart';

class TabsButtom extends StatelessWidget {
  final int reqCount;
 
  const TabsButtom({super.key,required this.reqCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.81,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              labelColor: AppStyle.softBrown,
              indicatorColor: AppStyle.softOrange,
              tabs: [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Requests',
                        style: TextStyle(color: AppStyle.softBrown),
                      ),
                      AppStyle.w(10.w),
                      reqCount > 0
                          ? Container(
                              height: 20.h,
                              width: 20.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100.r),
                                color: Colors.red.withOpacity(0.8),
                              ),
                              child: Center(
                                child: Text(
                                 reqCount
                                      .toString(),
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Notifications',
                        style: TextStyle(color: AppStyle.softBrown),
                      ),
                      AppStyle.w(10.w),
                      Container(
                        height: 20.h,
                        width: 20.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100.r),
                          color: Colors.red.withOpacity(0.8),
                        ),
                        child: Center(
                          child: Text(
                            '2',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Expanded(
              // TabBarView לתוכן כל טאב
              child: TabBarView(
                children: [
                  RequestsTab(),
                  NotificationsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
