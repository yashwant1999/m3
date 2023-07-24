import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:m3/ui/app_scaffold.dart';

class RefreshRateSetting extends StatefulWidget {
  const RefreshRateSetting({super.key});

  @override
  _RefreshRateSettingState createState() => _RefreshRateSettingState();
}

class _RefreshRateSettingState extends State<RefreshRateSetting> {
  List<DisplayMode> modes = <DisplayMode>[];
  DisplayMode? active;
  DisplayMode? preferred;

  final ValueNotifier<int> page = ValueNotifier<int>(0);
  late final PageController controller = PageController()
    ..addListener(() {
      page.value = controller.page!.round();
    });

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      fetchAll();
    });
  }

  Future<void> fetchAll() async {
    try {
      modes = await FlutterDisplayMode.supported;
      modes.forEach(print);

      /// On OnePlus 7 Pro:
      /// #1 1080x2340 @ 60Hz
      /// #2 1080x2340 @ 90Hz
      /// #3 1440x3120 @ 90Hz
      /// #4 1440x3120 @ 60Hz

      /// On OnePlus 8 Pro:
      /// #1 1080x2376 @ 60Hz
      /// #2 1440x3168 @ 120Hz
      /// #3 1440x3168 @ 60Hz
      /// #4 1080x2376 @ 120Hz
    } on PlatformException catch (e) {
      print(e);

      /// e.code =>
      /// noAPI - No API support. Only Marshmallow and above.
      /// noActivity - Activity is not available. Probably app is in background
    }

    preferred = await FlutterDisplayMode.preferred;

    active = await FlutterDisplayMode.active;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ComicScaffold(
      title: 'Refresh Rate',
      body: _buildScaffoldBody(context),
    );
  }

  Widget _buildScaffoldBody(BuildContext context) {
    return PageView(
      controller: controller,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (modes.isEmpty) const Text('Nothing here'),
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: modes.length,
                itemBuilder: (_, int i) {
                  final DisplayMode mode = modes[i];
                  return SizedBox(
                    height: 100,
                    child: Card(
                      child: Row(
                        children: <Widget>[
                          Radio<DisplayMode>(
                            value: mode,
                            groupValue: preferred,
                            onChanged: (DisplayMode? newMode) async {
                              await FlutterDisplayMode.setPreferredMode(
                                  newMode!);
                              await Future<dynamic>.delayed(
                                const Duration(milliseconds: 100),
                              );
                              await fetchAll();
                              setState(() {});
                            },
                          ),
                          if (mode == DisplayMode.auto)
                            const Text('Automatic')
                          else
                            Text(mode.toString()),
                          if (mode == active) const Text(' [ACTIVE]'),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            if (modes.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.onSecondary),
                      onPressed: () async {
                        await FlutterDisplayMode.setHighRefreshRate();
                        await Future<dynamic>.delayed(
                          const Duration(milliseconds: 100),
                        );
                        await fetchAll();
                        setState(() {});
                      },
                      child: const Text('Highest Hz'),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.onSecondary),
                      onPressed: () async {
                        await FlutterDisplayMode.setLowRefreshRate();
                        await Future<dynamic>.delayed(
                          const Duration(milliseconds: 100),
                        );
                        await fetchAll();
                        setState(() {});
                      },
                      child: const Text('Lowest Hz'),
                    ),
                  ),
                ],
              ),
            const SizedBox(
              height: 10,
            )
          ],
        ),
        ListView.separated(
          physics: const BouncingScrollPhysics(),
          itemCount: 10,
          separatorBuilder: (context, index) => const SizedBox(
            height: 10,
          ),
          padding: EdgeInsets.zero,
          itemBuilder: (BuildContext _, int i) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                  'https://helpx.adobe.com/content/dam/help/en/photoshop/using/convert-color-image-black-white/jcr_content/main-pars/before_and_after/image-before/Landscape-Color.jpg'),
            );
          },
        ),
      ],
    );
  }
}
