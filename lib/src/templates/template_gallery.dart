import 'package:flutter/material.dart';
import '../core/models.dart';
import 'template_models.dart';

/// A widget that displays a gallery of poster templates.
class TemplateGallery extends StatefulWidget {
  /// Callback function triggered when a template is selected.
  final Function(PosterModel) onSelect;

  const TemplateGallery({super.key, required this.onSelect});

  @override
  State<TemplateGallery> createState() => _TemplateGalleryState();
}

class _TemplateGalleryState extends State<TemplateGallery> {
  TemplateCategory? _selectedCategory;
  String _searchQuery = '';

  List<PosterTemplate> get _filteredTemplates {
    var templates = TemplateFactory.getAllTemplates();

    // Filter by category
    if (_selectedCategory != null) {
      templates = templates
          .where((t) => t.metadata.category == _selectedCategory)
          .toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      templates = templates.where((t) {
        final query = _searchQuery.toLowerCase();
        return t.metadata.name.toLowerCase().contains(query) ||
            t.metadata.description.toLowerCase().contains(query) ||
            t.metadata.tags.any((tag) => tag.toLowerCase().contains(query));
      }).toList();
    }

    return templates;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search and Filter Bar
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Column(
            children: [
              // Search bar
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search templates...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
              const SizedBox(height: 12),
              // Category chips
              SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _CategoryChip(
                      label: 'All',
                      isSelected: _selectedCategory == null,
                      onTap: () {
                        setState(() {
                          _selectedCategory = null;
                        });
                      },
                    ),
                    ...TemplateCategory.values.map((category) {
                      return _CategoryChip(
                        label: _getCategoryName(category),
                        isSelected: _selectedCategory == category,
                        onTap: () {
                          setState(() {
                            _selectedCategory = category;
                          });
                        },
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Templates Grid
        Expanded(
          child: _filteredTemplates.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        'No templates found',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: MediaQuery.of(context).size.width < 600
                        ? 1 // Mobile: 1 column
                        : MediaQuery.of(context).size.width < 900
                            ? 2 // Tablet: 2 columns
                            : 3, // Desktop: 3 columns
                    childAspectRatio: MediaQuery.of(context).size.width < 600
                        ? 1.2 // Mobile: wider cards
                        : 0.6, // Tablet/Desktop: taller cards
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: _filteredTemplates.length,
                  itemBuilder: (context, index) {
                    final template = _filteredTemplates[index];
                    return _TemplateCard(
                      template: template,
                      onTap: () => widget.onSelect(template.poster),
                    );
                  },
                ),
        ),
      ],
    );
  }

  String _getCategoryName(TemplateCategory category) {
    switch (category) {
      case TemplateCategory.socialMedia:
        return 'Social Media';
      case TemplateCategory.events:
        return 'Events';
      case TemplateCategory.business:
        return 'Business';
      case TemplateCategory.seasonal:
        return 'Seasonal';
      case TemplateCategory.education:
        return 'Education';
      case TemplateCategory.health:
        return 'Health';
      case TemplateCategory.food:
        return 'Food';
      case TemplateCategory.realEstate:
        return 'Real Estate';
    }
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => onTap(),
        backgroundColor: Colors.grey[200],
        selectedColor: Colors.blue,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}

class _TemplateCard extends StatelessWidget {
  final PosterTemplate template;
  final VoidCallback onTap;

  const _TemplateCard({
    required this.template,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Template Preview
            Expanded(
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                child: Container(
                  width: double.infinity,
                  color: template.poster.backgroundColor,
                  child: Stack(
                    children: [
                      // Render a simplified preview of the template
                      ...template.poster.layers.take(3).map((layer) {
                        if (layer is TextLayer) {
                          return Positioned(
                            left: layer.position.dx * 0.15,
                            top: layer.position.dy * 0.15,
                            child: Transform.scale(
                              scale: 0.15 * layer.scale,
                              alignment: Alignment.topLeft,
                              child: Text(
                                layer.text,
                                style: layer.style.copyWith(
                                  fontSize: (layer.style.fontSize ?? 20) * 0.8,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          );
                        } else if (layer is ShapeLayer) {
                          return Positioned(
                            left: layer.position.dx * 0.15,
                            top: layer.position.dy * 0.15,
                            child: Transform.scale(
                              scale: 0.15 * layer.scale,
                              child: Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: layer.color,
                                  shape: layer.shapeType == 'circle'
                                      ? BoxShape.circle
                                      : BoxShape.rectangle,
                                  borderRadius: layer.shapeType == 'rectangle'
                                      ? BorderRadius.circular(
                                          layer.borderRadius ?? 0)
                                      : null,
                                ),
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      }),
                      // Paid badge
                      if (template.metadata.isPaid)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.star, size: 12, color: Colors.white),
                                SizedBox(width: 4),
                                Text(
                                  'PRO',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            // Template Info
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    template.metadata.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    template.metadata.description,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
