import 'package:affinity/features/blog/data/models/event_model.dart';
import 'package:hive/hive.dart';

abstract interface class EventLocalDataSource {
  void uploadLocalBlogs({required List<EventModel> blogs});
  List<EventModel> loadBlogs();
}

class EventLocalDataSourceImpl implements EventLocalDataSource {
  final Box box;
  EventLocalDataSourceImpl(this.box);

  @override
  List<EventModel> loadBlogs() {
    List<EventModel> blogs = [];
    box.read(() {
      for (int i = 0; i < box.length; i++) {
        blogs.add(EventModel.fromJson(box.get(i.toString())));
      }
    });

    return blogs;
  }

  @override
  void uploadLocalBlogs({required List<EventModel> blogs}) {
    box.clear();

    box.write(() {
      for (int i = 0; i < blogs.length; i++) {
        box.put(i.toString(), blogs[i].toJson());
      }
    });
  }
}
