CREATE INDEX idx_cmd_statut_annee_montant
  ON commandes (statut, (YEAR(date_commande)), montant_total);
