class Api {
  static const host = "https://sched-master-e01d5e11fc47.herokuapp.com";

  static const getSaveToken = '$host/api/notification/token-save';
  static const getDeleteToken = '$host/api/notification/token-delete';
  static const getInstitution = '$host/api/institution/only';
  static const getInstitutionData = '$host/api/institution';
  static const getScheduleData = '$host/api/schedule';
  static const getReplacementData = '$host/api/schedule/replacement';
  static const getTeacherReplacementData = '$host/api/teacher/replacement';
  static const getTeacherData = '$host/api/teacher';
  static const getHistoryReplacement = '$host/api/replacement/history';
}
