/*
 * Class ITSMSNewHireContact
 * 
 * @version 1.0
 * @author  Dianna Guilinger - Slalom  
 * 
 * Called from Contact After Trigger for Insert/Update
 *    When a contact is updated/inserted from Active Directory and has a nonblank
 *    email address, logic will search for an open New Hire Active Directory case that is not owned by a queue. 
 * 	  When owned by a queue, no updates can be made to the case.
 * 	  If found, that AD case will be updated and logic initiated to create the remainder of the
 *    new hire child cases. 
  */
public class ITSMSNewHireContact 
{
    public static void completeITSMSNewHireContact (List<Contact> newValues, Map<Id, Contact> valuesMap) 
    {
        boolean updtContact;
        set<string> newHireEmails = new set<string>();
        list<Case> childCases = new list<Case>();

        for (Contact nv : newValues)
        { 
            if (nv.NewHireType__c != null && nv.Email != null)
                // get all emails for New Hire contacts
                newHireEmails.add(nv.Email);
        }
        // get open child cases associated with emails
        if (newHireEmails.size() > 0)
        {
            childCases = [ Select Id, NewHireEmail__c, Status, ParentId, ServiceRequestType__c, Owner.Type
                               from Case where Status != :ITSMSConstants.CASE_STATUS_CLOSE
                                and ServiceRequestType__c = :ITSMSConstants.NEWHIRE_SRVREQTYPE_ACTIVEDIRECTORY
                                and NewHireEmail__c in :newHireEmails
                         		and Owner.Type != 'Queue'];               
            update childCases;
        }
    } 
}