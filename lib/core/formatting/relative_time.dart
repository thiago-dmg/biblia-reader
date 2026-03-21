import 'package:intl/intl.dart';

String formatRelativeTime(DateTime t) {
  final now = DateTime.now();
  final d = now.difference(t);
  if (d.inSeconds < 45) return 'agora';
  if (d.inMinutes < 60) return 'há ${d.inMinutes} min';
  if (d.inHours < 24) return 'há ${d.inHours} h';
  if (d.inDays < 7) return 'há ${d.inDays} d';
  return DateFormat('dd/MM/yyyy').format(t);
}
