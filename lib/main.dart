import 'package:flutter/material.dart'hide RefreshIndicator, RefreshIndicatorState;
import 'package:pull_to_refresh/pull_to_refresh.dart';
import './router/Routes.dart';

import 'package:provider/provider.dart';
import 'common/model/provider_vital.dart';
import 'common/model/provider_test.dart';
import 'common/model/provider_personal.dart';
import 'common/model/provider_shopCart.dart';
import 'common/model/provider_brand.dart';
import 'common/model/provider_shop.dart';
import 'package:flutter_localizations/flutter_localizations.dart';//国际化
void main() {
  final vital = VitalModel();
  final test = TestModel();
  final personalModel = PersonalModel();
  final shopCartModel = ShopCartModel();
  final personal = PersonalBrand();
  final personalShop = PersonalShop();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: vital),
        ChangeNotifierProvider.value(value: test),
        ChangeNotifierProvider.value(value: personalModel),
        ChangeNotifierProvider.value(value: shopCartModel),
        ChangeNotifierProvider.value(value: personal),
        ChangeNotifierProvider.value(value: personalShop),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return RefreshConfiguration(
        child: MaterialApp(
          locale: const Locale('en'),
          title: '珑梨派',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: "思源", // 统一指定应用的字体。
            primarySwatch: Colors.lime,
          ),
          initialRoute: '/',
          onGenerateRoute: onGenerateRoute,
          localizationsDelegates: [                             //此处
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: [                                   //此处
            const Locale('zh','CH'),
          ],
        )
    );
  }
}


