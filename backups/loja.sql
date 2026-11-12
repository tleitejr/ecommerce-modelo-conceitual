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
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-11-12 12:34:07
