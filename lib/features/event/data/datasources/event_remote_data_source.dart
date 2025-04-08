import 'dart:developer';
import 'dart:io';

import 'package:affinity/core/error/exceptions.dart';
import 'package:affinity/features/event/data/models/event_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class EventRemoteDataSource {
  Future<EventModel> uploadEvent(EventModel event);
  Future<String> uploadEventImage({
    required File image,
    required EventModel event,
  });
  Future<List<EventModel>> getAllEvents();

  Future<EventModel> joinEvent(
      {required EventModel event, required String userId});
  Future<EventModel> leaveEvent(
      {required EventModel event, required String userId});
}

class EventRemoteDataSourceImpl implements EventRemoteDataSource {
  final SupabaseClient supabaseClient;
  EventRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<EventModel> uploadEvent(EventModel event) async {
    try {
      final eventData =
          await supabaseClient.from('events').insert(event.toJson()).select();

      return EventModel.fromJson(eventData.first);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> uploadEventImage({
    required File image,
    required EventModel event,
  }) async {
    try {
      await supabaseClient.storage.from('blog_images').upload(
            event.id,
            image,
          );

      return supabaseClient.storage.from('blog_images').getPublicUrl(
            event.id,
          );
    } on StorageException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<EventModel>> getAllEvents() async {
    try {
      final events =
          await supabaseClient.from('events').select('*, profiles (name)');
      log("Blogs: $events");
      return events
          .map(
            (blog) => EventModel.fromJson(blog).copyWith(
              posterName: blog['profiles']['name'],
            ),
          )
          .toList();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<EventModel> joinEvent(
      {required EventModel event, required String userId}) async {
    try {
      final List<String> currentMembers = event.members;
      log("Current Members: $currentMembers");
      log("User Id: $userId");
      log("Event Id: ${event.id}");
      if (!currentMembers.contains(userId)) {
        currentMembers.add(userId);
        final eventData = await supabaseClient
            .from('events')
            .update({'members_list': currentMembers})
            .eq('post_id', event.id)
            .select();
        log("Event Data: $eventData.");
        return EventModel.fromJson(eventData.first);
      } else {
        throw ServerException("You are already a member of this event");
      }
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } on ServerException catch (e) {
      log("Error: ${e.message}");
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<EventModel> leaveEvent(
      {required EventModel event, required String userId}) async {
    try {
      final List<String> currentMembers = event.members;
      if (currentMembers.contains(userId)) {
        currentMembers.remove(userId);
        final eventData = await supabaseClient
            .from('events')
            .update({'members_list': currentMembers})
            .eq('post_id', event.id)
            .select();
        return EventModel.fromJson(eventData.first);
      } else {
        throw ServerException("You are not a member of this event");
      }
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
