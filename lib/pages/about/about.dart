import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:weather_app/widgets/page_header.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox.expand(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              const Padding(
                padding: Pad(top: 20, horizontal: 20),
                child: PageHeader(title: 'О разработчике'),
              ),
              const SizedBox(height: 80),
              Neumorphic(
                padding: const Pad(all: 8, horizontal: 32),
                style: NeumorphicStyle(
                  boxShape: NeumorphicBoxShape.roundRect(
                    BorderRadius.circular(15),
                  ),
                  color: Theme.of(context).colorScheme.background,
                  depth: -4,
                  intensity: 0.3,
                  lightSource: LightSource.top,
                  shadowDarkColorEmboss: Theme.of(context).colorScheme.onBackground,
                ),
                child: Text(
                  'Weather app',
                  style: GoogleFonts.manrope(
                    fontWeight: FontWeight.w900,
                    fontSize: 25,
                  ),
                ),
              ),
              const SizedBox(height: 108),
              Expanded(
                child: SizedBox(
                  width: double.infinity,
                  child: _bottomSheet(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bottomSheet() {
    return Builder(builder: (context) {
      return Neumorphic(
        style: NeumorphicStyle(
          boxShape: NeumorphicBoxShape.roundRect(
            const BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30)),
          ),
          color: Theme.of(context).colorScheme.background,
          shadowDarkColor: Theme.of(context).colorScheme.onBackground,
          depth: 10,
          intensity: 0.25,
          lightSource: LightSource.bottom,
        ),
        child: Padding(
          padding: const Pad(top: 24, bottom: 8),
          child: DefaultTextStyle(
            style: GoogleFonts.manrope(
              fontWeight: FontWeight.w900,
              fontSize: 10,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            child: Column(
              children: [
                const Text(
                  'by ITMO University',
                  style: TextStyle(
                    fontSize: 15,
                    inherit: true,
                  ),
                ),
                const SizedBox(height: 8),
                _versionText(),
                const SizedBox(height: 4),
                Text(
                  'от 30 сентября 2021',
                  style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onBackground
                        .withOpacity(0.6),
                  ),
                ),
                const Spacer(),
                const Text('2021'),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _versionText() {
    return FutureBuilder(
      future: PackageInfo.fromPlatform(),
      builder: (
        BuildContext context,
        AsyncSnapshot<PackageInfo> snapshot,
      ) {
        if (snapshot.hasData) {
          return Text(
            'Версия ' + snapshot.data!.version,
            style: TextStyle(
              color:
                  Theme.of(context).colorScheme.onBackground.withOpacity(0.6),
            ),
          );
        } else if (snapshot.hasError) {
          return ListTile(
            leading: const Icon(
              Icons.nearby_error,
              color: Colors.red,
            ),
            title: Text(snapshot.error.toString()),
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
