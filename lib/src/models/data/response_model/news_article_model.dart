import 'dart:convert';

/// News Article Model - matches newsdata.io API response
class NewsArticleModel {

  /// Convert from Map (newsdata.io API format)
  factory NewsArticleModel.fromMap(Map<String, dynamic> map) {
    return NewsArticleModel(
      id: map['article_id']?.toString() ?? '',
      title: map['title']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      imageUrl: map['image_url']?.toString(),
      source: map['source_name']?.toString(),
      sourceIcon: map['source_icon']?.toString(),
      link: map['link']?.toString(),
      publishedAt: map['pubDate'] != null
          ? DateTime.tryParse(map['pubDate'].toString())
          : null,
      category: map['category'] != null
          ? List<String>.from(map['category'] as List<dynamic>)
          : null,
      creator: map['creator'] != null
          ? List<String>.from(map['creator'] as List<dynamic>)
          : null,
      isBookmarked: map['isBookmarked'] as bool? ?? false,
    );
  }

  /// Convert from Json
  factory NewsArticleModel.fromJson(String source) => NewsArticleModel.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );
  /// NewsArticleModel Constructor
  const NewsArticleModel({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
    this.source,
    this.sourceIcon,
    this.link,
    this.publishedAt,
    this.category,
    this.creator,
    this.isBookmarked = false,
  });

  /// Article ID
  final String id;

  /// Article Title
  final String title;

  /// Article Description
  final String description;

  /// Image URL (optional)
  final String? imageUrl;

  /// Source of the article
  final String? source;

  /// Source icon URL
  final String? sourceIcon;

  /// Article link
  final String? link;

  /// Published date
  final DateTime? publishedAt;

  /// Category
  final List<String>? category;

  /// Creator/Author
  final List<String>? creator;

  /// Bookmark status
  final bool isBookmarked;

  /// CopyWith method
  NewsArticleModel copyWith({
    String? id,
    String? title,
    String? description,
    String? imageUrl,
    String? source,
    String? sourceIcon,
    String? link,
    DateTime? publishedAt,
    List<String>? category,
    List<String>? creator,
    bool? isBookmarked,
  }) {
    return NewsArticleModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      source: source ?? this.source,
      sourceIcon: sourceIcon ?? this.sourceIcon,
      link: link ?? this.link,
      publishedAt: publishedAt ?? this.publishedAt,
      category: category ?? this.category,
      creator: creator ?? this.creator,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }

  /// Convert to Map
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'article_id': id,
      'title': title,
      'description': description,
      'image_url': imageUrl,
      'source_name': source,
      'source_icon': sourceIcon,
      'link': link,
      'pubDate': publishedAt?.toIso8601String(),
      'category': category,
      'creator': creator,
      'isBookmarked': isBookmarked,
    };
  }

  /// Convert to Json
  String toJson() => json.encode(toMap());

  @override
  String toString() => '''
NewsArticleModel(
  id: $id,
  title: $title,
  description: $description,
  imageUrl: $imageUrl,
  source: $source,
  publishedAt: $publishedAt,
  isBookmarked: $isBookmarked,
)
''';

  @override
  bool operator ==(covariant NewsArticleModel other) {
    if (identical(this, other)) return true;
    return other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
