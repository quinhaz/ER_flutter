-- script_schema.sql
CREATE DATABASE IF NOT EXISTS gri CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE gri;

-- USERS
CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(150) NOT NULL,
  email VARCHAR(200) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  role ENUM('Padre','Administracao','Fiel','Voluntario','Gestao') NOT NULL DEFAULT 'Fiel',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- CELEBRATIONS
CREATE TABLE celebrations (
  id INT AUTO_INCREMENT PRIMARY KEY,
  type ENUM('Batismo','Casamento','Obito') NOT NULL,
  date DATE NOT NULL,
  details TEXT,
  signed_by_user_id INT NULL,
  signed_at DATETIME NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_celebration_padre FOREIGN KEY (signed_by_user_id) REFERENCES users(id) ON DELETE SET NULL
);

-- DOCUMENTS
CREATE TABLE documents (
  id INT AUTO_INCREMENT PRIMARY KEY,
  celebration_id INT NOT NULL,
  owner_user_id INT NOT NULL, -- fiel
  type VARCHAR(150) NOT NULL,
  fee_amount DECIMAL(10,2) DEFAULT 0.00,
  fee_status ENUM('Pendente','Pago') NOT NULL DEFAULT 'Pendente',
  file_path VARCHAR(300) NULL, -- path on server when generated
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_doc_celebration FOREIGN KEY (celebration_id) REFERENCES celebrations(id) ON DELETE CASCADE,
  CONSTRAINT fk_doc_owner FOREIGN KEY (owner_user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- PAYMENTS / TRANSACTIONS
CREATE TABLE payments (
  id INT AUTO_INCREMENT PRIMARY KEY,
  document_id INT NOT NULL,
  user_id INT NOT NULL, -- quem pagou
  amount DECIMAL(10,2) NOT NULL,
  method VARCHAR(100) NOT NULL,
  provider_status ENUM('Pending','Confirmed','Rejected') NOT NULL DEFAULT 'Pending',
  provider_reference VARCHAR(200) NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  confirmed_at DATETIME NULL,
  CONSTRAINT fk_payment_document FOREIGN KEY (document_id) REFERENCES documents(id) ON DELETE CASCADE,
  CONSTRAINT fk_payment_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
