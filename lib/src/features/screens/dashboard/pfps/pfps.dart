import 'package:flutter/material.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loonaz_application/View%20Model/pfps_wallpaper_view_model.dart';
import 'package:loonaz_application/src/features/models/pfps_model/pfps_model.dart';
import 'package:loonaz_application/src/features/screens/dashboard/pfps/pfps_image.dart';
import 'package:provider/provider.dart';

class Pfps extends StatefulWidget {
  const Pfps({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<Pfps> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<PfPsWallPaperViewModel>(context, listen: false)
          .getPfPsWallpaper();
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 1;
    final width = MediaQuery.sizeOf(context).width * 1;
    return Consumer<PfPsWallPaperViewModel>(
      builder: (context, viewModel, child) {
        return NotificationListener(
          onNotification: (ScrollNotification notification) {
            if (!viewModel.loading &&
                notification.metrics.pixels ==
                    notification.metrics.maxScrollExtent) {
              //  viewModel.getAllProducts('-createdAt', false, 20);
              viewModel.getPfPsWallpaper();
              // viewModel.getAllCategories();
            }
            return true;
          },
          child: Scaffold(
            body: Container(
              color: Colors.black,
              child: buildPfpWallPaperGrid(viewModel, context),
            ),
          ),
        );
      },
    );
  }

  Widget buildPfpWallPaperGrid(
      PfPsWallPaperViewModel viewModel, BuildContext context) {
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
                      builder: (context) => pfpsDetailScreen(
                          imageDataList:
                              viewModel.wallPapers, // Pass the list of images
                          initialIndex: index,
                          heroTag: 'image_$index'),
                    ),
                  );
                },
                child: Hero(
                  tag: 'image_$index',
                  child: Stack(
                    children: [
                      SizedBox(
                        height: MediaQuery.sizeOf(context).height * 1,
                        width: MediaQuery.sizeOf(context).width * 1,
                        child: Image.network(
                          viewModel.wallPapers[index].file_high ?? '',
                          fit: BoxFit.cover,
                        ),
                      ),
                      // You can add more widgets here like text, buttons, etc.
                    ],
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
