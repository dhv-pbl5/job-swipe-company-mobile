import 'package:flutter/material.dart';
import 'package:pbl5/models/user/user.dart';
import 'package:pbl5/services/api_models/api_page_response/api_page_response.dart';
import 'package:pbl5/services/service_repositories/swipe_selection_repository.dart';
import 'package:pbl5/shared_customization/extensions/api_page_response_ext.dart';
import 'package:pbl5/shared_customization/helpers/utilizations/dio_parse_error.dart';
import 'package:pbl5/view_models/base_view_model.dart';

class SwipeSelectionViewModel extends BaseViewModel {
  final SwipeSelectionRepository recPredictRepo;

  ApiPageResponse<User>? users;
  bool isLoadmore = false;

  SwipeSelectionViewModel({required this.recPredictRepo});

  Future<void> getRecommendedCompanies({
    int page = 1,
    VoidCallback? onSuccess,
    Function(String)? onFailure,
  }) async {
    try {
      if (page != 1) {
        isLoadmore = true;
        updateUI();
      } else if (page == 1) {
        users = null;
        updateUI();
      }
      var response = (await recPredictRepo.getRecommendedUsers(page: page));
      users = users.insertPage(response);
      onSuccess?.call();
      isLoadmore = false;
      updateUI();
    } on Exception catch (error) {
      onFailure?.call(parseError(error));
      users = ApiPageResponse.empty();
    } finally {
      isLoadmore = false;
      updateUI();
    }
  }

  Future<void> requestMatchedPair({
    String? userId,
    VoidCallback? onSuccess,
    Function(String)? onFailure,
  }) async {
    try {
      await recPredictRepo.requestMatchedPair(userId!);
      updateUI();
      onSuccess?.call();
    } on Exception catch (error) {
      onFailure?.call(error.toString());
    }
  }
}
