// Final Version - ReservationScreen using Layanan collection (Capster + Packages)

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:project_uas/features/shop/controllers/reservation_controller.dart';
import 'package:project_uas/utils/helpers/helper_function.dart';
import 'package:project_uas/utils/constants/colors.dart';
import 'package:project_uas/features/shop/screens/reservation/floating_screen/payment_sheet.dart';
import 'package:project_uas/features/shop/screens/reservation/reservation_history_screen.dart';
import 'package:project_uas/features/shop/models/layanan_model.dart';

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
    controller.loadLayanan();
  }

  @override
  Widget build(BuildContext context) {
    final dark = BHelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Reservasi", style: Theme.of(context).textTheme.headlineMedium),
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
            DropdownButtonFormField<LayananModel>(
              value: controller.selectedCapsterLayanan.value,
              decoration: InputDecoration(
                labelText: 'Pilih Capster',
                labelStyle: TextStyle(color: dark ? Colors.white : Colors.black),
                floatingLabelStyle: TextStyle(color: dark ? Colors.white : Colors.black),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: dark ? Colors.white : Colors.black, width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: dark ? Colors.white : Colors.black, width: 2),
                ),
              ),
              dropdownColor: dark ? Colors.grey[900] : Colors.white,
              iconEnabledColor: dark ? Colors.white : Colors.black,
              items: controller.layananList.map((layanan) {
                return DropdownMenuItem(
                  value: layanan,
                  child: Text(
                    layanan.name,
                    style: TextStyle(color: dark ? Colors.white : Colors.black),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                controller.selectedCapsterLayanan.value = value;
                controller.selectedPackage.value = null;

                if (controller.selectedDate.value != null) {
                  controller.loadDisabledSlots();
                }
              },
            ),

            const SizedBox(height: 16),

            /// Dropdown Paket
            if (controller.selectedCapsterLayanan.value != null)
              DropdownButtonFormField<String>(
                value: controller.selectedPackage.value,
                decoration: InputDecoration(
                  labelText: 'Paket Potong',
                  labelStyle: TextStyle(color: dark ? Colors.white : Colors.black),
                  floatingLabelStyle: TextStyle(color: dark ? Colors.white : Colors.black),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: dark ? Colors.white : Colors.black, width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: dark ? Colors.white : Colors.black, width: 2),
                  ),
                ),
                dropdownColor: dark ? Colors.grey[900] : Colors.white,
                items: controller.selectedCapsterLayanan.value!.packages.map<DropdownMenuItem<String>>((pkg) {
                  return DropdownMenuItem(
                    value: pkg['name'],
                    child: Text(pkg['name'], style: TextStyle(color: dark ? Colors.white : Colors.black)),
                  );
                }).toList(),
                onChanged: (value) {
                  controller.selectedPackage.value = value;
                },
              ),

            /// Harga Paket
            if (controller.selectedPackage.value != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 16),
                child: Text(
                  "Harga: Rp ${controller.selectedCapsterLayanan.value!.packages.firstWhere((p) => p['name'] == controller.selectedPackage.value)['price']}",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),

            /// Pilih Tanggal
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
                  initialDate: controller.selectedDate.value ?? DateTime.now(),
                );
                if (date != null) {
                  controller.selectedDate.value = date;
                  controller.loadDisabledSlots();
                }
              },
            ),

            const SizedBox(height: 16),

            /// Grid Jam
            if (controller.selectedCapsterLayanan.value != null &&
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
                              color: dark
                                  ? isDisabled
                                      ? Colors.white38
                                      : isSelected
                                          ? Colors.white
                                          : Colors.blue
                                  : isDisabled
                                      ? Colors.white38
                                      : isSelected
                                          ? Colors.white
                                          : Colors.blueAccent,
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

            /// Tombol Lanjut ke Pembayaran
            Obx(() {
              final isReady = controller.selectedCapsterLayanan.value != null &&
                              controller.selectedPackage.value != null &&
                              controller.selectedDate.value != null &&
                              controller.selectedTime.value != null;

              if (!isReady) return const SizedBox();

              return ElevatedButton(
                onPressed: isReady
                    ? () async {
                        final result = await showModalBottomSheet<bool>(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (_) => const PaymentSheet(),
                        );

                        if (result == true) {
                          controller.submitReservation();
                        }
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isReady ? Colors.blueAccent : Colors.grey,
                  foregroundColor: Colors.white,
                  elevation: 4,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.qr_code_2_rounded, size: 24),
                    SizedBox(width: 10),
                    Text(
                      "Lanjut ke Pembayaran",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              );
            }),
          ],
        )),
      ),
    );
  }
}
