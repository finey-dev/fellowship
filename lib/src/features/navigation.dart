import 'package:fellowship/src/configs/configs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fellowship/src/features/screens.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Navigation extends ConsumerStatefulWidget {
  const Navigation({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NavigationState();
}

class _NavigationState extends ConsumerState<Navigation> {
  static const double _playerMinHeight = 60.0;

  int _selectedIndex = 0;

  final _screens = [
    const Home(),
    const Media(),
    const Study(),
    const Offerings(),
    const Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: Consumer(builder: ''),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
        selectedFontSize: 10.0,
        unselectedFontSize: 10.0,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              AppAssetsPath.homeT,
            ),
            activeIcon: SvgPicture.asset(
              AppAssetsPath.homeS,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              AppAssetsPath.mediaT,
            ),
            activeIcon: SvgPicture.asset(
              AppAssetsPath.mediaS,
            ),
            label: 'Media',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              AppAssetsPath.studyT,
              width: 17,
              height: 17,
            ),
            activeIcon: SvgPicture.asset(
              AppAssetsPath.studyS,
              width: 17,
              height: 17,
            ),
            label: 'Study',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              AppAssetsPath.coinT,
              width: 17,
              height: 17,
            ),
            activeIcon: SvgPicture.asset(
              AppAssetsPath.coinS,
              width: 17,
              height: 17,
            ),
            label: 'Offerings',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              AppAssetsPath.profileT,
              width: 17,
              height: 17,
            ),
            activeIcon: SvgPicture.asset(
              AppAssetsPath.profileS,
              width: 17,
              height: 17,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
