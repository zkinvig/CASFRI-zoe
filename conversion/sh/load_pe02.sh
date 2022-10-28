source ./common.sh

inventoryID=PE02


srcFileName=CorporateLanduseInventory2010
srcName="$srcFileName"
srcFullPath="$friDir/PE/$inventoryID/data/inventory/$srcFileName.shp"
fullTargetTableName=$targetFRISchema.pe02


########################################## Process ######################################

# cast year to an integer type so helperfunctions work as expected on that field
# load polygons
"$gdalFolder/ogr2ogr" \
-f "PostgreSQL" "$pg_connection_string" "$srcFullPath" \
-nln $fullTargetTableName \
-nlt PROMOTE_TO_MULTI \
$layer_creation_options $other_options \
-sql "SELECT *, '$srcFileName' AS src_filename, '$inventoryID' AS inventory_id, cast(year_ AS INTEGER) FROM $srcName" \
-progress $overwrite_tab

createSQLSpatialIndex=True

source ./common_postprocessing.sh