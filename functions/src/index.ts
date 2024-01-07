/**
 * Import function triggers from their respective submodules:
 *
 * import {onCall} from "firebase-functions/v2/https";
 * import {onDocumentWritten} from "firebase-functions/v2/firestore";
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

import {onRequest} from "firebase-functions/v2/https";
import * as logger from "firebase-functions/logger";
import * as admin from "firebase-admin";
import * as functions from "firebase-functions";
import {DocumentData} from "firebase-admin/firestore";

admin.initializeApp();

export const makeCall = functions.firestore
  .document("Calls/{id}")
  .onCreate(async (callSnapshot) => {
    const call = callSnapshot.data();
    let callerData: DocumentData;
    let tokens: string | string[] = [];
    const users = admin.firestore().collection("Users").get();
    users
      .then((usersSnapshot) => {
        usersSnapshot.forEach(async (userDoc) => {
          const user = userDoc.data();
          if (user.uid == call.caller) {
            callerData = user;
          }
          if (user.uid == call.called) {
            tokens = user.tokens;
          }
        });
      })
      .then(async (doc) => {
        if (call.active == true) {
          const callPayload = {
            data: {
              user: callerData.uid,
              name: callerData.name,
              email: callerData.email,
              id: call.uid,
              channel: call.channel,
              caller: call.caller,
              called: call.called,
              active: call.active.toString(),
              accepted: call.accepted.toString(),
              rejected: call.rejected.toString(),
              connected: call.connected.toString(),
            },
          };
          await admin.messaging().sendToDevice(tokens, callPayload);
        }
      });
  });

// Start writing functions
// https://firebase.google.com/docs/functions/typescript

// export const helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
