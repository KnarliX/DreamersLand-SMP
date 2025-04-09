#!/bin/bash

# Dreamers Land - Minecraft Server Start Script
# Simplified version for vispbyte.com Java server

# Server configuration
JAVA_MIN_RAM="1G"
JAVA_MAX_RAM="2G"

# Banner function
display_banner() {
    echo "================================================================="
    echo "      🌟 Dreamers Land - Minecraft Server 🌟"
    echo "================================================================="
    echo "Starting server with Java..."
    echo "If you need to adjust memory settings, edit JAVA_MIN_RAM and JAVA_MAX_RAM in this script"
    echo "================================================================="
}

# Get server IP address
get_ip() {
    PUBLIC_IP=$(hostname -I | awk '{print $1}' 2>/dev/null)
    if [ -z "$PUBLIC_IP" ]; then
        PUBLIC_IP="your-server-ip"
    fi
    echo "$PUBLIC_IP"
}

# Main function
main() {
    display_banner
    
    # Set up EULA if not already accepted
    if [ ! -f "eula.txt" ] || ! grep -q "eula=true" eula.txt; then
        echo "eula=true" > eula.txt
        echo "EULA accepted automatically."
    fi
    
    # Get server IP for the message
    SERVER_IP=$(get_ip)
    
    # Display connection information
    echo "Java Edition: ${SERVER_IP}:25565"
    echo "Bedrock Edition (via Geyser): ${SERVER_IP}:19132"
    echo "Join with your mobile device easily!"
    echo "================================================================="
    
    # Start the server with optimized settings
    java -Xms${JAVA_MIN_RAM} -Xmx${JAVA_MAX_RAM} \
         -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 \
         -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch \
         -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M \
         -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 \
         -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 \
         -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem \
         -XX:MaxTenuringThreshold=1 -jar paper.jar --nogui
}

# Run the main function
main