
<p align="center">
  <a href="https://pocketbase.io/">
    <img alt="PocketBase logo" height="128" src="https://pocketbase.io/images/logo.svg">
    <h1 align="center">Docker Image for PocketBase</h1>
  </a>
</p>

<p align="center">
   <a aria-label="Latest PocketBase Version" href="https://github.com/pocketbase/pocketbase/releases" target="_blank">
    <img alt="Latest PocketBase Version" src="https://img.shields.io/github/v/release/pocketbase/pocketbase?color=success&display_name=tag&label=latest&logo=docker&logoColor=%23fff&sort=semver&style=flat-square">
  </a>
  <a aria-label="Supported architectures" href="https://github.com/pocketbase/pocketbase/releases" target="_blank">
    <img alt="Supported Docker architectures" src="https://img.shields.io/badge/platform-amd64%20%7C%20arm64%20%7C%20armv7-brightgreen?style=flat-square&logo=linux&logoColor=%23fff">
  </a>
</p>

---

> [!NOTE]
> This project is based on the work found in [muchobien/pocketbase-docker](https://github.com/muchobien/pocketbase-docker).

## Supported Architectures

Pulling `ghcr.io/keksiqc/pocketbase:latest` will automatically retrieve the appropriate image for your system architecture.

| Architecture | Supported |
|--------------|-----------|
| amd64        | ✅        |
| arm64        | ✅        |
| armv7        | ✅        |

## Version Tags

This image offers multiple tags for different versions. Choose the appropriate tag for your use case and exercise caution when using unstable or development tags.

| Tag    | Available | Description                        |
|--------|-----------|------------------------------------|
| latest | ✅        | Latest stable release of PocketBase |
| x.x.x  | ✅        | Specific patch release             |
| x.x    | ✅        | Minor release                      |
| x      | ✅        | Major release                      |

## Application Setup

Access the web UI at `<your-ip>:8090`. For more details, refer to the [PocketBase Documentation](https://pocketbase.io/docs/).

## Usage

Below are example configurations to get started with a PocketBase container.

### Using Docker Compose (Recommended)

```yaml
version: "3.8"
services:
  pocketbase:
    image: ghcr.io/keksiqc/pocketbase:latest
    container_name: pocketbase
    restart: unless-stopped
    command:
      - --encryptionEnv # optional
      - ENCRYPTION # optional
    environment:
      ENCRYPTION: $(openssl rand -hex 16) # optional (Ensure this is a 32-character long encryption key https://pocketbase.io/docs/going-to-production/#enable-settings-encryption) 
    ports:
      - "8090:8090"
    volumes:
      - /path/to/data:/pb/pb_data
      - /path/to/public:/pb/pb_public # optional
      - /path/to/hooks:/pb/pb_hooks # optional
      - /path/to/migrations:/pb/pb_migrations # optional
    healthcheck: # optional, recommended since v0.10.0
      test: wget --no-verbose --tries=1 --spider http://localhost:8090/api/health || exit 1
      interval: 5s
      timeout: 5s
      retries: 5
```

### Using Docker CLI ([More Info](https://docs.docker.com/engine/reference/commandline/cli/))

```bash
docker run -d \
  --name=pocketbase \
  -p 8090:8090 \
  -e ENCRYPTION=example `# optional` \
  -v /path/to/data:/pb/pb_data \
  -v /path/to/public:/pb/pb_public `# optional` \
  -v /path/to/hooks:/pb/pb_hooks `# optional` \
  -v /path/to/migrations:/pb/pb_migrations `# optional` \
  --restart unless-stopped \
  ghcr.io/keksiqc/pocketbase:latest \
  --encryptionEnv ENCRYPTION `# optional`
```

## Building the Image Locally

To build the image yourself, copy the `Dockerfile` and `docker-compose.yml` to your project directory. Update `docker-compose.yml` to build the image instead of pulling it:

```yaml
version: "3.8"
services:
  pocketbase:
    build:
      context: .
      args:
        - VERSION=0.22.10 # Specify the PocketBase version here
    container_name: pocketbase
    restart: unless-stopped
    command:
      - --encryptionEnv # optional
      - ENCRYPTION # optional
    environment:
      ENCRYPTION: example # optional
    ports:
      - "8090:8090"
    volumes:
      - /path/to/data:/pb_data
      - /path/to/public:/pb_public # optional
      - /path/to/hooks:/pb_hooks # optional
      - /path/to/migrations:/pb_migrations # optional
    healthcheck: # optional, recommended since v0.10.0
      test: wget --no-verbose --tries=1 --spider http://localhost:8090/api/health || exit 1
      interval: 5s
      timeout: 5s
      retries: 5
```

## Related Repositories

- [PocketBase GitHub Repository](https://github.com/pocketbase/pocketbase)
