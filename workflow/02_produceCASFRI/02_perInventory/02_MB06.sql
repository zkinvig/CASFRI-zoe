------------------------------------------------------------------------------
-- CASFRI - MB06 translation script for CASFRI v5
-- For use with PostgreSQL Table Tranlation Framework v2.0.1 for PostgreSQL 13.x
-- https://github.com/CASFRI/PostgreSQL-Table-Translation-Framework
-- https://github.com/CASFRI/CASFRI
--
-- This is free software; you can redistribute and/or modify it under
-- the terms of the GNU General Public Licence. See the COPYING file.
--
-- Copyright (C) 2018-2021 Pierre Racine <pierre.racine@sbf.ulaval.ca>, 
--                         Marc Edwards <medwards219@gmail.com>,
--                         Pierre Vernier <pierre.vernier@gmail.com>
--                         Melina Houle <melina.houle@sbf.ulaval.ca>
-------------------------------------------------------------------------------
-- No not display debug messages.
SET tt.debug TO TRUE;
SET tt.debug TO FALSE;
--------------------------------------------------------------------------
-- Translate all MB06. XXhXXm
--------------------------------------------------------------------------
-- CAS
------------------------
SELECT TT_Prepare('translation', 'mb_fli01_cas', '_mb06_cas', 'ab_avi01_cas');

SELECT TT_CreateMappingView('rawfri', 'mb06', 'mb_fli');

-- Delete existing entries
-- DELETE FROM casfri50.cas_all WHERE left(cas_id, 4) = 'MB06';

-- Add translated ones
INSERT INTO casfri50.cas_all -- 
SELECT * FROM TT_Translate_mb06_cas('rawfri', 'mb06_l1_to_mb_fli_l1_map');


------------------------
-- DST
------------------------
SELECT TT_Prepare('translation', 'mb_fli01_dst', '_mb06_dst', 'ab_avi01_dst');

SELECT TT_CreateMappingView('rawfri', 'mb06', 'mb_fli');

-- Delete existing entries
-- DELETE FROM casfri50.dst_all WHERE left(cas_id, 4) = 'MB06';

-- Add translated ones
INSERT INTO casfri50.dst_all -- 
SELECT * FROM TT_Translate_mb06_dst('rawfri', 'mb06_l1_to_mb_fli_l1_map');


------------------------
-- ECO
------------------------
SELECT TT_Prepare('translation', 'mb_fli01_eco', '_mb06_eco', 'ab_avi01_eco');

SELECT TT_CreateMappingView('rawfri', 'mb06', 'mb_fli');

-- Delete existing entries
-- DELETE FROM casfri50.eco_all WHERE left(cas_id, 4) = 'MB06';

-- Add translated ones
INSERT INTO casfri50.eco_all -- 
SELECT * FROM TT_Translate_mb06_eco('rawfri', 'mb06_l1_to_mb_fli_l1_map');


------------------------
-- LYR
------------------------
-- Check the uniqueness of MB species codes
CREATE UNIQUE INDEX IF NOT EXISTS species_code_mapping_mb06_species_codes_idx
ON translation.species_code_mapping (mb_species_codes)
WHERE TT_NotEmpty(mb_species_codes);

-- Prepare the translation function
SELECT TT_Prepare('translation', 'mb_fli01_lyr', '_mb06_lyr', 'ab_avi01_lyr'); 

-- Delete existing entries
-- DELETE FROM casfri50.lyr_all WHERE left(cas_id, 4) = 'MB06';

-- Add translated ones
-- Layer 1
SELECT TT_CreateMappingView('rawfri', 'mb06', 1, 'mb_fli', 1);

INSERT INTO casfri50.lyr_all -- 
SELECT * FROM TT_Translate_mb06_lyr('rawfri', 'mb06_l1_to_mb_fli_l1_map');


-- Layer 2
SELECT TT_CreateMappingView('rawfri', 'mb06', 2, 'mb_fli', 1);

INSERT INTO casfri50.lyr_all -- 
SELECT * FROM TT_Translate_mb06_lyr('rawfri', 'mb06_l2_to_mb_fli_l1_map');


-- Layer 3
SELECT TT_CreateMappingView('rawfri', 'mb06', 3, 'mb_fli', 1);

INSERT INTO casfri50.lyr_all -- 
SELECT * FROM TT_Translate_mb06_lyr('rawfri', 'mb06_l3_to_mb_fli_l1_map');


-- Layer 4
SELECT TT_CreateMappingView('rawfri', 'mb06', 4, 'mb_fli', 1);

INSERT INTO casfri50.lyr_all -- 
SELECT * FROM TT_Translate_mb06_lyr('rawfri', 'mb06_l4_to_mb_fli_l1_map');


-- Layer 5
SELECT TT_CreateMappingView('rawfri', 'mb06', 5, 'mb_fli', 1);

INSERT INTO casfri50.lyr_all -- 
SELECT * FROM TT_Translate_mb06_lyr('rawfri', 'mb06_l5_to_mb_fli_l1_map');


------------------------
-- NFL
------------------------
SELECT TT_Prepare('translation', 'mb_fli01_nfl', '_mb06_nfl', 'ab_avi01_nfl');

-- Delete existing entries
-- DELETE FROM casfri50.nfl_all WHERE left(cas_id, 4) = 'MB06';

-- Add translated NFL
SELECT TT_CreateMappingView('rawfri', 'mb06', 6, 'mb_fli', 1);

INSERT INTO casfri50.nfl_all -- 
SELECT * FROM TT_Translate_mb06_nfl('rawfri', 'mb06_l6_to_mb_fli_l1_map');


------------------------
-- GEO
------------------------
SELECT TT_Prepare('translation', 'mb_fli01_geo', '_mb06_geo', 'ab_avi01_geo');

SELECT TT_CreateMappingView('rawfri', 'mb06', 'mb_fli');

-- Delete existing entries
-- DELETE FROM casfri50.geo_all WHERE left(cas_id, 4) = 'MB06';

-- Add translated ones
INSERT INTO casfri50.geo_all -- 
SELECT * FROM TT_Translate_mb06_geo('rawfri', 'mb06_l1_to_mb_fli_l1_map');

--------------------------------------------------------------------------
-- Check
/*
SELECT 'cas_all' AS table, count(*) nb
FROM casfri50.cas_all
WHERE left(cas_id, 4) = 'MB06'
UNION ALL
SELECT 'dst_all', count(*) nb
FROM casfri50.dst_all
WHERE left(cas_id, 4) = 'MB06'
UNION ALL
SELECT 'eco_all', count(*) nb
FROM casfri50.eco_all
WHERE left(cas_id, 4) = 'MB06'
UNION ALL
SELECT 'lyr_all', count(*) nb
FROM casfri50.lyr_all
WHERE left(cas_id, 4) = 'MB06'
UNION ALL
SELECT 'nfl_all', count(*) nb
FROM casfri50.nfl_all
WHERE left(cas_id, 4) = 'MB06'
UNION ALL
SELECT 'geo_all', count(*) nb
FROM casfri50.geo_all
WHERE left(cas_id, 4) = 'MB06';
*/
--------------------------------------------------------------------------
