class PostModel {
  final int id;
  final String appName;
  final String title;
  final String body;
  final bool isLottie;
  final String lottie;
  final bool isImage;
  final String image;
  final bool isVideo;
  final String video;
  bool opened;

  PostModel({
    required this.id,
    required this.appName,
    required this.title,
    required this.body,
    this.isLottie = false,
    this.lottie = '',
    this.isImage = false,
    this.image = '',
    this.isVideo = false,
    this.video = '',
    this.opened = false,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'],
      appName: json['appName'],
      title: json['title'],
      body: json['body'],
      isLottie: json['isLottie'] ?? false,
      lottie: json['lottie'] ?? '',
      isImage: json['isImage'] ?? false,
      image: json['image'] ?? '',
      isVideo: json['isVideo'] ?? false,
      video: json['video'] ?? '',
      opened: json['opened'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'appName': appName,
      'title': title,
      'body': body,
      'isLottie': isLottie,
      'lottie': lottie,
      'isImage': isImage,
      'image': image,
      'isVideo': isVideo,
      'video': video,
      'opened': opened,
    };
  }
}
