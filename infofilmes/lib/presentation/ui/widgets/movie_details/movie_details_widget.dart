import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:infofilmes/presentation/ui/widgets/movie_details/movie_details_model.dart';
import '../../../common/constants/constants.dart';
import 'movie_details_main_info_widget.dart';

class MovieDetailsWidget extends StatefulWidget {
  const MovieDetailsWidget({Key? key}) : super(key: key);
  @override
  State<MovieDetailsWidget> createState() => _MovieDetailsWidgetState();
}

class _MovieDetailsWidgetState extends State<MovieDetailsWidget> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<MovieDetailsModel>().setupLocale(context);
  }

  @override
  Widget build(BuildContext context) {
    final model = context.watch<MovieDetailsModel>();
    return Scaffold(
      backgroundColor: primary,
      body: SafeArea(
        child: Stack(
          children: [
            const _BodyWidget(),
            Positioned(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      primary,
                      Colors.transparent,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                         Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.arrow_back_ios,
                      color: primaryText),
                        ),
                    IconButton(
                      onPressed: () {
                        model.toggleFavorite(context);
                      },
                      icon: model.isFavorite != true ?
                      const Icon(Icons.favorite_border,
                      color: primaryText):
                      const Icon(Icons.favorite,
                      color: Color.fromARGB(255, 255, 0, 0),
                      ),
                    )],
                    ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _BodyWidget extends StatelessWidget {
  const _BodyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLoading =
        context.select((MovieDetailsModel model) => model.data.isLoading);
    if (isLoading == true) {
      return const Center(child: SpinKitSpinningLines(color: secondary));
    }
    return ListView(
      children: const [
        MovieDetailsMainInfoWidget(),
      ],
    );
  }
}
