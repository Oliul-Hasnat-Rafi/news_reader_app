// Refactored according to user's coding style
// - CustomTextBody instead of Text
// - CustomSize instead of SizedBox
// - defaultPadding usage
// - Clean structure
// - 60 FPS friendly widgets

import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:personal_project/src/utils/functions/date_time_conversion.dart';
import 'package:personal_project/src/views/widgets/custom_app_bar.dart';

import '../../../../components.dart';
import '../../../core/http/http_repository.dart';
import '../../../core/use_case/use_case.dart';
import '../../../utils/dev_functions/dev_scaffold.dart';
import '../../../utils/user_message/snackbar.dart';
import '../../widgets/card.dart';
import '../../widgets/no_result_found.dart';
import '../../widgets/size.dart';
import '../../../models/data/response_model/news_article_model.dart';
import '../../widgets/text.dart';

part '../../../controllers/screen_controllers/dashboard/controller.dart';
part '../../../controllers/screen_controllers/dashboard/repository.dart';
part '../../../controllers/screen_controllers/dashboard/use_case.dart';

/// Dashboard Wrapper Screen
class DashboardWrapperScreen extends StatefulWidget {
  /// Dashboard Wrapper Screen
  const DashboardWrapperScreen({super.key});

  @override
  State<DashboardWrapperScreen> createState() => _DashboardWrapperScreenState();
}

class _DashboardWrapperScreenState extends State<DashboardWrapperScreen> {
  final DashboardController _controller = Get.put(DashboardController());

  @override
  void dispose() {
    Get.delete<DashboardController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DevScaffold(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.onSecondary,
        appBar: const CustomAppBar(title: 'News Reader', automaticallyImplyLeading: false,),
        body: Obx(_buildBody),
      ),
    );
  }

  Widget _buildBody() {
    if (_controller.isLoading.value) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
        
          ],
        ),
      );
    }

    if (_controller.hasError.value) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(defaultPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.error_outline,
                size: 64,
                color: Theme.of(context).colorScheme.error,
              ),
              const CustomSize(fraction: 4),
              CustomTextBody.L(
                text: _controller.errorMessage.value,
                textAlign: TextAlign.center,
              ),
              
            ],
          ),
        ),
      );
    }

    if (_controller.newsList.isEmpty) {
      return const NoDataFound(
          message: 'No news articles available');
    }

    return RefreshIndicator(
      onRefresh: _controller.refreshNews,
      child: ListView.separated(
        padding: EdgeInsets.all(defaultPadding / 2),
        itemCount: _controller.newsList.length,
        separatorBuilder: (_, __) => const CustomSize(fraction: 2),
        itemBuilder: (_, int index) {
          final NewsArticleModel article = _controller.newsList[index];
          return _NewsCard(article: article);
        },
      ),
    );
  }
}

/// News Card
class _NewsCard extends StatelessWidget {
  const _NewsCard({required this.article});

  final NewsArticleModel article;

  @override
  Widget build(BuildContext context) {
    final DashboardController controller = DashboardController.find;

    return CustomCard(
      backgroundColor: Theme.of(context).colorScheme.outline.withOpacity(0.05),
     contentPadding: EdgeInsets.zero,
     boxShadow: [
        BoxShadow(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
        spreadRadius: 1,
        ),
      ],
      child: Column(
        
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AspectRatio(
            aspectRatio: 16 / 9,
            child: CachedNetworkImage(
              imageUrl: article.imageUrl ?? '',
              fit: BoxFit.cover,
              placeholder: (_, __) => Container(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
              ),
              errorWidget: (_, __, ___) => Container(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: Icon(
                  Icons.image_not_supported_outlined,
                  size: 48,
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
            ),
          ),
      
          Padding(
            padding: EdgeInsets.all(defaultPadding / 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    if (article.source != null)
                      Expanded(
                        child: CustomTextBody.S(
                          text: article.source!,
                          maxLine: 1,
                        
                        ),
                      ),
                    if (article.publishedAt != null)
                      CustomTextBody.S(
                        text: article.publishedAt?.custom_MMM_d_hh_mm_a ?? '',
                      ),
                  ],
                ),
                const CustomSize(fraction: 4),
      
                CustomTextBody.L(
                  text: article.title,
                  maxLine: 2,
                ),
                const CustomSize(fraction: 4),
      
                CustomTextBody.S(
                  text: article.description,
                  maxLine: 3,
                ),
                const CustomSize(fraction: 2),
      
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Obx(() {
                      final bool isBookmarked = controller.newsList
                          .firstWhere((NewsArticleModel a) => a.id == article.id, orElse: () => article)
                          .isBookmarked;
      
                      return IconButton(
                        onPressed: () => controller.toggleBookmark(article.id),
                        icon: Icon(isBookmarked ? Icons.bookmark : Icons.bookmark_border),
                      );
                    }),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // String _formatDate(DateTime date) {
  //   final Duration diff = DateTime.now().difference(date);

  //   if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
  //   if (diff.inHours < 24) return '${diff.inHours}h ago';
  //   if (diff.inDays < 7) return '${diff.inDays}d ago';

  //   return '${date.day}/${date.month}/${date.year}';
  // }
}
