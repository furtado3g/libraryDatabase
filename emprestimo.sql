create table lfdb.Emprestimo (
    sq_emprestimo         number primary key,
    id_aluno              number,
    sq_livros_emprestado number,
    dt_inicio             date default sysdate,
    dt_termino            date default sysdate+7
);

create table lfdb.livro_emprestimo(
    sq_livro_emprestado   number,
    sq_emprestimo         number,
    sq_livro              number
);

alter table lfdb.livro_emprestimo
add CONSTRAINT sq_livro_fk 
    foreign key (sq_livro)
    references lfdb.livro(sq_livro);

alter table lfdb.Emprestimo
add CONSTRAINT sq_emprestimo_fk
    foreign key (sq_emprestimo)
    references lfdb.livro_emprestimo(sq_emprestimo);

alter table Emprestimo
add CONSTRAINT id_aluno_fk
    foreign key (id_aluno)
    references Aluno(id_aluno);

CREATE OR REPLACE TRIGGER lfdb.Emprestimo
    before UPDATE ON lfdb.livro_emprestimo 
    FOR EACH ROW
BEGIN
    IF :old.dt_termino is null THEN
        UPDATE lfdb.livros
           SET sn_emprestado = 'S'
         WHERE sq_livro = :NEW.sq_livro;
    ELSE
        UPDATE lfdb.livros
           SET SN_RESERVADO = 'N'
         WHERE sq_livro = :NEW.sq_livro;
    END IF;
END reserva_livro;