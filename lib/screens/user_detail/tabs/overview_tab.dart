import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pbl5/app_common_data/app_text_sytle.dart';
import 'package:pbl5/app_common_data/common_data/global_variable.dart';
import 'package:pbl5/app_common_data/extensions/pair_ext.dart';
import 'package:pbl5/constants.dart';
import 'package:pbl5/locator_config.dart';
import 'package:pbl5/models/application_position/application_position.dart';
import 'package:pbl5/models/pair/pair.dart';
import 'package:pbl5/models/user/user.dart';
import 'package:pbl5/screens/user_detail/components/interview_invitation_dialog.dart';
import 'package:pbl5/shared_customization/extensions/date_time_ext.dart';
import 'package:pbl5/shared_customization/extensions/string_ext.dart';
import 'package:pbl5/shared_customization/helpers/banner_helper.dart';
import 'package:pbl5/shared_customization/helpers/dialogs/dialog_helper.dart';
import 'package:pbl5/shared_customization/widgets/buttons/custom_button.dart';
import 'package:pbl5/shared_customization/widgets/texts/custom_text.dart';
import 'package:pbl5/view_models/detail_view_model.dart';
import 'package:provider/provider.dart';

class OverviewTab extends StatelessWidget {
  const OverviewTab(
      {super.key,
      required this.user,
      required this.pair,
      required this.applicationPositions});
  final User user;
  final Pair? pair;
  final List<ApplicationPosition> applicationPositions;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 20.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                "About Us",
                style: TextStyle(
                  fontSize: 19,
                  color: Colors.black87,
                  fontFamily: 'Poppins',
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16.h),
                child: Text('\t' + (user.summaryIntroduction ?? '')),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16.h),
                child: Row(
                  children: [
                    Icon(Icons.mail),
                    SizedBox(width: 15.h),
                    Expanded(
                      child: Text(
                        user.email ?? '',
                        style: TextStyle(fontSize: 15.sp),
                      ),
                    ),
                  ],
                ),
              ),
              Builder(builder: (context) {
                final socialMediaLinks =
                    context.select<DetailViewModel, List<String>?>(
                        (vm) => vm.user?.socialMediaLink);
                final allSocialMediaLinks = socialMediaLinks?.join(', ');
                return Padding(
                  padding: EdgeInsets.only(top: 16.h),
                  child: Row(
                    children: [
                      Icon(Icons.link),
                      SizedBox(width: 15.h),
                      Expanded(
                        child: Text(
                          allSocialMediaLinks ?? '',
                          style: TextStyle(fontSize: 15.sp),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              Padding(
                padding: EdgeInsets.only(top: 16.h),
                child: Row(
                  children: [
                    Icon(Icons.date_range),
                    SizedBox(width: 15.h),
                    Expanded(
                      child: Text(
                        user.dob != null
                            ? user.dob.toDateTime.toDayMonthYear()
                            : '',
                        style: TextStyle(fontSize: 15.sp),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16.h),
                child: Row(
                  children: [
                    Icon(Icons.phone),
                    SizedBox(width: 15.h),
                    Expanded(
                      child: Text(
                        user.phoneNumber ?? '',
                        style: TextStyle(fontSize: 15.sp),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16.h),
                child: Row(
                  children: [
                    Icon(Icons.location_on_rounded),
                    SizedBox(width: 15.h),
                    Expanded(
                      child: Text(
                        user.address ?? '',
                        style: TextStyle(fontSize: 15.sp),
                      ),
                    ),
                  ],
                ),
              ),
              if (pair != null) SizedBox(height: 20.h),
              if (pair != null)
                Builder(
                  builder: (context) {
                    if (pair!.isFullyMatched) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: CustomButton(
                              contentAlignment: Alignment.center,
                              onPressed: () {
                                showCustomDialog(
                                  context: context,
                                  builder: (_) {
                                    return InterviewInvitationDialog(
                                      applicationPositions:
                                          applicationPositions,
                                      onConfirm:
                                          (interviewDate, interviewPositionId) {
                                        getIt.get<DetailViewModel>().sendInterviewMail(
                                            interviewDate: interviewDate,
                                            interviewPositionId:
                                                interviewPositionId,
                                            onSuccess: () => showSuccessBanner(
                                                content:
                                                    "Interview invitation sent successfully"),
                                            onFailure: (e) =>
                                                showErrorBanner(content: e));
                                      },
                                    );
                                  },
                                );
                              },
                              color: orangePink,
                              label: "Interview invitation",
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: CustomButton(
                              contentAlignment: Alignment.center,
                              onPressed: () {
                                showConfirmDialog(
                                  context,
                                  title: "Cancel pair",
                                  content:
                                      "Are you sure you want to cancel this pair?",
                                  onAccept: () {
                                    getIt.get<DetailViewModel>().declinePair(
                                        onSuccess: () {
                                      showSuccessBanner(
                                          content: "Cancel pair successfully");
                                    }, onFailure: (e) {
                                      showErrorBanner(content: e);
                                    });
                                  },
                                );
                              },
                              color: Colors.grey,
                              label: "Cancel pair",
                            ),
                          )
                        ],
                      );
                    }

                    if (pair!.isShowAcceptBtn) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: CustomButton(
                              contentAlignment: Alignment.center,
                              onPressed: () {
                                showConfirmDialog(
                                  context,
                                  title: "Accept pair",
                                  content:
                                      "Are you sure you want to accept this pair?",
                                  onAccept: () {
                                    getIt.get<DetailViewModel>().acceptPair(
                                        onSuccess: () {
                                      showSuccessBanner(
                                          content:
                                              "Pair accepted successfully");
                                    }, onFailure: (e) {
                                      showErrorBanner(content: e);
                                    });
                                  },
                                );
                              },
                              color: orangePink,
                              label: "Accept pair",
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: CustomButton(
                              contentAlignment: Alignment.center,
                              onPressed: () {
                                showConfirmDialog(
                                  context,
                                  title: "Decline request",
                                  content:
                                      "Are you sure you want to decline this request?",
                                  onAccept: () {
                                    getIt.get<DetailViewModel>().declinePair(
                                        onSuccess: () {
                                      showSuccessBanner(
                                          content:
                                              "Decline request successfully");
                                    }, onFailure: (e) {
                                      showErrorBanner(content: e);
                                    });
                                  },
                                );
                              },
                              color: Colors.grey,
                              label: "Decline request",
                            ),
                          )
                        ],
                      );
                    }

                    if (pair!.isShowMakePairAgainBtn) {
                      return Column(
                        children: [
                          CustomText(
                            "You canceled this pair, you can make pair again!",
                            style: AppTextStyle.defaultStyle
                                .copyWith(fontStyle: FontStyle.italic),
                            color: Colors.grey,
                            padding: const EdgeInsets.only(bottom: 12),
                          ),
                          CustomButton(
                            contentAlignment: Alignment.center,
                            width: double.infinity,
                            onPressed: () {
                              showConfirmDialog(
                                context,
                                title: "Make pair again",
                                content:
                                    "Are you sure you want to make pair again?",
                                onAccept: () {
                                  getIt.get<DetailViewModel>().acceptPair(
                                      onSuccess: () {
                                    showSuccessBanner(
                                        content:
                                            "Make pair again successfully");
                                  }, onFailure: (e) {
                                    showErrorBanner(content: e);
                                  });
                                },
                              );
                            },
                            color: orangePink,
                            label: "Make pair again",
                          ),
                        ],
                      );
                    }

                    if (pair!.isRequestToUser) {
                      return CustomText(
                        "Your request is pending, please wait for the response from the user!",
                        style: AppTextStyle.defaultStyle
                            .copyWith(fontStyle: FontStyle.italic),
                        color: Colors.grey,
                      );
                    }

                    if (pair!.isCanceledByUser) {
                      return CustomText(
                        "This pair has been canceled by the user! You can't do anything!",
                        style: AppTextStyle.defaultStyle
                            .copyWith(fontStyle: FontStyle.italic),
                        color: Colors.grey,
                      );
                    }

                    return EMPTY_WIDGET;
                  },
                )
            ],
          ),
        ),
      ),
    );
  }
}
