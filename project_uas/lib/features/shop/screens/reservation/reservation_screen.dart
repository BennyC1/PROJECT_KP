import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:project_uas/features/shop/controllers/reservation_controller.dart';
import 'package:project_uas/utils/helpers/helper_function.dart';
import 'package:project_uas/utils/constants/colors.dart';
import 'package:project_uas/features/shop/screens/reservation/floating_screen/payment_sheet.dart';
import 'package:project_uas/features/shop/screens/reservation/reservation_history_screen.dart';


class ReservationScreen extends StatefulWidget {
  const ReservationScreen({super.key});

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  final controller = ReservationController.instance;

  @override
  void initState() {
    super.initState();
    controller.resetForm();
  }

  @override
  Widget build(BuildContext context) {
    final dark = BHelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Reservasi Potong Rambut", style: TextStyle(color: dark ? Colors.white : Colors.black),),
        actions: [
          IconButton(
            icon: Icon(Icons.history, color: dark ? Colors.white : Colors.black),
            tooltip: 'Riwayat Reservasi',
            onPressed: () => Get.to(() => const ReservationHistoryScreen()),
          ),
        ],
        ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() => ListView(
              children: [
                /// Dropdown Capster
                DropdownButtonFormField<String>(
                  value: controller.selectedCapster.value,
                  decoration: InputDecoration(
                    labelText: 'Pilih Capster',
                    labelStyle: TextStyle(color: dark ? Colors.white : Colors.black), // ✅ warna label normal
                    floatingLabelStyle: TextStyle(color: dark ? Colors.white : Colors.black), // ✅ warna label saat floating
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: dark ? Colors.white : Colors.black, width: 1.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: dark ? Colors.white : Colors.black, width: 2),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: dark ? Colors.white : Colors.black, width: 1.5),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: dark ? Colors.white : Colors.black, width: 2),
                    ),
                  ),
                  dropdownColor: dark ? Colors.grey[900] : Colors.white,
                  iconEnabledColor: dark ? Colors.white : Colors.black,
                  items: ['Capster A', 'Capster B', 'Capster C']
                      .map((capster) => DropdownMenuItem(
                            value: capster,
                            child: Text(
                              capster,
                              style: TextStyle(color: dark ? Colors.white : Colors.black),
                            ),
                          ))
                      .toList(),
                  onChanged: (value) {
                    controller.selectedCapster.value = value;
                    controller.loadDisabledSlots();
                  },
                ),

                const SizedBox(height: 16),

                /// Dropdown Paket Potong
                DropdownButtonFormField<String>(
                  value: controller.selectedPackage.value,
                  decoration: InputDecoration(
                    labelText: 'Paket Potong',
                    labelStyle: TextStyle(color: dark ? Colors.white: Colors.black), // ✅ label warna sesuai tema
                    floatingLabelStyle: TextStyle(
                      color: dark
                          ? Colors.white
                          : Colors.black,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: dark ? Colors.white : Colors.black, width: 1.5), // ✅ border saat normal
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: dark ? Colors.white : Colors.black, width: 2), // ✅ border saat fokus
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: dark ? Colors.white : Colors.black, width: 1.5),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: dark ? Colors.white : Colors.black, width: 2),
                    ),
                  ),
                  dropdownColor: dark ? Colors.grey[900] : Colors.white, // opsional: latar dropdown
                  items: controller.packageOptions
                      .map((paket) => DropdownMenuItem(
                            value: paket,
                            child: Text(
                              paket,
                              style: TextStyle(color: dark ? Colors.white : Colors.black),
                            ),
                          ))
                      .toList(),
                  onChanged: (value) {
                    controller.selectedPackage.value = value;
                  },
                ),


                /// Tampilkan harga paket
                if (controller.selectedPackage.value != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 16),
                    child: Text(
                      "Harga: Rp ${controller.getPriceForPackage(controller.selectedPackage.value!).toString()}",
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),

                /// Tanggal
                ListTile(
                  title: Text(
                    controller.selectedDate.value == null
                        ? 'Pilih Tanggal'
                        : DateFormat.yMMMMd('id').format(controller.selectedDate.value!),
                  ),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 30)),
                      initialDate: DateTime.now(),
                    );
                    if (date != null) {
                      controller.selectedDate.value = date;
                      controller.loadDisabledSlots();
                    }
                  },
                ),

                const SizedBox(height: 16),

                /// Grid Jam
                if (controller.selectedCapster.value != null &&
                    controller.selectedDate.value != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Pilih Jam:", style: TextStyle(color: dark ? BColors.white : BColors.dark)),
                      const SizedBox(height: 10),
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 4,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 2.0,
                        children: controller.timeSlots.map((time) {
                          final isDisabled = controller.disabledSlots.contains(time);
                          final isSelected = controller.selectedTime.value == time;

                          return OutlinedButton(
                            onPressed: isDisabled
                                ? null
                                : () => controller.selectedTime.value = time,
                            style: OutlinedButton.styleFrom(
                              backgroundColor: isSelected
                                  ? Colors.blueAccent
                                  : isDisabled
                                      ? Colors.grey.shade900
                                      : Colors.transparent,
                              side: BorderSide(
                                color: isSelected ? Colors.blueAccent : Colors.blue,
                                width: 1.5,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: Center(
                              child: Text(
                                time,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: dark ? isDisabled ? Colors.white38 : isSelected ? 
                                  Colors.white : Colors.blue : isDisabled ? Colors.white38 : isSelected ? Colors.white : Colors.blueAccent,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),

                const SizedBox(height: 32),

                /// Tombol Simpan
                // ElevatedButton(
                //   onPressed: () => controller.submitReservation(),
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: Colors.blueAccent,
                //     foregroundColor: Colors.white,
                //     padding: const EdgeInsets.symmetric(vertical: 14),
                //   ),
                //   child: const Text(
                //     "Simpan Reservasi",
                //     style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                //   ),
                // ),

                ElevatedButton(
                  onPressed: () async {
                    final result = await showModalBottomSheet<bool>(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => const PaymentSheet(),
                    );

                    if (result == true) {
                      controller.submitReservation(); // hanya simpan jika user menyelesaikan pembayaran
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    "Lanjut ke Pembayaran",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),

              ],
            )),
      ),
    );
  }
}
