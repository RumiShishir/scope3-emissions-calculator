# Scope 3 Category 1 Emissions Dashboard (Shiny App)

## Overview

This project is an interactive **R Shiny dashboard** designed to calculate and compare greenhouse gas (GHG) emissions for **Scope 3 Category 1: Purchased Goods and Services**, based on the GHG Protocol Technical Guidance.

The dashboard supports multiple calculation approaches used in corporate carbon accounting and allows users to upload datasets, compute emissions, and directly compare methodological outcomes.

The tool is intended for **EIA, ESG reporting, carbon accounting analysis, and sustainability research workflows**.

---

## Methods Implemented

The dashboard includes four core calculation methods aligned with GHG Protocol Scope 3 guidance:

### 1. Supplier-Specific Method
Uses primary supplier emission factors.

**Formula:**
Emissions = Quantity × Supplier-specific emission factor

**Key feature:**
- Highest data accuracy
- Requires supplier product-level emission factors

---

### 2. Hybrid Method (Full Supplier Activity Data)
Uses detailed supplier operational data.

Includes:
- Scope 1 & 2 emissions
- Material input emissions
- Transport emissions
- Waste emissions

**Formula:**
Emissions = S1 + S2 + Materials + Transport + Waste

---

### 3. Hybrid Method (Partial Supplier Data)
Used when supplier provides limited data.

Includes:
- Scope 1 & 2 emissions
- Waste emissions
- Cradle-to-gate estimated emissions (secondary data)

**Formula:**
Emissions = S1 + S2 + Waste + Upstream estimated emissions

---

### 4. Average Data Method
Uses physical activity data with industry-average emission factors.

**Formula:**
Emissions = Activity data × Emission factor per unit

---

### 5. Mixed Spend-Mass Method
Combines:
- Physical mass-based data
- Monetary spend-based data

**Formula:**
Emissions =
- Mass × EF (physical goods)
- Spend × EF (monetary goods)

---

## Datasets Included

Each method uses a dedicated dataset format to ensure consistency and reproducibility.

### 1. Supplier_Specific.csv

Used for supplier-specific calculations.

**Columns:**
- Item
- Quantity_kg
- EmissionFactor_kgCO2e_per_kg

**Example:**
| Item     | Quantity_kg | EmissionFactor_kgCO2e_per_kg |
|----------|-------------|------------------------------|
| Cement   | 200000      | 0.15                         |
| Steel    | 100000      | 0.20                         |

---

### 2. hybrid_full_supplier_activity.csv

Used for full hybrid method.

**Columns:**
- Item
- Scope1_2_kgCO2e
- Material_mass_kg
- Material_EF
- Transport_km
- Transport_mass_kg
- Transport_EF
- Waste_kg
- Waste_EF

---

### 3. hybrid_partial_supplier_data.csv

Used for limited supplier data hybrid method.

**Columns:**
- Item
- Scope1_2_kgCO2e
- Waste_kg
- Waste_EF
- Total_Units
- Cradle_to_gate_EF

---

### 4. Avg_data_dataset.csv

Used for average-data method.

**Columns:**
- Item
- Quantity
- EmissionFactor_kgCO2e_per_unit

**Example:**
| Item   | Quantity | EmissionFactor_kgCO2e_per_unit |
|--------|----------|---------------------------------|
| Steel  | 1000     | 2.1                             |
| Plastic| 500      | 3.2                             |

---

### 5. Mixed_Spend_Mass.csv

Used for combined spend + mass approach.

**Columns:**
- Item
- Type (mass/spend)
- Quantity_kg (for mass-based items)
- Spend_USD (for monetary items)
- EF_kgCO2e_per_kg
- EF_kgCO2e_per_USD

---

## Dashboard Features

### Emissions Calculation
- Automated calculation for all 4 methods
- Handles missing data logic per method
- Supports Excel and CSV uploads

---

### Visualization
Each method tab includes:
- Bar charts of emissions by item
- Aggregated totals per method

---

### Comparison Module
A dedicated comparison dashboard provides:

- Total emissions per method
- Highest vs lowest emitting method
- Percentage contribution of each method
- Normalized emissions comparison
- Cumulative emissions distribution
- Ranking of methods
- Pie chart breakdown

---

## Key Analytical Insights

This dashboard allows users to:

- Compare methodological uncertainty in Scope 3 accounting
- Evaluate impact of data granularity on emissions outcomes
- Understand trade-offs between data quality and estimation methods
- Identify sensitivity of emissions results to methodological choice

---

## Technical Stack

- R
- Shiny
- Shinydashboard
- dplyr
- ggplot2
- readxl / writexl
- DT

---

## File Structure (Suggested)

## Author

COPYRIGHT© Abdullah Rumi Shishir
Developed as part of a learning and prototyping exercise in Scope 3 emissions accounting and interactive tool development.
