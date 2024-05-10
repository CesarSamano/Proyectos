
-- Alter a Tabla para agregar campos del reporte


ALTER table IFC.MTS_REPORTES_REGULATORIOS
    ADD
        VALOR_51 varchar(500),
        VALOR_52 varchar(500),
        VALOR_53 varchar(500),
        VALOR_54 varchar(500),
        VALOR_55 varchar(500),
        VALOR_56 varchar(500),
        VALOR_57 varchar(500),
        VALOR_58 varchar(500),
        VALOR_59 varchar(500),
        VALOR_60 varchar(500),
        VALOR_61 varchar(500),
        VALOR_62 varchar(500),
        VALOR_63 varchar(500),
        VALOR_64 varchar(500),
        VALOR_65 varchar(500),
        VALOR_66 varchar(500),
        VALOR_67 varchar(500),
        VALOR_68 varchar(500)

go



-- Alter de tabla contratantes para guardar el número de cuenta y la cuenta calabe

alter table IFC.MTS_ANA_HRN_CASOS_POLIZAS_AUD add CODOPER varchar(100);

alter table IFC.MTS_DCONTRATANTE add NUM_CUENTA         varchar(50);
alter table IFC.MTS_DCONTRATANTE add NUM_CUENTA_CLABE   varchar(50);
alter table IFC.MTS_DCONTRATANTE add CVE_ORIGEN_CLIENTE varchar(2);

alter table IFC.MTS_REPORTES_REGULATORIOS ADD   VALOR_51            varchar(500);
alter table IFC.MTS_REPORTES_REGULATORIOS ADD   VALOR_52            varchar(500);
alter table IFC.MTS_REPORTES_REGULATORIOS ADD   VALOR_53            varchar(500);
alter table IFC.MTS_REPORTES_REGULATORIOS ADD   VALOR_54            varchar(500);
alter table IFC.MTS_REPORTES_REGULATORIOS ADD   VALOR_55            varchar(500);
alter table IFC.MTS_REPORTES_REGULATORIOS ADD   VALOR_56            varchar(500);
alter table IFC.MTS_REPORTES_REGULATORIOS ADD   VALOR_57            varchar(500);
alter table IFC.MTS_REPORTES_REGULATORIOS ADD   VALOR_58            varchar(500);
alter table IFC.MTS_REPORTES_REGULATORIOS ADD   VALOR_59            varchar(500);
alter table IFC.MTS_REPORTES_REGULATORIOS ADD   VALOR_60            varchar(500);
alter table IFC.MTS_REPORTES_REGULATORIOS ADD   VALOR_61            varchar(500);
alter table IFC.MTS_REPORTES_REGULATORIOS ADD   VALOR_62            varchar(500);
alter table IFC.MTS_REPORTES_REGULATORIOS ADD   VALOR_63            varchar(500);
alter table IFC.MTS_REPORTES_REGULATORIOS ADD   VALOR_64            varchar(500);
alter table IFC.MTS_REPORTES_REGULATORIOS ADD   VALOR_65            varchar(500);
alter table IFC.MTS_REPORTES_REGULATORIOS ADD   VALOR_66            varchar(500);
alter table IFC.MTS_REPORTES_REGULATORIOS ADD   VALOR_67            varchar(500);
alter table IFC.MTS_REPORTES_REGULATORIOS ADD   VALOR_68            varchar(500);

/********************************************************************************************************************************************************************************/



-- Creación de  Vista para Reportes inusuales




CREATE  OR ALTER  VIEW IFC.MTS_VL_CASOS_INUSUALES_REPORTE_ITF AS
SELECT
    RIGHT('000' + LTRIM(RTRIM((SELECT SECTOR.ORGANISMOSUPID
                                  FROM IFC.MTS_ADM_SECTOR_CLIENTES SECTOR,
                                    IFC.MTS_ADM_LICENCIAS LIC
                                  WHERE SECTOR.CVE_SECTOR = LIC.CVE_SECTOR
                                        AND LIC.CVE_ACRONIMO = 'IFC'))), 3)                       AS  ORGANO_SUPERVISOR,
      '02'                                                                                          AS TIPO_IFC,
   ( SELECT ENTIDADFINID
                                         FROM IFC.MTS_ADM_LICENCIAS
                                         WHERE CVE_ACRONIMO = 'IFC')                              AS  SUJETO_OBLIGADO,
   -- '65-010'                                                                   AS  SUJETO_OBLIGADO,
    2                                                                                               AS  TIPO_REPORTE,
    CONVERT(CHAR, GETDATE(), 103)                                                                   AS  FECHA_REPORTE,
        NULL                                                                                        AS  FOLIO_CONSECUTIVO,
        (case when CTRATE.TIPOPERSONAFISCALID = 1 then '0'
              when CTRATE.TIPOPERSONAFISCALID = 2 then '0'
              when CTRATE.TIPOPERSONAFISCALID = 103 then '0' else '0' end)                              AS  REGIMEN,
        (case when CTRATE.TIPOPERSONAFISCALID = 1 then ''
              when CTRATE.TIPOPERSONAFISCALID = 2 then ''
              when CTRATE.TIPOPERSONAFISCALID = 103 then '' else '' end)                                AS  NIVEL_CUENTA,
      --ISNULL (CTRATE.NUM_CUENTA,'123456')/* 'NUMER O DE CUENTA ASIGNADO POR LA ITF'  */                AS  NUMERO_CUENTA,
      (Case when oper.TIPOOPERACIONID in ('01', '02','05') then oper.CUENTA_BENEFICIARIO
            when oper.TIPOOPERACIONID in ('01', '02','05') then oper.CUENTA_ORDENANTE
             else 'NO EXISTE OPERACION RELACIONADA A REPORTAR' end)/* 'NUMERO DE CUENTA ASIGNADO POR LA ITF'  */ AS  NUMERO_CUENTA,
        '260'  /*CAMBIAR ESTE VALOR POR AJUSTE DEL CATÁLOGO DE PAIS*/                                    AS  NACIONALIDAD_CUENTA,
      '040'+ ISNULL (substring(RIGHT('000000000000000000'+CUENTA_ORDENANTE,18), 1,3 ),'646')             AS  INSTITUCION_CUENTA,

        (Case when oper.TIPOOPERACIONID in ('01', '02','05') then oper.CUENTA_BENEFICIARIO
            when oper.TIPOOPERACIONID in ('01', '02','05') then oper.CUENTA_ORDENANTE
             else 'NO EXISTE OPERACION RELACIONADA A REPORTAR' end)  /*Validar si es correcto*/          AS  CUENTA_ASOCIADA,
        '' /*OK PARA IFC*/                                                                              AS  TIPO_FINANCIAMIENTO,
        ----------------- DATOS DE LA PERSONA
   -- CTRATE.TIPOPERSONAFISCALID AS CVE_PERSONA_FISCAL,
    (SELECT (case tipopersonafiscalid when 103  then 1 when 104  then 2 when 2  then 2 else 1 end  )
     FROM IFC.MTS_DTIPOPERSONAFISCAL
     WHERE TIPOPERSONAFISCALID = CTRATE.TIPOPERSONAFISCALID)   /*OK*/                                    AS  TIPO_PERSONA,
        ''  /*OK PARA IFC*/                                                                            AS TIPO_CLIENTE,
    PER.CVE_PAIS_NACIMIENTO                                                                              AS  CVE_NACIONALIDAD,
    (CASE CTRATE.TIPOPERSONAFISCALID
     WHEN 2
       THEN CTRATE.CONTRATANTERAZONSOCIAL
     WHEN 104
       THEN CTRATE.CONTRATANTERAZONSOCIAL
     ELSE '' END)                                                                                       AS  RAZON_SOCIAL_DENOMINACION,
    CTRATE.CONTRATANTEID,
    CTRATE.CONTRATANTECD,
    (CASE CTRATE.TIPOPERSONAFISCALID
     WHEN 1
       THEN CTRATE.CONTRATANTE
     WHEN 103
       THEN CTRATE.CONTRATANTE
     ELSE '' END)                                                                                                       AS  NOMBRE,
    (CASE CTRATE.TIPOPERSONAFISCALID
     WHEN 1
       THEN (ISNULL (CTRATE.CONTRATANTEPATERNO,'XXXX'))
     WHEN 103
       THEN (ISNULL (CTRATE.CONTRATANTEPATERNO,'XXXX'))
     ELSE '' END)                                                                                                       AS  APELLIDO_PATERNO,
    (CASE CTRATE.TIPOPERSONAFISCALID
     WHEN 1
       THEN (ISNULL( CTRATE.CONTRATANTEMATERNO,'XXXX'))
     WHEN 103
       THEN (ISNULL( CTRATE.CONTRATANTEMATERNO,'XXXX'))
     ELSE '' END)                                                                                                       AS  APELLIDO_MATERNO,
     (CASE
     WHEN CTRATE.TIPOPERSONAFISCALID IN (2, 104)
       THEN ''
     WHEN CTRATE.TIPOPERSONAFISCALID IN (1, 103)
        THEN (CASE WHEN PER.CVE_GENERO = 1 THEN 2 WHEN PER.CVE_GENERO = 2 THEN 1 ELSE '' END )
    ELSE '' END)                                                                                                        AS GENERO,
    ISNULL(CTRATE.CONTRATANTERFC,'')                                                                                    AS  RFC,
    ISNULL(CTRATE.CONTRATANTECURP ,'')                                                                                  AS  CURP,
    ISNULL((CASE CTRATE.TIPOPERSONAFISCALID
     WHEN 1
       THEN (CONVERT(CHAR, CTRATE.CONTRATANTEFECHANAC, 103))
     WHEN 103
       THEN (CONVERT(CHAR, CTRATE.CONTRATANTEFECHANAC, 103))
     ELSE (CONVERT(CHAR, CTRATE.FEC_CONSTITUCION, 103)) END),'')                                                        AS  FECHA_NACIMIENTO_CONSTITUCION,
    ISNULL(ISNULL(RIGHT('00'+per.CVE_ESTADO_NACIMIENTO,2),RIGHT('00'+CTRATE.ESTADOID,2)),'')                            AS ENTIDAD_NACIMIENTO_CONSTITUCION,
    ISNULL(LTRIM(RTRIM(CTRATE.CONTRATANTEDIRECCION + ' ' + CTRATE.NO_EXTERIOR + ' ' + CTRATE.NO_INTERIOR + ' ' +
                CTRATE.CODIGO_POSTAL)),'')                                                                              AS  DOMICILIO_CLIENTE,
    ISNULL(RIGHT('00'+CTRATE.ESTADOID,2),'')                                                                            AS ENTIDAD_FEDERATIVA_DOMICILIO,
    ISNULL(CTRATE.CONTRATANTEDIRECCION,'')                                                                              AS  CALLE_DOMICILIO,
     (CASE  WHEN DIR.CVE_COLONIA IS NULL
        THEN (SELECT ISNULL(MAX( CVE_ID_ASENTA_CPCONS),'') FROM IFC.MTS_ADM_SEPOMEX WHERE CVE_D_CODIGO = CTRATE.CODIGO_POSTAL)
    ELSE  RIGHT('0000'+ DIR.CVE_COLONIA,4)END)                                                                          AS  COLONIA,
    ISNULL(ISNULL( (RIGHT('000'+CTRATE.MUNICIPIOID,3))  ,
    (SELECT MAX(CVE_C_MNPIO) FROM IFC.MTS_ADM_SEPOMEX WHERE CVE_D_CODIGO = CTRATE.CODIGO_POSTAL ))
        ,'')                                                                                                            AS  CIUDAD_POBLACION,
    ISNULL( RIGHT('00000'+CTRATE.CODIGO_POSTAL,5),'')                                                                   AS  CODIGO_POSTAL,
    ISNULL(ISNULL( PER.NUM_TEL_CASA,per.NUM_TEL_CELULAR) ,'')                                                           AS  TELEFONO,--se mete el telefono de kyc
    ISNULL( UPPER(PER.EMAIL)    ,'')                                                                                    AS  CORREO_ELECTRONICO,
    ISNULL( PER.CVE_ACTIVIDAD_ECONOMICA ,'0000000')                                                                     AS  CVE_ACTIVIDADECO, --Se agrega la actividad económica de KYC
    ISNULL(OPER.TIPOOPERACIONID ,50) AS  TIPO_OPERACION_ITF,
    /*ISNULL( RIGHT('00' + (case OPER.TIPOOPERACIONID
        when '01' then '02'
        when '02' then '03'
        else '50' end),2),50)                                                                                           AS  TIPO_OPERACION_ITF,
    ISNULL( RIGHT('00' + (case OPER.INSTRMONETARIOID
        when '03' then '06'
        when '3' then '06'
            else '50' end),2),50)                                                                                       AS  INSTRUMENTO_MONETARIO,*/
       ISNULL(OPER.INSTRMONETARIOID ,'03')                                                                              AS  INSTRUMENTO_MONETARIO,
        ISNULL(CAST(OPER.MONTOCNTR AS DECIMAL(14, 2)) ,'0.00')/*si no tiene monto*/                                     AS  MONTO,
        ISNULL(OPER.MONEDAID ,'MXN')                                                                                    AS  CVE_MONEDA,
        CONVERT(CHAR, OPER.FECHAOPERACIONCNTR, 103)                                                                     AS  FECHA_OPERACION,
        CONVERT(CHAR, HCASOS.FECHADETECION_CASOS, 103)                                                                  AS  FECHA_DETECION,
    ISNULL((CASE WHEN CTRATE.TIPOPERSONAFISCALID IN (1, 103) THEN '' ELSE (SELECT NOMBRES
    FROM IFC.MTS_KYC_PERSONAS
        WHERE ID_KYC = (SELECT ID_KYC FROM IFC.MTS_KYC_CONTRATO_PERSONAS
        WHERE ID_CONTRATO = PER.CVE_PERSONA AND CVE_ROL = 'RL')) END ),'')                                              AS  NOMBRE_APODERADO,
    ISNULL((CASE WHEN CTRATE.TIPOPERSONAFISCALID IN (1, 103) THEN '' ELSE (SELECT APELLIDO_PATERNO
    FROM IFC.MTS_KYC_PERSONAS
        WHERE ID_KYC = (SELECT ID_KYC FROM IFC.MTS_KYC_CONTRATO_PERSONAS
        WHERE ID_CONTRATO = PER.CVE_PERSONA AND CVE_ROL = 'RL')) END ),'')                                              AS  APELLIDO_PATERNO_APODERADO,
    ISNULL((CASE WHEN CTRATE.TIPOPERSONAFISCALID IN (1, 103) THEN '' ELSE (SELECT APELLIDO_MATERNO
    FROM IFC.MTS_KYC_PERSONAS
        WHERE ID_KYC = (SELECT ID_KYC FROM IFC.MTS_KYC_CONTRATO_PERSONAS
        WHERE ID_CONTRATO = PER.CVE_PERSONA AND CVE_ROL = 'RL')) END ),'')                                              AS  APELLIDO_MATERNO_APODERADO,
    ISNULL(UPPER(HCASOS.DS_DESOPERACION_CASOS) ,'')                                                                     AS  DS_DESOPERACION,
    ISNULL(UPPER(HCASOS.RAZONOPERACION_CASOS) ,'')                                                                      AS  RAZONOPERACION,
        DATEADD(MONTH,-3, OPER.FECHAOPERACIONCNTR)                                                                      AS  FECHA_INICIO_PERFIL,
        DATEADD(DAY ,-1, OPER.FECHAOPERACIONCNTR)                                                                       AS  FECHA_FIN_PERFIL,-- '0.00' AS  MONTO_TOTAL_PERFIL, 'MXN'  AS  MONEDA_PERFIL,'0' AS  NUMERO_OPERACIONES_PERFIL,
    (SELECT  isnull(SUM(ISNULL(MONTOCNTR,0)),1.00) FROM IFC.MTS_HOPERACIONESCNTR
    WHERE CONTRATANTEID = CTRATE.CONTRATANTEID
    AND FECHAOPERACIONCNTR >= DATEADD(MONTH,-1, OPER.FECHAOPERACIONCNTR))                                               AS  MONTO_TOTAL_PERFIL,
     ISNULL((select MONEDAID from (
        select top(1) MONEDAID,  count (*) as cuenta
        from IFC.MTS_HOPERACIONESCNTR WHERE CONTRATANTEID = CTRATE.CONTRATANTEID
        AND FECHAOPERACIONCNTR >= DATEADD(MONTH,-3, OPER.FECHAOPERACIONCNTR)
        group by MONEDAID order by cuenta desc) A )  ,'MXN')                                                            AS  MONEDA_PERFIL,
    ISNULL((SELECT  COUNT(*) FROM IFC.MTS_HOPERACIONESCNTR
    WHERE CONTRATANTEID = CTRATE.CONTRATANTEID
    AND FECHAOPERACIONCNTR >= DATEADD(MONTH,-3, OPER.FECHAOPERACIONCNTR)),'1')                                          AS  NUMERO_OPERACIONES_PERFIL,
    '02'/*CORREGIR*/                                                                                                    AS  TIPO_OPERACION_PERFIL,
    '02'    /*SIN PRIORIDAD - REPORTE DE OPERATIVA*/                                                                    AS  PRIORIDAD_REPORTE,
    'ALERTA INUSUAL' /*CORREGIR*/                                                                                       AS  ALERTA,
        NULL  /*SOLO IFC*/                                                                                              AS  NUMERO_INVERSIONISTAS,
        NULL  /*SOLO IFC*/                                                                                              AS  INVERSIONISTA,
        NULL  /*SOLO IFC*/                                                                                              AS  TIPO_PERSONA_INVERSIONISTA,
        NULL  /*SOLO IFC*/                                                                                              AS  RAZON_DENOMINACION_INVERSIONISTA,
        NULL  /*SOLO IFC*/                                                                                              AS  NOMBRE_INVERSIONISTA,
        NULL  /*SOLO IFC*/                                                                                              AS  APELLIDO_PATERNO_INVERSIONISTA,
        NULL  /*SOLO IFC*/                                                                                              AS  APELLIDO_MATERNO_INVERSIONISTA,
        NULL  /*SOLO IFC*/                                                                                              AS  TIPO_PERSONA_SOLICITANTE,
        NULL  /*SOLO IFC*/                                                                                              AS  RAZON_DENOMINACION_SOLICITANTE,
        NULL  /*SOLO IFC*/                                                                                              AS  NOMBRE_SOLICITANTE,
        NULL  /*SOLO IFC*/                                                                                              AS  APELLIDO_PATERNO_SOLICITANTE,
        NULL  /*SOLO IFC*/                                                                                              AS  APELLIDO_MATERNO_SOLICITANTE,
        '1'  /*CORREGIR EN CASO DE Q HAYA MORALES*/                                                                     AS  TIPO_PERSONA_CONTRAPARTE,
        '' /*CORREGIR EN CASO DE Q HAYA MORALES*/                                                                       AS  RAZON_DENOMINACION_CONTRAPARTE,
        ISNULL(OPER.DS_NOMBRE_BENEFICIARIO,'') /*VALIDAR*/                                                              AS  NOMBRE_CONTRAPARTE,
        ISNULL(OPER.DS_NOMBRE_BENEFICIARIO,'')/*VALIDAR*/                                                                AS  APELLIDO_PATERNO_CONTRAPARTE,
        'XXXX'                                                                                                          AS  APELLIDO_MATERNO_CONTRAPARTE,
        '260'  /*CAMBIAR ESTE VALOR POR AJUSTE DEL CATÁLOGO DE PAIS*/                                                   AS  NACIONALIDAD_CUENTA_CONTRAPARTE,
        '040'+ ISNULL (substring(RIGHT('000000000000000000'+CUENTA_ORDENANTE,18), 1,3 ),'646')/*PENDIENTE FIN COLECTIVO*/ AS  INSTITUCION_FINANCIERA_CONTRAPARTE,
        (Case when oper.TIPOOPERACIONID in ('01', '02','05') then oper.CUENTA_ORDENANTE
            when oper.TIPOOPERACIONID in ('01', '02','05') then oper.CUENTA_BENEFICIARIO
             else '123456789' end)    /*PENDIENTE FIN COLECTIVO*/                                                       AS  CUENTA_CLABE_CONTRAPARTE,
        'T'                                                                                                             AS  CVE_TIPOINUSUALIDAD,
    'TRANSACCIÓN'                                                                                                       AS  DS_TIPOINUSUALIDAD,
    HCASOS.OPERCNTRID,
    HCASOS.CODOPER,
    CASOS.CVE_TIPO_ANALISIS,
    OPER.NUMPOLIZACNTR,
   -- OPER.CONTRATANTECD,
    NULL                                                                                                                AS SW_CASO_MANUAL,
       null as TIPO_SOFOM
FROM IFC.MTS_HOPERACIONESCNTR OPER,
    IFC.MTS_DCONTRATANTE CTRATE,
    IFC.MTS_ANA_HANALISIS_CASOS CASOS,
    IFC.MTS_HRN_CASOS HCASOS,
    IFC.MTS_KYC_PERSONAS PER,
    IFC.MTS_KYC_CONTRATO_PERSONAS CPER,
    IFC.MTS_KYC_DIRECCIONES DIR
  WHERE OPER.CONTRATANTEID = CTRATE.CONTRATANTEID
        AND OPER.OPERCNTRID = CASOS.OPERCNTRID
        AND CASOS.CIERREID = HCASOS.CIERREID
        AND CASOS.CASOSID = HCASOS.CASOSID
        --AND OPER.PREFIJO = CTRATE.PREFIJO
        AND CTRATE.CONTRATANTECD = CPER.CVE_PERSONA
        AND CPER.CVE_ROL = 'CL'
        AND PER.ID_KYC = CPER.ID_KYC
        AND DIR.ID_KYC = CPER.ID_KYC
        AND CASOS.ESTATUS_OPERACION = 'OP_R'
        AND (CASOS.CVE_TIPO_ANALISIS = 'TAINU' OR CASOS.CVE_TIPO_ANALISIS = 'ALE')
go





/********************************************************************************************************************************************************************************/



CREATE OR ALTER VIEW [IFC].[MTS_VL_CASOS_PREOCUPANTES_REPORTE_ITF] AS
SELECT RIGHT('000' + LTRIM(RTRIM((SELECT ORGANISMOSUPID
                                  FROM IFC.MTS_ADM_SECTOR_CLIENTES SECTOR,
                                       IFC.MTS_ADM_LICENCIAS LIC
                                  WHERE SECTOR.CVE_SECTOR = LIC.CVE_SECTOR
                                    AND LIC.CVE_ACRONIMO = 'IFC'))), 3)                                          AS ORGANO_SUPERVISOR,
       '02'                                                                                                        AS TIPO_IFPE,
       (SELECT ENTIDADFINID FROM IFC.MTS_ADM_LICENCIAS WHERE CVE_ACRONIMO = 'IFC')                             AS SUJETO_OBLIGADO,
       3                                                                                                           AS TIPO_REPORTE,
       CONVERT(CHAR, GETDATE(), 103)                                                                               AS FECHA_REPORTE,
       null                                                                                                        AS FOLIO_CONSECUTIVO,
       ---------- empleado ----------
       '260' /*CAMBIAR ESTE VALOR POR AJUSTE DEL CATÁLOGO DE PAIS*/                                                AS PAIS_NACIONALIDAD,
       ISNULL(UPPER(EMP.EMPLEADONOMBRE), 'XXXX')                                                                   AS NOMBRE,
       UPPER(case len(EMP.EMPLEADOPATERNO)
                 when 0 then 'XXXX'
                 when null then 'XXXX'
                 else EMP.EMPLEADOPATERNO end)                                                                     AS APELLIDO_PATERNO,
       UPPER(case len(EMP.EMPLEADOMATERNO)
                 when 0 then 'XXXX'
                 when null then 'XXXX'
                 else EMP.EMPLEADOMATERNO end)                                                                          AS APELLIDO_MATERNO,
       1                                                                                                                AS GENERO,
       ISNULL(EMP.DS_EMPLEADO_RFC, '')                                                                                  AS RFC,
       ISNULL(EMP.DS_EMPLEADO_CURP, '')                                                                                 AS CURP,
       ISNULL(CONVERT(CHAR, EMP.FEC_EMPLEADO_NACIMIENTO, 103), '')                                                      AS FECHA_NACIMIENTO,
       ( SELECT CLAVE_01 FROM IFC.MTS_ANA_DCATALOGOS_CLAVES WHERE CVE_TABLA = 'CAT_ENTIDADES_FEDERATIVAS'
        AND CLAVE_02 = substring(EMP.DS_EMPLEADO_CURP,12,2))                                                                        AS ENTIDAD_NACIMIENTO,
       (select UPPER(REPLACE( REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(DS_CALLE,'.',''), 'á', 'a'), 'é', 'e'), 'í', 'i'),
           'ó', 'o'), 'ú', 'u'))  from meltsan.MTS_ADM_LICENCIAS where CVE_ACRONIMO = 'IFC')                          AS DOMICILIO_EMPLEADO,
       --''/*EMP.DOMICILIO_EMPLEADO*/                                                                                     AS DOMICILIO_EMPLEADO,
       (select CVE_ESTADO from meltsan.MTS_ADM_LICENCIAS where CVE_ACRONIMO = 'IFC')                                  AS ENTIDAD_FEDERATIVA_DOMICILIO,
      -- ''/*EMP.ESTADO_*/                                                                                                AS ENTIDAD_FEDERATIVA_DOMICILIO,
       (select UPPER(REPLACE( REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(DS_CALLE,'.',''), 'á', 'a'), 'é', 'e'), 'í', 'i'),
           'ó', 'o'), 'ú', 'u'))  from meltsan.MTS_ADM_LICENCIAS where CVE_ACRONIMO = 'IFC')                          AS CALLE_DOMICILIO,
        (select CVE_COLONIA from meltsan.MTS_ADM_LICENCIAS where CVE_ACRONIMO = 'IFC')                                AS COLONIA,
       (select CVE_DELEGACION from meltsan.MTS_ADM_LICENCIAS where CVE_ACRONIMO = 'IFC')                              AS CIUDAD_POBLACION,
       (select CVE_CODIGO_POSTAL from meltsan.MTS_ADM_LICENCIAS where CVE_ACRONIMO = 'IFC')                           AS CODIGO_POSTAL,
       (select DS_TELEFONO_CONTACTO from meltsan.MTS_ADM_LICENCIAS where CVE_ACRONIMO = 'IFC')                        AS TELEFONO,
    (Select ISNULL(SUBSTRING(UPPER(REPLACE(
               REPLACE(REPLACE(REPLACE(REPLACE(DS_PUESTO, 'á', 'a'), 'é', 'e'), 'í', 'i'), 'ó', 'o'), 'ú', 'u')), 0,
                        59),
              '')  from IFC.MTS_DPUESTOS where PUESTOID = EMP.PUESTOID )                                              AS PUESTO_ENTIDAD,
       ---------- Operación ----------
       ISNULL(RIGHT('00' + (case PRE.TIPOOPERACIONID
                                when '01' then '02'
                                when '02' then '03'
                                else '50' end), 2),
              50)                                                                                                       AS TIPOOPERACIONID,
       --(CASE WHEN PRE.INSTRMONETARIOID IS NULL THEN 50 WHEN PRE.INSTRMONETARIOID < 1 THEN 50 ELSE PRE.INSTRMONETARIOID END)	AS INSTRUMENTO_MONETARIO_ant,
       ISNULL(RIGHT('00' + (case PRE.INSTRMONETARIOID
                                when '03' then '06'
                                when '3' then '06'
                                else '50' end), 2),
              50)                                                                                                       AS INSTRUMENTO_MONETARIO,

       ISNULL(PRE.MONTOCNTR, '0.00')                                                                                    AS MONTO,
       (CASE
            WHEN PRE.MONEDAID IS NULL THEN 'NON'
            WHEN PRE.MONEDAID = '0' THEN 'NON'
            ELSE PRE.MONEDAID END)                                                                                      AS MONEDA,
       ISNULL(CONVERT(CHAR, PRE.FECHAOPERACIONCNTR, 103),
              CONVERT(CHAR, ANA.FECHADETECION_CASOS, 103))                                                              AS FECHA,
---------- Análisis ----------
       CONVERT(CHAR, ANA.FECHADETECION_CASOS, 103)                                                                      AS FECHA_DETECCION,
       UPPER(COM.DS_COMENTARIO)                                                                                         AS DESCRIPCION_PERFIL_EMPLEADO,
       UPPER(pre.DS_COMENTARIO_REPORTE)                                                                                 AS RAZONES_VULNERA_PLD,
       10 /*TBD*/                                                                                                       AS PRIORIDAD_REPORTE,
---------- Cliente Relacionado ----------
       (select CAST(tipopersonafiscalid AS INT)
               from IFC.mts_dcontratante
               where contratantecd = pre.CONTRATANTECD)                                                                 AS TIPO_PERSONA_CLIENTE,
       (select contratanterazonsocial from IFC.mts_dcontratante where contratantecd = pre.contratantecd)              as RAZON_DENOMINACION_CLIENTE,
       (select contratante from IFC.mts_dcontratante where contratantecd = pre.contratantecd)                         as NOMBRE_CLIENTE,
       (select contratantepaterno from IFC.mts_dcontratante where contratantecd = pre.contratantecd)                  as APELLIDO_PATERNO_CLIENTE,
       (select contratantematerno from IFC.mts_dcontratante where contratantecd = pre.contratantecd)                  as APELLIDO_MATERNO_CLIENTE,
       (select contratanterfc from IFC.mts_dcontratante where contratantecd = pre.contratantecd)                      as RFC_CLIENTE,
       (select contratantecurp from IFC.mts_dcontratante where contratantecd = pre.contratantecd)                     as CURP_CLIENTE,
       --ISNULL((select CONVERT (CHAR,CONTRATANTEFECHANAC,103) from IFC.mts_dcontratante where contratantecd = pre.contratantecd),'') as FECHA_NACIMIENTO_CLIENTE,
       null                                                                                                             AS FECHA_NACIMIENTO_CLIENTE,
       null                                                                                                             as NUMERO_CUENTA_CLIENTE,
---------- Varios  ----------
       ANA.CIERREID,
       ANA.CASOSID,
       ANA.ESTATUS_OPERACION,
       ANA.CVE_TIPO_ANALISIS,
       (SELECT VALOR_ATRIBUTO_01
        FROM [IFC].MTS_ANA_DCATALOGOS_CLAVES
        WHERE CVE_TABLA = 'CAT_TIPO_ANALISIS'
          AND VIGENCIA = 'S'
          AND CLAVE_01 = ANA.CVE_TIPO_ANALISIS)                                                                       DS_TIPO_ANALISIS,
       'T'                                                                                                            CVE_TIPOINUSUALIDAD,
       'TRANSACCION'                                                                                                  DS_TIPOINUSUALIDAD,
       ANA.OPERCNTRID,
       ANA.CODOPER,
       NULL                                                                                                        AS NUMPOLIZACNTR,
       NULL                                                                                                        AS CONTRATANTECD,
       NULL                                                                                                        AS SW_CASO_MANUAL
FROM IFC.MTS_ANA_HANALISIS_CASOS ANA,
     IFC.MTS_HRN_CASOS_PREOCUPANTES PRE,
     IFC.MTS_DEMPLEADO EMP,
     IFC.MTS_DSUCURSALES SUC,
     IFC.MTS_ANA_CASOS_COMENTARIOS COM
WHERE ANA.CIERREID = PRE.CIERREID
  AND ANA.CIERREID = COM.CIERREID
  AND ANA.CASOSID = PRE.CASOSID
  AND ANA.CASOSID = COM.CASOSID
  AND PRE.EMPLEADOID = EMP.EMPLEADOID
  AND EMP.SUCURSALID = SUC.SUCURSALID
  AND ANA.ESTATUS_OPERACION = 'OP_R'
  AND ANA.ESTATUS_OPERACION = COM.CVE_ESTATUS_CASO
go


/********************************************************************************************************************************************************************************/


--Creación de  Vista para Reportes Relevantes
CREATE OR ALTER  VIEW [IFC].[MTS_VL_CASOS_RELEVANTES_REPORTE_ITF] AS
    SELECT
    RIGHT('000' + LTRIM(RTRIM((SELECT SECTOR.ORGANISMOSUPID
                                  FROM IFC.MTS_ADM_SECTOR_CLIENTES SECTOR,
                                    IFC.MTS_ADM_LICENCIAS LIC
                                  WHERE SECTOR.CVE_SECTOR = LIC.CVE_SECTOR
                                        AND LIC.CVE_ACRONIMO = 'IFC'))), 3)						AS  ORGANO_SUPERVISOR,
	  '02'                                                                    						AS TIPO_IFPE,
    RIGHT('000000' + LTRIM(RTRIM(ISNULL((SELECT ENTIDADFINID
                                         FROM IFC.MTS_ADM_LICENCIAS
                                         WHERE CVE_ACRONIMO = 'IFC'),
                                        (SELECT DS_ENTIDADFIN
                                         FROM IFC.MTS_ADM_LICENCIAS
                                         WHERE CVE_ACRONIMO = 'IFC')))), 6) 						AS  SUJETO_OBLIGADO,
   -- '65-010'																   AS  SUJETO_OBLIGADO,
    1                                                                          						AS  TIPO_REPORTE,
    CONVERT(CHAR, GETDATE(), 103)                                              						AS  FECHA_REPORTE,
		NULL    														                            AS  FOLIO_CONSECUTIVO,
		(case when CTRATE.TIPOPERSONAFISCALID = 1 then '0'
			  when CTRATE.TIPOPERSONAFISCALID = 103 then '0' else '0' end)    							AS  REGIMEN,
		(case when CTRATE.TIPOPERSONAFISCALID = 1 then 1
			  when CTRATE.TIPOPERSONAFISCALID = 103 then 1 else '' end)     							AS  NIVEL_CUENTA,
	--	ISNULL (CTRATE.NUM_CUENTA,'')/* 'NUMERO DE CUENTA ASIGNADO POR LA ITF'  */								AS  NUMERO_CUENTA,
		''/* 'NUMERO DE CUENTA ASIGNADO POR LA ITF'  */								AS  NUMERO_CUENTA,
		'260'  /*CAMBIAR ESTE VALOR POR AJUSTE DEL CATÁLOGO DE PAIS*/                               AS  NACIONALIDAD_CUENTA,
		--'040'+ ISNULL (SUBSTRING(CTRATE.NUM_CUENTA,1,3),'') /*PEND*/										AS  INSTITUCION_CUENTA,
		'040'+ '' /*PEND*/										AS  INSTITUCION_CUENTA,
		ISNULL (CTRATE.NUM_CUENTA_CLABE,'')  /*Validar si es correcto*/											AS  CUENTA_ASOCIADA,
		'' /*OK PARA IFPE*/	    										                        AS  TIPO_FINANCIAMIENTO,
----------------- DATOS DE LA PERSONA
    ---CTRATE.TIPOPERSONAFISCALID,
    (SELECT (case tipopersonafiscalid when 103  then 1 when 104  then 2 when 2  then 2 else 1 end  )
     FROM IFC.MTS_DTIPOPERSONAFISCAL
     WHERE TIPOPERSONAFISCALID = CTRATE.TIPOPERSONAFISCALID)   /*OK*/	                			AS  TIPO_PERSONA_CLIENTE,
	''  /*OK PARA IFPE*/	                                                          						AS TIPO_CLIENTE,
    /*(SELECT NAC.NACIONALIDADID --Se cambia la clave de la nacionalidad SE DEBE ACTUALIZAR EL CATÁLOGO DE PAÍSES
     FROM IFC.MTS_DPAIS PA,
       IFC.MTS_DNACIONALIDAD NAC
     WHERE PA.PAISID = NAC.PAISID
           AND NAC.NACIONALIDADID = CTRATE.NACIONALIDADID)*/'260'  													AS  PAIS_NACIONALIDAD,

    (CASE CTRATE.TIPOPERSONAFISCALID
     WHEN 2
       THEN CTRATE.CONTRATANTERAZONSOCIAL
     WHEN 104
       THEN CTRATE.CONTRATANTERAZONSOCIAL
     ELSE '' END)                                                            						AS  RAZONSOCIAL,
    CTRATE.CONTRATANTEID,
    CTRATE.CONTRATANTECD,
    (CASE CTRATE.TIPOPERSONAFISCALID
     WHEN 1
       THEN CTRATE.CONTRATANTE
     WHEN 103
       THEN CTRATE.CONTRATANTE
     ELSE '' END)                                                            						AS  NOMBRE,
    (CASE CTRATE.TIPOPERSONAFISCALID
     WHEN 1
       THEN (ISNULL (CTRATE.CONTRATANTEPATERNO,'XXXX'))
     WHEN 103
       THEN (ISNULL (CTRATE.CONTRATANTEPATERNO,'XXXX'))
     ELSE '' END)                                                            						AS  APELLIDO_PATERNO,
    (CASE CTRATE.TIPOPERSONAFISCALID
     WHEN 1
       THEN (ISNULL( CTRATE.CONTRATANTEMATERNO,'XXXX'))
     WHEN 103
       THEN (ISNULL( CTRATE.CONTRATANTEMATERNO,'XXXX'))
     ELSE '' END)                                                            						AS  APELLIDO_MATERNO,
	 ISNULL((CASE CTRATE.TIPOPERSONAFISCALID
     WHEN 1
       THEN (CASE WHEN PER.CVE_GENERO = 1 THEN 2 ELSE 1 END )
     WHEN 103
       THEN (CASE WHEN PER.CVE_GENERO = 1 THEN 2 ELSE 1 END )ELSE '' END),'')                        AS GENERO,
    ISNULL(CTRATE.CONTRATANTERFC,'')                                                     								AS  RFC,
    ISNULL(CTRATE.CONTRATANTECURP ,'')                                                      								AS  CURP,
    ISNULL((CASE CTRATE.TIPOPERSONAFISCALID
     WHEN 1
       THEN (CONVERT(CHAR, CTRATE.CONTRATANTEFECHANAC, 103))
     WHEN 103
       THEN (CONVERT(CHAR, CTRATE.CONTRATANTEFECHANAC, 103))
     ELSE (CONVERT(CHAR, CTRATE.FEC_CONSTITUCION, 103)) END) ,'')                  						AS  FECHA_NACIMIENTO_CONSTITUCION,
     ISNULL(RIGHT('00'+ PER.CVE_ESTADO_NACIMIENTO,2),RIGHT('00'+ CTRATE.ESTADOID,2))                                                      				  			AS ENTIDAD_NACIMIENTO_CONSTITUCION,
    ---------------- DOMICILIO -----------------------
    ISNULL(LTRIM(RTRIM(CTRATE.CONTRATANTEDIRECCION + ' ' + CTRATE.NO_EXTERIOR + ' ' + CTRATE.NO_INTERIOR + ' ' +
                CTRATE.CODIGO_POSTAL))  ,'')                                      								 AS  DOMICILIO_CLIENTE,
    ISNULL(RIGHT('00' + CTRATE.ESTADOID,2),'')                                                            								 AS ENTIDAD_FEDERATIVA_DOMICILIO,
    ISNULL(CTRATE.CONTRATANTEDIRECCION,'')                                                								 AS  CALLE_DOMICILIO,
     (CASE  WHEN DIR.CVE_COLONIA IS NULL
		THEN (SELECT ISNULL(MAX( CVE_ID_ASENTA_CPCONS),'') FROM IFC.MTS_ADM_SEPOMEX WHERE CVE_D_CODIGO = CTRATE.CODIGO_POSTAL)
    ELSE  RIGHT('0000'+ DIR.CVE_COLONIA,4)END)										   						AS  COLONIA,
    ISNULL(ISNULL( (RIGHT('000'+CTRATE.MUNICIPIOID,3))	,
	(SELECT MAX(CVE_C_MNPIO) FROM IFC.MTS_ADM_SEPOMEX WHERE CVE_D_CODIGO = CTRATE.CODIGO_POSTAL ))
		,'')									AS  CIUDAD_POBLACION,
    ISNULL( RIGHT('00000'+CTRATE.CODIGO_POSTAL,5),'')								                       						AS  CODIGO_POSTAL,
    ISNULL(PER.NUM_TEL_CASA,'') 															 						   	 AS  TELEFONO,--se mete el telefono de kyc
	ISNULL(PER.EMAIL,'') 															 						   	 		 AS  CORREO_ELECTRONICO,
    ISNULL(PER.CVE_ACTIVIDAD_ECONOMICA,'0000000')                                               								 AS  CVE_ACTIVIDADECO, --Se agrega la actividad económica de KYC
    ISNULL( RIGHT('00' + (case OPER.TIPOOPERACIONID
		when '01' then '02'
		when '02' then '03'
		else '50' end),2),50)																								 AS  TIPO_OPERACION_ITF,
    --ISNULL(RIGHT('00' + OPER.INSTRMONETARIOID,2),50)																		 AS  INSTRUMENTO_MONETARIO_ant,
    ISNULL( RIGHT('00' + (case OPER.INSTRMONETARIOID
		when '03' then '06'
		when '3' then '06'
		else '50' end),2),50)																									AS  INSTRUMENTO_MONETARIO,
    ISNULL(CAST(OPER.MONTOCNTR AS DECIMAL(14, 2)) ,'0.00')/*si no tiene monto*/								 AS  MONTO,
    ISNULL(OPER.MONEDAID,'')                                                             								 AS  CVE_MONEDA,
    CONVERT(CHAR, OPER.FECHAOPERACIONCNTR, 103)                               								 AS  FECHA_OPERACION,
    CONVERT(CHAR, HCASOS.FECHADETECION_CASOS, 103)                            								 AS  FECHA_DETECION,
    ISNULL((CASE WHEN CTRATE.TIPOPERSONAFISCALID IN (1, 103) THEN '' ELSE (SELECT NOMBRES
	FROM IFC.MTS_KYC_PERSONAS
		WHERE ID_KYC = (SELECT ID_KYC FROM IFC.MTS_KYC_CONTRATO_PERSONAS
		WHERE ID_CONTRATO = PER.CVE_PERSONA AND CVE_ROL = 'RL')) END ),'')		   						AS  NOMBRE_APODERADO,
	ISNULL((CASE WHEN CTRATE.TIPOPERSONAFISCALID IN (1, 103) THEN '' ELSE (SELECT APELLIDO_PATERNO
	FROM IFC.MTS_KYC_PERSONAS
		WHERE ID_KYC = (SELECT ID_KYC FROM IFC.MTS_KYC_CONTRATO_PERSONAS
		WHERE ID_CONTRATO = PER.CVE_PERSONA AND CVE_ROL = 'RL')) END ),'')		   						AS  APELLIDO_PATERNO_APODERADO,
	ISNULL((CASE WHEN CTRATE.TIPOPERSONAFISCALID IN (1, 103) THEN '' ELSE (SELECT APELLIDO_MATERNO
	FROM IFC.MTS_KYC_PERSONAS
		WHERE ID_KYC = (SELECT ID_KYC FROM IFC.MTS_KYC_CONTRATO_PERSONAS
		WHERE ID_CONTRATO = PER.CVE_PERSONA AND CVE_ROL = 'RL')) END ),'')		   						AS  APELLIDO_MATERNO_APODERADO,
    HCASOS.DS_DESOPERACION_CASOS                                               						AS  DS_DESOPERACION,
	'T'																									 AS  CVE_TIPOINUSUALIDAD,
    'TRANSACCION'																							 AS  DS_TIPOINUSUALIDAD,
    HCASOS.OPERCNTRID,
    HCASOS.CODOPER,
    CASOS.CVE_TIPO_ANALISIS,
    OPER.NUMPOLIZACNTR,
   -- OPER.CONTRATANTECD,
    NULL AS SW_CASO_MANUAL
  FROM IFC.MTS_HOPERACIONESCNTR OPER,
    IFC.MTS_DCONTRATANTE CTRATE,
    IFC.MTS_ANA_HANALISIS_CASOS CASOS,
    IFC.MTS_HRN_CASOS HCASOS,
    IFC.MTS_KYC_PERSONAS PER,
    IFC.MTS_KYC_CONTRATO_PERSONAS CPER,
    IFC.MTS_KYC_DIRECCIONES DIR
  WHERE OPER.CONTRATANTEID = CTRATE.CONTRATANTEID
        AND OPER.OPERCNTRID = CASOS.OPERCNTRID
        AND CASOS.CIERREID = HCASOS.CIERREID
        AND CASOS.CASOSID = HCASOS.CASOSID
        AND CTRATE.CONTRATANTECD = CPER.CVE_PERSONA
        AND CPER.CVE_ROL = 'CL'
        AND PER.ID_KYC = CPER.ID_KYC
        AND DIR.ID_KYC = CPER.ID_KYC
        AND CASOS.ESTATUS_OPERACION = 'OP_R'
        AND CASOS.CVE_TIPO_ANALISIS = 'TAREL'
go


/********************************************************************************************************************************************************************************/




------------ Cambios para Reporte de 24 Horas IFC

--------Reportes de 24 Horas ITF




CREATE or ALTER VIEW [IFC].[MTS_VL_CASOS_HORAS_REPORTE_ITF] AS
    SELECT RIGHT('000' + LTRIM(RTRIM((SELECT SECTOR.ORGANISMOSUPID
                                  FROM IFC.MTS_ADM_SECTOR_CLIENTES SECTOR,
                                    IFC.MTS_ADM_LICENCIAS LIC
                                  WHERE SECTOR.CVE_SECTOR = LIC.CVE_SECTOR
                                        AND LIC.CVE_ACRONIMO = 'IFC'))), 3)                                           AS ORGANO_SUPERVISOR,
      '01'                                                                                                              AS TIPO_IFPE,
   ( SELECT ENTIDADFINID
                                         FROM IFC.MTS_ADM_LICENCIAS
                                         WHERE CVE_ACRONIMO = 'IFC')                                                  AS  SUJETO_OBLIGADO,
   -- '65-010'                                                                                                          AS  SUJETO_OBLIGADO,
    2                                                                                                                   AS  TIPO_REPORTE,
    CONVERT(CHAR, GETDATE(), 103)                                                                                       AS  FECHA_REPORTE,
        NULL                                                                                                            AS  FOLIO_CONSECUTIVO,
        (case when CTRATE.TIPOPERSONAFISCALID = 1 then '0'
              when CTRATE.TIPOPERSONAFISCALID = 2 then '0'
              when CTRATE.TIPOPERSONAFISCALID = 3 then '0' else '0' end)                                                AS  REGIMEN,
        (case when CTRATE.TIPOPERSONAFISCALID = 1 then ''
              when CTRATE.TIPOPERSONAFISCALID = 2 then ''
              when CTRATE.TIPOPERSONAFISCALID = 3 then '' else '' end)                                                  AS  NIVEL_CUENTA,

       ISNULL (CTRATE.NUM_CUENTA_CLABE,'NO EXISTE OPERACION RELACIONADA A REPORTAR')/*NUMERO DE CUENTA ASIGNADO POR LA ITF*/  AS  NUMERO_CUENTA,
        '260'  /*CAMBIAR ESTE VALOR POR AJUSTE DEL CATÁLOGO DE PAIS*/                                                   AS  NACIONALIDAD_CUENTA,/*
      '040'+ ISNULL(substring(RIGHT('000000000000000000'+(
          SELECT DS_VALOR FROM IFC.MTS_KYC_ATRVAL_DATOS_ADICIONALES
          WHERE ID_KYC = CTRATE.ID_KYC AND CVE_ATRIBUTO = 'CTA_CLABE_ITF'),18), 1,3 ),646)                              AS  INSTITUCION_CUENTA, */ -- Se necesita que se integre el id_kyc en el reporte
           null AS  INSTITUCION_CUENTA, -- No se tiene el dato aun 11-04-2024
          'NO EXISTE OPERACION RELACIONADA A REPORTAR'  /*Validar si es correcto*/                                      AS  CUENTA_ASOCIADA,
        '' /*OK PARA IFC*/                                                                                             AS  TIPO_FINANCIAMIENTO,
             ----------------- DATOS DE LA PERSONA -----------------
    (SELECT (case tipopersonafiscalid when 103  then 1 when 3  then 1 when 2  then 2 else 1 end  )
     FROM IFC.MTS_DTIPOPERSONAFISCAL
     WHERE TIPOPERSONAFISCALID = CTRATE.TIPOPERSONAFISCALID)   /*OK*/                                                   AS TIPO_PERSONA,
        ''  /*OK PARA IFC*/                                                                                            AS TIPO_CLIENTE,
    (select  CLAVE_03  from IFC.MTS_ANA_DCATALOGOS_CLAVES
    where CVE_TABLA = 'MTS_DPAIS' and cast(CLAVE_02 as VARCHAR) = cast (CTRATE.PAIS_NACIMIENTO as VARCHAR))             AS CVE_NACIONALIDAD,
    (CASE CTRATE.TIPOPERSONAFISCALID
     WHEN 2
       THEN CTRATE.CONTRATANTERAZONSOCIAL
     WHEN 104
       THEN CTRATE.CONTRATANTERAZONSOCIAL
     ELSE '' END)                                                                                                       AS  RAZON_SOCIAL_DENOMINACION,
    CTRATE.CONTRATANTEID,
    CTRATE.CONTRATANTECD,
    (CASE CTRATE.TIPOPERSONAFISCALID
     WHEN 1
       THEN CTRATE.CONTRATANTE
    WHEN 3
       THEN CTRATE.CONTRATANTE
     WHEN 103
       THEN CTRATE.CONTRATANTE
     ELSE '' END)                                                                                                       AS  NOMBRE,
    (CASE CTRATE.TIPOPERSONAFISCALID
     WHEN 1
       THEN (ISNULL (CTRATE.CONTRATANTEPATERNO,'XXXX'))
    WHEN 3
       THEN (ISNULL (CTRATE.CONTRATANTEPATERNO,'XXXX'))
     WHEN 103
       THEN (ISNULL (CTRATE.CONTRATANTEPATERNO,'XXXX'))
     ELSE '' END)                                                                                                       AS  APELLIDO_PATERNO,
    (CASE CTRATE.TIPOPERSONAFISCALID
     WHEN 1
       THEN (ISNULL( CTRATE.CONTRATANTEMATERNO,'XXXX'))
     WHEN 3
       THEN (ISNULL( CTRATE.CONTRATANTEMATERNO,'XXXX'))
     WHEN 103
       THEN (ISNULL( CTRATE.CONTRATANTEMATERNO,'XXXX'))
     ELSE '' END)                                                                                                       AS  APELLIDO_MATERNO,
     (CASE
     WHEN CTRATE.TIPOPERSONAFISCALID IN (2, 104)
       THEN ''
     WHEN CTRATE.TIPOPERSONAFISCALID IN (1, 3, 103)
        THEN (CASE WHEN (substring(CTRATE.CONTRATANTECURP,11,1) ) = 'H' THEN 2
            WHEN(substring(CTRATE.CONTRATANTECURP,11,1))  = 'M' THEN 1 ELSE '' END )
    ELSE '' END)/*1-F, 2-M    */                                                                                        AS GENERO,
    ISNULL(CTRATE.CONTRATANTERFC,'')                                                                                    AS  RFC,
    ISNULL(CTRATE.CONTRATANTECURP ,'')                                                                                  AS  CURP,
    ISNULL((CASE CTRATE.TIPOPERSONAFISCALID
     WHEN 1
       THEN (CONVERT(CHAR, CTRATE.CONTRATANTEFECHANAC, 103))
     WHEN 3
       THEN (CONVERT(CHAR, CTRATE.CONTRATANTEFECHANAC, 103))
     WHEN 103
       THEN (CONVERT(CHAR, CTRATE.CONTRATANTEFECHANAC, 103))
     ELSE (CONVERT(CHAR, CTRATE.FEC_CONSTITUCION, 103)) END),'')                                                        AS FECHA_NACIMIENTO_CONSTITUCION,
        ISNULL(RIGHT('00'+CTRATE.ESTADOID,2),'')                                                                        AS ENTIDAD_NACIMIENTO_CONSTITUCION,
    ISNULL(LTRIM(RTRIM(CTRATE.CONTRATANTEDIRECCION + ' ' + CTRATE.NO_EXTERIOR + ' ' + CTRATE.NO_INTERIOR + ' ' +
                CTRATE.CODIGO_POSTAL)),'')                                                                              AS  DOMICILIO_CLIENTE,
    ISNULL(RIGHT('00'+CTRATE.ESTADOID,2),'')                                                                            AS  ENTIDAD_FEDERATIVA_DOMICILIO,
    ISNULL(CTRATE.CONTRATANTEDIRECCION,'')                                                                              AS  CALLE_DOMICILIO,
    (SELECT ISNULL(MAX( CVE_ID_ASENTA_CPCONS),'') FROM IFC.MTS_ADM_SEPOMEX
        WHERE CVE_D_CODIGO = CTRATE.CODIGO_POSTAL)                                                                      AS  COLONIA,
    ISNULL(ISNULL( (RIGHT('000'+CTRATE.MUNICIPIOID,3))  ,
    (SELECT MAX(CVE_C_MNPIO) FROM IFC.MTS_ADM_SEPOMEX WHERE CVE_D_CODIGO = CTRATE.CODIGO_POSTAL ))
        ,'')                                                                                                            AS  CIUDAD_POBLACION,
    ISNULL( RIGHT('00000'+CTRATE.CODIGO_POSTAL,5),'')                                                                   AS  CODIGO_POSTAL,
           (select NUM_TEL_CELULAR from IFC.MTS_KYC_PERSONAS where cve_persona = CTRATE.CONTRATANTECURP   )                                                                                AS  TELEFONO,
    ISNULL( UPPER(CTRATE.CONTRATANTEEMAIL)    ,'')                                                                      AS  CORREO_ELECTRONICO,
    ISNULL( CTRATE.ACTIVIDADECOID ,'0000000')                                                                           AS  CVE_ACTIVIDADECO,
    ISNULL( CASOS_MANUALES.TIPOOPERACIONID, 50)                                                                          AS  TIPO_OPERACION_ITF,
           right(('0' + LTRIM(RTRIM(CASE CASOS_MANUALES.INSTRMONETARIOID
                                        WHEN 11
                                            THEN '03'
                                        WHEN 12
                                            THEN '03'
                                        WHEN 13
                                            THEN '03'
                                        ELSE CASOS_MANUALES.INSTRMONETARIOID END))), 2)                                   AS  INSTRUMENTO_MONETARIO,
   REPLACE(CONVERT(VARCHAR(40), (CAST(CASOS_MANUALES.MONTOMNCNTR_CASOS AS MONEY)), 1), '.00', '')                       AS MONTO,
           CASOS_MANUALES.MONEDAID                                                      AS                              CVE_MONEDA,
    CONVERT(CHAR, CASOS_MANUALES.FECHAOPERACIONCNTR_CASOS, 103)                                                         AS  FECHA_OPERACION, -- No se tiene este valor en la columna viene null
    CONVERT(CHAR, CASOS_MANUALES.FECHADETECION_CASOS, 103)                                                              AS FECHA_DETECCION,
    ISNULL((CASE WHEN CTRATE.TIPOPERSONAFISCALID IN (1,3,103) THEN '' ELSE (SELECT NOMBRES
    FROM IFC.MTS_KYC_PERSONAS
        WHERE ID_KYC = (SELECT ID_KYC FROM IFC.MTS_KYC_CONTRATO_PERSONAS
        WHERE ID_CONTRATO = CTRATE.CONTRATANTECD AND CVE_ROL = 'RL')) END ),'')                                         AS  NOMBRE_APODERADO,
    ISNULL((CASE WHEN CTRATE.TIPOPERSONAFISCALID IN (1,3,103) THEN '' ELSE (SELECT APELLIDO_PATERNO
    FROM IFC.MTS_KYC_PERSONAS
        WHERE ID_KYC = (SELECT ID_KYC FROM IFC.MTS_KYC_CONTRATO_PERSONAS
        WHERE ID_CONTRATO = CTRATE.CONTRATANTECD AND CVE_ROL = 'RL')) END ),'')                                         AS  APELLIDO_PATERNO_APODERADO,
    ISNULL((CASE WHEN CTRATE.TIPOPERSONAFISCALID IN (1,3,103) THEN '' ELSE (SELECT APELLIDO_MATERNO
    FROM IFC.MTS_KYC_PERSONAS
        WHERE ID_KYC = (SELECT ID_KYC FROM IFC.MTS_KYC_CONTRATO_PERSONAS
        WHERE ID_CONTRATO = CTRATE.CONTRATANTECD AND CVE_ROL = 'RL')) END ),'')                                         AS  APELLIDO_MATERNO_APODERADO,
           CASOS_MANUALES.DESOPERACION_CASOS                                                          AS                DS_DESOPERACION,
           CASOS_MANUALES.RAZONOPERACION_CASOS                                                        AS                RAZONOPERACION,
        DATEADD(MONTH,-3, CASOS_MANUALES.FECHAOPERACIONCNTR_CASOS)                                                      AS  FECHA_INICIO_PERFIL,
        DATEADD(DAY ,-1, CASOS_MANUALES.FECHAOPERACIONCNTR_CASOS)                                                       AS  FECHA_FIN_PERFIL,
    (SELECT  isnull(SUM(ISNULL(MONTOCNTR,0)),1.00) FROM IFC.MTS_HOPERACIONESCNTR
    WHERE CONTRATANTECD = CTRATE.CONTRATANTECD
    AND FECHAOPERACIONCNTR >= DATEADD(MONTH,-3, CASOS_MANUALES.FECHADETECION_CASOS))                                    AS  MONTO_TOTAL_PERFIL,
     ISNULL((select MONEDAID from (
        select top(1) MONEDAID,  count (*) as cuenta
        from IFC.MTS_HOPERACIONESCNTR WHERE CONTRATANTECD = CTRATE.CONTRATANTECD
        AND FECHAOPERACIONCNTR >= DATEADD(MONTH,-3, CASOS_MANUALES.FECHADETECION_CASOS)
        group by MONEDAID order by cuenta desc) A )  ,'MXN')                                                            AS  MONEDA_PERFIL,
    ISNULL((SELECT  COUNT(*) FROM IFC.MTS_HOPERACIONESCNTR
    WHERE CONTRATANTECD = CTRATE.CONTRATANTECD
    AND FECHAOPERACIONCNTR >= DATEADD(MONTH,-3, CASOS_MANUALES.FECHADETECION_CASOS)),'1')                               AS  NUMERO_OPERACIONES_PERFIL,
    '02'/*CORREGIR*/                                                                                                    AS  TIPO_OPERACION_PERFIL,
    '02'    /*SIN PRIORIDAD - REPORTE DE OPERATIVA*/                                                                    AS  PRIORIDAD_REPORTE,
    'ALERTA INUSUAL' /*CORREGIR*/                                                                                       AS  ALERTA,
        NULL  /*SOLO IFC*/                                                                                              AS  NUMERO_INVERSIONISTAS,
        NULL  /*SOLO IFC*/                                                                                              AS  INVERSIONISTA,
        NULL  /*SOLO IFC*/                                                                                              AS  TIPO_PERSONA_INVERSIONISTA,
        NULL  /*SOLO IFC*/                                                                                              AS  RAZON_DENOMINACION_INVERSIONISTA,
        NULL  /*SOLO IFC*/                                                                                              AS  NOMBRE_INVERSIONISTA,
        NULL  /*SOLO IFC*/                                                                                              AS  APELLIDO_PATERNO_INVERSIONISTA,
        NULL  /*SOLO IFC*/                                                                                              AS  APELLIDO_MATERNO_INVERSIONISTA,
        NULL  /*SOLO IFC*/                                                                                              AS  TIPO_PERSONA_SOLICITANTE,
        NULL  /*SOLO IFC*/                                                                                              AS  RAZON_DENOMINACION_SOLICITANTE,
        NULL  /*SOLO IFC*/                                                                                              AS  NOMBRE_SOLICITANTE,
        NULL  /*SOLO IFC*/                                                                                              AS  APELLIDO_PATERNO_SOLICITANTE,
        NULL  /*SOLO IFC*/                                                                                              AS  APELLIDO_MATERNO_SOLICITANTE,
        '1'  /*CORREGIR EN CASO DE Q HAYA MORALES*/                                                                     AS  TIPO_PERSONA_CONTRAPARTE,
        '' /*CORREGIR EN CASO DE Q HAYA MORALES*/                                                                       AS  RAZON_DENOMINACION_CONTRAPARTE,
      --  ISNULL(OPER.DS_NOMBRE_BENEFICIARIO,'') /*VALIDAR*/                                                              AS  NOMBRE_CONTRAPARTE,
      null  AS  NOMBRE_CONTRAPARTE,
      --  ISNULL(OPER.DS_NOMBRE_BENEFICIARIO,'')/*VALIDAR*/                                                               AS  APELLIDO_PATERNO_CONTRAPARTE,
           null  AS  APELLIDO_PATERNO_CONTRAPARTE,
        'XXXX'                                                                                                          AS  APELLIDO_MATERNO_CONTRAPARTE,
        '260'  /*CAMBIAR ESTE VALOR POR AJUSTE DEL CATÁLOGO DE PAIS*/                                                   AS  NACIONALIDAD_CUENTA_CONTRAPARTE,
        --'040'+ ISNULL (substring(RIGHT('000000000000000000'+OPER.CUENTA_ORDENANTE,18), 1,3 ),'646')/*PENDIENTE FIN COLECTIVO*/ AS  INSTITUCION_FINANCIERA_CONTRAPARTE,
        '' AS  INSTITUCION_FINANCIERA_CONTRAPARTE,
        /*   (Case when oper.TIPOOPERACIONID in ('01', '02','05') then oper.CUENTA_ORDENANTE
            when oper.TIPOOPERACIONID in ('01', '02','05') then oper.CUENTA_BENEFICIARIO
             else '123456789' end)    /*PENDIENTE FIN COLECTIVO*/                  */                                     '' AS  CUENTA_CLABE_CONTRAPARTE,
        'T'                                                                                                             AS  CVE_TIPOINUSUALIDAD,
    'TRANSACCIÓN'                                                                                                       AS  DS_TIPOINUSUALIDAD,
    '' as opercntrid,
    '' as codoper,
    CASOS_MANUALES.CVE_TIPO_ANALISIS,
    CASOS_MANUALES.NUMPOLIZACNTR_CASOS as NUMPOLIZACNTR,
   -- OPER.CONTRATANTECD,
    NULL                                                                                                                AS SW_CASO_MANUAL,
    --CASOS_MANUALES.TIPO_OPERACION AS DS_TIPO_OPERACION,
    'TENTATIVA'     AS DS_TIPO_OPERACION,
    'REPORTE DE 24 HORAS' AS DS_TIPO_ANALISIS,
           CASOS_MANUALES.FECHADETECION_CASOS AS FECHA_DICTAMEN,
          -- CASOS_MANUALES.NUMPOLIZACNTR_CASOS AS NUMERO_CUENTA,
           CASOS_MANUALES.TIPOOPERACIONID AS TIPO_OPERACION,
           (select DS_TIPO_OPERACION from IFC.MTS_DTIPO_OPERACIONES  where CASOS_MANUALES.TIPOOPERACIONID = CASOS_MANUALES.TIPO_OPERACION) AS DESCRIPCION_TIPO_OPERACION,
           CASOS_MANUALES.CVE_TIPO_ANALISIS as TIPO_ANALISIS,
           '24 HORAS ' as DESCRIPCION_TIPO_ANALISIS
   ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
    /*FROM IFC.MTS_ANA_HRN_CASOS_POLIZAS_AUD CASOS_MANUALES, IFC.MTS_DCONTRATANTE CTRATE
    WHERE CASOS_MANUALES.CVE_TIPO_ANALISIS = 'TA24H'
     AND CASOS_MANUALES.CONTRATANTERFC_CASOS = CTRATE.CONTRATANTERFC*/
FROM IFC.MTS_ANA_HRN_CASOS_POLIZAS_AUD CASOS_MANUALES
LEFT JOIN IFC.MTS_DCONTRATANTE CTRATE ON CASOS_MANUALES.CONTRATANTECURP_CASOS = CTRATE.CONTRATANTECURP
WHERE CASOS_MANUALES.CVE_TIPO_ANALISIS = 'TA24H'
go





--
CREATE OR ALTER  VIEW [IFC].[MTS_VL_CASOS_INUSUALES_REPORTE] AS

    SELECT null as ID_SESION,
           null as ID_REGISTRO,
           CONVERT(CHAR, GETDATE(), 103)                                             AS   FECHA_PERIODO,
           CONVERT(VARCHAR(10), GETDATE(), 112)                                      AS   PERIODO,
           2                                                                              TIPO_REPORTE,
           2                                                                              TIPO_REPORTE_CASO,
           RIGHT('000000' + LTRIM(RTRIM(ISNULL((SELECT ENTIDADFINID
                                                FROM IFC.MTS_ADM_LICENCIAS
                                                WHERE CVE_ACRONIMO = 'IFC'),
                                               (SELECT DS_ENTIDADFIN
                                                FROM IFC.MTS_ADM_LICENCIAS
                                                WHERE CVE_ACRONIMO = 'IFC')))), 6) AS   SUJETO_OBLIGADO,
           RIGHT('000000' + LTRIM(RTRIM((SELECT ORGANISMOSUPID
                                         FROM IFC.MTS_ADM_SECTOR_CLIENTES SECTOR,
                                              IFC.MTS_ADM_LICENCIAS LIC
                                         WHERE SECTOR.CVE_SECTOR = LIC.CVE_SECTOR
                                           AND LIC.CVE_ACRONIMO = 'IFC'))), 6)     AS   ORGANO_SUPERVISOR,
           -- OPER.SUCURSALID AS CVE_SUCURSAL,
           '0'                                                                       AS   CVE_SUCURSAL,
           --(CASE OPER.SUCURSALID WHEN 1 THEN '0' ELSE OPER.SUCURSALID END ) AS CVE_SUCURSAL,
           (SELECT DS_SUCURSAL
            FROM IFC.MTS_DSUCURSALES S
            WHERE S.SUCURSALID = OPER.SUCURSALID)                                         DS_SUCURSAL,
           (SELECT CVE_LOCALIDAD
            FROM IFC.MTS_DSUCURSALES S
            WHERE S.SUCURSALID = OPER.SUCURSALID)                                         CVE_LOCALIDAD_SUCURSAL,
           --RIGHT('0' + LTRIM(RTRIM(OPER.TIPOOPERACIONID)), 2)                         AS  CVE_TIPOOPERACION,
           RIGHT(('0' + LTRIM(RTRIM(case OPER.TIPOOPERACIONID
                                        when 41 then '09'
                                        when 12 then '03'
                                        when 13 then '03'
                                        else OPER.TIPOOPERACIONID end))), 2)         AS   CVE_TIPOOPERACION,
           (SELECT DS_TIPO_OPERACION
            FROM IFC.MTS_DTIPO_OPERACIONES
            WHERE TIPOOPERACIONID = OPER.TIPOOPERACIONID)                                 DS_TIPO_OPERACION,
           right(('0' + LTRIM(RTRIM(CASE OPER.INSTRMONETARIOID
                                        WHEN 11
                                            THEN '03'
                                        WHEN 12
                                            THEN '03'
                                        WHEN 13
                                            THEN '03'
                                        ELSE OPER.INSTRMONETARIOID END))), 2)        AS   CVE_INSTRMONETARIO,
           (SELECT DS_INST_MONETARIO
            FROM IFC.MTS_DINSTRUMENTO_MONETARIO
            WHERE INSTRMONETARIOID = OPER.INSTRMONETARIOID)                               DS_INST_MONETARIO,
           OPER.NUMPOLIZACNTR,
           REPLACE(CONVERT(VARCHAR(40), (CAST(OPER.MONTOCNTR AS DECIMAL)), 1), '.00', '') MONTOCNTR,
           CAST(OPER.MONTOCNTR AS DECIMAL(14, 2))                                         MONTO,
           OPER.MONEDAID                                                             AS   CVE_MONEDA,
           (SELECT DS_MONEDA
            FROM IFC.MTS_DMONEDA
            WHERE MONEDAID = OPER.MONEDAID)                                               DS_MONEDA,
           CONVERT(CHAR, OPER.FECHAOPERACIONCNTR, 103)                               AS   FECHAOPERACIONCNTR,
           CONVERT(CHAR, OPER.FECHAOPERACIONCNTR, 112)                               AS   FECHA_OPERACION,
           CTRATE.CONTRATANTEID,
           CTRATE.CONTRATANTECD,
           (CASE CTRATE.TIPOPERSONAFISCALID
                WHEN 1
                    THEN CTRATE.CONTRATANTE
                ELSE NULL END)                                                       AS   NOMBRE,
           (CASE CTRATE.TIPOPERSONAFISCALID
                WHEN 1
                    THEN (CASE CTRATE.CONTRATANTEPATERNO
                              WHEN NULL
                                  THEN 'XXXX'
                              ELSE CTRATE.CONTRATANTEPATERNO END)
                ELSE NULL END)                                                       AS   APELLIDO_PATERNO,
           (CASE CTRATE.TIPOPERSONAFISCALID
                WHEN 1
                    THEN (CASE CTRATE.CONTRATANTEMATERNO
                              WHEN NULL
                                  THEN 'XXXX'
                              ELSE CTRATE.CONTRATANTEMATERNO END)
                ELSE NULL END)                                                       AS   APELLIDO_MATERNO,
           (CASE CTRATE.TIPOPERSONAFISCALID
                WHEN 2
                    THEN CTRATE.CONTRATANTERAZONSOCIAL
                ELSE NULL END)                                                       AS   RAZONSOCIAL,
           CTRATE.TIPOPERSONAFISCALID,
           (SELECT TIPOPERSONAFISCAL
            FROM IFC.MTS_DTIPOPERSONAFISCAL
            WHERE TIPOPERSONAFISCALID = CTRATE.TIPOPERSONAFISCALID)                  AS   DS_TIPOPERSONAFISCAL,
           (SELECT NAC.NACIONALIDADID --Se cambia la clave de la nacionalidad
            FROM IFC.MTS_DPAIS PA,
                 IFC.MTS_DNACIONALIDAD NAC
            WHERE PA.PAISID = NAC.PAISID
              AND NAC.NACIONALIDADID = CTRATE.NACIONALIDADID)                        AS   CVE_NACIONALIDAD,
           (SELECT N.NACIONALIDAD
            FROM IFC.MTS_DNACIONALIDAD N
            WHERE NACIONALIDADID = CTRATE.NACIONALIDADID)                            AS   DS_NACIONALIDAD,
           LTRIM(RTRIM(CTRATE.CONTRATANTEDIRECCION + ' ' + CTRATE.NO_EXTERIOR + ' ' + CTRATE.NO_INTERIOR + ' ' +
                       CTRATE.CODIGO_POSTAL))                                        AS   DIRECCION,
           CTRATE.CONTRATANTEDIRECCION                                               AS   CALLE,
           CTRATE.NO_EXTERIOR,
           CTRATE.NO_INTERIOR,
           CTRATE.CODIGO_POSTAL,
           -- CTRATE.CONTRATANTETELEFONO                                                 AS  TELEFONO,
           PER.NUM_TEL_CASA                                                          AS   TELEFONO,--se mete el telefono de kyc
           (CASE CTRATE.TIPOPERSONAFISCALID
                WHEN 1
                    THEN (CONVERT(CHAR, CTRATE.CONTRATANTEFECHANAC, 103))
                ELSE (CONVERT(CHAR, CTRATE.FEC_CONSTITUCION, 103)) END)              AS   CONTRATANTEFECHANAC,
           CONVERT(CHAR, CTRATE.CONTRATANTEEDADCONT, 103)                            AS   CONTRATANTEEDADCONT,
           (SELECT CASE
                       WHEN CTRATE.TIPOPERSONAFISCALID = 1
                           THEN
                           CONVERT(CHAR, CTRATE.CONTRATANTEFECHANAC, 112)
                       ELSE
                           CONVERT(CHAR, CTRATE.FEC_CONSTITUCION, 112) END)          AS   FECHA_NAC_CONT,
           CTRATE.CONTRATANTECURP                                                    AS   CURP,
           CTRATE.CONTRATANTERFC                                                     AS   RFC,
           CTRATE.PAISID,
           (SELECT DS_PAIS
            FROM IFC.MTS_DPAIS
            WHERE PAISID = CTRATE.PAISID)                                                 DS_PAIS_DOMICILIO,
           CTRATE.ESTADOID,
           (SELECT DISTINCT DS_D_ESTADO
            FROM MELTSAN.MTS_ADM_SEPOMEX SEPOMEX
            WHERE SEPOMEX.CVE_ID_ASENTA_CPCONS = cast(CTRATE.COLONIAID as int)
              AND SEPOMEX.CVE_C_MNPIO = cast(CTRATE.MUNICIPIOID as int)
              AND SEPOMEX.CVE_C_ESTADO = RIGHT('00'+ LTRIM(RTRIM(CTRATE.ESTADOID)),2))                    DS_ESTADO,
           CTRATE.MUNICIPIOID,
           (SELECT DISTINCT DS_D_MNPIO
            FROM MELTSAN.MTS_ADM_SEPOMEX SEPOMEX
            WHERE SEPOMEX.CVE_ID_ASENTA_CPCONS = RIGHT('000'+ LTRIM(RTRIM(CTRATE.COLONIAID)),3)
              AND SEPOMEX.CVE_C_MNPIO = RIGHT('000'+ LTRIM(RTRIM(CTRATE.MUNICIPIOID)),3)
              AND SEPOMEX.CVE_C_ESTADO = RIGHT('00'+ LTRIM(RTRIM(CTRATE.ESTADOID)),2)
           )                                                                              DS_MUNICIPIO,
           --CTRATE.COLONIAID                                                               AS  COLONIAID,--Se cambia la columna para que traiga el id de la colonia
           DIR.CVE_COLONIA                                                           AS   COLONIAID,--Se cambia la columna para que traiga el id de la colonia
           (case
                when CTRATE.CONTRATANTECOLONIA is null then
                    (SELECT distinct(DS_D_ASENTA)
                     FROM MELTSAN.MTS_ADM_SEPOMEX SEPOMEX
                     WHERE SEPOMEX.CVE_ID_ASENTA_CPCONS = cast(CTRATE.COLONIAID as int)
                       AND SEPOMEX.CVE_C_MNPIO = cast(CTRATE.MUNICIPIOID as int)
                       AND SEPOMEX.CVE_C_ESTADO = RIGHT('00'+ LTRIM(RTRIM(CTRATE.ESTADOID)),2)
                    )
                ELSE
                    CTRATE.CONTRATANTECOLONIA end)                                   as   DES_COLONIA, --se agrega la descripción de la colonia
           --CTRATE.ACTIVIDADECOID                                                      AS  CVE_ACTIVIDADECO,
           PER.CVE_ACTIVIDAD_ECONOMICA                                               AS   CVE_ACTIVIDADECO, --Se agrega la actividad económica de KYC
           (SELECT DS_ACTIVIDADECO
            FROM IFC.MTS_DACTIVIDADECONOMICA
            WHERE ACTIVIDADECOID = CTRATE.ACTIVIDADECOID)                                 DS_ACTIVIDADECO,
           (SELECT CASE
                       WHEN CTRATE.CVE_LOCALIDAD IS NULL
                           THEN (SELECT CVE_LOCALIDAD
                                 FROM IFC.MTS_CLOCALIDADES_CNBV
                                 WHERE CVE_LOCALIDAD = CTRATE.CVE_LOCALIDAD)
                       ELSE CTRATE.CVE_LOCALIDAD END)                                AS   CVE_LOCALIDAD,
           (SELECT DS_LOCALIDAD
            FROM IFC.MTS_CLOCALIDADES_CNBV
            WHERE CVE_LOCALIDAD = CTRATE.CVE_LOCALIDAD)                                   DS_LOCALIDAD,
           CASOS.CIERREID,
           CASOS.CASOSID,
           CASOS.ESTATUS_OPERACION,
           CASOS.CVE_TIPO_ANALISIS,
           (SELECT VALOR_ATRIBUTO_01
            FROM IFC.MTS_ANA_DCATALOGOS_CLAVES
            WHERE CVE_TABLA = 'CAT_TIPO_ANALISIS'
              AND VIGENCIA = 'S'
              AND CLAVE_01 = CASOS.CVE_TIPO_ANALISIS)                                     DS_TIPO_ANALISIS,
           CONVERT(CHAR, HCASOS.FECHADETECION_CASOS, 103)                            AS   FECHADETECION_CASOS,
           CONVERT(CHAR, HCASOS.FECHADETECION_CASOS, 112)                            AS   FECHA_DETECCION, -- se cambia la tabla a hrn_casos
           HCASOS.AGENTENOMBRE_CASOS                                                 AS   AGENTENOMBRE,
           HCASOS.AGENTEPATERNO_CASOS                                                AS   AGENTEPATERNO,
           HCASOS.AGENTEMATERNO_CASOS                                                AS   AGENTEMATERNO,
           HCASOS.AGENTERFC_CASOS                                                    AS   AGENTERFC,
           HCASOS.AGENTECURP_CASOS                                                   AS   AGENTECURP,
           --CONVERT(VARCHAR(10), HCASOS.CONSECNTAREL_CASOS) AS CONSECNTAREL,
           NULL                                                                      AS   CONSECNTAREL,
           HCASOS.NUMPOLIZABENEF_CASOS                                               AS   NUMPOLIZABENEF,
           HCASOS.DS_ENTIDADFINIDBENEF_CASOS                                         AS   DS_ENTIDADFINIDBENEF,
           HCASOS.BENEFICIARIO_CASOS                                                 AS   BENEFICIARIOS,
           HCASOS.BENEFICIARIOPATERNO_CASOS                                          AS   BENEFICIARIOPATERNO,
           HCASOS.BENEFICIARIOMATERNO_CASOS                                          AS   BENEFICIARIOMATERNO,
           HCASOS.DS_DESOPERACION_CASOS                                              AS   DS_DESOPERACION,
           HCASOS.RAZONOPERACION_CASOS                                               AS   RAZONOPERACION,
           HCASOS.SW_CASO_MANUAL,
           'T'                                                                            CVE_TIPOINUSUALIDAD,
           'TRANSACCION'                                                                  DS_TIPOINUSUALIDAD,
           HCASOS.OPERCNTRID,
           HCASOS.CODOPER
    FROM IFC.MTS_HOPERACIONESCNTR OPER,
         IFC.MTS_DCONTRATANTE CTRATE,
         IFC.MTS_ANA_HANALISIS_CASOS CASOS,
         IFC.MTS_HRN_CASOS HCASOS,
         IFC.MTS_KYC_PERSONAS PER,
         IFC.MTS_KYC_CONTRATO_PERSONAS CPER,
         IFC.MTS_KYC_DIRECCIONES DIR,
         IFC.MTS_VL_KYC_PERSONAS KPER
    WHERE OPER.CONTRATANTEID = CTRATE.CONTRATANTEID
      AND OPER.OPERCNTRID = CASOS.OPERCNTRID
      AND CASOS.CIERREID = HCASOS.CIERREID
      AND CASOS.CASOSID = HCASOS.CASOSID
      AND CTRATE.CONTRATANTECD = KPER.CONTRATANTECD
      AND CPER.ID_CONTRATO = KPER.ID_CONTRATO
      AND CPER.CVE_ROL = 'CL'
      AND PER.ID_KYC = CPER.ID_KYC
      AND DIR.ID_KYC = CPER.ID_KYC
      AND DIR.ID_DIRECCION = (select max(D.ID_DIRECCION) from IFC.MTS_KYC_DIRECCIONES D where d.ID_KYC = Dir.ID_KYC)
      AND CASOS.ESTATUS_OPERACION = 'OP_R'
      AND (CASOS.CVE_TIPO_ANALISIS = 'TAINU' OR CASOS.CVE_TIPO_ANALISIS = 'ALE')


    UNION
    SELECT CASOS_MANUALES.ID_SESION,
           CASOS_MANUALES.ID_REGISTRO,
           CONVERT(CHAR, GETDATE(), 103)                                                AS                FECHA_PERIODO,
           CONVERT(VARCHAR(10), GETDATE(), 112)                                         AS                PERIODO,
           CASOS_MANUALES.CVE_TIPO_REPORTE                                              AS                TIPO_REPORTE,
           2                                                                                              TIPO_REPORTE_CASO,
           RIGHT('000000' + CASOS_MANUALES.ENTIDADFINID_CASOS, 6)                       AS                SUJETO_OBLIGADO,
           RIGHT('000000' + CASOS_MANUALES.ORGANISMOSUPID_CASOS, 6)                     AS                ORGANO_SUPERVISOR,
           --CASOS_MANUALES.SUCURSALID                                             AS CVE_SUCURSAL,
           '0'                                                                          AS                CVE_SUCURSAL,
           (SELECT DS_SUCURSAL
            FROM IFC.MTS_DSUCURSALES S
            WHERE S.SUCURSALID = CASOS_MANUALES.SUCURSALID)                                               DS_SUCURSAL,
           (SELECT CVE_LOCALIDAD
            FROM IFC.MTS_DSUCURSALES S
            WHERE S.SUCURSALID =
                  CASOS_MANUALES.SUCURSALID)                                                              CVE_LOCALIDAD_SUCURSAL,
           RIGHT('0' + LTRIM(RTRIM(CASOS_MANUALES.TIPOOPERACIONID)), 2)                 AS                CVE_TIPOOPERACION,
           (SELECT DS_TIPO_OPERACION
            FROM IFC.MTS_DTIPO_OPERACIONES
            WHERE TIPOOPERACIONID = CASOS_MANUALES.TIPOOPERACIONID)                                       DS_TIPO_OPERACION,
           --RIGHT('0' + LTRIM(RTRIM(CASOS_MANUALES.INSTRMONETARIOID)), 2) AS CVE_INSTRMONETARIO,
           right(('0' + LTRIM(RTRIM(CASE CASOS_MANUALES.INSTRMONETARIOID
                                        WHEN 11
                                            THEN '03'
                                        WHEN 12
                                            THEN '03'
                                        WHEN 13
                                            THEN '03'
                                        ELSE CASOS_MANUALES.INSTRMONETARIOID END))),
                 2)                                                                     AS                CVE_INSTRMONETARIO2,
           (SELECT DS_INST_MONETARIO
            FROM IFC.MTS_DINSTRUMENTO_MONETARIO
            WHERE INSTRMONETARIOID = CASOS_MANUALES.INSTRMONETARIOID)                                     DS_INST_MONETARIO,
           CASOS_MANUALES.NUMPOLIZACNTR_CASOS                                           AS                NUMPOLIZACNTR,
           REPLACE(CONVERT(VARCHAR(40), (CAST(CASOS_MANUALES.MONTOMNCNTR_CASOS AS MONEY)), 1), '.00', '') MONTOCNTR,
           CAST(CASOS_MANUALES.MONTOMNCNTR_CASOS AS DECIMAL(14, 2))                                       MONTO,
           CASOS_MANUALES.MONEDAID                                                      AS                CVE_MONEDA,
           (SELECT DS_MONEDA
            FROM IFC.MTS_DMONEDA
            WHERE MONEDAID = CASOS_MANUALES.MONEDAID)                                                     DS_MONEDA,
           CONVERT(CHAR, CASOS_MANUALES.FECHAOPERACIONCNTR_CASOS, 103)                  AS                FECHAOPERACIONCNTR,
           CONVERT(CHAR, CASOS_MANUALES.FECHAOPERACIONCNTR_CASOS, 112)                  AS                FECHA_OPERACION,
           NULL                                                                                           CONTRATANTEID,
           NULL                                                                                           CONTRATANTECD,
           CASOS_MANUALES.CONTRATANTE_CASOS                                             AS                NOMBRE,
           CASOS_MANUALES.CONTRATANTEPATERNO_CASOS                                      AS                APELLIDO_PATERNO,
           CASOS_MANUALES.CONTRATANTEMATERNO_CASOS                                      AS                APELLIDO_MATERNO,
           CASOS_MANUALES.RAZONSOCIALCNTR_CASOS                                         AS                RAZONSOCIAL,
           CASOS_MANUALES.TIPOPERSONAFISCALID,
           (SELECT TIPOPERSONAFISCAL
            FROM IFC.MTS_DTIPOPERSONAFISCAL
            WHERE TIPOPERSONAFISCALID = CASOS_MANUALES.TIPOPERSONAFISCALID)                               DS_TIPOPERSONAFISCAL,
           (SELECT NAC.NACIONALIDADID
            FROM IFC.MTS_DPAIS PA,
                 IFC.MTS_DNACIONALIDAD NAC
            WHERE PA.PAISID = NAC.PAISID
              AND NAC.NACIONALIDADID = CASOS_MANUALES.NACIONALIDADID)                                     CVE_NACIONALIDAD,
           (SELECT N.NACIONALIDAD
            FROM IFC.MTS_DNACIONALIDAD N
            WHERE N.NACIONALIDADID = CASOS_MANUALES.NACIONALIDADID)                                       DS_NACIONALIDAD,
           LTRIM(RTRIM(CASOS_MANUALES.CONTRATANTEDIRECCION_CASOS + ' ' + CASOS_MANUALES.NO_EXTERIOR + ' ' +
                       CASOS_MANUALES.CODIGO_POSTAL))                                   AS                DIRECCION,
           CASOS_MANUALES.CONTRATANTEDIRECCION_CASOS                                    AS                CALLE,
           CASOS_MANUALES.NO_EXTERIOR,
           CASOS_MANUALES.NO_INTERIOR,
           CASOS_MANUALES.CODIGO_POSTAL,
           CASOS_MANUALES.CONTRATANTETELEFONO_CASOS                                     AS                TELEFONO,
           CONVERT(CHAR, CASOS_MANUALES.CONTRATANTEEDADCONT, 103)                       AS                CONTRATANTEFECHANAC,
           CONVERT(CHAR, CASOS_MANUALES.CONTRATANTEEDADCONT, 103)                       AS                CONTRATANTEEDADCONT,
           (SELECT CASE
                       WHEN CASOS_MANUALES.TIPOPERSONAFISCALID = 1
                           THEN
                           CONVERT(CHAR, CASOS_MANUALES.CONTRATANTEFECHANAC_CASOS, 112)
                       ELSE CONVERT(CHAR, CASOS_MANUALES.CONTRATANTEFECHANAC_CASOS, 112)
                       END)                                                             AS                FECHA_NAC_CONT,
           CASOS_MANUALES.CONTRATANTECURP_CASOS                                         AS                CURP,
           CASOS_MANUALES.CONTRATANTERFC_CASOS                                          AS                RFC,
           CASOS_MANUALES.PAISID,
           (SELECT DS_PAIS
            FROM IFC.MTS_DPAIS
            WHERE PAISID = CASOS_MANUALES.PAISID)                                                         DS_PAIS_DOMICILIO,

           CASOS_MANUALES.ESTADOID,
           (CASE
                WHEN CASOS_MANUALES.ESTADOID is NULL THEN 1 --CASOS_MANUALES.DS_ESTADO se comenta para agregar la columna
                ELSE
                    (SELECT DISTINCT DS_D_ESTADO
                     FROM IFC.MTS_ADM_SEPOMEX SEPOMEX
                     WHERE SEPOMEX.CVE_C_ESTADO = RIGHT('0'+ LTRIM(RTRIM(CASOS_MANUALES.ESTADOID)),2)) END   )                     DS_ESTADO,
           CASOS_MANUALES.MUNICIPIOID,
           (CASE
                WHEN CASOS_MANUALES.MUNICIPIOID IS NULL THEN 1--CASOS_MANUALES.DS_MUNICIPIO se comenta para agregar la columna
                ELSE  (SELECT DISTINCT DS_D_MNPIO
                       FROM IFC.MTS_ADM_SEPOMEX SEPOMEX
                       WHERE  SEPOMEX.CVE_C_MNPIO = RIGHT('000'+ LTRIM(RTRIM(CASOS_MANUALES.MUNICIPIOID)),3)
                         AND SEPOMEX.CVE_C_ESTADO = RIGHT('00'+ LTRIM(RTRIM(CASOS_MANUALES.ESTADOID)),2))
               END)                          DS_MUNICIPIO,
           CASOS_MANUALES.COLONIAID,
           (CASE
                WHEN CASOS_MANUALES.COLONIAID IS NULL THEN 1 --CASOS_MANUALES.DS_COLONIA se comenta para agregar la columna
                ELSE (SELECT DISTINCT DS_D_ASENTA
                      FROM IFC.MTS_ADM_SEPOMEX SEPOMEX
                      WHERE SEPOMEX.CVE_ID_ASENTA_CPCONS = RIGHT('0000'+ LTRIM(RTRIM(CASOS_MANUALES.COLONIAID)),4)
                        AND SEPOMEX.CVE_C_MNPIO = RIGHT('000'+ LTRIM(RTRIM(CASOS_MANUALES.MUNICIPIOID)),3)
                        AND SEPOMEX.CVE_C_ESTADO = RIGHT('00'+ LTRIM(RTRIM(CASOS_MANUALES.ESTADOID)),2)) END)                          DES_COLONIA,
           CASOS_MANUALES.ACTIVIDADECOID                                                AS                CVE_ACTIVIDADECO,
           (SELECT DS_ACTIVIDADECO
            FROM IFC.MTS_DACTIVIDADECONOMICA
            WHERE ACTIVIDADECOID = CASOS_MANUALES.ACTIVIDADECOID)                                         DS_ACTIVIDADECO,
           (SELECT CASE
                       WHEN CASOS_MANUALES.CVE_LOCALIDAD IS NULL
                           THEN CASOS_MANUALES.MUNICIPIOID
                       ELSE CASOS_MANUALES.CVE_LOCALIDAD END)                           AS                CVE_LOCALIDAD,
           (SELECT DS_LOCALIDAD
            FROM IFC.MTS_CLOCALIDADES_CNBV
            WHERE CVE_LOCALIDAD = CASOS_MANUALES.CVE_LOCALIDAD)                                           DS_LOCALIDAD,
           CASOS_MANUALES.CIERREID,
           CASOS_MANUALES.CASOSID,
           NULL                                                                                           ESTATUS_OPERACION,
           CASOS_MANUALES.CVE_TIPO_ANALISIS,
           (SELECT VALOR_ATRIBUTO_01
            FROM IFC.MTS_ANA_DCATALOGOS_CLAVES
            WHERE CVE_TABLA = 'CAT_TIPO_ANALISIS'
              AND VIGENCIA = 'S'
              AND CLAVE_01 = CASOS_MANUALES.CVE_TIPO_ANALISIS)                                            DS_TIPO_ANALISIS,
           CONVERT(CHAR, CASOS_MANUALES.FECHADETECION_CASOS, 103)                       AS                FECHADETECION_CASOS,
           CONVERT(CHAR, CASOS_MANUALES.FECHADETECION_CASOS, 112)                       AS                FECHA_DETECCION,
           CASOS_MANUALES.AGENTENOMBRE_CASOS                                            AS                AGENTENOMBRE,
           CASOS_MANUALES.AGENTEPATERNO_CASOS                                           AS                AGENTEPATERNO,
           CASOS_MANUALES.AGENTEMATERNO_CASOS                                           AS                AGENTEMATERNO,
           CASOS_MANUALES.AGENTERFC_CASOS                                               AS                AGENTERFC,
           CASOS_MANUALES.AGENTECURP_CASOS                                              AS                AGENTECURP,
           CONVERT(VARCHAR(10), CASOS_MANUALES.CONSECNTAREL_CASOS)                      AS                CONSECNTAREL,
           CASOS_MANUALES.NUMPOLIZABENEF_CASOS                                          AS                NUMPOLIZABENEF,
           CASOS_MANUALES.ENTIDADFINIDBENEF_CASOS                                       AS                DS_ENTIDADFINIDBENEF,
           CASOS_MANUALES.BENEFICIARIO_CASOS                                            AS                BENEFICIARIOS,
           CASOS_MANUALES.BENEFICIARIOPATERNO_CASOS                                     AS                BENEFICIARIOPATERNO,
           CASOS_MANUALES.BENEFICIARIOMATERNO_CASOS                                     AS                BENEFICIARIOMATERNO,
           CASOS_MANUALES.DESOPERACION_CASOS                                            AS                DS_DESOPERACION,
           CASOS_MANUALES.RAZONOPERACION_CASOS                                          AS                RAZONOPERACION,
           CASOS_MANUALES.SW_CASO_MANUAL,
           CASOS_MANUALES.CVE_TIPOINUSUALIDAD,
           (CASE CASOS_MANUALES.CVE_TIPOINUSUALIDAD
                WHEN 'O'
                    THEN 'OPERATIVA'
                WHEN 'T'
                    THEN 'TRANSACCION'
                ELSE ' ' END)                                                           AS                DS_TIPOINUSUALIDAD,
           NULL                                                                                           OPERCNTRID,
           NULL                                                                                           CODOPER
    FROM IFC.MTS_ANA_HRN_CASOS_POLIZAS_AUD CASOS_MANUALES
    WHERE CASOS_MANUALES.CVE_TIPO_ANALISIS in ('TAINU')
go








/************************************************************************************************************************************************/
