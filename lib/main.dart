import 'dart:math';

import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';
import 'env/env.dart';
import 'samples/audio_indicator.dart';
import 'samples/network_quality_indicator.dart';
import 'samples/participant_list.dart';
import 'samples/permissions_request_sample.dart';
import 'samples/reactions_sample.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    final client = StreamVideo(
      'mxnvhja9tnsg',
      user: User.regular(userId: '1318396', name: 'Anthony Dev Papi'),
      userToken:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiMTMxODM5NiJ9.n-bDoBsBuWjGm4OfRcFvXNJNBoBNHGGmsi_S2sihJg4',
      options: const StreamVideoOptions(
        logPriority: Priority.info,
      ),
    );

    final call = client.makeCall(
      callType: StreamCallType(),
      id: 'default_28311ec8-343d-4a74-9bb8-6f15f2663793',
    );

    //await call.getOrCreate(memberIds: ['Kevin']);
    await call.join();

    runApp(
      MaterialApp(
        home: DemoAppHome(
          call: call,
        ),
      ),
    );
  } catch (e) {
    print('Error initializing Stream client: $e');
  }
}

class DemoAppHome extends StatelessWidget {
  const DemoAppHome({Key? key, required this.call}) : super(key: key);

  final Call call;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamCallContainer(
        call: call,
        callContentBuilder: (context, call, callState) {
          return StreamCallContent(
            call: call,
            callState: callState,
            callControlsBuilder: (context, call, callState) {
              final localParticipant = callState.localParticipant!;
              return StreamCallControls(
                options: [
                  CallControlOption(
                    icon: const Text('👋'),
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Hello'),
                      ),
                    ),
                  ),
                  FlipCameraOption(
                    call: call,
                    localParticipant: localParticipant,
                  ),
                  LeaveCallOption(call: call, onLeaveCallTap: call.leave),
                ],
              );
            },
          );
        },
      ),
    );
  }
}


// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   /// Initialize Stream Video SDK.
// StreamVideo.create(
//     Env.streamVideoApiKey,
//     user: User.guest(userId: '1318396'),
//   );

//   await StreamVideo.instance.connect(
//     // const UserInfo(
//     //   id: Env.sampleUserId00,
//     //   role: Env.sampleUserRole00,
//     //   name: Env.sampleUserName00,
//     //   image: Env.sampleUserImage00,
//     // ),
//     // Env.sampleUserVideoToken00,
//   );

//   runApp(const UICookbook());
// }

// class UICookbook extends StatelessWidget {
//   const UICookbook({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'UI Cookbook',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: HomeScreen(),
//     );
//   }
// }

// class HomeScreen extends StatelessWidget {
//   HomeScreen({super.key});

//   final _chars = 'abcdefghijklmnopqrstuvwxyz1234567890';
//   final _rnd = Random();

//   Future<Call> generateCall(String type, String id) async {
//     final call = StreamVideo.instance.makeCall(
//       type: type,
//       id: id,
//     );
//     await call.getOrCreate();

//     return call;
//   }

//   String generateAlphanumericString(int length) => String.fromCharCodes(
//         Iterable.generate(
//           length,
//           (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length)),
//         ),
//       );

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('UI Cookbook'),
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           OptionButton(
//             onPressed: () async {
//               final call = await generateCall(
//                 'default',
//                 generateAlphanumericString(10),
//               );

//               Navigator.of(context).push(
//                 MaterialPageRoute(
//                   builder: (_) {
//                     return ParticipantListScreen(
//                       call: call,
//                     );
//                   },
//                 ),
//               );
//             },
//             label: 'Participant List',
//           ),
//           OptionButton(
//             onPressed: () async {
//               final call = await generateCall(
//                 'audio_room',
//                 generateAlphanumericString(10),
//               );

//               Navigator.of(context).push(
//                 MaterialPageRoute(
//                   builder: (_) {
//                     return PermissionRequestsExample(
//                       call: call,
//                     );
//                   },
//                 ),
//               );
//             },
//             label: 'Permission Requests',
//           ),
//           OptionButton(
//             onPressed: () async {
//               final call = await generateCall(
//                 'default',
//                 generateAlphanumericString(10),
//               );

//               Navigator.of(context).push(
//                 MaterialPageRoute(
//                   builder: (_) {
//                     return ReactionsExample(
//                       call: call,
//                     );
//                   },
//                 ),
//               );
//             },
//             label: 'Reactions',
//           ),
//           OptionButton(
//             onPressed: () async {
//               final call = await generateCall(
//                 'default',
//                 generateAlphanumericString(10),
//               );

//               Navigator.of(context).push(
//                 MaterialPageRoute(
//                   builder: (_) {
//                     return AudioIndicatorExample(
//                       call: call,
//                     );
//                   },
//                 ),
//               );
//             },
//             label: 'Audio Indicator',
//           ),
//           OptionButton(
//             onPressed: () async {
//               final call = await generateCall(
//                 'default',
//                 generateAlphanumericString(10),
//               );

//               Navigator.of(context).push(
//                 MaterialPageRoute(
//                   builder: (_) {
//                     return NetworkQualityIndicatorExample(
//                       call: call,
//                     );
//                   },
//                 ),
//               );
//             },
//             label: 'Network Quality Indicator',
//           ),
//         ],
//       ),
//     );
//   }
// }

// class OptionButton extends StatelessWidget {
//   const OptionButton({super.key, required this.onPressed, required this.label});

//   final VoidCallback onPressed;
//   final String label;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: ElevatedButton(
//         onPressed: onPressed,
//         child: Text(label),
//       ),
//     );
//   }
// }
