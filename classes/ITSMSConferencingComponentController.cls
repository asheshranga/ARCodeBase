/**************************************************************************************************************
Name         : ITSMSConferencingComponentController 
Created By   : Dianna Guilinger - Slalom 
Description  : Controller for VF Component ITSMSConferencing
             : Obtains passed parameters, manages page action
***************************************************************************************************************/
public class ITSMSConferencingComponentController  extends ITSMSComponentControllerBase {

    // format case record for Conferencing: VTC
    public override void formatCaseRec (){
        componentToPage.caseRec = caseRec;
        componentToPage.caseRec.SupportRequestType__c = ITSMSConstants.CONF_PRODUCT;
        componentToPage.caseRec.Category__c = ITSMSConstants.CONF_CATEGORY;
        componentToPage.caseRec.CategoryDetails__c = ITSMSConstants.CONF_CATEGORYDETAILS;
        componentToPage.caseRec.ServiceDeskProduct__c = ITSMSConstants.CONF_PRODUCT;
        componentToPage.caseRec.ServiceRequestType__c = ITSMSConstants.CONF_SRVREQTYPE;
        componentToPage.caseRec.SupportRequestType__c = ITSMSConstants.CONF_PRODUCT;
        string vtcRoom = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.VTCRoom__c, 'not entered');
        string webExReqd = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.WebExRequired__c, 'not entered');
        string webExNum = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.WebExMeetingNumber__c, 'not entered');
        string hostPasscode = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.HostPasscode__c, 'not entered');
        string webExInfo = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.WebExInformation__c, 'not entered');
        string confSetup = ViasatUtilityClass.replaceNullForDateTime(componentToPage.caseRec.ConferenceRoomSetupTime__c, 'not entered');
        string startDateTime = ViasatUtilityClass.replaceNullForDateTime(componentToPage.caseRec.StartDateTime__c, 'not entered');
        string endDateTime = ViasatUtilityClass.replaceNullForDateTime(componentToPage.caseRec.EndDateTime__c, 'not entered');
        string attendees = ViasatUtilityClass.replaceNullForDecimal(componentToPage.caseRec.Attendees__c, 'not entered');
        string meetingOrganizer = ' ';
        if (componentToPage.caseRec.ManagerUser__c!= null)
        {
            list<User> u = new list<User> ([Select Id, FirstName, LastName from User
                                              where Id = :componentToPage.caseRec.ManagerUser__c limit 1]);
            if (u.size() == 1)
                 meetingOrganizer = u[0].FirstName+' '+u[0].LastName;
        } else
        {
            User requestor = ITSMSUtilityClass.getRequestor(componentToPage.caseRec);
            if (requestor != null)
                meetingOrganizer = requestor.FirstName + ' ' + requestor.LastName;
        } 
                
        string[] conferArgs = new string [] { componentToPage.caseRec.EventTitle__c, componentToPage.caseRec.Description, meetingOrganizer, 
            confSetup, startDateTime, endDateTime, attendees, vtcRoom, webExReqd, webExNum, hostPasscode, webExInfo };
        componentToPage.caseRec.DescriptionRichText__c = string.format(ITSMSConstants.CONF_DESCRIPTION, conferArgs);             
        
        string[] conferSubjArgs = new string [] { componentToPage.caseRec.SupportRequestType__c, confSetup,
                endDateTime, componentToPage.caseRec.VTCRoom__c };
        componentToPage.caseRec.Subject = string.format(ITSMSConstants.CONF_SUBJECT,conferSubjArgs);
    }

}