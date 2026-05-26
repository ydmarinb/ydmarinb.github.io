---
layout: post
title: "Kimball"
date: 2026-05-13T18:38:53.255077
category: ingenieria-datos
subtopic: "Data modeling"
---

In today's enterprise ecosystem, organizations possess "mountains of data" but often face a strategic disconnect between information capture and timely decision-making. [Ralph Kimball's](https://en.wikipedia.org/wiki/Ralph_Kimball) methodology isn't just about organizing bits; it is about transforming operational chaos into a business compass through legibility and simplicity. As Kimball himself noted, sophistication lies not in the complexity of the schema, but in its legibility: "Simplicity is the fundamental key that allows users to understand databases easily and software to navigate them efficiently."

Architects must respect the dichotomy between [**OLTP (Online Transactional Processing)**](https://en.wikipedia.org/wiki/Online_transaction_processing) and [**OLAP (Online Analytical Processing)**](https://en.wikipedia.org/wiki/Online_analytical_processing). Operational systems are where data "enters" to turn the wheels of the business—processing one transaction at a time. The Data Warehouse is where data "exits" to observe how those wheels turn, analyzing millions of records to find patterns. A common critical error is assuming that a mirror copy of an operational system constitutes a functional DW. Without a dedicated architecture, analysts become involuntary "Black Belt VLOOKUP Ninjas," wasting strategic time on manual data preparation.

Managing a Data Warehouse should follow the **Publication Metaphor**, where the manager acts as the "Editor-in-Chief" of a high-quality magazine. The master tool is the [**Enterprise Data Warehouse Bus Matrix**](https://www.kimballgroup.com/data-warehouse-business-intelligence-resources/kimball-techniques/dimensional-modeling-techniques/dw-bus-architecture/), an editorial calendar that coordinates data through [**Conformed Dimensions**](https://en.wikipedia.org/wiki/Conformed_dimension). This ensures "Product" or "Time" means the same thing across all departments, effectively killing information silos. To achieve this, Kimball requires a strict 4-step sequence: 

1.  **Select the [Business Process](https://www.kimballgroup.com/data-warehouse-business-intelligence-resources/kimball-techniques/dimensional-modeling-techniques/business-process/):** Focusing on core activities rather than departments. 
2.  **Declare the [Grain](https://www.kimballgroup.com/data-warehouse-business-intelligence-resources/kimball-techniques/dimensional-modeling-techniques/grain/):** Defining exactly what one row in the fact table represents. 
3.  **Identify the [Dimensions](https://www.kimballgroup.com/data-warehouse-business-intelligence-resources/kimball-techniques/dimensional-modeling-techniques/dimensions-for-context/):** Providing the "Who, What, Where, When, and Why" context. 
4.  **Identify the [Facts](https://www.kimballgroup.com/data-warehouse-business-intelligence-resources/kimball-techniques/dimensional-modeling-techniques/facts-for-measurement/):** Capturing the numeric metrics for measurement.


To handle complex business requirements, three types of fact tables must coexist: [**Transaction**](https://en.wikipedia.org/wiki/Fact_table#Transaction_fact_tables) (point-in-time events), [**Periodic Snapshots**](https://en.wikipedia.org/wiki/Fact_table#Periodic_snapshot_fact_tables) (status at the end of a period), and [**Accumulating Snapshots**](https://en.wikipedia.org/wiki/Fact_table#Accumulating_snapshot_fact_tables) (tracking the entire lifecycle of a process). Long-term integrity rests on [**Surrogate Keys**](https://en.wikipedia.org/wiki/Surrogate_key)—sequential integers that shield the DW from operational changes—and [**Slowly Changing Dimensions (SCD)**](https://en.wikipedia.org/wiki/Slowly_changing_dimension). While Type 1 overwrites and Type 3 tracks limited change, **SCD Type 2** is the gold standard for unlimited historical tracking, creating new rows to preserve an audit trail of how business context evolves.

---

**Implementation Criteria**: [**Kimball's Dimensional Modeling**](https://www.kimballgroup.com/data-warehouse-business-intelligence-resources/kimball-techniques/dimensional-modeling-techniques/) is the definitive choice for building user-centric Data Warehouses where query performance and ease of use for BI tools (Power BI, Tableau) are the primary goals. It is critical for organizations requiring a flexible, extensible "Bus Architecture" that can grow one business process at a time. However, you should favor the [**Inmon Approach**](https://ydmarinb.github.io/data-engineering/Data-modeling/Inmon/) if your primary need is a centralized, highly-normalized (3NF) repository for data governance, or a [**Data Vault**](https://ydmarinb.github.io/data-engineering/Data-modeling/Data-vault/) approach if you are dealing with a rapidly changing, massive-scale environment requiring full auditability and agile integration of hundreds of disparate source systems.


