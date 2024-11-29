import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monscolis/core/widgets/error_view.dart';
import 'package:monscolis/core/widgets/loading_overlay.dart';
import 'package:monscolis/features/home/presentation/bloc/home_bloc.dart';
import 'package:monscolis/features/home/presentation/widgets/store_card.dart';
import 'package:monscolis/features/home/presentation/widgets/upcoming_appointment_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc()..add(LoadHomeData()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('MonsColis'),
          actions: [
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () => Navigator.pushNamed(context, '/profile'),
            ),
          ],
        ),
        body: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeError) {
              return ErrorView(
                message: state.message,
                onRetry: () {
                  context.read<HomeBloc>().add(LoadHomeData());
                },
              );
            }

            return LoadingOverlay(
              isLoading: state is HomeLoading,
              child: RefreshIndicator(
                onRefresh: () async {
                  context.read<HomeBloc>().add(LoadHomeData());
                },
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (state is HomeLoaded) ...[
                        if (state.nextAppointment != null) ...[
                          Text(
                            'Upcoming Appointment',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          UpcomingAppointmentCard(
                            appointment: state.nextAppointment!,
                            onCancel: () {
                              context.read<HomeBloc>().add(
                                    CancelAppointment(state.nextAppointment!['id']),
                                  );
                            },
                          ),
                          const SizedBox(height: 24),
                        ],
                        Text(
                          'Available Stores',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.stores.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 16),
                          itemBuilder: (context, index) {
                            final store = state.stores[index];
                            return StoreCard(
                              store: store,
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  '/store',
                                  arguments: store,
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: 'Appointments',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.folder),
              label: 'Documents',
            ),
          ],
          onTap: (index) {
            switch (index) {
              case 1:
                Navigator.pushNamed(context, '/appointments');
                break;
              case 2:
                Navigator.pushNamed(context, '/documents');
                break;
            }
          },
        ),
      ),
    );
  }
}
