import 'package:flutter/foundation.dart';
import '../models/prompt_model.dart';
import '../data/dummy_prompts.dart';

class PromptProvider extends ChangeNotifier {
  // All prompts
  List<PromptModel> _prompts = [];

  // IDs of prompts added to collection
  final Set<String> _collectionIds = {};

  // Search query
  String _searchQuery = '';

  // Selected category filter (null or empty means all categories)
  String? _selectedCategory;

  PromptProvider() {
    // Initialize with dummy data
    _prompts = List.from(dummyPrompts);
  }

  // Getters
  List<PromptModel> get allPrompts => _prompts;

  Set<String> get collectionIds => _collectionIds;

  String get searchQuery => _searchQuery;

  String? get selectedCategory => _selectedCategory;

  // Filtered prompts based on search query and selected category
  List<PromptModel> get filteredPrompts {
    return _prompts.where((prompt) {
      final matchesCategory = _selectedCategory == null ||
          _selectedCategory!.isEmpty ||
          prompt.category.toLowerCase() == _selectedCategory!.toLowerCase();

      final matchesSearch = _searchQuery.isEmpty ||
          prompt.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          prompt.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          prompt.category.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          prompt.tags.any((t) => t.toLowerCase().contains(_searchQuery.toLowerCase()));

      return matchesCategory && matchesSearch;
    }).toList();
  }

  // Favorite prompts
  List<PromptModel> get favoritePrompts {
    return _prompts.where((p) => p.isFavorite).toList();
  }

  // Collected prompts
  List<PromptModel> get collectionPrompts {
    return _prompts.where((p) => _collectionIds.contains(p.id)).toList();
  }

  // Live collection count badge getter
  int get collectionCount => _collectionIds.length;

  // Actions

  void toggleFavorite(String id) {
    final index = _prompts.indexWhere((p) => p.id == id);
    if (index != -1) {
      final prompt = _prompts[index];
      _prompts[index] = prompt.copyWith(isFavorite: !prompt.isFavorite);
      notifyListeners();
    }
  }

  void addToCollection(String id) {
    if (!_collectionIds.contains(id)) {
      _collectionIds.add(id);
      notifyListeners();
    }
  }

  void removeFromCollection(String id) {
    if (_collectionIds.contains(id)) {
      _collectionIds.remove(id);
      notifyListeners();
    }
  }

  void clearCollection() {
    if (_collectionIds.isNotEmpty) {
      _collectionIds.clear();
      notifyListeners();
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setSelectedCategory(String? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void clearFilters() {
    _searchQuery = '';
    _selectedCategory = null;
    notifyListeners();
  }

  // Helper to get prompts strictly for a specific category regardless of general search filters
  List<PromptModel> getPromptsForCategory(String category) {
    return _prompts.where((p) => p.category.toLowerCase() == category.toLowerCase()).toList();
  }

  // Helper to group collection items by category
  Map<String, List<PromptModel>> get collectionGroupedByCategory {
    final map = <String, List<PromptModel>>{};
    for (final p in collectionPrompts) {
      map.putIfAbsent(p.category, () => []).add(p);
    }
    return map;
  }
}
