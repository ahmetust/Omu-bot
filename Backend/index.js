const express = require('express');
const mysql = require('mysql');
const bodyParser = require('body-parser');
const cors = require('cors');
const ngrok = require('ngrok');

const app = express();
//const PORT = process.env.PORT || 8000;


app.use(bodyParser.json());
app.use(cors());

// MySQL bağlantı ayarları
const db = mysql.createConnection({
  host: 'localhost',
  user: 'root', // MySQL kullanıcı adı
  password: 'aDmin55', // MySQL kullanıcı şifresi
  database: 'omu_bot'
});

// Veritabanı bağlantısı
db.connect(err => {
  if (err) {
    console.error('Database connection failed:', err.stack);
    return;
  }
  console.log('Connected to database.');

  // Kullanıcı tablosunu oluşturma (eğer yoksa)
  const createUsersTable = `
    CREATE TABLE IF NOT EXISTS users (
      id INT AUTO_INCREMENT PRIMARY KEY,
      email VARCHAR(255) NOT NULL,
      password VARCHAR(255) NOT NULL,
      role ENUM('ADMIN', 'USER') NOT NULL DEFAULT 'USER'
    );
  `;

  db.query(createUsersTable, (err, result) => {
    if (err) throw err;
    console.log('Users table ensured.');

    // İlk admin kullanıcısını oluşturma
    const ensureAdminUser = `
      INSERT INTO users (email, password, role)
      SELECT * FROM (SELECT 'admin@example.com', 'adminpassword', 'ADMIN') AS tmp
      WHERE NOT EXISTS (
        SELECT email FROM users WHERE role = 'ADMIN'
      ) LIMIT 1;
    `;

    db.query(ensureAdminUser, (err, result) => {
      if (err) throw err;
      console.log('Initial admin user ensured.');
    });
  });
});

// Kullanıcı kaydı (herkes kayıt olabilir, rol USER olacak)
app.post('/register', (req, res) => {
  const { email, password } = req.body;

  db.query('INSERT INTO users (email, password, role) VALUES (?, ?, ?)', [email, password, 'USER'], (err, results) => {
    if (err) {
      return res.status(500).json({ message: 'User registration failed' });
    }
    res.status(201).json({ id: results.insertId });
  });
});

// Kullanıcı giriş
app.post('/login', (req, res) => {
  const { email, password } = req.body;

  db.query('SELECT id, role FROM users WHERE email = ? AND password = ?', [email, password], (err, results) => {
    if (err) {
      return res.status(500).json({ message: 'Login failed' });
    }
    if (results.length === 0) {
      return res.status(401).json({ message: 'Invalid email or password' });
    }
    res.json({ id: results[0].id, role: results[0].role });
  });
});

// Kullanıcı rolünü güncelleme (sadece admin tarafından yapılabilir)
app.put('/update-role', (req, res) => {
  const { userId, role } = req.body;
  const adminId = req.header('admin-id'); // Başlıkta admin ID kontrolü yapılacak

  db.query('SELECT role FROM users WHERE id = ?', [adminId], (err, results) => {
    if (err || results.length === 0 || results[0].role !== 'ADMIN') {
      return res.status(403).json({ message: 'Only admins can update roles' });
    }

    db.query('UPDATE users SET role = ? WHERE id = ?', [role, userId], (err, results) => {
      if (err) {
        return res.status(500).json({ message: 'Role update failed' });
      }
      res.status(200).json({ message: 'Role updated successfully' });
    });
  });
});

// Sunucuyu başlatma
const PORT = 3300;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
