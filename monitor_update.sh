#!/bin/bash 

# --- CONFIGURATION --- 
THRESHOLD=0
ALERT_EMAIL="vijayaraj.innovate@gmail.com" 
PARTITION="/" 
# --------------------- 

# 1. Get disk usage
USAGE=$(df -h "$PARTITION" | awk 'NR==2 {print $5}' | sed 's/%//') 

# 2. Get CPU load (average over 1 minute)
CPU_LOAD=$(uptime | awk -F'load average:' '{ print $2 }' | cut -d, -f1 | xargs)

# 3. Get Memory usage (using free command)
MEM_USAGE=$(free -m | awk 'NR==2{printf "%.2f%%", $3*100/$2 }')

# Check if usage is greater than or equal to the threshold 
if [ "$USAGE" -ge "$THRESHOLD" ]; then 
    
    MESSAGE="Warning: Partition '$PARTITION' is at ${USAGE}% capacity on $(hostname).

--- SYSTEM OVERVIEW ---
CPU Load (1m): $CPU_LOAD
Memory Usage: $MEM_USAGE

--- TOP 5 SPACE CONSUMERS IN /home ---
$(du -sh /home/* 2>/dev/null | sort -rh | head -n 5)"
    
    echo "Sending email alert for high disk usage..."
    echo -e "$MESSAGE" | mail -s "ALERT: System Resource Warning on $(hostname) (${USAGE}%)" "$ALERT_EMAIL" 
    
    logger -p local0.warn "Disk space alert: $PARTITION is at ${USAGE}%" 

fi
