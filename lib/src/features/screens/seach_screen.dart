import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loonaz_application/View%20Model/search_view_model.dart';
import 'package:provider/provider.dart';

import 'dashboard/wallpapers/Wallpaper_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    final searchNotifier = context.watch<SearchViewModel>();
    return Consumer<SearchViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            elevation: 0,
            automaticallyImplyLeading: false,
            title: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    height: 40.0,
                    child: TextField(
                      onChanged: (query) {
                        searchNotifier.searchWallpapers(query);
                      },
                      decoration: InputDecoration(
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
                )
              ],
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                if (searchNotifier.isLoading)
        const Center(
            child: SpinKitChasingDots(
              color: Colors.blue,
              size: 40,
            ),
        )
                else
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 2.0,
                      mainAxisSpacing: 3.0,
                    ),
                    itemCount: viewModel.searchResults.length,
                    itemBuilder: (context, index) {
                      if (index == viewModel.searchResults.length) {
                        return _buildProgressIndicator(viewModel.isLoading);
                      } else {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WallDetailScreen(
                                      imageDataList: viewModel.searchResults,
                                      // Pass the list of images
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
                                      height:
                                          MediaQuery.sizeOf(context).height * 1,
                                      width: MediaQuery.sizeOf(context).width * 1,
                                      child: Image.network(
                                        viewModel.searchResults[index].file_low
                                                .toString() ??
                                            "",
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
                  )
              ],
            ),
          ),
        );
      },
    );
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
