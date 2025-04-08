import 'package:affinity/features/event/data/models/event_model.dart';
import 'package:hive/hive.dart';

abstract interface class EventLocalDataSource {
  void uploadLocalEvents({required List<EventModel> events});
  List<EventModel> loadEvents();
}

class EventLocalDataSourceImpl implements EventLocalDataSource {
  final Box box;
  EventLocalDataSourceImpl(this.box);

  @override
  List<EventModel> loadEvents() {
    List<EventModel> blogs = [];
    box.read(() {
      for (int i = 0; i < box.length; i++) {
        blogs.add(EventModel.fromJson(box.get(i.toString())));
      }
    });

    return blogs;
  }

  @override
  void uploadLocalEvents({required List<EventModel> events}) {
    box.clear();

    box.write(() {
      for (int i = 0; i < events.length; i++) {
        box.put(i.toString(), events[i].toJson());
      }
    });
  }
}
