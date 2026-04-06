import 'job_model.dart';

class NotificationModel {
  final JobModel job;
  final bool isUnread;

  NotificationModel({
    required this.job,
    required this.isUnread,
  });

  NotificationModel copyWith({
    JobModel? job,
    bool? isUnread,
  }) {
    return NotificationModel(
      job: job ?? this.job,
      isUnread: isUnread ?? this.isUnread,
    );
  }
}
