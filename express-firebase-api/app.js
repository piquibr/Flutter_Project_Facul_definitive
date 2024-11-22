// Importações necessárias
const express = require("express");
const admin = require("firebase-admin");
const cors = require("cors");

// Inicialize o Firebase Admin com a chave privada
const serviceAccount = require("./google-services.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore(); // Obtém a referência do Firestore

const app = express();
app.use(cors()); // Permite requisições de origens diferentes (CORS)
app.use(express.json()); // Middleware para lidar com JSON

// Rota para adicionar um usuário ao Firestore
app.post("/api/addTest", async (req, res) => {
  const { email, senha, telefone, nome } = req.body;

  // Valida se todos os campos foram enviados
  if (!email || !senha || !telefone || !nome) {
    return res.status(400).send({ error: "Dados incompletos!" });
  }

  try {
    // Adiciona o documento à coleção "usuarios"
    const docRef = await db.collection("usuarios").add({
      email,
      senha,
      telefone,
      nome,
    });

    res.status(201).send({
      message: "Usuário cadastrado com sucesso!",
      id: docRef.id, // Retorna o ID do documento criado
    });
  } catch (error) {
    console.error("Erro ao salvar no Firestore:", error);
    res.status(500).send({ error: "Erro ao salvar no Firestore." });
  }
});

// Rota para adicionar um teste simples ao Firestore
app.post("/api/tist", async (req, res) => {
  try {
    const docRef = await db.collection("users").add({
      first: "Ada",
      last: "Lovelace",
      born: 1815,
    });

    console.log("Documento criado com ID:", docRef.id);
    res.status(201).send({
      message: "Documento adicionado com sucesso!",
      id: docRef.id,
    });
  } catch (error) {
    console.error("Erro ao adicionar documento:", error);
    res.status(500).send({ error: "Erro ao adicionar documento." });
  }
});

// Rota de teste
app.get("/", (req, res) => {
  res.send("Bem-vindo ao backend com Node.js e Express!");
});

// Porta do servidor
const PORT = 8080;
app.listen(PORT, () => {
  console.log(`Servidor rodando em http://localhost:${PORT}`);
});
