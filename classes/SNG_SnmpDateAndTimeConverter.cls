/**
 * This class contains static methods pertaining to SNMP DateAndTime.
 */
public with sharing class SNG_SnmpDateAndTimeConverter 
{
	/**
	 * '+' ASCII value in hexadecimal
	 */
    private static final transient String ASCII_PLUS_HEX = '2b';
    
    /**
	 * '-' ASCII value in hexadecimal
	 */
    private static final transient String ASCII_MINUS_HEX = '2d';
    
    /**
     * Translates the SNMP DateAndTime format to duration in seconds
     *
     * @param   snmpTime               The time in SNMP DateAndTime format
     * return                          The duration between now and the snmpTime
     */
    public static Long translateTimeToDurationFromNow(String snmpTime) {
    	Long durationInSeconds = 0;
    	if (snmpTime != null) {
    		Datetime timeInPast = getDateTime(snmpTime);
    		if (0 < timeInPast.getTime()) {
    			durationInSeconds = (Datetime.now().getTime() - timeInPast.getTime()) / 1000;
    		}
    	}
    	return durationInSeconds;
    }
    
    /**
      * Converts the SNMP DateAndTime format to a DateTime object.
     * The format of the SNMP DateAndTime object as follows:
     * <br />
     * <br />
     *
     * <table border="1">
     * <tr> <th>field</th> <th>octets</th> <th>contents</th> <th>range</th> </tr>
     * <tr> <td align="right">1</td> <td align="right">1-2</td> <td align="right">year*</td>              <td align="right">0..65546</td> </tr>
     * <tr> <td align="right">2</td> <td align="right">3</td>   <td align="right">month</td>              <td align="right">1..12</td>    </tr>
     * <tr> <td align="right">3</td> <td align="right">4</td>   <td align="right">day</td>                <td align="right">1..31</td>    </tr>
     * <tr> <td align="right">4</td> <td align="right">5</td>   <td align="right">hour</td>               <td align="right">0..23</td>    </tr>
     * <tr> <td align="right">5</td> <td align="right">6</td>   <td align="right">minutes</td>            <td align="right">0..23</td>    </tr>
     * <tr> <td align="right">6</td> <td align="right">7</td>   <td align="right">seconds*</td>          <td align="right">0..60</td>    </tr>
     * <tr> <td align="right">7</td> <td align="right">8</td>   <td align="right">deci-seconds</td>       <td align="right">0..9</td>     </tr>
     * <tr> <td align="right">8</td> <td align="right">9</td>   <td align="right">direction from UTC</td> <td align="right">'+'/'-'</td>  </tr>
     * <tr> <td align="right">9</td> <td align="right">10</td>  <td align="right">hours from UTC*</td>     <td align="right">0..13</td>    </tr>
     * <tr> <td align="right">10</td> <td align="right">11</td> <td align="right">minutes from UTC</td>   <td align="right">0..59</td>    </tr>
     * </table>
     * <br />
     * Notes:
     *       - the value of year is in network-byte order
     *       - the value of 60 represents leap seconds.
     *       - daylight saving time in New Zealand is +13
     *
     * @param 	snmpDateAndTime	The stringified date and time in the SNMP DateAndTime format.
     * @return                 	The converted DateTime object.
     * @throws	SNG_Exception  	If there was a parsing error, or the direction from UTC was invalid.
     */
    public static Datetime getDateTime(String snmpDateAndTime) 
    {
        /*
            field  octets  contents                  range
            -----  ------  --------                  -----
              1      1-2   year*                     0..65536
              2       3    month                     1..12
              3       4    day                       1..31
              4       5    hour                      0..23
              5       6    minutes                   0..59
              6       7    seconds                   0..60
                           (use 60 for leap-second)
              7       8    deci-seconds              0..9
              8       9    direction from UTC        '+' / '-'
              9      10    hours from UTC*           0..13
             10      11    minutes from UTC          0..59
        */
        
        try {
            // Extract the individual elements from the string
            snmpDateAndTime = snmpDateAndTime.substring(2); // Take out the 0x
            Integer year = NumberUtils.parseInt(snmpDateAndTime.substring(0, 4), 16);
            Integer month = NumberUtils.parseInt(snmpDateAndTime.substring(4, 6), 16);
            Integer day = NumberUtils.parseInt(snmpDateAndTime.substring(6, 8), 16);
            Integer hour = NumberUtils.parseInt(snmpDateAndTime.substring(8, 10), 16);
            Integer minutes = NumberUtils.parseInt(snmpDateAndTime.substring(10, 12), 16);
            Integer seconds = NumberUtils.parseInt(snmpDateAndTime.substring(12, 14), 16);
            
            // Create Datetime object
            Datetime dateTimeObj = Datetime.newInstanceGmt(year, month, day, hour, minutes, seconds);
            
            // Do conversion to UTC if needed
            Integer hoursFromUtc = NumberUtils.parseInt(snmpDateAndTime.substring(18, 20), 16);
            Integer minutesFromUtc = NumberUtils.parseInt(snmpDateAndTime.substring(20, 22), 16);
            
            if (hoursFromUtc != 0 || minutesFromUtc != 0) {
                final String directionFromUtc = snmpDateAndTime.substring(16, 18);
                 if (directionFromUtc == ASCII_PLUS_HEX) {
                     System.debug('SNG_SnmpDateAndTimeConverter.getDateTime adjusting time backward');
                     dateTimeObj = dateTimeObj.addHours(-hoursFromUtc).addMinutes(-minutesFromUtc);
                 } else if (directionFromUtc == ASCII_MINUS_HEX) {
                     System.debug('SNG_SnmpDateAndTimeConverter.getDateTime adjusting time forward');
                     dateTimeObj = dateTimeObj.addHours(hoursFromUtc).addMinutes(minutesFromUtc);
                 } else {
                     throw new SNG_Exception('SNG_SnmpDateAndTimeConverter.getDateTime: Invalid direction from UTC [' + directionFromUtc + ']');
                 }
             }
             
             System.debug('dateTimeObj hour: ' + dateTimeObj.hour());
             
             return dateTimeObj;
        } catch (Exception e) {
            throw new SNG_Exception('SNG_SnmpDateAndTimeConverter.getDateTime: Parsing Error');
        }
    }
}