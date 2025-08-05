// import 'package:intl/intl.dart';
// import 'package:on_book_shop_crm/features/authentication/presentation/provider/authentication_provider.dart';
// import 'package:on_book_shop_crm/features/calender_view/presentation/provider/add_appoitment_provider.dart';
// import 'package:on_book_shop_crm/general/routing/route_config.dart';
// import 'package:provider/provider.dart';

// String fillPlaceholdersFromAppointment({
//   required String message,
//   required AddAppoitmentProvider provider,
// }) {
//   final customer = provider.selectedCustomer;
//   final vehicle = provider.selectedVehicle;
//   final shop = navigatorKey.currentContext!
//       .read<AuthenticationProvider>()
//       .shopModel;

//   final startDate = provider.selectedStartDate;
//   final startTime = provider.startTime;
//   final endDate = provider.selectedEndDate;
//   final endTime = provider.endTime;

//   final Map<String, String> values = {
//     'first_name': customer?.firstName ?? '',
//     'last_name': customer?.lastName ?? '',
//     'customer_address': customer?.address1 ?? '',
//     'appt_start_date': startDate != null
//         ? DateFormat('dd/MM/yyyy').format(startDate)
//         : '',
//     'appt_start_time': startTime != null
//         ? startTime.format(navigatorKey.currentContext!)
//         : '',
//     'appt_end_date': endDate != null
//         ? DateFormat('dd/MM/yyyy').format(endDate)
//         : '',
//     'appt_end_time': endTime != null
//         ? endTime.format(navigatorKey.currentContext!)
//         : '',
//     'order_no': '',
//     'order_total': '',
//     'vehicle': vehicle != null
//         ? '${vehicle.make} ${vehicle.model} ${vehicle.year ?? ''}'.trim()
//         : '',
//     'vin': vehicle?.vin ?? '',
//     'license_plate': vehicle?.licensePlate ?? '',
//     'shop_name': shop?.shopName ?? '',
//     'shop_address': shop?.address1 ?? '',
//   };

//   String updated = message;

//   for (var entry in values.entries) {
//     updated = updated.replaceAll('{${entry.key}}', entry.value);
//   }

//   return updated;
// }
