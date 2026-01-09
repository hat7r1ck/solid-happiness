## Step 1: Confirm you are ingesting useful log levels

If you only ingest `error`, you will likely never see config lines or enablement state.

```spl
index=sec_extended sourcetype=pa:xsoar:server:txt source="/var/log/demisto/server.log" earliest=-24h
| rex field=_raw "(?<level>debug|info|warn|warning|error)\b"
| stats count by level
| sort - count
````

Decision:

* If only `error` is present, skip Step 2 and go straight to Step 3 and Step 4.
* If `debug` and `info` are present, proceed normally.

---

## Step 2: Try to find explicit entry-indexing config keys in logs

These are the definitive toggles. In many environments they will not appear in server.log, so 0 results is expected.

```spl
index=sec_extended sourcetype=pa:xsoar:server:txt source="/var/log/demisto/server.log" earliest=-180d
("db.index.entry.disable" OR "DB.IndexEntryContent" OR "granular.index.entries" OR "server.entries.restore")
| table _time host _raw
| sort - _time
```

Decision:

* If results exist, screenshot the line(s) showing the key/value and you have on/off evidence.
* If 0 results, proceed.

---

## Step 3: Look for entry index names and Elasticsearch failure modes

This is the strongest “something happened” evidence when config keys are not logged.

### 3A: Entry index name signal

```spl
index=sec_extended sourcetype=pa:xsoar:server:txt source="/var/log/demisto/server.log" earliest=-180d
(common-entry OR "common-entry_")
| table _time host _raw
| sort - _time
```

### 3B: Elasticsearch index failure signals

```spl
index=sec_extended sourcetype=pa:xsoar:server:txt source="/var/log/demisto/server.log" earliest=-180d
(index_not_found OR index_not_found_exception OR search_phase_execution OR cluster_block_exception OR "no such index")
| table _time host _raw
| sort - _time
```

Decision:

* If you see `common-entry` together with any Elasticsearch failure keyword, screenshot it. That is escalation-grade.
* If 0 results, proceed.

---

## Step 4: Extract top error signatures (host-scoped)

If you have the relevant XSOAR node, scope to it. Otherwise remove `host="..."` and use `wf_env=PROD` if available.

Replace `HOSTNAME_HERE`.

```spl
index=sec_extended sourcetype=pa:xsoar:server:txt source="/var/log/demisto/server.log" host="HOSTNAME_HERE" earliest=-7d
| eval raw=replace(_raw,"\n"," ")
| rex field=raw max_match=1 "(?<sig>(?i)(Exception|Error|Failed|failure|panic|fatal)[^\\.]*(\\.|$))"
| eval sig=coalesce(sig, substr(raw, 1, 220))
| stats count as hits by sig
| sort - hits
| head 25
```

Decision:

* If any signature includes `common-entry`, `entry index`, `index_not_found`, or `search_phase_execution`, screenshot that row and then pivot to raw events for that signature.
* If nothing relates to entries or indexing, proceed.

---

## Step 5: Produce the final statement (what you can safely say)

If Steps 2–4 produce 0 evidence of indexing state:

* You cannot attest “enabled” or “disabled” from SOC-visible telemetry.
* The correct escalation is an ownership request, not a defect claim.

Suggested ticket language (paste as-is):

> SOC attempted to validate War Room entry indexing state using SOC-permitted methods. `/system/config` is reachable but does not expose entry-indexing settings to SOC RBAC. In Splunk (index `sec_extended`, sourcetype `pa:xsoar:server:txt`, source `/var/log/demisto/server.log`), there is no observable evidence of entry-index enablement keys (`db.index.entry.disable`, `DB.IndexEntryContent`, `granular.index.entries`) and no `common-entry` or Elasticsearch index-failure indicators over the search window. SOC cannot provide configuration attestation from available telemetry. Platform team must confirm whether War Room entry indexing is enabled for audit lookbacks, and whether any reindex was performed after the outage window.
