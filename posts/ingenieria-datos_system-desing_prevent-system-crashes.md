---
layout: post
title: "Prevent system crashes"
date: 2026-05-24T20:51:35.003551
category: ingenieria-datos
subtopic: "System desing"
---

For decades, the engineering world approached traffic spikes with blind faith in infinite elasticity. However, when incoming requests dramatically exceed expected capacity, the result is not a simple service degradation; it is an existential threat that can trigger a complete, cascading system collapse. Faced with this avalanche, the default architectural response is **Scalability**—injecting new servers into the fleet to absorb the operational impact and stabilize throughput.

To orchestrate this defense, modern systems employ dynamic scaling strategies. These range from static, scheduled provisioning for predictable high-demand events (like Black Friday), to reactive heuristics based on monitoring statistics and advanced predictive models. However, there is a fundamental and often ignored flaw in this paradigm: compute capacity provisioning is not instantaneous. While the cloud infrastructure initializes machines, configures networks, and couples the new nodes to the Load Balancer, a critical time gap opens. During these precious minutes of operational latency, the original ecosystem remains exposed and can collapse catastrophically under the weight of unmitigated traffic.

To survive this period of extreme vulnerability, the architecture must abandon the utopian idea of serving every request and adopt a pure survival mechanism: **Load Shedding**. This technique acts as a brutal but mathematically necessary triage. Instead of allowing the request queue to saturate CPU and memory resources until process asphyxiation, the system determines its optimal number of tolerable requests per unit of time. Any traffic exceeding this maximum threshold is immediately rejected or dropped. By limiting the effort to the exact ceiling of its current processing capacity, the system intentionally sacrifices a portion of the incoming traffic to guarantee the core infrastructure survives intact, buying the necessary time while horizontal scaling completes in the background.

While Load Shedding protects the global integrity of the architecture, **Rate Limiting** is deployed as a tactical barrier against individual actors. This process relentlessly restricts the number of requests a specific user or client can issue within a defined time window, protecting compute cycles from abuse or targeted attacks. However, executing this control across a horizontally distributed server fleet introduces a complex technical challenge: how do multiple isolated servers know how many times a single user has interacted? To resolve this state dilemma without injecting destructive database latency, architects must force lightning-fast consensus. This is achieved by deploying a high-speed centralized counting cache (like Redis) or, in decentralized ecosystems that avoid single points of failure, by implementing **Gossip Protocols** so nodes can share state metrics epidemically and asynchronously across the network.


