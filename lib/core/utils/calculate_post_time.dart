import 'package:timeago/timeago.dart' as timeago;

String getTimeAgo(String timestamp) {
  final dateTime = DateTime.parse(timestamp);
  return timeago.format(dateTime);
}
