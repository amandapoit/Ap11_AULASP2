# EXERCÍCIOS - AP11

# 1.1 Adicione uma tabela de log ao sistema do restaurante. Ajuste cada procedimento para que ele registre
#   - a data em que a operação aconteceu
#   - o nome do procedimento executado

-- CREATE TABLE tb_log_de_operacoes(
--     cod_operacao SERIAL PRIMARY KEY,
--     data_operacao TIMESTAMP,
--     nome_operacao VARCHAR(200)
-- );

-- SELECT * FROM tb_cliente

-- SELECT * FROM tb_item

-- SELECT * FROM tb_item_pedido

-- SELECT * FROM tb_pedido

-- SELECT * FROM tb_tipo_item

-- SELECT * FROM tb_log_de_operacoes

-- -- CÁLCULO DO TROCO DO PEDIDO 1
-- DO $$
-- DECLARE
--     v_troco INT;
--     v_valor_total INT;
--     v_valor_a_pagar INT := 100;
--     v_cod_pedido INT := 1;
-- BEGIN
--     CALL sp_calcular_valor_de_um_pedido(
--         v_cod_pedido, 
--         v_valor_total
--     );
--     CALL sp_calcular_troco(
--         v_troco,
--         v_valor_a_pagar,
--         v_valor_total
--     );
--     RAISE NOTICE
--         'A conta foi de R$% e você pagou R$%. Troco: R$%',
--         v_valor_total, v_valor_a_pagar, v_troco;
-- END;
-- $$

-- -- CÁLCULO DO TROCO DO PEDIDO 2
-- DO $$
-- DECLARE
--     v_troco INT;
--     v_valor_total INT;
--     v_valor_a_pagar INT := 10;
--     v_cod_pedido INT := 2;
-- BEGIN
--     CALL sp_calcular_valor_de_um_pedido(
--         v_cod_pedido, 
--         v_valor_total
--     );
--     CALL sp_calcular_troco(
--         v_troco,
--         v_valor_a_pagar,
--         v_valor_total
--     );
--     RAISE NOTICE
--         'A conta foi de R$% e você pagou R$%. Troco: R$%',
--         v_valor_total, v_valor_a_pagar, v_troco;
-- END;
-- $$

-- CREATE OR REPLACE PROCEDURE sp_calcular_troco(
--     OUT p_troco INT,
--     IN p_valor_a_pagar INT,
--     IN p_valor_total INT
-- ) LANGUAGE plpgsql
-- AS $$
-- BEGIN
--     INSERT INTO tb_log_de_operacoes (data_operacao, nome_operacao)
--     VALUES (CURRENT_TIMESTAMP, 'Cálculo de Troco');
--     p_troco := p_valor_a_pagar - p_valor_total;
-- END;
-- $$


-- -- FECHA PEDIDO 1
-- DO $$
-- DECLARE
--     v_cod_pedido INT := 1;
-- BEGIN
--     CALL sp_fechar_pedido(200, v_cod_pedido);
-- END;
-- $$

-- -- FECHA PEDIDO 2
-- DO $$
-- DECLARE
--     v_cod_pedido INT := 2;
-- BEGIN
--     CALL sp_fechar_pedido(10, v_cod_pedido);
-- END;
-- $$

-- CREATE OR REPLACE PROCEDURE sp_fechar_pedido(
--     IN p_valor_a_pagar INT,
--     IN p_cod_pedido INT
-- )   LANGUAGE plpgsql
-- AS $$
-- DECLARE
--     v_valor_total INT;
-- BEGIN
--     INSERT INTO tb_log_de_operacoes (data_operacao, nome_operacao)
--     VALUES (CURRENT_TIMESTAMP, 'Fechamento de Pedido');
--     CALL sp_calcular_valor_de_um_pedido(
--         p_cod_pedido,
--         v_valor_total
--     );
--     IF p_valor_a_pagar < v_valor_total THEN
--         RAISE NOTICE 'R$% insuficiente para pagar a conta de R$%',
--         p_valor_a_pagar,
--         v_valor_total;
--     ELSE
--         UPDATE tb_pedido p SET
--         data_modificacao = CURRENT_TIMESTAMP,
--         status = 'fechado'
--         WHERE p.cod_pedido = p_cod_pedido;

--     END IF;
-- END;
-- $$

-- -- CÁLCULO DO PEDIDO 1
-- DO $$
-- DECLARE
--     v_valor_total INT;
--     v_cod_pedido INT := 1;
-- BEGIN 
--     CALL sp_calcular_valor_de_um_pedido(1, v_valor_total);
--     RAISE NOTICE 'Total do pedido %: R$%', v_cod_pedido, v_valor_total;
-- END;
-- $$


-- -- CÁLCULO DO PEDIDO 2
-- DO $$
-- DECLARE
--     v_valor_total INT;
--     v_cod_pedido INT := 2;
-- BEGIN 
--     CALL sp_calcular_valor_de_um_pedido(2, v_valor_total);
--     RAISE NOTICE 'Total do pedido %: R$%', v_cod_pedido, v_valor_total;
-- END;
-- $$

-- CREATE OR REPLACE PROCEDURE sp_calcular_valor_de_um_pedido(
--     IN p_cod_pedido INT, OUT p_valor_total INT
-- )
-- LANGUAGE plpgsql
-- AS $$
-- BEGIN
--     INSERT INTO tb_log_de_operacoes (data_operacao, nome_operacao)
--     VALUES (CURRENT_TIMESTAMP, 'Cálculo do valor total do pedido');
--     SELECT SUM(i.valor) FROM
--         tb_pedido p
--         INNER JOIN tb_item_pedido ip
--         ON p.cod_pedido = ip.cod_pedido
--         INNER JOIN tb_item i
--         ON ip.cod_pedido = i.cod_item
--         WHERE p.cod_cliente = p_cod_pedido
--         INTO $2;
-- END;
-- $$

-- CALL sp_adicionar_item_a_pedido(1, 1);

-- CALL sp_adicionar_item_a_pedido(2, 2);

-- CREATE OR REPLACE PROCEDURE sp_adicionar_item_a_pedido(
--     IN p_cod_item INT, IN p_cod_pedido INT
-- )
-- LANGUAGE plpgsql
-- AS $$
-- BEGIN
--     INSERT INTO tb_log_de_operacoes (data_operacao, nome_operacao)
--     VALUES (CURRENT_TIMESTAMP, 'Adição de Item a Pedido');
--     INSERT INTO tb_item_pedido (cod_item, cod_pedido)
--     VALUES($1, $2);
--     UPDATE tb_pedido p SET
--         data_modificacao = current_timestamp
--         WHERE p.cod_pedido = $2;
-- END;
-- $$

-- -- CRIA NOVO PEDIDO JÁ COM O CLIENTE
-- DO $$
-- DECLARE
--     v_cod_pedido INT;
--     v_cod_cliente INT;
-- BEGIN
--     SELECT cod_cliente FROM tb_cliente 
--         WHERE nome LIKE 'Jonas Samuel' INTO v_cod_cliente;
--     CALL sp_criar_pedido (v_cod_pedido, v_cod_cliente);
--     RAISE NOTICE 'Código do pedido recém criado: %',
--     v_cod_pedido;
-- END;
-- $$


-- CREATE OR REPLACE PROCEDURE sp_criar_pedido(
--     OUT p_cod_pedido INT, IN p_cod_cliente INT
-- )
-- LANGUAGE plpgsql
-- AS $$
-- BEGIN
--     INSERT INTO tb_log_de_operacoes (data_operacao, nome_operacao)
--     VALUES (CURRENT_TIMESTAMP, 'Criação de Pedido');
--     INSERT INTO tb_pedido(cod_cliente) VALUES (p_cod_cliente);
--     SELECT LASTVAL() INTO p_cod_pedido;
-- END;
-- $$

-- CREATE OR REPLACE PROCEDURE sp_criar_pedido_sem_itens(OUT p_cod_pedido integer, IN p_cod_cliente integer DEFAULT NULL::integer)
-- LANGUAGE plpgsql
-- AS $$
-- BEGIN
--     INSERT INTO tb_log_de_operacoes (data_operacao, nome_operacao)
--     VALUES (CURRENT_TIMESTAMP, 'Criação de pedido vazio');
--     Insert INTO tb_pedido (cod_cliente) VALUES (p_cod_pedido);
--     SELECT LASTVAL () INTO p_cod_pedido;
-- END;
-- $$

CALL sp_cadastrar_cliente ('Ana Silva')

CALL sp_cadastrar_cliente ('Jonas Samuel')

-- CREATE OR REPLACE PROCEDURE sp_cadastrar_cliente
-- (IN p_nome VARCHAR(200), IN p_cod_cliente INT DEFAULT NULL)
-- LANGUAGE plpgsql
-- AS $$
-- BEGIN
--     INSERT INTO tb_log_de_operacoes (data_operacao, nome_operacao)
--            VALUES (CURRENT_TIMESTAMP, 'Cadastro de Cliente');
--     IF p_cod_cliente IS NULL THEN
--         INSERT INTO tb_cliente (nome) VALUES (p_nome);
--     ELSE
--         INSERT INTO tb_cliente
--         (cod_cliente, nome) VALUES
--         (p_cod_cliente, p_nome);
--     END IF;
-- END;
-- $$


-- CREATE TABLE tb_item_pedido(
--     --surrogate key
--     cod_item_pedido SERIAL PRIMARY KEY,
--     cod_item INT NOT NULL,
--     cod_pedido INT NOT NULL,
--     CONSTRAINT fk_item FOREIGN KEY(cod_item) REFERENCES
--     tb_item(cod_item),
--     CONSTRAINT fk_pedido FOREIGN KEY(cod_pedido) REFERENCES
--     tb_pedido(cod_pedido)
-- );

-- INSERT INTO tb_item
-- (descricao, valor, cod_tipo)
-- VALUES
-- ('Refrigerante', 7, 1),
-- ('Suco', 8, 1),
-- ('Hamburguer', 12, 2),
-- ('Batata frita', 9, 2);

-- CREATE TABLE tb_item(
--     cod_item SERIAL PRIMARY KEY,
--     descricao VARCHAR(200) NOT NULL,
--     valor NUMERIC(10,2) NOT NULL,
--     cod_tipo INT NOT NULL,
--     CONSTRAINT fk_tipo_item FOREIGN KEY (cod_tipo)
--     REFERENCES tb_tipo_item(cod_tipo)
-- ); 


-- INSERT INTO tb_tipo_item
-- (descricao) VALUES
-- ('Bebida'), ('Comida');


-- CREATE TABLE tb_tipo_item(
--     cod_tipo SERIAL PRIMARY KEY,
--     descricao VARCHAR(200) NOT NULL
-- );

-- CREATE TABLE tb_pedido(
--     cod_pedido SERIAL PRIMARY KEY,
--     data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
--     data_modificacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
--     status VARCHAR(100) DEFAULT 'aberto',
--     cod_cliente INT NOT NULL, -- Uma chave estrangeira pode ser nula ou não se o relacionamento não for obrigatório
--     CONSTRAINT fk_cliente FOREIGN KEY (cod_cliente)
--     REFERENCES tb_cliente(cod_cliente)
-- );

-- CREATE TABLE tb_cliente(
--     cod_cliente SERIAL PRIMARY KEY,
--     nome VARCHAR(200) NOT NULL
-- );




-- -- EXEMPLO 6

-- CALL sp_calcula_media(1);

-- CALL sp_calcula_media(1, 2, 3);

-- CALL sp_calcula_media();

-- CREATE OR REPLACE PROCEDURE sp_calcula_media
-- (VARIADIC p_valores INT[])
-- LANGUAGE plpgsql
-- AS $$
-- DECLARE
--     v_media NUMERIC(10, 2) := 0;
--     v_valor INT;
-- BEGIN
--     FOREACH v_valor IN ARRAY p_valores LOOP
--         v_media := v_media + v_valor;
--     END LOOP;
--     RAISE NOTICE 
--         'A média é %', 
--         v_media / array_length(p_valores, 1); -- é o slice
-- END;
-- $$

-- DROP PROCEDURE IF EXISTS sp_acha_maior;

-- -- EXEMPLO 5

-- --colocando em execução (chamando ou invocando, jamais puxando)
-- DO $$
-- DECLARE
--     v_valor1 INT := 2;
--     v_valor2 INT := 3;
-- BEGIN
--     CALL sp_acha_maior(v_valor1, v_valor2);
--     RAISE NOTICE '% é o maior', v_valor1;
-- END;
-- $$

-- CREATE OR REPLACE PROCEDURE sp_acha_maior
-- (INOUT p_valor1 INT, IN p_valor2 INT)
-- LANGUAGE plpgsql
-- AS $$
-- BEGIN
--     IF $2 > $1 THEN
--         $1 := $2;
--     END IF;
-- END;
-- $$

-- DROP PROCEDURE IF EXISTS sp_acha_maior;

-- -- EXEMPLO 4

-- DO $$
-- DECLARE
--     v_resultado INT;
-- BEGIN
--     CALL sp_acha_maior(v_resultado, 2, 3);
--     RAISE NOTICE '% é o maior', v_resultado;
-- END;
-- $$

-- CREATE OR REPLACE PROCEDURE sp_acha_maior
-- (OUT p_resultado INT, IN p_valor1 INT, IN p_valor2 INT)
-- LANGUAGE plpgsql
-- AS $$
-- BEGIN
--     CASE
--         WHEN p_valor1 > p_valor2 THEN
--             p_resultado := p_valor1;
--         ELSE
--             $1 := p_valor2;
--     END CASE;
-- END;
-- $$


-- -- EXEMPLO 3

-- CALL sp_acha_maior(2,3);

-- CREATE OR REPLACE PROCEDURE sp_acha_maior
-- (IN p_valor1 INT, p_valor2 INT) -- IN é o modo padrão
-- LANGUAGE plpgsql
-- AS $$
-- BEGIN
--     IF p_valor1 > p_valor2 THEN
--         RAISE NOTICE '% é o maior', $1;
--     ELSE
--         RAISE NOTICE '% é o maior', $2;
--     END IF;
-- END;
-- $$


-- -- EXEMPLO 2

-- CALL sp_ola_usuario('Pedro');

-- CREATE OR REPLACE PROCEDURE sp_ola_usuario(p_nome VARCHAR(200))
-- LANGUAGE plpgsql
-- AS $$
-- BEGIN
--     --acessar o parâmetro pelo nome dele
--     RAISE NOTICE 'Olá, %', p_nome;
--     --acessar o parâmetro pelo seu "número identificador, começando do 1"
--     RAISE NOTICE 'Olá, %', $1;
-- END;
-- $$



-- -- EXEMPLO 1

-- CALL sp_ola_procedures();

-- CREATE OR REPLACE PROCEDURE sp_ola_procedures()
-- LANGUAGE plpgsql
-- AS $$
-- BEGIN
--     RAISE NOTICE 'Olá, procedures';
-- END;
-- $$