import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:weather_app/core/network/network_info.dart';
import 'package:weather_app/features/search/data/datasources/search_remote_data_source_impl.dart';
import 'package:weather_app/features/search/data/repositories/search_repository_impl.dart';
import 'package:weather_app/features/search/domain/entities/place.dart';
import 'package:weather_app/features/search/presentation/bloc/search_bloc.dart';
import 'package:weather_app/features/settings/presentation/bloc/settings_bloc.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        // TODO: use dependency injection for repository and api creation
        return SearchBloc()
          ..add(
            SearchInitialized(
              SearchRepositoryImpl(
                remoteDataSource: SearchRemoteDataSourceImpl(
                  api: GeoNamesApi(Dio()),
                ),
                networkInfo: NetworkInfoImpl(InternetConnectionChecker()),
              ),
            ),
          );
      },
      child: const _SearchPage(),
    );
  }
}

class _SearchPage extends StatefulWidget {
  const _SearchPage({Key? key}) : super(key: key);

  @override
  State<_SearchPage> createState() => __SearchPageState();
}

class __SearchPageState extends State<_SearchPage> {
  final _searchController = TextEditingController();
  var _clearButtonShowed = false;

  @override
  void initState() {
    _searchController.addListener(() {
      if (_searchController.text.isNotEmpty != _clearButtonShowed) {
        setState(() {
          _clearButtonShowed = _searchController.text.isNotEmpty;
        });
      }
      if (_searchController.text.isEmpty) {
        BlocProvider.of<SearchBloc>(context).add(const SearchCleared());
      } else {
        BlocProvider.of<SearchBloc>(context)
            .add(SearchSearched(_searchController.text));
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const Pad(top: 32, horizontal: 20),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.arrow_back_ios_rounded,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      style: Theme.of(context).textTheme.overline,
                      cursorColor: Theme.of(context).colorScheme.onBackground,
                      decoration: InputDecoration(
                        hintText: "Введите название города...",
                        suffixIcon: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: _clearButtonShowed
                              ? InkWell(
                                  customBorder: const StadiumBorder(),
                                  onTap: () => _searchController.clear(),
                                  child: Icon(
                                    CupertinoIcons.clear_circled_solid,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
                                  ),
                                )
                              : const SizedBox(),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 24),
              Expanded(
                child: BlocBuilder<SearchBloc, SearchState>(
                  builder: (context, state) {
                    if (state is SearchSuccess) {
                      return state.places.isEmpty
                          ? const Text('Ничего не найдено')
                          : ListView.separated(
                              itemCount: state.places.length,
                              itemBuilder: (context, index) => cityRow(
                                  context, state.places.elementAt(index)),
                              separatorBuilder: (_, __) => const Divider(
                                height: 1,
                              ),
                            );
                    } else if (state is SearchFailure) {
                      return Text(
                        state.message,
                        style: TextStyle(color: Colors.red[700]),
                      );
                    } else if (state is SearchInProgress) {
                      return const Align(
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return const Text(
                        'Unexpected error',
                        style: TextStyle(color: Colors.red),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget cityRow(BuildContext context, Place place) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      buildWhen: (_, newState) => newState is! SettingsInProgress,
      builder: (context, state) {
        if (state is SettingsSuccess) {
          final isFavorite = state.settings.favorites.contains(place);
          final bloc = BlocProvider.of<SettingsBloc>(context);

          return ListTile(
            dense: true,
            onTap: () async {
              BlocProvider.of<SettingsBloc>(context)
                  .add(SettingsActivePlaceSet(place));
              // await context.read<WeatherProvider>().updateWeatherData();
              Navigator.of(context).pop();
            },
            contentPadding: Pad.zero,
            title: Text(
              place.country == null
                  ? place.name
                  : '${place.country}, ${place.name}',
              style: Theme.of(context).textTheme.overline,
            ),
            trailing: IconButton(
              onPressed: () {
                (isFavorite
                    ? bloc.add(SettingsFavoriteRemoved(place))
                    : bloc.add(SettingsFavoriteAdded(place)));
              },
              icon: Icon(
                isFavorite ? Icons.star_rounded : Icons.star_border_rounded,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
          );
        } else {
          return const Text("Неожиданная ошибка. Настройки не загружены.");
        }
      },
    );
  }
}
