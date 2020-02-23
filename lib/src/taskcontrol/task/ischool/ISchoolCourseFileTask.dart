import 'package:flutter/cupertino.dart';
import 'package:flutter_app/generated/i18n.dart';
import 'package:flutter_app/src/connector/ISchoolConnector.dart';
import 'package:flutter_app/src/store/Model.dart';
import 'package:flutter_app/src/store/json/CourseFileJson.dart';
import 'package:flutter_app/src/taskcontrol/task/CheckCookiesTask.dart';
import 'package:flutter_app/src/taskcontrol/task/TaskModel.dart';
import 'package:flutter_app/ui/other/ErrorDialog.dart';
import 'package:flutter_app/ui/other/MyProgressDialog.dart';

class ISchoolCourseFileTask extends TaskModel {
  static final String taskName =
      "ISchoolCourseFileTask" + CheckCookiesTask.checkISchool;
  final String courseId;
  static String courseFileListTempKey = "ISchoolCourseFileTempKey";
  ISchoolCourseFileTask(BuildContext context, this.courseId)
      : super(context, taskName);

  @override
  Future<TaskStatus> taskStart() async {
    MyProgressDialog.showProgressDialog(
        context, S.current.getISchoolCourseFile);
    List<CourseFileJson> value = await ISchoolConnector.getCourseFile(courseId);
    MyProgressDialog.hideProgressDialog();
    if (value != null) {
      Model.instance.setTempData(courseFileListTempKey, value);
      return TaskStatus.TaskSuccess;
    } else {
      _handleError();
      return TaskStatus.TaskFail;
    }
  }

  void _handleError() {
    ErrorDialogParameter parameter = ErrorDialogParameter(
      context: context,
      desc: S.current.getISchoolCourseFileError,
    );
    ErrorDialog(parameter).show();
  }
}
