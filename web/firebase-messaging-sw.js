importScripts("https://www.gstatic.com/firebasejs/9.6.10/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/9.6.10/firebase-messaging-compat.js");

// todo Copy/paste firebaseConfig from Firebase Console
const firebaseConfig = {
  apiKey: "AIzaSyBlB11BhuLeBc1Bp0nH6AQZU2poF7p_qqs",
  authDomain: "purrfectmatch-abdb0.firebaseapp.com",
  projectId: "purrfectmatch-abdb0",
  storageBucket: "purrfectmatch-abdb0.appspot.com",
  messagingSenderId: "93586848241",
  appId: "1:93586848241:web:860e1128080a49a5fcec50",
  measurementId: "G-HHFRLBHMH4"
};

firebase.initializeApp(firebaseConfig);
const messaging = firebase.messaging();

// todo Set up background message handler
messaging.onBackgroundMessage((message) => {
 console.log("onBackgroundMessage", message);
});