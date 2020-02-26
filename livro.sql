create table lfdb.Area(
    id_area  number primary key,
    nm_area  varchar2(10),
    ds_area  varchar2(300)
);

create table lfdb.Autor(
    id_autor   number primary key,
    nm_autor   varchar2(100)
);

create table lfdb.Livro(
    sq_livro      number primary key,
    id_autor      number,
    id_area       number,
    an_publicacao number,
    sn_emprestado varchar2(1),
    sn_reservado  varchar2(1)
);

create table lfdb.livro_log(
    sq_livro number,
    ds_motivo varchar2(15),
    sq_funcionario number,
    dt_emprestimo date default sysdate
);


ALTER TABLE lfdb.livro
ADD CONSTRAINT id_autor_fk
   FOREIGN KEY (id_autor)
   REFERENCES lfdb.autor (id_autor);

create index lv_aut on lfdb.livro (sq_livro,id_autor);
create index lv_ar on lfdb.livro (sq_livro,id_area);
create index lv_emp on lfdb.livro (sq_livro,sn_emprestado);
create index lv_res on lfdb.livro (sq_livro,sn_reservado);

CREATE OR REPLACE TRIGGER lfdb.livro_emprestimo
    BEFORE UPDATE ON lfdb.livro
    FOR EACH ROW
BEGIN
    IF :NEW.sn_emprestado = 'N' THEN
        insert into lfdb.livro_log
            values(:NEW.sq_livro
                  ,'DEVOLUCAO'
                  ,null
                  ,sysdate);
    ELSE
        insert into lfdb.livro_log
            values(:NEW.sq_livro
                  ,'EMPRESTIMO'
                  ,null
                  ,sysdate);
    END IF;
    commit;
END livro_emprestimo;

CREATE OR REPLACE TRIGGER livro_reserva
    BEFORE UPDATE ON lfdb.livro
    FOR EACH ROW
BEGIN
    IF :old.sn_reservado = 'N' THEN
        update lfdb.livro
           set sn_reservado = 'S'
         where sq_livro = :old.sq_livro;
    ELSE
        insert into lfdb.livro_log
            values(:NEW.sq_livro
                  ,'Reserva'
                  ,null
                  ,sysdate);
    END IF;
END livro_emprestimo;