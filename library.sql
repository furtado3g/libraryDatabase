create table Aluno(
    id_aluno     number primary key,
    nr_matricula varchar2(10),
    nm_aluno     varchar2(10)
);

create table Autor(
    id_autor   number primary key,
    nm_autor   varchar2(100)
);

create table Area(
    id_area  number primary key,
    nm_area  varchar2(10),
    ds_area  varchar2(300)
);

create table Emprestimo (
    sq_emprestimo         number,
    id_aluno              number,
    sq_livros_emprestados number,
    dt_inicio             date,
    dt_termino            date
);

create table Livro(
    sq_livro      number primary key,
    id_aluno      varchar2(10),
    dt_inicio     date,
    dt_termino    date,
    sn_emprestado varchar2(1)
);

create table livro_emprestimo(
    sq_livro_emprestado   number,
    sq_emprestimo         number,
    sq_livro              number
)

create table livro_reserva(
    sq_reserva_livro      number,
    sq_reserva            number,
    sq_livro              number
)

create table Reserva(
    sq_reserva_livro    number,
    id_aluno            number,
    sq_livro            number
);

ALTER TABLE Reserva
ADD CONSTRAINT sq_reserva_fk
   FOREIGN KEY (sq_reserva)
   REFERENCES livro_reserva (sq_reserva);

ALTER TABLE Reserva
ADD CONSTRAINT id_aluno_reserva_fk
   FOREIGN KEY (id_aluno)
   REFERENCES Aluno (id_aluno);

ALTER TABLE Reserva
ADD CONSTRAINT sq_reserva_fk
   FOREIGN KEY (sq_reserva)
   REFERENCES livro_reserva (sq_reserva);

ALTER TABLE livro
ADD CONSTRAINT id_autor_fk
   FOREIGN KEY (id_autor)
   REFERENCES autor (livro);

CREATE INDEX emprestimo_index ON emprestimo (sq_emprestimo,id_aluno,sq_livro);
CREATE INDEX reserva_index    on Reservas (sq_reserva,sq_aluno,sq_reserva);