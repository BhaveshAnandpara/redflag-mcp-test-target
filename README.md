# redflag-mcp-test-target

A deliberately normal, real MCP server, deployed so [Redflag](https://red-flag-gules.vercel.app)
has a stable, always-reachable target to scan — instead of a local server behind a tunnel that
drops every few minutes.

It runs [excel-mcp-server](https://github.com/haris-musa/excel-mcp-server) (a third-party, open
source MCP server for reading and editing Excel workbooks) unmodified, in streamable-HTTP mode,
behind a bearer token.

**This is a test target, not a product.** It holds no real data — only workbooks Redflag's scans
create and write themselves, inside `/app/workbooks`, which Render clears on every restart.

## Deploying on Render

1. New → Blueprint → point it at this repo. `render.yaml` sets up a free Docker web service.
2. After it's created, set the `EXCEL_MCP_AUTH_TOKEN` environment variable in the Render
   dashboard (Settings → Environment) to a random token. It isn't set in the blueprint on
   purpose, so it's never written into the repo.
3. The server listens at `https://<your-service>.onrender.com/mcp`. Give that address, with the
   token, to Redflag's MCP check page.

## Running it locally

```
docker build -t redflag-mcp-test-target .
docker run -p 8000:8000 -e EXCEL_MCP_AUTH_TOKEN=some-throwaway-token redflag-mcp-test-target
```

## A note on the free tier

A free Render web service sleeps after a period of no traffic and takes a few seconds to wake on
the next request. Redflag's scans make one attempt per call with no retry, so a scan started the
moment this service is asleep will see its first calls time out. Open the server's URL once
yourself before starting a scan to wake it, or move to a paid "always on" plan if that's a
problem.
