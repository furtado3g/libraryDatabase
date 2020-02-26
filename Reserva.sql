create table lfdb.Reserva(
    sq_reserva_livro    number,
    id_aluno            number
);

create table lfdb.livro_reserva(
    sq_reserva_livro      number,
    sq_reserva            number,
    sq_livro              number,
    sn_liberado           varchar2(1)
);


ALTER TABLE lfdb.Reserva
ADD CONSTRAINT id_al_reserva_fk
   FOREIGN KEY (id_aluno)
   REFERENCES lfdb.Aluno (id_aluno);

ALTER TABLE lfdb.livro_reserva
ADD CONSTRAINT sq_reserva_fk
   FOREIGN KEY (sq_reserva_livro)
   REFERENCES lfdb.Reserva (sq_reserva_livro);
   
   
 
CREATE OR REPLACE TRIGGER lfdb.reserva_livro
BEFORE  INSERT OR UPDATE ON lfdb.livro_reserva
FOR EACH ROW
declare
    
BEGIN
    IF :NEW.sn_liberado = 'N' and :old.sn_liberado <> 'N' THEN
        UPDATE lfdb.livro
           SET SN_RESERVADO = 'S'
         WHERE sq_livro = :NEW.sq_livro;
    ELSE
        UPDATE lfdb.livro
           SET SN_RESERVADO = 'N'
         WHERE sq_livro = :NEW.sq_livro;
    END IF;
END reserva_livro;