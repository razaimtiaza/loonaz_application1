import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../../../../../View Model/single_category_view_model.dart';
import 'Wallpaper_detail_screen.dart';
class CategoryProducts extends StatefulWidget {
  final String name;
  final String query;
  const CategoryProducts({super.key, required this.name, required this.query});

  @override
  State<CategoryProducts> createState() => _CategoryProductsState();
}

class _CategoryProductsState extends State<CategoryProducts> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<SingleCategoryViewModel>(context, listen: false)
          .wallPapers.clear();
      Provider.of<SingleCategoryViewModel>(context, listen: false)
          .getAllWallPapers(widget.query);
    });
  }
  @override
  Widget build(BuildContext context) {
    return  Consumer<SingleCategoryViewModel>(
      builder:(context, viewModel, child) {
        return  NotificationListener(
          onNotification: (ScrollNotification notification) {
            if (!viewModel.loading &&
                notification.metrics.pixels ==
                    notification.metrics.maxScrollExtent) {
              //  viewModel.getAllProducts('-createdAt', false, 20);
              viewModel.getAllWallPapers(widget.query);
              // viewModel.getAllCategories();
            }
            return true;
          },
          child: Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              centerTitle: false,
              automaticallyImplyLeading: true,
              iconTheme: IconThemeData(color: Colors.white),
              backgroundColor: Colors.black,
              title: Text(widget.query.toString(),style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,fontSize: 16
              ),),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    color: Colors.black,
                    child: buildWallpaper(viewModel),
                  ),

                ],
              ),
            ),
          ),
        );
      },

    );
  }
  Widget buildWallpaper(SingleCategoryViewModel viewModel) {
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
