class Item {
  final String id;
  final String title;
  final String url;
  final String views;
  final String size;
  final String addDate;
  final String tags;
  final String hash;
  final String status;
  final int duration;
  final String userId;
  final String cid;
  final String catname;
  final String fileMp3;
  final String fileM4r;

  Item({
    required this.id,
    required this.title,
    required this.url,
    required this.views,
    required this.size,
    required this.addDate,
    required this.tags,
    required this.hash,
    required this.status,
    required this.duration,
    required this.userId,
    required this.cid,
    required this.catname,
    required this.fileMp3,
    required this.fileM4r,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      title: json['title'],
      url: json['url'],
      views: json['views'],
      size: json['size'],
      addDate: json['add_date'],
      tags: json['tags'],
      hash: json['hash'],
      status: json['status'],
      duration: json['duration'],
      userId: json['user_id'],
      cid: json['cid'],
      catname: json['catname'],
      fileMp3: json['file_mp3'],
      fileM4r: json['file_m4r'],
    );
  }
}

class RingToneData {
  final String totalPost;
  final String totalPage;
  final List<List<Item>> data;

  RingToneData({
    required this.totalPost,
    required this.totalPage,
    required this.data,
  });

  factory RingToneData.fromJson(Map<String, dynamic> json) {
    return RingToneData(
      totalPost: json['total_post'],
      totalPage: json['total_page'],
      data: (json['data'] as List)
          .map((itemsJson) =>
          (itemsJson as List).map((itemJson) => Item.fromJson(itemJson)).toList())
          .toList(),
    );
  }
}
