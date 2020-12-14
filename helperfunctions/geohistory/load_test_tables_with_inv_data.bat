:: This script loads the random test tables to test translation against.

:: When test tables rightfully differ from original tables they have to be 
:: dumped with the dump_test_tables.bat script and pushed back in the source tree.

:: #################################### Set variables ######################################

SETLOCAL

CALL ..\..\conversion\bat\common.bat

IF "%pgversion%"=="" SET pgversion=11

SET coltypes="id=text,poly_id=int,isvalid=boolean,wkt_geometry=text,poly_type=text,ref_year=int,valid_year_begin=int,valid_year_end=int,valid_time=text"

:: ########################################## Process ######################################

:: Make schema if it doesn't exist

"%gdalFolder%/ogrinfo" %pg_connection_string% -sql "CREATE SCHEMA IF NOT EXISTS geohistory";

::Run ogr2ogr

"%gdalFolder%/ogr2ogr" -f "PostgreSQL" %pg_connection_string% "./testtables%pgversion%/sampling_area_nb1_history.csv" -nln "geohistory.sampling_area_nb1_history" %overwrite_tab% -lco COLUMN_TYPES=%coltypes%

"%gdalFolder%/ogrinfo" %pg_connection_string% -sql "ALTER TABLE geohistory.sampling_area_nb1_history DROP COLUMN ogc_fid"

"%gdalFolder%/ogr2ogr" -f "PostgreSQL" %pg_connection_string% "./testtables%pgversion%/sampling_area_nb2_history.csv" -nln "geohistory.sampling_area_nb2_history" %overwrite_tab% -lco COLUMN_TYPES=%coltypes%

"%gdalFolder%/ogrinfo" %pg_connection_string% -sql "ALTER TABLE geohistory.sampling_area_nb2_history DROP COLUMN ogc_fid"

"%gdalFolder%/ogr2ogr" -f "PostgreSQL" %pg_connection_string% "./testtables%pgversion%/sampling_area_nt1_history.csv" -nln "geohistory.sampling_area_nt1_history" %overwrite_tab% -lco COLUMN_TYPES=%coltypes%

"%gdalFolder%/ogrinfo" %pg_connection_string% -sql "ALTER TABLE geohistory.sampling_area_nt1_history DROP COLUMN ogc_fid"

"%gdalFolder%/ogr2ogr" -f "PostgreSQL" %pg_connection_string% "./testtables%pgversion%/sampling_area_nt2_history.csv" -nln "geohistory.sampling_area_nt2_history" %overwrite_tab% -lco COLUMN_TYPES=%coltypes%

"%gdalFolder%/ogrinfo" %pg_connection_string% -sql "ALTER TABLE geohistory.sampling_area_nt2_history DROP COLUMN ogc_fid"

"%gdalFolder%/ogr2ogr" -f "PostgreSQL" %pg_connection_string% "./testtables%pgversion%/sampling_area_bc1_history.csv" -nln "geohistory.sampling_area_bc1_history" %overwrite_tab% -lco COLUMN_TYPES=%coltypes%

"%gdalFolder%/ogrinfo" %pg_connection_string% -sql "ALTER TABLE geohistory.sampling_area_bc1_history DROP COLUMN ogc_fid"

"%gdalFolder%/ogr2ogr" -f "PostgreSQL" %pg_connection_string% "./testtables%pgversion%/sampling_area_bc2_history.csv" -nln "geohistory.sampling_area_bc2_history" %overwrite_tab% -lco COLUMN_TYPES=%coltypes%

"%gdalFolder%/ogrinfo" %pg_connection_string% -sql "ALTER TABLE geohistory.sampling_area_bc2_history DROP COLUMN ogc_fid"

ENDLOCAL