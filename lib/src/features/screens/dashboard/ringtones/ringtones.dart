import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:loonaz_application/View%20Model/ringtone_view_model.dart';

import 'package:loonaz_application/src/features/controllers/ringtone_controller.dart';
import 'package:loonaz_application/src/features/models/ringtones/ringone_model.dart';
import 'package:loonaz_application/src/features/screens/dashboard/ringtones/ringtone_detail_screen.dart';
import 'package:provider/provider.dart';

import '../../../../constants/sizes.dart';

class Ringtones extends StatefulWidget {
  const Ringtones({super.key});

  @override
  State<Ringtones> createState() => _RingtonesState();
}

class _RingtonesState extends State<Ringtones> {
  final ringtoneController = Get.put(RingtoneScreenController());
  final AudioPlayer audioPlayer = AudioPlayer();
  String? currentPlayingUrl;
  bool isPlaying = false;
  Color _generateRandomColor() {
    final Random random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(220),
      random.nextInt(260),
      random.nextInt(280),
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<RingToneViewModel>(context, listen: false).getAllRingtones();
      Provider.of<RingToneViewModel>(context, listen: false).getAllPopular();
    });
  }
  List<Color> color = [];

  @override
  Widget build(BuildContext context) {
    final Color color1 = _generateRandomColor();
     final Color color2 = _generateRandomColor();
    color.add(color1);
    color.add(color2);
    // final list = RingtoneModelClass.list;
    // TODO: implement build
    return Consumer<RingToneViewModel>(
      builder: (context, viewModel, child) {
        return NotificationListener(
          onNotification: (ScrollNotification notification) {
            if (!viewModel.loading &&
                notification.metrics.pixels ==
                    notification.metrics.maxScrollExtent) {
              //  viewModel.getAllProducts('-createdAt', false, 20);
              viewModel.getAllRingtones();
            }
            return true;
          },
          child: Scaffold(
            body: Container(
                color: Colors.black,
                width: double.infinity,
                height: double.infinity,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          left: 10
                        ),
                        child: Text("Popular",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      buildHorizontalPopularTones(viewModel,color),
                      Container(
                        margin: EdgeInsets.only(
                            left: 10
                        ),
                        child: Text("Latest",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Obx(
                            () =>
                        ringtoneController.isLoading.value
                            ? const Center(child: CircularProgressIndicator())
                            : _buildListView(viewModel,color),
                      )
                    ],
                  ),
                )),
          ),
        );
      },
    );
  }

  Future<void> _playMusic1(String audioUrl) async {
    print("data===1$audioUrl");
    try {
      if (audioUrl == currentPlayingUrl && isPlaying) {
        print("data===2");
        await audioPlayer.pause();
        setState(() {
          print("data===3");
          isPlaying = false;
        });
      } else {
        print("data===4");
        await audioPlayer.play(UrlSource(audioUrl));
        setState(() {
          print("data===5");
          currentPlayingUrl = audioUrl;
          isPlaying = true;
        });
      }
    } catch (e) {}
  }

  Widget _buildListView(RingToneViewModel viewModel,List<Color> colors) {
    if (viewModel.loading && viewModel.ringTones.isEmpty) {
      return const SpinKitChasingDots(
        color: Colors.blue,
        size: 40,
      );
    } else {
      return Container(
        margin: EdgeInsets.only(
          left: 10
        ),
        child: ListView.builder(
          itemCount: viewModel.ringTones.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            if (index == viewModel.ringTones.length) {
              return _buildProgressIndicator(viewModel.loading);
            } else {
              return GestureDetector(
                onTap: () {
                  // Navigate to the detail screen when an item is tapped
                  ringtoneController.pauseSong();
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => RingtoneDetailScreen(
                  //       itemList:   ,
                  //       initialIndex: index,
                  //     ),
                  //   ),
                  // );
                },
                child: Container(
                  color: Colors.black,
                  child: Padding(
                    padding: const EdgeInsets.all(defaultPadding / 2 - 4),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            // _playMusic(list[index].audioUrl);
                            ringtoneController
                                .playMusic(viewModel.ringTones[index].fileMp3);
                          },
                          child: Stack(
                            children: [
                              Container(
                                width: 90,
                                height: 90,
                                decoration:  BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: colors,
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(defaultPadding / 2)),
                                ),
                              ),
                              SizedBox(
                                width: 90,
                                height: 90,
                                child: Icon(
                                  Icons.play_circle_fill_outlined,
                                  color: Colors.white.withOpacity(0.7),
                                  size: 42.0,
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: tDefaultSize / 2,
                        ),
                        GestureDetector(
                          onTap: () {
                            ringtoneController.pauseSong();
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => RingtoneDetailScreen(
                            //       itemList: list,
                            //       initialIndex: index,
                            //     ),
                            //   ),
                            // );
                          },
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width * 0.62,
                                child: Text(
                                  viewModel.ringTones[index].title,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 12.0,
                                      color: Colors.white),
                                ),
                              ),
                              const SizedBox(
                                height: tDefaultSize / 4,
                              ),
                              Text(
                                viewModel.ringTones[index].catname,
                                style: const TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14.0,
                                    color: Colors.white),
                              ),
                              const SizedBox(
                                height: tDefaultSize / 4,
                              ),
                              Text(
                                viewModel.ringTones[index].duration.toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 10.0,
                                    color: Colors.grey),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }
          },),
      );
    }
    // final List<RingtoneModelClass> list = itemList;
//  // print("data == itemlist");
//   return ListView.builder(
//     itemCount: itemList.length,
//     itemBuilder: (context, index) {
//       return ListTile(
//         title: Text(itemList[index].audioUrl,
//         style: TextStyle( color: Colors.black),),
//         subtitle: Text(itemList[index].audioUrl),
//       );
//     },
//   );

  }

  Widget _buildProgressIndicator(bool isLoading,) {
    return isLoading
        ? Center(
        child: Container(
            margin: EdgeInsets.all(10),
            child: const CircularProgressIndicator()))
        : Container();
  }

  Widget buildHorizontalPopularTones(RingToneViewModel viewModel,List<Color> colors) {
    if (viewModel.loading && viewModel.popularRing.isEmpty) {
      return const SpinKitChasingDots(
        color: Colors.blue,
        size: 40,
      );
    } else {
      return NotificationListener(
        onNotification: (ScrollNotification notification) {
          if (!viewModel.loading &&
              notification.metrics.pixels ==
                  notification.metrics.maxScrollExtent) {
            //  viewModel.getAllProducts('-createdAt', false, 20);
            viewModel.getAllPopular();
          }
          return true;
        },
        child: SizedBox(

          height: MediaQuery
              .of(context)
              .size
              .height * 0.14,
          child: ListView.builder(scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {

              return Container(
                margin: EdgeInsets.only(
                  left: 10
                ),
                child: Column(
                  children: [
                    Container(
                      width: 130,
                      height: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                        gradient: LinearGradient(
                          colors:colors,
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),

                        // color: Color(0xff + num.parse(viewModel.ringTones[index]
                        //     .hash).toInt()),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.play_circle_outlined, color: Colors.white,),
                      ),

                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                        width: 120,

                        child: Text(viewModel.popularRing[index].title.toString(),
                          overflow: TextOverflow.ellipsis, maxLines: 1,style: TextStyle(
                            color: Colors.white
                          ),))
                  ],
                ),
              );
            },
            itemCount: viewModel.popularRing.length,
          ),
        ),
      );
    }
  }
}


/*class GradientContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blueGrey, Colors.purple], // Replace with your desired colors
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0.0, 2.0),
            blurRadius: 6.0,
          ),
        ],
      ),
      child: Center(
        child: Text(
          'Gradient Container',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
*/

// class RadialGradientContainer extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 200,
//       height: 200,
//       decoration: BoxDecoration(
//         gradient: RadialGradient(
//           colors: [Colors.orange, Colors.yellow], // Replace with your desired colors
//           center: Alignment.center,
//           radius: 0.7,
//         ),
//         borderRadius: BorderRadius.circular(16.0),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black26,
//             offset: Offset(0.0, 2.0),
//             blurRadius: 6.0,
//           ),
//         ],
//       ),
//       child: Center(
//         child: Text(
//           'Radial Gradient',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 20.0,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     );
//   }
// }