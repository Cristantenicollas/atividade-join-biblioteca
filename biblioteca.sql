-- ATIVIDADE - JOIN NA BIBLIOTECA DA ESCOLA
-- Banco: biblioteca (PostgreSQL - 192.168.10.37:5432)

-- PARTE 1 - MONTAR O BANCO
CREATE TABLE alunos (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(80) NOT NULL
);

CREATE TABLE emprestimos (
    id SERIAL PRIMARY KEY,
    livro VARCHAR(80) NOT NULL,
    id_aluno INTEGER NOT NULL REFERENCES alunos(id)
);

-- 15 alunos
INSERT INTO alunos (id, nome) VALUES
 (1,  'Ana Souza'),
 (2,  'Bruno Lima'),
 (3,  'Carla Mendes'),
 (4,  'Diego Rocha'),
 (5,  'Elisa Barbosa'),
 (6,  'Felipe Alves'),
 (7,  'Gabriela Nunes'),
 (8,  'Henrique Melo'),
 (9,  'Isabela Pinto'),
 (10, 'João Vitor Costa'),
 (11, 'Karen Dias'),
 (12, 'Lucas Ferreira'),
 (13, 'Mariana Lopes'),
 (14, 'Nathan Ribeiro'),
 (15, 'Olívia Martins');

-- 10 empréstimos (alunos 1 a 10) - alunos 11 a 15 não estão com livro algum
INSERT INTO emprestimos (id, livro, id_aluno) VALUES
 (1,  'O Pequeno Príncipe',                1),
 (2,  'Harry Potter e a Pedra Filosofal',  2),
 (3,  'Turma da Mônica',                   3),
 (4,  'Dom Casmurro',                      4),
 (5,  'A Hora da Estrela',                 5),
 (6,  'O Hobbit',                          6),
 (7,  'Charlie e a Fábrica de Chocolate',  7),
 (8,  'Memórias Póstumas de Brás Cubas',   8),
 (9,  'Percy Jackson o Ladrão de Raios',   9),
 (10, 'A Bolsa Amarela',                  10);

SELECT setval('alunos_id_seq', 15);
SELECT setval('emprestimos_id_seq', 10);


