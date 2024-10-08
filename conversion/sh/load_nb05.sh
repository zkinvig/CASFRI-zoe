#!/bin/bash -x

# This script loads the New Brunswick FRI data into PostgreSQL
# This is for holder id 20

# If the table already exists, it can be overwritten by setting the "overwriteFRI" variable
# in the configuration file.

# Workflow is to load the first table normally, then append the others
# Use -nlt PROMOTE_TO_MULTI to take care of any mixed single and multi part geometries


######################################## Set variables #######################################

source ./common.sh

inventoryID=NB05
NB_subFolder=NB/$inventoryID/data/inventory/

srcFilename=NB_Landbase_Oct1_2019
srcLayerName=SDEOWNER_Landbase
srcFileFullPath="$friDir/$NB_subFolder$srcFilename.gdb"
fullTargetTableName=$targetFRISchema.nb05

########################################## Process ######################################


"$gdalFolder/ogr2ogr" \
-f PostgreSQL "$pg_connection_string" "$srcFileFullPath" \
-nln $fullTargetTableName $layer_creation_options $other_options \
-nlt PROMOTE_TO_MULTI -nlt CONVERT_TO_LINEAR \
-emptyStrAsNull \
-sql "SELECT *, '$srcFilename' AS src_filename, '$inventoryID' AS inventory_id FROM $srcLayerName WHERE holder = 20" \
-progress $overwrite_tab

source ./common_postprocessing.sh
