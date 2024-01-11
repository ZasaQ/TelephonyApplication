import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'package:telephon_application/models/call_model.dart';
import 'package:telephon_application/services/agora_settings.dart';
import 'package:telephon_application/models/user_model.dart';
import 'package:telephon_application/services/utils.dart';


class CallPage extends StatefulWidget {
  final UserModel user;
  CallModel callHandler;
  
  CallPage({super.key, required this.user, required this.callHandler});

  @override
  State<CallPage> createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  RtcEngine? rtcEngine;
  String? token;
  int uid = 0;
  bool localUserJoined = false;
  String? callID;
  String? channelName;
  int? remoteUid;
  AgoraClient? agoraClient;

  @override
  void initState() {
    setState(() {
      callID = widget.callHandler.id;
      rtcEngine = createAgoraRtcEngine();
    });

    super.initState();

    Future.delayed(const Duration(milliseconds: 1000)).then(
      (_) {
        getToken();
      },
    );
  }

  @override
  void dispose() {
    rtcEngine!.release();
    rtcEngine!.leaveChannel();
    super.dispose();
  }

  Future<void> getToken() async {
    final response = await http.get(Uri.parse(
        '$tokenBaseUrl/rtc/${widget.callHandler.channel}/publisher/userAccount/$uid?expiry=600'));
    if (response.statusCode == 200) {
      setState(() {
        token = jsonDecode(response.body)['rtcToken'];
      });
      initializeCall();
    }
  }

  Future<void> initializeCall() async {
    await [Permission.microphone, Permission.camera].request();

    await rtcEngine?.initialize(const RtcEngineContext(appId: appID));

    await rtcEngine?.enableVideo();

    rtcEngine?.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (connection, elapsed) {
          setState(() {
            localUserJoined = true;
          });
          if (widget.callHandler.id == null) {
            makeCall();
          }
        },
        onUserJoined: (connection, _remoteUid, elapsed) {
          setState(() {
            remoteUid = _remoteUid;
          });
          callsCollection.doc(widget.callHandler.id).update(
            {
              'accepted': true,
            },
          );
        },
        onLeaveChannel: (connection, stats) {
          callsCollection.doc(widget.callHandler.id).update(
            {
              'active': false,
            },
          );
          Navigator.pop(context);
        },
        onUserOffline: (connection, _remoteUid, reason) {
          setState(() {
            remoteUid = null;
          });
          rtcEngine?.leaveChannel();
          rtcEngine?.release();
          Navigator.pop(context);
          callsCollection.doc(widget.callHandler.id).update(
            {
              'active': false,
            },
          );
        },
        onVideoStopped: () {
          rtcEngine?.disableVideo();
        },
      ),
    );

    await joinVideoChannel();
  }

  makeCall() async {
    DocumentReference callDocRef = callsCollection.doc();
    setState(() {
      callID = callDocRef.id;
    });
    await callDocRef.set(
      {
        'id': callDocRef.id,
        'channel': widget.callHandler.channel,
        'caller': widget.callHandler.caller,
        'called': widget.callHandler.called,
        'active': true,
        'accepted': false,
        'rejected': false,
        'connected': false,
        'activationDate': widget.callHandler.activationDate
      },
    );
  }

  Future joinVideoChannel() async {
    await rtcEngine?.startPreview();

    ChannelMediaOptions options = const ChannelMediaOptions(
      clientRoleType: ClientRoleType.clientRoleBroadcaster,
      channelProfile: ChannelProfileType.channelProfileCommunication,
    );

    await rtcEngine?.joinChannel(
        token: token!,
        channelId: widget.callHandler.channel,
        uid: uid,
        options: options);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Text(
            "Calling ${widget.user.name}",
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        body: localUserJoined == false || callID == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : StreamBuilder<DocumentSnapshot>(
                stream: callsCollection.doc(callID!).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    widget.callHandler = CallModel(
                      id: snapshot.data!['id'],
                      channel: snapshot.data!['channel'],
                      caller: snapshot.data!['caller'],
                      called: snapshot.data!['called'],
                      active: snapshot.data!['active'],
                      accepted: snapshot.data!['accepted'],
                      rejected: snapshot.data!['rejected'],
                      connected: snapshot.data!['connected'],
                      activationDate: snapshot.data!['activationDate']
                    );

                    agoraClient = AgoraClient(
                      agoraConnectionData: AgoraConnectionData(
                        appId: appID, 
                        channelName: widget.callHandler.channel
                        )
                      );

                    return widget.callHandler.rejected == true
                        ? Center(child: const Text("Call Declined"))
                        : Stack(
                            children: [
                              //Remote user's video widget
                              Center(
                                child: remoteVideo(callHandler: widget.callHandler),
                              ),
                              //Local user's video widget
                              if (rtcEngine != null)
                                Positioned.fill(
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: SizedBox(
                                      width: 100,
                                      height: 150,
                                      child: AgoraVideoView(
                                        controller: VideoViewController(
                                          rtcEngine: rtcEngine!,
                                          canvas: VideoCanvas(uid: uid),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                AgoraVideoButtons(client: agoraClient!,),
                            ],
                          );
                  }
                  return const SizedBox.shrink();
                },
              ),
      ),
    );
  }

  Widget remoteVideo({required CallModel callHandler}) {
    return Stack(
      children: [
        if (remoteUid != null)
          AgoraVideoView(
            controller: VideoViewController.remote(
              rtcEngine: rtcEngine!,
              canvas: VideoCanvas(uid: remoteUid),
              connection: RtcConnection(channelId: callHandler.channel),
            ),
          ),
        if (remoteUid == null)
          Positioned.fill(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(callHandler.connected == false
                            ? "Connecting to ${widget.user.name}"
                            : "Waiting Response"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text('Channel name: ${widget.callHandler.channel}')
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text('Token: ${token.toString()}')
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}