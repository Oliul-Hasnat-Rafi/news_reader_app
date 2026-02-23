part of '../../../views/screens/dashboard/dashboard_screen.dart';

/// Dashboard Use Case for handling business logic
class _DashboardUseCase extends BaseUseCase {
  final _DashboardRepository _repository = _DashboardRepository();

  /// Get news articles
  Future<List<NewsArticleModel>> getNewsArticles() async {
    return _repository.fetchNewsArticles();
  }
}
