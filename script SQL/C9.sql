CREATE INDEX idx_cmd_statut_annee_montant
  ON commandes (statut, (YEAR(date_commande)), montant_total);
SELECT id, client_id, date_commande, montant_total
FROM commandes
WHERE statut = 'LIVREE'
  AND YEAR(date_commande) = 2026
ORDER BY montant_total DESC
LIMIT 10;