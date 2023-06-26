---
title: prometheus
categories:
  - software
  - notes
  - guides
author: monocodes
url: https://github.com/monocodes/snippets.git
---

## prometheus guides

- [Server Monitoring Guide: Using Prometheus, Grafana And Node_Exporter For Easy Server Monitoring](https://cloudtechservice.com/grafana-server-monitoring/)
- [Monitoring a Linux host with Prometheus, Node Exporter, and Docker Compose](https://grafana.com/docs/grafana-cloud/quickstart/docker-compose-linux/)
- [Monitor Your Synology With Grafana and Prometheus Dashboard](https://mariushosting.com/monitor-your-synology-with-grafana-and-prometheus-dashboard/)
- [Collect Docker metrics with Prometheus](https://docs.docker.com/config/daemon/prometheus/)
- [Monitoring Docker container metrics using cAdvisor](https://prometheus.io/docs/guides/cadvisor/)

### TSDB

#### [Prometheus: Delete Time Series Metrics](https://www.shellhacks.com/prometheus-delete-time-series-metrics/)

Sometimes you may want to delete some metrics from Prometheus if those metrics are unwanted or you just need to free up some disk space.

Time series in Prometheus can be deleted over administrative HTTP API only (disabled by default).

To enabled it, pass `--web.enable-admin-api` flag to Prometheus through start-up script or docker-compose file, depending on installation method.

**Delete Time Series Metrics**

Use the following syntax to delete all time series metrics that match some label:

```sh
$ curl -X POST \
    -g 'http://localhost:9090/api/v1/admin/tsdb/delete_series?match[]={foo="bar"}'
```

To delete time series metrics that match some `job` or `instance`, run:

```sh
$ curl -X POST -g 'http://localhost:9090/api/v1/admin/tsdb/delete_series?match[]={job="node_exporter"}'
$ curl -X POST -g 'http://localhost:9090/api/v1/admin/tsdb/delete_series?match[]={instance="192.168.0.1:9100"}'
```

To delete all data from Prometheus, run:

```sh
$ curl -X POST -g 'http://localhost:9090/api/v1/admin/tsdb/delete_series?match[]={__name__=~".+"}'
```

Note that the above API calls don’t delete data immediately.

The actual data still exists on disk and will be cleaned up in future compaction.

To determine when to remove old data, use `--storage.tsdb.retention` option e.g. `--storage.tsdb.retention='365d'` (by default, Prometheus keeps data for 15 days).

To completely remove the data deleted by `delete_series` send `clean_tombstones` API call:

```sh
$ curl -X POST -g 'http://localhost:9090/api/v1/admin/tsdb/clean_tombstones'
```

The successful exit status for the both `delete_series` and `clean_tombstones` is `204`.

> `204` is visible only with **Postman** or software like this. `cURL` returns `0`.
>
> Data will not be deleted at the same moment with the `clean_tombstones`. Wait some time, about 20-30 minutes.
>
> Don't forget to restart **Prometheus** or container with it without `--web.enable-admin-api`.

---