/*
*   Initial Author: Sujit Kumar
*
*   Set of utility methods to deal with dates and times.
*/
public with sharing class DateUtils {
	
   public static DateTime getYesterday(Integer hours, Integer minutes, Integer secs) {
      Date today = Date.today();
      Date yesterday = today.addDays(-1);
      Time myTime = Time.newInstance(hours, minutes, secs, 0);
      return DateTime.newInstance(yesterday, myTime);
   } 
   
   public static DateTime GetDateAnYearBack() {
      Date today = Date.today();
      Date dateAsOfLastYear = today.addYears(-1);
      Time myTime = Time.newInstance(0, 0, 0, 0);
      return DateTime.newInstance(dateAsOfLastYear, myTime);
   }
   
   public static Date convertDateTimeToDate(Datetime myDateTime) {
      return date.newinstance(myDateTime.year(), myDateTime.month(), myDateTime.day());
   }
   
   public static String getDateTimeAsMMDDYYYY(Datetime myDateTime) {
      return myDateTime.format('MM/dd/YYYY');
   }
   
   public static String getYesterdayAsMMDDYYYY() {
      Date today = Date.today();
      Date yesterday = today.addDays(-1);
      Time myTime = Time.newInstance(0, 0, 0, 0);
      DateTime myYesterday = DateTime.newInstance(yesterday, myTime);
      return myYesterday.format('MM/dd/YYYY');
   }
   
   public static String getYesterdayAsDDMMYYYY() {
      Date today = Date.today();
      Date yesterday = today.addDays(-1);
      Time myTime = Time.newInstance(0, 0, 0, 0);
      DateTime myYesterday = DateTime.newInstance(yesterday, myTime);
      return myYesterday.format('dd/MM/YYYY');
   }   
}