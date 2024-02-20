install.packages("remotes")
remotes::install_github("OHDSI/Achilles")
install.packages('dotenv')
install.packages('Achilles')

library(DatabaseConnector)
library(Achilles)
library(dotenv)
library(here)

dotenv::load_dot_env(here("../../.env"))

connectionString <- Sys.getenv("connectionString")
dbms <-  Sys.getenv("dbms")
pathToDriver <- Sys.getenv("pathToJDBCDriver")
user <- Sys.getenv("user")
password <- Sys.getenv("personal_access_token")

cdmVersion = "5.4"
cdmDatabaseSchema  <- Sys.getenv("cdmDatabaseSchema")
resultsDatabaseSchema  <- Sys.getenv("resultsDatabaseSchema")
sqlDialect  <- Sys.getenv("sqlDialect")

# Download JDBC drivers
DatabaseConnector::downloadJdbcDrivers("spark", pathToDriver=pathToDriver)

connectionDetails <- createConnectionDetails(
  dbms=dbms,
  connectionString = connectionString,
  pathToDriver = pathToDriver,
  user=user,
  password = password,
)

Achilles::achilles(
  cdmVersion = cdmVersion,
  connectionDetails = connectionDetails,
  cdmDatabaseSchema = cdmDatabaseSchema,
  resultsDatabaseSchema = resultsDatabaseSchema,
  sqlDialect = sqlDialect,
  dropScratchTables = True,
  numThreads = 1,
  optimizeAtlasCache = True
)
