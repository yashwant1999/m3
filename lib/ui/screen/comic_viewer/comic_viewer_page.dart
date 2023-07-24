import 'package:flutter/material.dart';
import 'package:m3/ui/common/control/app_image.dart';
import 'package:vector_math/vector_math_64.dart' show Quad, Vector3;

class ComicViewer extends StatefulWidget {
  const ComicViewer({Key? key}) : super(key: key);

  static const String routeName = '/iv-builder';

  @override
  _ComicViewerState createState() => _ComicViewerState();
}

class _ComicViewerState extends State<ComicViewer> {
  final TransformationController _transformationController =
      TransformationController();

  // static const double _cellWidth = 200.0;
  static const double _cellHeight = 280.0;
  static const int _rowCount = 100;

  // Returns true iff the given cell is currently visible. Caches viewport
  // calculations.
  Quad? _cachedViewport;
  late int _firstVisibleRow;
  late int _lastVisibleRow;

  bool _isCellVisible(int row, Quad viewport) {
    if (viewport != _cachedViewport) {
      final Rect aabb = axisAlignedBoundingBox(viewport);
      _cachedViewport = viewport;
      _firstVisibleRow = (aabb.top / _cellHeight).floor();
      _lastVisibleRow = (aabb.bottom / _cellHeight).ceil();
    }
    return row >= _firstVisibleRow && row < _lastVisibleRow;
  }

  void _onChangeTransformation() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _transformationController.addListener(_onChangeTransformation);
  }

  @override
  void dispose() {
    _transformationController.removeListener(_onChangeTransformation);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // removePadding: true,
      // title: 'Comics',
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Comics',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return InteractiveViewer.builder(
                panEnabled: true,

                scaleEnabled: true,
                // constrained: false,
                // minScale: 0.5,
                // maxScale: 5.0,
                // boundaryMargin: const EdgeInsets.all(double.infinity),
                transformationController: _transformationController,
                builder: (BuildContext context, Quad viewport) {
                  return Column(
                    children: <Widget>[
                      for (int row = 0; row < _rowCount; row++)
                        _isCellVisible(row, viewport)
                            ? SizedBox(
                                height: _cellHeight,
                                width: MediaQuery.sizeOf(context).width,
                                child: MyWidget(
                                  index: row,
                                ),
                              )
                            : Container(height: _cellHeight),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class MyWidget extends StatelessWidget {
  final int index;
  const MyWidget({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('how many times $index');
    return const AppImage(
        image: NetworkImage(
            'https://upload.wikimedia.org/wikipedia/commons/b/b6/Image_created_with_a_mobile_phone.png'));
  }
}

Quad? _cachedViewport;
late int _firstVisibleRow;
late int _lastVisibleRow;

Rect axisAlignedBoundingBox(Quad quad) {
  double? xMin;
  double? xMax;
  double? yMin;
  double? yMax;
  for (final Vector3 point in <Vector3>[
    quad.point0,
    quad.point1,
    quad.point2,
    quad.point3
  ]) {
    if (xMin == null || point.x < xMin) {
      xMin = point.x;
    }
    if (xMax == null || point.x > xMax) {
      xMax = point.x;
    }
    if (yMin == null || point.y < yMin) {
      yMin = point.y;
    }
    if (yMax == null || point.y > yMax) {
      yMax = point.y;
    }
  }
  return Rect.fromLTRB(xMin!, yMin!, xMax!, yMax!);
}
