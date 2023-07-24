import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:m3/routing.dart';
import 'package:m3/ui/app_scaffold.dart';
import 'package:m3/ui/screen/comic_viewer/comic_viewer_page.dart';

class ComicGridView extends StatefulWidget {
  const ComicGridView({super.key});

  @override
  State<ComicGridView> createState() => _ComicGridViewState();
}

class _ComicGridViewState extends State<ComicGridView> {
  @override
  Widget build(BuildContext context) {
    return ComicScaffold(
      title: 'Comic',
      body: MasonryGridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              CustomNavigation.push(
                context,
                page: const ComicViewer(),
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                'https://imgv3.fotor.com/images/blog-cover-image/part-blurry-image.jpg',
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}
