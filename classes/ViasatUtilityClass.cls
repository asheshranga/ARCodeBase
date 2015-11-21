/*
Author: Rajesh
Project: Viasat NBNCo Customer Portal
Date: Oct 2013
Updated: November 2014
Purpose: Common Methods: Time, Business Hours, Email, Timer related methods
*/
global class ViasatUtilityClass
{
    Public static boolean isRunTestNBNCoTrigger = True; //Static variable for Prevent trigger(ViaSatUpdateHoursUsedAndCaseCounts) execution for test method
    Public static boolean isPreventTriggerLooping = True;//Static variable for prevent trigger(ViaSatUpdateCaseStatusTime)looping
      
    //------------------------------------------------------------------------------------
    // RETURNS map<recordType.ID, recordType.Name> with object's record types visible to the currect User 
    // EX: map<id, string> availableRecordTypes = ViasatTestUtility.getAvailableRecordTypes(Site__c.SObjectType);
    //------------------------------------------------------------------------------------
    static public map<string,id> getAvailableRecordTypes(Schema.SObjectType sObjType) 
    {      
        map<string, id> availableRecordTypes = new map<string, id>();

        Schema.DescribeSObjectResult r = sObjType.getDescribe();
        String soql = 'SELECT Id, Name FROM RecordType WHERE SObjectType = \'' + r.getName() + '\' AND IsActive = TRUE';
        list<RecordType> results = Database.query(soql);
        if (results != null && results.size() > 0)
        {       
            Map<Id,Schema.RecordTypeInfo> recordTypeInfos = r.getRecordTypeInfosByID();
            for(RecordType rt : results)
            {
                if (recordTypeInfos.get(rt.Id).isAvailable()) 
                    availableRecordTypes.put(rt.Name,rt.Id);
            }
        }
        return availableRecordTypes;
    }

    //------------------------------------------------------------------------------
    //------------------------------------------------------------------------------
    public static Time GetElapsedTime(Time startTime, Time endTime)
    {
        if(startTime == null || endTime == null)    return Time.newInstance(0, 0, 0, 0);

        Integer elapsedHours = endTime.hour() - startTime.hour();
        Integer elapsedMinutes = endTime.minute() - startTime.minute();
        Integer elapsedSeconds = endTime.second() - startTime.second();
        Integer elapsedMiliseconds = endTime.millisecond() - startTime.millisecond();
        return Time.newInstance(elapsedHours, elapsedMinutes, elapsedSeconds, elapsedMiliseconds);
    }     

    public static Integer GetSecondsElapsed(DateTime startDt, DateTime endDt)
    {
        return GetElapsedTime(startDt.time(), endDt.time()).second();
    }
    public static Integer GetMinutesElapsed(DateTime startDt, DateTime endDt)
    {
        return GetElapsedTime(startDt.time(), endDt.time()).minute();
    }
    public static Integer GetHoursElapsed(DateTime startDt, DateTime endDt)
    {
        return GetElapsedTime(startDt.time(), endDt.time()).hour();
    }

    //------------------------------------------------------------------------------
    // Returns currentDate if it is a working day else the next working day.
    // If List<Holiday> is not set then it checks only for weekend days else checks for holidays as well
    //------------------------------------------------------------------------------
    public static DateTime getWorkDay(DateTime currentDate, List<Holiday> holidays)
    {
        DateTime workDay = currentDate;     
        while (isWorkDay(date.newinstance(workDay.year(), workDay.month(), workDay.day()), holidays) == false)
        {
            workDay = workDay.addDays(1);   
        }
        return workDay;
    }
    
    //------------------------------------------------------------------------------
    // Returns number of days till the next working day. If currentDate is a working day then it returns 0.
    // If List<Holiday> is not set then it checks only for weekend days else checks for holidays as well
    //------------------------------------------------------------------------------
    public static integer getNumOfDaysToNextWorkDay(DateTime currentDate, List<Holiday> holidays)
    {
        DateTime workDay = currentDate;
        integer i = 0;      
        while (isWorkDay(date.newinstance(workDay.year(), workDay.month(), workDay.day()), holidays) == false)
        {
            workDay = workDay.addDays(1);
            i++;    
        }
        return i;
    }

    //------------------------------------------------------------------------------
    // Checks if currentDate is a working day.
    // If List<Holiday> is not set then it checks only for weekend days else checks for holidays as well
    //------------------------------------------------------------------------------
    public static boolean isWorkDay(Date currentDate, List<Holiday> holidays)
    {
        Date weekStart  = currentDate.toStartofWeek();
        if (weekStart.daysBetween(currentDate) == 0 || weekStart.daysBetween(currentDate) == 6)
            return false;
        
        if (!holidays.isEmpty())
        {
            for (Holiday hDay:holidays)
            {
                if (currentDate.daysBetween(hDay.ActivityDate) == 0)
                    return false;
            }
        }
        return true;
    }

    //------------------------------------------------------------------------------
    // Check if it is SFDC ID
    //------------------------------------------------------------------------------
    public static String validateId(String Idparam) 
    {
        String id = String.escapeSingleQuotes(Idparam);
        if((id.length() == 15 || id.length() == 18) && Pattern.matches('^[a-zA-Z0-9]*$', id))
            return id;
        return null;
    }

    // -----------------------------------------------------------------------------------------------
    // Returns rest params (things after the main url, separated by /)
    // https://viasat--devatlas.cs3.my.salesforce.com/services/apexrest/API/subscriber/{internalReferencence}/billing
    // req.requestURI = '/API/subscriber/{internalReferencence}/billing'
    //      
    //list<string> uriKeys = ExedeApiHelper.getRestParams(RestContext.request.requestURI);          
    //internalReference = (uriKeys[2] =='billing' ? null : uriKeys[2]);
    // -----------------------------------------------------------------------------------------------
    /* NOT USED, UN_COMMENT IF NEED IT, DO NOT FORGET TO COVER THE CODE
    public static list<string> getRestParams(string url)
    {
        list<string> returnParams = new list<string>();        
        integer endOfUrl = url.indexOf('?');
        if(endOfUrl == -1)  endOfUrl = url.length();
        
        list<String> urlParams = url.substring(1,endOfUrl).split('/');         
        for (String p : urlParams)
        {
            returnParams.add(EncodingUtil.urlDecode(p, 'UTF-8'));
        }   
        return returnParams;           
    }*/

    //  -------------------------------------------------------------------------
    // @description - BuildEmail(Utility) method is used to build an email template. 
    // @param object subject,toAddresse, bccAdd, displayName, body.
    //  -------------------------------------------------------------------------
    public static Messaging.SingleEmailMessage buildEmail(String subject,String[] toRecipients, String[] bccAdd,String displayName,String body)
    {
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();         
        email.setSubject(subject);          
        email.setToAddresses(toRecipients); 
        if (bccAdd != null && bccAdd.size()>0)  email.setBccAddresses(bccAdd);
        //email.setBccSender(false);
        if (displayName != null)    email.setSenderDisplayName(displayName);
        email.setUseSignature(false);           
        email.setSaveAsActivity(false); 
          
        email.SetHtmlBody(body);
        return email;
    }
    
    //  -------------------------------------------------------------------------
    // Sends an email, logs error into in a ViasatLog__c if fails
    // appName is the application name used in a ViasatLog__c.Project (could be null)
    //  targetObjId     must be a Contact, User, Lead Id -- also used in merge fields of template recipient.xxxx
    //  whatId          must be an SObject that is used in the merge fields of the template relatedTo.xxxx
    //  fromId    if non null, use current user, otherwise, use this ID (most likely an org wide no reply id)
    //  bcc      not permitted when using templates  
    //  -------------------------------------------------------------------------
    /* NOT USED, UN_COMMENT IF NEED IT, DO NOT FORGET TO COVER THE CODE
    public static boolean sendTemplatedEmail(string appName, String[] toRecipients, String[] ccRecipients, String templateApiName
                                         , ID targetObjId, Id whatId, ID orgWideEmailId, Boolean saveAsActivity)//, Attachment[] attachList ) 
    {
        boolean bReturn = false;
        
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        Contact con = new Contact();
        Id emailTemplateId;  
        try 
        {   
            emailTemplateId = [SELECT id, name FROM EmailTemplate WHERE developerName = : templateApiName limit 1].id;

            //List<User> lstUser=[select id,contactId,Name,email from user where contact.email=:emailAddress AND ExternalAccountReference__c=: externalAccRef limit 1];
            email.setToAddresses(toRecipients);
            email.setCcAddresses(ccRecipients);
            
            if (targetObjId == Null)
            {
                // Create Contact
                con.FirstName = 'Test';
                con.LastName = 'Contact';
                con.Email = 'no-reply@viasat.com';
                insert con; 
                targetObjId = con.Id;           
            }
            email.setTargetObjectId(targetObjId);//contactId
            
            email.setWhatId(whatId); //User.Id
            email.setorgWideEmailAddressId(orgWideEmailId);
            email.setTemplateId(emailTemplateId);
            
            // save email as activity on the targetObjId (i.e. Contact). Note activity can't be saved on Users
            email.setSaveAsActivity(saveAsActivity);  
System.debug(LoggingLevel.INFO,'** entered sendTemplatedEmail, to:' + toRecipients + ' cc:' + ccRecipients +  ' templateId:' + emailTemplateId + ' tagetObjId:' + targetObjId + 
                    ' whatId:' + whatId + ' orgWideEmailId: ' + orgWideEmailId);
            
            if (!Test.isRunningTest())  
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
            
            bReturn = true; 
        }
        catch (exception e) 
        {
            string err = e.getMessage();
            if (emailTemplateId == null)
                err = 'Template not found; ' + err;
            System.debug('Error sending email - Error: ' + e.getMessage());
            ViasatLogHandler.Log((appName==null ? '' : appName)
                                , ViasatLogHandler.SeverityTypeMAJOR
                                , err
                                , e.getTypeName() + ' on line ' + e.getLineNumber()
                                , e.getStackTraceString());
        }   
        finally
        {
            if (con.Id != null)
                delete con;
        }
        return bReturn;
    }
    */
    
    //  -------------------------------------------------------------------------
    // Sends a list of emails, logs error into in a ViasatLog__c if fails
    // appName is the application name used in a ViasatLog__c.Project
    //  -------------------------------------------------------------------------
    public static void sendEmails(List<Messaging.SingleEmailMessage> emails, string appName)
    { 
        if (emails.isEmpty() == false) 
        {
            try 
            {       
                if (!Test.isRunningTest())
                    Messaging.sendEmail(emails);
            } 
            catch (DMLException de) 
            {
                System.debug('Error sending email: ' + de.getDMLMessage(0));
                //LogAsync(string project, string logType, string message, string details, string sender, string stackTrace);
                ViasatLogHandler.Log(appName, ViasatLogHandler.SeverityTypeCRITICAL, 'DMLError sending email', de.getDMLMessage(0), de.getDMLMessage(0));
            }
            catch (exception e) 
            {
                System.debug('Error sending email - Error: ' + e.getMessage());
                ViasatLogHandler.Log(appName
                                    , ViasatLogHandler.SeverityTypeMAJOR
                                    , e.getMessage()
                                    , e.getTypeName() + ' on line ' + e.getLineNumber() + '; ' + String.valueOf(emails)
                                    , e.getStackTraceString());
            }   
        } 
    }   
              
    //Method for build timer text from seconds
    Public static String segmentText(String segmentString, Integer segmentInteger, String priorSegments) {
        String returnString; //string for returning
        String spacer = ''; //string for holding an additional spacer
        if (segmentString != 'Second') { //if the segment being determined is not Seconds
            spacer = ' '; //create a spacer value
        }
        if (segmentInteger > 1) { //if the value is greater than 1
            returnString = segmentInteger.format()+' '+segmentString+'s'+spacer; //format
        } else if (segmentInteger > 0) { //if the value is greater than 0
            returnString = segmentInteger.format()+' '+segmentString+spacer; //format
        } else { //otherwise
            if (priorSegments != '' || segmentString == 'Second') { //if there is a value for prior segments or this is the seconds segment
                returnString = '0 '+segmentString+'s'+spacer; //format
            } else {
                returnString = ''; //set variable to null
            }
        }
        return returnString; //pass back the string
    }

    //Method for Calculating BusinesDuration(with timer text) between two date times
    // Not used ???
    public static String BusinessDurationBetweenTwoDateTimes(DateTime startDateTime, DateTime endDateTime)
    {    
      List<BusinessHours> bh = [SELECT Id FROM BusinessHours WHERE IsDefault=true and Name = 'Default'];
      Double temp = BusinessHours.diff(bh[0].id,startDateTime,endDateTime);
      Integer totalSeconds = (temp/1000).intValue();
     
      Integer yearResult = math.mod(math.floor(totalSeconds/31556926).intValue(),10000000); //number of years
      Integer dayResult = math.mod(math.floor(totalSeconds/86400).intValue(),365); //number of days
      Integer hourResult = math.mod(math.floor(totalSeconds/3600).intValue(),24); //number of hours
      Integer minuteResult = math.mod(math.floor(totalSeconds/60).intValue(),60); //number of minutes
      Integer secondResult = math.mod(math.floor(totalSeconds/1).intValue(),60); //number of seconds
        
      String yearTextString = segmentText('Year', yearResult, ''); //string variable for text regarding Year
      String dayTextString = segmentText('Day', dayResult, yearTextString); //string variable for text regarding Day
      String hourTextString = segmentText('Hour', hourResult, yearTextString + dayTextString); //string variable for text regarding Hour
      String minuteTextString = segmentText('Minute', minuteResult, yearTextString + dayTextString + hourTextString); //string variable for text regarding Minute
      String secondTextString = segmentText('Second', secondResult, yearTextString + dayTextString + hourTextString + minuteTextString); //string variable for text regarding Second
      String returnString = yearTextString + dayTextString + hourTextString + minuteTextString + secondTextString;//concatenate all the strings into one for our resutling test string
      return returnString;
    }
    
    //Method for Calculating BusinessSeconds Between two date times
    public static Integer BusinessSecondsBetweenTwoDateTimes(DateTime startDateTime, DateTime endDateTime) {
       List<BusinessHours> bh = [SELECT Id FROM BusinessHours WHERE IsDefault=true];// and Name = 'Default'];
       Double temp = BusinessHours.diff(bh[0].id,startDateTime,endDateTime);
       Integer totalSeconds = (temp/1000).intValue();
       return totalSeconds;
    }
    
    // Method for Calculating Clock timing between two date times
    // Refactored PL Dec 2014 - case 00308264 - See below
    // TO DO: Replace with new method below
    public static String durationBetweenTwoDateTimes(DateTime startDateTime, DateTime endDateTime) {
        Integer startYearAsInt = startDateTime.year(); //grab the start year
        Integer startDayasInt = startDateTime.dayOfYear(); //grab the start day
        Integer startHourasInt = startDateTime.hour(); //grab the start hour
        Integer startMinuteasInt = startDateTime.minute(); //grab the start minute
        Integer startSecondasInt = startDateTime.second(); //grab the start second
        Integer startInSeconds = (startYearAsInt * 31556926) + (startDayasInt * 86400) + (startHourasInt * 3600) + (startMinuteasInt * 60) + (startSecondasInt * 1); //convert the start date to a value in seconds
        //there are 31556926 seconds in one year and that is why we are mutiplying the startYearAsInt value by 31556926 > this same logic applies to the days, hours & minutes logic which is why there are weird multipliers in that line of code
        Integer endYearasInt = endDateTime.year(); //grab the end year
        Integer endDayasInt = endDateTime.dayOfYear(); //grab the end day
        Integer endHourasInt = endDateTime.hour(); //grab the end hour
        Integer endMinuteasInt = endDateTime.minute(); //grab the end minute
        Integer endSecondAsInt = endDateTime.second(); //grab the end second
        Integer endInSeconds = (endYearasInt * 31556926) + (endDayasInt * 86400) + (endHourasInt * 3600) + (endMinuteasInt * 60) + (endSecondAsInt * 1); //convert the end date to a value in seconds
        Integer totalDurationInSeconds = endInSeconds - startInSeconds; //duration in seconds
        
        Integer yearResult = math.mod(math.floor(totalDurationInSeconds/31556926).intValue(),10000000); //number of years
        Integer dayResult = math.mod(math.floor(totalDurationInSeconds/86400).intValue(),365); //number of days
        Integer hourResult = math.mod(math.floor(totalDurationInSeconds/3600).intValue(),24); //number of hours
        Integer minuteResult = math.mod(math.floor(totalDurationInSeconds/60).intValue(),60); //number of minutes
        Integer secondResult = math.mod(math.floor(totalDurationInSeconds/1).intValue(),60); //number of seconds
        
        String yearTextString = segmentText('Year', yearResult, ''); //string variable for text regarding Year
        String dayTextString = segmentText('Day', dayResult, yearTextString); //string variable for text regarding Day
        String hourTextString = segmentText('Hour', hourResult, yearTextString + dayTextString); //string variable for text regarding Hour
        String minuteTextString = segmentText('Minute', minuteResult, yearTextString + dayTextString + hourTextString); //string variable for text regarding Minute
        String secondTextString = segmentText('Second', secondResult, yearTextString + dayTextString + hourTextString + minuteTextString); //string variable for text regarding Second
        String returnString = yearTextString + dayTextString + hourTextString + minuteTextString + secondTextString;//concatenate all the strings into one for our resutling test string
        return returnString; //pass back the final string
    }
    
    
    // Method for Calculating Clock timing between two date times
    // Simplified method 
    // PL - Dec 2014 - case 00308264
    public static String durationBetweenTwoDateTimes_PL(DateTime startDateTime, DateTime endDateTime) 
    {                   
        return TimeTextFormatting((Integer)secondsBetweenTwoDateTimes(startDateTime, endDateTime));                        
    }
    
    //Method for Calculating Seconds between two date times
    // Simplified method 
    // PL - Dec 2014 - NBNCO cases 282319 + 282314
    public static Long secondsBetweenTwoDateTimes(DateTime startDateTime, DateTime endDateTime) 
    {
        Long totalDurationInSeconds = (endDateTime.getTime() - startDateTime.getTime())/1000;
        
        return totalDurationInSeconds;      
    }   
    
    // Method to add business days to a dateTime using SFDC BusinessHours
    // Adds back the truncated sec+ms 
    // PL - Dec 2014 - NBNCO cases 282319 + 282314
    public static DateTime addBusinessDays(ID businessHoursId, DateTime startDate, Integer days)
    { 
        long interval = days * 86400000;
        DateTime endTimeTemp = BusinessHours.add(businessHoursId, startDate, interval);         
        // add sec + ms of startDate time (truncated by BusinessHours.add) 
        DateTime endTime=DateTime.newInstance(endTimeTemp.getTime()+startDate.second()*1000+startDate.millisecond());
    
        return endTime;
    
    }

    // refactored PL Dec 2014 - case 00308264 - See below
    // Method for time text formating 
    // TO DO: Replace with new method
    public static string TimeTextFormatting(Decimal inputMinutes)
    {
        String strInputMinutes = String.valueof(inputMinutes);
        if(strInputMinutes.contains('-'))
        {
            Decimal dinputMinutes = - inputMinutes;
            return TimeTextFormattingForMinus(dinputMinutes);
        }
        Integer yearResult = math.mod(math.floor(inputMinutes/31556926).intValue(),10000000); //number of years
        Integer dayResult = math.mod(math.floor(inputMinutes/86400).intValue(),365); //number of days
        Integer hourResult = math.mod(math.floor(inputMinutes/3600).intValue(),24); //number of hours
        Integer minuteResult = math.mod(math.floor(inputMinutes/60).intValue(),60); //number of minutes
        Integer secondResult = math.mod(math.floor(inputMinutes/1).intValue(),60); //number of seconds
        
        String yearTextString = segmentText('Year', yearResult, ''); //string variable for text regarding Year
        String dayTextString = segmentText('Day', dayResult, yearTextString); //string variable for text regarding Day
        String hourTextString = segmentText('Hour', hourResult, yearTextString + dayTextString); //string variable for text regarding Hour
        String minuteTextString = segmentText('Minute', minuteResult, yearTextString + dayTextString + hourTextString); //string variable for text regarding Minute
        String secondTextString = segmentText('Second', secondResult, yearTextString + dayTextString + hourTextString + minuteTextString); //string variable for text regarding Second
        String returnString = yearTextString + dayTextString + hourTextString + minuteTextString + secondTextString;//concatenate all the strings into one for our resutling test string
        return returnString;    
    }
    //Method for Negative timer text builder
     public static String segmentTextMinus(String segmentString, Integer segmentInteger, String priorSegments) {
        String returnString; //string for returning
        String spacer = ''; //string for holding an additional spacer
        if (segmentString != 'Second') { //if the segment being determined is not Seconds
            spacer = ' '; //create a spacer value
        }
        if (segmentInteger > 1) { //if the value is greater than 1
            returnString = '-' + segmentInteger.format()+' '+segmentString+'s'+spacer; //format
        } else if (segmentInteger > 0) { //if the value is greater than 0
            returnString = '-' + segmentInteger.format()+' '+segmentString+spacer; //format
        } else { //otherwise
            if (priorSegments != '' || segmentString == 'Second') { //if there is a value for prior segments or this is the seconds segment
                returnString = '-0 '+segmentString+'s'+spacer; //format
            } else {
                returnString = ''; //set variable to null
            }
        }
        return returnString; //pass back the string
    }
    //Method for Negative Timer Text formating builder
    public static string TimeTextFormattingForMinus(Decimal inputMinutes)
    {
        Integer yearResult = math.mod(math.floor(inputMinutes/31556926).intValue(),10000000); //number of years
        Integer dayResult = math.mod(math.floor(inputMinutes/86400).intValue(),365); //number of days
        Integer hourResult = math.mod(math.floor(inputMinutes/3600).intValue(),24); //number of hours
        Integer minuteResult = math.mod(math.floor(inputMinutes/60).intValue(),60); //number of minutes
        Integer secondResult = math.mod(math.floor(inputMinutes/1).intValue(),60); //number of seconds
        
        String yearTextString = segmentTextMinus('Year', yearResult, ''); //string variable for text regarding Year
        String dayTextString = segmentTextMinus('Day', dayResult, yearTextString); //string variable for text regarding Day
        String hourTextString = segmentTextMinus('Hour', hourResult, yearTextString + dayTextString); //string variable for text regarding Hour
        String minuteTextString = segmentTextMinus('Minute', minuteResult, yearTextString + dayTextString + hourTextString); //string variable for text regarding Minute
        String secondTextString = segmentTextMinus('Second', secondResult, yearTextString + dayTextString + hourTextString + minuteTextString); //string variable for text regarding Second
        String returnString = yearTextString + dayTextString + hourTextString + minuteTextString + secondTextString;//concatenate all the strings into one for our resutling test string
        return returnString;    
    }

    public static string sandboxName()
    {
        string host = URL.getSalesforceBaseUrl().getHost();//viasat--DEVSUP.cs12.my.salesforce.com
        String server = host.substring(0,host.indexOf('.'));
        if(server.contains('--'))
            return server.substring(server.indexOf('--')+2);
        else
            return 'Prod';
    }
    //-------------------------------------------------------------
    // Method for replacing null values with specified text value
    //   for string variables. added for ITSMS Project 09/22/2015
    //-------------------------------------------------------------
    public static string replaceNullForString  (string fieldValue, string valueIfNull) {
    if (fieldValue == null)
        return valueIfNull;
    else
        return fieldValue;
  }
    //-------------------------------------------------------------
    // Method for replacing null values with specified text value
    //   for boolean variables. added for ITSMS Project 09/22/2015
    //-------------------------------------------------------------
    public static string replaceNullForBoolean(boolean fieldValue, string valueIfNull) {
    if (fieldValue == null)
        return valueIfNull;
    else
        return string.valueOf(fieldValue);
  }
    //-------------------------------------------------------------
    // Method for replacing null values with specified text value
    //   for date variables. added for ITSMS Project 09/22/2015
    //-------------------------------------------------------------
    public static string replaceNullForDate(date fieldValue, string valueIfNull) {
    if (fieldValue == null)
        return valueIfNull;
    else
        return string.valueOf(fieldValue);
  }
    //-------------------------------------------------------------
    // Method for replacing null values with specified text value
    //   for datetime variables. added for ITSMS Project 09/22/2015
    //-------------------------------------------------------------
    public static string replaceNullForDateTime(datetime fieldValue, string valueIfNull) {
    if (fieldValue == null)
    {
        return valueIfNull;
    }
    else
    {
        string formatDT = fieldValue.format('mm/dd/yyyy hh:mm a');
        return formatDT;
    }
  }
    //-------------------------------------------------------------
    // Method for replacing null values with specified integer value
    //   for datetime variables. added for ITSMS Project 09/22/2015
    //-------------------------------------------------------------
    public static string replaceNullForDecimal(decimal fieldValue, string valueIfNull) {
    if (fieldValue == null)
        return valueIfNull;
    else
        return string.valueOf(fieldValue);
  }

}