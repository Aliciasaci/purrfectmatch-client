import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:purrfectmatch/locale_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var localeProvider = Provider.of<LocaleProvider>(context);
    var currentLocale = localeProvider.locale;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings),
        backgroundColor: Colors.orange[100],
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.orange[100]!, Colors.orange[200]!],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.switchLanguage,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.orange[100]!,
                        ),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: DropdownButtonFormField<Locale>(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          icon: Icon(Icons.language, color: Colors.orange[100]),
                        ),
                        value: currentLocale,
                        items: L10n.all.map((locale) {
                          String flag;
                          switch (locale.languageCode) {
                            case 'en':
                              flag = '🇺🇸 English';
                              break;
                            case 'fr':
                              flag = '🇫🇷 Français';
                              break;
                            default:
                              flag = locale.languageCode;
                          }
                          return DropdownMenuItem<Locale>(
                            value: locale,
                            child: Text(flag),
                          );
                        }).toList(),
                        onChanged: (locale) {
                          if (locale != null) {
                            localeProvider.setLocale(locale);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
