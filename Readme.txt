# Scope 3 Emissions Calculator (Category 1) – Shiny App

## Overview

This project is an interactive **R Shiny dashboard** developed to calculate **Scope 3 Category 1 (Purchased Goods & Services)** emissions based on the GHG Protocol.

The tool was built as an alternative to traditional Excel-based workflows, aiming to improve:

* usability
* scalability
* transparency
* reproducibility

It supports multiple calculation methodologies and provides a structured interface for ESG analysis.

---

## Features

### Calculation Methods

The app currently supports three GHG Protocol-aligned methods:

* **Supplier-Specific Method**
  Uses product-level emission factors provided by suppliers.

* **Hybrid Method**
  Combines supplier-specific data (Scope 1 & 2, materials, transport, waste) with secondary emission factors.

* **Spend-Based Method**
  Uses EEIO-style emission factors (kg CO₂e per monetary value).

---

### Data Input

* Upload datasets via **Excel or CSV**
* Supports a ready-to-use test file: **`emissions_data.xlsx`**
* Structured format depending on selected method

---

### Emission Factor Integration

* Built-in emission factor datasets:

  * materials
  * services (spend-based)
  * transport
  * waste
* Option to **override with custom emission factors**

---

### Outputs

* Total emissions (kg CO₂e and tCO₂e)
* Emissions breakdown by item
* Visualizations:

  * bar charts
  * pie charts

---

### Validation & Transparency

* Basic data validation (missing values, inconsistencies)
* Warnings for lower-accuracy methods (e.g., spend-based)
* Clear indication of method used

---

### Export

* Download results as Excel file

---

## Test Dataset

A sample dataset is included in this repository:

**`emissions_data.xlsx`**

You can use this file to test all three calculation methods by:

1. Downloading the file from the repository
2. Uploading it directly into the app
3. Selecting different calculation methods to see how outputs change

This dataset includes multiple product categories and is structured to simulate real-world procurement data.

---

## Why Not Excel?

While Excel is commonly used for Scope 3 calculations, it becomes limiting when:

* handling multiple methodologies
* scaling to large datasets
* maintaining transparency for ESG reporting

This app introduces:

* dynamic method selection
* structured calculations
* improved user interaction
* reproducible workflows

---

## Tech Stack

* **R**
* **Shiny / shinydashboard**
* **dplyr**
* **ggplot2**
* **readxl / writexl**

---

## How to Run

1. Clone the repository:

```bash id="j1fjpn"
git clone https://github.com/yourusername/scope3-shiny-app.git
```

2. Open in RStudio

3. Install required packages:

```r id="t78nt9"
install.packages(c("shiny", "shinydashboard", "dplyr", "ggplot2", "readxl", "writexl"))
```

4. Run the app:

```r id="6tsxf5"
shiny::runApp()
```

---

## How to Use

1. Launch the app in RStudio
2. Select a calculation method:

   * Supplier-Specific
   * Hybrid
   * Spend-Based
3. Upload **`emissions_data.xlsx`** (or your own dataset)
4. View results:

   * Total emissions
   * Charts and breakdowns
5. Download results as Excel

---

## Current Limitations

* Focused only on Scope 3 Category 1
* Limited emission factor database (demo-level)
* No authentication or cloud deployment yet
* Basic validation (not audit-grade)

---

## Future Improvements

* Integration with external emission factor databases (e.g., DEFRA, EEIO expansion)
* Full GHG Protocol decision-tree guidance
* PDF ESG reporting output
* Multi-category Scope 3 support
* Improved validation and audit trail
* Deployment as a web-based SaaS tool

---

## Contributing

Feedback and suggestions are welcome, especially from professionals in:

* ESG / sustainability
* carbon accounting
* environmental data analysis

---


---

## Author

COPYRIGHT Abdullah Rumi Shishir©
Developed as part of a learning and prototyping exercise in Scope 3 emissions accounting and interactive tool development.
