import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../locale_provider.dart';

class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var localeProvider = Provider.of<LocaleProvider>(context);

    return GestureDetector(
      onTap: () {
        if (localeProvider.locale == const Locale('en')) {
          localeProvider.setLocale(const Locale('fr'));
        } else {
          localeProvider.setLocale(const Locale('en'));
        }
      },
      child: CircleAvatar(
        radius: 15,
        backgroundImage: AssetImage(
          localeProvider.locale == const Locale('en')
              ? 'assets/images/flag_uk.png'
              : 'assets/images/flag_fr.png',
        ),
      ),
    );
  }
}
