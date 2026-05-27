import 'package:flutter/material.dart';
import 'package:healthroutine/core/widgets/custom_bottom_nav.dart';
import 'package:healthroutine/features/profile/pages/profile_page.dart';
import '../../features/home/pages/home_page.dart';
import '../../features/reports/pages/reports_page.dart';
import '../features/feature-template/pages/templates_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    const HomePage(),
    const TemplatesPage(), 
    const ReportsPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: CustomBottomNav.buildFAB(context),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
