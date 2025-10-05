// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  //TODO here you have enter other user's ID to whom you are calling.
  final TextEditingController singleInviteeUserIDTextCtrl =
      TextEditingController(text: "Parent");

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            // Positioned(
            //   top: 20,
            //   right: 10,
            //   child: logoutButton(),
            // ),
            const Positioned(
              top: 50,
              left: 10,
              right: 10,
              child: Center(
                child: Text(
                  //TODO to show only that what is your id for calling. you can remove if want
                  'Your are in Child Flow',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            userListView(),
          ],
        ),
      ),
    );
  }

  Widget userListView() {
    return Center(
      child: sendCallButton(
        isVideoCall: true,
        inviteeUsersIDTextCtrl: singleInviteeUserIDTextCtrl,
        onCallFinished: onSendCallInvitationFinished,
      ),
    );
  }

  void onSendCallInvitationFinished(
    String code,
    String message,
    List<String> errorInvitees,
  ) {
    if (errorInvitees.isNotEmpty) {
      var userIDs = '';
      for (var index = 0; index < errorInvitees.length; index++) {
        if (index >= 5) {
          userIDs += '... ';
          break;
        }

        final userID = errorInvitees.elementAt(index);
        userIDs += '$userID ';
      }
      if (userIDs.isNotEmpty) {
        userIDs = userIDs.substring(0, userIDs.length - 1);
      }

      var message = "User doesn't exist or is offline: $userIDs";
      if (code.isNotEmpty) {
        message += ', code: $code, message:$message';
      }
      showToast(
        message,
        position: StyledToastPosition.top,
        context: context,
      );
    } else if (code.isNotEmpty) {
      showToast(
        'code: $code, message:$message',
        position: StyledToastPosition.top,
        context: context,
      );
    }
  }
}

Widget sendCallButton({
  required bool isVideoCall,
  required TextEditingController inviteeUsersIDTextCtrl,
  void Function(String code, String message, List<String>)? onCallFinished,
}) {
  return ValueListenableBuilder<TextEditingValue>(
    valueListenable: inviteeUsersIDTextCtrl,
    builder: (context, inviteeUserID, _) {
      final invitees =
          getInvitesFromTextCtrl(inviteeUsersIDTextCtrl.text.trim());

      return ZegoSendCallInvitationButton(
        isVideoCall: isVideoCall,
        invitees: invitees,
        resourceID: 'easyVideoCall',
        iconSize: const Size(200, 200),
        icon: ButtonIcon(
            icon: Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Colors.blue.shade900),
                child: const Center(
                  child: Text(
                    "Call To Parent",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            backgroundColor: Colors.white),
        buttonSize: const Size(250, 250),
        onPressed: onCallFinished,
      );
    },
  );
}

List<ZegoUIKitUser> getInvitesFromTextCtrl(String textCtrlText) {
  final invitees = <ZegoUIKitUser>[];

  final inviteeIDs = textCtrlText.trim().replaceAll('，', '');
  inviteeIDs.split(',').forEach((inviteeUserID) {
    if (inviteeUserID.isEmpty) {
      return;
    }

    invitees.add(ZegoUIKitUser(
      id: inviteeUserID,
      name: 'user_$inviteeUserID',
    ));
  });

  return invitees;
}
