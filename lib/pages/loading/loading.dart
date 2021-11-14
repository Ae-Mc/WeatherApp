import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/data/providers/providers.dart';
import 'package:weather_app/data/providers/weather_provider.dart';
import 'package:weather_app/data/storage/storage.dart';
import 'package:weather_app/features/settings/data/datasources/settings_local_data_source_impl.dart';
import 'package:weather_app/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:weather_app/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:weather_app/router/router.gr.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key: key);

  Future<void> init(BuildContext context) async {
    BlocProvider.of<SettingsBloc>(context).add(
      Init(
        SettingsRepositoryImpl(
          localDataSource: SettingsLocalDataSourceImpl(
            await SharedPreferences.getInstance(),
          ),
        ),
      ),
    );

    var router = AutoRouter.of(context);
    var weatherProvider = context.read<WeatherProvider>();
    var settingsProvider = context.read<SettingsProvider>();
    await Future.wait([
      Storage.initialize().then((value) => weatherProvider.initialize()),
      initializeDateFormatting('ru_RU'),
    ]);
    settingsProvider.init();
    router.replace(const HomeRoute());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: init(context)..onError((error, stackTrace) => throw error!),
          builder: (context, snapshot) {
            return SizedBox.expand(
              child: Column(
                children: [
                  const Spacer(),
                  Text('Weather', style: Theme.of(context).textTheme.headline2),
                  const Spacer(),
                  CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                  const Spacer(),
                  const Spacer(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
