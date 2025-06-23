class DestinationStatusHistory {
  final String status;
  final String note;
  final String
  updatedBy; // user role, user name, or user ID as per your preference
  final DateTime date;

  DestinationStatusHistory({
    required this.status,
    required this.note,
    required this.updatedBy,
    required this.date,
  });
}

class DestinationModel {
  final String name;
  final int adults;
  final int children;
  final int duration;
  final double budget;
  String? quotedPackage;
  String notes;
  String status;

  List<DestinationStatusHistory> history;

  DestinationModel({
    required this.name,
    required this.adults,
    required this.children,
    required this.duration,
    required this.budget,
    this.quotedPackage,
    this.notes = '',
    this.status = 'New Lead',
    List<DestinationStatusHistory>? history,
  }) : history = history ?? [];

  int get totalPax => adults + children;
}
