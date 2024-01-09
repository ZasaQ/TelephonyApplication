import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import {DocumentData} from "firebase-admin/firestore";

admin.initializeApp();

export const makeCall = functions.firestore
  .document("Calls/{id}")
  .onCreate(async (callSnapshot) => {
    const call = callSnapshot.data();
    let callerData: DocumentData;
    let tokens: string;
    const users = admin.firestore().collection("Users").get();
    users
      .then((usersSnapshot) => {
        usersSnapshot.forEach(async (userDoc) => {
          const user = userDoc.data();
          if (user.email == call.caller) {
            callerData = user;
          }
          if (user.email == call.called) {
            tokens = user.token;
          }
        });
      })
      .then(async () => {
        if (call.active == true) {
          const callPayload = {
            data: {
              uid: callerData.uid,
              name: callerData.name,
              email: callerData.email,
              id: call.id,
              channel: call.channel,
              caller: call.caller,
              called: call.called,
              active: call.active.toString(),
              accepted: call.accepted.toString(),
              rejected: call.rejected.toString(),
              connected: call.connected.toString(),
            },
            token: tokens,
          };
          functions.logger.log("Debug info caller: "+call.caller);
          functions.logger.log("Debug info called: "+call.called);
          functions.logger.log("Debug info tokens: "+tokens);
          await admin.messaging().send(callPayload);
        }
      });
  });
