part of '../../../views/screens/dashboard/dashboard_wrapper_screen.dart';

/// Dashboard Repository for fetching news data
class _DashboardRepository extends HttpRepository {
  /// API key for newsdata.io
  static const String _apiKey = 'pub_3571c574037f4c8aa14b2866d4e21041';

  /// Get news articles from newsdata.io API
  Future<List<NewsArticleModel>> fetchNewsArticles() async {
    List<NewsArticleModel> articles = <NewsArticleModel>[];

    await errorHandler.errorHandler(
      function: () async {
        final String url =
            'https://newsdata.io/api/1/latest?apikey=$_apiKey';

        final dio.Response<Map<String, dynamic>> response =
            await httpClient.get(
          '',
          customBaseLink: url,
        );

        if (response.statusCode != 200 || response.data == null) {
          throw response;
        }

        final Map<String, dynamic> data = response.data!;

        if (data['status'] == 'success' && data['results'] != null) {
          final List<dynamic> results = data['results'] as List<dynamic>;
          articles = results
              .map((dynamic item) =>
                  NewsArticleModel.fromMap(item as Map<String, dynamic>))
              .where((NewsArticleModel article) =>
                  article.title.isNotEmpty && article.description.isNotEmpty)
              .toList();
        }
      },
    );

    return articles;
  }
}
