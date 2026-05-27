import 'package:flutter/material.dart';

/// An interactive image viewer that supports pinch-to-zoom, pan,
/// double-tap gestures, and Hero animations.
///
/// Supports both single and multiple images by passing one or more
/// image providers in [imageProviders].
class InteractiveImageViewer extends StatefulWidget {
  final List<ImageProvider> imageProviders;
  final List<String?>? heroTags;
  final int initialPage;

  final double minScale;
  final double maxScale;
  final Color backgroundColor;
  final Axis scrollDirection;

  const InteractiveImageViewer({
    super.key,
    required this.imageProviders,
    this.heroTags,
    this.initialPage = 0,
    this.minScale = 0.5,
    this.maxScale = 4.0,
    this.backgroundColor = Colors.black,  this.scrollDirection = .horizontal,
  });

  @override
  State<InteractiveImageViewer> createState() =>
      _InteractiveImageViewerState();
}

class _InteractiveImageViewerState
    extends State<InteractiveImageViewer> {
  late final PageController _pageController;
  late int _currentPage;
  late final List<String?> _tags;

  @override
  void initState() {
    super.initState();

    _currentPage = widget.initialPage.clamp(
      0,
      widget.imageProviders.length - 1,
    );

    _tags =
        widget.heroTags ??
            List.generate(widget.imageProviders.length, (_) => null);

    _pageController = PageController(initialPage: _currentPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSingleImage = widget.imageProviders.length == 1;

    return Scaffold(
      backgroundColor: widget.backgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            PageView.builder(
              scrollDirection: widget.scrollDirection,
              controller: _pageController,
              itemCount: widget.imageProviders.length,
              onPageChanged: (page) {
                setState(() {
                  _currentPage = page;
                });
              },
              itemBuilder: (context, index) {
                return _ImagePage(
                  imageProvider: widget.imageProviders[index],
                  heroTag: _tags[index],
                  minScale: widget.minScale,
                  maxScale: widget.maxScale,
                );
              },
            ),

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
                      '${_currentPage + 1}/${widget.imageProviders.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),

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
                    padding: EdgeInsets.all(8),
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

class _ImagePageState extends State<_ImagePage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  final TransformationController _transformationController =
  TransformationController();

  late final AnimationController _animationController;

  Animation<Matrix4>? _animation;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    _animationController =
    AnimationController(
      vsync: this,
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
    final currentScale =
    _transformationController.value.getMaxScaleOnAxis();

    final targetScale = currentScale > 1.5 ? 1.0 : 2.5;

    final Matrix4 endMatrix;

    if (targetScale == 1.0) {
      endMatrix = Matrix4.identity();
    } else {
      final size = context.size!;

      final centerX = size.width / 2;
      final centerY = size.height / 2;

      endMatrix = Matrix4.identity()
        ..translateByDouble(centerX, centerY, 0, 1)
        ..scaleByDouble(targetScale, targetScale, 1, 1)
        ..translateByDouble(-centerX, -centerY, 0, 1);
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
    super.build(context);

    Widget imageWidget = Image(
      image: widget.imageProvider,
      fit: BoxFit.contain,
    );

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
        child: Center(
          child: imageWidget,
        ),
      ),
    );
  }
}