class PromptModel {
  final String id;
  final String title;
  final String description;
  final String fullPrompt;
  final String explanation;
  final String category;
  final List<String> tags;
  final String platform;
  final bool isFavorite;

  const PromptModel({
    required this.id,
    required this.title,
    required this.description,
    required this.fullPrompt,
    required this.explanation,
    required this.category,
    required this.tags,
    required this.platform,
    this.isFavorite = false,
  });

  PromptModel copyWith({
    String? id,
    String? title,
    String? description,
    String? fullPrompt,
    String? explanation,
    String? category,
    List<String>? tags,
    String? platform,
    bool? isFavorite,
  }) {
    return PromptModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      fullPrompt: fullPrompt ?? this.fullPrompt,
      explanation: explanation ?? this.explanation,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      platform: platform ?? this.platform,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
