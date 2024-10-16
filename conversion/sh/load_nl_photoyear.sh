#!/bin/bash -x

# This script loads the Newfoundland and Labrador photo year file into PostgreSQL

# The format of the source dataset is a single shapefile

# Load into a target table in the schema defined in the config file.

# If the table already exists, it can be overwritten by setting the "overwriteFRI" variable 
# in the configuration file.

# Set the -nlt argument to PROMOTE_TO_MULTI. This auto converts all features to multipart features when loading.

######################################## Set variables #######################################

source ./common.sh

srcFileName=photoyear
srcFullPath="$friDir/NL/NL01/data/photoyear/$srcFileName.shp"

fullTargetTableName=$targetFRISchema.nl_photoYear

########################################## Process ######################################

# Run ogr2ogr
"$gdalFolder/ogr2ogr" \
-f PostgreSQL "$pg_connection_string" "$srcFullPath" \
-nln $fullTargetTableName $layer_creation_options $other_options \
-nlt PROMOTE_TO_MULTI \
-progress $overwrite_tab

# Fix it
"$gdalFolder/ogrinfo" "$pg_connection_string" \
-sql "
DROP TABLE IF EXISTS ${targetFRISchema}.new_nl_photoyear;
CREATE TABLE ${targetFRISchema}.new_nl_photoyear AS
SELECT ST_MakeValid(wkb_geometry) AS wkb_geometry, photoyear, ogc_fid
FROM ${fullTargetTableName};
DROP TABLE IF EXISTS ${fullTargetTableName};
ALTER TABLE ${targetFRISchema}.new_nl_photoyear RENAME TO nl_photoyear;
"
createSQLSpatialIndex=True

source ./common_postprocessing.sh
