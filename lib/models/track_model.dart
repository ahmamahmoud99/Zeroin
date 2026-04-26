class TrackModel {
  final String id;
  final String title;
  final String icon; // مثلاً 'code' أو 'design'
  final List<String> roadmaps; // قائمة بالخطوات

  TrackModel({
    required this.id,
    required this.title,
    required this.icon,
    required this.roadmaps,
  });

  factory TrackModel.fromMap(String id, Map<String, dynamic> data) {
    return TrackModel(
      id: id,
      title: data['title'] ?? '',
      icon: data['icon'] ?? '',
      roadmaps: List<String>.from(data['roadmaps'] ?? []),
    );
  }
}
