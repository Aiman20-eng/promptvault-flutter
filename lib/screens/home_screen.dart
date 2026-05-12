import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/prompt_provider.dart';
import '../utils/theme.dart';
import '../widgets/prompt_card.dart';
import '../widgets/responsive_layout.dart';
import '../data/dummy_prompts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PromptProvider>();
    final prompts = provider.filteredPrompts;
    final crossAxisCount = ResponsiveLayout.getGridCrossAxisCount(context);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ترويسة التطبيق / شريط البحث
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            gradient: AppTheme.primaryGradient,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.bolt, color: Colors.white, size: 24),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'PromptVault',
                                style: TextStyle(
                                  color: AppTheme.textPrimary,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              Text(
                                'مكتبة التلقين والأوامر الذكية المتميزة',
                                style: TextStyle(
                                  color: AppTheme.textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // شريط البحث
                    TextField(
                      onChanged: (value) => provider.setSearchQuery(value),
                      decoration: InputDecoration(
                        hintText: 'ابحث عن الأوامر، الوسوم، المنصات...',
                        prefixIcon: const Icon(Icons.search, color: AppTheme.textSecondary),
                        suffixIcon: provider.searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, color: AppTheme.textSecondary),
                                onPressed: () {
                                  provider.setSearchQuery('');
                                },
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // شرائح فلترة الأقسام الأفقية
                    SizedBox(
                      height: 40,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: appCategories.length + 1,
                        itemBuilder: (context, index) {
                          final isAll = index == 0;
                          final category = isAll ? 'الكل' : appCategories[index - 1];
                          final isSelected = isAll
                              ? (provider.selectedCategory == null || provider.selectedCategory!.isEmpty)
                              : provider.selectedCategory?.toLowerCase() == category.toLowerCase();

                          return Padding(
                            padding: const EdgeInsets.only(left: 8), // استخدام left لدعم الاتجاه من اليمين لليسار
                            child: ChoiceChip(
                              label: Text(category),
                              selected: isSelected,
                              onSelected: (selected) {
                                provider.setSelectedCategory(isAll ? null : category);
                              },
                              selectedColor: AppTheme.neonCyan.withValues(alpha: 0.2),
                              backgroundColor: AppTheme.surface,
                              labelStyle: TextStyle(
                                color: isSelected ? AppTheme.neonCyan : AppTheme.textSecondary,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                fontSize: 13,
                              ),
                              side: BorderSide(
                                color: isSelected ? AppTheme.neonCyan : AppTheme.surfaceHighlight,
                                width: 1,
                              ),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),

            // شبكة/قائمة الأوامر
            if (prompts.isEmpty)
              SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off_rounded, size: 64, color: AppTheme.textSecondary.withValues(alpha: 0.5)),
                      const SizedBox(height: 16),
                      const Text(
                        'لم يتم العثور على أوامر',
                        style: TextStyle(color: AppTheme.textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'حاول تعديل كلمات البحث أو فلتر الأقسام',
                        style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () => provider.clearFilters(),
                        child: const Text('إلغاء الفلاتر', style: TextStyle(color: AppTheme.neonCyan)),
                      ),
                    ],
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisExtent: 210,
                    crossAxisSpacing: 0,
                    mainAxisSpacing: 0,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return PromptCard(prompt: prompts[index]);
                    },
                    childCount: prompts.length,
                  ),
                ),
              ),
            
            // مساحة سفلية
            const SliverToBoxAdapter(child: SizedBox(height: 40)),
          ],
        ),
      ),
    );
  }
}
