/*
 * Class ITSMSNewHireContactUpdate
 * 
 * @version 1.0
 * @author  Dianna Guilinger - Slalom  
 *
 *  Executed when an AD contact is associated to a New Hire parent case via 
 *  class ITSMSNewHireCaseComplete and the Case trigger.
 *  Updates contact fields using data entered into new hire request form.
 * 
 */
public class ITSMSNewHireContactUpdate {
    @future
    public static void applyFormToContact (set<Id> contactIds)
    {  
   /*     boolean updtContact;
        list<Contact> updtContacts = new list<Contact>();
        list<Contact> contacts = new list<Contact>();
        list<Case>  cases = new list<Case> ();
        map<Id,Case> contactToCase = new map<Id,Case>();
        // get contact records 
        contacts = [Select Id, FirstName, LastName, MiddleNameInitial__c, Email
                        , Citizenship__c, NewHireType__c, EmployeeType__c, Company__c  
                        , CompanyEmail__c, ManagerUserId__c, NewHireStartDate__c, WorkEndDate__c 
                        from Contact where Id in :contactIds];
        // get list of new hire cases for contacts
        cases = [select Id, CaseNumber, StartDate__c, EmployeeType__c, NewHireContact__c, WorkEndDate__c 
                        , Citizenship__c, PhysicalLocation__c, OfficeCubeNumber__c, FirstName__c, LastName__c, ManagerUserId__c, MiddleNameInitial__c
                        , DepartmentName__c, RecordTypeId, NewHireType__c, CompanyName__c, CompanyEmail__c
                        from Case where NewHireContact__c = :contacts];
        //  build map of contact to case 
        for (Case c:cases)
        {
            contactToCase.put(c.NewHireContact__c,c);
        }
        // update contact data where needed 
        for (Contact c:contacts)
        {
            updtContact = false;
            if (contactToCase.get(c.Id).Citizenship__c != null && c.Citizenship__c <> contactToCase.get(c.Id).Citizenship__c)
            {
                c.Citizenship__c = contactToCase.get(c.Id).Citizenship__c;
                updtContact = true;
            }
            if (contactToCase.get(c.Id).NewHireType__c != null && c.NewHireType__c <> contactToCase.get(c.Id).NewHireType__c )
            {
                c.NewHireType__c = contactToCase.get(c.Id).NewHireType__c;
                updtContact = true;
            }
            if (contactToCase.get(c.Id).EmployeeType__c != null && c.EmployeeType__c <> contactToCase.get(c.Id).EmployeeType__c )
            {
                c.EmployeeType__c = contactToCase.get(c.Id).EmployeeType__c;
                updtContact = true;
            }
            if (contactToCase.get(c.Id).MiddleNameInitial__c != null && c.MiddleNameInitial__c <> contactToCase.get(c.Id).MiddleNameInitial__c )
            {
                c.MiddleNameInitial__c = contactToCase.get(c.Id).MiddleNameInitial__c;
                updtContact = true;
            }
            if (contactToCase.get(c.Id).StartDate__c != null && c.NewHireStartDate__c <> contactToCase.get(c.Id).StartDate__c )
            {
                c.NewHireStartDate__c = contactToCase.get(c.Id).StartDate__c;
                updtContact = true;
            }
            if (contactToCase.get(c.Id).ManagerUserId__c != null && c.ManagerUserId__c <> contactToCase.get(c.Id).ManagerUserId__c )
            {
                c.ManagerUserId__c = contactToCase.get(c.Id).ManagerUserId__c;
                updtContact = true;
            }
            if (contactToCase.get(c.Id).WorkEndDate__c != null && c.WorkEndDate__c <> contactToCase.get(c.Id).WorkEndDate__c )
            {
                c.WorkEndDate__c = contactToCase.get(c.Id).WorkEndDate__c;
                updtContact = true;
            }
            if (contactToCase.get(c.Id).CompanyName__c != null && c.Company__c <> contactToCase.get(c.Id).CompanyName__c )
            {
                c.Company__c = contactToCase.get(c.Id).CompanyName__c;
                updtContact = true;
            }
            if (contactToCase.get(c.Id).CompanyEmail__c != null && c.CompanyEmail__c <> contactToCase.get(c.Id).CompanyEmail__c )
            {
                c.CompanyEmail__c = contactToCase.get(c.Id).CompanyEmail__c;
                updtContact = true;
            }
            If (updtContact == true)
                updtContacts.add(c);
        }            
        if (updtContacts.size() > 0)
        {
            system.debug('@@ logged on user:'+UserInfo.getUserId());
            update updtContacts;
        }    */
    }
}