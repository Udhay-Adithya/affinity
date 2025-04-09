import 'dart:developer';

import 'package:affinity/core/common/widgets/loader.dart';
import 'package:affinity/core/theme/app_pallete.dart';
import 'package:affinity/core/utils/show_snackbar.dart';
import 'package:affinity/features/event/presentation/bloc/event_bloc.dart';
import 'package:affinity/features/event/presentation/pages/add_new_event_page.dart';
import 'package:affinity/features/event/presentation/widgets/event_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EventPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const EventPage(),
      );
  const EventPage({super.key});

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  @override
  void initState() {
    super.initState();
    context.read<EventBloc>().add(BlogFetchAllBlogs());
  }

  Future<void> _onRefresh() async {
    context.read<EventBloc>().add(BlogFetchAllBlogs());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Affinity',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, AddNewEventPage.route());
            },
            icon: const Icon(
              CupertinoIcons.add_circled,
            ),
          ),
        ],
      ),
      body: BlocConsumer<EventBloc, EventState>(
        listener: (context, state) {
          if (state is EventFailure) {
            log(state.error);
            showSnackBar(context, state.error);
          }
        },
        builder: (context, state) {
          if (state is EventLoading) {
            return const Loader();
          }
          if (state is EventsDisplaySuccess) {
            return RefreshIndicator.adaptive(
              onRefresh: _onRefresh,
              child: ListView.builder(
                itemCount: state.event.length,
                itemBuilder: (context, index) {
                  final blog = state.event[index];
                  return EventCard(
                    blog: blog,
                    color: index % 2 == 0
                        ? AppPallete.gradient1
                        : AppPallete.gradient2,
                  );
                },
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
