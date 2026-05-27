import 'package:flutter/material.dart';

/// An interactive image viewer that supports pinch-to-zoom, pan, and double-tap gestures
/// with Hero animation support for smooth transitions.
///
/// Can display a single image or multiple images with page navigation.
class InteractiveImageViewer extends StatefulWidget {
  // Legacy single image constructor
  final ImageProvider? imageProvider;
  final String? heroTag;

  // New multiple images support
  final List<ImageProvider>? imageProviders;
  final List<String>? heroTags;
  final int initialPage;

  // Common properties
  final double minScale;
  final double maxScale;
  final Color backgroundColor;

  /// Constructor for single image (maintains backward compatibility)
  const InteractiveImageViewer({
    super.key,
    required this.imageProvider,
    required this.heroTag,
    this.minScale = 0.5,
    this.maxScale = 4.0,
    this.backgroundColor = Colors.black,
  }) : imageProviders = null,
       heroTags = null,
       initialPage = 0;

  /// Constructor for multiple images
  const InteractiveImageViewer.multiple({
    super.key,
    required this.imageProviders,
    this.heroTags,
    this.initialPage = 0,
    this.minScale = 0.5,
    this.maxScale = 4.0,
    this.backgroundColor = Colors.black,
  }) : imageProvider = null,
       heroTag = null;

  @override
  State<InteractiveImageViewer> createState() => _InteractiveImageViewerState();
}

class _InteractiveImageViewerState extends State<InteractiveImageViewer> {
  late PageController _pageController;
  late int _currentPage;
  late List<ImageProvider> _images;
  late List<String?> _tags;

  @override
  void initState() {
    super.initState();

    // Initialize data from either single or multiple image constructor
    if (widget.imageProvider != null) {
      _images = [widget.imageProvider!];
      _tags = [widget.heroTag];
      _currentPage = 0;
    } else {
      _images = widget.imageProviders!;
      _tags = widget.heroTags ?? List.generate(_images.length, (i) => null);
      _currentPage = widget.initialPage.clamp(0, _images.length - 1);
    }

    _pageController = PageController(initialPage: _currentPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSingleImage = _images.length == 1;

    return Scaffold(
      backgroundColor: widget.backgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            // PageView for images
            PageView.builder(
              controller: _pageController,
              itemCount: _images.length,
              onPageChanged: (page) {
                setState(() {
                  _currentPage = page;
                });
              },
              itemBuilder: (context, index) {
                return _ImagePage(
                  imageProvider: _images[index],
                  heroTag: _tags[index],
                  minScale: widget.minScale,
                  maxScale: widget.maxScale,
                );
              },
            ),

            // Page indicator (only show for multiple images)
            if (!isSingleImage)
              Positioned(
                top: 16,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${_currentPage + 1}/${_images.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),

            // Close button
            Positioned(
              top: 16,
              right: 16,
              child: Material(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(20),
                child: InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  borderRadius: BorderRadius.circular(20),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Individual page for each image with zoom/pan functionality
class _ImagePage extends StatefulWidget {
  final ImageProvider imageProvider;
  final String? heroTag;
  final double minScale;
  final double maxScale;

  const _ImagePage({
    required this.imageProvider,
    required this.heroTag,
    required this.minScale,
    required this.maxScale,
  });

  @override
  State<_ImagePage> createState() => _ImagePageState();
}

class _ImagePageState extends State<_ImagePage> with AutomaticKeepAliveClientMixin {
  final TransformationController _transformationController = TransformationController();
  late AnimationController _animationController;
  Animation<Matrix4>? _animation;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(
          vsync: Navigator.of(context),
          duration: const Duration(milliseconds: 300),
        )..addListener(() {
          if (_animation != null) {
            _transformationController.value = _animation!.value;
          }
        });
  }

  @override
  void dispose() {
    _transformationController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _handleDoubleTap() {
    final currentScale = _transformationController.value.getMaxScaleOnAxis();
    final targetScale = currentScale > 1.5 ? 1.0 : 2.5;

    final Matrix4 endMatrix;
    if (targetScale == 1.0) {
      endMatrix = Matrix4.identity();
    } else {
      final context = this.context;
      final size = context.size!;
      final centerX = size.width / 2;
      final centerY = size.height / 2;

      endMatrix = Matrix4.identity()
        ..translate(centerX, centerY)
        ..scale(targetScale)
        ..translate(-centerX, -centerY);
    }

    _animation =
        Matrix4Tween(
          begin: _transformationController.value,
          end: endMatrix,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
          ),
        );

    _animationController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin

    Widget imageWidget = Image(
      image: widget.imageProvider,
      fit: BoxFit.contain,
    );

    // Wrap with Hero only if heroTag is provided
    if (widget.heroTag != null) {
      imageWidget = Hero(
        tag: widget.heroTag!,
        child: imageWidget,
      );
    }

    return GestureDetector(
      onDoubleTap: _handleDoubleTap,
      child: InteractiveViewer(
        transformationController: _transformationController,
        minScale: widget.minScale,
        maxScale: widget.maxScale,
        child: Center(child: imageWidget),
      ),
    );
  }
}
