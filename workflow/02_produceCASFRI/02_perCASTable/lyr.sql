------------------------------------------------------------------------------
-- CASFRI Sample workflow file for CASFRI v5 beta
-- For use with PostgreSQL Table Tranlation Engine v0.1 for PostgreSQL 9.x
-- https://github.com/edwardsmarc/postTranslationEngine
-- https://github.com/edwardsmarc/casfri
--
-- This is free software; you can redistribute and/or modify it under
-- the terms of the GNU General Public Licence. See the COPYING file.
--
-- Copyright (C) 2018-2020 Pierre Racine <pierre.racine@sbf.ulaval.ca>, 
--                         Marc Edwards <medwards219@gmail.com>,
--                         Pierre Vernier <pierre.vernier@gmail.com>
-------------------------------------------------------------------------------
-- No not display debug messages.
SET tt.debug TO TRUE;
SET tt.debug TO FALSE;

CREATE SCHEMA IF NOT EXISTS casfri50;

-------------------------------------------------------
-- Check the uniqueness of all species codes
-------------------------------------------------------
CREATE UNIQUE INDEX ON translation.species_code_mapping (ab_species_codes)
WHERE TT_NotEmpty(ab_species_codes);

CREATE UNIQUE INDEX ON translation.species_code_mapping (bc_species_codes)
WHERE TT_NotEmpty(bc_species_codes);

CREATE UNIQUE INDEX ON translation.species_code_mapping (nb_species_codes)
WHERE TT_NotEmpty(nb_species_codes);

CREATE UNIQUE INDEX ON translation.species_code_mapping (nt_species_codes)
WHERE TT_NotEmpty(nt_species_codes);

CREATE UNIQUE INDEX ON translation.species_code_mapping (on_species_codes)
WHERE TT_NotEmpty(on_species_codes);

CREATE UNIQUE INDEX ON translation.species_code_mapping (sk_species_codes)
WHERE TT_NotEmpty(sk_species_codes);

CREATE UNIQUE INDEX ON translation.species_code_mapping (yt_species_codes)
WHERE TT_NotEmpty(yt_species_codes);

-------------------------------------------------------
-- Translate all LYR tables into a common table. 32h
-------------------------------------------------------
-- Prepare the translation functions
SELECT TT_Prepare('translation', 'ab_avi01_lyr', '_ab_lyr'); -- used for both AB16 and NB02AB06 layer 1 and 2
SELECT TT_Prepare('translation', 'nb_nbi01_lyr', '_nb_lyr', 'ab_avi01_lyr'); -- used for both NB01 and NB02, layer 1 and 2
SELECT TT_Prepare('translation', 'bc_vri01_lyr', '_bc_lyr', 'ab_avi01_lyr'); -- used for both BC08 and BC10, layer 1 and 2
SELECT TT_Prepare('translation', 'nt_fvi01_lyr', '_nt_lyr', 'ab_avi01_lyr'); -- used for both NT01 and NT02, layer 1 and 2
SELECT TT_Prepare('translation', 'on_fim02_lyr', '_on_lyr', 'ab_avi01_lyr'); 
SELECT TT_Prepare('translation', 'sk_utm01_lyr', '_sk_lyr', 'ab_avi01_lyr'); 
SELECT TT_Prepare('translation', 'yt_yvi01_lyr', '_yt_lyr', 'ab_avi01_lyr'); 
-------------------------
DROP TABLE IF EXISTS casfri50.lyr_all CASCADE;
------------------------
-- Translate AB06 layer 1
BEGIN;
SELECT TT_CreateMappingView('rawfri', 'ab06', 1, 'ab', 1, NULL, 'lyr');

CREATE TABLE casfri50.lyr_all AS -- 4m41s
SELECT * FROM TT_Translate_ab_lyr('rawfri', 'ab06_l1_to_ab_l1_map_lyr', 'ogc_fid');
COMMIT;

SELECT * FROM TT_ShowLastLog('translation', 'ab_avi01_lyr');
------------------------
-- Translate AB06 layer 2 reusing AB06 layer 1 translation table
BEGIN;
SELECT TT_CreateMappingView('rawfri', 'ab06', 2, 'ab', 1, NULL, 'lyr');

INSERT INTO casfri50.lyr_all -- 3m56s
SELECT * FROM TT_Translate_ab_lyr('rawfri', 'ab06_l2_to_ab_l1_map_lyr', 'ogc_fid');
COMMIT;

SELECT * FROM TT_ShowLastLog('translation', 'ab_avi01_lyr');
------------------------
-- Translate AB16 layer 1
BEGIN;
SELECT TT_CreateMappingView('rawfri', 'ab16', 1, 'ab', 1, NULL, 'lyr');

INSERT INTO casfri50.lyr_all -- 46m20s
SELECT * FROM TT_Translate_ab_lyr('rawfri', 'ab16_l1_to_ab_l1_map_lyr', 'ogc_fid');
COMMIT;

SELECT * FROM TT_ShowLastLog('translation', 'ab_avi01_lyr');
------------------------
-- Translate AB16 layer 2 reusing AB16 layer 1 translation table and only rows having LYR attributes
BEGIN;
SELECT TT_CreateMappingView('rawfri', 'ab16', 2, 'ab', 1, NULL, 'lyr');

INSERT INTO casfri50.lyr_all -- 3m56s
SELECT * FROM TT_Translate_ab_lyr('rawfri', 'ab16_l2_to_ab_l1_map_lyr', 'ogc_fid');
COMMIT;

SELECT * FROM TT_ShowLastLog('translation', 'ab_avi01_lyr');
------------------------
-- Translate NB01 using NB generic translation table and only rows with LYR attributes
BEGIN;
SELECT TT_CreateMappingView('rawfri', 'nb01', 1, 'nb', 1, NULL, 'lyr');

INSERT INTO casfri50.lyr_all -- 5h32m
SELECT * FROM TT_Translate_nb_lyr('rawfri', 'nb01_l1_to_nb_l1_map_lyr', 'ogc_fid');
COMMIT;

SELECT * FROM TT_ShowLastLog('translation', 'nb_nbi01_lyr');
------------------------
-- Translate NB01 layer 2 using NB layer 1 generic translation table and only rows having LYR attributes
BEGIN;
SELECT TT_CreateMappingView('rawfri', 'nb01', 2, 'nb', 1, NULL, 'lyr');

INSERT INTO casfri50.lyr_all -- 
SELECT * FROM TT_Translate_nb_lyr('rawfri', 'nb01_l2_to_nb_l1_map_lyr', 'ogc_fid');
COMMIT;

SELECT * FROM TT_ShowLastLog('translation', 'nb_nbi01_lyr');
------------------------
-- Translate NB02 using NB generic translation table and only rows having LYR attributes
BEGIN;
SELECT TT_CreateMappingView('rawfri', 'nb02', 1, 'nb', 1, NULL, 'lyr');

INSERT INTO casfri50.lyr_all -- 
SELECT * FROM TT_Translate_nb_lyr('rawfri', 'nb02_l1_to_nb_l1_map_lyr', 'ogc_fid');
COMMIT;

SELECT * FROM TT_ShowLastLog('translation', 'nb_nbi01_lyr');
------------------------
-- Translate NB02 layer 2 reusing NB01 layer 1 translation table
BEGIN;
SELECT TT_CreateMappingView('rawfri', 'nb02', 2, 'nb', 1, NULL, 'lyr');

INSERT INTO casfri50.lyr_all -- 
SELECT * FROM TT_Translate_nb_lyr('rawfri', 'nb02_l2_to_nb_l1_map_lyr', 'ogc_fid');
COMMIT;

SELECT * FROM TT_ShowLastLog('translation', 'nb_nbi01_lyr');
------------------------
-- Translate BC08
BEGIN;
SELECT TT_CreateMappingView('rawfri', 'bc08', 1, 'bc', 1, NULL, 'lyr');

INSERT INTO casfri50.lyr_all -- 30h19m
SELECT * FROM TT_Translate_bc_lyr('rawfri', 'bc08_l1_to_bc_l1_map_lyr', 'ogc_fid');
COMMIT;

SELECT * FROM TT_ShowLastLog('translation', 'bc_vri01_lyr');
------------------------
-- Translate BC10 layer 1
BEGIN;
SELECT TT_CreateMappingView('rawfri', 'bc10', 1, 'bc', 1, NULL, 'lyr');

INSERT INTO casfri50.lyr_all -- *m**s
SELECT * FROM TT_Translate_bc_lyr('rawfri', 'bc10_l1_to_bc_l1_map_lyr', 'ogc_fid');
COMMIT;

SELECT * FROM TT_ShowLastLog('translation', 'bc_vri01_lyr');
------------------------
-- Translate BC10 layer 2 reusing BC10 layer 1 translation table
BEGIN;
SELECT TT_CreateMappingView('rawfri', 'bc10', 2, 'bc', 1, NULL, 'lyr');

INSERT INTO casfri50.lyr_all -- *m**s
SELECT * FROM TT_Translate_bc_lyr('rawfri', 'bc10_l2_to_bc_l1_map_lyr', 'ogc_fid');
COMMIT;

SELECT * FROM TT_ShowLastLog('translation', 'bc_vri01_lyr');
------------------------
-- Translate NT01 using NT generic translation table
BEGIN;
SELECT TT_CreateMappingView('rawfri', 'nt01', 1, 'nt', 1, NULL, 'lyr');

INSERT INTO casfri50.lyr_all -- 1h49m
SELECT * FROM TT_Translate_nt_lyr('rawfri', 'nt01_l1_to_nt_l1_map_lyr', 'ogc_fid');
COMMIT;

SELECT * FROM TT_ShowLastLog('translation', 'nt_fvi01_lyr');
------------------------
-- Translate NT01 layer 2 using NT layer 1 generic translation table
BEGIN;
SELECT TT_CreateMappingView('rawfri', 'nt01', 2, 'nt', 1, NULL, 'lyr');

INSERT INTO casfri50.lyr_all -- 1h24m
SELECT * FROM TT_Translate_nt_lyr('rawfri', 'nt01_l2_to_nt_l1_map_lyr', 'ogc_fid');
COMMIT;

SELECT * FROM TT_ShowLastLog('translation', 'nt_fvi01_lyr');
------------------------
-- Translate NT02 using NT generic translation table
BEGIN;
SELECT TT_CreateMappingView('rawfri', 'nt02', 1, 'nt', 1, NULL, 'lyr');

INSERT INTO casfri50.lyr_all -- 1h45m
SELECT * FROM TT_Translate_nt_lyr('rawfri', 'nt02_l1_to_nt_l1_map_lyr', 'ogc_fid');
COMMIT;

SELECT * FROM TT_ShowLastLog('translation', 'nt_fvi01_lyr');
------------------------
-- Translate NT02 layer 2 using NT layer 1 generic translation table
BEGIN;
SELECT TT_CreateMappingView('rawfri', 'nt02', 2, 'nt', 1, NULL, 'lyr');

INSERT INTO casfri50.lyr_all -- 1h34m
SELECT * FROM TT_Translate_nt_lyr('rawfri', 'nt02_l2_to_nt_l1_map_lyr', 'ogc_fid');
COMMIT;

SELECT * FROM TT_ShowLastLog('translation', 'nt_fvi01_lyr');
------------------------
-- Translate ON02 using ON translation table
BEGIN;
SELECT TT_CreateMappingView('rawfri', 'on02', 1, 'on', 1, NULL, 'lyr');

INSERT INTO casfri50.lyr_all -- 
SELECT * FROM TT_Translate_on_lyr('rawfri', 'on02_l1_to_on_l1_map_lyr', 'ogc_fid');
COMMIT;

SELECT * FROM TT_ShowLastLog('translation', 'on_fim02_lyr');
------------------------
-- Translate ON02 layer 2 using ON translation table
BEGIN;
SELECT TT_CreateMappingView('rawfri', 'on02', 2, 'on', 1, NULL, 'lyr');

INSERT INTO casfri50.lyr_all -- 
SELECT * FROM TT_Translate_on_lyr('rawfri', 'on02_l2_to_on_l1_map_lyr', 'ogc_fid');
COMMIT;

SELECT * FROM TT_ShowLastLog('translation', 'on_fim02_lyr');
------------------------
-- Translate SK01 using UTM translation table
BEGIN;
SELECT TT_CreateMappingView('rawfri', 'sk01', 1, 'sk_utm', 1, NULL, 'lyr');

INSERT INTO casfri50.lyr_all -- 
SELECT * FROM TT_Translate_sk_lyr('rawfri', 'sk01_l1_to_sk_utm_l1_map_lyr', 'ogc_fid');
COMMIT;

SELECT * FROM TT_ShowLastLog('translation', 'sk_utm01_lyr');
------------------------
-- Translate SK01 layer 2 using UTM translation table
BEGIN;
SELECT TT_CreateMappingView('rawfri', 'sk01', 2, 'sk_utm', 1, NULL, 'lyr');

INSERT INTO casfri50.lyr_all -- 
SELECT * FROM TT_Translate_sk_lyr('rawfri', 'sk01_l2_to_sk_utm_l1_map_lyr', 'ogc_fid');
COMMIT;

SELECT * FROM TT_ShowLastLog('translation', 'sk_utm01_lyr');
------------------------
-- Translate YT02 using YVI translation table
BEGIN;
SELECT TT_CreateMappingView('rawfri', 'yt02', 1, 'yt', 1);

INSERT INTO casfri50.lyr_all -- 
SELECT * FROM TT_Translate_yt_lyr('rawfri', 'yt02_l1_to_yt_l1_map', 'ogc_fid');
COMMIT;

SELECT * FROM TT_ShowLastLog('translation', 'yt_yvi01_lyr');
--------------------------------------------------------------------------
-- Check processed inventories and count
--------------------------------------------------------------------------
SELECT left(cas_id, 4) inv, count(*) nb 
FROM casfri50.lyr_all
GROUP BY left(cas_id, 4);
-- inv  nb
-- AB06	14179
-- AB16	149674
-- BC08	4113383
-- BC10	4744673
-- NB01	932271
-- NB02	1053554
-- NT01	246179
-- NT02	350967
-- ON02	2240815
-- SK01	1692982
-- YT02	105102

SELECT left(cas_id, 4) inv, layer, count(*) nb
FROM casfri50.lyr_all
GROUP BY left(cas_id, 4), layer;
-- inv lyr nb
-- AB06	1	9403
-- AB06	2	4776
-- AB16	1	104945
-- AB16	2	44729
-- BC08	1	4113383
-- BC10	1	4570063
-- BC10	2	174610
-- NB01	1	767392
-- NB01	2	164879
-- NB02	1	870925
-- NB02	2	182629
-- NT01	1	236939
-- NT01	2	9240
-- NT02	1	266159
-- NT02	2	84808
-- ON02	1	2066888
-- ON02	2	173927
-- SK01	1	1679088
-- SK01	2	13894
-- YT02	1	105102

SELECT count(*) FROM casfri50.lyr_all; -- 15643779
--------------------------------------------------------------------------
-- Add some indexes
CREATE INDEX lyr_all_casid_idx
ON casfri50.lyr_all USING btree(cas_id);

CREATE INDEX lyr_all_inventory_idx
ON casfri50.lyr_all USING btree(left(cas_id, 4));
    
CREATE INDEX lyr_all_province_idx
ON casfri50.lyr_all USING btree(left(cas_id, 2));
--------------------------------------------------------------------------
