# 🌟 Dreamers Land - Minecraft Server 🌟

A fully automated Minecraft server setup supporting both Java Edition and Bedrock Edition (Pocket Edition) players. Perfect for hosting on [vispbyte.com](https://vispbyte.com/) or other hosting providers.

## Features

- **Cross-Platform Play**: Java and Bedrock players can play together seamlessly
- **Easy Setup**: Single bash script handles everything
- **Optimized Performance**: Configured for minimal resource usage
- **Automatic Configuration**: No manual setup required
- **Hosting-Ready**: Designed to work on vispbyte.com or similar hosting services

## Requirements

- **Java 17 or higher** installed on your hosting service
- Internet connectivity for downloading server files
- Port forwarding for 25565 (TCP) and 19132 (UDP) if hosting at home

## Hosting on vispbyte.com

1. Upload these files to your vispbyte.com hosting account
2. Ensure Java 17+ is available (contact support if needed)
3. Download necessary files (not included in the repository due to size):
   - For paper.jar, the `start.sh` script will automatically download it
   - For GeyserMC and Floodgate plugins, they'll be downloaded automatically by `start.sh`
4. Make the script executable and run it:
   ```bash
   chmod +x start.sh
   ./start.sh
   ```
5. The server will start automatically and display connection information

## Local Testing

1. Clone or download this repository
2. Make the script executable:
   ```bash
   chmod +x start.sh
   ```
3. Run the script (it will automatically download required files):
   ```bash
   ./start.sh
   ```
4. Wait for the server to start (this may take a few minutes on first run as it downloads required files)
5. Connect to the server using the displayed IP addresses and ports

## Connection Details

After starting the server, you'll see connection information:

- **Java Edition**: Connect using the displayed IP and port (default: 25565)
- **Bedrock Edition**: Connect using the displayed IP and port (default: 19132)

## World Information

- **Seed**: 259097770644189520
- **Gamemode**: Survival
- **Difficulty**: Normal

## Customization

You can modify the following variables in the `start.sh` script:

- `JAVA_MIN_RAM` and `JAVA_MAX_RAM`: Adjust server memory usage (increase as needed)
- `MINECRAFT_VERSION`: Change the Minecraft version
- `SERVER_PORT`: Change the Java Edition port
- `BEDROCK_PORT`: Change the Bedrock Edition port

## Troubleshooting

- **Server won't start**: Ensure Java 17+ is installed correctly on your hosting
- **Can't connect from Bedrock**: Check if port 19132 (UDP) is open in your firewall/router
- **Can't connect from Java**: Check if port 25565 (TCP) is open in your firewall/router
- **Performance issues**: Try adjusting memory allocation in the start.sh script

## License

This project is provided as-is, free to use and modify.

## Acknowledgements

- [PaperMC](https://papermc.io/) - High-performance Minecraft server
- [GeyserMC](https://geysermc.org/) - Bedrock to Java connector
- [Floodgate](https://github.com/GeyserMC/Floodgate) - Authentication system for Bedrock players
- [vispbyte.com](https://vispbyte.com/) - Recommended hosting provider
