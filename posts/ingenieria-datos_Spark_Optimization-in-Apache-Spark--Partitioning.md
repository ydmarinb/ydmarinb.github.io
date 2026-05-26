---
layout: post
title: "Optimization in apache spark: Partitioning"
date: 2026-05-23T21:41:26.494538
category: ingenieria-datos
subtopic: "Spark"
---

Imagine a massive bookshelf with thousands of books in no particular order. Finding a specific title requires a "Full Scan"—checking every spine one by one. In engineering terms, this is a performance killer due to massive I/O overhead and unnecessary memory pressure. [Data Partitioning](https://ydmarinb.github.io/data-engineering/Spark/Optimization-in-Apache-Spark--Partitioning/) transforms this chaos into a targeted search, moving from a blind `FileScan` operator to a logical structure where Spark ignores irrelevant data and goes directly to the required section.

The fundamental objective is to reduce the search space through [Partition Pruning](https://docs.aws.amazon.com/prescriptive-guidance/latest/spark-tuning-glue-emr/pruning-dynamic-partitions.html). For a dataset like Spotify activity, analyzing a specific `listen_date` should not require reading the entire year’s records. By partitioning by date, Spark uses its metadata to eliminate processing of irrelevant folders. However, achieving the "Goldilocks Zone" of partitioning is critical: partitions that are too large create bottlenecks where a single core does the "heavy lifting" while others sit idle, whereas partitions that are too small( trigger the ["small file problem,"](https://www.youtube.com/watch?v=SPKEEapQ4Rg) where Spark spends more time on administrative overhead—managing tasks and I/O connections—than on processing actual data.



Selecting the right partitioning column depends entirely on **cardinality**. High-cardinality columns, such as a unique `Customer_ID`, generate too many micro-partitions, nullifying any gain in search efficiency. Conversely, low-to-medium cardinality columns, like `State` or `Province`, create substantial data blocks that allow for efficient filtering. The "Golden Rule" is to partition by columns frequently used in `WHERE` clauses, while avoiding extremely low cardinality (e.g., a single country) that would collapse all data into a single partition and kill parallelism.


Architecting the data layout involves both disk and memory manipulation. When using [partitionBy()](https://spark.apache.org/docs/latest/api/python/reference/pyspark.sql/api/pyspark.sql.DataFrameWriter.partitionBy.html), the column order creates a nested folder hierarchy ($date=X/hour=Y/$); the parent folder should reflect the most common query entry point. For reading, the `spark.sql.files.maxPartitionBytes` property controls how Spark splits files into tasks. Finally, managing the output requires a choice between [repartition()](https://spark.apache.org/docs/latest/api/python/reference/pyspark.sql/api/pyspark.sql.DataFrame.repartition.html)  and [coalesce()](https://spark.apache.org/docs/latest/api/python/reference/pyspark.sql/api/pyspark.sql.functions.coalesce.html): use `repartition()` to increase parallelism through a full network shuffle, or `coalesce()` to reduce the number of files efficiently by avoiding a shuffle, keeping in mind that `coalesce()` cannot increase the partition count.


