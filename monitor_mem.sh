THRESHOLD=0
ALERT_EMAIL="vijayaraj.innovate@gmail.com"
PARTITION="/"

MEM_USAGE_INT=$(free -m | awk 'NR==2{printf "%.0f", $3*100/$2 }')

# 2. Get memory usage for the display message
MEM_USAGE_DISPLAY=$(free -m | awk 'NR==2{printf "%.2f%%", $3*100/$2 }')

# 3. Compare the integer value
if [ "$MEM_USAGE_INT" -ge "$THRESHOLD" ]; then
    
    MESSAGE="Warning: High Memory usage detected on $(hostname).
    Memory Usage = $MEM_USAGE_DISPLAY"
    
    echo "Sending email alert for high memory usage..."
    echo -e "$MESSAGE" | mail -s "ALERT: System Memory Warning on $(hostname) ($MEM_USAGE_DISPLAY)" "$ALERT_EMAIL" 
    
    logger -p local0.warn "Memory usage alert: $MEM_USAGE_DISPLAY" 
fi
