# Sample configuration file for conversion batch files
# Copy this file as config.sh and edit it according to your setup.

#################################################################
# Path to base folder of all source inventories
#################################################################
friDir=E:/FRIs

#################################################################
# PostgreSQL configuration
#################################################################
pgport=5432
pghost=localhost
pguser=postgres
pgpassword=postgres

# Target PostgreSQL database
pgdbname=cas

# Target schema where raw source inventories should be loaded
targetFRISchema=rawfri

# Target schema where translation tables should be loaded
targetTranslationFileSchema=translation

#################################################################
# List of source tables to load and translate
#################################################################

# Extra, non inventory tables to load (not translate)
photoYearList=(ab_photoyear nl_photoyear)

# First series of inventories having more than 2000000 rows. Longest one should be the last one.
invList1=(BC08 BC10 ON01 QC01 QC04 QC05)

# Second series of inventories having more than 2000000 rows. Longest one should be the last one.
invList2=(BC11 BC12 QC02 QC06 ON02)

# Inventories having between 500000 and 2000000 rows. Longest one should be the last one.
invList3=(AB25 AB29 NB01 NB02 NS01 NS02 NS03 SK01 SK04 MB05 NL01)

# Inventories having between 200000 and 500000 rows. Longest one should be the last one.
invList4=(MB07 NT01 NT03 QC03 YT01 YT02 SK06 SK05)

# Inventories having less than 200000 rows
invList5=(AB03 AB06 AB07 AB08 AB10 AB11 AB16 AB30 MB01 MB02 MB04 MB06 PC01 PC02 PE01 QC07 SK02 SK03 YT03)

# Merge all inventory lists into a list of list
fullList=(invList1 invList2 invList3 invList4 invList5)

#################################################################
# GDAL installation folder
#################################################################
gdalFolder="C:/Program Files/GDAL"

# Set this to true if using GDAL version 1.11.4
gdal_1_11_4=False

#################################################################
# Set to True if you want conversion and translation command windows to stay open after completion
leaveConvShellOpen=False

#################################################################
# Set to true if you want loaded inventories to overwrite already loaded ones
overwriteFRI=True

# Set to true if you want loaded translation tables to overwrite already loaded ones
overwriteTTables=True

#################################################################
# Set some default values
#################################################################

##############################
# Set pgversion if your version of PostgreSQL is different than 13
# pgversion=11

if [ ${pgversion}x == x ]; then
pgversion=13
fi
pgFolder="/c/PROGRA~1/PostgreSQL/$pgversion"

##############################
# Set bashCmd if your bash command is different from the standard Linux bash command
# bashCmd="/c/program files/git/git-bash.exe"

if [ ${bashCmd}x == x ]; then
bashCmd="/bin/bash"
fi

