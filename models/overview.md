{% docs __overview__ %}

# OHDSI/OMOP Data Harmonisation project

__Data Science Team, Lancashire Teaching Hospitals NHS Foundation Trust__

## Overview

Lancashire Teaching Hospitals NHS Foundation Trust (LTH) is a digitally mature secondary care provider, major trauma centre and multi-specialty tertiary referral centre in Lancashire and South Cumbria ICS (LSC).

LTH have access to routinely collected healthcare data for over 2.25 million patients spanning 15 years, covering most aspects of secondary care.
This data is stored in multiple disparate databases.

We have invested in a multi-year, large-scale data harmonisation program with the [Observational Medical Outcomes Partnership (OMOP) Common Data Model (CDM)](https://www.ohdsi.org/data-standardization/) as the target model.
We have secured additional external funding from [EHDEN-HDRUK](https://www.ehden.eu/datapartners/) further validating our strategy.

OMOP is supported by the [Observational Health Data Sciences and Informatics (OHDSI)](https://www.ohdsi.org/) program, a multi-stakeholder, global collaborative that aims to deliver value out of health data through large-scale analytics.
Harmonising to OMOP makes our data immediately valuable using standardised, open-source, analytics software maintained by a global community of researchers.

LTH is a member of the [HDRUK Alliance](https://ukhealthdata.org/members/) and will also become member of the global OHDSI federation collaborating on international research studies - both observational as well as clinical trials.

## OMOP, Azure DataBricks & DBT

This project follows on from our [on-prem ELT project on SQL Server](https://omop-lsc.surge.sh/rxn_dev/index.html#!/overview) that also utilises [dbt](https://www.getdbt.com/) to transform data from multiple data sources into the OMOP 5.4 CDM. This data is ingested at regular intervals into Lancashire and South Cumbria's [Azure DataBricks](https://azure.microsoft.com/en-gb/products/databricks) Secure Data Platform.

The _bronze_ OMOP data is transformed into a clean _silver_ layer in preparation for use in direct care and clinical/operational intelligence. These transformations are based on extensive tests on the bronze (source) layer followed by further tests on the silver layer.

A separate project converts the _silver_ layer into a research-ready, deidentified, _gold_ layer (docs yet to be published).

## Project Team

- Vishnu V Chandrabalan, Consultant Surgeon, Director/CCIO, LSC SDE
- Quin Ashcroft, Lead Data Scientist and OMOP Analytics Engineer
- Tim Howcroft, Clinical Scientist
- Dale Kirkwood, ED Trainee, PPIE Lead - LSC SDE
- Jo Knight, Professor of Data Science, Lancaster University
- Kina Bennett, Head of Research and Development
- Louise Acheson, Information Governance Lead
- Sally Stewart, Programme Director, NW SDE
- Stephen Dobson, Chief Information Officer, LTH

{% enddocs %}
