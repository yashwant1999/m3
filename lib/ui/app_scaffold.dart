import 'package:flutter/material.dart';
import 'package:m3/ui/common/scroll_behaviour.dart';

/// Common Scaffold for all screen with default behaviour
/// 1. scroll behaviour :- such as `bouncingScrollPhysics()`,
///
class ComicScaffold extends StatelessWidget {
  const ComicScaffold({
    super.key,
    required this.body,
    required this.title,
    this.bottomNavigationBar,
    this.isExpandedAppBar = true,
  });
  // content
  final Widget body;
  final String title;

  final bool isExpandedAppBar;
  final Widget? bottomNavigationBar;
  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: MyScrollBehavior(),
      child: Scaffold(
        bottomNavigationBar: bottomNavigationBar,
        body: NestedScrollView(
            physics: const BouncingScrollPhysics(),
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return [
                _buildSliverAppBar(innerBoxIsScrolled),
              ];
            },
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: body,
            )),
      ),
    );
  }

  SliverAppBar _buildSliverAppBar(bool innerBoxIsScrolled) {
    return SliverAppBar(
      title: Text(title),
      // expandedHeight: 120,
      pinned: true,
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.search),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.volume_up_rounded),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.settings),
        )
      ],
      // flexibleSpace: FlexibleSpaceBar(
      //   // expandedTitleScale: 2.0,
      //   titlePadding: const EdgeInsetsDirectional.only(
      //     start: 22.0,
      //     bottom: 16.0,
      //   ),
      //   title: Text(
      //     title,
      //     maxLines: 1,
      //     textAlign: TextAlign.center,
      //     style: const TextStyle(
      //       fontWeight: FontWeight.w500,
      //       // fontSize: 18.0,
      //       overflow: TextOverflow.ellipsis,
      //     ),
      //   ),
      // ),
    );
  }
}
