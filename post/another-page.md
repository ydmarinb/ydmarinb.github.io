---
layout: default
title: Another page
description: This is just another page
---

When working with Spark, it is not only important to know how to transform data, it may even be more important to know how we can improve the performance of Spark, so in this post we are going to go over in detail how we can optimize Spark and the possible sources of poor performance .

# Skewness

When we talk about asymmetry, we talk about an unequal proportion of data between data partitions (we can find some partitions with a large amount of data and some with a low volume of data). Since the purpose of Spark is to perform a transformation in parallel on each partition, this issue can cause some processing threads to be underutilized.


```python
# Installing pyspark
! pip3 install pyspark
```

    Collecting pyspark
      Downloading pyspark-3.5.0.tar.gz (316.9 MB)
    [2K     [90m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━[0m [32m316.9/316.9 MB[0m [31m23.1 MB/s[0m eta [36m0:00:00[0m00:01[0m00:01[0m
    [?25h  Installing build dependencies ... [?25ldone
    [?25h  Getting requirements to build wheel ... [?25ldone
    [?25h  Preparing metadata (pyproject.toml) ... [?25ldone
    [?25hCollecting py4j==0.10.9.7 (from pyspark)
      Downloading py4j-0.10.9.7-py2.py3-none-any.whl (200 kB)
    [2K     [90m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━[0m [32m200.5/200.5 kB[0m [31m22.6 MB/s[0m eta [36m0:00:00[0m
    [?25hBuilding wheels for collected packages: pyspark
      Building wheel for pyspark (pyproject.toml) ... [?25ldone
    [?25h  Created wheel for pyspark: filename=pyspark-3.5.0-py2.py3-none-any.whl size=317425345 sha256=7280ca284238e0968997a9358897f17f5869f143a1dc6ee5af6235ac66425b07
      Stored in directory: /Users/daniel.marin/Library/Caches/pip/wheels/84/40/20/65eefe766118e0a8f8e385cc3ed6e9eb7241c7e51cfc04c51a
    Successfully built pyspark
    Installing collected packages: py4j, pyspark
    Successfully installed py4j-0.10.9.7 pyspark-3.5.0
    
    [1m[[0m[34;49mnotice[0m[1;39;49m][0m[39;49m A new release of pip is available: [0m[31;49m23.2.1[0m[39;49m -> [0m[32;49m23.3.2[0m
    [1m[[0m[34;49mnotice[0m[1;39;49m][0m[39;49m To update, run: [0m[32;49mpython3.12 -m pip install --upgrade pip[0m



```python
from pyspark.sql import SparkSession

# Initialize Spark Session
spark = SparkSession.builder.appName("SkewnessDemo").getOrCreate()
```

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
```

### 3. Visualize the Skewness:

To visualize the skewness, we'll collect the data and use a library like matplotlib to plot the distribution of records per key. Note: This part should ideally be run in a local environment as it involves plotting.


```python
import matplotlib.pyplot as plt

# Collect data
result_data = result_df.collect()

# Prepare data for plotting
keys = [row['key'] for row in result_data]
counts = [row['count'] for row in result_data]

# Plot
plt.bar(keys, counts)
plt.xlabel('Keys')
plt.ylabel('Count')
plt.xticks(rotation=90, fontsize=7)
plt.title('Distribution of Keys Showing Skewness')
plt.show()

```


    
![png](post_files/post_8_0.png)
    


<div style="background-color: #D4EDDA; color: #155724; border-left: 5px solid #28A745; padding: 0.5rem;">
    We can see an obvious asymmetry problem: the length of the bar for <code>key 1</code> is evidently many times larger than the other bars.
</div>




```python

```
