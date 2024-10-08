#!/bin/bash -x

# This script loads the New Brunswick FRI data into PostgreSQL
# This is the open data (all holder ids other than 16 and 20)

# If the table already exists, it can be overwritten by setting the "overwriteFRI" variable
# in the configuration file.

# Workflow is to load the first table normally, then append the others
# Use -nlt PROMOTE_TO_MULTI to take care of any mixed single and multi part geometries


######################################## Set variables #######################################

source ./common.sh

inventoryID=NB06
NB_subFolder=NB/$inventoryID/data/inventory/

srcFilename=LandBase_2024v1
srcLayerName=LandBase2024v1
srcFileFullPath="/home/casfri/$srcFilename.gdb"
fullTargetTableName=$targetFRISchema.nb06

########################################## Process ######################################


"$gdalFolder/ogr2ogr" \
-f PostgreSQL "$pg_connection_string" "$srcFileFullPath" \
-nln $fullTargetTableName $layer_creation_options $other_options \
-nlt PROMOTE_TO_MULTI -nlt CONVERT_TO_LINEAR \
-emptyStrAsNull \
-sql "SELECT *, '$srcFilename' AS src_filename, '$inventoryID' AS inventory_id FROM $srcLayerName WHERE holder IS NULL OR holder NOT IN (16, 20)" \
-progress $overwrite_tab

source ./common_postprocessing.sh
