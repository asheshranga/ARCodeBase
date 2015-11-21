/**
 * Formats Salesforce Date and DateTime objects to UTC strings in compliance with ISO-8601.
 */
public with sharing class ISODateAndTimeConverter {
	
	public class ISODateAndTimeException extends Exception { }

	/* Year-Month-Day ISO Date format */
	private static final String ISO_DATE_FORMAT = 'yyyy-MM-dd';
	
	private static final String ISO_DATE_TIME_FORMAT = ISO_DATE_FORMAT + '\'T\'HH:mm:ssXXX';
	
	private static final String ISO_DATE_TIME_FORMAT_GMT = ISO_DATE_FORMAT + '\'T\'HH:mm:ss\'Z\'';

    /**
     * Formats the input date in ISO-8601 UTC format, e.g. : "2014-07-10"
     *
     * @param  date to format
     * @return date in ISO-8601 format
     */
    public static String formatDate(Date d) {
    	Datetime dt = Datetime.newInstance(d.year(), d.month(),d.day());
    	return dt.formatGmt(ISO_DATE_FORMAT);
    }
    
    public static String formatDateTime(DateTime dt) {
    	return dt.format(ISO_DATE_TIME_FORMAT);
    }
    
    public static String formatDateTimeGmt(DateTime dt) {
    	return dt.formatGmt(ISO_DATE_TIME_FORMAT_GMT);
    }
    
    /**
     * Formats the duration provided in seconds into a String in ISO-8601 format, e.g. : "P4DT12H30M5S"
     *
     * @param 	seconds                	Duration in seconds
     * @return	                       	Duration in ISO-8601 format
     * @throws	ISODateAndTimeException	If the provided seconds is invalid
     */
    public static String formatDuration(Long seconds) {
    	if (null == seconds || 0 > seconds)
            throw new ISODateAndTimeException('Invalid Duration: ' + (null == seconds ? 'null' : String.valueOf(seconds)));
    	
    	String isoTime = 'P';
    	
        Long days = seconds / (60 * 60 * 24);
        seconds -= days * (60 * 60 * 24);
        
        Long hours = seconds / 3600;
        seconds -= hours * 3600;
        
        Long minutes = seconds / 60;
        seconds -= minutes * 60;  
      
        isoTime += (days > 0) ? days + 'D' : '';
        isoTime += (hours > 0 || minutes > 0 || seconds > 0) ? 'T' : '';
        isoTime += (hours > 0) ? hours + 'H' : '';
        isoTime += (minutes > 0) ? minutes + 'M' : '';
        isoTime += (seconds > 0) ? seconds + 'S' : '';
        isoTime = ('P' != isoTime) ? isoTime : 'PT0H0M0S';
      
        return isoTime;
    }
}