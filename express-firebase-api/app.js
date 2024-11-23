// Importações necessárias
const express = require("express");
const admin = require("firebase-admin");
const cors = require("cors");
const bcrypt = require("bcrypt");

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

  if (!email || !senha || !telefone || !nome) {
    return res.status(400).send({ error: "Dados incompletos!" });
  }

  try {
    // Hashear a senha
    const senhaHash = await bcrypt.hash(senha, 10);

    // Adicionar usuário com senha hasheada
    const docRef = await db.collection("usuarios").add({
      email,
      senha: senhaHash, // Salva a senha como hash
      telefone,
      nome,
    });

    res.status(201).send({
      message: "Usuário cadastrado com sucesso!",
      id: docRef.id,
    });
  } catch (error) {
    console.error("Erro ao salvar no Firestore:", error);
    res.status(500).send({ error: "Erro ao salvar no Firestore." });
  }
});


//Atualizar senhas Firestore

const atualizarSenhas = async () => {
  const usuarios = await db.collection("usuarios").get();

  usuarios.forEach(async (doc) => {
    const usuario = doc.data();

    if (usuario.senha && !usuario.senha.startsWith("$2b$")) {
      // Hashear a senha se ela ainda não estiver hasheada
      const senhaHash = await bcrypt.hash(usuario.senha, 10);

      // Atualizar a senha no Firestore
      await db.collection("usuarios").doc(doc.id).update({ senha: senhaHash });
      console.log(`Senha do usuário ${doc.id} atualizada para hash.`);
    }
  });
};

atualizarSenhas();

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


// Rota Autenticar-Login

app.post("/login", async (req, res) => {
  const { email, senha } = req.body;

  if (!email || !senha) {
    return res.status(400).send({ error: "E-mail e senha são obrigatórios!" });
  }

  try {
    const emailNormalizado = email.toLowerCase().trim();
    const usuarios = await db.collection("usuarios").where("email", "==", emailNormalizado).get();

    if (usuarios.empty) {
      console.log("Nenhum usuário encontrado com este e-mail:", emailNormalizado);
      return res.status(401).send({ error: "E-mail ou senha inválidos!" });
    }

    const usuarioDoc = usuarios.docs[0];
    const usuario = usuarioDoc.data();
    console.log("Usuário encontrado:", usuario);

    if (!usuario.senha) {
      console.error("Senha ausente no banco de dados.");
      return res.status(500).send({ error: "Erro no servidor." });
    }

    console.log("Senha fornecida:", senha);
    console.log("Senha armazenada:", usuario.senha);

    const senhaValida = await bcrypt.compare(senha, usuario.senha);

    if (!senhaValida) {
      console.log("Senha inválida para o e-mail:", emailNormalizado);
      return res.status(401).send({ error: "E-mail ou senha inválidos!" });
    }

    const jwt = require("jsonwebtoken");
    const token = jwt.sign({ id: usuarioDoc.id }, "sua_chave_secreta", { expiresIn: "1h" });

    res.status(200).send({
      message: "Login realizado com sucesso!",
      token,
      usuario: {
        id: usuarioDoc.id,
        email: usuario.email,
        nome: usuario.nome,
      },
    });
  } catch (error) {
    console.error("Erro ao autenticar:", error);
    res.status(500).send({ error: "Erro ao autenticar." });
  }
});

// Porta do servidor
const PORT = 8080;
app.listen(PORT, () => {
  console.log(`Servidor rodando em http://localhost:${PORT}`);
});