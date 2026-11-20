USE advanced_sql;

SELECT id, nom
FROM employes
WHERE id NOT IN (SELECT manager_id FROM employes);

SELECT e.id, e.nom
FROM employes e
WHERE NOT EXISTS (
  SELECT 1 FROM employes m WHERE m.manager_id = e.id
);

SELECT id, nom
FROM employes
WHERE id NOT IN (SELECT manager_id FROM employes WHERE manager_id IS NOT NULL);

SELECT e.id, e.nom
FROM employes e
LEFT JOIN employes m ON m.manager_id = e.id
WHERE m.id IS NULL;