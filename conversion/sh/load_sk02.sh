#!/bin/bash -x

# This script loads the SK SFVI Government Forest Island dataset (SK02) into PostgreSQL

# The format of the source dataset is a geodatabase
# Source data is split into a STAND feature class of polygons, and the following tables
# of attributes: DISTURBANCES, FEATURE_METADATA, HERBS, LAYER_1, LAYER_2, LAYER_3, SHRUBS,
# WETLAND.

# These tables need to be joined into a single source table in the database. All columns
# are unique. Polygons with type = OTH and no entries for all of SMR, LUC and TRANSP_CLASS
# are empty polygons forming the bounding extent of the dataset. These should be removed.

# The year of photography is included in the attribute FEATURE_SOURCE_DATE

# Load into a target table in the schema defined in the config file.

# If the table already exists, it can be overwritten by setting the "overwriteFRI" variable 
# in the configuration file.

######################################## Set variables #######################################

source ./common.sh

inventoryID=SK02
srcFileName=SFVI_Island_Forest
fullTargetTableName=$targetFRISchema.sk02

gdbFileName_poly=STAND
gdbFileName_meta=FEATURE_METADATA
gdbFileName_dist=DISTURBANCES
gdbFileName_herbs=HERBS
gdbFileName_l1=LAYER_1
gdbFileName_l2=LAYER_2
gdbFileName_l3=LAYER_3
gdbFileName_shrubs=SHRUBS
gdbFileName_wetland=WETLAND

TableName_poly=${fullTargetTableName}_poly
TableName_meta=${fullTargetTableName}_meta
TableName_dist=${fullTargetTableName}_dist
TableName_herbs=${fullTargetTableName}_herbs
TableName_l1=${fullTargetTableName}_l1
TableName_l2=${fullTargetTableName}_l2
TableName_l3=${fullTargetTableName}_l3
TableName_shrubs=${fullTargetTableName}_shrubs
TableName_wetland=${fullTargetTableName}_wetland

srcFullPath="$friDir/SK/$inventoryID/data/inventory/$srcFileName.gdb"

########################################## Process ######################################

# Run ogr2ogr for polygons, don't load non-FRI polygons
"$gdalFolder/ogr2ogr" \
-f "PostgreSQL" "$pg_connection_string" "$srcFullPath" "$gdbFileName_poly" \
-nln $TableName_poly $layer_creation_option \
-sql "SELECT *, '$srcFileName' AS src_filename, '$inventoryID' AS inventory_id FROM '$gdbFileName_poly' \
        WHERE NOT(TYPE = 'OTH' AND SMR = ' ' AND LUC = ' ' AND TRANSP_CLASS = ' ')" \
-progress $overwrite_tab

# Run ogr2ogr for meta data
"$gdalFolder/ogr2ogr" \
-f "PostgreSQL" "$pg_connection_string" "$srcFullPath" "$gdbFileName_meta" \
-nln $TableName_meta $layer_creation_option \
-sql "SELECT *, poly_id AS poly_id_meta FROM '$gdbFileName_meta'" \
-progress $overwrite_tab

# Run ogr2ogr for dist data
"$gdalFolder/ogr2ogr" \
-f "PostgreSQL" "$pg_connection_string" "$srcFullPath" "$gdbFileName_dist" \
-nln $TableName_dist $layer_creation_option \
-sql "SELECT *, poly_id AS poly_id_dist FROM '$gdbFileName_dist'" \
-progress $overwrite_tab

# Run ogr2ogr for herbs data
"$gdalFolder/ogr2ogr" \
-f "PostgreSQL" "$pg_connection_string" "$srcFullPath" "$gdbFileName_herbs" \
-nln $TableName_herbs $layer_creation_option \
-sql "SELECT *, poly_id AS poly_id_herbs FROM '$gdbFileName_herbs'" \
-progress $overwrite_tab

# Run ogr2ogr for layer 1 data
"$gdalFolder/ogr2ogr" \
-f "PostgreSQL" "$pg_connection_string" "$srcFullPath" "$gdbFileName_l1" \
-nln $TableName_l1 $layer_creation_option \
-sql "SELECT *, poly_id AS poly_id_l1 FROM '$gdbFileName_l1'" \
-progress $overwrite_tab

# Run ogr2ogr for layer 2 data
"$gdalFolder/ogr2ogr" \
-f "PostgreSQL" "$pg_connection_string" "$srcFullPath" "$gdbFileName_l2" \
-nln $TableName_l2 $layer_creation_option \
-sql "SELECT *, poly_id AS poly_id_l2 FROM '$gdbFileName_l2'" \
-progress $overwrite_tab

# Run ogr2ogr for layer 3 data
"$gdalFolder/ogr2ogr" \
-f "PostgreSQL" "$pg_connection_string" "$srcFullPath" "$gdbFileName_l3" \
-nln $TableName_l3 $layer_creation_option \
-sql "SELECT *, poly_id AS poly_id_l3 FROM '$gdbFileName_l3'" \
-progress $overwrite_tab

# Run ogr2ogr for shrubs data
"$gdalFolder/ogr2ogr" \
-f "PostgreSQL" "$pg_connection_string" "$srcFullPath" "$gdbFileName_shrubs" \
-nln $TableName_shrubs $layer_creation_option \
-sql "SELECT *, poly_id AS poly_id_shrubs FROM '$gdbFileName_shrubs'" \
-progress $overwrite_tab

# Run ogr2ogr for wetland data
"$gdalFolder/ogr2ogr" \
-f "PostgreSQL" "$pg_connection_string" "$srcFullPath" "$gdbFileName_wetland" \
-nln $TableName_wetland $layer_creation_option \
-sql "SELECT *, poly_id AS poly_id_wetland FROM '$gdbFileName_wetland'" \
-progress $overwrite_tab


# Join all attribute tables to polygons.
# The ogc_fid attribute is dropped from all but the poly table. 
# Original tables are deleted at the end.
"$gdalFolder/ogrinfo" "$pg_connection_string" \
-sql "
-- delete ogc and poly_id, joins don't work with matching names
ALTER TABLE $TableName_meta DROP COLUMN IF EXISTS ogc_fid, DROP COLUMN IF EXISTS poly_id;
ALTER TABLE $TableName_dist DROP COLUMN IF EXISTS ogc_fid, DROP COLUMN IF EXISTS poly_id;
ALTER TABLE $TableName_herbs DROP COLUMN IF EXISTS ogc_fid, DROP COLUMN IF EXISTS poly_id;
ALTER TABLE $TableName_l1 DROP COLUMN IF EXISTS ogc_fid, DROP COLUMN IF EXISTS poly_id;
ALTER TABLE $TableName_l2 DROP COLUMN IF EXISTS ogc_fid, DROP COLUMN IF EXISTS poly_id;
ALTER TABLE $TableName_l3 DROP COLUMN IF EXISTS ogc_fid, DROP COLUMN IF EXISTS poly_id;
ALTER TABLE $TableName_shrubs DROP COLUMN IF EXISTS ogc_fid, DROP COLUMN IF EXISTS poly_id;
ALTER TABLE $TableName_wetland DROP COLUMN IF EXISTS ogc_fid, DROP COLUMN IF EXISTS poly_id;

-- join
DROP TABLE IF EXISTS $fullTargetTableName; 
CREATE TABLE $fullTargetTableName AS
SELECT *
    FROM $TableName_poly A 
    LEFT JOIN $TableName_meta B ON A.poly_id = B.poly_id_meta
    LEFT JOIN $TableName_dist C ON A.poly_id = C.poly_id_dist
	LEFT JOIN $TableName_herbs D ON A.poly_id = D.poly_id_herbs
	LEFT JOIN $TableName_l1 E ON A.poly_id = E.poly_id_l1
	LEFT JOIN $TableName_l2 F ON A.poly_id = F.poly_id_l2
	LEFT JOIN $TableName_l3 G ON A.poly_id = G.poly_id_l3
	LEFT JOIN $TableName_shrubs H ON A.poly_id = H.poly_id_shrubs
	LEFT JOIN $TableName_wetland I ON A.poly_id = I.poly_id_wetland;

--drop tables
DROP TABLE IF EXISTS $TableName_poly;
DROP TABLE IF EXISTS $TableName_meta;
DROP TABLE IF EXISTS $TableName_dist; 
DROP TABLE IF EXISTS $TableName_herbs;
DROP TABLE IF EXISTS $TableName_l1;
DROP TABLE IF EXISTS $TableName_l2;
DROP TABLE IF EXISTS $TableName_l3;
DROP TABLE IF EXISTS $TableName_shrubs;
DROP TABLE IF EXISTS $TableName_wetland;

-- drop duplicate poly_ids
ALTER TABLE $fullTargetTableName 
  DROP COLUMN poly_id_meta, 
  DROP COLUMN poly_id_dist, 
  DROP COLUMN poly_id_herbs, 
  DROP COLUMN poly_id_l1, 
  DROP COLUMN poly_id_l2, 
  DROP COLUMN poly_id_l3, 
  DROP COLUMN poly_id_shrubs, 
  DROP COLUMN poly_id_wetland;
"