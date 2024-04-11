import 'package:flutter/material.dart';
import 'package:homework_must_eat_place_app/view/firebase_home.dart';
import 'package:homework_must_eat_place_app/view/mysql_home.dart';
import 'package:homework_must_eat_place_app/view/sqlite_home.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  // Property
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: _tabController,
        children: const <Widget>[
          SQLiteHome(),
          MySQLHome(),
          FirebaseHome(),
        ],
      ),
      bottomNavigationBar: SizedBox(
        height: 130,
        child: TabBar(
          controller: _tabController,
          labelStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          labelColor: const Color.fromARGB(
              255, 235, 48, 241), // 선택된 Label의 Color를 변경해준다.
          unselectedLabelStyle: const TextStyle(
            fontSize: 16,
          ),
          unselectedLabelColor: const Color.fromARGB(
              255, 75, 208, 199), // 선택되지 않은 Label들의 Color를 변경해준다.
          overlayColor: MaterialStatePropertyAll(
            Colors.blue.shade100,
          ), // TabBar 클릭 시 나오는 Splash Effect Color
          splashBorderRadius: BorderRadius.circular(
              20), // TabBar 클릭할 때 나오는 Splash Effect의 Radius
          // indicatorColor: const Color.fromARGB(
          //     255, 113, 175, 102), // 선택된 Label에서의 border-bottom Color를 변경해준다.
          indicator: BoxDecoration(
            color: Colors.yellow.shade100,
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.orange.shade100,
              width: 5,
            ),
          ),
          tabs: const [
            Tab(
              text: 'SQLite\n'
                  'ver.',
            ),
            Tab(
              text: 'MySQL\n'
                  'ver.',
            ),
            Tab(
              text: 'Firebase\n'
                  'ver.',
            ),
          ],
        ),
      ),
    );
  }
} // End
