import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loonaz_application/View%20Model/dp_wallpaper_view_model.dart';

import 'package:loonaz_application/src/features/screens/dashboard/dps/dps_image.dart';
import 'package:provider/provider.dart';

class Dps extends StatefulWidget {
  const Dps({Key? key}) : super(key: key);

  @override
  State<Dps> createState() => _DpsState();
}

class _DpsState extends State<Dps> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<DpsWallPaperViewModel>(context, listen: false)
          .getAllWallPapers();
    });
  }
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 1;
    final width = MediaQuery.sizeOf(context).width * 1;
    return Consumer<DpsWallPaperViewModel>(
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
            body: Container(
                color: Colors.black,
                child: buildGridWallPaper(viewModel, context)),
          ),
        );
      },
    );
  }

  Widget buildGridWallPaper(
      DpsWallPaperViewModel viewModel, BuildContext context) {
    if (viewModel.loading && viewModel.wallPapers.isEmpty) {
      return Center(
        child: SpinKitChasingDots(
          color: Colors.blue,
          size: 40,
        ),
      );
    } else {
      return GridView.builder(
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
                          builder: (context) => ImageDetailScreen(
                              imageDataList:
                                  viewModel.wallPapers, // Pass the list of images
                              initialIndex: index,
                              heroTag: 'image_$index'),
                        ),
                      );
                    },
                    child: Hero(
                        tag: 'image_$index',
                        child: Container(
                            child: Stack(children: [
                          SizedBox(
                            height: MediaQuery.sizeOf(context).height * 1,
                            width: MediaQuery.sizeOf(context).width * 1,
                            child: Image.network(
                              viewModel.wallPapers[index].file_low !=null?
                              viewModel.wallPapers[index].file_low.toString() : 'https://t3.ftcdn.net/jpg/05/79/68/24/360_F_579682479_j4jRfx0nl3C8vMrTYVapFnGP8EgNHgfk.jpg',
                              fit: BoxFit.cover,
                            ),
                          )
                        ])))),
              );
            }

            // You can add more widgets here like text, buttons, etc.
          });
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
