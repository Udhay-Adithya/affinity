import 'dart:developer';
import 'dart:io';

import 'package:affinity/core/error/exceptions.dart';
import 'package:affinity/features/blog/data/models/event_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class EventRemoteDataSource {
  Future<EventModel> uploadEvent(EventModel event);
  Future<String> uploadEventImage({
    required File image,
    required EventModel event,
  });
  Future<List<EventModel>> getAllEvents();

  Future<void> joinEvent();
  Future<void> leaveEvent();
}

class EventRemoteDataSourceImpl implements EventRemoteDataSource {
  final SupabaseClient supabaseClient;
  EventRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<EventModel> uploadEvent(EventModel event) async {
    try {
      final blogData =
          await supabaseClient.from('events').insert(event.toJson()).select();

      return EventModel.fromJson(blogData.first);
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
  Future<void> joinEvent() async {
    try {} on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> leaveEvent() async {
    try {} on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
