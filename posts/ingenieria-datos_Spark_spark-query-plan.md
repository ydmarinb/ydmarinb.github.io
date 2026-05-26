---
layout: post
title: "Spark query plan"
date: 2026-05-05T17:25:01.781545
category: ingenieria-datos
subtopic: "Spark"
---

Before moving a single byte, Spark transforms your code through a logical and physical assembly line known as the [Catalyst Optimizer](https://www.databricks.com/blog/what-is-catalyst-optimizer). This process begins with an **Unresolved Logical Plan**, where Spark merely verifies syntax. Once passed to the **Analyzed Logical Plan**, the engine consults the Catalog to verify that tables and columns exist and that data types are compatible. The real magic occurs in the **Optimized Logical Plan**, where Catalyst applies rule-based optimizations—such as constant folding and filter reordering—to maximize efficiency. Finally, Spark generates multiple **Physical Plans**, selecting the most resource-efficient strategy through an internal cost model before distributing tasks to executors.



One of Spark's most elegant strategies is the combination of **Predicate and Projection Pushdown**. The goal is simple: read the least amount of data possible. [Predicate Pushdown](https://www.dremio.com/wiki/predicate-pushdown/) attempts to apply your filters directly at the storage layer (e.g., within a Parquet file). If you only need data for "Boston," Spark requests that the storage engine send only those rows, while **Projection Pushdown** ignores columns you don't use. This is crucial because network I/O is the primary enemy of performance. However, architects must be aware of "blind spots": if you filter by keys inside a **Map type** column or use unsupported expressions like a `cast()` on a source column, pushdown fails. In these cases, the original source cannot "see" inside the structure or transformation, forcing Spark to perform a heavy, full-table read and filter in memory afterward.



Data movement, or **Shuffling**, remains the most expensive operation in any plan. Understanding the mechanical difference between `repartition` and `coalesce` is vital for managing this cost. **Repartition** uses a [Round Robin](https://en.wikipedia.org/wiki/Round-robin_scheduling) scheme to guarantee perfect data distribution, but it triggers a full network **Exchange**. Conversely, **Coalesce** is "shuffle-aware"; it attempts to reduce the partition count by merging adjacent partitions within the same executor, avoiding data movement across the network. This efficiency also extends to how Spark handles aggregations. Through **Hash Aggregates**, Spark uses a "divide and conquer" approach, performing local calculations (Partial Sums) on each partition before sending only the consolidated results across the wire. This is why a simple `count()` is fast, while a `count(distinct)` is orders of magnitude heavier—it requires a "gauntlet" of four Hash Aggregates and two Shuffles to deduplicate keys globally.



The pinnacle of modern Spark optimization is [Adaptive Query Execution (AQE)](https://www.databricks.com/blog/2020/05/29/adaptive-query-execution-speeding-up-spark-sql-at-runtime.html). If a query plan shows `is final plan = false`, you are witnessing Spark learning in real-time. Unlike static plans that guess data characteristics, AQE uses runtime statistics to observe the actual bytes read and the true size of partitions after a shuffle. This "fresh" information allows Spark to dynamically switch a heavy **Sort-Merge Join** to a high-speed **Broadcast Join** or merge small partitions that would otherwise clog the cluster with scheduling overhead. By evolving the plan during execution, Spark ensures that your architecture remains resilient to data skew and fluctuating workloads.


