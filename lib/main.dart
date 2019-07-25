import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'allTranslations.dart';

void main() async {
  // Initializes the translation module
  await allTranslations.init();

  // start the application
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    // Initializes a callback should something need
    // to be done when the language is changed
    allTranslations.onLocaleChangedCallback = _onLocaleChanged;
  }

  // If there is anything special to do when the user changes the language
  _onLocaleChanged() async {
    // do anything you need to do if the language changes
    print('Language has been changed to: ${allTranslations.currentLanguage}');
  }

  // Main initialization
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      // Tells the system which languages are supported
      supportedLocales: allTranslations.supportedLocales(),

      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final String language = allTranslations.currentLanguage;
    final String buttonText = language == 'pt' ? '=> English' : '=> Portuguese';

    return Scaffold(
      appBar: AppBar(
        title: Text(allTranslations.text('title')),
      ),
      body: Container(
          width: double.infinity,
          child: Column(
            children: <Widget>[
              RaisedButton(
                child: Text(buttonText),
                onPressed: () async {
                  await allTranslations.setNewLanguage(language == 'pt' ? 'en' : 'pt');
                  setState(() {});
                },
              ),
              Text(allTranslations.text('main_body')),
            ],
          )),
    );
  }
}
