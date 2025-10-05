// Package imports:
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

/// on user login
void onUserLogin() {
  /// 4/5. initialized ZegoUIKitPrebuiltCallInvitationService when account is logged in or re-logged in
  ZegoUIKitPrebuiltCallInvitationService().init(
    appID: 444284985 /*input your AppID*/,
    appSign:
        "6cf30423f4fa68a345d3356a37b326104f1782493209c617ff450be3c3aa909b" /*input your AppSign*/,

    //TODO things to change id and name here and in the HOME_PAGE alse
    userID:
        "Son", //change the id like 1234 is my id then other user should have changed id like 12345,
    userName:
        "Son", //change the name like John is my name then other user should have changed name like Mike,
    plugins: [ZegoUIKitSignalingPlugin()],

    notificationConfig: ZegoCallInvitationNotificationConfig(
      androidNotificationConfig: ZegoCallAndroidNotificationConfig(
        showFullScreen: true,
        fullScreenBackgroundAssetURL: 'assets/image/call.png',
        callChannel: ZegoCallAndroidNotificationChannelConfig(
          channelID: "ZegoUIKit",
          channelName: "Call Notifications",
          sound: "call",
          icon: "call",
        ),
        missedCallChannel: ZegoCallAndroidNotificationChannelConfig(
          channelID: "MissedCall",
          channelName: "Missed Call",
          sound: "missed_call",
          icon: "missed_call",
          vibrate: false,
        ),
      ),
      iOSNotificationConfig: ZegoCallIOSNotificationConfig(
        systemCallingIconName: 'CallKitIcon',
      ),
    ),
    requireConfig: (ZegoCallInvitationData data) {
      final config = (data.invitees.length > 1)
          ? ZegoCallInvitationType.videoCall == data.type
              ? ZegoUIKitPrebuiltCallConfig.groupVideoCall()
              : ZegoUIKitPrebuiltCallConfig.groupVoiceCall()
          : ZegoCallInvitationType.videoCall == data.type
              ? ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
              : ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall();

      /// support minimizing, show minimizing button
      config.topMenuBar.isVisible = true;
      config.topMenuBar.buttons
          .insert(0, ZegoCallMenuBarButtonName.minimizingButton);
      config.topMenuBar.buttons
          .insert(1, ZegoCallMenuBarButtonName.soundEffectButton);

      return config;
    },
  );
}

/// on user logout
void onUserLogout() {
  /// 5/5. de-initialization ZegoUIKitPrebuiltCallInvitationService when account is logged out
  ZegoUIKitPrebuiltCallInvitationService().uninit();
}
