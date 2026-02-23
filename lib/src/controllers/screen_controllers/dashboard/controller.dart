// ignore_for_file: public_member_api_docs

part of '../../../views/screens/dashboard/dashboard_screen.dart';

/// Dashboard screen controller for managing news list
class DashboardController extends GetxController {
  /// Get [DashboardController] GetxController
  static DashboardController get find => Get.find();

  final _DashboardUseCase _useCase = _DashboardUseCase();

  /// List of news articles
  final RxList<NewsArticleModel> newsList = <NewsArticleModel>[].obs;

  /// Loading state
  final RxBool isLoading = true.obs;

  /// Error state
  final RxBool hasError = false.obs;

  /// Error message
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNews();
  }

  /// Fetch news articles
  Future<void> fetchNews() async {
    isLoading.value = true;
    hasError.value = false;
    errorMessage.value = '';

    try {
      final List<NewsArticleModel> articles = await _useCase.getNewsArticles();
      newsList.value = articles;
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Failed to load news. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  /// Toggle bookmark status for an article
  void toggleBookmark(String articleId) {
    final int index = newsList.indexWhere(
      (NewsArticleModel article) => article.id == articleId,
    );
    if (index != -1) {
      final NewsArticleModel article = newsList[index];
      newsList[index] = article.copyWith(isBookmarked: !article.isBookmarked);
      
      // Show feedback
      showToast(
        message: newsList[index].isBookmarked
            ? 'Article bookmarked'
            : 'Bookmark removed',
      );
    }
  }

  /// Refresh news list
  Future<void> refreshNews() async {
    await fetchNews();
  }
}
