# AMPTemplates

Custom application templates for [CubeCoders AMP](https://cubecoders.com/AMP), following the format of the official [CubeCoders/AMPTemplates](https://github.com/CubeCoders/AMPTemplates) repository.

## Farming Simulator 25

Generic module template for the Farming Simulator 25 Dedicated Server.

### Important notes

- The FS25 dedicated server is **not a free download**. You must own a copy of Farming Simulator 25 (GIANTS/eshop version recommended — the Steam version is not suitable for headless server use) and a dedicated server licence. The game cannot be installed via SteamCMD.
- The server application is Windows-only. On Linux it runs under Wine (the template uses the `cubecoders/ampbase:wine-stable` container image, which is recommended).
- The server is administered through its own web interface (default port 8080), where savegames, mods and the actual game session are managed. AMP starts/stops `dedicatedServer.exe` and manages the configuration files.

### Setup steps

1. Create the instance from this template and let the first update/install run complete. This creates the directory structure, the Wine prefix (on Linux) and default configuration files.
2. Install Farming Simulator 25 on a Windows PC using the GIANTS installer and activate it with your licence key. Update it to the latest patch and install any DLC you want to use.
3. Copy the **entire installed game folder contents** (containing `dedicatedServer.exe`, `FarmingSimulator2025Game.exe`, the `data` folder, etc.) into the instance's `farming-simulator25/game/` directory (use AMP's file manager or SFTP).
4. On Linux/Wine, the game licence must be activated once inside the Wine prefix. If the server fails to start with a licence error, run the activation once with a display attached (e.g. via `xvfb-run`/VNC inside the container) — see the [wine-gameservers FS25 project](https://github.com/wine-gameservers/arch-fs25server) for reference.
5. Configure the server name, passwords, map and other settings on the instance's configuration pages in AMP.
6. Start the server, then open the web interface at `http://<server-ip>:8080` (login with the configured web interface username/passphrase) to create/select a savegame and start the game session.

### Ports

| Port | Protocol | Purpose |
|------|----------|---------|
| 10823 | TCP+UDP | Game traffic |
| 8080 | TCP | Web interface (HTTP) |
| 8443 | TCP | Web interface (HTTPS, if TLS is enabled) |

### Files

| File | Purpose |
|------|---------|
| `farming-simulator25.kvp` | Main template definition |
| `farming-simulator25config.json` | Settings shown in AMP's configuration UI |
| `farming-simulator25metaconfig.json` | Mapping of settings to the server's XML config files |
| `farming-simulator25ports.json` | Port definitions |
| `farming-simulator25updates.json` | Install/update stages |
| `farming-simulator25dedicatedserver.xml` | Default web interface config (`dedicatedServer.xml`) |
| `farming-simulator25dedicatedserverconfig.xml` | Default game server config (`dedicatedServerConfig.xml`) |

### Using the template in AMP

Create a new instance using the "Generic" module, then in the instance's settings use this repository as a custom template source, or place the template files in AMP's `GenericTemplates` directory and select "Farming Simulator 25" when creating a Generic instance.
