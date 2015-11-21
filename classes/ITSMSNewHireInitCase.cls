/*
 * Class ITSMSNewHireInitCase
 * 
 * @version 1.0
 * @author  Dianna Guilinger - Slalom  
 * 
 *  Creates child case for New Hire service request for initial setup of employee or
 *  contractor in Active Directory. 
 */
public with sharing class ITSMSNewHireInitCase 
{
   public static Case createInitialNewHireCase (Case parentCase) 
    { 
        // build child case for New Hire 
        Case childCase = new Case();
        childCase.Category__c = ITSMSConstants.ACTIVE_DIRECTORY_CATEGORY;
        childCase.CategoryDetails__c = ITSMSConstants.ACTIVE_DIRECTORY_CATEGORYDETAIL;
        childCase.DescriptionRichText__c = parentCase.DescriptionRichText__c;
        childCase.ManagerUser__c = parentCase.ManagerUser__c;
        childCase.RequestingForUser__c = parentCase.RequestingForUser__c;
        childCase.Origin = parentCase.Origin;
        childCase.ParentId = parentCase.Id;
        childCase.RecordTypeId = parentCase.RecordTypeId;
        childCase.Requestor__c = parentCase.Requestor__c;
        childCase.ContactId = parentCase.ContactId;
        childCase.AccountId = parentCase.AccountId;
        childCase.SupportCategory__c = ITSMSConstants.NEWHIRE;
        childCase.ServiceRequestType__c = ITSMSConstants.ACTIVE_DIRECTORY_SRVREQTYPE;
        childCase.ServiceDeskProduct__c = ITSMSConstants.ACTIVE_DIRECTORY_PRODUCT;
        childCase.NewHireType__c = parentCase.NewHireType__c;
        childCase.EmployeeType__c = parentCase.EmployeeType__c;
        string middleName = ViasatUtilityClass.replaceNullForString(parentCase.MiddleNameInitial__c, ' ');
        string temp = 'Add AD Contact for:';
        string[] subjArgs = new string[] {parentCase.NewHireType__c, parentCase.FirstName__c, middleName, parentCase.LastName__c, parentCase.PhysicalLocation__c};
        childCase.Subject = temp + string.format(ITSMSConstants.ACTIVE_DIRECTORY_SUBJECT, subjArgs);
        childCase.Description = childCase.Subject;
        childCase.Type = parentCase.Type;
        //   get entitlement
        Entitlement ent = ITSMSUtilityClass.getEntitlement(ITSMSConstants.ENTITLEMENT_ACTIVEDIRECTORY);
        if (ent != null) 
            childCase.EntitlementId = ent.Id;
         //   Fetch the assignment rules on case
        AssignmentRule assignRule = new AssignmentRule();
        assignRule = [select id from AssignmentRule where SobjectType = 'Case' and Active = true limit 1];
        if (assignRule != null)
        {
            //  Create DMLOptions for "Assign using active assignment rules" checkbox
            Database.DMLOptions dmlOpts = new Database.DMLOptions();
            dmlOpts.assignmentRuleHeader.assignmentRuleId= assignRule.id;
            //   Set DMLOption on Case instance so that assignment rules are executed
            childCase.setOptions(dmlOpts);
        }
        //   insert child case
        boolean isUpserted = ITSMSUtilityClass.upsertCase(childCase);
        return childCase;
    } 
}