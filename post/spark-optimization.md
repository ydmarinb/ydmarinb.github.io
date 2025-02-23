---
layout: default
title: Spark Optimization
description: How to improve spark performance?
---

When working with Spark, it is not only important to know how to transform data, it may even be more important to know how we can improve the performance of Spark, so in this post we are going to go over in detail how we can optimize Spark and the possible sources of poor performance .

# 1. Skewness

When we talk about asymmetry, we talk about an unequal proportion of data between data partitions (we can find some partitions with a large amount of data and some with a low volume of data). Since the purpose of Spark is to perform a transformation in parallel on each partition, this issue can cause some processing threads to be underutilized.

![Skewness](../images/spark-optimization/partition.png)


```python
from pyspark.sql import SparkSession

# Initialize Spark Session
spark = SparkSession.builder.appName("SkewnessDemo").getOrCreate()
```

    24/01/29 11:59:48 WARN SparkSession: Using an existing Spark session; only runtime SQL configurations will take effect.


### 1. Create a Skewed Dataset:

For demonstration, let's create a DataFrame with a key-value structure where one key is overly represented (skewed).


```python
from pyspark.sql import Row
import random

# Function to generate skewed data
def generate_skewed_data():
    skewed_key = "key1"
    other_keys = [f"key{i}" for i in range(2, 11)]
    rows = [Row(key=skewed_key, value=random.randint(1, 100)) for _ in range(100)]  # 100 rows of 'key1'
    rows += [Row(key=random.choice(other_keys), value=random.randint(1, 10)) for _ in range(10)]  # 10 rows of other keys
    return rows

# Create RDD and then DataFrame
rdd = spark.sparkContext.parallelize(generate_skewed_data())
df = spark.createDataFrame(rdd)

```

### 2. Perform an Operation Exposing Skewness:
Let's perform a group-by operation, which will be affected by skewness.




```python
# Group by 'key' and count
result_df = df.groupBy("key").count()
result_df.show()
```

    +-----+-----+
    |  key|count|
    +-----+-----+
    | key1|  100|
    | key8|    1|
    | key3|    2|
    | key6|    3|
    | key4|    1|
    | key2|    1|
    |key10|    2|
    +-----+-----+
    


<div style="background-color: #D4EDDA; color: #155724; border-left: 5px solid #28A745; padding: 0.5rem;">
    We can see an obvious asymmetry problem: the length of the bar for <code>key 1</code> is evidently many times larger than the other bars.
</div>



## Fixing the problema with salting method

Salting involves adding a random value to the keys that are causing skewness. This is done to "break" these keys into several distinct keys, thus distributing the data more evenly across the cluster partitions and avoiding overloading a single node.

Identify the Problematic Key: 

### 1. Identify the key (or keys) that is causing skewness: 
If you have a key 'Key1' that appears in a large amount of your data, this would be your problematic key.

### 2. Add a Random Value:
 Next, you add a random value to this key. If your problematic key is 'Key1', you could add a random number from 1 to 5 to it, thus creating new keys like 'Key1_1', 'Key1_2', 'Key1_3', etc.


```python
from pyspark.sql import SparkSession, functions as F
import random


# Add a 'salt' column with a random value to each row of the DataFrame.
# F.rand() generates a random number between 0 and 1 for each row.
# This number is multiplied by 5 and then cast to an integer.
# As a result, a random integer between 0 and 4 is generated for each row.
df_with_salting = df.withColumn("salt", (F.rand() * 5).cast("int"))

# Show the DataFrame with the added 'salt' column.
# This display helps in understanding how the salting process affects each row.
df_with_salting.show()

```

    +----+-----+----+
    | key|value|salt|
    +----+-----+----+
    |key1|   52|   4|
    |key1|    3|   3|
    |key1|   37|   4|
    |key1|   52|   1|
    |key1|   72|   4|
    |key1|   32|   1|
    |key1|   46|   4|
    |key1|   77|   0|
    |key1|   85|   0|
    |key1|   59|   3|
    |key1|   38|   1|
    |key1|   16|   4|
    |key1|   97|   3|
    |key1|   57|   4|
    |key1|   11|   2|
    |key1|   85|   2|
    |key1|   80|   4|
    |key1|   48|   2|
    |key1|   53|   4|
    |key1|   48|   2|
    +----+-----+----+
    only showing top 20 rows
    


### 3. Process the Modified Data
Now you perform your operations (such as joins or groupBys) on this modified data set. Adding these random values helps distribute the data more evenly across partitions, thus avoiding the skewness problem.


```python
# Combine the original key and the salt value to create a new 'salted' key.
# The F.concat function is used to concatenate the original key, an underscore, and the salt value.
# This results in a new column 'salted_key' where each original key is appended with a unique salt value.
df_with_salting = df_with_salting.withColumn("salted_key", F.concat(F.col("key"), F.lit("_"), F.col("salt")))

# Display the DataFrame to show the effect of adding the 'salted_key' column.
# This output is useful for verifying that the salting process has been applied correctly to each row.
df_with_salting.show()

```

    +----+-----+----+----------+
    | key|value|salt|salted_key|
    +----+-----+----+----------+
    |key1|   52|   4|    key1_4|
    |key1|    3|   3|    key1_3|
    |key1|   37|   4|    key1_4|
    |key1|   52|   1|    key1_1|
    |key1|   72|   4|    key1_4|
    |key1|   32|   1|    key1_1|
    |key1|   46|   4|    key1_4|
    |key1|   77|   0|    key1_0|
    |key1|   85|   0|    key1_0|
    |key1|   59|   3|    key1_3|
    |key1|   38|   1|    key1_1|
    |key1|   16|   4|    key1_4|
    |key1|   97|   3|    key1_3|
    |key1|   57|   4|    key1_4|
    |key1|   11|   2|    key1_2|
    |key1|   85|   2|    key1_2|
    |key1|   80|   4|    key1_4|
    |key1|   48|   2|    key1_2|
    |key1|   53|   4|    key1_4|
    |key1|   48|   2|    key1_2|
    +----+-----+----+----------+
    only showing top 20 rows
    



```python
# Perform operations on the salted data.
# Here, an example operation is grouping by the 'salted_key' column.
# The groupBy operation is followed by a count, which aggregates the data based on the 'salted_key'.
# This is useful to observe the distribution of data across the newly created salted keys.
grouped_df = df_with_salting.groupBy("salted_key").count()

grouped_df.show()

```

    +----------+-----+
    |salted_key|count|
    +----------+-----+
    |    key1_1|   26|
    |    key1_4|   31|
    |    key1_3|   17|
    |    key1_0|   15|
    |    key1_2|   11|
    |    key9_4|    1|
    |    key2_0|    1|
    |    key3_1|    1|
    |    key9_1|    1|
    |   key10_3|    1|
    |    key4_0|    1|
    |    key4_3|    1|
    |    key3_3|    1|
    |    key8_1|    1|
    |   key10_1|    1|
    +----------+-----+
    


### 4. Remove Salting Post-Processing: 
After completing the operations, you remove the added random value, returning the keys to their original form. This step is necessary to obtain accurate and meaningful results.


```python
# Remove the salting to retrieve the original key.
# This involves splitting the 'salted_key' at the underscore and extracting the first part,
# which represents the original key before salting.
# The result is a new column 'original_key' in the DataFrame.
df_final = grouped_df.withColumn("original_key", F.expr("split(salted_key, '_')[0]"))

# If needed, group the data again by the original key.
# Here, the groupBy operation is followed by a summation of the 'count' column.
# This operation aggregates the data based on the original key, combining the counts
# from all salted variants of each key.
df_final = df_final.groupBy("original_key").sum("count")

# Display the final results.
df_final.show()

```

    +------------+----------+
    |original_key|sum(count)|
    +------------+----------+
    |        key8|         1|
    |        key3|         2|
    |        key1|       100|
    |        key4|         2|
    |        key2|         1|
    |        key9|         2|
    |       key10|         2|
    +------------+----------+
    


# 2. Memory Spill

Spilling is the concept that refers to the act of moving RDD data from memory to disk and then returning the data back to memory. This process has a great impact, because it can affect system performance since access to data on disk is significantly slower than in memory. 

![Memory Spill](../images/spark-optimization/spilling.png)

This problem is usually caused by:

* There is not enough RAM to hold the entire data set.

* Some aggregation operations such as "groupBy" and "join" require large data to be loaded and processed into memory simultaneously.

* Improper configuration of Spark parameters, such as the memory size of executors `spark.executor.memory` or the memory size of shuffling operations `spark.shuffle.memoryFraction` can cause inefficient use of the memory.


## Memory Spill Management

To manage and minimize the impact of memory spill in PySpark, the following strategies can be considered:

**1. Configuration Optimization**
* *Adjust Executor Memory (`spark.executor.memory`):* This setting determines the amount of memory that is allocated to each executor. Increasing it can help avoid spilling, but be careful not to exceed the available physical memory.

* *Configure Shuffle Memory (`spark.shuffle.memoryFraction` and `spark.shuffle.spill.compress`):* Sets what fraction of the executor memory is used for shuffle operations. Adjusting this ratio can help reduce spill during the shuffle. Additionally, enabling spilled data compression (spark.shuffle.spill.compress) can reduce the amount of data written to disk.



```python
from pyspark.sql import SparkSession

# Start a SparkSession with optimized configuration:
spark = SparkSession.builder \
    .appName("OptimizedMemoryUsage") \  # Sets the name of the application. Useful for identification in the Spark UI.

    # Configures the amount of memory allocated to each Spark executor. Here, 4 GB is allocated.
    # Increasing this value can help to manage larger datasets and reduce memory spilling.
    .config("spark.executor.memory", "4g") \

    # Sets the fraction of executor memory to be used for execution and storage (0.8 = 80% of executor memory).
    # A higher value can reduce memory spilling, but might leave less memory for other operations.
    .config("spark.memory.fraction", "0.8") \

    # Specifies the fraction of 'spark.memory.fraction' dedicated to storage (e.g., caching, broadcast variables).
    # Here, 50% of the memory fraction is allocated for storage.
    # Adjusting this value helps to optimize the balance between execution memory and storage memory.
    .config("spark.memory.storageFraction", "0.5") \

    # Specifies the fraction of 'spark.memory.fraction' used for shuffle-related data structures (e.g., sort, aggregates).
    # A lower value may reduce memory usage but increase memory spilling during shuffling operations.
    .config("spark.shuffle.memoryFraction", "0.3") \

    # Enables compression of data spilled during shuffle operations. 
    # Compressing spilled data can significantly reduce the volume of data written to disk,
    # improving performance in scenarios where memory spilling occurs.
    .config("spark.shuffle.spill.compress", "true") \

    # Creates the Spark session with the specified configuration. If a Spark session already exists, 
    # this command will return the existing session.
    .getOrCreate()  

```

**2. Efficient Application Design**
(It refers to the way you write your Spark applications)

* *Minimize Expensive Transformations:* Some operations, such as groupBy and join, require a lot of memory. Try to minimize its use or redesign your workflow to make it more efficient.

* *Early Data Filtering:* Apply filters as early as possible in your workflow to reduce the volume of data that is processed in later stages.

* *Using Persistence and Smart Cache:* Use persist() or cache() to keep data in memory, but avoid overloading memory by caching only essential data.


```python
### Minimizing Expensive Transformations and Early Data Filtering 
 
 
# Read data
df = spark.read.csv("large_dataset.csv", header=True, inferSchema=True)

# Example of an expensive operation: groupBy followed by an aggregation
# Original approach
expensive_df = df.groupBy("category").agg({"price": "avg"})

# Redesigning to minimize the expensive operation
# Let's say you only need data for a specific category, filter first
filtered_df = df.filter(df["category"] == "specific_category")
optimized_df = filtered_df.groupBy("category").agg({"price": "avg"})

```


```python
#Using Persistence and Smart Cache:

# Read data
df = spark.read.csv("large_dataset.csv", header=True, inferSchema=True)

# Assume this DataFrame will be used multiple times in different transformations
df.cache()  # or df.persist()

# Perform transformations
transformed_df1 = df.someTransformation1()
transformed_df2 = df.someTransformation2()

# After all transformations are done, you can unpersist the DataFrame
df.unpersist()

```

**3. Query Optimization**

* *Review and Optimize Spark Queries:* Make sure your queries are as efficient as possible. This may include rewriting queries to minimize shuffle operations or use more efficient operations.

* *Broadcast Join instead of Shuffle Join:* When one table is significantly smaller than the other, using a broadcast join can avoid costly shuffle operations.

* *Data Partitioning:* Ensure that data is well partitioned to avoid imbalances in data distribution, which can lead to unnecessary spills.


```python
# Assuming 'products_df' is a small DataFrame and 'sales_df' is a large DataFrame
from pyspark.sql.functions import broadcast

# Using broadcast join to avoid shuffle
joined_df = sales_df.join(broadcast(products_df), sales_df["product_id"] == products_df["id"])

```

# 3. Adaptive Query Execution (AQE) 

Adaptive Query Execution (AQE) is an advanced technique that allows Spark to adapt and reoptimize query execution plans at runtime. Improves query performance by adjusting to actual data distribution and cluster conditions.

AQE is not enabled by default in Spark. To activate it, you must modify your SparkSession configuration:



```python
from pyspark.sql import SparkSession

spark = SparkSession.builder \
    .appName("AdaptiveQueryExecution") \
    .config("spark.sql.adaptive.enabled", "true") \
    .getOrCreate()

```

    24/01/29 11:53:03 WARN SparkSession: Using an existing Spark session; only runtime SQL configurations will take effect.


## AQE Key Features

* *Dynamic Partition Coalescing:* AQE can automatically merge small partitions to improve operation efficiency.

* *Join Partition Size Optimization:* AQE adjusts the size of partitions in join operations to handle imbalances in data distribution.

* *Handling Skew in Joins:* AQE can detect and handle skew in joins to avoid execution bottlenecks.

## Benefits of Using AQE

* *Performance Improvement:* By adjusting execution plans in real time, AQE can significantly improve query efficiency.

* *Automatic Partition and Skew Management:* Reduces the need for manual adjustments and specific optimizations by the developer.

## Best Practices and Considerations

* *Monitoring:* Use the Spark UI to monitor the impact of AQE on your queries.

* *Variable Data and Workloads:* AQE is particularly useful in environments with frequently changing data and workloads.

* *Testing and Tuning:* Test your queries with and without AQE to understand their impact on your specific use cases.
