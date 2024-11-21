// Importações necessárias
const express = require("express");
const admin = require("firebase-admin");

const app = express();

// Inicialize o Firebase Admin com a chave privada
const serviceAccount = require("./google-services.json");

admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
});

// Obtenha a referência do Firestore
const db = admin.firestore();

// Middleware para lidar com JSON
app.use(express.json());

// Rota para adicionar um teste ao Firestore
app.post("/api/addTest", async (req, res) => {
    const { testKey, testValue } = req.body;

    try {
        // Salva o dado no Firestore na coleção "tests"
        const docRef = await db.collection("tests").add({
            testKey,
            testValue,
            createdAt: new Date(),
        });

        res.status(201).json({
            message: "Documento adicionado com sucesso",
            id: docRef.id,
        });
    } catch (error) {
        console.error("Erro ao adicionar documento:", error.message);
        res.status(500).json({ error: "Erro ao salvar o documento no Firestore" });
    }
});

// Rota de teste
app.get("/", (req, res) => {
    res.send("Bem-vindo ao backend com Node.js e Express!");
});

// Porta do servidor
const PORT = 3000;
app.listen(PORT, () => {
    console.log(`Servidor rodando em http://localhost:${PORT}`);
});
