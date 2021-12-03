import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:weather_app/app.dart';
import 'package:weather_app/features/weather/presentation/pages/home_page.dart';
import 'package:weather_app/features/weather/presentation/widgets/custom_bottom_sheet.dart';
import 'package:weather_app/main.dart' as app;

class HomePageObject {
  final WidgetTester tester;

  HomePageObject(this.tester);

  HomePageState get state => tester.state(find.byType(HomePage));

  Future<void> refreshWeather() async {
    await _dragFinder(find.byType(RefreshIndicator), const Offset(0, 10000));
  }

  Future<void> expandBottomSheet() async {
    await _dragBottomSheet(const Offset(0, -10000));
  }

  Future<void> collapseBottomSheet() async {
    await _dragBottomSheet(const Offset(0, 10000));
  }

  Future<void> _dragBottomSheet(Offset offset) async {
    await _dragFinder(find.byType(CustomBottomSheet), offset);
  }

  Future<void> _dragFinder(Finder finder, Offset offset) async {
    await tester.drag(finder, offset);
    await tester.pumpAndSettle();
  }
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('HomePage integration tests.', () {
    tearDown(() async {
      await getIt.reset();
    });
    testWidgets(
      "Test home screen base composition and swipe working.",
      (WidgetTester tester) async {
        app.main();
        await tester.pumpAndSettle();

        final homePage = HomePageObject(tester);

        expect(homePage.state.bottomSheetExpanded, equals(false));
        expect(find.text('Прогноз на неделю'), findsOneWidget);
        expect(find.text('Санкт-Петербург'), findsNothing);

        await homePage.expandBottomSheet();

        expect(homePage.state.bottomSheetExpanded, equals(true));
        expect(find.text('Прогноз на неделю'), findsNothing);
        expect(find.text('Санкт-Петербург'), findsOneWidget);

        await homePage.collapseBottomSheet();

        expect(homePage.state.bottomSheetExpanded, equals(false));
        expect(find.text('Прогноз на неделю'), findsOneWidget);
        expect(find.text('Санкт-Петербург'), findsNothing);
      },
    );

    testWidgets(
      "Test home screen refresh.",
      (WidgetTester tester) async {
        app.main();
        await tester.pumpAndSettle();

        final homePage = HomePageObject(tester);
        await homePage.refreshWeather();
      },
    );
  });
}
