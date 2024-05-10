
CREATE OR ALTER VIEW [SOFIPO].[MTS_VL_CASOS_24H_REPORTE] AS

  SELECT
    CONVERT(CHAR, GETDATE(), 103)                                            AS                    FECHA_PERIODO,
    CONVERT(VARCHAR(10), GETDATE(), 112)                                     AS                    PERIODO,
         null as FOLIO,
    CASOS_MANUALES.CVE_TIPO_REPORTE                                          AS                    TIPO_REPORTE,
    2                                                                                              TIPO_REPORTE_CASO,
    ( SELECT ENTIDADFINID
                                         FROM [MELTSAN].MTS_ADM_LICENCIAS
                                         WHERE CVE_ACRONIMO = 'SOFIPO')        AS                    SUJETO_OBLIGADO,
    RIGHT('000000' + CASOS_MANUALES.ORGANISMOSUPID_CASOS, 6)                 AS                    ORGANO_SUPERVISOR,
    --CASOS_MANUALES.SUCURSALID                                             AS CVE_SUCURSAL,
    '0'                                                                      AS                    CVE_SUCURSAL,
    (SELECT DS_SUCURSAL
     FROM SOFIPO.MTS_DSUCURSALES S
     WHERE S.SUCURSALID = CASOS_MANUALES.SUCURSALID)                                               DS_SUCURSAL,
    (SELECT CVE_LOCALIDAD
     FROM SOFIPO.MTS_DSUCURSALES S
     WHERE S.SUCURSALID =
           CASOS_MANUALES.SUCURSALID)                                                              CVE_LOCALIDAD_SUCURSAL,
    RIGHT('0' + LTRIM(RTRIM(CASOS_MANUALES.TIPOOPERACIONID)), 2)             AS                    CVE_TIPOOPERACION,
    (SELECT DS_TIPO_OPERACION
     FROM SOFIPO.MTS_DTIPO_OPERACIONES
     WHERE TIPOOPERACIONID = CASOS_MANUALES.TIPOOPERACIONID)                                       DS_TIPO_OPERACION,
    --RIGHT('0' + LTRIM(RTRIM(CASOS_MANUALES.INSTRMONETARIOID)), 2) AS CVE_INSTRMONETARIO,
    right(('0' + LTRIM(RTRIM(CASE CASOS_MANUALES.INSTRMONETARIOID
                             WHEN 11
                               THEN '03'
                             WHEN 12
                               THEN '03'
                             WHEN 13
                               THEN '03'
                             ELSE CASOS_MANUALES.INSTRMONETARIOID END))), 2) AS                    CVE_INSTRMONETARIO,
    (SELECT DS_INST_MONETARIO
     FROM SOFIPO.MTS_DINSTRUMENTO_MONETARIO
     WHERE INSTRMONETARIOID = CASOS_MANUALES.INSTRMONETARIOID)                                     DS_INST_MONETARIO,
    CASOS_MANUALES.NUMPOLIZACNTR_CASOS                                       AS                    NUMPOLIZACNTR,
    REPLACE(CONVERT(VARCHAR(40), (CAST(CASOS_MANUALES.MONTOMNCNTR_CASOS AS MONEY)), 1), '.00', '') MONTOCNTR,
    CAST(CASOS_MANUALES.MONTOMNCNTR_CASOS AS DECIMAL(14, 2))                                       MONTO,
    CASOS_MANUALES.MONEDAID                                                  AS                    CVE_MONEDA,
    (SELECT DS_MONEDA
     FROM SOFIPO.MTS_DMONEDA
     WHERE MONEDAID = CASOS_MANUALES.MONEDAID)                                                     DS_MONEDA,
    CONVERT(CHAR, CASOS_MANUALES.FECHAOPERACIONCNTR_CASOS, 103)              AS                    FECHAOPERACIONCNTR,
    CONVERT(CHAR, CASOS_MANUALES.FECHAOPERACIONCNTR_CASOS, 112)              AS                    FECHA_OPERACION,
    NULL                                                                                           CONTRATANTEID,
    NULL                                                                                           CONTRATANTECD,
    CASOS_MANUALES.CONTRATANTE_CASOS                                         AS                    NOMBRE,
    CASOS_MANUALES.CONTRATANTEPATERNO_CASOS                                  AS                    APELLIDO_PATERNO,
    CASOS_MANUALES.CONTRATANTEMATERNO_CASOS                                  AS                    APELLIDO_MATERNO,
    CASOS_MANUALES.RAZONSOCIALCNTR_CASOS                                     AS                    RAZONSOCIAL,
    CASOS_MANUALES.TIPOPERSONAFISCALID,
    (SELECT TIPOPERSONAFISCAL
     FROM SOFIPO.MTS_DTIPOPERSONAFISCAL
     WHERE TIPOPERSONAFISCALID = CASOS_MANUALES.TIPOPERSONAFISCALID)                               DS_TIPOPERSONAFISCAL,
    (SELECT NAC.NACIONALIDADID
     FROM SOFIPO.MTS_DPAIS PA, SOFIPO.MTS_DNACIONALIDAD NAC
     WHERE PA.PAISID = NAC.PAISID AND NAC.NACIONALIDADID = CASOS_MANUALES.NACIONALIDADID)          CVE_NACIONALIDAD,
    (SELECT N.NACIONALIDAD
     FROM SOFIPO.MTS_DNACIONALIDAD N
     WHERE N.NACIONALIDADID = CASOS_MANUALES.NACIONALIDADID)                                       DS_NACIONALIDAD,
    LTRIM(RTRIM(CASOS_MANUALES.CONTRATANTEDIRECCION_CASOS + ' ' + CASOS_MANUALES.NO_EXTERIOR + ' ' +
                CASOS_MANUALES.CODIGO_POSTAL))                               AS                    DIRECCION,
    CASOS_MANUALES.CONTRATANTEDIRECCION_CASOS                                AS                    CALLE,
    CASOS_MANUALES.NO_EXTERIOR,
    CASOS_MANUALES.NO_INTERIOR,
    CASOS_MANUALES.CODIGO_POSTAL,
    CASOS_MANUALES.CONTRATANTETELEFONO_CASOS                                 AS                    TELEFONO,
    CONVERT(CHAR, CASOS_MANUALES.CONTRATANTEEDADCONT, 103)                   AS                    CONTRATANTEFECHANAC,
    CONVERT(CHAR, CASOS_MANUALES.CONTRATANTEEDADCONT, 103)                   AS                    CONTRATANTEEDADCONT,
    (SELECT CASE WHEN CASOS_MANUALES.TIPOPERSONAFISCALID = 1
      THEN
        CONVERT(CHAR, CASOS_MANUALES.CONTRATANTEFECHANAC_CASOS, 112)
            ELSE CONVERT(CHAR, CASOS_MANUALES.CONTRATANTEFECHANAC_CASOS, 112)
            END)                                                             AS                    FECHA_NAC_CONT,
    CASOS_MANUALES.CONTRATANTECURP_CASOS                                     AS                    CURP,
    CASOS_MANUALES.CONTRATANTERFC_CASOS                                      AS                    RFC,
    CASOS_MANUALES.PAISID,
    (SELECT DS_PAIS
     FROM SOFIPO.MTS_DPAIS
     WHERE PAISID = CASOS_MANUALES.PAISID)                                                         DS_PAIS_DOMICILIO,
    CASOS_MANUALES.ESTADOID,
    (SELECT DISTINCT DS_D_ESTADO
     FROM SOFIPO.MTS_ADM_SEPOMEX SEPOMEX
     WHERE SEPOMEX.CVE_ID_ASENTA_CPCONS = CASOS_MANUALES.COLONIAID
           AND SEPOMEX.CVE_C_MNPIO = CASOS_MANUALES.MUNICIPIOID
           AND SEPOMEX.CVE_C_ESTADO = CASOS_MANUALES.ESTADOID)                                     DS_ESTADO,
    CASOS_MANUALES.MUNICIPIOID,
    (SELECT DISTINCT DS_D_MNPIO
     FROM SOFIPO.MTS_ADM_SEPOMEX SEPOMEX
     WHERE SEPOMEX.CVE_ID_ASENTA_CPCONS = CASOS_MANUALES.COLONIAID
           AND SEPOMEX.CVE_C_MNPIO = CASOS_MANUALES.MUNICIPIOID
           AND SEPOMEX.CVE_C_ESTADO = CASOS_MANUALES.ESTADOID)                                     DS_MUNICIPIO,
    CASOS_MANUALES.COLONIAID,
    (SELECT DISTINCT DS_D_ASENTA
     FROM SOFIPO.MTS_ADM_SEPOMEX SEPOMEX
     WHERE SEPOMEX.CVE_ID_ASENTA_CPCONS = CASOS_MANUALES.COLONIAID
           AND SEPOMEX.CVE_C_MNPIO = CASOS_MANUALES.MUNICIPIOID
           AND SEPOMEX.CVE_C_ESTADO = CASOS_MANUALES.ESTADOID)                                     DES_COLONIA,
    CASOS_MANUALES.ACTIVIDADECOID                                            AS                    CVE_ACTIVIDADECO,
    (SELECT DS_ACTIVIDADECO
     FROM SOFIPO.MTS_DACTIVIDADECONOMICA
     WHERE ACTIVIDADECOID = CASOS_MANUALES.ACTIVIDADECOID)                                         DS_ACTIVIDADECO,
    (SELECT CASE WHEN CASOS_MANUALES.CVE_LOCALIDAD IS NULL
      THEN CASOS_MANUALES.MUNICIPIOID
            ELSE CASOS_MANUALES.CVE_LOCALIDAD END)                           AS                    CVE_LOCALIDAD,
    (SELECT DS_LOCALIDAD
     FROM SOFIPO.MTS_CLOCALIDADES_CNBV
     WHERE CVE_LOCALIDAD = CASOS_MANUALES.CVE_LOCALIDAD)                                           DS_LOCALIDAD,
    CASOS_MANUALES.CIERREID,
    CASOS_MANUALES.CASOSID,
    NULL                                                                                           ESTATUS_OPERACION,
    CASOS_MANUALES.CVE_TIPO_ANALISIS,
    (SELECT VALOR_ATRIBUTO_01
     FROM SOFIPO.MTS_ANA_DCATALOGOS_CLAVES
     WHERE CVE_TABLA = 'CAT_TIPO_ANALISIS'
           AND VIGENCIA = 'S' AND CLAVE_01 = CASOS_MANUALES.CVE_TIPO_ANALISIS)                     DS_TIPO_ANALISIS,
    CONVERT(CHAR, CASOS_MANUALES.FECHADETECION_CASOS, 103)                   AS                    FECHADETECION_CASOS,
    CONVERT(CHAR, CASOS_MANUALES.FECHADETECION_CASOS, 112)                   AS                    FECHA_DETECCION,
    CASOS_MANUALES.AGENTENOMBRE_CASOS                                        AS                    AGENTENOMBRE,
    CASOS_MANUALES.AGENTEPATERNO_CASOS                                       AS                    AGENTEPATERNO,
    CASOS_MANUALES.AGENTEMATERNO_CASOS                                       AS                    AGENTEMATERNO,
    CASOS_MANUALES.AGENTERFC_CASOS                                           AS                    AGENTERFC,
    CASOS_MANUALES.AGENTECURP_CASOS                                          AS                    AGENTECURP,
    CONVERT(VARCHAR(10), CASOS_MANUALES.CONSECNTAREL_CASOS)                  AS                    CONSECNTAREL,
    CASOS_MANUALES.NUMPOLIZABENEF_CASOS                                      AS                    NUMPOLIZABENEF,
    CASOS_MANUALES.ENTIDADFINIDBENEF_CASOS                                   AS                    DS_ENTIDADFINIDBENEF,
    CASOS_MANUALES.BENEFICIARIO_CASOS                                        AS                    BENEFICIARIOS,
    CASOS_MANUALES.BENEFICIARIOPATERNO_CASOS                                 AS                    BENEFICIARIOPATERNO,
    CASOS_MANUALES.BENEFICIARIOMATERNO_CASOS                                 AS                    BENEFICIARIOMATERNO,
    CASOS_MANUALES.DESOPERACION_CASOS                                        AS                    DS_DESOPERACION,
    CASOS_MANUALES.RAZONOPERACION_CASOS                                      AS                    RAZONOPERACION,
    CASOS_MANUALES.SW_CASO_MANUAL,
    CASOS_MANUALES.CVE_TIPOINUSUALIDAD,
    (CASE CASOS_MANUALES.CVE_TIPOINUSUALIDAD
     WHEN 'O'
       THEN 'OPERATIVA'
     WHEN 'T'
       THEN 'TRANSACCION'
     ELSE ' ' END)                                                           AS                    DS_TIPOINUSUALIDAD,
    NULL                                                                                           OPERCNTRID,
    NULL                                                                                           CODOPER
  FROM SOFIPO.MTS_ANA_HRN_CASOS_POLIZAS_AUD CASOS_MANUALES
  WHERE CASOS_MANUALES.CVE_TIPO_ANALISIS = 'TA24H'


go

/************************************************************************************************************************************************/

CREATE OR ALTER VIEW [SAPI].[MTS_VL_CASOS_24H_REPORTE] AS

  SELECT
    CONVERT(CHAR, GETDATE(), 103)                                            AS                    FECHA_PERIODO,
    CONVERT(VARCHAR(10), GETDATE(), 112)                                     AS                    PERIODO,
         null as FOLIO,
    CASOS_MANUALES.CVE_TIPO_REPORTE                                          AS                    TIPO_REPORTE,
    2                                                                                              TIPO_REPORTE_CASO,
    ( SELECT ENTIDADFINID
                                         FROM [MELTSAN].MTS_ADM_LICENCIAS
                                         WHERE CVE_ACRONIMO = 'SAPI')        AS                    SUJETO_OBLIGADO,
    RIGHT('000000' + CASOS_MANUALES.ORGANISMOSUPID_CASOS, 6)                 AS                    ORGANO_SUPERVISOR,
    --CASOS_MANUALES.SUCURSALID                                             AS CVE_SUCURSAL,
    '0'                                                                      AS                    CVE_SUCURSAL,
    (SELECT DS_SUCURSAL
     FROM SAPI.MTS_DSUCURSALES S
     WHERE S.SUCURSALID = CASOS_MANUALES.SUCURSALID)                                               DS_SUCURSAL,
    (SELECT CVE_LOCALIDAD
     FROM SAPI.MTS_DSUCURSALES S
     WHERE S.SUCURSALID =
           CASOS_MANUALES.SUCURSALID)                                                              CVE_LOCALIDAD_SUCURSAL,
    RIGHT('0' + LTRIM(RTRIM(CASOS_MANUALES.TIPOOPERACIONID)), 2)             AS                    CVE_TIPOOPERACION,
    (SELECT DS_TIPO_OPERACION
     FROM SAPI.MTS_DTIPO_OPERACIONES
     WHERE TIPOOPERACIONID = CASOS_MANUALES.TIPOOPERACIONID)                                       DS_TIPO_OPERACION,
    --RIGHT('0' + LTRIM(RTRIM(CASOS_MANUALES.INSTRMONETARIOID)), 2) AS CVE_INSTRMONETARIO,
    right(('0' + LTRIM(RTRIM(CASE CASOS_MANUALES.INSTRMONETARIOID
                             WHEN 11
                               THEN '03'
                             WHEN 12
                               THEN '03'
                             WHEN 13
                               THEN '03'
                             ELSE CASOS_MANUALES.INSTRMONETARIOID END))), 2) AS                    CVE_INSTRMONETARIO,
    (SELECT DS_INST_MONETARIO
     FROM SAPI.MTS_DINSTRUMENTO_MONETARIO
     WHERE INSTRMONETARIOID = CASOS_MANUALES.INSTRMONETARIOID)                                     DS_INST_MONETARIO,
    CASOS_MANUALES.NUMPOLIZACNTR_CASOS                                       AS                    NUMPOLIZACNTR,
    REPLACE(CONVERT(VARCHAR(40), (CAST(CASOS_MANUALES.MONTOMNCNTR_CASOS AS MONEY)), 1), '.00', '') MONTOCNTR,
    CAST(CASOS_MANUALES.MONTOMNCNTR_CASOS AS DECIMAL(14, 2))                                       MONTO,
    CASOS_MANUALES.MONEDAID                                                  AS                    CVE_MONEDA,
    (SELECT DS_MONEDA
     FROM SAPI.MTS_DMONEDA
     WHERE MONEDAID = CASOS_MANUALES.MONEDAID)                                                     DS_MONEDA,
    CONVERT(CHAR, CASOS_MANUALES.FECHAOPERACIONCNTR_CASOS, 103)              AS                    FECHAOPERACIONCNTR,
    CONVERT(CHAR, CASOS_MANUALES.FECHAOPERACIONCNTR_CASOS, 112)              AS                    FECHA_OPERACION,
    NULL                                                                                           CONTRATANTEID,
    NULL                                                                                           CONTRATANTECD,
    CASOS_MANUALES.CONTRATANTE_CASOS                                         AS                    NOMBRE,
    CASOS_MANUALES.CONTRATANTEPATERNO_CASOS                                  AS                    APELLIDO_PATERNO,
    CASOS_MANUALES.CONTRATANTEMATERNO_CASOS                                  AS                    APELLIDO_MATERNO,
    CASOS_MANUALES.RAZONSOCIALCNTR_CASOS                                     AS                    RAZONSOCIAL,
    CASOS_MANUALES.TIPOPERSONAFISCALID,
    (SELECT TIPOPERSONAFISCAL
     FROM SAPI.MTS_DTIPOPERSONAFISCAL
     WHERE TIPOPERSONAFISCALID = CASOS_MANUALES.TIPOPERSONAFISCALID)                               DS_TIPOPERSONAFISCAL,
    (SELECT NAC.NACIONALIDADID
     FROM SAPI.MTS_DPAIS PA, SAPI.MTS_DNACIONALIDAD NAC
     WHERE PA.PAISID = NAC.PAISID AND NAC.NACIONALIDADID = CASOS_MANUALES.NACIONALIDADID)          CVE_NACIONALIDAD,
    (SELECT N.NACIONALIDAD
     FROM SAPI.MTS_DNACIONALIDAD N
     WHERE N.NACIONALIDADID = CASOS_MANUALES.NACIONALIDADID)                                       DS_NACIONALIDAD,
    LTRIM(RTRIM(CASOS_MANUALES.CONTRATANTEDIRECCION_CASOS + ' ' + CASOS_MANUALES.NO_EXTERIOR + ' ' +
                CASOS_MANUALES.CODIGO_POSTAL))                               AS                    DIRECCION,
    CASOS_MANUALES.CONTRATANTEDIRECCION_CASOS                                AS                    CALLE,
    CASOS_MANUALES.NO_EXTERIOR,
    CASOS_MANUALES.NO_INTERIOR,
    CASOS_MANUALES.CODIGO_POSTAL,
    CASOS_MANUALES.CONTRATANTETELEFONO_CASOS                                 AS                    TELEFONO,
    CONVERT(CHAR, CASOS_MANUALES.CONTRATANTEEDADCONT, 103)                   AS                    CONTRATANTEFECHANAC,
    CONVERT(CHAR, CASOS_MANUALES.CONTRATANTEEDADCONT, 103)                   AS                    CONTRATANTEEDADCONT,
    (SELECT CASE WHEN CASOS_MANUALES.TIPOPERSONAFISCALID = 1
      THEN
        CONVERT(CHAR, CASOS_MANUALES.CONTRATANTEFECHANAC_CASOS, 112)
            ELSE CONVERT(CHAR, CASOS_MANUALES.CONTRATANTEFECHANAC_CASOS, 112)
            END)                                                             AS                    FECHA_NAC_CONT,
    CASOS_MANUALES.CONTRATANTECURP_CASOS                                     AS                    CURP,
    CASOS_MANUALES.CONTRATANTERFC_CASOS                                      AS                    RFC,
    CASOS_MANUALES.PAISID,
    (SELECT DS_PAIS
     FROM SAPI.MTS_DPAIS
     WHERE PAISID = CASOS_MANUALES.PAISID)                                                         DS_PAIS_DOMICILIO,
    CASOS_MANUALES.ESTADOID,
    (SELECT DISTINCT DS_D_ESTADO
     FROM SAPI.MTS_ADM_SEPOMEX SEPOMEX
     WHERE SEPOMEX.CVE_ID_ASENTA_CPCONS = CASOS_MANUALES.COLONIAID
           AND SEPOMEX.CVE_C_MNPIO = CASOS_MANUALES.MUNICIPIOID
           AND SEPOMEX.CVE_C_ESTADO = CASOS_MANUALES.ESTADOID)                                     DS_ESTADO,
    CASOS_MANUALES.MUNICIPIOID,
    (SELECT DISTINCT DS_D_MNPIO
     FROM SAPI.MTS_ADM_SEPOMEX SEPOMEX
     WHERE SEPOMEX.CVE_ID_ASENTA_CPCONS = CASOS_MANUALES.COLONIAID
           AND SEPOMEX.CVE_C_MNPIO = CASOS_MANUALES.MUNICIPIOID
           AND SEPOMEX.CVE_C_ESTADO = CASOS_MANUALES.ESTADOID)                                     DS_MUNICIPIO,
    CASOS_MANUALES.COLONIAID,
    (SELECT DISTINCT DS_D_ASENTA
     FROM SAPI.MTS_ADM_SEPOMEX SEPOMEX
     WHERE SEPOMEX.CVE_ID_ASENTA_CPCONS = CASOS_MANUALES.COLONIAID
           AND SEPOMEX.CVE_C_MNPIO = CASOS_MANUALES.MUNICIPIOID
           AND SEPOMEX.CVE_C_ESTADO = CASOS_MANUALES.ESTADOID)                                     DES_COLONIA,
    CASOS_MANUALES.ACTIVIDADECOID                                            AS                    CVE_ACTIVIDADECO,
    (SELECT DS_ACTIVIDADECO
     FROM SAPI.MTS_DACTIVIDADECONOMICA
     WHERE ACTIVIDADECOID = CASOS_MANUALES.ACTIVIDADECOID)                                         DS_ACTIVIDADECO,
    (SELECT CASE WHEN CASOS_MANUALES.CVE_LOCALIDAD IS NULL
      THEN CASOS_MANUALES.MUNICIPIOID
            ELSE CASOS_MANUALES.CVE_LOCALIDAD END)                           AS                    CVE_LOCALIDAD,
    (SELECT DS_LOCALIDAD
     FROM SAPI.MTS_CLOCALIDADES_CNBV
     WHERE CVE_LOCALIDAD = CASOS_MANUALES.CVE_LOCALIDAD)                                           DS_LOCALIDAD,
    CASOS_MANUALES.CIERREID,
    CASOS_MANUALES.CASOSID,
    NULL                                                                                           ESTATUS_OPERACION,
    CASOS_MANUALES.CVE_TIPO_ANALISIS,
    (SELECT VALOR_ATRIBUTO_01
     FROM SAPI.MTS_ANA_DCATALOGOS_CLAVES
     WHERE CVE_TABLA = 'CAT_TIPO_ANALISIS'
           AND VIGENCIA = 'S' AND CLAVE_01 = CASOS_MANUALES.CVE_TIPO_ANALISIS)                     DS_TIPO_ANALISIS,
    CONVERT(CHAR, CASOS_MANUALES.FECHADETECION_CASOS, 103)                   AS                    FECHADETECION_CASOS,
    CONVERT(CHAR, CASOS_MANUALES.FECHADETECION_CASOS, 112)                   AS                    FECHA_DETECCION,
    CASOS_MANUALES.AGENTENOMBRE_CASOS                                        AS                    AGENTENOMBRE,
    CASOS_MANUALES.AGENTEPATERNO_CASOS                                       AS                    AGENTEPATERNO,
    CASOS_MANUALES.AGENTEMATERNO_CASOS                                       AS                    AGENTEMATERNO,
    CASOS_MANUALES.AGENTERFC_CASOS                                           AS                    AGENTERFC,
    CASOS_MANUALES.AGENTECURP_CASOS                                          AS                    AGENTECURP,
    CONVERT(VARCHAR(10), CASOS_MANUALES.CONSECNTAREL_CASOS)                  AS                    CONSECNTAREL,
    CASOS_MANUALES.NUMPOLIZABENEF_CASOS                                      AS                    NUMPOLIZABENEF,
    CASOS_MANUALES.ENTIDADFINIDBENEF_CASOS                                   AS                    DS_ENTIDADFINIDBENEF,
    CASOS_MANUALES.BENEFICIARIO_CASOS                                        AS                    BENEFICIARIOS,
    CASOS_MANUALES.BENEFICIARIOPATERNO_CASOS                                 AS                    BENEFICIARIOPATERNO,
    CASOS_MANUALES.BENEFICIARIOMATERNO_CASOS                                 AS                    BENEFICIARIOMATERNO,
    CASOS_MANUALES.DESOPERACION_CASOS                                        AS                    DS_DESOPERACION,
    CASOS_MANUALES.RAZONOPERACION_CASOS                                      AS                    RAZONOPERACION,
    CASOS_MANUALES.SW_CASO_MANUAL,
    CASOS_MANUALES.CVE_TIPOINUSUALIDAD,
    (CASE CASOS_MANUALES.CVE_TIPOINUSUALIDAD
     WHEN 'O'
       THEN 'OPERATIVA'
     WHEN 'T'
       THEN 'TRANSACCION'
     ELSE ' ' END)                                                           AS                    DS_TIPOINUSUALIDAD,
    NULL                                                                                           OPERCNTRID,
    NULL                                                                                           CODOPER
  FROM SAPI.MTS_ANA_HRN_CASOS_POLIZAS_AUD CASOS_MANUALES
  WHERE CASOS_MANUALES.CVE_TIPO_ANALISIS = 'TA24H'


go





/************************************************************************************************************************************************/

CREATE OR ALTER VIEW [SOFOM].[MTS_VL_CASOS_24H_REPORTE] AS

  SELECT
    CONVERT(CHAR, GETDATE(), 103)                                            AS                    FECHA_PERIODO,
    CONVERT(VARCHAR(10), GETDATE(), 112)                                     AS                    PERIODO,
         null as FOLIO,
    CASOS_MANUALES.CVE_TIPO_REPORTE                                          AS                    TIPO_REPORTE,
    2                                                                                              TIPO_REPORTE_CASO,
    ( SELECT ENTIDADFINID
                                         FROM [MELTSAN].MTS_ADM_LICENCIAS
                                         WHERE CVE_ACRONIMO = 'SOFOM')        AS                    SUJETO_OBLIGADO,
    RIGHT('000000' + CASOS_MANUALES.ORGANISMOSUPID_CASOS, 6)                 AS                    ORGANO_SUPERVISOR,
    --CASOS_MANUALES.SUCURSALID                                             AS CVE_SUCURSAL,
    '0'                                                                      AS                    CVE_SUCURSAL,
    (SELECT DS_SUCURSAL
     FROM SOFOM.MTS_DSUCURSALES S
     WHERE S.SUCURSALID = CASOS_MANUALES.SUCURSALID)                                               DS_SUCURSAL,
    (SELECT CVE_LOCALIDAD
     FROM SOFOM.MTS_DSUCURSALES S
     WHERE S.SUCURSALID =
           CASOS_MANUALES.SUCURSALID)                                                              CVE_LOCALIDAD_SUCURSAL,
    RIGHT('0' + LTRIM(RTRIM(CASOS_MANUALES.TIPOOPERACIONID)), 2)             AS                    CVE_TIPOOPERACION,
    (SELECT DS_TIPO_OPERACION
     FROM SOFOM.MTS_DTIPO_OPERACIONES
     WHERE TIPOOPERACIONID = CASOS_MANUALES.TIPOOPERACIONID)                                       DS_TIPO_OPERACION,
    --RIGHT('0' + LTRIM(RTRIM(CASOS_MANUALES.INSTRMONETARIOID)), 2) AS CVE_INSTRMONETARIO,
    right(('0' + LTRIM(RTRIM(CASE CASOS_MANUALES.INSTRMONETARIOID
                             WHEN 11
                               THEN '03'
                             WHEN 12
                               THEN '03'
                             WHEN 13
                               THEN '03'
                             ELSE CASOS_MANUALES.INSTRMONETARIOID END))), 2) AS                    CVE_INSTRMONETARIO,
    (SELECT DS_INST_MONETARIO
     FROM SOFOM.MTS_DINSTRUMENTO_MONETARIO
     WHERE INSTRMONETARIOID = CASOS_MANUALES.INSTRMONETARIOID)                                     DS_INST_MONETARIO,
    CASOS_MANUALES.NUMPOLIZACNTR_CASOS                                       AS                    NUMPOLIZACNTR,
    REPLACE(CONVERT(VARCHAR(40), (CAST(CASOS_MANUALES.MONTOMNCNTR_CASOS AS MONEY)), 1), '.00', '') MONTOCNTR,
    CAST(CASOS_MANUALES.MONTOMNCNTR_CASOS AS DECIMAL(14, 2))                                       MONTO,
    CASOS_MANUALES.MONEDAID                                                  AS                    CVE_MONEDA,
    (SELECT DS_MONEDA
     FROM SOFOM.MTS_DMONEDA
     WHERE MONEDAID = CASOS_MANUALES.MONEDAID)                                                     DS_MONEDA,
    CONVERT(CHAR, CASOS_MANUALES.FECHAOPERACIONCNTR_CASOS, 103)              AS                    FECHAOPERACIONCNTR,
    CONVERT(CHAR, CASOS_MANUALES.FECHAOPERACIONCNTR_CASOS, 112)              AS                    FECHA_OPERACION,
    NULL                                                                                           CONTRATANTEID,
    NULL                                                                                           CONTRATANTECD,
    CASOS_MANUALES.CONTRATANTE_CASOS                                         AS                    NOMBRE,
    CASOS_MANUALES.CONTRATANTEPATERNO_CASOS                                  AS                    APELLIDO_PATERNO,
    CASOS_MANUALES.CONTRATANTEMATERNO_CASOS                                  AS                    APELLIDO_MATERNO,
    CASOS_MANUALES.RAZONSOCIALCNTR_CASOS                                     AS                    RAZONSOCIAL,
    CASOS_MANUALES.TIPOPERSONAFISCALID,
    (SELECT TIPOPERSONAFISCAL
     FROM SOFOM.MTS_DTIPOPERSONAFISCAL
     WHERE TIPOPERSONAFISCALID = CASOS_MANUALES.TIPOPERSONAFISCALID)                               DS_TIPOPERSONAFISCAL,
    (SELECT NAC.NACIONALIDADID
     FROM SOFOM.MTS_DPAIS PA, SOFOM.MTS_DNACIONALIDAD NAC
     WHERE PA.PAISID = NAC.PAISID AND NAC.NACIONALIDADID = CASOS_MANUALES.NACIONALIDADID)          CVE_NACIONALIDAD,
    (SELECT N.NACIONALIDAD
     FROM SOFOM.MTS_DNACIONALIDAD N
     WHERE N.NACIONALIDADID = CASOS_MANUALES.NACIONALIDADID)                                       DS_NACIONALIDAD,
    LTRIM(RTRIM(CASOS_MANUALES.CONTRATANTEDIRECCION_CASOS + ' ' + CASOS_MANUALES.NO_EXTERIOR + ' ' +
                CASOS_MANUALES.CODIGO_POSTAL))                               AS                    DIRECCION,
    CASOS_MANUALES.CONTRATANTEDIRECCION_CASOS                                AS                    CALLE,
    CASOS_MANUALES.NO_EXTERIOR,
    CASOS_MANUALES.NO_INTERIOR,
    CASOS_MANUALES.CODIGO_POSTAL,
    CASOS_MANUALES.CONTRATANTETELEFONO_CASOS                                 AS                    TELEFONO,
    CONVERT(CHAR, CASOS_MANUALES.CONTRATANTEEDADCONT, 103)                   AS                    CONTRATANTEFECHANAC,
    CONVERT(CHAR, CASOS_MANUALES.CONTRATANTEEDADCONT, 103)                   AS                    CONTRATANTEEDADCONT,
    (SELECT CASE WHEN CASOS_MANUALES.TIPOPERSONAFISCALID = 1
      THEN
        CONVERT(CHAR, CASOS_MANUALES.CONTRATANTEFECHANAC_CASOS, 112)
            ELSE CONVERT(CHAR, CASOS_MANUALES.CONTRATANTEFECHANAC_CASOS, 112)
            END)                                                             AS                    FECHA_NAC_CONT,
    CASOS_MANUALES.CONTRATANTECURP_CASOS                                     AS                    CURP,
    CASOS_MANUALES.CONTRATANTERFC_CASOS                                      AS                    RFC,
    CASOS_MANUALES.PAISID,
    (SELECT DS_PAIS
     FROM SOFOM.MTS_DPAIS
     WHERE PAISID = CASOS_MANUALES.PAISID)                                                         DS_PAIS_DOMICILIO,
    CASOS_MANUALES.ESTADOID,
    (SELECT DISTINCT DS_D_ESTADO
     FROM SOFOM.MTS_ADM_SEPOMEX SEPOMEX
     WHERE SEPOMEX.CVE_ID_ASENTA_CPCONS = CASOS_MANUALES.COLONIAID
           AND SEPOMEX.CVE_C_MNPIO = CASOS_MANUALES.MUNICIPIOID
           AND SEPOMEX.CVE_C_ESTADO = CASOS_MANUALES.ESTADOID)                                     DS_ESTADO,
    CASOS_MANUALES.MUNICIPIOID,
    (SELECT DISTINCT DS_D_MNPIO
     FROM SOFOM.MTS_ADM_SEPOMEX SEPOMEX
     WHERE SEPOMEX.CVE_ID_ASENTA_CPCONS = CASOS_MANUALES.COLONIAID
           AND SEPOMEX.CVE_C_MNPIO = CASOS_MANUALES.MUNICIPIOID
           AND SEPOMEX.CVE_C_ESTADO = CASOS_MANUALES.ESTADOID)                                     DS_MUNICIPIO,
    CASOS_MANUALES.COLONIAID,
    (SELECT DISTINCT DS_D_ASENTA
     FROM SOFOM.MTS_ADM_SEPOMEX SEPOMEX
     WHERE SEPOMEX.CVE_ID_ASENTA_CPCONS = CASOS_MANUALES.COLONIAID
           AND SEPOMEX.CVE_C_MNPIO = CASOS_MANUALES.MUNICIPIOID
           AND SEPOMEX.CVE_C_ESTADO = CASOS_MANUALES.ESTADOID)                                     DES_COLONIA,
    CASOS_MANUALES.ACTIVIDADECOID                                            AS                    CVE_ACTIVIDADECO,
    (SELECT DS_ACTIVIDADECO
     FROM SOFOM.MTS_DACTIVIDADECONOMICA
     WHERE ACTIVIDADECOID = CASOS_MANUALES.ACTIVIDADECOID)                                         DS_ACTIVIDADECO,
    (SELECT CASE WHEN CASOS_MANUALES.CVE_LOCALIDAD IS NULL
      THEN CASOS_MANUALES.MUNICIPIOID
            ELSE CASOS_MANUALES.CVE_LOCALIDAD END)                           AS                    CVE_LOCALIDAD,
    (SELECT DS_LOCALIDAD
     FROM SOFOM.MTS_CLOCALIDADES_CNBV
     WHERE CVE_LOCALIDAD = CASOS_MANUALES.CVE_LOCALIDAD)                                           DS_LOCALIDAD,
    CASOS_MANUALES.CIERREID,
    CASOS_MANUALES.CASOSID,
    NULL                                                                                           ESTATUS_OPERACION,
    CASOS_MANUALES.CVE_TIPO_ANALISIS,
    (SELECT VALOR_ATRIBUTO_01
     FROM SOFOM.MTS_ANA_DCATALOGOS_CLAVES
     WHERE CVE_TABLA = 'CAT_TIPO_ANALISIS'
           AND VIGENCIA = 'S' AND CLAVE_01 = CASOS_MANUALES.CVE_TIPO_ANALISIS)                     DS_TIPO_ANALISIS,
    CONVERT(CHAR, CASOS_MANUALES.FECHADETECION_CASOS, 103)                   AS                    FECHADETECION_CASOS,
    CONVERT(CHAR, CASOS_MANUALES.FECHADETECION_CASOS, 112)                   AS                    FECHA_DETECCION,
    CASOS_MANUALES.AGENTENOMBRE_CASOS                                        AS                    AGENTENOMBRE,
    CASOS_MANUALES.AGENTEPATERNO_CASOS                                       AS                    AGENTEPATERNO,
    CASOS_MANUALES.AGENTEMATERNO_CASOS                                       AS                    AGENTEMATERNO,
    CASOS_MANUALES.AGENTERFC_CASOS                                           AS                    AGENTERFC,
    CASOS_MANUALES.AGENTECURP_CASOS                                          AS                    AGENTECURP,
    CONVERT(VARCHAR(10), CASOS_MANUALES.CONSECNTAREL_CASOS)                  AS                    CONSECNTAREL,
    CASOS_MANUALES.NUMPOLIZABENEF_CASOS                                      AS                    NUMPOLIZABENEF,
    CASOS_MANUALES.ENTIDADFINIDBENEF_CASOS                                   AS                    DS_ENTIDADFINIDBENEF,
    CASOS_MANUALES.BENEFICIARIO_CASOS                                        AS                    BENEFICIARIOS,
    CASOS_MANUALES.BENEFICIARIOPATERNO_CASOS                                 AS                    BENEFICIARIOPATERNO,
    CASOS_MANUALES.BENEFICIARIOMATERNO_CASOS                                 AS                    BENEFICIARIOMATERNO,
    CASOS_MANUALES.DESOPERACION_CASOS                                        AS                    DS_DESOPERACION,
    CASOS_MANUALES.RAZONOPERACION_CASOS                                      AS                    RAZONOPERACION,
    CASOS_MANUALES.SW_CASO_MANUAL,
    CASOS_MANUALES.CVE_TIPOINUSUALIDAD,
    (CASE CASOS_MANUALES.CVE_TIPOINUSUALIDAD
     WHEN 'O'
       THEN 'OPERATIVA'
     WHEN 'T'
       THEN 'TRANSACCION'
     ELSE ' ' END)                                                           AS                    DS_TIPOINUSUALIDAD,
    NULL                                                                                           OPERCNTRID,
    NULL                                                                                           CODOPER
  FROM SOFOM.MTS_ANA_HRN_CASOS_POLIZAS_AUD CASOS_MANUALES
  WHERE CASOS_MANUALES.CVE_TIPO_ANALISIS = 'TA24H'


go






/************************************************************************************************************************************************/


CREATE OR ALTER VIEW [TD1].[MTS_VL_CASOS_24H_REPORTE] AS

  SELECT
    CONVERT(CHAR, GETDATE(), 103)                                            AS                    FECHA_PERIODO,
    CONVERT(VARCHAR(10), GETDATE(), 112)                                     AS                    PERIODO,
         null as FOLIO,
    CASOS_MANUALES.CVE_TIPO_REPORTE                                          AS                    TIPO_REPORTE,
    2                                                                                              TIPO_REPORTE_CASO,
    ( SELECT ENTIDADFINID
                                         FROM [MELTSAN].MTS_ADM_LICENCIAS
                                         WHERE CVE_ACRONIMO = 'TD1')        AS                    SUJETO_OBLIGADO,
    RIGHT('000000' + CASOS_MANUALES.ORGANISMOSUPID_CASOS, 6)                 AS                    ORGANO_SUPERVISOR,
    --CASOS_MANUALES.SUCURSALID                                             AS CVE_SUCURSAL,
    '0'                                                                      AS                    CVE_SUCURSAL,
    (SELECT DS_SUCURSAL
     FROM TD1.MTS_DSUCURSALES S
     WHERE S.SUCURSALID = CASOS_MANUALES.SUCURSALID)                                               DS_SUCURSAL,
    (SELECT CVE_LOCALIDAD
     FROM TD1.MTS_DSUCURSALES S
     WHERE S.SUCURSALID =
           CASOS_MANUALES.SUCURSALID)                                                              CVE_LOCALIDAD_SUCURSAL,
    RIGHT('0' + LTRIM(RTRIM(CASOS_MANUALES.TIPOOPERACIONID)), 2)             AS                    CVE_TIPOOPERACION,
    (SELECT DS_TIPO_OPERACION
     FROM TD1.MTS_DTIPO_OPERACIONES
     WHERE TIPOOPERACIONID = CASOS_MANUALES.TIPOOPERACIONID)                                       DS_TIPO_OPERACION,
    --RIGHT('0' + LTRIM(RTRIM(CASOS_MANUALES.INSTRMONETARIOID)), 2) AS CVE_INSTRMONETARIO,
    right(('0' + LTRIM(RTRIM(CASE CASOS_MANUALES.INSTRMONETARIOID
                             WHEN 11
                               THEN '03'
                             WHEN 12
                               THEN '03'
                             WHEN 13
                               THEN '03'
                             ELSE CASOS_MANUALES.INSTRMONETARIOID END))), 2) AS                    CVE_INSTRMONETARIO,
    (SELECT DS_INST_MONETARIO
     FROM TD1.MTS_DINSTRUMENTO_MONETARIO
     WHERE INSTRMONETARIOID = CASOS_MANUALES.INSTRMONETARIOID)                                     DS_INST_MONETARIO,
    CASOS_MANUALES.NUMPOLIZACNTR_CASOS                                       AS                    NUMPOLIZACNTR,
    REPLACE(CONVERT(VARCHAR(40), (CAST(CASOS_MANUALES.MONTOMNCNTR_CASOS AS MONEY)), 1), '.00', '') MONTOCNTR,
    CAST(CASOS_MANUALES.MONTOMNCNTR_CASOS AS DECIMAL(14, 2))                                       MONTO,
    CASOS_MANUALES.MONEDAID                                                  AS                    CVE_MONEDA,
    (SELECT DS_MONEDA
     FROM TD1.MTS_DMONEDA
     WHERE MONEDAID = CASOS_MANUALES.MONEDAID)                                                     DS_MONEDA,
    CONVERT(CHAR, CASOS_MANUALES.FECHAOPERACIONCNTR_CASOS, 103)              AS                    FECHAOPERACIONCNTR,
    CONVERT(CHAR, CASOS_MANUALES.FECHAOPERACIONCNTR_CASOS, 112)              AS                    FECHA_OPERACION,
    NULL                                                                                           CONTRATANTEID,
    NULL                                                                                           CONTRATANTECD,
    CASOS_MANUALES.CONTRATANTE_CASOS                                         AS                    NOMBRE,
    CASOS_MANUALES.CONTRATANTEPATERNO_CASOS                                  AS                    APELLIDO_PATERNO,
    CASOS_MANUALES.CONTRATANTEMATERNO_CASOS                                  AS                    APELLIDO_MATERNO,
    CASOS_MANUALES.RAZONSOCIALCNTR_CASOS                                     AS                    RAZONSOCIAL,
    CASOS_MANUALES.TIPOPERSONAFISCALID,
    (SELECT TIPOPERSONAFISCAL
     FROM TD1.MTS_DTIPOPERSONAFISCAL
     WHERE TIPOPERSONAFISCALID = CASOS_MANUALES.TIPOPERSONAFISCALID)                               DS_TIPOPERSONAFISCAL,
    (SELECT NAC.NACIONALIDADID
     FROM TD1.MTS_DPAIS PA, TD1.MTS_DNACIONALIDAD NAC
     WHERE PA.PAISID = NAC.PAISID AND NAC.NACIONALIDADID = CASOS_MANUALES.NACIONALIDADID)          CVE_NACIONALIDAD,
    (SELECT N.NACIONALIDAD
     FROM TD1.MTS_DNACIONALIDAD N
     WHERE N.NACIONALIDADID = CASOS_MANUALES.NACIONALIDADID)                                       DS_NACIONALIDAD,
    LTRIM(RTRIM(CASOS_MANUALES.CONTRATANTEDIRECCION_CASOS + ' ' + CASOS_MANUALES.NO_EXTERIOR + ' ' +
                CASOS_MANUALES.CODIGO_POSTAL))                               AS                    DIRECCION,
    CASOS_MANUALES.CONTRATANTEDIRECCION_CASOS                                AS                    CALLE,
    CASOS_MANUALES.NO_EXTERIOR,
    CASOS_MANUALES.NO_INTERIOR,
    CASOS_MANUALES.CODIGO_POSTAL,
    CASOS_MANUALES.CONTRATANTETELEFONO_CASOS                                 AS                    TELEFONO,
    CONVERT(CHAR, CASOS_MANUALES.CONTRATANTEEDADCONT, 103)                   AS                    CONTRATANTEFECHANAC,
    CONVERT(CHAR, CASOS_MANUALES.CONTRATANTEEDADCONT, 103)                   AS                    CONTRATANTEEDADCONT,
    (SELECT CASE WHEN CASOS_MANUALES.TIPOPERSONAFISCALID = 1
      THEN
        CONVERT(CHAR, CASOS_MANUALES.CONTRATANTEFECHANAC_CASOS, 112)
            ELSE CONVERT(CHAR, CASOS_MANUALES.CONTRATANTEFECHANAC_CASOS, 112)
            END)                                                             AS                    FECHA_NAC_CONT,
    CASOS_MANUALES.CONTRATANTECURP_CASOS                                     AS                    CURP,
    CASOS_MANUALES.CONTRATANTERFC_CASOS                                      AS                    RFC,
    CASOS_MANUALES.PAISID,
    (SELECT DS_PAIS
     FROM TD1.MTS_DPAIS
     WHERE PAISID = CASOS_MANUALES.PAISID)                                                         DS_PAIS_DOMICILIO,
    CASOS_MANUALES.ESTADOID,
    (SELECT DISTINCT DS_D_ESTADO
     FROM TD1.MTS_ADM_SEPOMEX SEPOMEX
     WHERE SEPOMEX.CVE_ID_ASENTA_CPCONS = CASOS_MANUALES.COLONIAID
           AND SEPOMEX.CVE_C_MNPIO = CASOS_MANUALES.MUNICIPIOID
           AND SEPOMEX.CVE_C_ESTADO = CASOS_MANUALES.ESTADOID)                                     DS_ESTADO,
    CASOS_MANUALES.MUNICIPIOID,
    (SELECT DISTINCT DS_D_MNPIO
     FROM TD1.MTS_ADM_SEPOMEX SEPOMEX
     WHERE SEPOMEX.CVE_ID_ASENTA_CPCONS = CASOS_MANUALES.COLONIAID
           AND SEPOMEX.CVE_C_MNPIO = CASOS_MANUALES.MUNICIPIOID
           AND SEPOMEX.CVE_C_ESTADO = CASOS_MANUALES.ESTADOID)                                     DS_MUNICIPIO,
    CASOS_MANUALES.COLONIAID,
    (SELECT DISTINCT DS_D_ASENTA
     FROM TD1.MTS_ADM_SEPOMEX SEPOMEX
     WHERE SEPOMEX.CVE_ID_ASENTA_CPCONS = CASOS_MANUALES.COLONIAID
           AND SEPOMEX.CVE_C_MNPIO = CASOS_MANUALES.MUNICIPIOID
           AND SEPOMEX.CVE_C_ESTADO = CASOS_MANUALES.ESTADOID)                                     DES_COLONIA,
    CASOS_MANUALES.ACTIVIDADECOID                                            AS                    CVE_ACTIVIDADECO,
    (SELECT DS_ACTIVIDADECO
     FROM TD1.MTS_DACTIVIDADECONOMICA
     WHERE ACTIVIDADECOID = CASOS_MANUALES.ACTIVIDADECOID)                                         DS_ACTIVIDADECO,
    (SELECT CASE WHEN CASOS_MANUALES.CVE_LOCALIDAD IS NULL
      THEN CASOS_MANUALES.MUNICIPIOID
            ELSE CASOS_MANUALES.CVE_LOCALIDAD END)                           AS                    CVE_LOCALIDAD,
    (SELECT DS_LOCALIDAD
     FROM TD1.MTS_CLOCALIDADES_CNBV
     WHERE CVE_LOCALIDAD = CASOS_MANUALES.CVE_LOCALIDAD)                                           DS_LOCALIDAD,
    CASOS_MANUALES.CIERREID,
    CASOS_MANUALES.CASOSID,
    NULL                                                                                           ESTATUS_OPERACION,
    CASOS_MANUALES.CVE_TIPO_ANALISIS,
    (SELECT VALOR_ATRIBUTO_01
     FROM TD1.MTS_ANA_DCATALOGOS_CLAVES
     WHERE CVE_TABLA = 'CAT_TIPO_ANALISIS'
           AND VIGENCIA = 'S' AND CLAVE_01 = CASOS_MANUALES.CVE_TIPO_ANALISIS)                     DS_TIPO_ANALISIS,
    CONVERT(CHAR, CASOS_MANUALES.FECHADETECION_CASOS, 103)                   AS                    FECHADETECION_CASOS,
    CONVERT(CHAR, CASOS_MANUALES.FECHADETECION_CASOS, 112)                   AS                    FECHA_DETECCION,
    CASOS_MANUALES.AGENTENOMBRE_CASOS                                        AS                    AGENTENOMBRE,
    CASOS_MANUALES.AGENTEPATERNO_CASOS                                       AS                    AGENTEPATERNO,
    CASOS_MANUALES.AGENTEMATERNO_CASOS                                       AS                    AGENTEMATERNO,
    CASOS_MANUALES.AGENTERFC_CASOS                                           AS                    AGENTERFC,
    CASOS_MANUALES.AGENTECURP_CASOS                                          AS                    AGENTECURP,
    CONVERT(VARCHAR(10), CASOS_MANUALES.CONSECNTAREL_CASOS)                  AS                    CONSECNTAREL,
    CASOS_MANUALES.NUMPOLIZABENEF_CASOS                                      AS                    NUMPOLIZABENEF,
    CASOS_MANUALES.ENTIDADFINIDBENEF_CASOS                                   AS                    DS_ENTIDADFINIDBENEF,
    CASOS_MANUALES.BENEFICIARIO_CASOS                                        AS                    BENEFICIARIOS,
    CASOS_MANUALES.BENEFICIARIOPATERNO_CASOS                                 AS                    BENEFICIARIOPATERNO,
    CASOS_MANUALES.BENEFICIARIOMATERNO_CASOS                                 AS                    BENEFICIARIOMATERNO,
    CASOS_MANUALES.DESOPERACION_CASOS                                        AS                    DS_DESOPERACION,
    CASOS_MANUALES.RAZONOPERACION_CASOS                                      AS                    RAZONOPERACION,
    CASOS_MANUALES.SW_CASO_MANUAL,
    CASOS_MANUALES.CVE_TIPOINUSUALIDAD,
    (CASE CASOS_MANUALES.CVE_TIPOINUSUALIDAD
     WHEN 'O'
       THEN 'OPERATIVA'
     WHEN 'T'
       THEN 'TRANSACCION'
     ELSE ' ' END)                                                           AS                    DS_TIPOINUSUALIDAD,
    NULL                                                                                           OPERCNTRID,
    NULL                                                                                           CODOPER
  FROM TD1.MTS_ANA_HRN_CASOS_POLIZAS_AUD CASOS_MANUALES
  WHERE CASOS_MANUALES.CVE_TIPO_ANALISIS = 'TA24H'


go



/************************************************************************************************************************************************/


CREATE OR ALTER VIEW [TDUSA].[MTS_VL_CASOS_24H_REPORTE] AS

  SELECT
    CONVERT(CHAR, GETDATE(), 103)                                            AS                    FECHA_PERIODO,
    CONVERT(VARCHAR(10), GETDATE(), 112)                                     AS                    PERIODO,
         null as FOLIO,
    CASOS_MANUALES.CVE_TIPO_REPORTE                                          AS                    TIPO_REPORTE,
    2                                                                                              TIPO_REPORTE_CASO,
    ( SELECT ENTIDADFINID
                                         FROM [MELTSAN].MTS_ADM_LICENCIAS
                                         WHERE CVE_ACRONIMO = 'TDUSA')        AS                    SUJETO_OBLIGADO,
    RIGHT('000000' + CASOS_MANUALES.ORGANISMOSUPID_CASOS, 6)                 AS                    ORGANO_SUPERVISOR,
    --CASOS_MANUALES.SUCURSALID                                             AS CVE_SUCURSAL,
    '0'                                                                      AS                    CVE_SUCURSAL,
    (SELECT DS_SUCURSAL
     FROM TDUSA.MTS_DSUCURSALES S
     WHERE S.SUCURSALID = CASOS_MANUALES.SUCURSALID)                                               DS_SUCURSAL,
    (SELECT CVE_LOCALIDAD
     FROM TDUSA.MTS_DSUCURSALES S
     WHERE S.SUCURSALID =
           CASOS_MANUALES.SUCURSALID)                                                              CVE_LOCALIDAD_SUCURSAL,
    RIGHT('0' + LTRIM(RTRIM(CASOS_MANUALES.TIPOOPERACIONID)), 2)             AS                    CVE_TIPOOPERACION,
    (SELECT DS_TIPO_OPERACION
     FROM TDUSA.MTS_DTIPO_OPERACIONES
     WHERE TIPOOPERACIONID = CASOS_MANUALES.TIPOOPERACIONID)                                       DS_TIPO_OPERACION,
    --RIGHT('0' + LTRIM(RTRIM(CASOS_MANUALES.INSTRMONETARIOID)), 2) AS CVE_INSTRMONETARIO,
    right(('0' + LTRIM(RTRIM(CASE CASOS_MANUALES.INSTRMONETARIOID
                             WHEN 11
                               THEN '03'
                             WHEN 12
                               THEN '03'
                             WHEN 13
                               THEN '03'
                             ELSE CASOS_MANUALES.INSTRMONETARIOID END))), 2) AS                    CVE_INSTRMONETARIO,
    (SELECT DS_INST_MONETARIO
     FROM TDUSA.MTS_DINSTRUMENTO_MONETARIO
     WHERE INSTRMONETARIOID = CASOS_MANUALES.INSTRMONETARIOID)                                     DS_INST_MONETARIO,
    CASOS_MANUALES.NUMPOLIZACNTR_CASOS                                       AS                    NUMPOLIZACNTR,
    REPLACE(CONVERT(VARCHAR(40), (CAST(CASOS_MANUALES.MONTOMNCNTR_CASOS AS MONEY)), 1), '.00', '') MONTOCNTR,
    CAST(CASOS_MANUALES.MONTOMNCNTR_CASOS AS DECIMAL(14, 2))                                       MONTO,
    CASOS_MANUALES.MONEDAID                                                  AS                    CVE_MONEDA,
    (SELECT DS_MONEDA
     FROM TDUSA.MTS_DMONEDA
     WHERE MONEDAID = CASOS_MANUALES.MONEDAID)                                                     DS_MONEDA,
    CONVERT(CHAR, CASOS_MANUALES.FECHAOPERACIONCNTR_CASOS, 103)              AS                    FECHAOPERACIONCNTR,
    CONVERT(CHAR, CASOS_MANUALES.FECHAOPERACIONCNTR_CASOS, 112)              AS                    FECHA_OPERACION,
    NULL                                                                                           CONTRATANTEID,
    NULL                                                                                           CONTRATANTECD,
    CASOS_MANUALES.CONTRATANTE_CASOS                                         AS                    NOMBRE,
    CASOS_MANUALES.CONTRATANTEPATERNO_CASOS                                  AS                    APELLIDO_PATERNO,
    CASOS_MANUALES.CONTRATANTEMATERNO_CASOS                                  AS                    APELLIDO_MATERNO,
    CASOS_MANUALES.RAZONSOCIALCNTR_CASOS                                     AS                    RAZONSOCIAL,
    CASOS_MANUALES.TIPOPERSONAFISCALID,
    (SELECT TIPOPERSONAFISCAL
     FROM TDUSA.MTS_DTIPOPERSONAFISCAL
     WHERE TIPOPERSONAFISCALID = CASOS_MANUALES.TIPOPERSONAFISCALID)                               DS_TIPOPERSONAFISCAL,
    (SELECT NAC.NACIONALIDADID
     FROM TDUSA.MTS_DPAIS PA, TDUSA.MTS_DNACIONALIDAD NAC
     WHERE PA.PAISID = NAC.PAISID AND NAC.NACIONALIDADID = CASOS_MANUALES.NACIONALIDADID)          CVE_NACIONALIDAD,
    (SELECT N.NACIONALIDAD
     FROM TDUSA.MTS_DNACIONALIDAD N
     WHERE N.NACIONALIDADID = CASOS_MANUALES.NACIONALIDADID)                                       DS_NACIONALIDAD,
    LTRIM(RTRIM(CASOS_MANUALES.CONTRATANTEDIRECCION_CASOS + ' ' + CASOS_MANUALES.NO_EXTERIOR + ' ' +
                CASOS_MANUALES.CODIGO_POSTAL))                               AS                    DIRECCION,
    CASOS_MANUALES.CONTRATANTEDIRECCION_CASOS                                AS                    CALLE,
    CASOS_MANUALES.NO_EXTERIOR,
    CASOS_MANUALES.NO_INTERIOR,
    CASOS_MANUALES.CODIGO_POSTAL,
    CASOS_MANUALES.CONTRATANTETELEFONO_CASOS                                 AS                    TELEFONO,
    CONVERT(CHAR, CASOS_MANUALES.CONTRATANTEEDADCONT, 103)                   AS                    CONTRATANTEFECHANAC,
    CONVERT(CHAR, CASOS_MANUALES.CONTRATANTEEDADCONT, 103)                   AS                    CONTRATANTEEDADCONT,
    (SELECT CASE WHEN CASOS_MANUALES.TIPOPERSONAFISCALID = 1
      THEN
        CONVERT(CHAR, CASOS_MANUALES.CONTRATANTEFECHANAC_CASOS, 112)
            ELSE CONVERT(CHAR, CASOS_MANUALES.CONTRATANTEFECHANAC_CASOS, 112)
            END)                                                             AS                    FECHA_NAC_CONT,
    CASOS_MANUALES.CONTRATANTECURP_CASOS                                     AS                    CURP,
    CASOS_MANUALES.CONTRATANTERFC_CASOS                                      AS                    RFC,
    CASOS_MANUALES.PAISID,
    (SELECT DS_PAIS
     FROM TDUSA.MTS_DPAIS
     WHERE PAISID = CASOS_MANUALES.PAISID)                                                         DS_PAIS_DOMICILIO,
    CASOS_MANUALES.ESTADOID,
    (SELECT DISTINCT DS_D_ESTADO
     FROM TDUSA.MTS_ADM_SEPOMEX SEPOMEX
     WHERE SEPOMEX.CVE_ID_ASENTA_CPCONS = CASOS_MANUALES.COLONIAID
           AND SEPOMEX.CVE_C_MNPIO = CASOS_MANUALES.MUNICIPIOID
           AND SEPOMEX.CVE_C_ESTADO = CASOS_MANUALES.ESTADOID)                                     DS_ESTADO,
    CASOS_MANUALES.MUNICIPIOID,
    (SELECT DISTINCT DS_D_MNPIO
     FROM TDUSA.MTS_ADM_SEPOMEX SEPOMEX
     WHERE SEPOMEX.CVE_ID_ASENTA_CPCONS = CASOS_MANUALES.COLONIAID
           AND SEPOMEX.CVE_C_MNPIO = CASOS_MANUALES.MUNICIPIOID
           AND SEPOMEX.CVE_C_ESTADO = CASOS_MANUALES.ESTADOID)                                     DS_MUNICIPIO,
    CASOS_MANUALES.COLONIAID,
    (SELECT DISTINCT DS_D_ASENTA
     FROM TDUSA.MTS_ADM_SEPOMEX SEPOMEX
     WHERE SEPOMEX.CVE_ID_ASENTA_CPCONS = CASOS_MANUALES.COLONIAID
           AND SEPOMEX.CVE_C_MNPIO = CASOS_MANUALES.MUNICIPIOID
           AND SEPOMEX.CVE_C_ESTADO = CASOS_MANUALES.ESTADOID)                                     DES_COLONIA,
    CASOS_MANUALES.ACTIVIDADECOID                                            AS                    CVE_ACTIVIDADECO,
    (SELECT DS_ACTIVIDADECO
     FROM TDUSA.MTS_DACTIVIDADECONOMICA
     WHERE ACTIVIDADECOID = CASOS_MANUALES.ACTIVIDADECOID)                                         DS_ACTIVIDADECO,
    (SELECT CASE WHEN CASOS_MANUALES.CVE_LOCALIDAD IS NULL
      THEN CASOS_MANUALES.MUNICIPIOID
            ELSE CASOS_MANUALES.CVE_LOCALIDAD END)                           AS                    CVE_LOCALIDAD,
    (SELECT DS_LOCALIDAD
     FROM TDUSA.MTS_CLOCALIDADES_CNBV
     WHERE CVE_LOCALIDAD = CASOS_MANUALES.CVE_LOCALIDAD)                                           DS_LOCALIDAD,
    CASOS_MANUALES.CIERREID,
    CASOS_MANUALES.CASOSID,
    NULL                                                                                           ESTATUS_OPERACION,
    CASOS_MANUALES.CVE_TIPO_ANALISIS,
    (SELECT VALOR_ATRIBUTO_01
     FROM TDUSA.MTS_ANA_DCATALOGOS_CLAVES
     WHERE CVE_TABLA = 'CAT_TIPO_ANALISIS'
           AND VIGENCIA = 'S' AND CLAVE_01 = CASOS_MANUALES.CVE_TIPO_ANALISIS)                     DS_TIPO_ANALISIS,
    CONVERT(CHAR, CASOS_MANUALES.FECHADETECION_CASOS, 103)                   AS                    FECHADETECION_CASOS,
    CONVERT(CHAR, CASOS_MANUALES.FECHADETECION_CASOS, 112)                   AS                    FECHA_DETECCION,
    CASOS_MANUALES.AGENTENOMBRE_CASOS                                        AS                    AGENTENOMBRE,
    CASOS_MANUALES.AGENTEPATERNO_CASOS                                       AS                    AGENTEPATERNO,
    CASOS_MANUALES.AGENTEMATERNO_CASOS                                       AS                    AGENTEMATERNO,
    CASOS_MANUALES.AGENTERFC_CASOS                                           AS                    AGENTERFC,
    CASOS_MANUALES.AGENTECURP_CASOS                                          AS                    AGENTECURP,
    CONVERT(VARCHAR(10), CASOS_MANUALES.CONSECNTAREL_CASOS)                  AS                    CONSECNTAREL,
    CASOS_MANUALES.NUMPOLIZABENEF_CASOS                                      AS                    NUMPOLIZABENEF,
    CASOS_MANUALES.ENTIDADFINIDBENEF_CASOS                                   AS                    DS_ENTIDADFINIDBENEF,
    CASOS_MANUALES.BENEFICIARIO_CASOS                                        AS                    BENEFICIARIOS,
    CASOS_MANUALES.BENEFICIARIOPATERNO_CASOS                                 AS                    BENEFICIARIOPATERNO,
    CASOS_MANUALES.BENEFICIARIOMATERNO_CASOS                                 AS                    BENEFICIARIOMATERNO,
    CASOS_MANUALES.DESOPERACION_CASOS                                        AS                    DS_DESOPERACION,
    CASOS_MANUALES.RAZONOPERACION_CASOS                                      AS                    RAZONOPERACION,
    CASOS_MANUALES.SW_CASO_MANUAL,
    CASOS_MANUALES.CVE_TIPOINUSUALIDAD,
    (CASE CASOS_MANUALES.CVE_TIPOINUSUALIDAD
     WHEN 'O'
       THEN 'OPERATIVA'
     WHEN 'T'
       THEN 'TRANSACCION'
     ELSE ' ' END)                                                           AS                    DS_TIPOINUSUALIDAD,
    NULL                                                                                           OPERCNTRID,
    NULL                                                                                           CODOPER
  FROM TDUSA.MTS_ANA_HRN_CASOS_POLIZAS_AUD CASOS_MANUALES
  WHERE CASOS_MANUALES.CVE_TIPO_ANALISIS = 'TA24H'


go
