-- CONSULTAS DA ATIVIDADE (executar após biblioteca.sql)

-- 1) Todos os dados de cada tabela
SELECT * FROM alunos;
SELECT * FROM emprestimos;

-- 2) INNER JOIN: nome do aluno e o livro que ele pegou
SELECT a.nome, e.livro
FROM alunos a
INNER JOIN emprestimos e ON e.id_aluno = a.id;

-- 3) LEFT JOIN: TODOS os alunos e o livro de cada um
SELECT a.nome, e.livro
FROM alunos a
LEFT JOIN emprestimos e ON e.id_aluno = a.id;

-- 4) Alunos que NUNCA pegaram livro
SELECT a.id, a.nome
FROM alunos a
LEFT JOIN emprestimos e ON e.id_aluno = a.id
WHERE e.id IS NULL;

-- 5) Tentar registrar empréstimo para o aluno 50 (não existe)
-- Esperado: erro de chave estrangeira (foreign key violation)
INSERT INTO emprestimos (livro, id_aluno) VALUES ('Turma da Mônica', 50);
