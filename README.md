# 🎬 OneMediaServer

A fully self-hosted and containerized media automation and monitoring suite powered by Docker Compose. This project provides an end-to-end solution for managing, tracking, and streaming your media content — with built-in automation, monitoring, metrics, and a beautiful dashboard UI.

---

## 📦 Overview

**OneMediaServer** is a modular media server stack designed for home-lab and DevOps-style environments. It leverages Docker Compose for deployment and provides a unified solution with:

- **Media Acquisition & Management** – Radarr, Sonarr, Lidarr, Prowlarr
- **Streaming** – Plex
- **Metadata & Subtitles** – Bazarr
- **Discovery** – Overseerr
- **Monitoring** – Tautulli
- **Reverse Proxy & SSL** – Traefik
- **Dashboards** – Heimdall, Prometheus
- **Metrics** – Prometheus + node_exporter
- **Notifications** – Notifiarr
- **Secrets Management** – External `.env.secrets` file
- **Declarative Configuration** – `.env`, `docker-compose.yml`, and `setup.sh`

---

## 🧰 Services Included

| Service        | Description |
|----------------|-------------|
| **Traefik**    | Reverse proxy and Let's Encrypt SSL manager |
| **Plex**       | Media server (LXC-hosted separately) |
| **Sonarr**     | TV shows manager |
| **Radarr**     | Movies manager |
| **Bazarr**     | Subtitles manager |
| **Prowlarr**   | Indexer manager |
| **Overseerr**  | Media discovery and request manager |
| **Tautulli**   | Plex usage monitoring |
| **Heimdall**   | Landing page and dashboard |
| **Notifiarr**  | Unified push notifications |
| **Prometheus** | Monitoring and scraping service metrics |
| **Node Exporter** | Host metrics collector |
| **RDTClient**  | Real-Debrid download manager |

---

## 📁 Project Structure

```
onemediaserver/
├── docker-compose.yml
├── setup.sh
├── .env.example
├── secrets/
│   └── .env.secrets.example
├── config/
│   ├── traefik/
│   │   ├── traefik.yml
│   │   └── acme.json
│   ├── prometheus/
│   │   └── prometheus.yml
│   └── ...
└── data/
    ├── downloads/
    └── media/
```

---

## 🛠 Prerequisites

- Linux-based system (Ubuntu/Debian recommended)
- Docker + Docker Compose
- Root or `sudo` privileges
- Reverse DNS or a valid domain (e.g. `your.domain.tld`)
- Optional: Real-Debrid account, Plex token

---

## ⚙️ Installation

1. **Clone the repository**:

```bash
git clone https://github.com/yourusername/onemediaserver.git
cd onemediaserver
```

2. **Create environment files**:

```bash
cp .env.example .env
mkdir -p secrets
cp .env.secrets.example secrets/.env.secrets
```

> Edit `.env` to match your environment (paths, domain, timezone, etc.)  
> Edit `secrets/.env.secrets` to provide required API keys and tokens.

3. **Run setup script**:

```bash
chmod +x setup.sh
./setup.sh
```

> This creates directory structures, loads secrets, ensures file permissions, and launches the stack.

---

## 🔐 Secrets Handling

Sensitive credentials are never committed to Git. Instead:

- Use `secrets/.env.secrets` to store:
  - API keys for Tautulli, Overseerr, Notifiarr
  - Plex Token (if needed)
  - Real-Debrid credentials

The file is loaded by `setup.sh` and injected automatically.

---

## 🧪 Monitoring & Metrics

### Prometheus

Prometheus scrapes metrics from services like `node_exporter`, `tautulli`, and others.

**Configuration**:  
`config/prometheus/prometheus.yml`

```yaml
global:
  scrape_interval: ${PROMETHEUS_SCRAPE_INTERVAL:-15s}

scrape_configs:
  - job_name: 'node'
    static_configs:
      - targets: ['host.docker.internal:9100']

  - job_name: 'tautulli'
    metrics_path: /api/v2
    params:
      apikey: [ "${TAUTULLI_API_KEY}" ]
    static_configs:
      - targets: ['tautulli:8181']
```

> Exposed on port `9090` by default (reverse proxied via Traefik if needed).

---

## 🌍 Access Points

After setup, access your services via:

| Service      | URL |
|--------------|-----|
| Traefik Dashboard | `https://traefik.your.domain.tld` |
| Plex          | *(via external LXC instance)* |
| Sonarr        | `https://sonarr.your.domain.tld` |
| Radarr        | `https://radarr.your.domain.tld` |
| Bazarr        | `https://bazarr.your.domain.tld` |
| Overseerr     | `https://overseerr.your.domain.tld` |
| Tautulli      | `https://tautulli.your.domain.tld` |
| Heimdall      | `https://heimdall.your.domain.tld` |
| Prometheus    | `https://prometheus.your.domain.tld` |
| Prowlarr      | `https://prowlarr.your.domain.tld` |

> You can customize the subdomains via labels in `docker-compose.yml`.

---

## 📤 Reverse Proxy & TLS

### Traefik

- Exposes all services via HTTPS using Let's Encrypt
- Configured via `config/traefik/traefik.yml`
- ACME certificates stored in `acme.json` (auto-created by `setup.sh`)

---

## 🧬 Environment Variables

See `.env.example` for all options:

| Variable | Description |
|----------|-------------|
| `PUID`, `PGID` | Permissions for container volumes |
| `TZ` | Timezone |
| `BASE_DIR`, `CONF`, `DATA` | Path management |
| `DOMAIN`, `ACME_EMAIL` | Required for TLS |
| `TRAEFIK_USER`, `TRAEFIK_PASSWORD_HASH` | Dashboard protection |
| `SECRETS_FILE` | Secrets injection |
| `PROMETHEUS_SCRAPE_INTERVAL` | Monitoring frequency |

---

## 🧽 Cleanup

To stop and remove all containers:

```bash
docker compose down
```

To remove volumes as well:

```bash
docker compose down -v
```

---

## 📈 Future Ideas

- Add Grafana for dashboards
- Add Authentik or Authelia for identity provider support
- Add Plex Meta Manager (PMM)
- Add Recyclarr for syncing quality profiles
- Kubernetes support with ArgoCD (GitOps)

---

## 💡 Troubleshooting

- Use `docker compose logs -f <service>` to view logs
- Ensure correct permissions on mounted volumes
- Confirm secrets file is sourced and not empty
- Use `docker exec` to access running containers for debugging

---

## 🛡 Security Tips

- Always use HTTPS (Traefik manages certs for you)
- Store secrets outside Git (`.env.secrets`)
- Change default passwords and credentials
- Restrict access via firewall or VPN

---

## 📜 License

This project is released under the MIT License.

---

## 👨‍💻 Maintained By

**Meir** – Cybersecurity student, DevOps enthusiast, and self-hosting hobbyist.

---
