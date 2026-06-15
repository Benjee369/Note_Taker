import 'package:flutter/material.dart';
import 'package:notes/feature_home/providers/view_mode_provider.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

import '../../common/providers/theme_provider.dart';
import '../../common/widgets/text_widget.dart';
import '../../constants/app_sizes.dart';
import '../../constants/strings.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer({super.key});

  @override
  State<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  @override
  Drawer build(BuildContext context) {
    final viewProvider = context.watch<ViewModeProvider>();
    // final view = viewProvider.getViewMode();

    return Drawer(
      child: ListView(
        padding: EdgeInsets.all(10),
        children: [
          TextWidget(
            text: 'Settings',
            size: 20,
            fontWeight: FontWeight.bold,
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Row(
              children: [
                Icon(Icons.mode_night_rounded),
                gapW4,
                TextWidget(text: 'Dark mode'),
                Spacer(),
                Switch(
                  value: context.watch<ThemeProvider>().themeMode ==
                      ThemeMode.dark,
                  onChanged: (_) {
                    context.read<ThemeProvider>().toggleTheme();
                  },
                ),
              ],
            ),
          ),
          Divider(),
          ListTile(
            onTap: () => viewProvider.toggleViewMode(),
            contentPadding: EdgeInsets.zero,
            title: Row(
              children: [
                Icon(
                  !viewProvider.viewMode
                      ? Icons.grid_view_rounded
                      : Icons.format_list_bulleted_rounded,
                ),
                gapW4,
                TextWidget(
                  text: !viewProvider.viewMode ? 'Grid view' : 'List view',
                ),
              ],
            ),
          ),
          Divider(),
          FutureBuilder<PackageInfo>(
            future: PackageInfo.fromPlatform(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextWidget(
                      text: Strings.noteTaker,
                      size: 13,
                    ),
                    gapW4,
                    TextWidget(
                      text: 'v ${snapshot.data!.version}',
                      size: 13,
                    ),
                  ],
                );
              }
              return const TextWidget(
                text: 'Checking version...',
                size: 13,
              );
            },
          ),
        ],
      ),
    );
  }
}
