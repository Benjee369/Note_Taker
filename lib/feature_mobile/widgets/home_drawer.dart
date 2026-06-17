import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import '../../common/providers/system_settings_provider.dart';
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
    final systemSettings = context.watch<SystemSettingsProvider>();

    return Drawer(
      child: ListView(
        padding: EdgeInsets.all(10),
        children: [
          TextWidget(
            text: Strings.settings,
            size: 20,
            fontWeight: FontWeight.bold,
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Row(
              children: [
                AnimatedSwitcher(
                  duration: Duration(milliseconds: 50),
                  child: Icon(
                    systemSettings.systemSettingsModel.theme
                        ? Icons.wb_sunny_rounded
                        : Icons.mode_night_rounded,
                  ),
                ),
                gapW4,
                TextWidget(text: Strings.darkMode),
                Spacer(),
                Switch(
                  value: !systemSettings.systemSettingsModel.theme,
                  onChanged: (_) {
                    systemSettings.toggleTheme();
                  },
                ),
              ],
            ),
          ),
          Divider(),
          ListTile(
            onTap: () => systemSettings.toggleViewMode(),
            contentPadding: EdgeInsets.zero,
            title: Row(
              children: [
                Icon(
                  !systemSettings.systemSettingsModel.viewMode
                      ? Icons.grid_view_rounded
                      : Icons.format_list_bulleted_rounded,
                ),
                gapW4,
                TextWidget(
                  text: !systemSettings.systemSettingsModel.viewMode
                      ? Strings.gridView
                      : Strings.listView,
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
