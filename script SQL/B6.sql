USE advanced_sql;

WITH RECURSIVE organigramme AS (
  SELECT
    id, nom, poste, manager_id,
    1 AS niveau,
    CAST(nom AS CHAR(1000)) AS chemin
  FROM employes
  WHERE manager_id IS NULL

  UNION ALL
  SELECT
    e.id, e.nom, e.poste, e.manager_id,
    o.niveau + 1,
    CONCAT(o.chemin, ' > ', e.nom)
  FROM employes e
  JOIN organigramme o ON e.manager_id = o.id
)
SELECT niveau, CONCAT(REPEAT('    ', niveau - 1), nom) AS employe, poste, chemin
FROM organigramme
ORDER BY chemin;