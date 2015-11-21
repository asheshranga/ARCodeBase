/*
 * Class ITSMSNewHireEmailNotice
 * 
 * @version 1.0
 * @author  Dianna Guilinger - Slalom  
 * 
 *  Creates 2 emails for each parent case passed that will list all corresponding child cases.  
 *  The first is sent to the requestor, manager and delegates of the new hire employee/contractor.
 *  The second is sent to the new hire. 
 */
global class ITSMSNewHireEmailNotice  {

    public static void sendNewHireNotice(set<Id> parentCaseIds){
        // init variables 
        string caselink;
        string startDate;
        string middleName;
        string emailSubject;
        string emailBody;
        string senderName;
        string appName;
     
        list <Case> parentCases = new list<Case>();
        list <Case> ChildCases = new list<Case>();
        list <string> toAddresses = new list<string> ();
        list <string> bccAddresses = new list<string> ();
        List<Messaging.SingleEmailMessage> emails = new list<Messaging.SingleEmailMessage> ();

        //  get parent cases 
        parentCases = ITSMSUtilityClass.getCases(ITSMSConstants.NEWHIRE_EMAIL_PARENTQUERY, parentCaseIds);
        // get child cases for all parents
        childCases = ITSMSUtilityClass.getCases(ITSMSConstants.NEWHIRE_EMAIL_CHILDQUERY, parentCaseIds);
        // get org to use with link to case
        caseLink = getPageURL();

        // build emails for each parent case 
        for (Case pc:parentCases) 
        {
            // generate notice to requestor/manager/delegates as long as one email exists 
            if (pc.ManagerUser__c != null && pc.ManagerUser__r.Email != null)
                toAddresses.add(pc.ManagerUser__r.Email);
            if (pc.CreatedBy.Email != null)
                toAddresses.add(pc.CreatedBy.Email);
            if (pc.ManagerUser__c != null && pc.ManagerUser__r.Delegate__c != null && pc.ManagerUser__r.Delegate__r.Email != null)
                toAddresses.add(pc.ManagerUser__r.Delegate__r.Email);
            if (pc.CreatedBy.Delegate__c != null && pc.CreatedBy.Delegate__r.Email != null)
                toAddresses.add(pc.CreatedBy.Delegate__r.Email);
            
            if (toAddresses.size() > 0)
            {
                // set Subject line           
                startDate = pc.StartDate__c.month()+'/'+pc.StartDate__c.day()+'/'+pc.StartDate__c.year();
                middleName = ViasatUtilityClass.replaceNullForString(pc.MiddleNameInitial__c, ' ');
                string[] subjectArgs = new string [] { pc.NewHireType__c, pc.FirstName__c, middleName, pc.LastName__c, startDate, pc.PhysicalLocation__c };
                emailSubject = string.format(ITSMSConstants.EMAIL_SUBJECT_NEWHIRE, subjectArgs);
                string [] bodyArgs; 
                // build body for email to requestor
                if (pc.ManagerUser__c != null)
                {    
                    bodyArgs = new string [] {pc.ManagerUser__r.FirstName, pc.ManagerUser__r.LastName};
                } else
                {
                    bodyArgs = new string []  {pc.CreatedBy.FirstName, pc.CreatedBy.LastName};
                }
                emailBody = string.format(ITSMSConstants.EMAIL_BODY_REQUESTOR, bodyArgs);
                emailBody = appendChildCases(emailBody, pc.Id, childCases, caseLink);
                Messaging.SingleEmailMessage mail1 = ViasatUtilityClass.buildEmail(emailSubject, toAddresses, bccAddresses, senderName, emailBody);
                emails.add(mail1);

                // generate notice to new hire 
                if (pc.NewHireContact__c != null && pc.NewHireContact__r.Email != null)
                {
                    // get To addresses     
                    toAddresses.clear();
                    toAddresses.add(pc.NewHireContact__r.Email);
                    // uses same subject line as requestor email          
                    // build body for email to new hire
                    bodyArgs = new string [] {pc.NewHireContact__r.FirstName, pc.NewHireContact__r.LastName};
                    emailBody = string.format(ITSMSConstants.EMAIL_BODY_NEWHIRE, bodyArgs);
                    emailBody = appendChildCases(emailBody, pc.Id, childCases, caseLink);
                    Messaging.SingleEmailMessage mail2 = ViasatUtilityClass.buildEmail(emailSubject, toAddresses, bccAddresses, senderName, emailBody);
                    emails.add(mail2);
                }               
                if (emails.size() > 0)
                {
                    appName = ITSMSConstants.ITSMS_APPNAME;
                    ViasatUtilityClass.sendEmails(emails, appName);
                }
            }
        }
    }
    private static string appendChildCases(string emailBody, string parentId, list<Case> childCases, string caseLink) {
        // for each child case for the parent, format a detail line in the email body 
        string [] bodyArgs;
        for (Case c: childCases)
        {
            if (c.ParentId == parentId )
            {
        		string childCategory = ViasatUtilityClass.replaceNullForString(c.Category__c, ' ');
        		string childCategoryDetails = ViasatUtilityClass.replaceNullForString(c.CategoryDetails__c, ' ');
                bodyArgs = new string [] {caseLink+c.Id, c.CaseNumber, c.Subject, childCategory, childCategoryDetails};
                emailBody += string.format(ITSMSConstants.EMAIL_BODY_CHILDCASES, bodyArgs);
            }
        }
        return emailBody;
    }
    
    // Get URL to be used by links in email 
    private static string getPageURL() {
        String URLL = URL.getSalesforceBaseUrl().toExternalForm() +'/';
        return URLL; 
    } 
}