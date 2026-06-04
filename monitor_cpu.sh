THRESHOLD=0
ALERT_EMAIL="vijayaraj.innovate@gmail.com"
PARTITION="/"

CPU_LOAD=$(uptime | awk -F'load average:' '{ print $2 }' | cut -d, -f1 | xargs)

if [ "$(echo "$CPU_LOAD >= $THRESHOLD" | bc -l)" -eq 1 ]; then 
    
    MESSAGE="Warning: High CPU load detected on $(hostname).
Current CPU Load: ${CPU_LOAD}

--- TOP 5 SPACE CONSUMERS IN /home ---
$(du -sh /home/* 2>/dev/null | sort -rh | head -n 5)"
    
    echo "Sending email alert for high CPU usage..."
    echo -e "$MESSAGE" | mail -s "ALERT: System CPU Overload Warning on $(hostname) (${CPU_LOAD}%)" "$ALERT_EMAIL" 
    
    logger -p local0.warn "CPU Overload alert: $PARTITION is at ${CPU_LOAD}%" 

fi
