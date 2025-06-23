class BookingModel {
  final String id;
  final String destination;
  final DateTime fromDate;
  final DateTime toDate;
  final double cost;
  final int passengers;
  final String notes;

  BookingModel({
    required this.id,
    required this.destination,
    required this.fromDate,
    required this.toDate,
    required this.cost,
    required this.passengers,
    required this.notes,
  });
}
