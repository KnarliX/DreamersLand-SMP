# 🌟 Dreamers Land - Minecraft Server Hosting Guide 🌟

This guide provides detailed instructions for setting up your Dreamers Land Minecraft server on [vispbyte.com](https://vispbyte.com/) or other hosting providers.

## Hosting on vispbyte.com

vispbyte.com is recommended for hosting your Minecraft server because of its reliability, performance, and ease of use.

### Step 1: Sign Up and Create a Server

1. Register an account at [vispbyte.com](https://vispbyte.com/)
2. Choose a Minecraft hosting plan (recommended: at least 2GB RAM)
3. Select your server location (choose one closest to most players)
4. Complete the purchase process

### Step 2: Upload Server Files

1. Connect to your server using the File Manager or SFTP details provided by vispbyte.com
2. Upload all the files from this repository to your server:
   - `start.sh` (Main startup script)
   - `server.properties` (Server configuration)
   - `server-icon.svg` (Server icon)
   - Any other files included in the download

### Step 3: Setup and Start the Server

1. Access your server control panel
2. Open the terminal/console
3. Make the startup script executable:
   ```bash
   chmod +x start.sh
   ```
4. Run the startup script:
   ```bash
   ./start.sh
   ```
5. The script will check for Java, download required files, and start the server

### Step 4: Configure Your Server (Optional)

Through the vispbyte.com control panel, you can:
- Adjust server memory allocation
- Schedule automatic restarts
- Create backups
- Monitor server performance

## Hosting on Other Providers

If you're using a different hosting provider, the general process is similar:

1. Ensure your hosting provider supports Java 17 or higher
2. Upload all files from this repository
3. Make the startup script executable (`chmod +x start.sh`)
4. Run the startup script (`./start.sh`)

## Self-Hosting (Advanced)

If you're hosting the server on your own hardware:

1. Install a Linux distribution (Ubuntu Server recommended)
2. Install Java 17 or higher:
   ```bash
   sudo apt update
   sudo apt install openjdk-17-jre-headless
   ```
3. Download this repository to your server
4. Make the startup script executable:
   ```bash
   chmod +x start.sh
   ```
5. Run the startup script:
   ```bash
   ./start.sh
   ```
6. Configure port forwarding on your router:
   - Port 25565 (TCP) for Java Edition
   - Port 19132 (UDP) for Bedrock Edition

## Optimizing Performance

For better server performance:

1. Edit `start.sh` and increase `JAVA_MIN_RAM` and `JAVA_MAX_RAM` based on available memory
2. Reduce `view-distance` in `server.properties` if experiencing lag
3. Consider using a wired internet connection instead of Wi-Fi if self-hosting

## Troubleshooting

- **Java errors**: Make sure Java 17+ is installed and in the system PATH
- **Connection issues**: Check that ports are properly forwarded/allowed
- **Performance problems**: Reduce server settings or increase allocated memory
- **Plugin errors**: Check for plugin updates or conflicts

For specific vispbyte.com hosting issues, contact their customer support team for assistance.