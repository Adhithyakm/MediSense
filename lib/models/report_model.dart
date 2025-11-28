class ReportModel {
  final String title;
  final List<String> symptoms;
  final String description;
  final String district;
  final String locality;
  final String date;
  final String time;

  ReportModel({
    required this.title,
    required this.symptoms,
    required this.description,
    required this.district,
    required this.locality,
    required this.date,
    required this.time,
  });
}
