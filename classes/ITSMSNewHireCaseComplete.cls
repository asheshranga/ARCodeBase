/*
 * Class ITSMSNewHireCaseComplete
 * 
 * @version 1.0
 * @author  Dianna Guilinger - Slalom  
 * 
 *  For New Hire Employee/Contractor, executed by Case Trigger before update of the
 *  AD (Active Directory) case.  Once the admin has made the entry 
 *  in Active Directory, the 'New Hire Email' field in this case will be populated
 *  triggering this code's execution.  
 *  1. This email is used to find the new (or updated) Saleforce contact record for that 
 *      employee/contractor and associating it to the new hire parent case
 *  2. This child case will be closed.
 *  3. Additional child cases will be generated for the parent case using data from the
 *      New Hire form.
 *  4. An email will be sent to the Manager and Requestor of the New Hire request.
 *  5. Updates to that contact will be applied using data entered into the New Hire form 
 *      associated to the parent case. 
 *  
 */
public class ITSMSNewHireCaseComplete 
{
    //-- check for ITSMS open new hire AD case before update of cases
    public static void completeITSMSNewHireCase (List<Case> newValues, Map<Id, Case> valuesMap) 
    { 
        // avoid recursion
        
        if (ITSMSUtilityClass.runCompleteCase())
        {
            set<string> newHireEmails = new set<string>();
            set<Id> parentCaseIds = new set<ID>();
            set<Id> contactIds = new set<Id>();
            list<Contact> contacts = new list<Contact>();
            list<Case> parentCases = new list<Case>();
            map<string,Contact> emailToContact = new map<string,Contact>();
            map<Id,Case> contactToCase = new map<Id,Case>();
            map<Id,Case> parentIdToCase = new map<Id,Case>();
            // for each case in the trigger, check to see if it is an open new hire AD case where the 
            //   new hire's email address has been entered
            for (Case nv : newValues)
            { 
                if (nv.RecordTypeId == Schema.SObjectType.Case.RecordTypeInfosByName.get(ITSMSConstants.CASE_RECORDTYPE).RecordTypeId && nv.ServiceRequestType__c == ITSMSConstants.NEWHIRE_SRVREQTYPE_ACTIVEDIRECTORY && ITSMSConstants.NEWHIRE_STATUS_AD_OPEN.contains('#'+nv.Status+'#') && nv.NewHireEmail__c != null)
                    // get all emails for AD Account New Hire cases
                    newHireEmails.add(nv.NewHireEmail__c);
            }
            // get contacts associated with emails for any AD cases
            if (newHireEmails.size() > 0)
            {
                contacts = ITSMSUtilityClass.getContacts(ITSMSConstants.CONTACTS_QUERY_BY_EMAIL, newHireEmails);
                for (Contact c:contacts)
                {
                    emailToContact.put(c.email,c);
                    contactIds.add(c.Id);
                }
                if (contacts.size() > 0)
                {
                    // for each child case where contact was found, save parent case id and close child case
                    for (Case nv:newValues)
                    {
                        if (emailToContact.get(nv.NewHireEmail__c) != null && nv.ParentId != null)
                        {
                            parentCaseIds.add(nv.ParentId);
                            contactToCase.put(emailToContact.get(nv.NewHireEmail__c).Id,nv);
                            nv.Status = ITSMSConstants.CASE_STATUS_CLOSE;
                        }
                    }
                    // build map of parent cases assoc to child cases with contact email found. 
                    IF (parentCaseIds.size() > 0)
                    {
                        parentCases = [Select Id, Status, NewHireContact__c from Case where Id = :parentCaseIds ];
                        if (parentCases.size() > 0)
                        {
                            for (Case pc:parentCases)
                            {
                                parentIdToCase.put(pc.Id, pc);
                            }
                            //  for each child case - update assoc parent with contact 
                            for (Case nv:newValues)
                            {
                                if (emailToContact.get(nv.NewHireEmail__c) != null)
                                {
                                    parentIdToCase.get(nv.ParentId).NewHireContact__c = emailToContact.get(nv.NewHireEmail__c).Id;
                                }
                            }
                            update parentIdToCase.values();
                            // execute create of child cases
                            ITSMSNewHireChildCases.createCases(parentCaseIds);
                            
                        }
                        // execute update of contact
                        ITSMSNewHireContactUpdate.applyFormToContact(contactIds);
                    }
                }
            }
        }
    } 
}