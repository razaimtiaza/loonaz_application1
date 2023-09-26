import 'package:flutter/material.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loonaz_application/src/constants/text_strings.dart';
import 'package:loonaz_application/View%20Model/wallapaper_view_model.dart';

import 'package:loonaz_application/repositries/wallpaper_repo.dart';
import 'package:loonaz_application/src/features/models/dashboard/wallpaper/wallpaper_model.dart';
import 'package:loonaz_application/src/features/screens/dashboard/wallpapers/Wallpaper_detail_screen.dart';
import 'package:provider/provider.dart';

import 'category_products.dart';

class Wallpapers extends StatefulWidget {
  const Wallpapers({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<Wallpapers> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<WallPaperViewModel>(context, listen: false)
          .getAllWallPapers();
      Provider.of<WallPaperViewModel>(context, listen: false)
          .getAllCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 1;
    final width = MediaQuery.sizeOf(context).width * 1;
    return Consumer<WallPaperViewModel>(
      builder: (context, viewModel, child) {
        return NotificationListener(
          onNotification: (ScrollNotification notification) {
            if (!viewModel.loading &&
                notification.metrics.pixels ==
                    notification.metrics.maxScrollExtent) {
              //  viewModel.getAllProducts('-createdAt', false, 20);
              viewModel.getAllWallPapers();
              // viewModel.getAllCategories();
            }
            return true;
          },
          child: Scaffold(
            backgroundColor: Colors.black,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(left: 10),
                    child: Text('Categories',style: TextStyle(
                      color: Colors.white,fontWeight: FontWeight.w600,fontSize: 17
                    ),),
                  ),
                  const SizedBox(height: 5,),
                  buildCategories(viewModel),
                  const SizedBox(height: 20,),
                  Container(
                    color: Colors.black,
                    child: buildWallpaper(viewModel),
                    // child: FutureBuilder<Wallpaper>(
                    //   future: wal.fetchwallData(),
                    //   builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    //     if (snapshot.connectionState == ConnectionState.waiting) {
                    //       return const Center(
                    //         child: SpinKitChasingDots(
                    //           color: Colors.blue,
                    //           size: 40,
                    //         ),
                    //       );
                    //     } else {
                    //       return GridView.builder(
                    //         gridDelegate:
                    //             const SliverGridDelegateWithFixedCrossAxisCount(
                    //           crossAxisCount: 2,
                    //           crossAxisSpacing: 2.0,
                    //           mainAxisSpacing: 3.0,
                    //         ),
                    //         itemCount: snapshot.data?.data?[0].length ?? 0,
                    //         itemBuilder: (context, index) {
                    //           var item = snapshot.data?.data?[0][index];
                    //           if (item == null) {
                    //             return Container(); // Handle if item is null
                    //           }
                    //           return GestureDetector(
                    //             onTap: () {
                    //               Navigator.push(
                    //                 context,
                    //                 MaterialPageRoute(
                    //                   builder: (context) => WallDetailScreen(
                    //                       imageDataList: snapshot.data?.data?[0] ??
                    //                           [], // Pass the list of images
                    //                       initialIndex: index,
                    //                       heroTag: 'image_$index'),
                    //                 ),
                    //               );
                    //             },
                    //             child: Hero(
                    //               tag: 'image_$index',
                    //               child: Container(
                    //                 child: Stack(
                    //                   children: [
                    //                     SizedBox(
                    //                       height: height,
                    //                       width: width,
                    //                       child: Image.network(
                    //                         item.file_high ?? '',
                    //                         fit: BoxFit.cover,
                    //                       ),
                    //                     ),
                    //                   ],
                    //                 ),
                    //               ),
                    //             ),
                    //           );
                    //         },
                    //       );
                    //     }
                    //   },
                    // ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildCategories(WallPaperViewModel viewModel) {
    if (viewModel.loading && viewModel.category.isEmpty) {
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
            // viewModel.getAllWallPapers();
            viewModel.getAllCategories();
          }
          return true;
        },
        child: Container(
          color: Colors.black,
          height: MediaQuery.of(context).size.height * 0.09,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              if (index == viewModel.category.length) {
                return _buildProgressIndicator(viewModel.loading);
              }else{
                return ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.5),
                    // Apply black dull effect (adjust opacity as needed)
                    BlendMode.saturation, // You can adjust the BlendMode as needed
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_)=>CategoryProducts(name: viewModel.category[index].title.toString(), query: viewModel.category[index].catname.toString(),)));
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 10),
                      width: 130,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                  '${viewModel.category[index].file_low}'))),
                      child: Center(
                        child: Text(
                          viewModel.category[index].catname.toString(),
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 15),
                        ),
                      ),
                    ),
                  ),
                );
              }

            },
            itemCount: viewModel.category.length,
          ),
        ),
      );
    }
  }

  Widget buildWallpaper(WallPaperViewModel viewModel) {
    if (viewModel.loading && viewModel.wallPapers.isEmpty) {
      return const SpinKitChasingDots(
        color: Colors.blue,
        size: 40,
      );
    } else {
      return GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 2.0,
          mainAxisSpacing: 3.0,
        ),
        itemCount: viewModel.wallPapers.length,
        itemBuilder: (context, index) {
          if (index == viewModel.wallPapers.length) {
            return _buildProgressIndicator(viewModel.loading);
          } else {
            return ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WallDetailScreen(
                          imageDataList: viewModel.wallPapers, // Pass the list of images
                          initialIndex: index,
                          heroTag: 'image_$index'),
                    ),
                  );
                },
                child: Hero(
                  tag: 'image_$index',
                  child: Container(
                    child: Stack(
                      children: [
                        SizedBox(
                          height: MediaQuery.sizeOf(context).height * 1,
                          width: MediaQuery.sizeOf(context).width * 1,
                          child: Image.network(
                            viewModel.wallPapers[index].file_low.toString() ?? "",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        },
      );
    }
  }

  Widget _buildProgressIndicator(bool isLoading) {
    return isLoading
        ? Center(
            child: Container(
                margin: EdgeInsets.all(10),
                child: const CircularProgressIndicator()))
        : Container();
  }
}
