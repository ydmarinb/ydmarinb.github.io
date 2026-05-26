---
layout: post
title: "Data bricks"
date: 2026-05-14T19:32:38.588908
category: ingenieria-datos
subtopic: "Modern Data Warehouses"
---

In the grand narrative of distributed systems, there is an irony every senior architect appreciates: Apache Spark was born as the high-performance successor to Hadoop, designed to transcend the limitations of MapReduce. By choosing Scala and the Java Virtual Machine (JVM), Spark gained expressivity and speed, but a decade later, it hit an invisible wall. The system that freed Big Data from the tyranny of the disk ended up suffocated by the very language that gave it life. This led to the birth of [**Photon**](https://www.databricks.com/product/photon), a native execution engine designed to resolve the "JVM tax" by integrating a C++ heart into a Java-based ecosystem.



The engineering shift began when workloads moved from being **[I/O-bound](https://en.wikipedia.org/wiki/I/O_bound)** to **[CPU-bound](https://en.wikipedia.org/wiki/CPU-bound)**. During the Hadoop era, mitigation focused on storage bottlenecks, but the arrival of [NVMe SSDs](https://www.ibm.com/think/topics/nvme) and disaggregated storage shifted the pressure directly to the processor. Databricks identified that trying to squeeze more performance out of the JVM was a battle of diminishing returns due to **Garbage Collection (GC) pauses** in massive heaps (64GB+) and **JIT compilation limits**, where complex generated code would exceed method size limits and force a fall-back to slow interpreted mode. Photon solves this by being a vectorized engine integrated via [**JNI (Java Native Interface)**](https://www.baeldung.com/jni), where a call costs approximately 23ns—comparable to a C++ virtual function lookup—allowing a fluid transition between the Java-managed threading and the native execution kernels.



Photon’s design philosophy prioritizes **Expression Fusion (Horizontal)** over the "Vertical" Operator Fusion used by systems like [HyPer](https://cs.brown.edu/courses/cs227/archives/2012/papers/olap/hyper.pdf) or [Actian](https://www.actian.com/databases/analytics-engine/). While compiling a whole plan into a single loop is efficient, it creates a diagnostic nightmare; if the system crashes, you "fall into the assembly," losing traceability. Photon uses precompiled primitives, allowing developers to profile every operator individually and maintain high observability. A key architectural decision was the choice of **Position Lists** (offsets) over Bitmaps to track active rows. As research from [**CMU**](https://15721.courses.cs.cmu.edu/spring2023/) suggests, while Bitmaps are [SIMD-friendly](https://www.youtube.com/watch?v=X_wPVFB8ikU), Position Lists win in sparse analytical scenarios by iterating only over $O(\text{active rows})$, avoiding wasted cycles on "dead" tuples within a batch.

Efficiency in the Lakehouse is further driven by **Macro and Micro Adaptivity**. At the Macro level, Photon can change the physical plan after a shuffle (e.g., switching from a Shuffle Join to a Broadcast Join). At the Micro level, the engine detects at runtime if a batch is ASCII-only or null-free, triggering specialized code paths that eliminate [**branching**](https://en.wikipedia.org/wiki/Branch_(computer_science)) and accelerate execution. This native approach allowed Databricks to break the 100TB TPC-DS record, proving that for modern [**OLAP**](https://en.wikipedia.org/wiki/Online_analytical_processing), Java is no longer a top-tier candidate for high-performance execution engines.



