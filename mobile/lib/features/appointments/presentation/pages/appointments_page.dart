import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monscolis/core/widgets/error_view.dart';
import 'package:monscolis/core/widgets/loading_overlay.dart';
import 'package:monscolis/features/appointments/presentation/bloc/appointments_bloc.dart';
import 'package:monscolis/features/appointments/presentation/widgets/appointment_list_item.dart';

class AppointmentsPage extends StatelessWidget {
  const AppointmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppointmentsBloc()..add(LoadAppointments()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Appointments'),
        ),
        body: BlocBuilder<AppointmentsBloc, AppointmentsState>(
          builder: (context, state) {
            if (state is AppointmentsError) {
              return ErrorView(
                message: state.message,
                onRetry: () {
                  context.read<AppointmentsBloc>().add(LoadAppointments());
                },
              );
            }

            return LoadingOverlay(
              isLoading: state is AppointmentsLoading,
              child: RefreshIndicator(
                onRefresh: () async {
                  context.read<AppointmentsBloc>().add(LoadAppointments());
                },
                child: CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.all(16.0),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          if (state is AppointmentsLoaded) ...[
                            if (state.upcomingAppointments.isEmpty &&
                                state.pastAppointments.isEmpty)
                              Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.calendar_today_outlined,
                                      size: 64,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'No appointments yet',
                                      style:
                                          Theme.of(context).textTheme.titleLarge,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Book an appointment with a store to get started',
                                      style: Theme.of(context).textTheme.bodyLarge,
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              )
                            else ...[
                              if (state.upcomingAppointments.isNotEmpty) ...[
                                Text(
                                  'Upcoming',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                const SizedBox(height: 8),
                                ...state.upcomingAppointments.map(
                                  (appointment) => Padding(
                                    padding: const EdgeInsets.only(bottom: 16.0),
                                    child: AppointmentListItem(
                                      appointment: appointment,
                                      onCancel: () {
                                        context.read<AppointmentsBloc>().add(
                                              CancelAppointment(
                                                appointment['id'],
                                              ),
                                            );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                              if (state.pastAppointments.isNotEmpty) ...[
                                const SizedBox(height: 24),
                                Text(
                                  'Past',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                const SizedBox(height: 8),
                                ...state.pastAppointments.map(
                                  (appointment) => Padding(
                                    padding: const EdgeInsets.only(bottom: 16.0),
                                    child: AppointmentListItem(
                                      appointment: appointment,
                                      isPast: true,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ],
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.pushNamed(context, '/stores');
          },
          icon: const Icon(Icons.add),
          label: const Text('Book Appointment'),
        ),
      ),
    );
  }
}
