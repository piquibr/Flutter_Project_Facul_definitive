// app.js
const express = require("express");
const admin = require("firebase-admin");

// Inicialize o app Firebase com a chave privada do projeto
const serviceAccount = require("./google-services.json");

admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
    databaseURL: "https://ToDoList.firebaseio.com"
});

const db = admin.firestore();
const app = express();
const PORT = 3000;

app.use(express.json());

// Rota para adicionar um documento ao Firestore
app.post("/api/addData", async (req, res) => {
    const { collection, data } = req.body;
    try {
        const docRef = await db.collection(collection).add(data);
        res.status(200).json({ id: docRef.id });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Rota para recuperar um documento do Firestore
app.get("/api/getData/:collection/:id", async (req, res) => {
    const { collection, id } = req.params;
    try {
        const doc = await db.collection(collection).doc(id).get();
        if (!doc.exists) {
            return res.status(404).json({ message: "Documento não encontrado" });
        }
        res.status(200).json(doc.data());
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

app.listen(PORT, () => {
    console.log(`Servidor Express rodando em http://localhost:${PORT}`);
});