import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_uas/common/widgets/appbar/appbar.dart';
import 'package:project_uas/features/shop/controllers/reservation_controller.dart';
import 'package:project_uas/features/shop/models/reservation_model.dart';

class AdminConfirmReservationScreen extends StatefulWidget {
  const AdminConfirmReservationScreen({super.key});

  @override
  State<AdminConfirmReservationScreen> createState() => _AdminConfirmReservationScreenState();
}

class _AdminConfirmReservationScreenState extends State<AdminConfirmReservationScreen> {
  final controller = ReservationController.instance;

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final ValueNotifier<String> _searchQueryNotifier = ValueNotifier('');
  String selectedFilter = 'all';
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: BAppBar(
        showBackArrow: true,
        title: Text('Konfirmasi Reservasi', style: theme.textTheme.headlineSmall),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) => setState(() => selectedFilter = value),
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'all', child: Text('Semua')),
              PopupMenuItem(value: 'pending', child: Text('Pending')),
              PopupMenuItem(value: 'approved', child: Text('Approved')),
              PopupMenuItem(value: 'cancelled', child: Text('Cancelled')),
            ],
            icon: Icon(
              Icons.filter_alt_rounded,
              color: theme.brightness == Brightness.dark ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
      body: StreamBuilder<List<ReservationModel>>(
        stream: controller.fetchAllReservationsForAdminStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final allData = snapshot.data ?? [];
          final filteredByStatus = selectedFilter == 'all'
              ? allData
              : allData.where((r) => r.status.toLowerCase() == selectedFilter).toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔎 Search Bar
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
                child: TextField(
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                  onChanged: (value) => _searchQueryNotifier.value = value.toLowerCase(),
                  decoration: InputDecoration(
                    hintText: 'Cari nama capster...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              _searchQueryNotifier.value = '';
                              FocusScope.of(context).unfocus();
                            },
                          )
                        : null,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),

              // 📅 Filter Tanggal
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        selectedDate != null
                            ? 'Tanggal: ${DateFormat('dd MMM yyyy', 'id').format(selectedDate!)}'
                            : 'Filter tanggal: Tidak dipilih',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    TextButton.icon(
                      icon: const Icon(Icons.date_range),
                      label: const Text('Pilih Tanggal'),
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate ?? DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) setState(() => selectedDate = picked);
                      },
                    ),
                    if (selectedDate != null)
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => setState(() => selectedDate = null),
                      ),
                  ],
                ),
              ),

              // 🧠 Reaktif berdasarkan ValueNotifier
              ValueListenableBuilder<String>(
                valueListenable: _searchQueryNotifier,
                builder: (context, searchQuery, _) {
                  final filteredData = filteredByStatus.where((item) {
                    final matchCapster = item.capster.toLowerCase().contains(searchQuery);
                    final matchDate = selectedDate == null
                        ? true
                        : item.datetime.year == selectedDate!.year &&
                            item.datetime.month == selectedDate!.month &&
                            item.datetime.day == selectedDate!.day;
                    return matchCapster && matchDate;
                  }).toList()
                    ..sort((a, b) => b.datetime.compareTo(a.datetime)); // ⬅️ urutkan dari terbaru

                  return Expanded(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total: ${filteredData.length} reservasi ditemukan',
                                style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                              ),
                              if (searchQuery.isNotEmpty || selectedDate != null || selectedFilter != 'all')
                                TextButton.icon(
                                  onPressed: () {
                                    setState(() {
                                      selectedDate = null;
                                      _searchController.clear();
                                      selectedFilter = 'all';
                                    });
                                    _searchQueryNotifier.value = '';
                                  },
                                  icon: const Icon(Icons.refresh),
                                  label: const Text('Reset'),
                                ),
                            ],
                          ),
                        ),
                        const Divider(height: 1),
                        if (filteredData.isEmpty)
                          const Expanded(child: Center(child: Text('Tidak ada reservasi ditemukan.')))
                        else
                          Expanded(
                            child: ListView.separated(
                              padding: const EdgeInsets.all(16),
                              separatorBuilder: (_, __) => const SizedBox(height: 12),
                              itemCount: filteredData.length,
                              itemBuilder: (context, index) {
                                final item = filteredData[index];
                                final status = item.status.toLowerCase();

                                return Material(
                                  elevation: 3,
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: theme.cardColor,
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${item.capster} - ${item.packageType}',
                                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 4),
                                        Text('User ID: ${item.userId}',
                                            style: const TextStyle(fontSize: 13, color: Colors.grey)),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            const Icon(Icons.access_time, size: 16, color: Colors.grey),
                                            const SizedBox(width: 4),
                                            Text(
                                              DateFormat('EEEE, dd MMM yyyy – HH:mm', 'id')
                                                  .format(item.datetime),
                                              style: TextStyle(color: Colors.grey[700]),
                                            ),
                                            const Spacer(),
                                            Chip(
                                              label: Text(
                                                status == 'pending'
                                                    ? 'Menunggu'
                                                    : status == 'approved'
                                                        ? 'Disetujui'
                                                        : 'Dibatalkan',
                                                style: const TextStyle(color: Colors.white),
                                              ),
                                              backgroundColor: status == 'approved'
                                                  ? Colors.green
                                                  : status == 'pending'
                                                      ? Colors.orange
                                                      : Colors.redAccent,
                                            ),
                                          ],
                                        ),
                                        if (item.proofUrl != null && item.proofUrl!.isNotEmpty)
                                          Padding(
                                            padding: const EdgeInsets.only(top: 12.0),
                                            child: GestureDetector(
                                              onTap: () => showDialog(
                                                context: context,
                                                builder: (_) => Dialog(
                                                  child: InteractiveViewer(
                                                    child: Image.network(item.proofUrl!),
                                                  ),
                                                ),
                                              ),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(8),
                                                child: Image.network(item.proofUrl!, height: 90),
                                              ),
                                            ),
                                          ),
                                        const SizedBox(height: 16),
                                        if (status == 'pending') ...[
                                          Row(
                                            children: [
                                              Expanded(
                                                child: ElevatedButton.icon(
                                                  icon: const Icon(Icons.check),
                                                  onPressed: () => controller.updateReservationStatus(
                                                      item.docId, 'approved'),
                                                  style: ElevatedButton.styleFrom(
                                                      backgroundColor: Colors.green),
                                                  label: const Text('Konfirmasi'),
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: OutlinedButton.icon(
                                                  icon: const Icon(Icons.cancel),
                                                  onPressed: () => controller.updateReservationStatus(
                                                      item.docId, 'cancelled'),
                                                  style: OutlinedButton.styleFrom(
                                                    foregroundColor: Colors.redAccent,
                                                    side: const BorderSide(color: Colors.redAccent),
                                                  ),
                                                  label: const Text('Batalkan'),
                                                ),
                                              ),
                                            ],
                                          )
                                        ] else if (status == 'approved') ...[
                                          SizedBox(
                                            width: double.infinity,
                                            child: OutlinedButton.icon(
                                              icon: const Icon(Icons.cancel),
                                              onPressed: () => controller.updateReservationStatus(
                                                  item.docId, 'cancelled'),
                                              style: OutlinedButton.styleFrom(
                                                foregroundColor: Colors.redAccent,
                                                side: const BorderSide(color: Colors.redAccent),
                                              ),
                                              label: const Text('Batalkan Reservasi'),
                                            ),
                                          )
                                        ],
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
