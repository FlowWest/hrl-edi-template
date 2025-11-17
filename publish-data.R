# Script used to publish data to EDI

# Prior to running this script, please ensure you have an EDI account
# Contact support@edirepository.org to create an account
# Please add your user_id and password to your Renviron
# usethis::edit_r_environ()
# EDI_USER_ID = "INSERT USERNAME"
# EDI_PASSWORD = "INSERT PASSWORD"

remotes::install_github("FlowWest/EMLaide") #https://github.com/FlowWest/EMLaide
library(EMLaide)

path_eml_file <- here("data-raw", "eml", "edi.00.00.xml") # Created using make-eml.R

# If this is a new package, use "upload_edi_package". If it is an update,
# use "update_edi_package"
# Recommend publishing on staging first! Update to "production" when ready
upload_edi_package(user_id = Sys.getenv("EDI_USER_ID"),
                   password = Sys.getenv("EDI_PASSWORD"),
                   eml_file_path = path_eml_file,
                   environment = "staging")
