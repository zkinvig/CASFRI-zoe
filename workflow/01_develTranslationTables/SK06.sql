------------------------------------------------------------------------------
-- CASFRI - SK06 translation development script for CASFRI v5
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
CREATE SCHEMA IF NOT EXISTS translation_devel;

-- Check the uniqueness of SK species codes
CREATE UNIQUE INDEX ON translation.species_code_mapping (sk_species_codes)
WHERE TT_NotEmpty(sk_species_codes);

--SELECT TT_DeleteAllViews('rawfri');

-- CAS ATTRIBUTES
SELECT * FROM translation.sk_sfv01_cas;
DROP TABLE IF EXISTS translation_devel.sk06_sfv01_cas_devel;
CREATE TABLE translation_devel.sk06_sfv01_cas_devel AS
SELECT * FROM translation.sk_sfv01_cas; --WHERE rule_id::int = 1
SELECT * FROM translation_devel.sk06_sfv01_cas_devel;
SELECT TT_Prepare('translation_devel', 'sk06_sfv01_cas_devel', '_sk06_cas_devel');
SELECT TT_CreateMappingView('rawfri', 'sk06', 'sk_sfv', 200);
SELECT * FROM TT_Translate_sk06_cas_devel('rawfri', 'sk06_l1_to_sk_sfv_l1_map_200'); -- 5 s.

-- LYR1 ATTRIBUTES
SELECT * FROM translation.sk_sfv01_lyr;
DROP TABLE IF EXISTS translation_devel.sk06_sfv01_lyr_devel;
CREATE TABLE translation_devel.sk06_sfv01_lyr_devel AS
SELECT * FROM translation.sk_sfv01_lyr; --WHERE rule_id::int = 1
SELECT * FROM translation_devel.sk06_sfv01_lyr_devel;
SELECT TT_Prepare('translation_devel', 'sk06_sfv01_lyr_devel', '_sk06_lyr_devel');
SELECT TT_CreateMappingView('rawfri', 'sk06', 1, 'sk_sfv', 1, 200);
SELECT * FROM TT_Translate_sk06_lyr_devel('rawfri', 'sk06_l1_to_sk_sfv_l1_map_200'); -- 7 s.

-- LYR2 ATTRIBUTES
SELECT TT_CreateMappingView('rawfri', 'sk06', 2, 'sk_sfv', 1, 200);
SELECT * FROM TT_Translate_sk06_lyr_devel('rawfri', 'sk06_l2_to_sk_sfv_l1_map_200'); -- 7 s.

-- LYR3 ATTRIBUTES
SELECT TT_CreateMappingView('rawfri', 'sk06', 3, 'sk_sfv', 1, 200);
SELECT * FROM TT_Translate_sk06_lyr_devel('rawfri', 'sk06_l3_to_sk_sfv_l1_map_200'); -- 7 s.

-- DST ATTRIBUTES
SELECT * FROM translation.sk_sfv01_dst;
DROP TABLE IF EXISTS translation_devel.sk06_sfv01_dst_devel;
CREATE TABLE translation_devel.sk06_sfv01_dst_devel AS
SELECT * FROM translation.sk_sfv01_dst; --WHERE rule_id::int = 1
SELECT * FROM translation_devel.sk06_sfv01_dst_devel;
SELECT TT_Prepare('translation_devel', 'sk06_sfv01_dst_devel', '_sk06_dst_devel');
SELECT TT_CreateMappingView('rawfri', 'sk06', 1, 'sk_sfv', 1, 200);
SELECT * FROM TT_Translate_sk06_dst_devel('rawfri', 'sk06_l1_to_sk_sfv_l1_map_200'); -- 4 s.

-- NFL1 ATTRIBUTES
SELECT * FROM translation.sk_sfv01_nfl;
DROP TABLE IF EXISTS translation_devel.sk06_sfv01_nfl_devel;
CREATE TABLE translation_devel.sk06_sfv01_nfl_devel AS
SELECT * FROM translation.sk_sfv01_nfl; --WHERE rule_id::int = 1
SELECT * FROM translation_devel.sk06_sfv01_nfl_devel;
SELECT TT_Prepare('translation_devel', 'sk06_sfv01_nfl_devel', '_sk06_nfl_devel');
SELECT TT_CreateMappingView('rawfri', 'sk06', 4, 'sk_sfv', 1, 200);
SELECT * FROM TT_Translate_sk06_nfl_devel('rawfri', 'sk06_l4_to_sk_sfv_l1_map_200'); -- 3 s.

-- NFL2 ATTRIBUTES
SELECT TT_CreateMappingView('rawfri', 'sk06', 5, 'sk_sfv', 1, 200);
SELECT * FROM TT_Translate_sk06_nfl_devel('rawfri', 'sk06_l5_to_sk_sfv_l1_map_200'); -- 7 s.

-- NFL3 ATTRIBUTES - layer 6 can either be nat_non_veg or non_for_anth, not both.
SELECT TT_CreateMappingView('rawfri', 'sk06', 6, 'sk_sfv', 1, 200);
SELECT * FROM TT_Translate_sk06_nfl_devel('rawfri', 'sk06_l6_to_sk_sfv_l1_map_200'); -- 7 s.
SELECT count(*), sp1_h, sp1_s, CONCAT(sp1_h, sp1_s) FROM rawfri.sk06 GROUP BY sp1_h, sp1_s;

-- Display original values and translated values side-by-side to compare and debug the translation table
SELECT a.cas_id, b.nvsl, b.aquatic_class, b.luc, b.transp_class, b.shrub1, b.herb1, a.nat_non_veg, a.non_for_anth, a.non_for_veg
FROM TT_Translate_sk06_nfl_devel('rawfri', 'sk02_l1_to_sk_sfv_l1_map_200') a, rawfri.sk06_l1_to_sk_sfv_l1_map_200 b
WHERE b.ogc_fid::int = right(a.cas_id, 7)::int;

-- ECO ATTRIBUTES
SELECT * FROM translation.sk_sfv01_eco;
DROP TABLE IF EXISTS translation_devel.sk06_sfv01_eco_devel;
CREATE TABLE translation_devel.sk06_sfv01_eco_devel AS
SELECT * FROM translation.sk_sfv01_eco; --WHERE rule_id::int = 1
SELECT * FROM translation_devel.sk06_sfv01_eco_devel;
SELECT TT_Prepare('translation_devel', 'sk06_sfv01_eco_devel', '_sk06_eco_devel');
SELECT TT_CreateMappingView('rawfri', 'sk06', 'sk_sfv', 200);
SELECT * FROM TT_Translate_sk06_eco_devel('rawfri', 'sk06_l1_to_sk_sfv_l1_map_200');


-- GEO ATTRIBUTES
SELECT * FROM translation.sk_sfv01_geo;
DROP TABLE IF EXISTS translation_devel.sk06_sfv01_geo_devel;
CREATE TABLE translation_devel.sk06_sfv01_geo_devel AS
SELECT * FROM translation.sk_sfv01_geo; --WHERE rule_id::int = 1
SELECT * FROM translation_devel.sk06_sfv01_geo_devel;
SELECT TT_Prepare('translation_devel', 'sk06_sfv01_geo_devel', '_sk06_geo_devel');
SELECT TT_CreateMappingView('rawfri', 'sk06', 'sk_sfv', 200);
SELECT * FROM TT_Translate_sk06_geo_devel('rawfri', 'sk06_l1_to_sk_sfv_l1_map_200'); -- 2 s.


-- Display original values and translated values side-by-side to compare and debug the translation table
SELECT b.src_filename, b.inventory_id, b.poly_id, b.ogc_fid, a.cas_id, 
       b.l1_crown_closure, a.crown_closure_lower, a.crown_closure_upper, 
       b.l1_height, a.height_upper, a.height_lower, 
       b.l1_sp1, a.species_1,
       b.l1_sp1_cover, a.species_per_1
FROM TT_Translate_sk06_lyr_devel('rawfri', 'sk06_l1_to_sk_sfv_l1_map_200') a, rawfri.sk06_l1_to_sk_sfv_l1_map_200 b
WHERE b.ogc_fid::int = right(a.cas_id, 7)::int;

--------------------------------------------------------------------------
SELECT TT_DeleteAllLogs('translation_devel');
