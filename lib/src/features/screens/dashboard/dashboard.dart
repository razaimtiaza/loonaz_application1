import 'package:flutter/material.dart';
import 'package:loonaz_application/src/constants/text_strings.dart';
import 'package:loonaz_application/src/features/screens/seach_screen.dart';
import 'pfps/pfps.dart';
import 'ringtones/ringtones.dart';
import 'wallpapers/wallpapers.dart';
import 'dps/dps.dart';
import 'live/live.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int currentIndex = 0;
  final screensList = <StatefulWidget>[
    const Wallpapers(),
    const Ringtones(),
    const Live(),
    const Dps(),
    const Pfps()
  ];
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      onWillPop: () async {
        if (currentIndex != 0) {
          // If the current tab is not the HomeScreen, select the HomeScreen
          setState(() {
            currentIndex = 0;
          });
          return false;
        } else {
          // If the current tab is the HomeScreen, exit the application
          return true;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_)=>SearchScreen()));
                  },
                  child: SizedBox(
                    width: double.infinity,
                    height: 40.0,
                    child: TextField(

                      decoration: InputDecoration(
                        enabled: false,
                        hintText: 'Search...',
                        contentPadding:
                        const EdgeInsets.symmetric(vertical: 8.0),
                        // Adjust vertical alignment
                        alignLabelWithHint: true,
                        hintStyle: const TextStyle(color: Colors.white),
                        prefixIcon:
                        const Icon(Icons.search, color: Colors.white),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: const BorderSide(color: Colors.blue),
                        ),
                        filled: true,
                        fillColor: const Color.fromARGB(255, 6, 33, 47),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        //  note : agr hr cheez by default use kro gey to look achi ay gi
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          unselectedItemColor:
              Colors.white, // jo click nai ha on ka color orange ho ga
          selectedItemColor: const Color.fromARGB(
              255, 170, 199, 213), // jo select ha on ka color blue ho ga
          backgroundColor: const Color.fromARGB(255, 6, 33, 47),
          //  iconSize: 40,
          //   selectedFontSize: 20,
          //   unselectedFontSize: 10,
          //  showSelectedLabels: false,  //  not show lable select
          //  showUnselectedLabels: false,  //no show lable unslected
          currentIndex: currentIndex,
          onTap: (index) => setState(() {
            currentIndex = index;
          }),
          items: const [
            BottomNavigationBarItem(
              // icon: _buildNavIcon(Icons.wallpaper, 1, badge: 3),
              icon: Icon(Icons.wallpaper),
              label: wallpaper,
              //backgroundColor: Colors.white  // is k bacground color blue ho ga jb click krey gey
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.music_video),
                label: ringtones,
                backgroundColor: Colors
                    .red // is k bacground color red ho ga jb click krey gey
                ),
            BottomNavigationBarItem(
                icon: Icon(Icons.play_arrow),
                label: live,
                backgroundColor: Colors
                    .blue // is k bacground color blue ho ga jb click krey gey
                ),
            BottomNavigationBarItem(
                icon: Icon(Icons.perm_identity_sharp),
                label: dps,
                backgroundColor: Colors
                    .blue // is k bacground color blue ho ga jb click krey gey
                ),
            BottomNavigationBarItem(
                icon: Icon(Icons.image),
                label: pfps,
                backgroundColor: Colors
                    .blue // is k bacground color blue ho ga jb click krey gey
                ),
          ],
        ),
        body: screensList[
            currentIndex], // is trha jb kisi or activity se wapis ay gey to acitvity again refresh ho gi
        // body: IndexedStack(   // is trha nai ho gi
        //   children: screens,
        // )
      ),
    );
  }

  Widget _buildNavIcon(IconData icon, int index, {int badge = 0}) {
    return Container(
      // width: MediaQuery.of(context).size.width,
      // height: kBottomNavigationBarHeight,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                  child: Container(
                child: Stack(
                  // ignore: deprecated_member_use
                  //overflow: Overflow.visible,
                  children: [
                    Icon(
                      icon,
                      // color: Colors.red,
                      // size: 40,
                    ),
                    index != 0
                        ? Positioned(
                            right: -5.0,
                            top: -5.0,
                            child: Container(
                              height: 20,
                              width: 20,
                              constraints: const BoxConstraints(
                                  maxHeight: 45, maxWidth: 45),
                              decoration: const BoxDecoration(
                                color: Colors.lightGreen,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text("$badge"),
                              ),
                            ),
                          )
                        : Container(
                            child: const SizedBox.shrink(),
                          ),
                  ],
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
