import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:infofilmes/presentation/ui/widgets/movie_details/movie_details_model.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../../data/data_source/api_client/image_downloader.dart';
import '../../../common/constants/constants.dart';

class MovieDetailsMainInfoWidget extends StatelessWidget {
  const MovieDetailsMainInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        _PosterAndDataWidget(),
        _OverViewWidget(),
        _CastListWidget(),
         SizedBox(height: 30),
      ],
    );
  }
}

class _PosterAndDataWidget extends StatelessWidget {
  const _PosterAndDataWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: const [
        _BackdropPosterWidget(),
        _MovieMainDataWidget(),
      ],
    );
  }
}

class _BackdropPosterWidget extends StatelessWidget {
  const _BackdropPosterWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final posterData =
        context.select((MovieDetailsModel model) => model.data.posterData);
    final trailerKey = posterData.trailerKey;
    if (posterData.backdropPath != null) {
      return AspectRatio(
        aspectRatio: 390 / 219,
        child: Stack(
          children: [
            Image.network(
              ImageDownloader.imageUrl(
                posterData.backdropPath!,
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [primary, Colors.transparent],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
            if (trailerKey != null) _TrailerWidget(trailerKey: trailerKey)
          ],
        ),
      );
    } else {
      return const AspectRatio(aspectRatio: 390 / 219);
    }
  }
}

class _MovieMainDataWidget extends StatelessWidget {
  const _MovieMainDataWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mainData =
        context.select((MovieDetailsModel model) => model.data.mainData);
    return Padding(
      padding: const EdgeInsets.only(top: 140, left: 10, right: 1),
      child: SizedBox(
        height: 200,
        child: Row(
          children: [
            Positioned(
              top: 20,
              bottom: 20,
              left: 20,
              child: Image.network(
                ImageDownloader.imageUrl(mainData.posterPath!),
              ),
            ),
            const SizedBox(width: 15),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 190,
                  child: AppText(
                    size: 22,
                    text: mainData.title ?? '',
                    isBold: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    AppText(size: 14, text: 'Ano: ${mainData.year}'),
                    const SizedBox(width: 15),
                    AppText(size: 14, text: 'Duração: ${mainData.time}'),
                  ],
                ),
                const SizedBox(height: 5),
                AppText(
                    size: 14,
                    text: 'Avaliado: ${mainData.voteCount!.round()} vezes'),
                const SizedBox(height: 20),
                Row(
                  children: [
                    AppText(size: 19, text: mainData.voteAvarage.toString()),
                    const SizedBox(width: 10),
                    StarDisplayWidget(value: mainData.voteAvarage! ~/ 2.round()),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _OverViewWidget extends StatelessWidget {
  const _OverViewWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var overview =
        context.select((MovieDetailsModel model) => model.data.overview);
    if(overview == '')
       overview = 'Sem Sinopse...';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 25),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: AppText(color: titles , size: 20, text: 'Sinopse: ' ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: AppText(color: white, size: 17, text: overview),
        ),
      ],
    );
  }
}

class _CastListWidget extends StatelessWidget {
  const _CastListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.watch<MovieDetailsModel>();
    var length = model.movieDetailsCast!.cast.length;
    var cast = model.movieDetailsCast?.cast;
    if (cast == null || cast.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, top: 10, bottom: 10),
          child:
              AppText(color: titles , size: 22, text: 'Elenco', isBold: FontWeight.w400),
        ),
        SizedBox(
          height: 250,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: ListView.builder(
              itemCount: length,
              itemExtent: 120,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return _CastListItemWidget(castIndex: index);
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _CastListItemWidget extends StatelessWidget {
  final int castIndex;
  const _CastListItemWidget({required this.castIndex, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<MovieDetailsModel>();
    final actor = model.movieDetailsCast!.cast[castIndex];
    final profilePath = actor.profilePath;
    return Padding(
      padding: const EdgeInsets.all(10),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black.withOpacity(0.2)),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          clipBehavior: Clip.hardEdge,
          child: Column(
            children: [
              if (profilePath != null)
                Image.network(ImageDownloader.imageUrl(profilePath))
              else
              Image.asset('assets/images/pessoa.png'),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      actor.name,
                      maxLines: 2,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 12),
                    ),
                    Text(
                      actor.character,
                      maxLines: 2,
                      style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 10,
                          color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class _TrailerWidget extends StatefulWidget {
  final String trailerKey;
  const _TrailerWidget({Key? key, required this.trailerKey}) : super(key: key);
  @override
  State<_TrailerWidget> createState() => __TrailerWidgetState();
}

class __TrailerWidgetState extends State<_TrailerWidget> {
  late final YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.trailerKey,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            builder: (BuildContext context) {
              return _showTrailerBottomSheet(
                widget.trailerKey,
                _controller,
              );
            },
          );
        },
        child: const CircleAvatar(
          child: Icon(
            Icons.play_arrow_rounded,
            color: primaryText,
            size: 32,
          ),
          backgroundColor: secondary,
          radius: 24,
        ),
      ),
    );
  }
}

Widget _showTrailerBottomSheet(
    String trailerKey, YoutubePlayerController controller) {
  return Container(
    decoration: const BoxDecoration(
      color: Color.fromRGBO(24, 23, 27, 1),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(25),
        topRight: Radius.circular(25),
      ),
    ),
    child: YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: controller,
        showVideoProgressIndicator: true,
      ),
      builder: (context, player) {
        return player;
      },
    ),
  );
}
