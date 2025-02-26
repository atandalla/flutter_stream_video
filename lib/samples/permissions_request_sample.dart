import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

class PermissionRequestsExample extends StatefulWidget {
  const PermissionRequestsExample({super.key, required this.call});

  final Call call;

  @override
  State<PermissionRequestsExample> createState() =>
      _PermissionRequestsExampleState();
}

class _PermissionRequestsExampleState extends State<PermissionRequestsExample> {
  bool canSpeak = false;

  Future<void> startCall() async {
    await widget.call.getOrCreate();
    await widget.call.goLive();
    canSpeak = widget.call.state.value.ownCapabilities
        .contains(CallPermission.sendAudio);
  }

  Future<void> endCall() async {
    await widget.call.stopLive();
    await widget.call.end();
  }

  @override
  void initState() {
    super.initState();
    startCall();

    /// The [onPermissionRequest] handler can be used to be notified of new requests from users in the call.
    /// [CoordinatorCallPermissionRequestEvent] contains the user requesting permissions along with a list
    /// containing the different capabilities they would like granted.
    widget.call.onPermissionRequest =
        (CoordinatorCallPermissionRequestEvent permissionRequestEvent) {
      final uid = permissionRequestEvent.user.id;

      /// For more complex applications, a user may request one or more permission at the same time. In those cases,
      /// the full range of permissions can be retrieved from the `permissions` list.
      final permission = permissionRequestEvent.permissions;
      grantSpeakingPermission(uid);
    };
  }

  @override
  void dispose() {
    endCall();
    super.dispose();
  }

  /// To request permissions, the [Call] object includes the method [requestPermissions]
  /// which allows us to pass a list of [CallPermission] we would like granted during the call.
  Future<void> requestSpeakingPermission() async {
    await widget.call.requestPermissions([CallPermission.sendAudio]);
  }

  /// Once a permission request is received, it can be granted using [grantPermissions] or revoked using [revokePermissions]
  Future<void> grantSpeakingPermission(String userID) async {
    await widget.call.grantPermissions(
      userId: userID,
      permissions: [CallPermission.sendAudio],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Permission Requests Example'),
        actions: [
          canSpeak
              ? IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.request_page),
                )
              : IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.mic),
                )
        ],
      ),
      body: StreamBuilder<CallState>(
        stream: widget.call.state.valueStream,
        initialData: widget.call.state.value,
        builder: (context, snapshot) {
          return StreamCallContent(
            call: widget.call,
            callState: snapshot.data!,
            callAppBarBuilder: (context, call, callState) =>
                const PreferredSize(
              preferredSize: Size.zero,
              child: SizedBox(),
            ),
          );
        },
      ),
    );
  }
}
