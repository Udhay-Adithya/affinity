import 'dart:developer';
import 'dart:io';

import 'package:affinity/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:affinity/core/common/widgets/loader.dart';
import 'package:affinity/core/constants/constants.dart';
import 'package:affinity/core/theme/app_pallete.dart';
import 'package:affinity/core/utils/pick_image.dart';
import 'package:affinity/core/utils/show_snackbar.dart';
import 'package:affinity/features/event/data/models/event_model.dart';
import 'package:affinity/features/event/domain/entities/event.dart';
import 'package:affinity/features/event/presentation/bloc/event_bloc.dart';
import 'package:affinity/features/event/presentation/pages/event_viewer_page.dart';
import 'package:affinity/features/event/presentation/widgets/event_editor.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditEventPage extends StatefulWidget {
  final EventModel event;
  const EditEventPage({super.key, required this.event});

  @override
  State<EditEventPage> createState() => _EditEventPageState();
}

class _EditEventPageState extends State<EditEventPage> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final membersLimitController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  List<String> selectedTopics = [];
  File? image;
  late Event updatedEvent;

  @override
  void initState() {
    super.initState();
    titleController.text = widget.event.title;
    contentController.text = widget.event.content;
    membersLimitController.text = widget.event.maxMembers.toString();
    selectedTopics = widget.event.topics;
  }

  void selectImage() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        image = pickedImage;
      });
    }
  }

  void updateEvent() {
    if (formKey.currentState!.validate() && selectedTopics.isNotEmpty) {
      final posterId =
          (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;
      updatedEvent = widget.event.copyWith(
        title: titleController.text.trim(),
        content: contentController.text.trim(),
        maxMembers: int.parse(membersLimitController.text.trim()),
        topics: selectedTopics,
      );

      log(posterId.toString());
      context.read<EventBloc>().add(
            UpdateEventEvent(
              event: updatedEvent,
            ),
          );
    }
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    contentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              updateEvent();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => EventViewerPage(event: updatedEvent),
                ),
                (route) => false,
              );
            },
            icon: const Icon(Icons.done_rounded),
          ),
        ],
      ),
      body: BlocConsumer<EventBloc, EventState>(
        listener: (context, state) {
          if (state is EventFailure) {
            showSnackBar(context, state.error);
          } else if (state is EventUploadSuccess) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (_) => EventViewerPage(event: updatedEvent),
              ),
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          if (state is EventLoading) {
            return const Loader();
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    image != null
                        ? GestureDetector(
                            onTap: selectImage,
                            child: SizedBox(
                              width: double.infinity,
                              height: 150,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  image!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          )
                        : GestureDetector(
                            onTap: () {
                              selectImage();
                            },
                            child: DottedBorder(
                              color: AppPallete.borderColor,
                              dashPattern: const [10, 4],
                              radius: const Radius.circular(10),
                              borderType: BorderType.RRect,
                              strokeCap: StrokeCap.round,
                              child: SizedBox(
                                height: 150,
                                width: double.infinity,
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.folder_open,
                                      size: 40,
                                    ),
                                    SizedBox(height: 15),
                                    Text(
                                      'Select your image',
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                    const SizedBox(height: 20),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: Constants.topics
                            .map(
                              (e) => Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: GestureDetector(
                                  onTap: () {
                                    if (selectedTopics.contains(e)) {
                                      selectedTopics.remove(e);
                                    } else {
                                      selectedTopics.add(e);
                                    }
                                    setState(() {});
                                  },
                                  child: Chip(
                                    label: Text(e),
                                    color: selectedTopics.contains(e)
                                        ? const WidgetStatePropertyAll(
                                            AppPallete.gradient1,
                                          )
                                        : null,
                                    side: selectedTopics.contains(e)
                                        ? null
                                        : const BorderSide(
                                            color: AppPallete.borderColor,
                                          ),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    EventEditor(
                      controller: titleController,
                      hintText: 'Event title',
                    ),
                    const SizedBox(height: 10),
                    EventEditor(
                      controller: contentController,
                      hintText: 'Event description',
                    ),
                    const SizedBox(height: 10),
                    EventEditor(
                      controller: membersLimitController,
                      hintText: 'Maximum Members Limit',
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
