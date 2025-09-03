CREATE TABLE clientes (
id_cliente SERIAL PRIMARY KEY,
nome VARCHAR(100) NOT NULL,
cpf VARCHAR(11) UNIQUE NOT NULL,
endereco TEXT,
telefone VARCHAR(15)
);

INSERT INTO clientes (nome, cpf, endereco, telefone) VALUES
('João Silva', '12345678900', 'Rua A, 123', '11999990000'),
('Maria Oliveira', '98765432100', 'Rua B, 456', '11988887777');

CREATE TABLE contas (
id_conta SERIAL PRIMARY KEY,
numero_conta VARCHAR(10) UNIQUE NOT NULL,
saldo DECIMAL(10,2) DEFAULT 0,
id_cliente INT REFERENCES clientes(id_cliente) ON DELETE CASCADE
);

INSERT INTO contas (numero_conta, saldo, id_cliente) VALUES
('000123', 1500.00, 1),
('000456', 2300.00, 2);

CREATE TABLE transacoes (
id_transacao SERIAL PRIMARY KEY,
id_conta INT REFERENCES contas(id_conta) ON DELETE CASCADE,
tipo VARCHAR(15) CHECK (tipo IN ('Depósito', 'Saque', 'Transferência')),
valor DECIMAL(10,2) NOT NULL CHECK (valor > 0),
data_transacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
destino_transferencia INT REFERENCES contas(id_conta)
);

INSERT INTO transacoes (id_conta, tipo, valor) VALUES
(1, 'Depósito', 500.00),
(2, 'Saque', 200.00),
(1, 'Transferência', 300.00);

-- Apaga tudo

drop table clientes cascade;
drop table contas cascade;
drop table transacoes cascade;

-- Listar todos os clientes cadastrados:

SELECT * FROM clientes;

--Listar todas as contas e seus respectivos clientes:

SELECT contas.numero_conta, clientes.nome, contas.saldo
FROM contas
INNER JOIN clientes ON contas.id_cliente = clientes.id_cliente;

-- Listar todas as transações registradas:

SELECT transacoes.tipo, transacoes.valor, transacoes.data_transacao,
contas.numero_conta AS origem,
c2.numero_conta AS destino
FROM transacoes
INNER JOIN contas ON transacoes.id_conta = contas.id_conta
LEFT JOIN contas c2 ON transacoes.destino_transferencia = c2.id_conta;

-- Atualizar o saldo de uma conta (exemplo de um depósito):
UPDATE contas
SET saldo = saldo + 500.00
WHERE id_conta = 1;

--Excluir um cliente e suas contas (devido à regra ON DELETE CASCADE, 
-- as contas e transações associadas também serão excluídas automaticamente):
DELETE FROM clientes WHERE id_cliente = 2;



-- Atividade Prática (Individual)
-- Insira um novo cliente no sistema.

INSERT INTO clientes (nome, cpf, endereco, telefone) VALUES
('Pedro Souza', '23456789100', 'Rua C, 789', '11988880001');

SELECT * FROM clientes;

-- Crie uma conta para esse novo cliente.

INSERT INTO contas (numero_conta, saldo, id_cliente) VALUES
('000789', 1900.00, 3);

select * from contas;

-- Realize uma transferência de R$ 100,00 da conta 000123 para a conta 000789

select * from contas where id_conta = 1 union
select * from contas where id_conta = 3;

UPDATE contas
SET saldo = saldo - 100.00
WHERE id_conta = 1;

UPDATE contas
SET saldo = saldo + 100.00
WHERE id_conta = 3;

select * from contas where id_conta = 1 union
select * from contas where id_conta = 3;

-- Liste todas as contas do banco, mostrando os saldos atualizados.

select * from contas;