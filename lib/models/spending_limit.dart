enum SpendingLimitType {
  every,
  only,
  all
}
class SpendingLimit {
  SpendingLimitType duration;
  DateTime? dateTime;
  int? dayOfWeek;
  double value;
  SpendingLimit({this.duration = SpendingLimitType.all, this.dateTime, required this.value, this.dayOfWeek});
}