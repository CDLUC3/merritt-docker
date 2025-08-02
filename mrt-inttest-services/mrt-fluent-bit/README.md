## Test

```
docker run -it --rm \
  -v ./test-driver-stdin.conf:/fluent-bit/etc/fluent-bit.conf \
  671846987296.dkr.ecr.us-west-2.amazonaws.com/mrt-fluent-bit 
```

## TODOs
- [ ] java - get access logs
- [ ] java - get json logs
- [ ] ui, get lograge logs
- [ ] ui, compress default messages
- [ ] suppress health checks

## Audit

```
01-Aug-2025 11:01:49.162 INFO  [pool-27-thread-1] RunFixity - Fixity Batch Compelete
```

## UI

```
[49ed8f96-e681-452f-8a02-bc623dd02073]   Rendered collection/_billable_size.html.erb (Duration: 12.3ms | GC: 4.9ms) [cache miss]
```

## Admin

```
127.0.0.1 - - [01/Aug/2025:11:11:10 -0700] "GET /robots.txt HTTP/1.1" 200 25 0.0007
```

## Zoo

```
2025-08-01 18:00:02,894 [myid:] - INFO  [CommitProcessor:3:o.a.z.s.q.LeaderSessionTracker@104] - Committing global session 0x1000001d1c5001f
```

## Merritt Dev 

```
::1 - - [01/Aug/2025:17:53:09 +0000] "GET / HTTP/1.1" 200 239 "-" "curl/8.12.1"
```