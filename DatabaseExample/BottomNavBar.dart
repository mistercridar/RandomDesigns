import 'package:attendance/Dashboard.dart';
import 'package:attendance/HomePage.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Database/DatabaseHelper.dart';
import 'Model/KharchaModel.dart';


class BottomNavBar extends StatefulWidget {

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}


class _BottomNavBarState extends State<BottomNavBar> {
  late DatabaseHandler handler;
  //final List<Widget> _tabItems = [Dashboard(), HomePage(), Dashboard(),Dashboard(),Dashboard()];
  int _page = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: CurvedNavigationBar(
          key: _bottomNavigationKey,

          index: 0,
          height: 60.0,
          items: <Widget>[
            bottomItem(
                title: "Dashboard", index: 0, icon: Icons.dashboard),
            bottomItem(title: "Leave Form", index: 1, icon: Icons.article),
            bottomItem(title: "Attendance", index: 2, icon: Icons.add_circle),
            bottomItem(title: "Reports", index: 3, icon: Icons.article_outlined),
            bottomItem(title: "More", index: 4, icon: Icons.more_horiz),
          ],
          color: Colors.black,
          buttonBackgroundColor: Colors.white,
          backgroundColor: Colors.white,
          animationCurve: Curves.easeInOut,
          animationDuration: const Duration(milliseconds: 600),
          onTap: (index) {
            setState(() {
              _page = index;
            });
          },
          letIndexChange: (index) => true,
        ),
        body:  FutureBuilder
          (
          future: this.handler.retrieveKharcha(),
          builder: (BuildContext context, AsyncSnapshot<List<KharchaModel>> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (BuildContext context, int index) {
                  return Dismissible(
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Icon(Icons.delete_forever),
                    ),
                    key: ValueKey<int>(snapshot.data![index].id!),
                    onDismissed: (DismissDirection direction) async {
                      await this.handler.deleteKharcha(snapshot.data![index].id!);
                      setState(() {
                        snapshot.data!.remove(snapshot.data![index]);
                      });
                    },
                    child: Card(
                        child: ListTile(
                          contentPadding: EdgeInsets.all(8.0),
                          title: Text(snapshot.data![index].kharchaName),
                          subtitle: Text(snapshot.data![index].amount.toString()),
                        )),
                  );
                },
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        )

      //  _tabItems[_page],
      //   Container(
      //     color: Colors.white,
      //     child: Center(
      //       child: Column(
      //         children: <Widget>[
      //
      //           Text(_page.toString(), textScaleFactor: 10.0),
      //           ElevatedButton(
      //             child: Text('Go To Page of index 1'),
      //             onPressed: () {
      //               //Page change using state does the same as clicking index 1 navigation button
      //               final CurvedNavigationBarState? navBarState =
      //                   _bottomNavigationKey.currentState;
      //               navBarState?.setPage(1);
      //             },
      //           )
      //         ],
      //       ),
      //     ),
      //   )
    );

  }
  Widget bottomItem(
      {required int index, required String title, required IconData icon}) {
    if (index == _page) {
      return Icon(
        icon,
        size: 26,
        color: Colors.black,
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(top: 6.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 22,
              color: Colors.white,
            ),
            const SizedBox(height: 5),
            Text(
              title,
              style: const TextStyle(color: Colors.white),
            )
          ],
        ),
      );
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.handler = DatabaseHandler();
    this.handler.initializeDB().whenComplete(() async {
      await this.addKharchas();
      setState(() {});
    });
  }
  Future<int> addKharchas() async {

    KharchaModel firstUser = KharchaModel(kharchaName: "petrol", amount: 2044);
    KharchaModel secondUser = KharchaModel(kharchaName: "samosha", amount: 50);
    List<KharchaModel> listOfKharchass = [firstUser, secondUser];
    return await handler.insertKharcha(listOfKharchass);
  }

}
