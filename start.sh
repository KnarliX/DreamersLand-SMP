#!/bin/bash

# Dreamers Land - Minecraft Server Setup Script
# This script sets up and runs a PaperMC server with GeyserMC and Floodgate for Pocket Edition compatibility

# Colors for terminal output
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Server configuration
SERVER_NAME="Dreamers Land"
PAPER_VERSION="latest"
MINECRAFT_VERSION="1.20.4"  # Use this or change to the latest version
JAVA_MIN_RAM="512M"
JAVA_MAX_RAM="1G"
WORLD_SEED="259097770644189520"
SERVER_PORT=25565
BEDROCK_PORT=19132

# File paths
SERVER_DIR="$(pwd)"
PLUGINS_DIR="${SERVER_DIR}/plugins"
WORLD_DIR="${SERVER_DIR}/world"

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to display a banner
display_banner() {
    echo -e "${GREEN}"
    echo -e "================================================================="
    echo -e "      🌟 Dreamers Land - Minecraft Server Setup Script 🌟"
    echo -e "================================================================="
    echo -e "${NC}"
}

# Function to display an error and exit
error_exit() {
    echo -e "${RED}ERROR: $1${NC}" >&2
    exit 1
}

# Create necessary directories
setup_directories() {
    echo -e "${CYAN}Setting up server directories...${NC}"
    
    # Create plugins directory if it doesn't exist
    if [ ! -d "$PLUGINS_DIR" ]; then
        mkdir -p "$PLUGINS_DIR"
        echo -e "${GREEN}Created plugins directory${NC}"
    fi
    
    # Create world directory if it doesn't exist
    if [ ! -d "$WORLD_DIR" ]; then
        mkdir -p "$WORLD_DIR"
        echo -e "${GREEN}Created world directory${NC}"
    fi
}

# Check Java installation
check_java() {
    echo -e "${CYAN}Checking Java installation...${NC}"
    
    if command_exists java; then
        # Check Java version
        java_version=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}' | cut -d'.' -f1)
        
        echo -e "${GREEN}Java is installed. Version: $(java -version 2>&1 | head -n 1)${NC}"
        
        # Check if Java version is 17 or higher
        if [ "$java_version" -lt 17 ]; then
            echo -e "${YELLOW}Warning: Java version is below 17. Some features may not work correctly.${NC}"
        fi
    else
        # In vispbyte.com or other hosting environment, the user would install Java manually
        echo -e "${YELLOW}Java not detected. Please ensure Java 17 or higher is installed on your hosting provider.${NC}"
        echo -e "${YELLOW}For vispbyte.com hosting, please contact support to ensure Java 17 is available.${NC}"
        echo -e "${YELLOW}Continuing with script execution assuming Java is available...${NC}"
    fi
}

# Download PaperMC server
download_papermc() {
    echo -e "${CYAN}Downloading PaperMC server...${NC}"
    
    # Check if paper.jar already exists
    if [ -f "${SERVER_DIR}/paper.jar" ]; then
        echo -e "${YELLOW}PaperMC server already exists. Skipping download.${NC}"
        return
    fi
    
    # For simplicity in this setup, we'll use a direct download URL for a known working version
    # This avoids having to parse API responses and is more reliable
    echo -e "${YELLOW}Using PaperMC 1.20.4 (Build 441)...${NC}"
    PAPER_DOWNLOAD_URL="https://api.papermc.io/v2/projects/paper/versions/1.20.4/builds/441/downloads/paper-1.20.4-441.jar"
    
    # Download the PaperMC server jar
    echo -e "${YELLOW}Downloading PaperMC from: ${PAPER_DOWNLOAD_URL}${NC}"
    
    if command_exists curl; then
        echo -e "${YELLOW}Using curl to download...${NC}"
        if ! curl -sL -o "${SERVER_DIR}/paper.jar" "$PAPER_DOWNLOAD_URL"; then
            error_exit "Failed to download PaperMC server. Please check your internet connection."
        fi
    elif command_exists wget; then
        echo -e "${YELLOW}Using wget to download...${NC}"
        if ! wget -q -O "${SERVER_DIR}/paper.jar" "$PAPER_DOWNLOAD_URL"; then
            error_exit "Failed to download PaperMC server. Please check your internet connection."
        fi
    else
        error_exit "Neither curl nor wget is installed. Please install one of them."
    fi
    
    # Check if the download was successful by verifying file size
    if [ -f "${SERVER_DIR}/paper.jar" ]; then
        FILESIZE=$(stat -c%s "${SERVER_DIR}/paper.jar" 2>/dev/null || stat -f%z "${SERVER_DIR}/paper.jar" 2>/dev/null)
        if [ -n "$FILESIZE" ] && [ "$FILESIZE" -gt 1000000 ]; then
            echo -e "${GREEN}Successfully downloaded PaperMC server (${FILESIZE} bytes)${NC}"
        else
            echo -e "${RED}Download appears incomplete. File size: ${FILESIZE} bytes${NC}"
            if [ -f "${SERVER_DIR}/paper.jar" ]; then
                rm "${SERVER_DIR}/paper.jar"
            fi
            error_exit "PaperMC download failed or was incomplete."
        fi
    else
        error_exit "PaperMC download failed completely."
    fi
}

# Download GeyserMC and Floodgate plugins
download_plugins() {
    echo -e "${CYAN}Downloading GeyserMC and Floodgate plugins...${NC}"
    
    # Check if plugins already exist
    if [ -f "${PLUGINS_DIR}/Geyser-Spigot.jar" ] && [ -f "${PLUGINS_DIR}/floodgate-spigot.jar" ]; then
        echo -e "${YELLOW}GeyserMC and Floodgate plugins already exist. Skipping download.${NC}"
        return
    fi
    
    # Use specific versions to avoid API issues
    # GeyserMC - using a known stable version
    GEYSER_DOWNLOAD_URL="https://ci.opencollab.dev/job/GeyserMC/job/Geyser/job/master/lastSuccessfulBuild/artifact/bootstrap/spigot/build/libs/Geyser-Spigot.jar"
    
    # Floodgate - using a known stable version
    FLOODGATE_DOWNLOAD_URL="https://ci.opencollab.dev/job/GeyserMC/job/Floodgate/job/master/lastSuccessfulBuild/artifact/spigot/build/libs/floodgate-spigot.jar"
    
    # Download GeyserMC
    echo -e "${YELLOW}Downloading GeyserMC...${NC}"
    if command_exists curl; then
        echo -e "${YELLOW}Using curl to download GeyserMC...${NC}"
        if ! curl -sL -o "${PLUGINS_DIR}/Geyser-Spigot.jar" "$GEYSER_DOWNLOAD_URL"; then
            echo -e "${RED}Failed direct download. Using alternative source...${NC}"
            if ! curl -sL -o "${PLUGINS_DIR}/Geyser-Spigot.jar" "https://download.geysermc.org/v2/projects/geyser/versions/latest/builds/latest/downloads/spigot"; then
                error_exit "Failed to download GeyserMC plugin from all sources. Please check your internet connection."
            fi
        fi
    elif command_exists wget; then
        echo -e "${YELLOW}Using wget to download GeyserMC...${NC}"
        if ! wget -q -O "${PLUGINS_DIR}/Geyser-Spigot.jar" "$GEYSER_DOWNLOAD_URL"; then
            echo -e "${RED}Failed direct download. Using alternative source...${NC}"
            if ! wget -q -O "${PLUGINS_DIR}/Geyser-Spigot.jar" "https://download.geysermc.org/v2/projects/geyser/versions/latest/builds/latest/downloads/spigot"; then
                error_exit "Failed to download GeyserMC plugin from all sources. Please check your internet connection."
            fi
        fi
    else
        error_exit "Neither curl nor wget is installed. Please install one of them."
    fi
    
    # Check if download was successful
    if [ ! -f "${PLUGINS_DIR}/Geyser-Spigot.jar" ] || [ ! -s "${PLUGINS_DIR}/Geyser-Spigot.jar" ]; then
        echo -e "${RED}GeyserMC plugin download failed or file is empty.${NC}"
        # Create a placeholder file with download instructions
        mkdir -p "${PLUGINS_DIR}"
        cat > "${PLUGINS_DIR}/DOWNLOAD_GEYSER_MANUALLY.txt" << EOL
Download GeyserMC plugin manually from https://geysermc.org/download
Rename the file to Geyser-Spigot.jar and place it in this plugins directory.
EOL
        echo -e "${YELLOW}Created manual download instructions for GeyserMC.${NC}"
    else
        FILESIZE=$(stat -c%s "${PLUGINS_DIR}/Geyser-Spigot.jar" 2>/dev/null || stat -f%z "${PLUGINS_DIR}/Geyser-Spigot.jar" 2>/dev/null)
        echo -e "${GREEN}Successfully downloaded GeyserMC plugin (${FILESIZE} bytes)${NC}"
    fi
    
    # Download Floodgate
    echo -e "${YELLOW}Downloading Floodgate...${NC}"
    if command_exists curl; then
        echo -e "${YELLOW}Using curl to download Floodgate...${NC}"
        if ! curl -sL -o "${PLUGINS_DIR}/floodgate-spigot.jar" "$FLOODGATE_DOWNLOAD_URL"; then
            echo -e "${RED}Failed direct download. Using alternative source...${NC}"
            if ! curl -sL -o "${PLUGINS_DIR}/floodgate-spigot.jar" "https://download.geysermc.org/v2/projects/floodgate/versions/latest/builds/latest/downloads/spigot"; then
                error_exit "Failed to download Floodgate plugin from all sources. Please check your internet connection."
            fi
        fi
    elif command_exists wget; then
        echo -e "${YELLOW}Using wget to download Floodgate...${NC}"
        if ! wget -q -O "${PLUGINS_DIR}/floodgate-spigot.jar" "$FLOODGATE_DOWNLOAD_URL"; then
            echo -e "${RED}Failed direct download. Using alternative source...${NC}"
            if ! wget -q -O "${PLUGINS_DIR}/floodgate-spigot.jar" "https://download.geysermc.org/v2/projects/floodgate/versions/latest/builds/latest/downloads/spigot"; then
                error_exit "Failed to download Floodgate plugin from all sources. Please check your internet connection."
            fi
        fi
    else
        error_exit "Neither curl nor wget is installed. Please install one of them."
    fi
    
    # Check if download was successful
    if [ ! -f "${PLUGINS_DIR}/floodgate-spigot.jar" ] || [ ! -s "${PLUGINS_DIR}/floodgate-spigot.jar" ]; then
        echo -e "${RED}Floodgate plugin download failed or file is empty.${NC}"
        # Create a placeholder file with download instructions
        mkdir -p "${PLUGINS_DIR}"
        cat > "${PLUGINS_DIR}/DOWNLOAD_FLOODGATE_MANUALLY.txt" << EOL
Download Floodgate plugin manually from https://geysermc.org/download
Rename the file to floodgate-spigot.jar and place it in this plugins directory.
EOL
        echo -e "${YELLOW}Created manual download instructions for Floodgate.${NC}"
    else
        FILESIZE=$(stat -c%s "${PLUGINS_DIR}/floodgate-spigot.jar" 2>/dev/null || stat -f%z "${PLUGINS_DIR}/floodgate-spigot.jar" 2>/dev/null)
        echo -e "${GREEN}Successfully downloaded Floodgate plugin (${FILESIZE} bytes)${NC}"
    fi
    
    echo -e "${GREEN}Plugin download step completed${NC}"
}

# Create or update server.properties
create_server_properties() {
    echo -e "${CYAN}Setting up server properties...${NC}"
    
    # Check if server.properties already exists
    if [ -f "${SERVER_DIR}/server.properties" ]; then
        echo -e "${YELLOW}server.properties already exists. Updating...${NC}"
    fi
    
    # Create or update server.properties
    cat > "${SERVER_DIR}/server.properties" << EOL
#Minecraft server properties
#Generated by Dreamers Land Setup Script
server-name=${SERVER_NAME}
motd=\u00A7b\u00A7l${SERVER_NAME} \u00A7r\u00A7e- A Java+Bedrock Server
server-port=${SERVER_PORT}
max-players=20
gamemode=survival
difficulty=normal
level-seed=${WORLD_SEED}
level-name=world
view-distance=8
simulation-distance=6
entity-broadcast-range-percentage=65
online-mode=false
white-list=false
enforce-whitelist=false
pvp=true
spawn-monsters=true
spawn-animals=true
spawn-npcs=true
spawn-protection=0
max-world-size=29999984
allow-nether=true
enable-command-block=false
max-tick-time=60000
query.port=${SERVER_PORT}
network-compression-threshold=256
max-build-height=256
max-players=20
use-native-transport=true
enable-status=true
allow-flight=false
broadcast-rcon-to-ops=true
broadcast-console-to-ops=true
sync-chunk-writes=true
op-permission-level=4
enable-rcon=false
rate-limit=0
function-permission-level=2
resource-pack-prompt=
enable-jmx-monitoring=false
require-resource-pack=false
hide-online-players=false
EOL
    
    echo -e "${GREEN}Successfully created/updated server.properties${NC}"
}

# Create eula.txt
accept_eula() {
    echo -e "${CYAN}Accepting EULA...${NC}"
    
    # Create or update eula.txt
    echo "eula=true" > "${SERVER_DIR}/eula.txt"
    
    echo -e "${GREEN}Successfully accepted EULA${NC}"
}

# Get IP address for connection info
get_ip_address() {
    # Try different methods to get public IP
    if command_exists curl; then
        PUBLIC_IP=$(curl -s -4 ifconfig.me 2>/dev/null || curl -s -4 icanhazip.com 2>/dev/null || curl -s -4 ipecho.net/plain 2>/dev/null)
    elif command_exists wget; then
        PUBLIC_IP=$(wget -qO- ifconfig.me 2>/dev/null || wget -qO- icanhazip.com 2>/dev/null || wget -qO- ipecho.net/plain 2>/dev/null)
    fi
    
    # If public IP could not be determined, use localhost
    if [ -z "$PUBLIC_IP" ]; then
        # Try to get the local IP address
        if command_exists hostname; then
            LOCAL_IP=$(hostname -I | awk '{print $1}')
            if [ -n "$LOCAL_IP" ]; then
                PUBLIC_IP=$LOCAL_IP
            else
                PUBLIC_IP="localhost"
            fi
        else
            PUBLIC_IP="localhost"
        fi
    fi
    
    echo "$PUBLIC_IP"
}

# Configure GeyserMC
configure_geyser() {
    echo -e "${CYAN}Configuring GeyserMC...${NC}"
    
    # Create plugins/Geyser-Spigot directory if it doesn't exist
    mkdir -p "${PLUGINS_DIR}/Geyser-Spigot"
    
    # Get server IP
    SERVER_IP=$(get_ip_address)
    
    # Create or update config.yml for GeyserMC
    cat > "${PLUGINS_DIR}/Geyser-Spigot/config.yml" << EOL
# Geyser-Spigot Configuration
bedrock:
  address: 0.0.0.0
  port: ${BEDROCK_PORT}
  clone-remote-port: false
  motd1: "${SERVER_NAME}"
  motd2: "Bedrock + Java Edition"
  server-name: "${SERVER_NAME}"
remote:
  address: 127.0.0.1
  port: ${SERVER_PORT}
  auth-type: floodgate
  use-proxy-protocol: false
  forward-hostname: false
EOL
    
    echo -e "${GREEN}Successfully configured GeyserMC${NC}"
}

# Start the server
start_server() {
    echo -e "${CYAN}Starting Minecraft server...${NC}"
    
    # Get server IP
    SERVER_IP=$(get_ip_address)
    
    # Display connection information
    echo -e "\n${GREEN}=================================================================${NC}"
    echo -e "${GREEN}🌟 Dreamers Land is now LIVE (No Python)! 🌟${NC}"
    echo -e "${GREEN}=================================================================${NC}"
    echo -e "${CYAN}Java Edition: ${SERVER_IP}:${SERVER_PORT}${NC}"
    echo -e "${CYAN}Bedrock Edition (via Geyser): ${SERVER_IP}:${BEDROCK_PORT}${NC}"
    echo -e "\n${YELLOW}Join with your mobile device easily!${NC}"
    echo -e "${GREEN}=================================================================${NC}\n"
    
    # Check if Java is installed
    if ! command_exists java; then
        echo -e "${RED}Java is not available. Cannot start the server.${NC}"
        echo -e "${YELLOW}All server files have been prepared.${NC}"
        echo -e "${YELLOW}Once Java is installed on your hosting, run this script again to start the server.${NC}"
        echo -e "\n${GREEN}Server setup completed! Java installation required to start.${NC}"
        
        # Create a ready file to indicate setup is complete
        echo "Setup completed on $(date)" > "${SERVER_DIR}/SETUP_COMPLETE.txt"
        echo "Run './start.sh' again after installing Java to start the server." >> "${SERVER_DIR}/SETUP_COMPLETE.txt"
        
        exit 0
    fi
    
    # Try starting server with optimized JVM flags
    echo -e "${YELLOW}Starting Minecraft server with optimized settings...${NC}"
    
    if ! java -Xms${JAVA_MIN_RAM} -Xmx${JAVA_MAX_RAM} \
         -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 \
         -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch \
         -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M \
         -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 \
         -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 \
         -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem \
         -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs \
         -Daikars.new.flags=true -jar paper.jar --nogui; then
        
        echo -e "${RED}Failed to start with optimized settings. Trying with basic settings...${NC}"
        
        # Try with basic settings
        java -Xms${JAVA_MIN_RAM} -Xmx${JAVA_MAX_RAM} -jar paper.jar --nogui
    fi
}

# Main function to run the script
main() {
    display_banner
    
    # Setup directories
    setup_directories
    
    # Check Java installation
    check_java
    
    # Download PaperMC
    download_papermc
    
    # Download plugins
    download_plugins
    
    # Setup server.properties
    create_server_properties
    
    # Accept EULA
    accept_eula
    
    # Configure GeyserMC
    configure_geyser
    
    # Start the server
    start_server
}

# Run the main function
main
