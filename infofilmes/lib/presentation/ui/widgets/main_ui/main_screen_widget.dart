import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:infofilmes/presentation/ui/widgets/elements/circle_progress_bar.dart';
import 'package:infofilmes/presentation/ui/widgets/main_ui/main_screen_model.dart';
import '../../../../data/data_source/api_client/image_downloader.dart';
import '../../../common/constants/constants.dart';

class MainScreenWidget extends StatefulWidget {
  const MainScreenWidget({Key? key}) : super(key: key);
  @override
  State<MainScreenWidget> createState() => _MainScreenWidgetState();
}

class _MainScreenWidgetState extends State<MainScreenWidget> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<MainScreenModel>().setupLocale(context);
  }

  @override
  Widget build(BuildContext context) {
    final model = context.watch<MainScreenModel>();
    return model.playingMovies.isNotEmpty
        ? SafeArea(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: const [
                _TopBarWidget(),
                _TabsWidget(),
              ],
            ),
          )
        : const Center(child: SpinKitSpinningLines(color: secondary));
  }
}


class _TopBarWidget extends StatelessWidget {
  const _TopBarWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<MainScreenModel>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
           onPressed: () => model.logout(context),
            icon: const Icon(Icons.exit_to_app, color: secondaryText),
          ),],
      ),
    );
  }
}

class _TabsWidget extends StatefulWidget {
  const _TabsWidget({Key? key}) : super(key: key);
  @override
  State<_TabsWidget> createState() => __TabsWidgetState();
}

class __TabsWidgetState extends State<_TabsWidget>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    TabController _tabController = TabController(length: 3, vsync: this);
    final model = context.read<MainScreenModel>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
    SizedBox(
    width: MediaQuery.of(context).size.height/1.5,
    height: MediaQuery.of(context).size.width/1.5,
    child: SvgPicture.asset("assets/images/logo_home.svg"),
    ),Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: TabBar(
            labelColor: primaryText,
            labelStyle:
            const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
            unselectedLabelColor: secondaryText,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorPadding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            indicator: BoxDecoration(
              gradient: const LinearGradient(colors: [
                secondary,
                Color.fromARGB(255, 79, 130, 181),
              ]),
              borderRadius: BorderRadius.circular(50),
            ),
            controller: _tabController,
            tabs: const [
              Tab(text: 'Maiores Avaliações'),
              Tab(text: 'Em Cartaz'),
              Tab(text: 'Próximos Filmes'),
            ],
            isScrollable: true,
          ),
        ),
        SizedBox(
          height: 320,
          child: TabBarView(
            controller: _tabController,
            children: [
              _TopRatedWidget(movies: model.topRatedMovies),
              _TopRatedWidget(movies: model.playingMovies),
              _TopRatedWidget(movies: model.upcomingMovies),
            ],
          ),
        ),
      ],
    );
  }
}

class _TopRatedWidget extends StatelessWidget {
  final List<MovieListRowData> movies;
  const _TopRatedWidget({Key? key, required this.movies}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<MainScreenModel>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 320,
          child: Scrollbar(
            child: ListView.builder(
              itemCount: movies.length,
              physics: const BouncingScrollPhysics(),
              itemExtent: 150,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                final movie = movies[index];
                return GestureDetector(
                    onTap: () => model.onMovieTap(context, movie.id!),
                    child: _MovieTileWidget(movie: movie));
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _MovieTileWidget extends StatelessWidget {
  final MovieListRowData movie;
  const _MovieTileWidget({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                // borderRadius: BorderRadius.circular(10),
                // clipBehavior: Clip.hardEdge,
                child: AspectRatio(
                  aspectRatio: 87 / 130,
                  child: Image(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      ImageDownloader.imageUrl(
                        movie.posterPath!,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 15),
                    AppText(
                        maxLines: 2,
                        size: 16,
                        text: movie.title!,
                        isBold: FontWeight.bold),
                    const SizedBox(height: 5),
                    AppText(
                        size: 14,
                        overflow: true,
                        text: movie.releaseDate!,
                        color: secondaryText),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 88,
            left: 10,
            child: SizedBox(
              width: 40,
              height: 40,
              child: RadialPercentWidget(
                  child: Text('${(movie.voteAvarage! * 10).round()}',
                      style:
                          const TextStyle(color: white, fontFamily: 'Arial')),
                  percent: movie.voteAvarage! / 10,
                  fillColor: const Color.fromARGB(255, 10, 23, 25),
                  lineColor: const Color.fromARGB(255, 37, 203, 103),
                  freeColor: const Color.fromARGB(255, 25, 54, 31),
                  lineWidth: 3),
            ),
          )
        ],
      ),
    );
  }
}
