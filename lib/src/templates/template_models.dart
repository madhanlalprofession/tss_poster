import 'package:flutter/material.dart';
import '../core/models.dart';

/// Enum for template categories
enum TemplateCategory {
  socialMedia,
  events,
  business,
  seasonal,
  education,
  health,
  food,
  realEstate,
}

/// Metadata for a template
class TemplateMetadata {
  final String name;
  final String description;
  final TemplateCategory category;
  final bool isPaid;
  final List<String> tags;

  const TemplateMetadata({
    required this.name,
    required this.description,
    required this.category,
    this.isPaid = false,
    this.tags = const [],
  });
}

/// A complete poster template with metadata
class PosterTemplate {
  final TemplateMetadata metadata;
  final PosterModel poster;

  const PosterTemplate({
    required this.metadata,
    required this.poster,
  });
}

/// Factory for creating professional poster templates
class TemplateFactory {
  static List<PosterTemplate> getAllTemplates() {
    return [
      // Phase 1: Professional Multi-layered Templates
      _createFitnessInstagramPost(),
      _createEventFlyer(),
      _createProductLaunchPoster(),
      _createFoodMenuDesign(),
      _createRealEstateFlyer(),
      _createBusinessCard(),
      _createQuotePost(),
      _createSalePromotion(),
      _createWeddingInvitation(),
      _createConcertPoster(),
    ];
  }

  static List<PosterTemplate> getTemplatesByCategory(
      TemplateCategory category) {
    return getAllTemplates()
        .where((t) => t.metadata.category == category)
        .toList();
  }

  // ==================== PROFESSIONAL TEMPLATES ====================

  /// Instagram Fitness Post - Gradient background with hero section
  static PosterTemplate _createFitnessInstagramPost() {
    return PosterTemplate(
      metadata: const TemplateMetadata(
        name: 'Fitness Motivation',
        description: 'High-energy fitness post with gradient background',
        category: TemplateCategory.health,
        tags: ['instagram', 'fitness', 'motivation', 'health'],
      ),
      poster: PosterModel(
        backgroundColor: const Color(0xFFFF6B6B), // Coral gradient base
        size: const Size(1080, 1080),
        layers: [
          // Gradient overlay shape (simulated)
          ShapeLayer(
            shapeType: 'rectangle',
            color: Color.fromRGBO(255, 142, 83, 0.7),
            position: const Offset(0, 0),
            width: 1080,
            height: 540,
          ),

          // Main title with shadow effect
          TextLayer(
            text: 'PUSH YOUR\nLIMITS',
            style: const TextStyle(
              fontSize: 90,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              height: 0.9,
              letterSpacing: -2,
            ),
            align: TextAlign.center,
            position: const Offset(540, 200),
          ),

          // Subtitle
          TextLayer(
            text: 'Transform Your Body & Mind',
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w500,
              color: Colors.white,
              letterSpacing: 1,
            ),
            align: TextAlign.center,
            position: const Offset(540, 450),
          ),

          // Decorative accent shape
          ShapeLayer(
            shapeType: 'circle',
            color: Color.fromRGBO(255, 255, 255, 0.15),
            position: const Offset(100, 700),
            width: 300,
            height: 300,
          ),

          // CTA button background
          ShapeLayer(
            shapeType: 'rectangle',
            color: Colors.white,
            borderRadius: 30,
            position: const Offset(340, 850),
            width: 400,
            height: 80,
          ),

          // CTA text
          TextLayer(
            text: 'START TODAY',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Color(0xFFFF6B6B),
              letterSpacing: 2,
            ),
            align: TextAlign.center,
            position: const Offset(540, 875),
          ),
        ],
      ),
    );
  }

  /// Event Flyer - Multi-layered with photo overlay
  static PosterTemplate _createEventFlyer() {
    return PosterTemplate(
      metadata: const TemplateMetadata(
        name: 'Music Festival',
        description: 'Professional event flyer with photo effects',
        category: TemplateCategory.events,
        tags: ['concert', 'festival', 'music', 'event'],
      ),
      poster: PosterModel(
        backgroundColor: const Color(0xFF1A1A2E),
        size: const Size(1080, 1920),
        layers: [
          // Dark overlay for contrast
          ShapeLayer(
            shapeType: 'rectangle',
            color: Color.fromRGBO(0, 0, 0, 0.5),
            position: const Offset(0, 0),
            width: 1080,
            height: 800,
          ),

          // Event title with glow effect
          TextLayer(
            text: 'SUMMER\nBEATS',
            style: const TextStyle(
              fontSize: 110,
              fontWeight: FontWeight.w900,
              color: Color(0xFFFFD700),
              height: 0.85,
              letterSpacing: 5,
            ),
            align: TextAlign.center,
            position: const Offset(540, 250),
          ),

          // Subtitle
          TextLayer(
            text: 'MUSIC FESTIVAL 2024',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: Color.fromRGBO(255, 255, 255, 0.9),
              letterSpacing: 8,
            ),
            align: TextAlign.center,
            position: const Offset(540, 480),
          ),

          // Decorative line
          ShapeLayer(
            shapeType: 'rectangle',
            color: const Color(0xFFFFD700),
            position: const Offset(340, 550),
            width: 400,
            height: 4,
          ),

          // Date badge background
          ShapeLayer(
            shapeType: 'rectangle',
            color: const Color(0xFFFFD700),
            borderRadius: 20,
            position: const Offset(340, 900),
            width: 400,
            height: 120,
          ),

          // Date text
          TextLayer(
            text: 'JULY 15-17',
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.w900,
              color: Color(0xFF1A1A2E),
              letterSpacing: 3,
            ),
            align: TextAlign.center,
            position: const Offset(540, 930),
          ),

          // Location info
          TextLayer(
            text: 'CENTRAL PARK, NEW YORK',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 2,
            ),
            align: TextAlign.center,
            position: const Offset(540, 1100),
          ),

          // Ticket CTA
          ShapeLayer(
            shapeType: 'rectangle',
            color: const Color(0xFFE91E63),
            borderRadius: 35,
            position: const Offset(290, 1650),
            width: 500,
            height: 90,
          ),

          TextLayer(
            text: 'GET TICKETS NOW',
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: 2,
            ),
            align: TextAlign.center,
            position: const Offset(540, 1680),
          ),
        ],
      ),
    );
  }

  /// Product Launch - Split layout design
  static PosterTemplate _createProductLaunchPoster() {
    return PosterTemplate(
      metadata: const TemplateMetadata(
        name: 'Product Launch',
        description: 'Modern product announcement with features',
        category: TemplateCategory.business,
        tags: ['product', 'launch', 'tech', 'business'],
      ),
      poster: PosterModel(
        backgroundColor: const Color(0xFFF5F5F5),
        size: const Size(1080, 1350),
        layers: [
          // Top accent bar
          ShapeLayer(
            shapeType: 'rectangle',
            color: const Color(0xFF6C5CE7),
            position: const Offset(0, 0),
            width: 1080,
            height: 15,
          ),

          // "NEW" badge
          ShapeLayer(
            shapeType: 'rectangle',
            color: const Color(0xFFFF6348),
            borderRadius: 8,
            position: const Offset(60, 60),
            width: 120,
            height: 50,
          ),

          TextLayer(
            text: 'NEW',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: 3,
            ),
            align: TextAlign.center,
            position: const Offset(120, 72),
          ),

          // Product name
          TextLayer(
            text: 'Introducing\nProMax Ultra',
            style: const TextStyle(
              fontSize: 72,
              fontWeight: FontWeight.w900,
              color: Color(0xFF2D3436),
              height: 1.1,
            ),
            align: TextAlign.left,
            position: const Offset(60, 180),
          ),

          // Tagline
          TextLayer(
            text: 'The future of innovation',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w500,
              color: Color(0xFF636E72),
              fontStyle: FontStyle.italic,
            ),
            align: TextAlign.left,
            position: const Offset(60, 380),
          ),

          // Feature 1
          ShapeLayer(
            shapeType: 'circle',
            color: const Color(0xFF6C5CE7),
            position: const Offset(60, 550),
            width: 80,
            height: 80,
          ),

          TextLayer(
            text: 'Ultra HD Display',
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2D3436),
            ),
            align: TextAlign.left,
            position: const Offset(170, 572),
          ),

          // Feature 2
          ShapeLayer(
            shapeType: 'circle',
            color: const Color(0xFF6C5CE7),
            position: const Offset(60, 680),
            width: 80,
            height: 80,
          ),

          TextLayer(
            text: 'AI-Powered Performance',
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2D3436),
            ),
            align: TextAlign.left,
            position: const Offset(170, 702),
          ),

          // Feature 3
          ShapeLayer(
            shapeType: 'circle',
            color: const Color(0xFF6C5CE7),
            position: const Offset(60, 810),
            width: 80,
            height: 80,
          ),

          TextLayer(
            text: '5-Day Battery Life',
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2D3436),
            ),
            align: TextAlign.left,
            position: const Offset(170, 832),
          ),

          // Price section background
          ShapeLayer(
            shapeType: 'rectangle',
            color: const Color(0xFF2D3436),
            position: const Offset(0, 1100),
            width: 1080,
            height: 250,
          ),

          TextLayer(
            text: 'Starting at',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
            align: TextAlign.center,
            position: const Offset(540, 1140),
          ),

          TextLayer(
            text: '\$999',
            style: const TextStyle(
              fontSize: 96,
              fontWeight: FontWeight.w900,
              color: Color(0xFF6C5CE7),
            ),
            align: TextAlign.center,
            position: const Offset(540, 1200),
          ),
        ],
      ),
    );
  }

  /// Food Menu - Restaurant style
  static PosterTemplate _createFoodMenuDesign() {
    return PosterTemplate(
      metadata: const TemplateMetadata(
        name: 'Restaurant Menu',
        description: 'Elegant food menu design',
        category: TemplateCategory.food,
        tags: ['restaurant', 'food', 'menu', 'dining'],
      ),
      poster: PosterModel(
        backgroundColor: const Color(0xFFFFF8E1),
        size: const Size(1080, 1920),
        layers: [
          // Header background
          ShapeLayer(
            shapeType: 'rectangle',
            color: const Color(0xFF8D6E63),
            position: const Offset(0, 0),
            width: 1080,
            height: 350,
          ),

          // Restaurant name
          TextLayer(
            text: "Chef's Kitchen",
            style: const TextStyle(
              fontSize: 68,
              fontWeight: FontWeight.w300,
              color: Color(0xFFFFF8E1),
              letterSpacing: 8,
              fontStyle: FontStyle.italic,
            ),
            align: TextAlign.center,
            position: const Offset(540, 140),
          ),

          // Subtitle
          TextLayer(
            text: 'FINE DINING EXPERIENCE',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Color(0xFFFFF8E1),
              letterSpacing: 5,
            ),
            align: TextAlign.center,
            position: const Offset(540, 240),
          ),

          // Menu section title
          TextLayer(
            text: "Today's Specials",
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.w700,
              color: Color(0xFF5D4037),
            ),
            align: TextAlign.center,
            position: const Offset(540, 450),
          ),

          // Decorative line
          ShapeLayer(
            shapeType: 'rectangle',
            color: const Color(0xFF8D6E63),
            position: const Offset(390, 540),
            width: 300,
            height: 3,
          ),

          // Menu Item 1
          TextLayer(
            text: 'Grilled Salmon',
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w600,
              color: Color(0xFF3E2723),
            ),
            align: TextAlign.left,
            position: const Offset(100, 650),
          ),

          TextLayer(
            text: '\$28',
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w700,
              color: Color(0xFF8D6E63),
            ),
            align: TextAlign.right,
            position: const Offset(980, 650),
          ),

          TextLayer(
            text: 'Fresh Atlantic salmon with herb butter',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              color: Color(0xFF6D4C41),
              fontStyle: FontStyle.italic,
            ),
            align: TextAlign.left,
            position: const Offset(100, 710),
          ),

          // Menu Item 2
          TextLayer(
            text: 'Truffle Risotto',
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w600,
              color: Color(0xFF3E2723),
            ),
            align: TextAlign.left,
            position: const Offset(100, 820),
          ),

          TextLayer(
            text: '\$26',
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w700,
              color: Color(0xFF8D6E63),
            ),
            align: TextAlign.right,
            position: const Offset(980, 820),
          ),

          TextLayer(
            text: 'Creamy arborio rice with black truffles',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              color: Color(0xFF6D4C41),
              fontStyle: FontStyle.italic,
            ),
            align: TextAlign.left,
            position: const Offset(100, 880),
          ),

          // Menu Item 3
          TextLayer(
            text: 'Wagyu Steak',
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w600,
              color: Color(0xFF3E2723),
            ),
            align: TextAlign.left,
            position: const Offset(100, 990),
          ),

          TextLayer(
            text: '\$45',
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w700,
              color: Color(0xFF8D6E63),
            ),
            align: TextAlign.right,
            position: const Offset(980, 990),
          ),

          TextLayer(
            text: 'Premium A5 wagyu with seasonal vegetables',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              color: Color(0xFF6D4C41),
              fontStyle: FontStyle.italic,
            ),
            align: TextAlign.left,
            position: const Offset(100, 1050),
          ),

          // Decorative element
          ShapeLayer(
            shapeType: 'circle',
            color: Color.fromRGBO(141, 110, 99, 0.1),
            position: const Offset(800, 1400),
            width: 400,
            height: 400,
          ),

          // Footer
          TextLayer(
            text: 'Reservations: (555) 123-4567',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: Color(0xFF5D4037),
            ),
            align: TextAlign.center,
            position: const Offset(540, 1750),
          ),
        ],
      ),
    );
  }

  /// Real Estate Flyer - Property listing
  static PosterTemplate _createRealEstateFlyer() {
    return PosterTemplate(
      metadata: const TemplateMetadata(
        name: 'Luxury Property',
        description: 'Professional real estate listing',
        category: TemplateCategory.realEstate,
        tags: ['realestate', 'property', 'house', 'luxury'],
      ),
      poster: PosterModel(
        backgroundColor: Colors.white,
        size: const Size(1080, 1920),
        layers: [
          // Price badge background
          ShapeLayer(
            shapeType: 'rectangle',
            color: const Color(0xFF2C3E50),
            position: const Offset(60, 60),
            width: 420,
            height: 140,
          ),

          TextLayer(
            text: '\$1,250,000',
            style: const TextStyle(
              fontSize: 52,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
            align: TextAlign.center,
            position: const Offset(270, 105),
          ),

          // Property title
          TextLayer(
            text: 'Modern Luxury\nVilla',
            style: const TextStyle(
              fontSize: 68,
              fontWeight: FontWeight.w900,
              color: Color(0xFF2C3E50),
              height: 1.1,
            ),
            align: TextAlign.left,
            position: const Offset(60, 800),
          ),

          // Location
          TextLayer(
            text: 'Beverly Hills, CA',
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w500,
              color: Color(0xFF95A5A6),
            ),
            align: TextAlign.left,
            position: const Offset(60, 1050),
          ),

          // Features section background
          ShapeLayer(
            shapeType: 'rectangle',
            color: const Color(0xFFF8F9FA),
            position: const Offset(0, 1200),
            width: 1080,
            height: 350,
          ),

          // Feature 1 - Bedrooms
          TextLayer(
            text: '5',
            style: const TextStyle(
              fontSize: 56,
              fontWeight: FontWeight.w900,
              color: Color(0xFF3498DB),
            ),
            align: TextAlign.center,
            position: const Offset(180, 1300),
          ),

          TextLayer(
            text: 'Bedrooms',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF7F8C8D),
            ),
            align: TextAlign.center,
            position: const Offset(180, 1390),
          ),

          // Feature 2 - Bathrooms
          TextLayer(
            text: '4',
            style: const TextStyle(
              fontSize: 56,
              fontWeight: FontWeight.w900,
              color: Color(0xFF3498DB),
            ),
            align: TextAlign.center,
            position: const Offset(540, 1300),
          ),

          TextLayer(
            text: 'Bathrooms',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF7F8C8D),
            ),
            align: TextAlign.center,
            position: const Offset(540, 1390),
          ),

          // Feature 3 - Sq Ft
          TextLayer(
            text: '4,500',
            style: const TextStyle(
              fontSize: 56,
              fontWeight: FontWeight.w900,
              color: Color(0xFF3498DB),
            ),
            align: TextAlign.center,
            position: const Offset(900, 1300),
          ),

          TextLayer(
            text: 'Sq Ft',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF7F8C8D),
            ),
            align: TextAlign.center,
            position: const Offset(900, 1390),
          ),

          // Contact CTA background
          ShapeLayer(
            shapeType: 'rectangle',
            color: const Color(0xFF3498DB),
            borderRadius: 35,
            position: const Offset(140, 1650),
            width: 800,
            height: 100,
          ),

          TextLayer(
            text: 'SCHEDULE A VIEWING',
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: 3,
            ),
            align: TextAlign.center,
            position: const Offset(540, 1685),
          ),

          // Agent info
          TextLayer(
            text: 'Contact: Sarah Johnson | (555) 987-6543',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w500,
              color: Color(0xFF7F8C8D),
            ),
            align: TextAlign.center,
            position: const Offset(540, 1830),
          ),
        ],
      ),
    );
  }

  // Additional templates (Business Card, Quote, Sale, Wedding, Concert)
  static PosterTemplate _createBusinessCard() {
    return PosterTemplate(
      metadata: const TemplateMetadata(
        name: 'Business Card',
        description: 'Professional business card design',
        category: TemplateCategory.business,
      ),
      poster: PosterModel(
        backgroundColor: const Color(0xFF1E272E),
        size: const Size(1080, 1080),
        layers: [
          // Accent stripe
          ShapeLayer(
            shapeType: 'rectangle',
            color: const Color(0xFF00D2FF),
            position: const Offset(0, 0),
            width: 1080,
            height: 20,
          ),

          TextLayer(
            text: 'JOHN DOE',
            style: const TextStyle(
              fontSize: 72,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: 8,
            ),
            align: TextAlign.center,
            position: const Offset(540, 450),
          ),

          TextLayer(
            text: 'Creative Director',
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w400,
              color: Color(0xFF00D2FF),
              letterSpacing: 4,
            ),
            align: TextAlign.center,
            position: const Offset(540, 560),
          ),

          TextLayer(
            text: 'john@example.com | +1 234 567 8900',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
            align: TextAlign.center,
            position: const Offset(540, 680),
          ),
        ],
      ),
    );
  }

  static PosterTemplate _createQuotePost() {
    return PosterTemplate(
      metadata: const TemplateMetadata(
        name: 'Inspirational Quote',
        description: 'Motivational quote for social media',
        category: TemplateCategory.socialMedia,
      ),
      poster: PosterModel(
        backgroundColor: const Color(0xFF667EEA),
        size: const Size(1080, 1080),
        layers: [
          // Quote marks background
          TextLayer(
            text: '"',
            style: TextStyle(
              fontSize: 400,
              fontWeight: FontWeight.w900,
              color: Color.fromRGBO(255, 255, 255, 0.1),
            ),
            align: TextAlign.center,
            position: const Offset(540, 200),
          ),

          TextLayer(
            text: 'Believe you can\nand you\'re\nhalfway there',
            style: const TextStyle(
              fontSize: 64,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              height: 1.2,
            ),
            align: TextAlign.center,
            position: const Offset(540, 440),
          ),

          TextLayer(
            text: '— Theodore Roosevelt',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w500,
              color: Color.fromRGBO(255, 255, 255, 0.85),
              fontStyle: FontStyle.italic,
            ),
            align: TextAlign.center,
            position: const Offset(540, 780),
          ),
        ],
      ),
    );
  }

  static PosterTemplate _createSalePromotion() {
    return PosterTemplate(
      metadata: const TemplateMetadata(
        name: 'Flash Sale',
        description: 'Eye-catching sale promotion',
        category: TemplateCategory.business,
      ),
      poster: PosterModel(
        backgroundColor: const Color(0xFFFFFFFF),
        size: const Size(1080, 1080),
        layers: [
          // Red accent backgrounds
          ShapeLayer(
            shapeType: 'circle',
            color: Color.fromRGBO(255, 56, 56, 0.15),
            position: const Offset(100, 100),
            width: 400,
            height: 400,
          ),

          ShapeLayer(
            shapeType: 'circle',
            color: Color.fromRGBO(255, 56, 56, 0.15),
            position: const Offset(600, 600),
            width: 500,
            height: 500,
          ),

          TextLayer(
            text: 'FLASH',
            style: const TextStyle(
              fontSize: 120,
              fontWeight: FontWeight.w900,
              color: Color(0xFFFF3838),
              letterSpacing: 15,
            ),
            align: TextAlign.center,
            position: const Offset(540, 300),
          ),

          TextLayer(
            text: 'SALE',
            style: const TextStyle(
              fontSize: 140,
              fontWeight: FontWeight.w900,
              color: Color(0xFF2C3E50),
              letterSpacing: 15,
            ),
            align: TextAlign.center,
            position: const Offset(540, 450),
          ),

          // Discount circle
          ShapeLayer(
            shapeType: 'circle',
            color: const Color(0xFFFF3838),
            position: const Offset(390, 620),
            width: 300,
            height: 300,
          ),

          TextLayer(
            text: '70%\nOFF',
            style: const TextStyle(
              fontSize: 68,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              height: 1.0,
            ),
            align: TextAlign.center,
            position: const Offset(540, 730),
          ),
        ],
      ),
    );
  }

  static PosterTemplate _createWeddingInvitation() {
    return PosterTemplate(
      metadata: const TemplateMetadata(
        name: 'Wedding Invitation',
        description: 'Elegant wedding save the date',
        category: TemplateCategory.events,
      ),
      poster: PosterModel(
        backgroundColor: const Color(0xFFFFF5F5),
        size: const Size(1080, 1350),
        layers: [
          // Decorative border
          ShapeLayer(
            shapeType: 'rectangle',
            color: Color.fromRGBO(212, 175, 55, 0.3),
            position: const Offset(80, 80),
            width: 920,
            height: 1190,
            borderRadius: 20,
          ),

          TextLayer(
            text: 'Save the Date',
            style: const TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.w300,
              color: Color(0xFFD4AF37),
              letterSpacing: 6,
              fontStyle: FontStyle.italic,
            ),
            align: TextAlign.center,
            position: const Offset(540, 180),
          ),

          TextLayer(
            text: 'Emily & James',
            style: const TextStyle(
              fontSize: 76,
              fontWeight: FontWeight.w400,
              color: Color(0xFF4A4A4A),
              fontStyle: FontStyle.italic,
            ),
            align: TextAlign.center,
            position: const Offset(540, 620),
          ),

          ShapeLayer(
            shapeType: 'rectangle',
            color: const Color(0xFFD4AF37),
            position: const Offset(440, 750),
            width: 200,
            height: 2,
          ),

          TextLayer(
            text: 'June 15, 2024',
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w500,
              color: Color(0xFF6A6A6A),
              letterSpacing: 3,
            ),
            align: TextAlign.center,
            position: const Offset(540, 850),
          ),

          TextLayer(
            text: 'The Grand Ballroom',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w400,
              color: Color(0xFF8A8A8A),
            ),
            align: TextAlign.center,
            position: const Offset(540, 980),
          ),
        ],
      ),
    );
  }

  static PosterTemplate _createConcertPoster() {
    return PosterTemplate(
      metadata: const TemplateMetadata(
        name: 'Rock Concert',
        description: 'Energetic concert poster',
        category: TemplateCategory.events,
      ),
      poster: PosterModel(
        backgroundColor: Colors.black,
        size: const Size(1080, 1920),
        layers: [
          // Vibrant accent shapes
          ShapeLayer(
            shapeType: 'circle',
            color: Color.fromRGBO(231, 76, 60, 0.4),
            position: const Offset(200, 300),
            width: 600,
            height: 600,
          ),

          ShapeLayer(
            shapeType: 'circle',
            color: Color.fromRGBO(155, 89, 182, 0.4),
            position: const Offset(400, 800),
            width: 500,
            height: 500,
          ),

          TextLayer(
            text: 'LIVE',
            style: const TextStyle(
              fontSize: 90,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: 20,
            ),
            align: TextAlign.center,
            position: const Offset(540, 200),
          ),

          TextLayer(
            text: 'THE ROCKERS',
            style: const TextStyle(
              fontSize: 100,
              fontWeight: FontWeight.w900,
              color: Color(0xFFE74C3C),
              letterSpacing: 5,
            ),
            align: TextAlign.center,
            position: const Offset(540, 500),
          ),

          TextLayer(
            text: 'WORLD TOUR 2024',
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 8,
            ),
            align: TextAlign.center,
            position: const Offset(540, 640),
          ),

          ShapeLayer(
            shapeType: 'rectangle',
            color: Colors.white,
            position: const Offset(290, 1100),
            width: 500,
            height: 4,
          ),

          TextLayer(
            text: 'MADISON SQUARE GARDEN',
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 4,
            ),
            align: TextAlign.center,
            position: const Offset(540, 1200),
          ),

          TextLayer(
            text: 'AUGUST 20 • 8PM',
            style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w900,
              color: Color(0xFF9B59B6),
              letterSpacing: 3,
            ),
            align: TextAlign.center,
            position: const Offset(540, 1320),
          ),

          ShapeLayer(
            shapeType: 'rectangle',
            color: const Color(0xFFE74C3C),
            borderRadius: 30,
            position: const Offset(290, 1600),
            width: 500,
            height: 90,
          ),

          TextLayer(
            text: 'BUY TICKETS',
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: 4,
            ),
            align: TextAlign.center,
            position: const Offset(540, 1632),
          ),
        ],
      ),
    );
  }
}
