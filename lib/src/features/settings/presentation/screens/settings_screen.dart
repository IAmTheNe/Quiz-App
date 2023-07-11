import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whizz/src/features/auth/data/bloc/login/login_cubit.dart';
import 'package:whizz/src/features/settings/data/enum/menu_title.dart';
import 'package:whizz/src/features/settings/data/mockup/settings_mockup.dart';
import 'package:whizz/src/features/settings/data/models/menu_setting.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView.builder(
        itemCount: MenuSettingsMockup.settingsList.length,
        itemBuilder: (context, index) {
          final item = MenuSettingsMockup.settingsList[index];
          if (item.menuType == MenuList.toggle) {
            return SwitchListTile(
              value: false,
              onChanged: (val) {},
              title: Text(item.title.title),
              secondary: item.prefixIcon,
            );
          } else {
            return ListTile(
              onTap: () => onTap(context, item.title),
              title: Text(item.title.title),
              leading: item.prefixIcon,
              trailing: const Icon(Icons.arrow_forward_ios),
            );
          }
        },
      ),
    );
  }
}

Future<void>? onTap(BuildContext context, MenuTitle index) {
  switch (index) {
    case MenuTitle.logout:
      return context.read<LoginCubit>().signOut();
    default:
      return null;
  }
}
