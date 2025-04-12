import 'package:affinity/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:affinity/core/theme/app_pallete.dart';
import 'package:affinity/core/utils/calculate_post_time.dart';
import 'package:affinity/core/utils/format_date.dart';
import 'package:affinity/features/event/data/models/event_model.dart';
import 'package:affinity/features/event/domain/entities/event.dart';
import 'package:affinity/features/event/presentation/pages/edit_event_page.dart';
import 'package:affinity/features/event/presentation/widgets/event_interact_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'event_page.dart';

class EventViewerPage extends StatelessWidget {
  static route(Event event) => MaterialPageRoute(
        builder: (context) => EventViewerPage(
          event: event,
        ),
      );
  final Event event;
  const EventViewerPage({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    final user = (context.read<AppUserCubit>().state as AppUserLoggedIn).user;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              EventPage.route(),
              (route) => false,
            );
          },
          icon: Icon(Icons.arrow_back),
        ),
        actions: [
          if (event.posterId == user.id || user.isAdmin)
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        EditEventPage(event: event as EventModel),
                  ),
                );
              },
              child: const Text(
                "Edit",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          EventInteractButton(
            event: event,
          )
        ],
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'By ${event.posterName}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '${formatDateBydMMMYYYY(event.updatedAt)} . ${getTimeAgo(event.updatedAt.toString())}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: AppPallete.greyColor,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 20),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(event.imageUrl),
                ),
                const SizedBox(height: 20),
                Text(
                  event.content,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 2,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
