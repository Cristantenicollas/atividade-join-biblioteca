# ATIVIDADE – JOIN NA BIBLIOTECA DA ESCOLA

**Banco:** PostgreSQL – `192.168.10.37:5432`, database **`biblioteca`**
**Arquivos:** `biblioteca.sql` (Parte 1 – montar o banco) • `consultas.sql` (Parte 2 – as consultas)

---

## PARTE 1 – MONTAR O BANCO

```sql
CREATE TABLE alunos (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(80) NOT NULL
);

CREATE TABLE emprestimos (
    id SERIAL PRIMARY KEY,
    livro VARCHAR(80) NOT NULL,
    id_aluno INTEGER NOT NULL REFERENCES alunos(id)
);
```

- **alunos**: 15 alunos (ids 1 a 15)
- **emprestimos**: 10 livros emprestados (alunos 1 a 10) → **5 alunos não estão com livro algum** (ids 11 a 15)
- `emprestimos.id_aluno` é **chave estrangeira** (`REFERENCES alunos(id)`): o empréstimo guarda o **número** do aluno, não o nome.

---

## PARTE 2 – CONSULTAS E RESPOSTAS

### 1) Todos os dados de cada tabela

```sql
SELECT * FROM alunos;
SELECT * FROM emprestimos;
```

**alunos (15 linhas)**

| id | nome |
|----|------|
| 1 | Ana Souza |
| 2 | Bruno Lima |
| 3 | Carla Mendes |
| 4 | Diego Rocha |
| 5 | Elisa Barbosa |
| 6 | Felipe Alves |
| 7 | Gabriela Nunes |
| 8 | Henrique Melo |
| 9 | Isabela Pinto |
| 10 | João Vitor Costa |
| 11 | Karen Dias |
| 12 | Lucas Ferreira |
| 13 | Mariana Lopes |
| 14 | Nathan Ribeiro |
| 15 | Olívia Martins |

**emprestimos (10 linhas)**

| id | livro | id_aluno |
|----|-------|----------|
| 1 | O Pequeno Príncipe | 1 |
| 2 | Harry Potter e a Pedra Filosofal | 2 |
| 3 | Turma da Mônica | 3 |
| 4 | Dom Casmurro | 4 |
| 5 | A Hora da Estrela | 5 |
| 6 | O Hobbit | 6 |
| 7 | Charlie e a Fábrica de Chocolate | 7 |
| 8 | Memórias Póstumas de Brás Cubas | 8 |
| 9 | Percy Jackson o Ladrão de Raios | 9 |
| 10 | A Bolsa Amarela | 10 |

---

### 2) INNER JOIN – nome do aluno e o livro que ele pegou

```sql
SELECT a.nome, e.livro
FROM alunos a
INNER JOIN emprestimos e ON e.id_aluno = a.id;
```

| nome | livro |
|------|-------|
| Ana Souza | O Pequeno Príncipe |
| Bruno Lima | Harry Potter e a Pedra Filosofal |
| Carla Mendes | Turma da Mônica |
| Diego Rocha | Dom Casmurro |
| Elisa Barbosa | A Hora da Estrela |
| Felipe Alves | O Hobbit |
| Gabriela Nunes | Charlie e a Fábrica de Chocolate |
| Henrique Melo | Memórias Póstumas de Brás Cubas |
| Isabela Pinto | Percy Jackson o Ladrão de Raios |
| João Vitor Costa | A Bolsa Amarela |

*(10 linhas)*

**Resposta – quais alunos NÃO apareceram? Por quê?**
Não apareceram **Karen Dias, Lucas Ferreira, Mariana Lopes, Nathan Ribeiro e Olívia Martins** (alunos 11 a 15). O `INNER JOIN` só devolve as linhas em que a condição `ON e.id_aluno = a.id` encontra correspondência **nas duas tabelas**; esses alunos não têm nenhum registro em `emprestimos`, portanto a linha deles é descartada.

---

### 3) LEFT JOIN – TODOS os alunos e o livro de cada um

```sql
SELECT a.nome, e.livro
FROM alunos a
LEFT JOIN emprestimos e ON e.id_aluno = a.id;
```

| nome | livro |
|------|-------|
| Ana Souza | O Pequeno Príncipe |
| Bruno Lima | Harry Potter e a Pedra Filosofal |
| Carla Mendes | Turma da Mônica |
| Diego Rocha | Dom Casmurro |
| Elisa Barbosa | A Hora da Estrela |
| Felipe Alves | O Hobbit |
| Gabriela Nunes | Charlie e a Fábrica de Chocolate |
| Henrique Melo | Memórias Póstumas de Brás Cubas |
| Isabela Pinto | Percy Jackson o Ladrão de Raios |
| João Vitor Costa | A Bolsa Amarela |
| Karen Dias | NULL |
| Lucas Ferreira | NULL |
| Mariana Lopes | NULL |
| Nathan Ribeiro | NULL |
| Olívia Martins | NULL |

*(15 linhas)*

**Resposta – o que apareceu na coluna `livro` para quem não pegou nenhum livro?**
Apareceu **NULL** (valor nulo, “vazio”). O `LEFT JOIN` mantém **todas** as linhas da tabela da esquerda (`alunos`), mesmo quando não há correspondência em `emprestimos`; nesse caso as colunas da tabela da direita entram como `NULL`.

---

### 4) Alunos que NUNCA pegaram livro

```sql
SELECT a.id, a.nome
FROM alunos a
LEFT JOIN emprestimos e ON e.id_aluno = a.id
WHERE e.id IS NULL;
```

| id | nome |
|----|------|
| 11 | Karen Dias |
| 12 | Lucas Ferreira |
| 13 | Mariana Lopes |
| 14 | Nathan Ribeiro |
| 15 | Olívia Martins |

*(5 linhas)*

> O `WHERE e.id IS NULL` filtra apenas os alunos que **não** tiveram nenhuma linha correspondente em `emprestimos`.
> Forma alternativa: `SELECT * FROM alunos a WHERE NOT EXISTS (SELECT 1 FROM emprestimos e WHERE e.id_aluno = a.id);`

---

### 5) INSERT para o aluno 50

```sql
INSERT INTO emprestimos (livro, id_aluno) VALUES ('Turma da Mônica', 50);
```

**O que aconteceu (saída real):**

```
ERROR:  insert or update on table "emprestimos" violates foreign key constraint "emprestimos_id_aluno_fkey"
DETAIL:  Key (id_aluno)=(50) is not present in table "alunos".
(SQLSTATE 23503 – foreign key violation)
```

**Resposta – o que aconteceu? Por quê?**
A inserção foi **recusada com erro de chave estrangeira**. A coluna `emprestimos.id_aluno` tem a restrição `REFERENCES alunos(id)`, ou seja, só pode guardar números que **existam na tabela `alunos`**. Como o aluno **50 não existe** (só há alunos de 1 a 15), o banco bloqueia o INSERT para não permitir um empréstimo apontando para um aluno inexistente — nada foi inserido.

*(Em MySQL o mesmo INSERT geraria o erro **1452** – "Cannot add or update a child row: a foreign key constraint fails", pela mesma causa.)*.
