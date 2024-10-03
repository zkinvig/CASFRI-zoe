#!/bin/bash -x

# This script loads the New Brunswick FRI data into PostgreSQL

# If the table already exists, it can be overwritten by setting the "overwriteFRI" variable
# in the configuration file.

# Workflow is to load the first table normally, then append the others
# Use -nlt PROMOTE_TO_MULTI to take care of any mixed single and multi part geometries


######################################## Set variables #######################################

source ./common.sh

inventoryID=NB04
NB_subFolder=NB/$inventoryID/data/inventory/

srcFilename=LandBase_2024v1
srcLayerName=LandBase2024v1
srcFileFullPath="/home/casfri/$srcFilename.gdb"
fullTargetTableName=$targetFRISchema.nb04

########################################## Process ######################################


"$gdalFolder/ogr2ogr" \
-f PostgreSQL "$pg_connection_string" "$srcFileFullPath" \
-nln $fullTargetTableName $layer_creation_options $other_options \
-nlt PROMOTE_TO_MULTI -nlt CONVERT_TO_LINEAR \
-emptyStrAsNull \
-sql "SELECT *, '$srcFilename' AS src_filename, '$inventoryID' AS inventory_id FROM $srcLayerName" \
-progress $overwrite_tab

source ./common_postprocessing.sh
