import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:infofilmes/presentation/ui/widgets/movie_list/movie_search_model.dart';
import '../../../../data/data_source/api_client/image_downloader.dart';
import '../../../common/constants/constants.dart';

class MovieSearchWidget extends StatefulWidget {
  const MovieSearchWidget({Key? key}) : super(key: key);
  @override
  State<MovieSearchWidget> createState() => _MovieSearchWidgetState();
}

class _MovieSearchWidgetState extends State<MovieSearchWidget> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<MovieSearchModel>().setupLocale(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: const [
          _MovieListWidget(),
          _SearchWidget(),
        ],
      ),
    );
  }
}

class _SearchWidget extends StatelessWidget {
  const _SearchWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<MovieSearchModel>();
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextField(
         style: TextStyle(color: Colors.white),
        onChanged: (val) => model.searchMovie(val),
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.search,
            color: white,
          ),

          filled: true,
          fillColor: grey.withAlpha(100),
          hintText: 'Pesquisar',
          hintStyle: const TextStyle(color: secondaryText),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: tertiary),
            borderRadius: BorderRadius.circular(25),
          ),
        ),
      ),
    );
  }
}

class _MovieListWidget extends StatelessWidget {
  const _MovieListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.watch<MovieSearchModel>();
    return ListView.builder(
      padding: const EdgeInsets.only(top: 70),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      itemCount: model.movies.length,
      itemExtent: 163,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        model.showedMovieAtIndex(index);
        return _MovieListRowWidget(index: index);
      },
    );
  }
}

class _MovieListRowWidget extends StatelessWidget {
  final int index;
  const _MovieListRowWidget({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<MovieSearchModel>();
    final movie = model.movies[index];
    final posterPath = movie.posterPath;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: black.withOpacity(.2)),
              borderRadius: BorderRadius.circular(10),
              color: secondary,
              boxShadow: [
                BoxShadow(
                  color: black.withOpacity(.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            clipBehavior: Clip.hardEdge,
            child: Row(
              children: [
                if (posterPath != null)
                  Image.network(ImageDownloader.imageUrl(posterPath),
                      width: 95),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      AppText(
                          size: 18,
                          text: movie.title!,
                          isBold: FontWeight.bold,
                          maxLines: 1,
                          overflow: true),
                      const SizedBox(height: 5),
                      AppText(
                        size: 16,
                        text: movie.releaseDate!,
                        color: secondaryText,
                        maxLines: 1,
                      ),
                      const SizedBox(height: 12),
                      AppText(
                        size: 16,
                        text: movie.overview!,
                        overflow: true,
                        color: primaryText,
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 5),
              ],
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () => model.onMovieTap(context, index),
            ),
          )
        ],
      ),
    );
  }
}
