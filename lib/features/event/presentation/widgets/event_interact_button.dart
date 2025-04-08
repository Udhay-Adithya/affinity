import 'package:affinity/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:affinity/core/utils/show_snackbar.dart';
import 'package:affinity/features/event/domain/entities/event.dart';
import 'package:affinity/features/event/presentation/bloc/event_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EventInteractButton extends StatelessWidget {
  final Event event;
  const EventInteractButton({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EventBloc, EventState>(
      listener: (context, state) {
        if (state is EventFailure) {
          showSnackBar(context, state.error);
        }
      },
      builder: (context, state) {
        return TextButton(
          onPressed: state is EventLoading
              ? null
              : () {
                  final userId =
                      (context.read<AppUserCubit>().state as AppUserLoggedIn)
                          .user
                          .id;
                  context.read<EventBloc>().add(EventJoinEvent(
                        event: event,
                        userId: userId,
                      ));
                },
          child: Text(
            state is EventLoading ? "Joining..." : "Join",
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        );
      },
    );
  }
}
