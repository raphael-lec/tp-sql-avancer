-- Non-Repeatable Read 
USE advanced_sql;
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
START TRANSACTION;
SELECT id, titulaire, solde FROM comptes_bancaires WHERE id = 1; 

--  REPEATABLE READ
UPDATE comptes_bancaires SET solde = solde + 500 WHERE id = 1;

SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
START TRANSACTION;
SELECT id, titulaire, solde FROM comptes_bancaires WHERE id = 1;