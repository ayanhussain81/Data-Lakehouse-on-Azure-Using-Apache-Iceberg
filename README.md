# Data Lakehouse on Azure Using Apache Iceberg

A medallion-style (Bronze → Silver → Iceberg) data lakehouse on Azure, built on the NYC Parking Violations dataset. Raw CSV data in Azure Blob/ADLS storage is processed with Azure Databricks and stored as Delta / Apache Iceberg tables, with the Azure infrastructure provisioned by Terraform.

## Repository structure

```
.
├── Data/                         parking_data.csv (sample) + dataset notes (full ~1.2 GB CSV not tracked)
└── Project_Code/
    ├── Code/
    │   ├── Bronze_Layer.ipynb                       Raw ingestion (classic cluster)
    │   ├── Bronze_Layer_Databricks_Serverless.ipynb Raw ingestion (Databricks serverless + Unity Catalog)
    │   ├── Silver_Layer.ipynb                       Cleaned / conformed data
    │   ├── Apache Iceberg Table.ipynb               Create Iceberg tables
    │   ├── Apache Iceberg - ACID Transaction.ipynb  ACID transactions
    │   ├── Apache Iceberg - Schema Evolution.ipynb  Schema evolution
    │   └── Apache Iceberg - Time Travel.ipynb       Time travel and rollback
    └── Terraform/                Azure infrastructure (main.tf, providers.tf, instructions)
```

## Getting started

1. Provision the Azure resources: see [Project_Code/Terraform/Instructions.md](Project_Code/Terraform/Instructions.md).
2. Download the NYC Parking Violations CSV (NYC Open Data, "Parking Violations Issued", or Kaggle "NYC Parking Tickets") and upload it to your Azure Blob/ADLS container.
3. Run the notebooks in `Project_Code/Code/` in order: Bronze → Silver → Iceberg.
4. For Databricks serverless, set `storage_account`, `container` and `file_path` in the first cell of `Bronze_Layer_Databricks_Serverless.ipynb` and grant access through a Unity Catalog external location.

## Dataset columns

The dataset has 43 columns (listed below as 41 entries, since the three Street Code columns are grouped); each row is one parking ticket. A 1,119-row sample is included in [Data/parking_data.csv](Data/parking_data.csv).

| # | Column | Description |
|---|--------|-------------|
| 1 | Summons Number | Unique ticket number assigned to each parking violation. |
| 2 | Plate ID | License plate number of the ticketed vehicle. |
| 3 | Registration State | State where the vehicle is registered, e.g. NY or NJ. |
| 4 | Plate Type | Type of license plate, e.g. PAS = passenger vehicle. |
| 5 | Issue Date | Date the ticket was issued. |
| 6 | Violation Code | Numeric code identifying the specific type of violation. |
| 7 | Vehicle Body Type | Body style of the vehicle, e.g. SDN = sedan, SUBN = SUV. |
| 8 | Vehicle Make | Vehicle manufacturer, e.g. Toyota, Honda, Ford. |
| 9 | Issuing Agency | Code of the agency that issued the ticket, e.g. P = Police Department. |
| 10 | Street Code1, Street Code2, Street Code3 | NYC Department of Transportation street codes, used to map or geocode the violation location. |
| 11 | Vehicle Expiration Date | Date the vehicle's registration expires. |
| 12 | Violation Location | Precinct or area where the violation took place. |
| 13 | Violation Precinct | NYPD precinct in which the violation was recorded. |
| 14 | Issuer Precinct | Precinct of the officer who issued the ticket. |
| 15 | Issuer Code | Badge number or unique identifier of the issuing officer. |
| 16 | Issuer Command | Command or department code of the issuing officer. |
| 17 | Issuer Squad | Subdivision or unit of the issuing officer. |
| 18 | Violation Time | Time of the violation in coded format, e.g. 0911A = 9:11 AM. |
| 19 | Time First Observed | Time the officer first noticed the violation; may differ from the violation time. |
| 20 | Violation County | County where the ticket was issued, e.g. BX = Bronx, NY = Manhattan. |
| 21 | Violation In Front Of Or Opposite | Whether the vehicle was parked in front of or opposite a location. |
| 22 | House Number | Building number where the violation occurred. |
| 23 | Street Name | Street where the vehicle was parked. |
| 24 | Intersecting Street | Nearest cross street to the violation location. |
| 25 | Date First Observed | Date the violation was first observed; useful for ongoing offenses. |
| 26 | Law Section | Section of law (often NYC Administrative Code) the violation falls under. |
| 27 | Sub Division | Subsection of the law related to the violation. |
| 28 | Violation Legal Code | Specific legal code describing the exact infraction. |
| 29 | Days Parking In Effect | Days the parking rules are enforced; BBBBBBB = every day of the week. (The raw header has trailing spaces, which the Bronze layer cleans.) |
| 30 | From Hours In Effect | Time when the parking restriction starts. |
| 31 | To Hours In Effect | Time when the parking restriction ends. |
| 32 | Vehicle Color | Color of the vehicle. |
| 33 | Unregistered Vehicle? | Flag: 1 = unregistered, 0 = registered. |
| 34 | Vehicle Year | Year the vehicle was manufactured. |
| 35 | Meter Number | Parking meter number, if applicable. |
| 36 | Feet From Curb | Distance of the vehicle from the curb, in feet. |
| 37 | Violation Post Code | Internal code identifying the enforcement location. |
| 38 | Violation Description | Text description of the violation; often empty. |
| 39 | No Standing or Stopping Violation | Flag: 1 = violation involved no standing or stopping. |
| 40 | Hydrant Violation | Flag: 1 = parked too close to a fire hydrant. |
| 41 | Double Parking Violation | Flag: 1 = vehicle was double-parked. |

> A *precinct* is the geographic district served by a local police station. In NYC, Violation Precinct and Issuer Precinct refer to NYPD precincts.
