import '../../models/user_role.dart';
import '../bookings/booking_model.dart';
import 'destination_model.dart';

class CustomerModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final UserRole assignedTo;
  final List<DestinationModel> destinations;
  final List<BookingModel> bookings;

  CustomerModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.assignedTo,
    required this.destinations,
    this.bookings = const [],
  });
}
