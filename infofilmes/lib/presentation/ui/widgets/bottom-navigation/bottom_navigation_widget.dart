import 'package:flutter/material.dart';
import 'package:infofilmes/domain/factories/screen_factory.dart';
import '../../../common/constants/constants.dart';

class BottomNavigationWidget extends StatefulWidget {
  const BottomNavigationWidget({Key? key}) : super(key: key);
  @override
  State<BottomNavigationWidget> createState() => _BottomNavigationWidgetState();
}

class _BottomNavigationWidgetState extends State<BottomNavigationWidget> {
  int _selectedTab = 0;
  final _screenFactory = ScreenFactory();

  void onSelectTab(int index) {
    if (_selectedTab == index) return;
    setState(() {
      _selectedTab = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary,
      body: IndexedStack(
        index: _selectedTab,
        children: [
          _screenFactory.makeNewsList(),
          _screenFactory.makeFavorite(),
          _screenFactory.makeMovieList(),

        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTab,
        elevation: 0,
        backgroundColor: bottomNav,
        selectedItemColor: bottomNavUnselect,
        unselectedItemColor: bottomNavUnselect,
        showUnselectedLabels: false,
        showSelectedLabels: false,
        items: [
          BottomNavigationBarItem(
            icon: _selectedTab == 0
                ? Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: secondary,
                    ),
                    child: const Icon(Icons.movie_filter, size: 30),
                  )
                : const Icon(Icons.movie_filter, size: 30),
            label: 'fita',
          ),
          BottomNavigationBarItem(
            icon: _selectedTab == 1
                ? Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: secondary,
                    ),
                    child: const Icon(Icons.favorite, size: 30),
                  )
                : const Icon(Icons.favorite, size: 30),
            label: 'Favoritos',
          ),
          BottomNavigationBarItem(
            icon: _selectedTab == 2
                ? Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: secondary,
              ),
              child: const Icon(Icons.search, size: 30),
            )
                : const Icon(Icons.search, size: 30),
            label: 'Pesquisar',
          ),
        ],
        onTap: onSelectTab,
      ),
    );
  }
}
