-- MySQL dump 10.13  Distrib 5.5.20, for osx10.6 (i386)
--
-- Host: 192.168.1.98    Database: coge_eifis
-- ------------------------------------------------------
-- Server version	5.1.62-0ubuntu0.10.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `abi`
--

DROP TABLE IF EXISTS `abi`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `abi` (
  `ABI` int(11) NOT NULL DEFAULT '0',
  `NOME` char(40) DEFAULT NULL,
  PRIMARY KEY (`ABI`),
  KEY `ABI_DESCRIZ` (`NOME`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `agenti`
--

DROP TABLE IF EXISTS `agenti`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `agenti` (
  `AZIENDA` int(11) NOT NULL DEFAULT '0',
  `CODICE` int(11) NOT NULL DEFAULT '0',
  `NOME` char(40) DEFAULT NULL,
  `RUOLO` int(11) DEFAULT NULL,
  `PERC1` decimal(16,4) DEFAULT NULL,
  `PERC2` decimal(16,4) DEFAULT NULL,
  `C_ANAG` int(11) DEFAULT NULL,
  `FLAGS` char(8) DEFAULT NULL,
  PRIMARY KEY (`AZIENDA`,`CODICE`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `anagen`
--

DROP TABLE IF EXISTS `anagen`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `anagen` (
  `CODICE` int(11) NOT NULL DEFAULT '0',
  `TIPO` char(1) DEFAULT NULL,
  `TIPOPERS` char(1) DEFAULT NULL,
  `RAGSOC` char(40) DEFAULT NULL,
  `INDIR` char(40) DEFAULT NULL,
  `C_LOCAL` int(11) DEFAULT NULL,
  `LOCALITA` char(40) DEFAULT NULL,
  `CAP` int(11) DEFAULT NULL,
  `TELEF1` char(16) DEFAULT NULL,
  `TELEF2` char(16) DEFAULT NULL,
  `FAX` char(16) DEFAULT NULL,
  `TELEX` char(16) DEFAULT NULL,
  `EMAIL` char(40) DEFAULT NULL,
  `URLWEB` char(40) DEFAULT NULL,
  `CODFISC` char(16) DEFAULT NULL,
  `PARTIVA` char(20) DEFAULT NULL,
  `NOTE1` char(80) DEFAULT NULL,
  `NOTE2` char(80) DEFAULT NULL,
  `RIFERIM` char(40) DEFAULT NULL,
  `DATA_NAS` datetime DEFAULT NULL,
  `LUOGONAS` char(40) DEFAULT NULL,
  `SESSO` char(1) DEFAULT NULL,
  `USE_MAIL` int(11) DEFAULT NULL,
  `FLAGS` char(8) DEFAULT NULL,
  `C_CATEG` int(11) DEFAULT NULL,
  `C_ANAG2` int(11) DEFAULT NULL,
  `C_ANAG3` int(11) DEFAULT NULL,
  `C_BANCA` int(11) DEFAULT NULL,
  `CONTOC` char(8) DEFAULT NULL,
  `C_AGENTE` int(11) DEFAULT NULL,
  `RISCHIO` int(11) DEFAULT NULL,
  `FIDO` decimal(16,4) DEFAULT NULL,
  `C_ZONA` int(11) DEFAULT NULL,
  `C_PAGAM` int(11) DEFAULT NULL,
  `C_SPEDIZ` int(11) DEFAULT NULL,
  `PORTO` char(1) DEFAULT NULL,
  `C_SCONTO` int(11) DEFAULT NULL,
  `C_SCONTO2` int(11) DEFAULT NULL,
  `C_SCONTO3` int(11) DEFAULT NULL,
  `C_SCONTO4` int(11) DEFAULT NULL,
  `LISTINO` int(11) DEFAULT NULL,
  `C_ABI` int(11) DEFAULT NULL,
  `C_CAB` int(11) DEFAULT NULL,
  `DES_BAN` char(60) DEFAULT NULL,
  `C_PORTO` int(11) DEFAULT NULL,
  `C_IVA_ISO` char(4) DEFAULT NULL,
  `INTRASTAT` int(11) DEFAULT NULL,
  `SOST_IMP` int(11) DEFAULT NULL,
  `EXTRAI1` int(11) DEFAULT NULL,
  `EXTRAI2` int(11) DEFAULT NULL,
  `EXTRAI3` int(11) DEFAULT NULL,
  `EXTRAI4` int(11) DEFAULT NULL,
  `EXTRAD1` datetime DEFAULT NULL,
  `EXTRAD2` datetime DEFAULT NULL,
  `EXTRAD3` datetime DEFAULT NULL,
  `EXTRAD4` datetime DEFAULT NULL,
  `EXTRAN1` decimal(16,4) DEFAULT NULL,
  `EXTRAN2` decimal(16,4) DEFAULT NULL,
  `EXTRAN3` decimal(16,4) DEFAULT NULL,
  `EXTRAN4` decimal(16,4) DEFAULT NULL,
  `RAGSOC2` char(40) DEFAULT NULL,
  `ABI2` int(11) DEFAULT NULL,
  `CAB2` int(11) DEFAULT NULL,
  `CONTO1` int(11) DEFAULT NULL,
  `CONTO2` int(11) DEFAULT NULL,
  `CONTO3` int(11) DEFAULT NULL,
  `CONTO4` int(11) DEFAULT NULL,
  `CIN` char(1) DEFAULT NULL,
  `IBAN` char(30) DEFAULT NULL,
  `SWIFT` char(15) DEFAULT NULL,
  `FLAGESC` char(1) DEFAULT NULL,
  `NUMDIC` int(11) DEFAULT NULL,
  `DATADIC` datetime DEFAULT NULL,
  `CLIASS` char(1) DEFAULT NULL,
  `GIOSC1` int(11) DEFAULT NULL,
  `GIOSC2` int(11) DEFAULT NULL,
  `NUMCIR` int(11) DEFAULT NULL,
  `PATENTE` char(20) DEFAULT NULL,
  `CARTAID` char(20) DEFAULT NULL,
  `PASSPORT` char(20) DEFAULT NULL,
  PRIMARY KEY (`CODICE`),
  KEY `ANAGEN_CODICE_FISC` (`CODFISC`),
  KEY `ANAGEN_NOME` (`RAGSOC`),
  KEY `ANAGEN_PARTITA_IVA` (`PARTIVA`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `anamag`
--

DROP TABLE IF EXISTS `anamag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `anamag` (
  `AZIENDA` int(11) NOT NULL DEFAULT '0',
  `CODICE` int(11) NOT NULL DEFAULT '0',
  `DESCRIZ` char(50) DEFAULT NULL,
  `MARCA` char(10) DEFAULT NULL,
  `MODELLO` char(10) DEFAULT NULL,
  `UN_MIS` char(2) DEFAULT NULL,
  `C_IVA` int(11) DEFAULT NULL,
  `POSIZ` char(10) DEFAULT NULL,
  `C_FORN` int(11) DEFAULT NULL,
  `CODICE2` char(20) DEFAULT NULL,
  `PROVVIG` int(11) DEFAULT NULL,
  `GRAMMATURA` char(20) DEFAULT NULL,
  `ASPETTO` char(8) DEFAULT NULL,
  PRIMARY KEY (`AZIENDA`,`CODICE`),
  KEY `ANAMAG_CODICEBARRE` (`AZIENDA`,`CODICE2`),
  KEY `ANAMAG_DESCRIZIONE` (`AZIENDA`,`DESCRIZ`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `aziende`
--

DROP TABLE IF EXISTS `aziende`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `aziende` (
  `CODICE` int(11) NOT NULL DEFAULT '0',
  `RAGSOC` char(60) DEFAULT NULL,
  `COD_ANAG` int(11) DEFAULT NULL,
  `PIANOGE` int(11) DEFAULT NULL,
  `MAS_CLI` int(11) DEFAULT NULL,
  `MAS_FOR` int(11) DEFAULT NULL,
  `N1` decimal(16,4) DEFAULT NULL,
  `N2` decimal(16,4) DEFAULT NULL,
  `N3` decimal(16,4) DEFAULT NULL,
  `N4` decimal(16,4) DEFAULT NULL,
  `N5` decimal(16,4) DEFAULT NULL,
  `N6` decimal(16,4) DEFAULT NULL,
  `N7` decimal(16,4) DEFAULT NULL,
  `N8` decimal(16,4) DEFAULT NULL,
  `N9` decimal(16,4) DEFAULT NULL,
  `N10` decimal(16,4) DEFAULT NULL,
  `N11` decimal(16,4) DEFAULT NULL,
  `N12` decimal(16,4) DEFAULT NULL,
  `N13` decimal(16,4) DEFAULT NULL,
  `N14` decimal(16,4) DEFAULT NULL,
  `N15` decimal(16,4) DEFAULT NULL,
  `N16` decimal(16,4) DEFAULT NULL,
  `N17` decimal(16,4) DEFAULT NULL,
  `N18` decimal(16,4) DEFAULT NULL,
  `N19` decimal(16,4) DEFAULT NULL,
  `N20` decimal(16,4) DEFAULT NULL,
  `I1` int(11) DEFAULT NULL,
  `I2` int(11) DEFAULT NULL,
  `I3` int(11) DEFAULT NULL,
  `I4` int(11) DEFAULT NULL,
  `I5` int(11) DEFAULT NULL,
  `I6` int(11) DEFAULT NULL,
  `I7` int(11) DEFAULT NULL,
  `I8` int(11) DEFAULT NULL,
  `I9` int(11) DEFAULT NULL,
  `I10` int(11) DEFAULT NULL,
  `I11` int(11) DEFAULT NULL,
  `I12` int(11) DEFAULT NULL,
  `I13` int(11) DEFAULT NULL,
  `I14` int(11) DEFAULT NULL,
  `I15` int(11) DEFAULT NULL,
  `I16` int(11) DEFAULT NULL,
  `I17` int(11) DEFAULT NULL,
  `I18` int(11) DEFAULT NULL,
  `I19` int(11) DEFAULT NULL,
  `I20` int(11) DEFAULT NULL,
  `D1` datetime DEFAULT NULL,
  `D2` datetime DEFAULT NULL,
  `D3` datetime DEFAULT NULL,
  `D4` datetime DEFAULT NULL,
  `D5` datetime DEFAULT NULL,
  `D6` datetime DEFAULT NULL,
  `D7` datetime DEFAULT NULL,
  `D8` datetime DEFAULT NULL,
  `D9` datetime DEFAULT NULL,
  `D10` datetime DEFAULT NULL,
  `D11` datetime DEFAULT NULL,
  `D12` datetime DEFAULT NULL,
  `D13` datetime DEFAULT NULL,
  `D14` datetime DEFAULT NULL,
  `D15` datetime DEFAULT NULL,
  `D16` datetime DEFAULT NULL,
  `D17` datetime DEFAULT NULL,
  `D18` datetime DEFAULT NULL,
  `D19` datetime DEFAULT NULL,
  `D20` datetime DEFAULT NULL,
  `S1` char(20) DEFAULT NULL,
  `S2` char(20) DEFAULT NULL,
  `S3` char(20) DEFAULT NULL,
  `S4` char(20) DEFAULT NULL,
  `S5` char(20) DEFAULT NULL,
  `S6` char(20) DEFAULT NULL,
  `S7` char(20) DEFAULT NULL,
  `S8` char(20) DEFAULT NULL,
  `S9` char(20) DEFAULT NULL,
  `S10` char(20) DEFAULT NULL,
  `NOTE1` char(80) DEFAULT NULL,
  `NOTE2` char(80) DEFAULT NULL,
  `RAGSOC2` char(40) DEFAULT NULL,
  `ABI1` int(11) DEFAULT NULL,
  `CAB1` int(11) DEFAULT NULL,
  `ABI2` int(11) DEFAULT NULL,
  `CAB2` int(11) DEFAULT NULL,
  `ABI3` int(11) DEFAULT NULL,
  `CAB3` int(11) DEFAULT NULL,
  `ABI4` int(11) DEFAULT NULL,
  `CAB4` int(11) DEFAULT NULL,
  PRIMARY KEY (`CODICE`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cab`
--

DROP TABLE IF EXISTS `cab`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cab` (
  `ABI` int(11) NOT NULL DEFAULT '0',
  `CAB` int(11) NOT NULL DEFAULT '0',
  `AGENZIA` char(40) DEFAULT NULL,
  `LOCALITA` char(40) DEFAULT NULL,
  `PROV` char(2) DEFAULT NULL,
  `CAP` int(11) DEFAULT NULL,
  `C_ANAG` int(11) DEFAULT NULL,
  PRIMARY KEY (`ABI`,`CAB`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `categor`
--

DROP TABLE IF EXISTS `categor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `categor` (
  `CODICE` int(11) NOT NULL DEFAULT '0',
  `DESCRIZ` char(40) DEFAULT NULL,
  PRIMARY KEY (`CODICE`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `catemerc`
--

DROP TABLE IF EXISTS `catemerc`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `catemerc` (
  `AZIENDA` int(11) NOT NULL DEFAULT '0',
  `CODICE` int(11) NOT NULL DEFAULT '0',
  `DESCRIZIONE` char(40) DEFAULT NULL,
  `FAMIGLIA` int(11) DEFAULT NULL,
  `RICAVI` int(11) DEFAULT NULL,
  `EXTRA` int(11) DEFAULT NULL,
  PRIMARY KEY (`AZIENDA`,`CODICE`),
  KEY `CATEMERC_DESCRIZ` (`DESCRIZIONE`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `causali`
--

DROP TABLE IF EXISTS `causali`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `causali` (
  `CODICE` int(11) NOT NULL DEFAULT '0',
  `DESCRIZ` char(40) DEFAULT NULL,
  `TIPOIVA` int(11) DEFAULT NULL,
  `TIPOREG` int(11) DEFAULT NULL,
  `SOTTOREG` int(11) DEFAULT NULL,
  `PROGPROT` int(11) DEFAULT NULL,
  `TIPODARE` char(10) DEFAULT NULL,
  `TIPOAVERE` char(10) DEFAULT NULL,
  `C_IVA` int(11) DEFAULT NULL,
  `C_RICAVI` int(11) DEFAULT NULL,
  `C_CONTO1` int(11) DEFAULT NULL,
  `C_CONTO2` int(11) DEFAULT NULL,
  `C_CAUSAL` int(11) DEFAULT NULL,
  `SPECIAL` int(11) DEFAULT NULL,
  `C_CONTO3` int(11) DEFAULT NULL,
  `C_CONTO4` int(11) DEFAULT NULL,
  `C_CONTO5` int(11) DEFAULT NULL,
  `C_CONTO6` int(11) DEFAULT NULL,
  `C_CONTO7` int(11) DEFAULT NULL,
  `C_CONTO8` int(11) DEFAULT NULL,
  `EXTRA1` int(11) DEFAULT NULL,
  PRIMARY KEY (`CODICE`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `causmag`
--

DROP TABLE IF EXISTS `causmag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `causmag` (
  `TIPO_DOC` int(11) NOT NULL DEFAULT '0',
  `CODICE` int(11) NOT NULL DEFAULT '0',
  `DESCRIZ` char(40) DEFAULT NULL,
  `DES_CAUS` char(40) DEFAULT NULL,
  `CAUSALE` int(11) DEFAULT NULL,
  `MOVMAG` int(11) DEFAULT NULL,
  `MOVCON` int(11) DEFAULT NULL,
  `MOVORD` int(11) DEFAULT NULL,
  `SRC` int(11) DEFAULT NULL,
  `DST` int(11) DEFAULT NULL,
  `MODULO` char(10) DEFAULT NULL,
  `ORIG` char(1) DEFAULT NULL,
  `CONTROP` char(1) DEFAULT NULL,
  `GESMAG` char(1) DEFAULT NULL,
  `FATTUR` int(11) DEFAULT NULL,
  `LISTINO` int(11) DEFAULT NULL,
  PRIMARY KEY (`TIPO_DOC`,`CODICE`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cespperc`
--

DROP TABLE IF EXISTS `cespperc`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cespperc` (
  `ANNO_ESE` int(11) NOT NULL DEFAULT '0',
  `COD_GRUPPO` int(11) NOT NULL DEFAULT '0',
  `COD_SPECIE` int(11) NOT NULL DEFAULT '0',
  `COD_CATEG` int(11) NOT NULL DEFAULT '0',
  `DESCRIZ` char(255) DEFAULT NULL,
  `PERC_AMM` decimal(16,4) DEFAULT NULL,
  `NOTE` char(255) DEFAULT NULL,
  PRIMARY KEY (`ANNO_ESE`,`COD_GRUPPO`,`COD_SPECIE`,`COD_CATEG`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `commpg`
--

DROP TABLE IF EXISTS `commpg`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `commpg` (
  `GRUPPO` int(11) NOT NULL DEFAULT '0',
  `CODICE` int(11) NOT NULL DEFAULT '0',
  `DESCRIZ` char(40) DEFAULT NULL,
  `TIPO_PE` char(1) DEFAULT NULL,
  `TIPO_CO` char(1) DEFAULT NULL,
  `RICLAS1` char(12) DEFAULT NULL,
  `RICLAS2` char(12) DEFAULT NULL,
  `RICLAS3` char(12) DEFAULT NULL,
  `RICLAS4` char(12) DEFAULT NULL,
  `DESCRIZ2` char(40) DEFAULT NULL,
  PRIMARY KEY (`GRUPPO`,`CODICE`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `comuni`
--

DROP TABLE IF EXISTS `comuni`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `comuni` (
  `CODICE` int(11) NOT NULL DEFAULT '0',
  `LOCALITA` char(40) DEFAULT NULL,
  `PROV` char(2) DEFAULT NULL,
  `CAP` char(5) DEFAULT NULL,
  `NAZIONE` char(30) DEFAULT NULL,
  `CODFIS` char(5) DEFAULT NULL,
  PRIMARY KEY (`CODICE`),
  KEY `COMUNI_DESCRIZ` (`LOCALITA`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `conta`
--

DROP TABLE IF EXISTS `conta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `conta` (
  `AZIENDA` int(11) NOT NULL DEFAULT '0',
  `ANNO_ESE` int(11) NOT NULL DEFAULT '0',
  `TIPO` int(11) NOT NULL DEFAULT '0',
  `DATA` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `USA_DATA` int(11) DEFAULT NULL,
  `DESCRIZ` char(40) DEFAULT NULL,
  `VALORE` int(11) DEFAULT NULL,
  PRIMARY KEY (`AZIENDA`,`ANNO_ESE`,`TIPO`,`DATA`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `defextra`
--

DROP TABLE IF EXISTS `defextra`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `defextra` (
  `ID` int(11) NOT NULL DEFAULT '0',
  `TIPO` char(1) DEFAULT NULL,
  `DESCRIZ` char(40) DEFAULT NULL,
  `RIGA` char(4) DEFAULT NULL,
  `COLONNA` char(4) DEFAULT NULL,
  `LABEL` char(10) DEFAULT NULL,
  `SPEC1` int(11) DEFAULT NULL,
  `SPEC2` int(11) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gioiva`
--

DROP TABLE IF EXISTS `gioiva`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gioiva` (
  `AZIENDA` int(11) NOT NULL DEFAULT '0',
  `ANNO_ESE` int(11) NOT NULL DEFAULT '0',
  `CODICE` int(11) NOT NULL DEFAULT '0',
  `DESCRIZ` char(40) DEFAULT NULL,
  `TIPO` char(1) DEFAULT NULL,
  `FLAG1` int(11) DEFAULT NULL,
  `FLAG2` int(11) DEFAULT NULL,
  `REPORT` char(20) DEFAULT NULL,
  `ULTDAT` datetime DEFAULT NULL,
  `ULTRIG` int(11) DEFAULT NULL,
  PRIMARY KEY (`AZIENDA`,`ANNO_ESE`,`CODICE`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `invent`
--

DROP TABLE IF EXISTS `invent`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `invent` (
  `AZIENDA` int(11) NOT NULL DEFAULT '0',
  `ANNO_ESE` int(11) NOT NULL DEFAULT '0',
  `COD_ART` int(11) NOT NULL DEFAULT '0',
  `COD_MAG` int(11) NOT NULL DEFAULT '0',
  `GIACENZA` decimal(16,4) DEFAULT NULL,
  `CARICO` decimal(16,4) DEFAULT NULL,
  `SCARICO` decimal(16,4) DEFAULT NULL,
  `ORDINATO` decimal(16,4) DEFAULT NULL,
  `IMPEGNATO` decimal(16,4) DEFAULT NULL,
  `SCORTAMIN` decimal(16,4) DEFAULT NULL,
  `N1` decimal(16,4) DEFAULT NULL,
  `N2` decimal(16,4) DEFAULT NULL,
  `N3` decimal(16,4) DEFAULT NULL,
  `N4` decimal(16,4) DEFAULT NULL,
  PRIMARY KEY (`AZIENDA`,`ANNO_ESE`,`COD_ART`,`COD_MAG`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `iva`
--

DROP TABLE IF EXISTS `iva`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `iva` (
  `CODICE` int(11) NOT NULL DEFAULT '0',
  `DESCRIZ` char(40) DEFAULT NULL,
  `ALIQUOTA` decimal(16,4) DEFAULT NULL,
  `ART_ESEN` char(8) DEFAULT NULL,
  PRIMARY KEY (`CODICE`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `lismag`
--

DROP TABLE IF EXISTS `lismag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lismag` (
  `ANNO_ESE` int(11) NOT NULL DEFAULT '0',
  `CODICE` int(11) NOT NULL DEFAULT '0',
  `MAGAZZINO` int(11) NOT NULL DEFAULT '0',
  `GIACENZA` decimal(16,4) DEFAULT NULL,
  `CARICO` decimal(16,4) DEFAULT NULL,
  `SCARICO` decimal(16,4) DEFAULT NULL,
  `ORDINATO` decimal(16,4) DEFAULT NULL,
  `IMPEGNATO` decimal(16,4) DEFAULT NULL,
  `SCORTAMIN` decimal(16,4) DEFAULT NULL,
  `PR_ACQUIS` decimal(16,4) DEFAULT NULL,
  `PR_VEND1` decimal(16,4) DEFAULT NULL,
  `PR_VEND2` decimal(16,4) DEFAULT NULL,
  `PR_VEND3` decimal(16,4) DEFAULT NULL,
  `PR_VEND4` decimal(16,4) DEFAULT NULL,
  `PR_VEND5` decimal(16,4) DEFAULT NULL,
  `DT_INI_PROM` datetime DEFAULT NULL,
  `DT_FIN_PROM` datetime DEFAULT NULL,
  PRIMARY KEY (`ANNO_ESE`,`CODICE`,`MAGAZZINO`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `listini`
--

DROP TABLE IF EXISTS `listini`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `listini` (
  `AZIENDA` int(11) NOT NULL DEFAULT '0',
  `ANNO_ESE` int(11) NOT NULL DEFAULT '0',
  `COD_ART` int(11) NOT NULL DEFAULT '0',
  `LISTINO` int(11) NOT NULL DEFAULT '0',
  `PREZZO` decimal(16,4) DEFAULT NULL,
  `DT_INIZIO` datetime DEFAULT NULL,
  `DT_FINE` datetime DEFAULT NULL,
  `DT_AGG` datetime DEFAULT NULL,
  PRIMARY KEY (`AZIENDA`,`ANNO_ESE`,`COD_ART`,`LISTINO`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `mastri`
--

DROP TABLE IF EXISTS `mastri`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mastri` (
  `CODICE` int(11) NOT NULL DEFAULT '0',
  `DESCRIZ` char(40) DEFAULT NULL,
  `ULTCONTO` int(11) DEFAULT NULL,
  `GRUPPO` char(1) DEFAULT NULL,
  `TIPO` char(1) DEFAULT NULL,
  `TIPOAP` char(1) NOT NULL DEFAULT 'A',
  PRIMARY KEY (`CODICE`),
  KEY `MASTRI_NOME` (`DESCRIZ`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `misure`
--

DROP TABLE IF EXISTS `misure`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `misure` (
  `CODICE` char(2) NOT NULL DEFAULT '',
  `DESCRIZIONE` char(20) DEFAULT NULL,
  `CODCONV` char(2) DEFAULT NULL,
  `FUNCONV` int(11) DEFAULT NULL,
  PRIMARY KEY (`CODICE`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `mocodett`
--

DROP TABLE IF EXISTS `mocodett`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mocodett` (
  `AZIENDA` int(11) NOT NULL DEFAULT '0',
  `ANNO_ESE` int(11) NOT NULL DEFAULT '0',
  `DATA_REG` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `NUM_REG` int(11) NOT NULL DEFAULT '0',
  `RIGA` int(11) NOT NULL DEFAULT '0',
  `SUBRIGA` int(11) NOT NULL DEFAULT '0',
  `COD_CONTO` int(11) DEFAULT NULL,
  `TIPO_MOV` char(1) DEFAULT NULL,
  `IMPORTO` decimal(16,4) DEFAULT NULL,
  `IMPONIB` decimal(16,4) DEFAULT NULL,
  `IMPOSTA` decimal(16,4) DEFAULT NULL,
  `COD_IVA` int(11) DEFAULT NULL,
  `PERC_DET` decimal(16,4) DEFAULT NULL,
  `DATA_RIF` datetime DEFAULT NULL,
  `DATA_SCA` datetime DEFAULT NULL,
  `CONTROP` int(11) DEFAULT NULL,
  `N1` decimal(16,4) DEFAULT NULL,
  `N2` decimal(16,4) DEFAULT NULL,
  `CENTROCO` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`AZIENDA`,`ANNO_ESE`,`DATA_REG`,`NUM_REG`,`RIGA`,`SUBRIGA`),
  KEY `MOCODETT_CONTO` (`AZIENDA`,`ANNO_ESE`,`COD_CONTO`,`DATA_REG`,`NUM_REG`,`RIGA`,`SUBRIGA`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `momadett`
--

DROP TABLE IF EXISTS `momadett`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `momadett` (
  `ANNO_ESE` int(11) NOT NULL DEFAULT '0',
  `DATA_MOV` int(11) NOT NULL DEFAULT '0',
  `NUM_MOV` int(11) NOT NULL DEFAULT '0',
  `RIG_MOV` int(11) NOT NULL DEFAULT '0',
  `C_MAGAZ` int(11) DEFAULT NULL,
  `CODICE` int(11) DEFAULT NULL,
  `TIPO_MOV` char(1) DEFAULT NULL,
  `VALORE` decimal(16,4) DEFAULT NULL,
  `PEZZI` int(11) DEFAULT NULL,
  `CASSE` int(11) DEFAULT NULL,
  `PESO` decimal(16,4) DEFAULT NULL,
  PRIMARY KEY (`ANNO_ESE`,`DATA_MOV`,`NUM_MOV`,`RIG_MOV`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `movcon`
--

DROP TABLE IF EXISTS `movcon`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `movcon` (
  `AZIENDA` int(11) NOT NULL DEFAULT '0',
  `ANNO_ESE` int(11) NOT NULL DEFAULT '0',
  `DATA_REG` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `NUM_REG` int(11) NOT NULL DEFAULT '0',
  `COD_CAUS` int(11) DEFAULT NULL,
  `DAT_PROT` datetime DEFAULT NULL,
  `NUM_PROT` int(11) DEFAULT NULL,
  `DATA_DOC` datetime DEFAULT NULL,
  `NUM_DOC` char(20) DEFAULT NULL,
  `ANNO_RIF` int(11) DEFAULT NULL,
  `TIPO_REG` int(11) DEFAULT NULL,
  `STAT_REG` int(11) DEFAULT NULL,
  `DESCRIZ` char(40) DEFAULT NULL,
  `EXTRA1` int(11) DEFAULT NULL,
  `EXTRA2` int(11) DEFAULT NULL,
  PRIMARY KEY (`AZIENDA`,`ANNO_ESE`,`DATA_REG`,`NUM_REG`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `movmag`
--

DROP TABLE IF EXISTS `movmag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `movmag` (
  `ANNO_ESE` int(11) NOT NULL DEFAULT '0',
  `DATA_MOV` int(11) NOT NULL DEFAULT '0',
  `NUM_MOV` int(11) NOT NULL DEFAULT '0',
  `CAUSALE` int(11) DEFAULT NULL,
  `DESCRIZ` char(40) DEFAULT NULL,
  `DATA_DOC` datetime DEFAULT NULL,
  `NUM_DOC` int(11) DEFAULT NULL,
  `C_CONTO` int(11) DEFAULT NULL,
  `DATA_REG` datetime DEFAULT NULL,
  `NUM_REG` int(11) DEFAULT NULL,
  `D_CONSE` datetime DEFAULT NULL,
  `T_CONSE` datetime DEFAULT NULL,
  `NUM_DDT` int(11) DEFAULT NULL,
  PRIMARY KEY (`ANNO_ESE`,`DATA_MOV`,`NUM_MOV`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `paesi`
--

DROP TABLE IF EXISTS `paesi`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `paesi` (
  `CODICE` int(11) NOT NULL DEFAULT '0',
  `LOCALITA` char(40) DEFAULT NULL,
  `PROV` char(2) DEFAULT NULL,
  `CAP` char(5) DEFAULT NULL,
  `NAZIONE` char(30) DEFAULT NULL,
  PRIMARY KEY (`CODICE`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pagam`
--

DROP TABLE IF EXISTS `pagam`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pagam` (
  `CODICE` int(11) NOT NULL DEFAULT '0',
  `DESCRIZ` char(40) DEFAULT NULL,
  `TIPO` int(11) DEFAULT NULL,
  `TIPO_RIP` int(11) DEFAULT NULL,
  `NUMSCAD` int(11) DEFAULT NULL,
  `PERSCAD` int(11) DEFAULT NULL,
  `PESC1_DA` datetime DEFAULT NULL,
  `PESC1_A` datetime DEFAULT NULL,
  `PESC2_DA` datetime DEFAULT NULL,
  `PESC2_A` datetime DEFAULT NULL,
  `PESC3_DA` datetime DEFAULT NULL,
  `PESC3_A` datetime DEFAULT NULL,
  `FLAGS` char(8) DEFAULT NULL,
  PRIMARY KEY (`CODICE`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `parametri`
--

DROP TABLE IF EXISTS `parametri`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `parametri` (
  `codice` char(16) NOT NULL DEFAULT '',
  `valore_int` int(10) unsigned DEFAULT NULL,
  `valore_date` date DEFAULT NULL,
  `valore_float` double DEFAULT NULL,
  `valore_string` char(64) DEFAULT NULL,
  `descriz` char(30) DEFAULT NULL,
  PRIMARY KEY (`codice`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pianoge`
--

DROP TABLE IF EXISTS `pianoge`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pianoge` (
  `AZIENDA` int(11) NOT NULL DEFAULT '0',
  `ANNO_ESE` int(11) NOT NULL DEFAULT '0',
  `CODICE` int(11) NOT NULL DEFAULT '0',
  `DESCRIZ` char(40) DEFAULT NULL,
  `C_ANAG` int(11) DEFAULT NULL,
  `C_ANA2` int(11) DEFAULT NULL,
  `C_ANA3` int(11) DEFAULT NULL,
  `C_ANA4` int(11) DEFAULT NULL,
  `TIPO_PE` char(1) DEFAULT NULL,
  `TIPO_CO` char(1) DEFAULT NULL,
  `T_DARE` decimal(16,4) DEFAULT NULL,
  `T_AVERE` decimal(16,4) DEFAULT NULL,
  `T_SALPR` decimal(16,4) DEFAULT NULL,
  `T_ORDIN` decimal(16,4) DEFAULT NULL,
  `N_ORDIN` int(11) DEFAULT NULL,
  `D_ORDIN` datetime DEFAULT NULL,
  `T_FATTU` decimal(16,4) DEFAULT NULL,
  `N_FATTU` int(11) DEFAULT NULL,
  `D_FATTU` datetime DEFAULT NULL,
  `T_PAGAT` decimal(16,4) DEFAULT NULL,
  `T_INSOL` decimal(16,4) DEFAULT NULL,
  `N_INSOL` int(11) DEFAULT NULL,
  `D_INSOL` datetime DEFAULT NULL,
  `RICLAS` char(12) DEFAULT NULL,
  `RICLAS2` char(12) DEFAULT NULL,
  `RICLAS3` char(12) DEFAULT NULL,
  `RICLAS4` char(12) DEFAULT NULL,
  `NOTE` char(80) DEFAULT NULL,
  `CONTROP` int(11) DEFAULT NULL,
  `N1` decimal(16,4) DEFAULT NULL,
  `N2` decimal(16,4) DEFAULT NULL,
  `N3` decimal(16,4) DEFAULT NULL,
  `N4` decimal(16,4) DEFAULT NULL,
  `DESCRIZ2` char(40) DEFAULT NULL,
  `EXTRA1` int(11) DEFAULT NULL,
  PRIMARY KEY (`AZIENDA`,`ANNO_ESE`,`CODICE`),
  KEY `PIANOGE_COD_ANAG` (`AZIENDA`,`ANNO_ESE`,`TIPO_CO`,`C_ANAG`),
  KEY `PIANOGE_NOME` (`AZIENDA`,`ANNO_ESE`,`TIPO_CO`,`DESCRIZ`),
  KEY `PIANOGE_NOME2` (`AZIENDA`,`ANNO_ESE`,`DESCRIZ`),
  KEY `PIANOGE_TIPO` (`AZIENDA`,`ANNO_ESE`,`TIPO_CO`,`CODICE`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `province`
--

DROP TABLE IF EXISTS `province`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `province` (
  `SIGLA` char(2) NOT NULL DEFAULT '',
  `NOME` char(20) DEFAULT NULL,
  PRIMARY KEY (`SIGLA`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `rigdoc`
--

DROP TABLE IF EXISTS `rigdoc`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rigdoc` (
  `AZIENDA` int(11) NOT NULL DEFAULT '0',
  `ANNO_ESE` int(11) NOT NULL DEFAULT '0',
  `TIP_DOC` int(11) NOT NULL DEFAULT '0',
  `NUM_DOC` int(11) NOT NULL DEFAULT '0',
  `RIG_DOC` int(11) NOT NULL DEFAULT '0',
  `C_MAGAZ` int(11) DEFAULT NULL,
  `C_MAGA2` int(11) DEFAULT NULL,
  `COD_ART` int(11) DEFAULT NULL,
  `TIP_RIG` int(11) DEFAULT NULL,
  `TIP_MOV` int(11) DEFAULT NULL,
  `PR_UNI` decimal(16,4) DEFAULT NULL,
  `PR_TOT` decimal(16,4) DEFAULT NULL,
  `PEZZI` int(11) DEFAULT NULL,
  `CASSE` int(11) DEFAULT NULL,
  `C_IVA` int(11) DEFAULT NULL,
  `UN_MIS` char(2) DEFAULT NULL,
  `DESCRIZ` char(50) DEFAULT NULL,
  `PESO` decimal(16,4) DEFAULT NULL,
  `SCONTO` decimal(16,4) DEFAULT NULL,
  `PROVVIG` decimal(16,4) DEFAULT NULL,
  `STATO` int(11) DEFAULT NULL,
  `ASPETTO` char(8) DEFAULT NULL,
  `TARA` decimal(16,4) DEFAULT NULL,
  `PESO_LORDO` decimal(16,4) DEFAULT NULL,
  `COD_ALFA` char(20) DEFAULT NULL,
  PRIMARY KEY (`AZIENDA`,`ANNO_ESE`,`TIP_DOC`,`NUM_DOC`,`RIG_DOC`),
  KEY `RIGDOC_ARTICOLO` (`AZIENDA`,`ANNO_ESE`,`TIP_RIG`,`COD_ART`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sconti`
--

DROP TABLE IF EXISTS `sconti`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sconti` (
  `AZIENDA` int(11) NOT NULL DEFAULT '0',
  `CODICE` int(11) NOT NULL DEFAULT '0',
  `DESCRIZ` char(40) DEFAULT NULL,
  `TIPO` int(11) DEFAULT NULL,
  `VALORE` decimal(16,4) DEFAULT NULL,
  `FLAGS` char(8) DEFAULT NULL,
  PRIMARY KEY (`AZIENDA`,`CODICE`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sezcli`
--

DROP TABLE IF EXISTS `sezcli`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sezcli` (
  `AZIENDA` int(11) NOT NULL DEFAULT '0',
  `ANNO_ESE` int(11) NOT NULL DEFAULT '0',
  `CONTO` int(11) NOT NULL DEFAULT '0',
  `DATAREG` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `NUMREG` int(11) NOT NULL DEFAULT '0',
  `DATASCAD` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `NUMDOC` int(11) DEFAULT NULL,
  `DATADOC` datetime DEFAULT NULL,
  `IMPORTO` decimal(16,4) DEFAULT NULL,
  `CODPAG` int(11) DEFAULT NULL,
  `STATO` char(1) DEFAULT NULL,
  `CAUSALE` int(11) DEFAULT NULL,
  `LIBERO1` int(11) DEFAULT NULL,
  `LIBERO2` int(11) DEFAULT NULL,
  PRIMARY KEY (`AZIENDA`,`ANNO_ESE`,`CONTO`,`DATAREG`,`NUMREG`,`DATASCAD`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sezfor`
--

DROP TABLE IF EXISTS `sezfor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sezfor` (
  `AZIENDA` int(11) NOT NULL DEFAULT '0',
  `ANNO_ESE` int(11) NOT NULL DEFAULT '0',
  `CONTO` int(11) NOT NULL DEFAULT '0',
  `PRATICA` char(8) NOT NULL DEFAULT '',
  `RIGA` int(11) NOT NULL DEFAULT '0',
  `DATAARRIVO` datetime DEFAULT NULL,
  `DATAPARTENZA` datetime DEFAULT NULL,
  `IMPORTO` decimal(16,4) DEFAULT NULL,
  `VALUTA` char(4) DEFAULT NULL,
  `CAMBIO` decimal(16,4) DEFAULT NULL,
  `NOTE` char(30) DEFAULT NULL,
  `STATO` char(1) DEFAULT NULL,
  `DESCRIZIONE` char(40) DEFAULT NULL,
  `IMPORTOLIT` decimal(16,4) DEFAULT NULL,
  PRIMARY KEY (`AZIENDA`,`ANNO_ESE`,`CONTO`,`PRATICA`,`RIGA`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tab_coeff`
--

DROP TABLE IF EXISTS `tab_coeff`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tab_coeff` (
  `ANNO_ESE` int(11) NOT NULL DEFAULT '0',
  `TIPO` int(11) NOT NULL DEFAULT '0',
  `COD_GRUPPO` int(11) NOT NULL DEFAULT '0',
  `COD_SPECIE` int(11) NOT NULL DEFAULT '0',
  `COD_CATEG` int(11) NOT NULL DEFAULT '0',
  `DESCRIZ` char(240) DEFAULT NULL,
  `PERC_AMM` decimal(16,4) DEFAULT NULL,
  `NOTE` char(40) DEFAULT NULL,
  PRIMARY KEY (`ANNO_ESE`,`TIPO`,`COD_GRUPPO`,`COD_SPECIE`,`COD_CATEG`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabdesc`
--

DROP TABLE IF EXISTS `tabdesc`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tabdesc` (
  `TIPO` char(1) NOT NULL DEFAULT '',
  `PROG` int(11) NOT NULL DEFAULT '0',
  `DESCRIZ` char(80) DEFAULT NULL,
  PRIMARY KEY (`TIPO`,`PROG`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tesdoc`
--

DROP TABLE IF EXISTS `tesdoc`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tesdoc` (
  `AZIENDA` int(11) NOT NULL DEFAULT '0',
  `ANNO_ESE` int(11) NOT NULL DEFAULT '0',
  `TIP_DOC` int(11) NOT NULL DEFAULT '0',
  `NUM_DOC` int(11) NOT NULL DEFAULT '0',
  `DAT_DOC` int(11) DEFAULT NULL,
  `DT_DOC` datetime DEFAULT NULL,
  `DESCRIZ` char(40) DEFAULT NULL,
  `CAUS_TRASP` char(40) DEFAULT NULL,
  `ANN_DO2` int(11) DEFAULT NULL,
  `TIP_DO2` int(11) DEFAULT NULL,
  `NUM_DO2` int(11) DEFAULT NULL,
  `C_CONTO` int(11) DEFAULT NULL,
  `ANN_REG` int(11) DEFAULT NULL,
  `DAT_REG` datetime DEFAULT NULL,
  `NUM_REG` int(11) DEFAULT NULL,
  `DT_CONS` datetime DEFAULT NULL,
  `OR_CONS` datetime DEFAULT NULL,
  `C_AGENT` int(11) DEFAULT NULL,
  `C_SPEDI` int(11) DEFAULT NULL,
  `C_PAGAM` int(11) DEFAULT NULL,
  `PORTO` char(1) DEFAULT NULL,
  `NUM_DDT` int(11) DEFAULT NULL,
  `RIF_COM` char(20) DEFAULT NULL,
  `NOTE` char(80) DEFAULT NULL,
  `LISTINO` int(11) DEFAULT NULL,
  `SCONTO` decimal(16,4) DEFAULT NULL,
  `NUM_COLLI` int(11) DEFAULT NULL,
  `PESO` decimal(16,4) DEFAULT NULL,
  `ASPETTO` int(11) DEFAULT NULL,
  `C_PORTO` int(11) DEFAULT NULL,
  `STATO` int(11) DEFAULT NULL,
  PRIMARY KEY (`AZIENDA`,`ANNO_ESE`,`TIP_DOC`,`NUM_DOC`),
  KEY `TESDOC_CONTO` (`AZIENDA`,`ANNO_ESE`,`TIP_DOC`,`C_CONTO`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `utenti`
--

DROP TABLE IF EXISTS `utenti`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `utenti` (
  `NOME` char(10) NOT NULL DEFAULT '',
  `NOME_COG` char(40) DEFAULT NULL,
  `PW1` char(20) DEFAULT NULL,
  `PW2` char(20) DEFAULT NULL,
  `PERMESSI` int(11) DEFAULT NULL,
  `DATAPW` datetime DEFAULT NULL,
  PRIMARY KEY (`NOME`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `valextra`
--

DROP TABLE IF EXISTS `valextra`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `valextra` (
  `AZIENDA` int(11) NOT NULL DEFAULT '0',
  `CONTO` int(11) NOT NULL DEFAULT '0',
  `ID` int(11) NOT NULL DEFAULT '0',
  `VALORE` char(40) DEFAULT NULL,
  PRIMARY KEY (`AZIENDA`,`CONTO`,`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `vettori`
--

DROP TABLE IF EXISTS `vettori`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `vettori` (
  `CODICE` int(11) NOT NULL DEFAULT '0',
  `NOME` char(40) DEFAULT NULL,
  `C_ANAG` int(11) DEFAULT NULL,
  PRIMARY KEY (`CODICE`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `zone`
--

DROP TABLE IF EXISTS `zone`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `zone` (
  `CODICE` int(11) NOT NULL DEFAULT '0',
  `DESCRIZ` char(40) DEFAULT NULL,
  PRIMARY KEY (`CODICE`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2012-05-04 13:12:53
