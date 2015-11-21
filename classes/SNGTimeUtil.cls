public with sharing class SNGTimeUtil 
{
	
	/**
     * Formats the seconds data into a stringified format 
     * (day/hour/minute/second) for display.
     * 
     * @param   second          The seconds data to format.
     * @return                  A stringified time in day/hour/minute/second
     */
    public static String getTimeString(Long seconds) 
    {
        String timeString = '';
        
        if (seconds > 0) {
            Long days = seconds / (60 * 60 * 24);
            if (days > 0) {
                seconds -= days * (60 * 60 * 24);
                timeString += days + ' days';
                if (seconds != 0) {
                    timeString += ', ';
                }
            }
            
            Long hours = seconds / 3600;
            if (hours > 0) {
                seconds -= hours * 3600;
                timeString += hours + ' hours';
                if (seconds != 0) {
                    timeString += ', ';
                }
            }
            
            Long minutes = seconds / 60;
            if (minutes > 0) {
                seconds -= minutes * 60;
                timeString += minutes + ' minutes';
                if (seconds != 0) {
                    timeString += ', ';
                }
            }
            
            if (seconds > 0) {
                timeString += seconds + ' seconds';
            }
        } else {
            timeString = 'Offline';
        }
        
        return timeString;
    }
    
    /**
     * Translates the SNMP DateAndTime format to the apex seconds online.
     *
     * @param   snmpTimeCameOnline     The duration the modem is online in SNMP DateAndTime format.
     * return                          The duration the modem is online in seconds format.
     */
    public static Long translateOnlineTime(String snmpTimeCameOnline) 
    {
        Long secondsOnline = 0;
        if (null != snmpTimeCameOnline && !StringUtils.isEmpty(snmpTimeCameOnline)) 
        {
            Datetime timeCameOnline = SNG_SnmpDateAndTimeConverter.getDateTime(snmpTimeCameOnline);
            if (0 < timeCameOnline.getTime())
                secondsOnline = (Datetime.now().getTime() - timeCameOnline.getTime()) / 1000;
        }
        return secondsOnline;
    }
    

}