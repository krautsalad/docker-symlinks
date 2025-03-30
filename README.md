# docker-symlinks

Cron-Managed Symlink Utility for Chrooted Paths.

**docker-symlinks** is an Alpine-based Docker container that periodically runs the [symlinks utility](https://github.com/brandt/symlinks) using cron. It optimizes symlinks in your chrooted environment (mounted under /host) by:

- Converting absolute symlinks to relative ones.
- Shortening symlinks.
- Removing broken or mangled symlinks.

This helps maintain a clean and efficient filesystem, especially in environments where symlink management is critical.

## Configuration

### Docker Compose Example

```yaml
# docker-compose.yml
services:
  symlinks:
    container_name: symlinks
    environment:
      SCHEDULE: 0 3 * * *
      TZ: Europe/Berlin
    image: krautsalad/symlinks
    restart: unless-stopped
    volumes:
      - /:/host
      - ./empty:/host/var/lib/docker
```

### Environment Variables

- `SCHEDULE`: Cron schedule for running the utility (default: `0 0 * * *`).
- `TZ`: Timezone setting (default: `UTC`).

## How it works

The container works by copying the statically linked symlinks binary to the host and executing it on the chrooted host. After the utility runs, the copied binary is removed from the host.

The `symlinks` utility is run with the following options:

- `-c`: Convert absolute symlinks to relative ones.
- `-d`: Delete broken or mangled symlinks.
- `-o`: Cross filesystems.
- `-r`: Recursively process directories.
- `-s`: Shorten symlinks.

It operates on the chrooted path `/host`. For correct operation, you must mount your host's root (`/`) to `/host` in the container.

### Excluding Directories

To prevent the utility from processing directories you want to exclude (for example, Docker's storage at `/var/lib/docker`), mount an empty directory over that path. This avoids accidental deletion or modification of essential symlinks.

## Source Code

You can find the full source code on [GitHub](https://github.com/krautsalad/docker-symlinks).
