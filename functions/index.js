const {onDocumentCreated} = require("firebase-functions/v2/firestore");
const {initializeApp} = require("firebase-admin/app");
const {getFirestore, FieldValue} = require("firebase-admin/firestore");

initializeApp();
const db = getFirestore();

exports.bootstrapUser = onDocumentCreated("user/{uid}", async (event) => {
  const uid = event.params.uid;
  const snap = event.data;
  if (!snap) return;

  const userData = snap.data() || {};
  const email = userData.email;

  if (!email) {
    throw new Error("User doc created without email.");
  }

  const userRef = db.collection("user").doc(uid);
  const now = FieldValue.serverTimestamp();
  const batch = db.batch();

  // Asegura username=email y timestamps (sin romper lo ya creado)
  batch.set(userRef, {
    email,
    username: email,
    updatedAt: now,
    createdAt: now,
  }, {merge: true});

  const lists = [
    {id: "favorites", name: "Favorites"},
    {id: "watched", name: "Watched"},
    {id: "watchlist", name: "Watchlist"},
  ];

  for (const l of lists) {
    batch.set(
        userRef.collection("list").doc(l.id),
        {
          name: l.name,
          type: "system",
          createdAt: now,
          updatedAt: now,
        },
        {merge: true},
    );
  }

  await batch.commit();
});
