import 'package:affinity/core/theme/app_pallete.dart';
import 'package:affinity/core/utils/calculate_post_time.dart';
import 'package:affinity/core/utils/format_date.dart';
import 'package:affinity/features/event/domain/entities/event.dart';
import 'package:flutter/material.dart';

class BlogViewerPage extends StatelessWidget {
  static route(Event event) => MaterialPageRoute(
        builder: (context) => BlogViewerPage(
          event: event,
        ),
      );
  final Event event;
  const BlogViewerPage({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          if (event.members.contains(event.posterId))
            TextButton(
              onPressed: () {},
              child: const Text(
                "Edit",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            )
          else
            TextButton(
              onPressed: () {},
              child: const Text(
                "Join",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
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
                  '${formatDateBydMMMYYYY(event.updatedAt)} . ${getTimeAgo(event.updatedAt.toString())} min',
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
