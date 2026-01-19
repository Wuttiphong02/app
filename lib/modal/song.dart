// AI-ASSISTED: Model class สำหรับข้อมูลเพลง
class Song {
  final String id;
  final String title;
  final String artist;
  final String duration;
  final String imageUrl;
  bool isFavorite;

  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.duration,
    required this.imageUrl,
    this.isFavorite = false,
  });

  // AI-ASSISTED: Method สำหรับสร้าง Song จาก JSON (ถ้าต้องการใช้ในอนาคต)
  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      id: json['id'],
      title: json['title'],
      artist: json['artist'],
      duration: json['duration'],
      imageUrl: json['imageUrl'],
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  // AI-ASSISTED: Method สำหรับแปลง Song เป็น JSON (ถ้าต้องการบันทึกข้อมูล)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'duration': duration,
      'imageUrl': imageUrl,
      'isFavorite': isFavorite,
    };
  }
}
