class LiveWallPaper {
  String? totalPost;
  String? totalPage;
  List<List<LiveWallPaperData>>? data;

  LiveWallPaper({this.totalPost, this.totalPage, this.data});

  LiveWallPaper.fromJson(Map<String, dynamic> json) {
    totalPost = json['total_post'];
    totalPage = json['total_page'];
    if (json['data'] != null) {
      data = <List<LiveWallPaperData>>[];
      json['data'].forEach((v) {
        if (v is List) {
          List<LiveWallPaperData> dataList = [];
          for (var item in v) {
            dataList.add(LiveWallPaperData.fromJson(item));
          }
          data!.add(dataList);
        }
      });
    }
  }
}

class LiveWallPaperData {
  String? id;
  String? title;
  String? catname;
  String? url;
  String? file_thumb;
  String? file_video;
  String? size;
  String? views; // Corrected property name for thumbnail URL

  LiveWallPaperData(
      {this.id,
        this.title,
        this.catname,
        this.url,
        this.file_thumb,
        this.file_video,
        this.size,
        this.views}); // Include the new property in the constructor

  LiveWallPaperData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    catname = json['catname'];
    url = json['url'];
    file_thumb = json['file_thumb'];
    file_video = json['file_video'];
    size = json['size'];
    views = json['views']; // Assign the value from JSON to the new property
  }
}
