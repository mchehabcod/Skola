enum SchoolNoteKind { absence, early }

class SchoolNote {
  final String id;
  final SchoolNoteKind kind;
  final String title;
  final String date;
  final String status;
  final String? time;
  final String? teacherNote;
  final bool isToday;

  const SchoolNote({
    required this.id,
    required this.kind,
    required this.title,
    required this.date,
    required this.status,
    this.time,
    this.teacherNote,
    this.isToday = false,
  });
}
