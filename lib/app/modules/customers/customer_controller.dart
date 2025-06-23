import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../models/user_role.dart';
import '../bookings/booking_model.dart';
import 'customer_model.dart';
import 'destination_model.dart';

class CustomerController extends GetxController {
  final customers = <CustomerModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Dummy customers with destinations and empty bookings list
    customers.assignAll([
      CustomerModel(
        id: const Uuid().v4(),
        name: 'Rohit Singh',
        email: 'rohit@gmail.com',
        phone: '9876543211',
        assignedTo: UserRole.salesAgent,
        destinations: [
          DestinationModel(
            name: 'Dubai',
            adults: 2,
            children: 1,
            duration: 5,
            budget: 75000,
            quotedPackage: 'Luxury 5D4N',
            notes: 'Wants Desert Safari + Burj Khalifa',
          ),
        ],
        bookings: [], // Initialize empty bookings list
      ),
      CustomerModel(
        id: const Uuid().v4(),
        name: 'Ankita Mehra',
        email: 'ankita@gmail.com',
        phone: '9123456790',
        assignedTo: UserRole.salesAgent,
        destinations: [
          DestinationModel(
            name: 'Singapore',
            adults: 1,
            children: 0,
            duration: 3,
            budget: 45000,
            quotedPackage: null,
            notes: 'Budget conscious, prefers group tours',
          ),
        ],
        bookings: [],
      ),
    ]);
  }

  List<CustomerModel> getCustomersForRole(UserRole role) {
    if (role == UserRole.admin ||
        role == UserRole.manager ||
        role == UserRole.teamLeader) {
      return customers;
    } else {
      return customers.where((c) => c.assignedTo == role).toList();
    }
  }

  CustomerModel? getById(String id) {
    return customers.firstWhereOrNull((c) => c.id == id);
  }

  void addBooking(String customerId, BookingModel booking) {
    final customer = getById(customerId);
    if (customer != null) {
      customer.bookings.add(booking);
      customers.refresh();
    }
  }
}
