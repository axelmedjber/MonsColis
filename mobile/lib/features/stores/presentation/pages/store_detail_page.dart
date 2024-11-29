import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monscolis/core/widgets/error_view.dart';
import 'package:monscolis/core/widgets/loading_overlay.dart';
import 'package:monscolis/features/stores/presentation/bloc/store_detail_bloc.dart';
import 'package:monscolis/features/stores/presentation/widgets/store_info_section.dart';
import 'package:monscolis/features/stores/presentation/widgets/time_slot_picker.dart';
import 'package:intl/intl.dart';

class StoreDetailPage extends StatefulWidget {
  final String storeId;

  const StoreDetailPage({
    super.key,
    required this.storeId,
  });

  @override
  State<StoreDetailPage> createState() => _StoreDetailPageState();
}

class _StoreDetailPageState extends State<StoreDetailPage> {
  DateTime? selectedDate;
  DateTime? selectedSlot;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          StoreDetailBloc()..add(LoadStoreDetail(widget.storeId)),
      child: BlocConsumer<StoreDetailBloc, StoreDetailState>(
        listener: (context, state) {
          if (state is BookingSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Appointment booked successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          } else if (state is StoreDetailError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is StoreDetailError) {
            return Scaffold(
              appBar: AppBar(),
              body: ErrorView(
                message: state.message,
                onRetry: () {
                  context
                      .read<StoreDetailBloc>()
                      .add(LoadStoreDetail(widget.storeId));
                },
              ),
            );
          }

          if (state is StoreDetailLoaded) {
            final store = state.store;
            return Scaffold(
              appBar: AppBar(
                title: Text(store['name']),
              ),
              body: LoadingOverlay(
                isLoading: state is StoreDetailLoading,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      StoreInfoSection(store: store),
                      const Divider(height: 32),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Book an Appointment',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 16),
                            _buildDatePicker(context),
                            if (selectedDate != null) ...[
                              const SizedBox(height: 24),
                              TimeSlotPicker(
                                availableSlots: state.availableSlots ?? [],
                                selectedSlot: selectedSlot,
                                onSlotSelected: (slot) {
                                  setState(() {
                                    selectedSlot = slot;
                                  });
                                },
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: selectedSlot != null
                  ? SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ElevatedButton(
                          onPressed: () {
                            context.read<StoreDetailBloc>().add(
                                  BookAppointment(
                                    storeId: widget.storeId,
                                    dateTime: selectedSlot!,
                                  ),
                                );
                          },
                          child: const Text('Confirm Appointment'),
                        ),
                      ),
                    )
                  : null,
            );
          }

          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Date',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 30)),
              selectableDayPredicate: (date) {
                // Disable weekends if the store is closed
                return date.weekday < 6;
              },
            );

            if (date != null) {
              setState(() {
                selectedDate = date;
                selectedSlot = null;
              });

              if (!mounted) return;
              context.read<StoreDetailBloc>().add(
                    LoadAvailableSlots(
                      storeId: widget.storeId,
                      date: date,
                    ),
                  );
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedDate == null
                      ? 'Choose a date'
                      : DateFormat('EEEE, MMMM d').format(selectedDate!),
                ),
                const Icon(Icons.calendar_today),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
