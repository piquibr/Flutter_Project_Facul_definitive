// Import the functions you need from the SDKs you need
import { initializeApp } from "firebase/app";
import { getFirestore } from "firebase/firestore";

import { getAnalytics } from "firebase/analytics";
// TODO: Add SDKs for Firebase products that you want to use
// https://firebase.google.com/docs/web/setup#available-libraries

// Your web app's Firebase configuration
// For Firebase JS SDK v7.20.0 and later, measurementId is optional
const firebaseConfig = {
  apiKey: "AIzaSyAq9fhnLycQGqhieg3isiU2uSStZEbphM8",
  authDomain: "todoolistnv.firebaseapp.com",
  projectId: "todoolistnv",
  storageBucket: "todoolistnv.firebasestorage.app",
  messagingSenderId: "346458540439",
  appId: "1:346458540439:web:c787c2a96721608c711cd2"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const analytics = getAnalytics(app);
const db = getFirestore(app);
module.exports = db;