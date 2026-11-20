USE advanced_sql;

DROP TABLE IF EXISTS affectations_brutes;
CREATE TABLE affectations_brutes (
  employe_id      INT,
  employe_nom     VARCHAR(100),
  dept_nom        VARCHAR(50),
  projets_liste   VARCHAR(255),
  chef_projet     VARCHAR(100),
  chef_projet_tel VARCHAR(20)
);
INSERT INTO affectations_brutes VALUES
(1, 'Alice Martin', 'Data',  'Alpha,Beta', 'Paul Durand',  '0601020304'),
(2, 'Bob Leroy',    'Infra', 'Beta',       'Paul Durand',  '0601020304'),
(3, 'Chloé Petit',  'Data',  'Gamma',      'Sarah Blanc',  '0605060708');

DROP TABLE IF EXISTS affectation;
DROP TABLE IF EXISTS projet;
DROP TABLE IF EXISTS chef_projet;
DROP TABLE IF EXISTS employe_3fn;
DROP TABLE IF EXISTS departement;

CREATE TABLE departement (
  dept_id  INT AUTO_INCREMENT PRIMARY KEY,
  dept_nom VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE employe_3fn (
  employe_id  INT PRIMARY KEY,
  employe_nom VARCHAR(100) NOT NULL,
  dept_id     INT NOT NULL,
  FOREIGN KEY (dept_id) REFERENCES departement (dept_id)
);

CREATE TABLE chef_projet (
  chef_id         INT AUTO_INCREMENT PRIMARY KEY,
  chef_projet     VARCHAR(100) NOT NULL UNIQUE,
  chef_projet_tel VARCHAR(20)
);

CREATE TABLE projet (
  projet_id  INT AUTO_INCREMENT PRIMARY KEY,
  projet_nom VARCHAR(100) NOT NULL UNIQUE,
  chef_id    INT NOT NULL,
  FOREIGN KEY (chef_id) REFERENCES chef_projet (chef_id)
);

CREATE TABLE affectation (
  employe_id INT NOT NULL,
  projet_id  INT NOT NULL,
  PRIMARY KEY (employe_id, projet_id),
  FOREIGN KEY (employe_id) REFERENCES employe_3fn (employe_id),
  FOREIGN KEY (projet_id)  REFERENCES projet (projet_id)
);

INSERT INTO departement (dept_nom)
SELECT DISTINCT dept_nom FROM affectations_brutes;

INSERT INTO employe_3fn (employe_id, employe_nom, dept_id)
SELECT DISTINCT b.employe_id, b.employe_nom, d.dept_id
FROM affectations_brutes b JOIN departement d ON d.dept_nom = b.dept_nom;

INSERT INTO chef_projet (chef_projet, chef_projet_tel)
SELECT DISTINCT chef_projet, chef_projet_tel FROM affectations_brutes;

CREATE TEMPORARY TABLE tmp_aff AS
SELECT b.employe_id, TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(b.projets_liste, ',', n.n), ',', -1)) AS projet_nom, b.chef_projet
FROM affectations_brutes b
JOIN (SELECT 1 n UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5) n
  ON n.n <= 1 + LENGTH(b.projets_liste) - LENGTH(REPLACE(b.projets_liste, ',', ''));

INSERT INTO projet (projet_nom, chef_id)
SELECT DISTINCT t.projet_nom, c.chef_id
FROM tmp_aff t JOIN chef_projet c ON c.chef_projet = t.chef_projet;

INSERT INTO affectation (employe_id, projet_id)
SELECT t.employe_id, p.projet_id
FROM tmp_aff t JOIN projet p ON p.projet_nom = t.projet_nom;