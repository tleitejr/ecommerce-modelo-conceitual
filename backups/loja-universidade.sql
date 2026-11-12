-- MySQL dump 10.13  Distrib 8.0.46, for Linux (x86_64)
--
-- Host: localhost    Database: loja
-- ------------------------------------------------------
-- Server version	8.0.46

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `loja`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `loja` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `loja`;

--
-- Table structure for table `CLIENTE`
--

DROP TABLE IF EXISTS `CLIENTE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `CLIENTE` (
  `id_cliente` bigint unsigned NOT NULL AUTO_INCREMENT,
  `email` varchar(255) NOT NULL,
  `telefone` varchar(20) DEFAULT NULL,
  `data_cadastro` date NOT NULL,
  PRIMARY KEY (`id_cliente`),
  UNIQUE KEY `uk_cliente_email` (`email`),
  KEY `idx_cliente_data_cadastro` (`data_cadastro`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CLIENTE`
--

LOCK TABLES `CLIENTE` WRITE;
/*!40000 ALTER TABLE `CLIENTE` DISABLE KEYS */;
/*!40000 ALTER TABLE `CLIENTE` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_cliente_before_delete` BEFORE DELETE ON `CLIENTE` FOR EACH ROW BEGIN
    DECLARE v_tipo     VARCHAR(20)  DEFAULT 'NAO_CLASSIFICADO';
    DECLARE v_nome     VARCHAR(200) DEFAULT NULL;
    DECLARE v_cpf      CHAR(11)     DEFAULT NULL;
    DECLARE v_razao    VARCHAR(200) DEFAULT NULL;
    DECLARE v_fantasia VARCHAR(200) DEFAULT NULL;
    DECLARE v_cnpj     CHAR(14)     DEFAULT NULL;

    IF EXISTS (SELECT 1 FROM PESSOA_FISICA WHERE id_cliente = OLD.id_cliente) THEN
        SELECT nome_completo, cpf
          INTO v_nome, v_cpf
          FROM PESSOA_FISICA
         WHERE id_cliente = OLD.id_cliente;
        SET v_tipo = 'PF';

    ELSEIF EXISTS (SELECT 1 FROM PESSOA_JURIDICA WHERE id_cliente = OLD.id_cliente) THEN
        SELECT razao_social, nome_fantasia, cnpj
          INTO v_razao, v_fantasia, v_cnpj
          FROM PESSOA_JURIDICA
         WHERE id_cliente = OLD.id_cliente;
        SET v_tipo = 'PJ';
    END IF;

    INSERT INTO CLIENTE_EXCLUIDO
        (id_cliente_original, email, telefone, data_cadastro,
         tipo_pessoa, nome_completo, cpf, razao_social, nome_fantasia, cnpj)
    VALUES
        (OLD.id_cliente, OLD.email, OLD.telefone, OLD.data_cadastro,
         v_tipo, v_nome, v_cpf, v_razao, v_fantasia, v_cnpj);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `CLIENTE_EXCLUIDO`
--

DROP TABLE IF EXISTS `CLIENTE_EXCLUIDO`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `CLIENTE_EXCLUIDO` (
  `id_exclusao` bigint unsigned NOT NULL AUTO_INCREMENT,
  `id_cliente_original` bigint unsigned NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `telefone` varchar(20) DEFAULT NULL,
  `data_cadastro` date DEFAULT NULL,
  `tipo_pessoa` enum('PF','PJ','NAO_CLASSIFICADO') NOT NULL DEFAULT 'NAO_CLASSIFICADO',
  `nome_completo` varchar(200) DEFAULT NULL,
  `cpf` char(11) DEFAULT NULL,
  `razao_social` varchar(200) DEFAULT NULL,
  `nome_fantasia` varchar(200) DEFAULT NULL,
  `cnpj` char(14) DEFAULT NULL,
  `data_exclusao` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_exclusao`),
  KEY `idx_ce_cliente` (`id_cliente_original`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CLIENTE_EXCLUIDO`
--

LOCK TABLES `CLIENTE_EXCLUIDO` WRITE;
/*!40000 ALTER TABLE `CLIENTE_EXCLUIDO` DISABLE KEYS */;
INSERT INTO `CLIENTE_EXCLUIDO` VALUES (1,1,'teste.exclusao@exemplo.com','11999999999','2026-11-12','PF','Cliente Excluído Teste','99988877766',NULL,NULL,NULL,'2026-11-12 12:33:56');
/*!40000 ALTER TABLE `CLIENTE_EXCLUIDO` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `DEVOLUCAO`
--

DROP TABLE IF EXISTS `DEVOLUCAO`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `DEVOLUCAO` (
  `id_devolucao` bigint unsigned NOT NULL AUTO_INCREMENT,
  `id_item_pedido` bigint unsigned NOT NULL,
  `data_solicitacao` date NOT NULL,
  `quantidade_solicitada` int unsigned NOT NULL,
  `status_devolucao` varchar(30) NOT NULL,
  PRIMARY KEY (`id_devolucao`),
  KEY `idx_dev_item` (`id_item_pedido`),
  KEY `idx_devolucao_status_data` (`status_devolucao`,`data_solicitacao`) USING BTREE,
  CONSTRAINT `fk_dev_item` FOREIGN KEY (`id_item_pedido`) REFERENCES `ITEM_PEDIDO` (`id_item_pedido`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `DEVOLUCAO`
--

LOCK TABLES `DEVOLUCAO` WRITE;
/*!40000 ALTER TABLE `DEVOLUCAO` DISABLE KEYS */;
/*!40000 ALTER TABLE `DEVOLUCAO` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ENDERECO_CLIENTE`
--

DROP TABLE IF EXISTS `ENDERECO_CLIENTE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ENDERECO_CLIENTE` (
  `id_endereco_cliente` bigint unsigned NOT NULL AUTO_INCREMENT,
  `id_cliente` bigint unsigned NOT NULL,
  `logradouro` varchar(200) NOT NULL,
  `numero` varchar(20) DEFAULT NULL,
  `complemento` varchar(100) DEFAULT NULL,
  `bairro` varchar(100) DEFAULT NULL,
  `cidade` varchar(100) NOT NULL,
  `uf` char(2) DEFAULT NULL,
  `cep` char(8) DEFAULT NULL,
  `pais` varchar(80) NOT NULL DEFAULT 'Brasil',
  PRIMARY KEY (`id_endereco_cliente`),
  KEY `idx_ec_cliente` (`id_cliente`),
  CONSTRAINT `fk_ec_cliente` FOREIGN KEY (`id_cliente`) REFERENCES `CLIENTE` (`id_cliente`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ENDERECO_CLIENTE`
--

LOCK TABLES `ENDERECO_CLIENTE` WRITE;
/*!40000 ALTER TABLE `ENDERECO_CLIENTE` DISABLE KEYS */;
/*!40000 ALTER TABLE `ENDERECO_CLIENTE` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ENDERECO_ENTREGA`
--

DROP TABLE IF EXISTS `ENDERECO_ENTREGA`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ENDERECO_ENTREGA` (
  `id_endereco_entrega` bigint unsigned NOT NULL AUTO_INCREMENT,
  `id_pedido` bigint unsigned NOT NULL,
  `logradouro` varchar(200) NOT NULL,
  `numero` varchar(20) DEFAULT NULL,
  `complemento` varchar(100) DEFAULT NULL,
  `bairro` varchar(100) DEFAULT NULL,
  `cidade` varchar(100) NOT NULL,
  `uf` char(2) DEFAULT NULL,
  `cep` char(8) DEFAULT NULL,
  `pais` varchar(80) NOT NULL DEFAULT 'Brasil',
  PRIMARY KEY (`id_endereco_entrega`),
  UNIQUE KEY `uk_ee_pedido` (`id_pedido`),
  CONSTRAINT `fk_ee_pedido` FOREIGN KEY (`id_pedido`) REFERENCES `PEDIDO` (`id_pedido`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ENDERECO_ENTREGA`
--

LOCK TABLES `ENDERECO_ENTREGA` WRITE;
/*!40000 ALTER TABLE `ENDERECO_ENTREGA` DISABLE KEYS */;
/*!40000 ALTER TABLE `ENDERECO_ENTREGA` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ENTREGA`
--

DROP TABLE IF EXISTS `ENTREGA`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ENTREGA` (
  `id_entrega` bigint unsigned NOT NULL AUTO_INCREMENT,
  `id_pedido` bigint unsigned NOT NULL,
  `status_entrega` varchar(30) NOT NULL,
  `codigo_rastreio` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id_entrega`),
  KEY `idx_entrega_pedido` (`id_pedido`),
  KEY `idx_entrega_status` (`status_entrega`) USING BTREE,
  CONSTRAINT `fk_entrega_pedido` FOREIGN KEY (`id_pedido`) REFERENCES `PEDIDO` (`id_pedido`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ENTREGA`
--

LOCK TABLES `ENTREGA` WRITE;
/*!40000 ALTER TABLE `ENTREGA` DISABLE KEYS */;
/*!40000 ALTER TABLE `ENTREGA` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ESTOQUE`
--

DROP TABLE IF EXISTS `ESTOQUE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ESTOQUE` (
  `id_estoque` bigint unsigned NOT NULL AUTO_INCREMENT,
  `nome_local` varchar(150) NOT NULL,
  `descricao_local` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id_estoque`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ESTOQUE`
--

LOCK TABLES `ESTOQUE` WRITE;
/*!40000 ALTER TABLE `ESTOQUE` DISABLE KEYS */;
/*!40000 ALTER TABLE `ESTOQUE` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ESTORNO`
--

DROP TABLE IF EXISTS `ESTORNO`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ESTORNO` (
  `id_estorno` bigint unsigned NOT NULL AUTO_INCREMENT,
  `id_pagamento` bigint unsigned NOT NULL,
  `data_estorno` date NOT NULL,
  `valor_estornado` decimal(12,2) NOT NULL,
  `motivo` varchar(255) DEFAULT NULL,
  `status_estorno` varchar(30) NOT NULL,
  PRIMARY KEY (`id_estorno`),
  KEY `idx_estorno_pagamento` (`id_pagamento`),
  KEY `idx_estorno_status_data` (`status_estorno`,`data_estorno`) USING BTREE,
  CONSTRAINT `fk_estorno_pagamento` FOREIGN KEY (`id_pagamento`) REFERENCES `PAGAMENTO` (`id_pagamento`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ESTORNO`
--

LOCK TABLES `ESTORNO` WRITE;
/*!40000 ALTER TABLE `ESTORNO` DISABLE KEYS */;
/*!40000 ALTER TABLE `ESTORNO` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `FORMA_PAGAMENTO`
--

DROP TABLE IF EXISTS `FORMA_PAGAMENTO`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `FORMA_PAGAMENTO` (
  `id_forma_pagamento` bigint unsigned NOT NULL AUTO_INCREMENT,
  `id_cliente` bigint unsigned NOT NULL,
  `tipo_forma_pagamento` varchar(30) NOT NULL,
  `titular` varchar(150) DEFAULT NULL,
  `validade` char(7) DEFAULT NULL,
  `identificador_seguro` varchar(50) DEFAULT NULL,
  `ultimos_digitos` char(4) DEFAULT NULL,
  PRIMARY KEY (`id_forma_pagamento`),
  KEY `idx_fp_cliente` (`id_cliente`),
  CONSTRAINT `fk_fp_cliente` FOREIGN KEY (`id_cliente`) REFERENCES `CLIENTE` (`id_cliente`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `FORMA_PAGAMENTO`
--

LOCK TABLES `FORMA_PAGAMENTO` WRITE;
/*!40000 ALTER TABLE `FORMA_PAGAMENTO` DISABLE KEYS */;
/*!40000 ALTER TABLE `FORMA_PAGAMENTO` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `FORNECEDOR`
--

DROP TABLE IF EXISTS `FORNECEDOR`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `FORNECEDOR` (
  `id_fornecedor` bigint unsigned NOT NULL AUTO_INCREMENT,
  `nome_fornecedor` varchar(200) NOT NULL,
  PRIMARY KEY (`id_fornecedor`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `FORNECEDOR`
--

LOCK TABLES `FORNECEDOR` WRITE;
/*!40000 ALTER TABLE `FORNECEDOR` DISABLE KEYS */;
/*!40000 ALTER TABLE `FORNECEDOR` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ITEM_PEDIDO`
--

DROP TABLE IF EXISTS `ITEM_PEDIDO`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ITEM_PEDIDO` (
  `id_item_pedido` bigint unsigned NOT NULL AUTO_INCREMENT,
  `id_pedido` bigint unsigned NOT NULL,
  `id_produto` bigint unsigned NOT NULL,
  `quantidade` int unsigned NOT NULL,
  `preco_unitario_compra` decimal(12,2) NOT NULL,
  PRIMARY KEY (`id_item_pedido`),
  KEY `idx_ip_pedido` (`id_pedido`),
  KEY `idx_ip_produto` (`id_produto`),
  CONSTRAINT `fk_ip_pedido` FOREIGN KEY (`id_pedido`) REFERENCES `PEDIDO` (`id_pedido`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_ip_produto` FOREIGN KEY (`id_produto`) REFERENCES `PRODUTO` (`id_produto`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ITEM_PEDIDO`
--

LOCK TABLES `ITEM_PEDIDO` WRITE;
/*!40000 ALTER TABLE `ITEM_PEDIDO` DISABLE KEYS */;
/*!40000 ALTER TABLE `ITEM_PEDIDO` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PAGAMENTO`
--

DROP TABLE IF EXISTS `PAGAMENTO`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `PAGAMENTO` (
  `id_pagamento` bigint unsigned NOT NULL AUTO_INCREMENT,
  `id_pedido` bigint unsigned NOT NULL,
  `id_forma_pagamento` bigint unsigned NOT NULL,
  `valor` decimal(12,2) NOT NULL,
  `data_pagamento` date NOT NULL,
  `status_pagamento` varchar(30) NOT NULL,
  PRIMARY KEY (`id_pagamento`),
  KEY `idx_pag_pedido` (`id_pedido`),
  KEY `idx_pag_forma` (`id_forma_pagamento`),
  KEY `idx_pagamento_status_data` (`status_pagamento`,`data_pagamento`) USING BTREE,
  CONSTRAINT `fk_pag_forma` FOREIGN KEY (`id_forma_pagamento`) REFERENCES `FORMA_PAGAMENTO` (`id_forma_pagamento`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_pag_pedido` FOREIGN KEY (`id_pedido`) REFERENCES `PEDIDO` (`id_pedido`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PAGAMENTO`
--

LOCK TABLES `PAGAMENTO` WRITE;
/*!40000 ALTER TABLE `PAGAMENTO` DISABLE KEYS */;
/*!40000 ALTER TABLE `PAGAMENTO` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PEDIDO`
--

DROP TABLE IF EXISTS `PEDIDO`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `PEDIDO` (
  `id_pedido` bigint unsigned NOT NULL AUTO_INCREMENT,
  `id_cliente` bigint unsigned NOT NULL,
  `data_pedido` date NOT NULL,
  `status_pedido` varchar(30) NOT NULL,
  `valor_frete_contratado` decimal(12,2) NOT NULL DEFAULT '0.00',
  `data_limite_devolucao` date DEFAULT NULL,
  PRIMARY KEY (`id_pedido`),
  KEY `idx_pedido_cliente` (`id_cliente`),
  KEY `idx_pedido_status_data` (`status_pedido`,`data_pedido`) USING BTREE,
  CONSTRAINT `fk_pedido_cliente` FOREIGN KEY (`id_cliente`) REFERENCES `CLIENTE` (`id_cliente`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PEDIDO`
--

LOCK TABLES `PEDIDO` WRITE;
/*!40000 ALTER TABLE `PEDIDO` DISABLE KEYS */;
/*!40000 ALTER TABLE `PEDIDO` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PESSOA_FISICA`
--

DROP TABLE IF EXISTS `PESSOA_FISICA`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `PESSOA_FISICA` (
  `id_cliente` bigint unsigned NOT NULL,
  `nome_completo` varchar(200) NOT NULL,
  `cpf` char(11) NOT NULL,
  PRIMARY KEY (`id_cliente`),
  UNIQUE KEY `uk_pf_cpf` (`cpf`),
  CONSTRAINT `fk_pf_cliente` FOREIGN KEY (`id_cliente`) REFERENCES `CLIENTE` (`id_cliente`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PESSOA_FISICA`
--

LOCK TABLES `PESSOA_FISICA` WRITE;
/*!40000 ALTER TABLE `PESSOA_FISICA` DISABLE KEYS */;
/*!40000 ALTER TABLE `PESSOA_FISICA` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_pf_disjunta_bi` BEFORE INSERT ON `PESSOA_FISICA` FOR EACH ROW BEGIN
    IF EXISTS (SELECT 1 FROM PESSOA_JURIDICA WHERE id_cliente = NEW.id_cliente) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Cliente já classificado como PESSOA_JURIDICA.';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `PESSOA_JURIDICA`
--

DROP TABLE IF EXISTS `PESSOA_JURIDICA`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `PESSOA_JURIDICA` (
  `id_cliente` bigint unsigned NOT NULL,
  `razao_social` varchar(200) NOT NULL,
  `nome_fantasia` varchar(200) DEFAULT NULL,
  `cnpj` char(14) NOT NULL,
  PRIMARY KEY (`id_cliente`),
  UNIQUE KEY `uk_pj_cnpj` (`cnpj`),
  CONSTRAINT `fk_pj_cliente` FOREIGN KEY (`id_cliente`) REFERENCES `CLIENTE` (`id_cliente`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PESSOA_JURIDICA`
--

LOCK TABLES `PESSOA_JURIDICA` WRITE;
/*!40000 ALTER TABLE `PESSOA_JURIDICA` DISABLE KEYS */;
/*!40000 ALTER TABLE `PESSOA_JURIDICA` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_pj_disjunta_bi` BEFORE INSERT ON `PESSOA_JURIDICA` FOR EACH ROW BEGIN
    IF EXISTS (SELECT 1 FROM PESSOA_FISICA WHERE id_cliente = NEW.id_cliente) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Cliente já classificado como PESSOA_FISICA.';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `PRODUTO`
--

DROP TABLE IF EXISTS `PRODUTO`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `PRODUTO` (
  `id_produto` bigint unsigned NOT NULL AUTO_INCREMENT,
  `sku` varchar(50) NOT NULL,
  `nome` varchar(200) NOT NULL,
  `descricao` text,
  `preco_atual` decimal(12,2) NOT NULL,
  `status_produto` varchar(30) NOT NULL,
  PRIMARY KEY (`id_produto`),
  UNIQUE KEY `uk_produto_sku` (`sku`),
  KEY `idx_produto_status_preco` (`status_produto`,`preco_atual`) USING BTREE,
  FULLTEXT KEY `ft_produto_nome_desc` (`nome`,`descricao`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PRODUTO`
--

LOCK TABLES `PRODUTO` WRITE;
/*!40000 ALTER TABLE `PRODUTO` DISABLE KEYS */;
INSERT INTO `PRODUTO` VALUES (1,'SKU-1001','Notebook X Pro','Notebook 16GB',3999.90,'ATIVO'),(3,'TRANSACAO-COMMIT-001','Produto transacional','Exemplo persistido por uma procedure',120.00,'ATIVO');
/*!40000 ALTER TABLE `PRODUTO` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PRODUTO_ESTOQUE`
--

DROP TABLE IF EXISTS `PRODUTO_ESTOQUE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `PRODUTO_ESTOQUE` (
  `id_produto` bigint unsigned NOT NULL,
  `id_estoque` bigint unsigned NOT NULL,
  `quantidade` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id_produto`,`id_estoque`),
  KEY `idx_prodest_estoque` (`id_estoque`),
  CONSTRAINT `fk_prodest_estoque` FOREIGN KEY (`id_estoque`) REFERENCES `ESTOQUE` (`id_estoque`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_prodest_produto` FOREIGN KEY (`id_produto`) REFERENCES `PRODUTO` (`id_produto`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PRODUTO_ESTOQUE`
--

LOCK TABLES `PRODUTO_ESTOQUE` WRITE;
/*!40000 ALTER TABLE `PRODUTO_ESTOQUE` DISABLE KEYS */;
/*!40000 ALTER TABLE `PRODUTO_ESTOQUE` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PRODUTO_FORNECEDOR`
--

DROP TABLE IF EXISTS `PRODUTO_FORNECEDOR`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `PRODUTO_FORNECEDOR` (
  `id_produto` bigint unsigned NOT NULL,
  `id_fornecedor` bigint unsigned NOT NULL,
  PRIMARY KEY (`id_produto`,`id_fornecedor`),
  KEY `idx_prodforn_fornecedor` (`id_fornecedor`),
  CONSTRAINT `fk_prodforn_fornecedor` FOREIGN KEY (`id_fornecedor`) REFERENCES `FORNECEDOR` (`id_fornecedor`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_prodforn_produto` FOREIGN KEY (`id_produto`) REFERENCES `PRODUTO` (`id_produto`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PRODUTO_FORNECEDOR`
--

LOCK TABLES `PRODUTO_FORNECEDOR` WRITE;
/*!40000 ALTER TABLE `PRODUTO_FORNECEDOR` DISABLE KEYS */;
/*!40000 ALTER TABLE `PRODUTO_FORNECEDOR` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'loja'
--

--
-- Dumping routines for database 'loja'
--
/*!50003 DROP PROCEDURE IF EXISTS `sp_manipular_produto` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_manipular_produto`(
    IN p_acao            INT,              
    IN p_id_produto      BIGINT UNSIGNED,  
    IN p_sku             VARCHAR(50),
    IN p_nome            VARCHAR(200),
    IN p_descricao       TEXT,
    IN p_preco_atual     DECIMAL(12,2),
    IN p_status_produto  VARCHAR(30)
)
BEGIN
    CASE p_acao
        WHEN 1 THEN
            INSERT INTO PRODUTO (sku, nome, descricao, preco_atual, status_produto)
            VALUES (p_sku, p_nome, p_descricao, p_preco_atual, p_status_produto);
            SELECT LAST_INSERT_ID() AS id_gerado, 'PRODUTO inserido' AS msg;

        WHEN 2 THEN
            UPDATE PRODUTO
               SET sku            = COALESCE(p_sku,            sku),
                   nome           = COALESCE(p_nome,           nome),
                   descricao      = COALESCE(p_descricao,      descricao),
                   preco_atual    = COALESCE(p_preco_atual,    preco_atual),
                   status_produto = COALESCE(p_status_produto, status_produto)
             WHERE id_produto = p_id_produto;
            SELECT ROW_COUNT() AS linhas_afetadas, 'PRODUTO atualizado' AS msg;

        WHEN 3 THEN
            DELETE FROM PRODUTO WHERE id_produto = p_id_produto;
            SELECT ROW_COUNT() AS linhas_afetadas, 'PRODUTO removido' AS msg;

        WHEN 4 THEN
            SELECT * FROM PRODUTO WHERE id_produto = p_id_produto;

        ELSE
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT =
                'Ação inválida. Use 1=INSERT, 2=UPDATE, 3=DELETE, 4=SELECT.';
    END CASE;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Current Database: `universidade`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `universidade` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `universidade`;

--
-- Table structure for table `CIDADE`
--

DROP TABLE IF EXISTS `CIDADE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `CIDADE` (
  `id_cidade` bigint unsigned NOT NULL AUTO_INCREMENT,
  `nome` varchar(150) NOT NULL,
  `uf` char(2) NOT NULL,
  PRIMARY KEY (`id_cidade`),
  KEY `idx_cidade_nome` (`nome`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CIDADE`
--

LOCK TABLES `CIDADE` WRITE;
/*!40000 ALTER TABLE `CIDADE` DISABLE KEYS */;
INSERT INTO `CIDADE` VALUES (1,'São Paulo','SP'),(2,'Rio de Janeiro','RJ'),(3,'Belo Horizonte','MG');
/*!40000 ALTER TABLE `CIDADE` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `DEPARTAMENTO`
--

DROP TABLE IF EXISTS `DEPARTAMENTO`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `DEPARTAMENTO` (
  `id_departamento` bigint unsigned NOT NULL AUTO_INCREMENT,
  `nome` varchar(150) NOT NULL,
  `id_cidade` bigint unsigned NOT NULL,
  `id_gerente` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`id_departamento`),
  KEY `idx_dept_cidade` (`id_cidade`) USING BTREE,
  KEY `fk_dept_gerente` (`id_gerente`),
  CONSTRAINT `fk_dept_cidade` FOREIGN KEY (`id_cidade`) REFERENCES `CIDADE` (`id_cidade`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_dept_gerente` FOREIGN KEY (`id_gerente`) REFERENCES `EMPREGADO` (`id_empregado`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `DEPARTAMENTO`
--

LOCK TABLES `DEPARTAMENTO` WRITE;
/*!40000 ALTER TABLE `DEPARTAMENTO` DISABLE KEYS */;
INSERT INTO `DEPARTAMENTO` VALUES (1,'Tecnologia',1,2),(2,'Recursos Humanos',2,6),(3,'Financeiro',1,4),(4,'Comercial',3,8);
/*!40000 ALTER TABLE `DEPARTAMENTO` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `DEPENDENTE`
--

DROP TABLE IF EXISTS `DEPENDENTE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `DEPENDENTE` (
  `id_dependente` bigint unsigned NOT NULL AUTO_INCREMENT,
  `id_empregado` bigint unsigned NOT NULL,
  `nome` varchar(200) NOT NULL,
  `parentesco` varchar(50) DEFAULT NULL,
  `data_nascimento` date DEFAULT NULL,
  PRIMARY KEY (`id_dependente`),
  KEY `idx_dep_empregado` (`id_empregado`),
  CONSTRAINT `fk_dep_empregado` FOREIGN KEY (`id_empregado`) REFERENCES `EMPREGADO` (`id_empregado`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `DEPENDENTE`
--

LOCK TABLES `DEPENDENTE` WRITE;
/*!40000 ALTER TABLE `DEPENDENTE` DISABLE KEYS */;
INSERT INTO `DEPENDENTE` VALUES (1,1,'Lucas Silva','Filho','2015-06-01'),(2,1,'Carla Silva','Cônjuge','1985-02-14'),(3,2,'Mariana Souza','Filha','2018-11-20'),(4,4,'Rosa Oliveira','Mãe','1950-03-10'),(5,5,'Pedro Pereira','Filho','2010-09-25'),(6,8,'Tiago Rocha','Filho','2012-04-18');
/*!40000 ALTER TABLE `DEPENDENTE` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `EMPREGADO`
--

DROP TABLE IF EXISTS `EMPREGADO`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `EMPREGADO` (
  `id_empregado` bigint unsigned NOT NULL AUTO_INCREMENT,
  `nome` varchar(200) NOT NULL,
  `cpf` char(11) NOT NULL,
  `salario` decimal(12,2) NOT NULL,
  `data_admissao` date NOT NULL,
  `id_departamento` bigint unsigned NOT NULL,
  PRIMARY KEY (`id_empregado`),
  UNIQUE KEY `uk_emp_cpf` (`cpf`),
  KEY `idx_emp_departamento` (`id_departamento`) USING BTREE,
  KEY `idx_emp_nome` (`nome`) USING BTREE,
  CONSTRAINT `fk_emp_dept` FOREIGN KEY (`id_departamento`) REFERENCES `DEPARTAMENTO` (`id_departamento`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `EMPREGADO`
--

LOCK TABLES `EMPREGADO` WRITE;
/*!40000 ALTER TABLE `EMPREGADO` DISABLE KEYS */;
INSERT INTO `EMPREGADO` VALUES (1,'João Silva','11111111111',5500.00,'2023-01-15',1),(2,'Maria Souza','22222222222',6200.00,'2022-08-10',1),(4,'Ana Oliveira','44444444444',7800.00,'2021-05-20',3),(5,'Carlos Pereira','55555555555',5500.00,'2020-07-01',1),(6,'Beatriz Lima','66666666666',4900.00,'2022-11-15',2),(7,'Diego Alves','77777777777',7000.00,'2019-02-10',3),(8,'Eduarda Rocha','88888888888',8100.00,'2021-10-05',4);
/*!40000 ALTER TABLE `EMPREGADO` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_empregado_before_insert` BEFORE INSERT ON `EMPREGADO` FOR EACH ROW BEGIN
    IF NEW.salario IS NULL OR NEW.salario <= 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Salário base deve ser maior que zero.';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_empregado_after_insert` AFTER INSERT ON `EMPREGADO` FOR EACH ROW BEGIN
    INSERT INTO HISTORICO_SALARIO
        (id_empregado, nome_empregado, salario_anterior, salario_novo, tipo_evento)
    VALUES
        (NEW.id_empregado, NEW.nome, NULL, NEW.salario, 'INSERT');
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_empregado_before_update` BEFORE UPDATE ON `EMPREGADO` FOR EACH ROW BEGIN
    IF NEW.salario IS NULL OR NEW.salario <= 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Salário base deve ser maior que zero.';
    END IF;

    IF NEW.salario <> OLD.salario THEN
        INSERT INTO HISTORICO_SALARIO
            (id_empregado, nome_empregado, salario_anterior, salario_novo, tipo_evento)
        VALUES
            (OLD.id_empregado, OLD.nome, OLD.salario, NEW.salario, 'UPDATE');
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `HISTORICO_SALARIO`
--

DROP TABLE IF EXISTS `HISTORICO_SALARIO`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `HISTORICO_SALARIO` (
  `id_historico` bigint unsigned NOT NULL AUTO_INCREMENT,
  `id_empregado` bigint unsigned NOT NULL,
  `nome_empregado` varchar(200) DEFAULT NULL,
  `salario_anterior` decimal(12,2) DEFAULT NULL,
  `salario_novo` decimal(12,2) DEFAULT NULL,
  `tipo_evento` enum('INSERT','UPDATE') NOT NULL,
  `data_evento` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_historico`),
  KEY `idx_hist_empregado` (`id_empregado`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `HISTORICO_SALARIO`
--

LOCK TABLES `HISTORICO_SALARIO` WRITE;
/*!40000 ALTER TABLE `HISTORICO_SALARIO` DISABLE KEYS */;
INSERT INTO `HISTORICO_SALARIO` VALUES (1,1,'João Silva',5000.00,5500.00,'UPDATE','2026-11-12 12:33:56');
/*!40000 ALTER TABLE `HISTORICO_SALARIO` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PROJETO`
--

DROP TABLE IF EXISTS `PROJETO`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `PROJETO` (
  `id_projeto` bigint unsigned NOT NULL AUTO_INCREMENT,
  `nome` varchar(200) NOT NULL,
  `id_departamento` bigint unsigned NOT NULL,
  PRIMARY KEY (`id_projeto`),
  KEY `idx_projeto_dept` (`id_departamento`),
  CONSTRAINT `fk_projeto_dept` FOREIGN KEY (`id_departamento`) REFERENCES `DEPARTAMENTO` (`id_departamento`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PROJETO`
--

LOCK TABLES `PROJETO` WRITE;
/*!40000 ALTER TABLE `PROJETO` DISABLE KEYS */;
INSERT INTO `PROJETO` VALUES (1,'Migração ERP',1),(2,'Portal do Cliente',1),(3,'Reestruturação RH',2),(4,'Auditoria 2024',3),(5,'Campanha Vendas Q1',4);
/*!40000 ALTER TABLE `PROJETO` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PROJETO_EMPREGADO`
--

DROP TABLE IF EXISTS `PROJETO_EMPREGADO`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `PROJETO_EMPREGADO` (
  `id_projeto` bigint unsigned NOT NULL,
  `id_empregado` bigint unsigned NOT NULL,
  `horas_alocadas` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id_projeto`,`id_empregado`),
  KEY `idx_pe_empregado` (`id_empregado`),
  CONSTRAINT `fk_pe_empregado` FOREIGN KEY (`id_empregado`) REFERENCES `EMPREGADO` (`id_empregado`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_pe_projeto` FOREIGN KEY (`id_projeto`) REFERENCES `PROJETO` (`id_projeto`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PROJETO_EMPREGADO`
--

LOCK TABLES `PROJETO_EMPREGADO` WRITE;
/*!40000 ALTER TABLE `PROJETO_EMPREGADO` DISABLE KEYS */;
INSERT INTO `PROJETO_EMPREGADO` VALUES (1,1,100),(1,2,80),(1,5,50),(2,1,60),(2,5,40),(3,6,120),(4,4,200),(4,7,90),(5,7,40),(5,8,150);
/*!40000 ALTER TABLE `PROJETO_EMPREGADO` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `vw_departamentos_gerentes`
--

DROP TABLE IF EXISTS `vw_departamentos_gerentes`;
/*!50001 DROP VIEW IF EXISTS `vw_departamentos_gerentes`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_departamentos_gerentes` AS SELECT 
 1 AS `id_departamento`,
 1 AS `departamento`,
 1 AS `cidade`,
 1 AS `uf`,
 1 AS `id_gerente`,
 1 AS `gerente`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_empregados_dependentes`
--

DROP TABLE IF EXISTS `vw_empregados_dependentes`;
/*!50001 DROP VIEW IF EXISTS `vw_empregados_dependentes`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_empregados_dependentes` AS SELECT 
 1 AS `id_empregado`,
 1 AS `empregado`,
 1 AS `qtd_dependentes`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_empregados_dependentes_gerentes`
--

DROP TABLE IF EXISTS `vw_empregados_dependentes_gerentes`;
/*!50001 DROP VIEW IF EXISTS `vw_empregados_dependentes_gerentes`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_empregados_dependentes_gerentes` AS SELECT 
 1 AS `id_empregado`,
 1 AS `empregado`,
 1 AS `qtd_dependentes`,
 1 AS `eh_gerente`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_empregados_por_departamento_localidade`
--

DROP TABLE IF EXISTS `vw_empregados_por_departamento_localidade`;
/*!50001 DROP VIEW IF EXISTS `vw_empregados_por_departamento_localidade`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_empregados_por_departamento_localidade` AS SELECT 
 1 AS `id_departamento`,
 1 AS `departamento`,
 1 AS `cidade`,
 1 AS `uf`,
 1 AS `total_empregados`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_projetos_departamentos_gerentes`
--

DROP TABLE IF EXISTS `vw_projetos_departamentos_gerentes`;
/*!50001 DROP VIEW IF EXISTS `vw_projetos_departamentos_gerentes`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_projetos_departamentos_gerentes` AS SELECT 
 1 AS `id_projeto`,
 1 AS `projeto`,
 1 AS `departamento`,
 1 AS `cidade`,
 1 AS `uf`,
 1 AS `gerente`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_projetos_mais_empregados`
--

DROP TABLE IF EXISTS `vw_projetos_mais_empregados`;
/*!50001 DROP VIEW IF EXISTS `vw_projetos_mais_empregados`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_projetos_mais_empregados` AS SELECT 
 1 AS `id_projeto`,
 1 AS `projeto`,
 1 AS `departamento`,
 1 AS `total_empregados`*/;
SET character_set_client = @saved_cs_client;

--
-- Dumping events for database 'universidade'
--

--
-- Dumping routines for database 'universidade'
--
/*!50003 DROP PROCEDURE IF EXISTS `sp_manipular_empregado` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_manipular_empregado`(
    IN p_acao             INT,              
    IN p_id_empregado     BIGINT UNSIGNED,  
    IN p_nome             VARCHAR(200),
    IN p_cpf              CHAR(11),
    IN p_salario          DECIMAL(12,2),
    IN p_data_admissao    DATE,
    IN p_id_departamento  BIGINT UNSIGNED
)
BEGIN
    CASE p_acao
        WHEN 1 THEN
            INSERT INTO EMPREGADO (nome, cpf, salario, data_admissao, id_departamento)
            VALUES (p_nome, p_cpf, p_salario, p_data_admissao, p_id_departamento);
            SELECT LAST_INSERT_ID() AS id_gerado, 'EMPREGADO inserido' AS msg;

        WHEN 2 THEN
            UPDATE EMPREGADO
               SET nome            = COALESCE(p_nome,            nome),
                   cpf             = COALESCE(p_cpf,             cpf),
                   salario         = COALESCE(p_salario,         salario),
                   data_admissao   = COALESCE(p_data_admissao,   data_admissao),
                   id_departamento = COALESCE(p_id_departamento, id_departamento)
             WHERE id_empregado = p_id_empregado;
            SELECT ROW_COUNT() AS linhas_afetadas, 'EMPREGADO atualizado' AS msg;

        WHEN 3 THEN
            DELETE FROM EMPREGADO WHERE id_empregado = p_id_empregado;
            SELECT ROW_COUNT() AS linhas_afetadas, 'EMPREGADO removido' AS msg;

        WHEN 4 THEN
            SELECT * FROM EMPREGADO WHERE id_empregado = p_id_empregado;

        ELSE
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT =
                'Ação inválida. Use 1=INSERT, 2=UPDATE, 3=DELETE, 4=SELECT.';
    END CASE;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Current Database: `loja`
--

USE `loja`;

--
-- Current Database: `universidade`
--

USE `universidade`;

--
-- Final view structure for view `vw_departamentos_gerentes`
--

/*!50001 DROP VIEW IF EXISTS `vw_departamentos_gerentes`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_departamentos_gerentes` AS select `d`.`id_departamento` AS `id_departamento`,`d`.`nome` AS `departamento`,`c`.`nome` AS `cidade`,`c`.`uf` AS `uf`,`g`.`id_empregado` AS `id_gerente`,`g`.`nome` AS `gerente` from ((`DEPARTAMENTO` `d` join `CIDADE` `c` on((`c`.`id_cidade` = `d`.`id_cidade`))) left join `EMPREGADO` `g` on((`g`.`id_empregado` = `d`.`id_gerente`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_empregados_dependentes`
--

/*!50001 DROP VIEW IF EXISTS `vw_empregados_dependentes`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_empregados_dependentes` AS select `e`.`id_empregado` AS `id_empregado`,`e`.`nome` AS `empregado`,(select count(0) from `DEPENDENTE` `dep` where (`dep`.`id_empregado` = `e`.`id_empregado`)) AS `qtd_dependentes` from `EMPREGADO` `e` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_empregados_dependentes_gerentes`
--

/*!50001 DROP VIEW IF EXISTS `vw_empregados_dependentes_gerentes`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_empregados_dependentes_gerentes` AS select `e`.`id_empregado` AS `id_empregado`,`e`.`nome` AS `empregado`,(select count(0) from `DEPENDENTE` `dep` where (`dep`.`id_empregado` = `e`.`id_empregado`)) AS `qtd_dependentes`,(case when exists(select 1 from `DEPARTAMENTO` `d` where (`d`.`id_gerente` = `e`.`id_empregado`)) then 'SIM' else 'NÃO' end) AS `eh_gerente` from `EMPREGADO` `e` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_empregados_por_departamento_localidade`
--

/*!50001 DROP VIEW IF EXISTS `vw_empregados_por_departamento_localidade`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_empregados_por_departamento_localidade` AS select `d`.`id_departamento` AS `id_departamento`,`d`.`nome` AS `departamento`,`c`.`nome` AS `cidade`,`c`.`uf` AS `uf`,count(`e`.`id_empregado`) AS `total_empregados` from ((`DEPARTAMENTO` `d` join `CIDADE` `c` on((`c`.`id_cidade` = `d`.`id_cidade`))) left join `EMPREGADO` `e` on((`e`.`id_departamento` = `d`.`id_departamento`))) group by `d`.`id_departamento`,`d`.`nome`,`c`.`nome`,`c`.`uf` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_projetos_departamentos_gerentes`
--

/*!50001 DROP VIEW IF EXISTS `vw_projetos_departamentos_gerentes`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_projetos_departamentos_gerentes` AS select `p`.`id_projeto` AS `id_projeto`,`p`.`nome` AS `projeto`,`d`.`nome` AS `departamento`,`c`.`nome` AS `cidade`,`c`.`uf` AS `uf`,`g`.`nome` AS `gerente` from (((`PROJETO` `p` join `DEPARTAMENTO` `d` on((`d`.`id_departamento` = `p`.`id_departamento`))) join `CIDADE` `c` on((`c`.`id_cidade` = `d`.`id_cidade`))) left join `EMPREGADO` `g` on((`g`.`id_empregado` = `d`.`id_gerente`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_projetos_mais_empregados`
--

/*!50001 DROP VIEW IF EXISTS `vw_projetos_mais_empregados`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_projetos_mais_empregados` AS select `p`.`id_projeto` AS `id_projeto`,`p`.`nome` AS `projeto`,`d`.`nome` AS `departamento`,count(`pe`.`id_empregado`) AS `total_empregados` from ((`PROJETO` `p` join `DEPARTAMENTO` `d` on((`d`.`id_departamento` = `p`.`id_departamento`))) left join `PROJETO_EMPREGADO` `pe` on((`pe`.`id_projeto` = `p`.`id_projeto`))) group by `p`.`id_projeto`,`p`.`nome`,`d`.`nome` order by `total_empregados` desc */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-11-12 12:34:07
