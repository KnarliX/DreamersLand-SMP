# 🌟 Dreamers Land - vispbyte.com Setup Instructions 🌟

Follow these simple steps to get your Minecraft server running on vispbyte.com:

## 1. Upload Files

Upload all these files to your vispbyte.com Java server:

- `paper.jar` - The main Minecraft server software
- `run.sh` - The simplified startup script
- `eula.txt` - Pre-accepted Minecraft EULA
- `server.properties` - Server configuration
- `server-icon.svg` - Server icon
- `plugins/` folder - Contains GeyserMC and Floodgate for Pocket Edition support

## 2. Set Execution Permissions

In your vispbyte.com console, run:

```bash
chmod +x run.sh
```

## 3. Start the Server

In your vispbyte.com console, run:

```bash
./run.sh
```

## 4. Connect to Your Server

Once running, players can connect using:

- **Java Edition**: Use your server IP and port 25565
- **Pocket Edition**: Use your server IP and port 19132

## Adjusting Memory Settings

If you need to allocate more or less memory to your server:

1. Edit the `run.sh` file
2. Change the `JAVA_MIN_RAM` and `JAVA_MAX_RAM` values
3. Restart your server

## Server Configuration

- **Server Name**: Dreamers Land
- **Game Mode**: Survival
- **Difficulty**: Normal
- **World Seed**: 259097770644189520

Enjoy your Minecraft server on vispbyte.com!