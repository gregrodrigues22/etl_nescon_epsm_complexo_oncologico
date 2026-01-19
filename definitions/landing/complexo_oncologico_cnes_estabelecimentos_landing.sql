CREATE OR REPLACE TABLE `escolap2p.cliente_nescon_epsm.complexo_oncologico_cnes_estabelecimentos_landing` AS
WITH cnes_interesse AS (
  SELECT DISTINCT
    LPAD(CAST(CNES AS STRING), 7, '0') AS cnes
  FROM `escolap2p.cliente_nescon_epsm.complexo_oncologico_cnes_definidos_raw`
),

base_filtrada AS (
  SELECT
    -- chave padronizada para join e auditoria
    LPAD(CAST(id_estabelecimento_cnes AS STRING), 7, '0') AS cnes_padronizado,

    -- competencia como DATE para facilitar uso depois
    DATE(ano, mes, 1) AS competencia_dt,

    -- tudo da fonte
    e.*
  FROM `basedosdados.br_ms_cnes.estabelecimento` e
  JOIN cnes_interesse c
    ON LPAD(CAST(e.id_estabelecimento_cnes AS STRING), 7, '0') = c.cnes
)

SELECT *
FROM base_filtrada
QUALIFY ROW_NUMBER() OVER (
  PARTITION BY cnes_padronizado
  ORDER BY ano DESC, mes DESC
) = 1;