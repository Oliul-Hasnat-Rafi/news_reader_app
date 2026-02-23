// Refactored with full performance optimizations:
// - _BookmarkButton extracted as separate widget (only it rebuilds on bookmark change)
// - _NewsCard is fully const-safe and key-aware
// - Obx scope minimized — no full-body rebuild
// - cacheExtent added to ListView
// - withOpacity replaced with withValues (Flutter 3.x)
// - Controller.find used only inside Obx widgets
// - Loading overlay via Stack instead of replacing whole body
// - dispose properly cleans up controller

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


class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
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
        appBar: const CustomAppBar(
          title: 'News Reader',
          automaticallyImplyLeading: false,
        ),

        body: Stack(
          children: [
            _NewsListView(controller: _controller),
            _LoadingOverlay(controller: _controller),
            _ErrorOverlay(controller: _controller),
          ],
        ),
      ),
    );
  }
}



class _NewsListView extends StatelessWidget {
  const _NewsListView({required this.controller});

  final DashboardController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value || controller.hasError.value) {
        return const SizedBox.shrink();
      }

      if (controller.newsList.isEmpty) {
        return const NoDataFound(message: 'No news articles available');
      }

      return RefreshIndicator(
        onRefresh: controller.refreshNews,
        child: ListView.separated(
          padding: EdgeInsets.all(defaultPadding / 2),
          cacheExtent: 500,
          itemCount: controller.newsList.length,
          separatorBuilder: (_, __) => const CustomSize(fraction: 2),
          itemBuilder: (_, int index) {
            final NewsArticleModel article = controller.newsList[index];
            return _NewsCard(
              key: ValueKey(article.id),
              article: article,
            );
          },
        ),
      );
    });
  }
}



class _LoadingOverlay extends StatelessWidget {
  const _LoadingOverlay({required this.controller});

  final DashboardController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!controller.isLoading.value) return const SizedBox.shrink();

      return const ColoredBox(
        color: Colors.transparent,
        child: Center(child: CircularProgressIndicator()),
      );
    });
  }
}



class _ErrorOverlay extends StatelessWidget {
  const _ErrorOverlay({required this.controller});

  final DashboardController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!controller.hasError.value) return const SizedBox.shrink();

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
                text: controller.errorMessage.value,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    });
  }
}


class _NewsCard extends StatelessWidget {
  const _NewsCard({super.key, required this.article});

  final NewsArticleModel article;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      backgroundColor:
          Theme.of(context).colorScheme.outline.withValues(alpha: 0.05),
      contentPadding: EdgeInsets.zero,
      boxShadow: [
        BoxShadow(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
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
              placeholder: (_, __) => ColoredBox(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
              errorWidget: (_, __, ___) => ColoredBox(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: Center(
                  child: Icon(
                    Icons.image_not_supported_outlined,
                    size: 48,
                    color: Theme.of(context).colorScheme.outline,
                  ),
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
                    _BookmarkButton(articleId: article.id),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



class _BookmarkButton extends StatelessWidget {
  const _BookmarkButton({required this.articleId});

  final String articleId;

  @override
  Widget build(BuildContext context) {
    final DashboardController controller = DashboardController.find;

    return Obx(() {
      final bool isBookmarked = controller.newsList
          .firstWhere(
            (NewsArticleModel a) => a.id == articleId,
            orElse: () => NewsArticleModel(id: articleId, title: '', description: ''),
          )
          .isBookmarked;

      return IconButton(
        onPressed: () => controller.toggleBookmark(articleId),
        icon: Icon(isBookmarked ? Icons.bookmark : Icons.bookmark_border),
      );
    });
  }
}