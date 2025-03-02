class Api {
  static const host = "http://185.123.187.135:9090";

  static const getSaveToken = '$host/api/notification/token-save';
  static const getDeleteToken = '$host/api/notification/token-delete';
  static const getInstitution = '$host/api/institution/only';
  static const getInstitutionData = '$host/api/institution';
  static const getScheduleData = '$host/api/schedule';
  static const getReplacementData = '$host/api/schedule/replacement';
  static const getTeacherReplacementData = '$host/api/replacements/teacher';
  static const getTeacherData = '$host/api/teacher';
  static const getHistoryReplacement = '$host/api/replacement/history';
}
