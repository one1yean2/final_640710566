class WebType {
  final String id;
  final String title;
  final String subtitle;
  final String image;

  WebType({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.image,
  });

  factory WebType.fromJson(Map<String, dynamic> json) {
    return WebType(
      id: json['id'],
      title: json['title'],
      subtitle: json['subtitle'],
      image: json['image'],
    );
  }
}
