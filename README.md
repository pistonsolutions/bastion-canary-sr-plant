# bastion-canary-sr-plant
Build reproducibility telemetry canary (plant)

## Build reproducibility telemetry preflight

Run this before any build task:

```bash
./scripts/build-telemetry-preflight.sh
```

For local verification without posting telemetry:

```bash
BUILD_TELEMETRY_DRY_RUN=1 ./scripts/build-telemetry-preflight.sh
```
