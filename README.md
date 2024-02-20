# DBT OMOP Medallion Gold Layer

__Data Science Team, Lancashire Teaching Hospitals NHS Foundation Trust__

## Introduction

This repository has the transformations, tests and snapshots for generating a clean 'gold' OMOP layer from a 'silver' layer.

Additional supporting models that extend the OMOP CDM are also included as part of this project.

## Requirements

Python >= 3.11 is required.

Run `pip install -r requirements.txt` in a new Python environment to install the dependencies.

## Instructions

1. Clone the repository.

2. Create a ```.dbt``` folder in your user profile and create a file called ```profiles.yml```

3. Copy the following into the file:

a. This project is setup to initially run on on-prm SQL server where the _bronze_ layer resides. The production workflow will be executed on the _silver_ layer in DataBricks.

```yaml
dbt_omop_rxn_gold_sqlserver:
  target: dev
  outputs:
    dev:
      database: dbt_omop
      driver: ODBC Driver 17 for SQL Server
      port: 1433
      schema: gold
      server: LTHDATASCIENCE
      threads: 4
      trust_cert: true
      type: sqlserver

  outputs:
    databricks:
      type: databricks
      catalog: hive_metastore
      schema: gold
      threads: 8
      host: <databricks-workspace-id>.azuredatabricks.net
      http_path: <eg/sql/1.0/warehouses/warehouse-id>
      token: <databricks-personal-access-token>
```

4. Run `dbt deps` to setup the dbt dependencies.

5. When running locally, set $Env:DBT_PROFILES_DIR='C:\Users\username\.dbt' to ensure that the above profiles directory is used instead of the 'profiles.yaml' file in root of this project that is used for databricks jobs.

6. Run `dbt run -s "dbt_omom_rxn_gold"` to run the entire lineage or select specific models.

7. For production use on DataBricks run `dbt run -s "dbt_omom_rxn_gold" --target databricks`
