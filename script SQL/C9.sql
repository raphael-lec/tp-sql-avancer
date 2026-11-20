(a) Suivi GPS : base orientée colonnes / série temporelle (Cassandra, ou TimescaleDB / InfluxDB), avec Redis pour la dernière position connue.
Écritures massives et partitionnées par véhicule et par temps.
Une position perdue ou légèrement en retard n’est pas grave : cohérence éventuelle acceptable.
Classement CAP : AP .
Classement PACELC : PA/EL .

(b) Facturation : base relationnelle (PostgreSQL ou MySQL/InnoDB).
Transactions ACID, contraintes d’intégrité, isolation, WAL pour la durabilité.
Une erreur ou une incohérence sur un paiement est inacceptable.
Classement CAP : CP.
Classement PACELC : PC/EC (on privilégie la cohérence, quitte à payer en latence).

(c) Suggestions d’amis et d’itinéraires : base de graphes (Neo4j).
Un parcours à 3 degrés est un parcours de voisinage natif, rapide. En SQL, il demanderait trois jointures auto-référencées coûteuses .
Les suggestions tolèrent un léger retard de fraîcheur. Neo4j est plutôt orienté cohérence au sein d’un cluster : CP, soit PC/EC.