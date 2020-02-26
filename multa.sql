create table lfdb.multa(
    id_multa      number
   ,id_emprestimo number
   ,vl_multa      number 
);

alter table LFDB.multa 
  add constraint multa_emprestimo_fk
      foreign key (id_emprestimo)
      references LFDB.EMPRESTIMO (SQ_EMPRESTIMO);

create unique index i_multa on lfdb.multa(id_multa,id_emprestimo);

create or replace trigger calcula_multa
  before update on LFDB.EMPRESTIMO 
  for each row 
declare 
    cursor c_emprestimo(pID_EMPRESTIMO NUMBER) IS
    SELECT SQ_EMPRESTIMO 
          ,DT_INICIO
          ,DT_TERMINO
      FROM EMPRESTIMO
     WHERE SQ_EMPRESTIMO = pID_EMPRESTIMO;
    
    R_EMPRESTIMO C_EMPRESTIMO%ROWTYPE;
    wNEXT NUMBER;
begin
    OPEN C_EMPRESTIMO(:OLD.SQ_EMPRESTIMO);
    FETCH C_EMPRESTIMO INTO R_EMPRESTIMO;
    CLOSE C_EMPRESTIMO;
    SELECT MAX(ID_MULTA) INTO wNEXT FROM LFDB.MULTA; 
    
    IF(R_EMPRESTIMO.DT_TERMINO <> R_EMPRESTIMO.DT_INICIO + 7) THEN 
        INSERT INTO LFDB.MULTA VALUES(wNEXT,:NEW.SQ_EMPRESTIMO,lfdb.calcula_multa((:NEW.DT_TERMINO - :OLD.DT_TERMINO),3.5));
    END IF;  
    COMMIT;
end;

CREATE OR REPLACE function lfdb.calcula_multa(atraso in number,vl_dia in number) return number is 
begin
    return(vl_dia * atraso);
end;