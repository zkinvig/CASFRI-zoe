#!/bin/bash -x

# This script loads the Yukon (YK01) into PostgreSQL

# The format of the source dataset is a shapefile

# The year of photography is included in the attribute REF_YEAR

# Load into a target table in the schema defined in the config file.

# If the table already exists, it can be overwritten by setting the "overwriteFRI" variable 
# in the configuration file.

######################################## Set variables #######################################

source ./common.sh

inventoryID=YT01
srcFileName=INVENTORY_POLY_40K
srcFullPath="$friDir/YT/$inventoryID/data/inventory/$srcFileName.shp"

fullTargetTableName=$targetFRISchema.yt01

########################################## Process ######################################

# Run ogr2ogr
"$gdalFolder/ogr2ogr" \
-f PostgreSQL "$pg_connection_string" "$srcFullPath" \
-nln $fullTargetTableName $layer_creation_options $other_options \
-sql "SELECT *, '$srcFileName' AS src_filename, '$inventoryID' AS inventory_id FROM $srcFileName" \
-progress $overwrite_tab

source ./common_postprocessing.sh