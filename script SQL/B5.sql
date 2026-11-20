USE advanced_sql;

WITH classement AS (
  SELECT
    c.nom AS categorie,
    p.nom AS produit,
    p.prix_unitaire,
    DENSE_RANK() OVER (PARTITION BY p.categorie_id ORDER BY p.prix_unitaire DESC) AS rang
  FROM produits p
  JOIN categories c ON c.id = p.categorie_id
)
SELECT categorie, produit, prix_unitaire, rang
FROM classement
WHERE rang <= 2
ORDER BY categorie, rang, produit;