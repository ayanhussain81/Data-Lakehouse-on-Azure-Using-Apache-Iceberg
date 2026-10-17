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

The dataset has 43 columns; each row is one parking ticket. A 1,119-row sample is included in [Data/parking_data.csv](Data/parking_data.csv).

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
| 10 | Street Code1 | NYC Department of Transportation street code, used to map or geocode the violation location. |
| 11 | Street Code2 | NYC Department of Transportation street code, used to map or geocode the violation location. |
| 12 | Street Code3 | NYC Department of Transportation street code, used to map or geocode the violation location. |
| 13 | Vehicle Expiration Date | Date the vehicle's registration expires. |
| 14 | Violation Location | Precinct or area where the violation took place. |
| 15 | Violation Precinct | NYPD precinct in which the violation was recorded. |
| 16 | Issuer Precinct | Precinct of the officer who issued the ticket. |
| 17 | Issuer Code | Badge number or unique identifier of the issuing officer. |
| 18 | Issuer Command | Command or department code of the issuing officer. |
| 19 | Issuer Squad | Subdivision or unit of the issuing officer. |
| 20 | Violation Time | Time of the violation in coded format, e.g. 0911A = 9:11 AM. |
| 21 | Time First Observed | Time the officer first noticed the violation; may differ from the violation time. |
| 22 | Violation County | County where the ticket was issued, e.g. BX = Bronx, NY = Manhattan. |
| 23 | Violation In Front Of Or Opposite | Whether the vehicle was parked in front of or opposite a location. |
| 24 | House Number | Building number where the violation occurred. |
| 25 | Street Name | Street where the vehicle was parked. |
| 26 | Intersecting Street | Nearest cross street to the violation location. |
| 27 | Date First Observed | Date the violation was first observed; useful for ongoing offenses. |
| 28 | Law Section | Section of law (often NYC Administrative Code) the violation falls under. |
| 29 | Sub Division | Subsection of the law related to the violation. |
| 30 | Violation Legal Code | Specific legal code describing the exact infraction. |
| 31 | Days Parking In Effect | Days the parking rules are enforced; BBBBBBB = every day of the week. (The raw header has trailing spaces, which the Bronze layer cleans.) |
| 32 | From Hours In Effect | Time when the parking restriction starts. |
| 33 | To Hours In Effect | Time when the parking restriction ends. |
| 34 | Vehicle Color | Color of the vehicle. |
| 35 | Unregistered Vehicle? | Flag: 1 = unregistered, 0 = registered. |
| 36 | Vehicle Year | Year the vehicle was manufactured. |
| 37 | Meter Number | Parking meter number, if applicable. |
| 38 | Feet From Curb | Distance of the vehicle from the curb, in feet. |
| 39 | Violation Post Code | Internal code identifying the enforcement location. |
| 40 | Violation Description | Text description of the violation; often empty. |
| 41 | No Standing or Stopping Violation | Flag: 1 = violation involved no standing or stopping. |
| 42 | Hydrant Violation | Flag: 1 = parked too close to a fire hydrant. |
| 43 | Double Parking Violation | Flag: 1 = vehicle was double-parked. |

> A *precinct* is the geographic district served by a local police station. In NYC, Violation Precinct and Issuer Precinct refer to NYPD precincts.
