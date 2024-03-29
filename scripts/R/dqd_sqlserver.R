install.packages("remotes")
# remotes::install_github("OHDSI/DataQualityDashboard")
remotes::install_local('./OHDSI-DataQualityDashboard-v2.5.0-9-g81230bd.tar.gz', upgrade = 'always')

library(DataQualityDashboard)
library(dotenv)
library(here)

dotenv::load_dot_env(here(".env.sqlserver"))


# Load Environment variables
connectionString <- Sys.getenv("connectionString")
dbms <-  Sys.getenv("dbms")
pathToDriver <- Sys.getenv("pathToJDBCDriver")

cdmVersion = "5.4"
cdmDatabaseSchema  <- Sys.getenv("cdmDatabaseSchema")
resultsDatabaseSchema  <- Sys.getenv("resultsDatabaseSchema")
vocabDatabaseSchema  <- Sys.getenv("vocabDatabaseSchema")

sqlDialect  <- Sys.getenv("sqlDialect")

cdmSourceName <- Sys.getenv("cdmSourceName")
PATH_TO_AUTH_DLL <- Sys.getenv("pathToAuthDll")

# Download JDBC drivers
# DatabaseConnector::downloadJdbcDrivers(dbms, pathToDriver=pathToDriver)

# Create Connection Details
connectionDetails <- createConnectionDetails(
  dbms=dbms,
  connectionString = connectionString,
  pathToDriver = pathToDriver
)



# determine how many threads (concurrent SQL sessions) to use ----------------------------------------
numThreads <- 1 # on Redshift, 3 seems to work well

# specify if you want to execute the queries or inspect them ------------------------------------------
sqlOnly <- FALSE # set to TRUE if you just want to get the SQL scripts and not actually run the queries
sqlOnlyIncrementalInsert <- FALSE # set to TRUE if you want the generated SQL queries to calculate DQD results and insert them into a database table (@resultsDatabaseSchema.@writeTableName)
sqlOnlyUnionCount <- 25  # in sqlOnlyIncrementalInsert mode, the number of check sqls to union in a single query; higher numbers can improve performance in some DBMS (e.g. a value of 25 may be 25x faster)

# NOTES specific to sqlOnly <- TRUE option ------------------------------------------------------------
# 1. You do not need a live database connection.  Instead, connectionDetails only needs these parameters:
#      connectionDetails <- DatabaseConnector::createConnectionDetails(
#        dbms = "", # specify your dbms
#        pathToDriver = "/"
#      )
# 2. Since these are fully functional queries, this can help with debugging.
# 3. In the results output by the sqlOnlyIncrementalInsert queries, placeholders are populated for execution_time, query_text, and warnings/errors; and the NOT_APPLICABLE rules are not applied.
# 4. In order to use the generated SQL to insert metadata and check results into output table, you must set sqlOnlyIncrementalInsert = TRUE.  Otherwise sqlOnly is backwards compatable with <= v2.2.0, generating queries which run the checks but don't store the results.


# where should the results and logs go? ----------------------------------------------------------------
outputFolder <- "output"
outputFile <- "dqd_results.json"


# logging type -------------------------------------------------------------------------------------
verboseMode <- TRUE # set to FALSE if you don't want the logs to be printed to the console

# write results to table? ------------------------------------------------------------------------------
writeToTable <- TRUE # set to FALSE if you want to skip writing to a SQL table in the results schema

# specify the name of the results table (used when writeToTable = TRUE and when sqlOnlyIncrementalInsert = TRUE)
writeTableName <- "dqdashboard_results"

# write results to a csv file? -----------------------------------------------------------------------
writeToCsv <- TRUE # set to FALSE if you want to skip writing to csv file
csvFile <- "dqd_results.csv" # only needed if writeToCsv is set to TRUE

# if writing to table and using Redshift, bulk loading can be initialized -------------------------------

# Sys.setenv("AWS_ACCESS_KEY_ID" = "",
#            "AWS_SECRET_ACCESS_KEY" = "",
#            "AWS_DEFAULT_REGION" = "",
#            "AWS_BUCKET_NAME" = "",
#            "AWS_OBJECT_KEY" = "",
#            "AWS_SSE_TYPE" = "AES256",
#            "USE_MPP_BULK_LOAD" = TRUE)

# which DQ check levels to run -------------------------------------------------------------------
checkLevels <- c("TABLE", "FIELD", "CONCEPT")
# checkLevels <- c("TABLE")

# which DQ checks to run? ------------------------------------
checkNames <- c(
  "cdmTable",
  "measurePersonCompleteness",
  "measureConditionEraCompleteness",
  "cdmField",
  "isRequired",
  "cdmDatatype",
  "isPrimaryKey",
  "isForeignKey",
  "fkDomain",
  "fkClass",
  "isStandardValidConcept",
  "measureValueCompleteness",
  "standardConceptRecordCompleteness",
  "sourceConceptRecordCompleteness",
  "sourceValueCompleteness",
  "plausibleValueLow",
  "plausibleValueHigh",
  "plausibleTemporalAfter",
  "plausibleDuringLife",
  "withinVisitDates",
  "plausibleGender"
  # "plausibleUnitConceptIds"
) # Names can be found in inst/csv/OMOP_CDM_v5.3_Check_Descriptions.csv

# which CDM tables to exclude? ------------------------------------
tablesToExclude <- c(
  "COHORT_DEFINITION",
  "CONCEPT",
  "VOCABULARY",
  "CONCEPT_ANCESTOR",
  "CONCEPT_RELATIONSHIP",
  "CONCEPT_CLASS",
  "CONCEPT_SYNONYM",
  "RELATIONSHIP",
  "DOMAIN",
  "FACT_RELATIONSHIP"
) # list of CDM table names to skip evaluating checks against; by default DQD excludes the vocab tables

# run the job --------------------------------------------------------------------------------------
DataQualityDashboard::executeDqChecks(connectionDetails = connectionDetails,
                                      cdmVersion = "5.4",
                                      cdmDatabaseSchema = cdmDatabaseSchema,
                                      resultsDatabaseSchema = resultsDatabaseSchema,
                                      vocabDatabaseSchema = vocabDatabaseSchema,
                                      cdmSourceName = cdmSourceName,
                                      numThreads = numThreads,
                                      sqlOnly = sqlOnly,
                                      sqlOnlyUnionCount = sqlOnlyUnionCount,
                                      sqlOnlyIncrementalInsert = sqlOnlyIncrementalInsert,
                                      outputFolder = outputFolder,
                                      verboseMode = verboseMode,
                                      writeToTable = writeToTable,
                                      writeToCsv = writeToCsv,
                                      csvFile = csvFile,
                                      checkLevels = checkLevels,
                                      tablesToExclude = tablesToExclude,
                                      checkNames = checkNames)

# inspect logs ----------------------------------------------------------------------------
ParallelLogger::launchLogViewer(logFileName = file.path(outputFolder,
                                                        sprintf("log_DqDashboard_%s.txt", cdmSourceName)))

# (OPTIONAL) if you want to write the JSON file to the results table separately -----------------------------
jsonFilePath <- ""
DataQualityDashboard::writeJsonResultsToTable(connectionDetails = connectionDetails,
                                              resultsDatabaseSchema = resultsDatabaseSchema,
                                              jsonFilePath = jsonFilePath)
