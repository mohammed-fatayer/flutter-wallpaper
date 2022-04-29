import 'package:flutterproject2/model/ad_helper.dart';
import 'package:in_app_update/in_app_update.dart';

AppUpdateInfo? _updateInfo;

class PlaystoreUpdate {
  static checkForUpdate() async {
    InAppUpdate.checkForUpdate().then((info) {
      _updateInfo = info;
      preformupdate();
    }).catchError((e) {
      // print(e.toString());
    });
  }

  static preformupdate() async {
    _updateInfo?.updateAvailability == UpdateAvailability.updateAvailable
        ? () {
            InAppUpdate.performImmediateUpdate().catchError((e) {
              // print(e.toString());
            });
          }
        : Adhelper.getappopenad();
  }
}
