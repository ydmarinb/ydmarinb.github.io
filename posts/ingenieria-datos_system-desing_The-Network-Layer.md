---
layout: post
title: "The network layer"
date: 2026-05-22T20:52:46.702770
category: ingenieria-datos
subtopic: "System desing"
---

For a user, typing a URL into a browser feels instantaneous, but for enterprise distributed infrastructure, it triggers a hierarchical, multi-continent routing odyssey. The [Domain Name System (DNS)](https://www.cloudflare.com/learning/dns/what-is-dns/) acts as the internet's global routing protocol, transforming human-readable semantics into machine-readable IP addresses. Before any packet touches the wire, the architecture attempts to resolve the domain via a localized cascade—checking the browser cache, the Operating System cache, and the local router. If a cache miss occurs, the query escalates to a recursive resolver, which systematically queries the **Root Name Servers**, the **Top-Level Domain (TLD) Servers** (such as `.com`), and finally, the **Authoritative Name Server** for the specific domain (e.g., returning an IP like `208.65.153.238` for YouTube). 



Once the IP address is resolved, the system initiates communication by transitioning down to the transport layer, where the architectural trade-offs of the network stack become apparent. The [Transmission Control Protocol (TCP)](https://www.geeksforgeeks.org/what-is-transmission-control-protocol-tcp/) is built directly on top of the connectionless Internet Protocol (IP), but it introduces stateful reliability and ordered packet delivery through the execution of a synchronous **Three-Way Handshake (SYN, SYN-ACK, ACK)**. While TCP provides an absolute guarantee that data packets—bounded by an IP header packet size up to $2^{16}$ bytes (64 KB)—arrive intact, it introduces strict network latency overhead. To simplify application development, [Hypertext Transfer Protocol (HTTP)](https://developer.mozilla.org/en-US/docs/Web/HTTP) abstracts this underlying complexity, establishing standardized ports for traffic routing: port `80` for unencrypted HTTP and port `443` for TLS/SSL encrypted HTTPS. 

The structural mechanics of a server can be understood through a classic architectural analogy: the IP address represents a physical apartment building, while the network port represents a specific apartment unit number. This precise addressing model works flawlessly for traditional request-response lifecycles, but it degrades significantly when engineering real-time, bidirectional communication systems. In high-concurrency environments, relying on traditional short-polling forces the client to hit the server with relentless, redundant HTTP requests, generating massive CPU scheduling overhead and network saturation. While **Long Polling** attempts to mitigate this by holding the request open until new data appears, it remains an inefficient patch. The true paradigm shift occurs with the implementation of [WebSockets](https://developer.mozilla.org/en-US/docs/Web/API/WebSockets_API), an independent protocol that uses an HTTP handshake to upgrade the connection, establishing a persistent, full-duplex TCP pipe that handles massive concurrent traffic with near-zero frame overhead.


