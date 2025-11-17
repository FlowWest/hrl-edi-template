# Script to run the EMLassemblyline workflow to make EML

# PLEASE UPDATE! ----------------------------------------------------------
# TODO
# Please enter the following information needed for this script to work.
data_file_name <- "INSERT" # This is the name of your data table in data-raw/data_objects.
# If there are multiple files some steps will need to be repeated
attributes_metadata_csv_file_name <- "INSERT" # This is the name of the attributes
# metadata csv template in data-raw/metadata_templates/attributes_csv_template
title <- "INSERT" # This is the title of your data package
geography <- "INSERT" # This is a description of the geography. For instance, "Feather River"
coordinates <- c("INSERT", "INSERT","INSERT", "INSERT") # These are the bounding
# coordinates entered as: North bounding, East bounding, South bounding, West bounding
maintenance <- "INSERT" # This is how often the package will be maintained: daily, weekly, monthly, annually, complete

# Finish creating metadata templates --------------------------------------
# Use helper code to create remaining metadata
# Update EMLassemblyline and load

remotes::install_github("EDIorg/EMLassemblyline")
library(EMLassemblyline) # used to build the metadata EML (e.g. specific format needed to publish on EDI)
library(here) # used for file paths

# Define paths for your metadata templates, data, and EML

path_templates <- here("data-raw", "metadata_templates")
path_data <- here("data-raw", "data_objects")
path_eml <- here("data-raw", "eml")

# Read in your data file to find the start and end dates for temporal coverage
data_file <- read_csv(paste0(path_data, "/", data_file_name, ".csv"))
start_date <- min(data_file$date)
end_date <- max(data_file$date)

# Check that the following files in metadata_templates have been manually filled
# in and are correct:
# abstract.txt
# attributes_csv_templates/attributes_csv_template.csv (one per data table)
# custom_units.txt
# intellectual_rights.txt (DO NOT CHANGE unless using another license)
# keywords.txt
# methods.docx
# personnel.txt

# Attributes metadata - csv to txt
# It is easier to fill in the data dictionaries as csv and then translate to .txt file
data_csv <- read_csv(here("metadata_templates","attributes_csv_template", paste0(attributes_metadata_csv_file_name, ".csv")))
# Name this file as paste0("attributes_", "INSERT data file name", ".txt")
write.table(data_csv, file = here("metadata_templates", paste0("attributes_", data_file_name, ".txt")), sep = "\t", row.names = F, quote = F)

# Create categorical variables template (required when attributes templates
# contains variables with a "categorical" class)
# The following code will automatically create these for you

EMLassemblyline::template_categorical_variables(
  path = path_templates,
  data.path = path_data)

# Create taxonomic coverage template (Not-required. Use this to report
# taxonomic entities in the metadata)

# In this example we manually fill out this template but use taxonomyCleanr to help
# find the authority id

# remotes::install_github("EDIorg/taxonomyCleanr")
# library(taxonomyCleanr)

# taxonomyCleanr::resolve_comm_taxa("chinook salmon", 3) # enter any species you need
# to find the id for


# Create geographic coverage (required when more than one geographic location
# is to be reported in the metadata).

# EMLassemblyline::template_geographic_coverage(
#   path = path_templates,
#   data.path = path_data,
#   data.table = "",
#   lat.col = "",
#   lon.col = "",
#   site.col = "")

# Make EML from metadata templates --------------------------------------------

# Once all your metadata templates are complete call this function to create
# the EML.

make_eml(
  path = path_templates,
  data.path = path_data,
  eml.path = path_eml,
  dataset.title = title,
  temporal.coverage = c(start_date, end_date),
  geographic.description = geography,
  geographic.coordinates = coordinates,
  maintenance.description = maintenance,
  data.table = data_file_name)
