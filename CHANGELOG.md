## 1.4.2
* **Documentation**: Updated installation instructions in README to reflect the correct version.
* **Maintenance**: Verified platform support and package details for publishing.

## 1.4.1
* **Pub.dev Analysis**: Fixed static analysis formatting issues to improve package score.
* **Metadata**: Restored repository URLs to meet pub.dev scoring requirements (ensure repo is public).

## 1.4.0
* **WASM Compatibility**: Migrated from `universal_html` and `universal_io` to `package:web` and conditional imports to support Dart WASM runtime.
* **Metadata**: Updated repository and homepage URLs.

## 1.3.8
* **Maintenance**: Internal cleanup and verification for publishing stability.
* **Dependencies**: Verified compatibility with latest Flutter and Dart versions.

## 1.3.7
* **Mobile UX**: Significantly improved mobile editing experience by maximizing workspace area and preventing layers from being lost off-screen.
* **Documentation**: Completely overhauled README with detailed features, usage guides, and visual placeholders.
* **Metadata**: Added package topics for better discovery.
* **Visuals**: Added drop shadows and better contrast for the editor workspace.

## 1.3.6
* **Code Quality**: Fixed deprecation warnings by replacing deprecated `Share.shareXFiles` with `SharePlus.instance.share()`.
* **Dependency Update**: Updated `share_plus` minimum version to `>=11.0.0 <13.0.0` to use the new non-deprecated API.
* **Static Analysis**: Achieved 50/50 points on static analysis with zero errors, warnings, lints, or formatting issues.

## 1.3.5
* **Pub.dev Optimization**: Achieved 160/160 points on pub.dev scoring.
* **Dependency Update**: Updated `share_plus` constraint to `>=10.0.0 <13.0.0` to support all stable versions including 11.0.0 and 12.0.1.
* **Platform Declaration**: Added explicit platform support declaration for Android, iOS, Linux, macOS, Windows, and Web.
* **Code Quality**: Fixed Dart formatter issues in `export_service.dart` to ensure zero static analysis warnings.

## 1.3.4
* **Web Support**: Added full support for Web platform by replacing `dart:io` dependencies with `universal_io` and `universal_html`.
* **Cross-Platform Sharing**: Replaced `gal` package with `share_plus` to support image sharing/saving on all platforms (Android, iOS, Web, Windows, macOS, Linux).
* **Bug Fixes**: Fixed image loading issues on Web by correctly handling network images and file blobs.

## 1.3.3
* Fixed static analysis formatting issues in `PosterCanvas` to comply with Dart formatter.

## 1.3.2
* Fixed deprecation warnings for `translate` and `scale` methods in `PosterCanvas`.
* Improved code quality by resolving analysis errors.

## 1.3.1
* Fixed image visibility issue where images were added off-screen on smaller viewports.
* Updated `PosterCanvas` to automatically scale the poster to fit the screen.

## 1.3.0
* **Cross-Platform Support**: Added full support for Web, Windows, macOS, and Linux.
* **Project Structure**: Converted project to a complete Flutter application structure.
* **Web**: Added web entry point and configuration.
* **Desktop**: Added desktop platform runners.

## 1.2.8
* Added support for loading images from raw bytes (`Uint8List`) to improve cross-platform compatibility and reliability.
* Fixed `PosterController` definition issue.
* Improved code quality and formatting.

## 1.2.6
* Fixed persistent image loading issues by adding robust error handling and fallback UI.
* Improved mobile usability by resolving gesture conflicts between layer manipulation and canvas zooming.
* Significantly increased touch target sizes for resize and rotation handles.

## 1.2.5
* Updated export functionality to save images in a specific "poster" folder/album.

## 1.2.4
* Fixed image download issue on mobile by saving to Gallery instead of internal storage.

## 1.2.3
* Improved mobile usability:
  * Added double-tap to edit text layers with a dedicated dialog.
  * Increased touch targets for selection and rotation handles.
  * Fixed keyboard visibility issue when editing text.

## 1.2.2
* Fixed `Asset not found` exception when loading local images on Android.
* Fixed editor visibility issue on mobile by refactoring Toolbar to support horizontal layout.

## 1.2.1
* Fixed static analysis formatting issues.
* Improved code style compliance.

## 1.2.0

**Feature Release - Enhanced Customization & Mobile Support**

### 🚀 New Features
* **Feature Toggles**: Control visibility of tools (`showText`, `showImage`, `showShape`, `showExport`) in `PosterEditor`.
* **Export Callback**: New `onExport` callback to handle image bytes directly.
* **Controller Access**: Pass your own `PosterController` to programmatically manage the editor.
* **Mobile Improvements**: Added `InteractiveViewer` for zoom/pan support on mobile.
* **Drag Support**: Added drag-to-move gesture for layers (in addition to property panel controls).

### 🐛 Bug Fixes
* Fixed `blob:` URL loading error for web images.
* Improved gesture handling on mobile devices.

## 1.1.1
* Fixed static analysis issues and formatting.
* Updated dependencies to latest versions.
* Fixed `deprecated_member_use` warning in `models.dart`.

## 1.1.0

**Advanced Canva-Like Features Release**

### ✨ Advanced Typography Effects
* **Letter Spacing**: Adjustable character spacing (-2.0 to 10.0)
* **Line Height**: Customizable line spacing (0.8 to 3.0)
* **Text Shadows**: Full shadow control with color, blur radius (0-20), and offset
* **Text Stroke/Outline**: Configurable outline with width (0-10) and color
* Real-time UI controls with conditional property panels

### 🎨 Image Filters
* **Brightness**: Adjust image brightness (-1.0 to 1.0)
* **Contrast**: Control image contrast (0.0 to 2.0)
* **Saturation**: Modify color saturation (0.0 to 2.0, grayscale to vibrant)
* **Sepia**: Apply vintage sepia tone effect (0.0 to 1.0)
* Matrix-based filter implementation for optimal performance

### 🔧 Technical Improvements
* Extended `TextLayer` with 8 new typography properties
* Extended `ImageLayer` with 5 filter properties
* Enhanced `PropertyPanel` with advanced effects sections
* Backward compatible serialization with default values
* Zero static analysis errors

### 📱 UI Enhancements
* Conditional UI controls (stroke/shadow pickers appear when active)
* Real-time slider controls for all effects
* Professional property panel organization
* Smooth rendering with chained ColorFilter widgets

## 1.0.0

**Major Release - Professional Canva-Style Editor**

### 🎨 Professional Templates
* Added 10 realistic multi-layered Canva-style templates:
  - Fitness Instagram Post (gradient background, CTA button)
  - Music Festival Flyer (event layout with photo overlay)
  - Product Launch Poster (feature highlights, pricing)
  - Restaurant Menu (elegant design with prices)
  - Real Estate Flyer (property features, contact CTA)
  - Business Card (minimalist professional)
  - Quote Post (inspirational typography)
  - Flash Sale (eye-catching discount design)
  - Wedding Invitation (elegant save the date)
  - Rock Concert Poster (vibrant energetic design)
* Each template includes 5-15 professionally designed layers
* Templates organized by category with search and filtering

### ✨ Advanced Editing Features
* **Interactive Resize Handles**: 8-point resize (4 corners + 4 edges)
* **Rotation Handle**: Green circle handle for layer rotation
* **Visual Selection**: Blue border with shadows on selected layers
* **Lock Indicator**: Visual lock icon for locked layers

### 📊 Comprehensive Property Panel
* Position controls (X, Y coordinates)
* Size controls (Width, Height)
* Rotation slider (0-360°)
* Opacity slider (0-100%)
* Scale slider (10%-300%)
* Text formatting (font size 8-200, weight, 8 colors, alignment)
* Shape customization (8 colors, border radius)
* Layer actions (duplicate, delete, bring to front, send to back, lock)

### 📱 Mobile Optimization
* Fully responsive layouts (mobile < 600px, tablet < 1024px, desktop)
* Bottom navigation bar for mobile
* InteractiveViewer with pinch-to-zoom (0.1x-4.0x)
* Draggable bottom sheet for properties
* Touch-friendly controls (44x44 minimum)
* Adaptive template grid (1/2/3 columns)

### 💾 Working Export System
* Real file downloads (not just previews)
* PNG and JPG format support
* 4 quality levels (Low, Medium, High, Ultra)
* Custom filename input
* Platform-specific implementation (web browser download, mobile/desktop file save)
* Progress indicators and success feedback

### 📸 Device Image Upload
* Camera and gallery support
* Cross-platform compatible
* Proper file handling for local images

### 🛠️ Layer Management
* Duplicate layers with offset
* Delete selected layers
* Bring to front / Send to back
* Lock/unlock layers
* Layer ordering controls
* Selected layer getter

### 🎯 Enhanced Controller
* `resizeLayer()`, `rotateLayer()`, `updateLayer()`
* `duplicateLayer()`, `lockLayer()`
* `bringToFront()`, `sendToBack()`
* `updateLayerOpacity()`, `scaleLayer()`
* `addImageFromFile()`
* `selectedLayer` getter

### 📐 Data Model Enhancements
* Added `opacity`, `isLocked`, `width`, `height` to all layer types
* Proper serialization/deserialization
* Support for explicit layer sizing

### 🎨 UI/UX Improvements
* Professional property panel with sliders and controls
* Responsive export dialog
* Mobile menu in app bar
* Floating action button on mobile
* Better visual feedback throughout

## 0.0.4
* Fixed `Unsupported operation` runtime error in `PosterController`.
* Added missing `TemplatePage` and `AutoPosterPage` classes.
* Fixed image export functionality.

## 0.0.3
* Fixed linter hints and deprecation warnings.

## 0.0.2
* Polished code and documentation.
* Fixed analysis issues and deprecations.
* Renamed package to `tss_poster`.

## 0.0.1

* Initial release.
* Added Poster Editor with drag & drop support.
* Added Auto-Poster generator.
* Added Template support.
* Added Export to image functionality.
