import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:weather_app/features/search/domain/entities/place.dart';
import 'package:weather_app/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:weather_app/widgets/page_header.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Padding(
              padding: Pad(horizontal: 20, top: 32, bottom: 16),
              child: PageHeader(title: 'Избранное'),
            ),
            Expanded(
              child: BlocBuilder<SettingsBloc, SettingsState>(
                buildWhen: (_, newState) {
                  return newState is! SettingsInProgress;
                },
                builder: (context, state) {
                  if (state is SettingsSuccess) {
                    return ListView.separated(
                      padding: const Pad(horizontal: 20, vertical: 16),
                      itemCount: state.settings.favorites.length,
                      itemBuilder: (_, index) =>
                          _favoriteRow(state.settings.favorites[index]),
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                    );
                  } else if (state is SettingsFailure) {
                    return Text(
                      state.message,
                      style: TextStyle(color: Colors.red[700]),
                    );
                  } else {
                    return Text(
                      'При получении списка избранного что-то пошло не так!',
                      style: TextStyle(color: Colors.red[700]),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _favoriteRow(Place place) {
    return Builder(builder: (context) {
      return InkWell(
        borderRadius: BorderRadius.circular(25),
        onTap: () {
          context.read<SettingsBloc>().add(SettingsActivePlaceSet(place));
          Navigator.of(context).pop();
        },
        child: Stack(
          children: [
            SizedBox(
              width: double.infinity,
              child: Neumorphic(
                style: NeumorphicStyle(
                  color: Theme.of(context).colorScheme.surface,
                  depth: Theme.of(context).colorScheme.brightness ==
                          Brightness.light
                      ? -4
                      : 3,
                  lightSource: LightSource.top,
                  boxShape:
                      NeumorphicBoxShape.roundRect(BorderRadius.circular(15)),
                ),
                padding: const Pad(all: 16),
                child: Text(
                  place.country == null
                      ? place.name
                      : '${place.country}, ${place.name}',
                  style: Theme.of(context).textTheme.overline,
                  maxLines: 1,
                ),
              ),
            ),
            Positioned(
              top: 0,
              bottom: 0,
              right: 0,
              child: AspectRatio(
                aspectRatio: 1,
                child: GestureDetector(
                  onTap: () => BlocProvider.of<SettingsBloc>(context)
                      .add(SettingsFavoriteRemoved(place)),
                  child: Neumorphic(
                    style: NeumorphicStyle(
                      color: Theme.of(context).colorScheme.brightness ==
                              Brightness.light
                          ? const Color(0xFFC8DAFF)
                          : const Color(0xFF152A53),
                      depth: Theme.of(context).colorScheme.brightness ==
                              Brightness.light
                          ? 4
                          : 0,
                      boxShape: NeumorphicBoxShape.roundRect(
                          BorderRadius.circular(15)),
                    ),
                    child: Icon(
                      Icons.close,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
