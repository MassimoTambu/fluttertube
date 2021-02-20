import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static const _requiredPermissions = [Permission.storage];

  static void getRequiredPermissions() {
    _requiredPermissions.forEach((p) async {
      final isGranted = await p.isGranted;
      if (!isGranted) {
        await p.request();
      }
    });
  }
}
