# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

Shared deployment infrastructure for the **eduis** project. It is not an application — there is no source code to build, lint, or test. It holds the Docker Compose stack and config for services that are shared across the eduis deployment:

- **nginx** — reverse proxy / TLS termination
- **certbot** — Let's Encrypt certificate issuance and renewal
- **postgres** — shared database
- (room for "any further shared dockers", per `docs/server-infrastructure.md`)

The actual eduis backend/frontend application(s) live in separate repositories and are *not* part of this compose file.

## Commands

There is no build/lint/test pipeline. The relevant commands are Docker Compose operations run from the repo root:

```bash
docker compose up -d           # start the stack
docker compose down            # stop the stack
docker compose restart nginx   # apply nginx.conf changes (nginx isn't auto-reloaded)
docker compose logs -f nginx   # tail logs for a service
```

A `.env` file (gitignored) must define `DB_PASSWORD`, consumed by the `postgres` service in [docker-compose.yml](docker-compose.yml).

[deploy.sh](deploy.sh) wraps the above as `./deploy.sh {start|stop|restart|status|log} [service]` (referenced by `README.md`'s install steps).

## Architecture notes

- **Shared network**: all containers join a bridge network named `server`. This is the one stack that publishes ports to the host (`80`/`443` for nginx). Other eduis repos are expected to attach to this same `server` network externally rather than publishing their own ports.
- **nginx → app routing**: [nginx.conf](nginx.conf) proxies `/api` to `http://localhost:8091` and everything else (`/`) to `http://localhost:8092`. These point at the eduis backend/frontend processes, which run outside this compose file (on the host, or another stack) — not at containers reachable by name on the `server` network. Keep this in mind when changing networking: `localhost` inside the nginx container only resolves correctly if nginx is on host networking or there's an equivalent mapping.
- **Certbot ↔ nginx handoff**: certs are issued/renewed via the HTTP-01 webroot method. Both containers share the `webroot` volume (ACME challenge files) and the `certbot-etc`/`certbot-var` volumes (issued certs, read-only in nginx, read-write in certbot). Certbot's entrypoint loops `certbot renew` every 12h instead of running as a one-shot job.
- **Postgres data**: persisted via a host bind mount at `~/postgres-data`, outside the repo and outside Docker-managed volumes.
- **Domain placeholder**: `server_name` in [nginx.conf](nginx.conf) is currently `test.eduis.cz` with an explicit comment marking it as a placeholder to replace for real deployments.
- **Language convention**: existing docs and inline comments (`docker-compose.yml`, `nginx.conf`, `docs/server-infrastructure.md`) are written in Czech. Match this when editing those files.
