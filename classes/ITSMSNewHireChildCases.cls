/*
 * Class ITSMSNewHireChildCases
 * 
 * @version 1.0
 * @author  Dianna Guilinger - Slalom  
 *
 *  Creates child cases for New Hire requests based on data entered
 *  into the associated form.
 */
public with sharing class ITSMSNewHireChildCases {
    
    @future
    public static void createCases (set<Id> parentCaseIds) { 
        System.debug('(ITSMSNewHireChildCases) Begin');
        // build child cases for New Hire Employee 
        list<Case> childCases = new list<Case>();
        list<Case> parentCases = ITSMSUtilityClass.getCases(ITSMSConstants.NEWHIRE_QUERY +' from Case where Id = :caseIds', parentCaseIds);
        for (Case pc:parentCases)
        {
            string startDate = pc.StartDate__c.month()+'/'+pc.StartDate__c.day()+'/'+pc.StartDate__c.year();
            // will only do once for a parent case even if AD Account case is updated again
            if (!pc.ChildCasesCreated__c )
            {
                // check if Desktop case is needed for Contractor or Employee
                if ( (!ITSMSConstants.NEWHIRE_TYPE_AD.contains('#'+pc.NewHireType__c+'#'))&& (pc.DeskPhone__c == 'Yes' || pc.WirelessHeadset__c == 'Yes' || pc.PCModelType__c != 'No PC Required' || (pc.OtherHardware__c != null && pc.OtherHardware__c != 'not entered')))
                {
                    Case desktopCase = new Case();
                    desktopCase.Category__c = ITSMSConstants.DESKTOP_CATEGORY;
                    desktopCase.CategoryDetails__c = ITSMSConstants.DESKTOP_CATEGORYDETAIL;
                    desktopCase.ContactId = pc.NewHireContact__c;
                    desktopCase.ManagerUser__c = pc.ManagerUser__c;
                    desktopCase.Origin = pc.Origin;
                    desktopCase.ParentId = pc.Id;
                    desktopCase.NewHireType__c = pc.NewHireType__c;
                    desktopCase.EmployeeType__c = pc.EmployeeType__c;
                    desktopCase.RecordTypeId = pc.RecordTypeId;
                    desktopCase.RequestingForUser__c= pc.RequestingForUser__c;
                    desktopCase.Requestor__c = pc.Requestor__c;
                    desktopCase.DeskPhone__c = pc.DeskPhone__c;
                    desktopCase.WirelessHeadset__c = pc.WirelessHeadset__c;
                    desktopCase.PCModelType__c = pc.PCModelType__c;
                    desktopCase.OtherHardware__c = pc.OtherHardware__c;
                    desktopCase.OtherPCModelOS__c = pc.OtherPCModelOS__c;
                    desktopCase.PCModel__c = pc.PCModel__c;
                    
                    // format concatenated description using form fields
                    string pcModel = ViasatUtilityClass.replaceNullForString(pc.PCModel__c, 'not entered');
                    string otherPCModel = ViasatUtilityClass.replaceNullForString(pc.OtherPCModelOS__c, 'not entered');
                    string otherHardware = ViasatUtilityClass.replaceNullForString(pc.OtherHardware__c, 'not entered');
                    string[] desktopArgs = new string [] { pc.DeskPhone__c, pc.WirelessHeadset__c, pc.PCModelType__c, pcModel, otherPCModel, otherHardware };
                    desktopCase.DescriptionRichText__c = string.format(ITSMSConstants.DESKTOP_DESCRIPTION, desktopArgs);          
                    if (ITSMSConstants.DESKTOP_PCMODELS.contains('#'+pc.PCModelType__c+'#') )
                        desktopCase.ServiceDeskProduct__c = pc.PCModelType__c;
                    desktopCase.ServiceRequestType__c = ITSMSConstants.DESKTOP_SERVICEREQUESTTYPE;
                    desktopCase.SupportCategory__c = ITSMSConstants.NEWHIRE;
                    string[] desktopSubjectArgs = new string [] { pc.FirstName__c, pc.LastName__c, StartDate, desktopCase.ServiceDeskProduct__c};
                    desktopCase.Subject = string.format(ITSMSConstants.DESKTOP_SUBJECT, desktopSubjectArgs);   
                    desktopCase.Type = pc.Type;
                    childCases.add(desktopCase);
                }

                // check if Software case is needed
                if (pc.Software__c != null)
                {
                    string[] selectedSoftwareList = pc.Software__c.split(';');
                    if (selectedSoftwareList.size() > 0 )
                    {
                        for(string software:selectedSoftwareList)
                        {
                            Case softwareCase = new Case();
                            if (ITSMSConstants.SOFTWARE_NAME_GROUP1.contains('#'+software+'#'))
                            {
                                softwareCase.Category__c = ITSMSConstants.SOFTWARE_GROUP1_CATEGORY;
                                softwareCase.CategoryDetails__c = ITSMSConstants.SOFTWARE_GROUP1_CATEGORYDETAIL;
                            } else {
                                softwareCase.Category__c = null;
                                softwareCase.CategoryDetails__c = null;
                            }
                            softwareCase.ServiceDeskProduct__c = null;
                            string[] softwareArgs = new string [] { software};
                            softwareCase.DescriptionRichText__c = string.format(ITSMSConstants.NEWHIRE_DESCRIPTION_SOFTWARE, softwareArgs);          
                            softwareCase.ManagerUser__c = pc.ManagerUser__c;
                            softwareCase.Origin = pc.Origin;
                            softwareCase.ParentId = pc.Id;
                            softwareCase.ContactId = pc.NewHireContact__c;
                            softwareCase.RecordTypeId = pc.RecordTypeId;
                            softwareCase.NewHireType__c = pc.NewHireType__c;
                            softwareCase.EmployeeType__c = pc.EmployeeType__c;
                            softwareCase.RequestingForUser__c= pc.RequestingForUser__c;
                            softwareCase.Requestor__c = pc.Requestor__c;
                            softwareCase.Software__c = software;
                            softwareCase.FirstName__c = software;
                            softwareCase.LastName__c = software;
                            softwareCase.ServiceRequestType__c = ITSMSConstants.SOFTWARE_SERVICEREQUESTTYPE;
                            softwareCase.SupportCategory__c = ITSMSConstants.NEWHIRE;
                            string[] softwareSubjArgs = new string [] { pc.FirstName__c, pc.LastName__c,  startDate, software };
                            softwareCase.Subject = string.format(ITSMSConstants.NEWHIRE_SUBJECT_SOFTWARE, softwareSubjArgs);   
                            softwareCase.Type = pc.Type;
                            childCases.add(softwareCase);
                        }
                    }
                }
                // check if Access case for Oracle is needed
                if (pc.OracleOBIEEResponsibilities__c!= null || pc.OracleEBSResponsibilities__c!= null || pc.OracleASCPResponsibilities__c!= null)
                {
                    Case oracleCase = new Case();
                    oracleCase.Category__c = ITSMSConstants.ORACLE_CATEGORY;
                    oracleCase.CategoryDetails__c = ITSMSConstants.ORACLE_CATEGORYDETAIL;
                    oracleCase.ContactId = pc.NewHireContact__c;
                    oracleCase.NewHireType__c = pc.NewHireType__c;
                    oracleCase.EmployeeType__c = pc.EmployeeType__c;
                    string oracleASCP = ViasatUtilityClass.replaceNullForString(pc.OracleASCPResponsibilities__c, 'not entered');
                    string oracleEBS = ViasatUtilityClass.replaceNullForString(pc.OracleEBSResponsibilities__c, 'not entered');
                    string oracleOBIEE = ViasatUtilityClass.replaceNullForString(pc.OracleOBIEEResponsibilities__c, 'not entered');
                    string[] oracleArgs = new string[] { oracleASCP, oracleEBS, oracleOBIEE   };
                    oracleCase.DescriptionRichText__c = string.format(ITSMSConstants.ORACLE_DESCRIPTION, oracleArgs);   
                    oracleCase.ManagerUser__c = pc.ManagerUser__c;
                    oracleCase.Origin = pc.Origin;
                    oracleCase.ParentId = pc.Id;
                    oracleCase.RecordTypeId = pc.RecordTypeId;
                    oracleCase.RequestingForUser__c = pc.RequestingForUser__c;
                    oracleCase.Requestor__c = pc.Requestor__c;
                    oracleCase.ServiceDeskProduct__c = ITSMSConstants.ORACLE_PRODUCT;
                    oracleCase.ServiceRequestType__c = ITSMSConstants.ORACLE_SERVICEREQUESTTYPE;
                    oracleCase.SupportCategory__c = ITSMSConstants.NEWHIRE;
                    oracleCase.OracleASCPResponsibilities__c = pc.OracleASCPResponsibilities__c;
                    oracleCase.OracleEBSResponsibilities__c = pc.OracleEBSResponsibilities__c;
                    oracleCase.OracleOBIEEResponsibilities__c = pc.OracleOBIEEResponsibilities__c;
                    oracleCase.OracleRequired__c = pc.OracleRequired__c;
                    string[] oracleSubjArgs = new string[] {  pc.FirstName__c, pc.LastName__c, StartDate }; 
                    oracleCase.Subject = string.format(ITSMSConstants.ORACLE_SUBJECT, oracleSubjArgs);  
                    oracleCase.Type = pc.Type;
                    childCases.add(oracleCase);
                }
                // check if case for Permissions is needed
                if (pc.SecurityGroups__c != null || pc.DistributionGroup__c != null || pc.SharedMailboxes__c != null || pc.NetworkDirectoryAccessLevel__c != null)
                {
                    Case permitCase = new Case();
                    permitCase.Category__c = ITSMSConstants.PERMISSION_CATEGORY;
                    permitCase.CategoryDetails__c = ITSMSConstants.PERMISSION_CATEGORYDETAIL;
                    permitCase.ContactId = pc.NewHireContact__c;
                    // format concatenated description using form fields
                    string securityGroups = ViasatUtilityClass.replaceNullForString(pc.SecurityGroups__c, 'not entered');
                    string distGroup = ViasatUtilityClass.replaceNullForString(pc.DistributionGroup__c , 'not entered');
                    string sharedMailbox = ViasatUtilityClass.replaceNullForString(pc.SharedMailboxes__c, 'not entered');
                    string networkDirectory = ViasatUtilityClass.replaceNullForString(pc.NetworkDirectoryAccessLevel__c, 'not entered');
                    string[] permissionArgs = new string[] {securityGroups, distGroup, sharedMailbox, networkDirectory};
                    permitCase.DescriptionRichText__c = string.format(ITSMSConstants.PERMISSION_DESCRIPTION, permissionArgs);  
                    permitCase.ManagerUser__c = pc.ManagerUser__c;
                    permitCase.Origin = pc.Origin;
                    permitCase.ParentId = pc.Id;
                    permitCase.RecordTypeId = pc.RecordTypeId;
                    permitCase.NewHireType__c = pc.NewHireType__c;
                    permitCase.EmployeeType__c = pc.EmployeeType__c;                    
                    permitCase.RequestingForUser__c = pc.RequestingForUser__c;
                    permitCase.Requestor__c = pc.Requestor__c;
                    permitCase.ServiceDeskProduct__c = ITSMSConstants.PERMISSION_PRODUCT;
                    permitCase.SupportCategory__c = ITSMSConstants.NEWHIRE;
                    permitCase.ServiceRequestType__c = ITSMSConstants.PERMISSION_SERVICEREQUESTTYPE;
                    permitCase.SecurityGroups__c = pc.SecurityGroups__c;
                    permitCase.DistributionGroup__c = pc.DistributionGroup__c;
                    permitCase.SharedMailboxes__c = pc.SharedMailboxes__c;
                    permitCase.NetworkDirectoryAccessLevel__c = pc.NetworkDirectoryAccessLevel__c;
                    
                    string[] permissionSubjArgs = new string[] {  pc.FirstName__c, pc.LastName__c, StartDate }; 
                    permitCase.Subject = string.format(ITSMSConstants.PERMISSION_SUBJECT, permissionSubjArgs); 
                    permitCase.Type = pc.Type;
                    childCases.add(permitCase);
                }
                // check if case for WIKI access is needed
                if (pc.WIKIRequired__c == 'Yes' || ITSMSConstants.WIKI_OPTIONS.contains('#'+pc.WIKIRequired__c +'#'))
                {
                    Case wikiCase = new Case();
                    wikiCase.Category__c = ITSMSConstants.WIKI_CATEGORY;
                    wikiCase.CategoryDetails__c = ITSMSConstants.WIKI_CATEGORYDETAIL;
                    wikiCase.ContactId = pc.NewHireContact__c;
                    string[] wikiArgs = new string[] { pc.JustificationWIKIURLs__c};        
                    wikiCase.DescriptionRichText__c = string.format(ITSMSConstants.WIKI_DESCRIPTION, wikiArgs);
                    wikiCase.ManagerUser__c = pc.ManagerUser__c;
                    wikiCase.Origin = pc.Origin;
                    wikiCase.ParentId = pc.Id;
                    wikiCase.RecordTypeId = pc.RecordTypeId;
                    wikiCase.NewHireType__c = pc.NewHireType__c;
                    wikiCase.EmployeeType__c = pc.EmployeeType__c;                    
                    wikiCase.RequestingForUser__c= pc.RequestingForUser__c;
                    wikiCase.Requestor__c = pc.Requestor__c;
                    wikiCase.WIKIRequired__c = pc.WIKIRequired__c;
                    wikiCase.JustificationWIKIURLs__c = pc.JustificationWIKIURLs__c;
                    wikiCase.ServiceDeskProduct__c = ITSMSConstants.WIKI_PRODUCT;
                    wikiCase.ServiceRequestType__c = ITSMSConstants.WIKI_SERVICEREQUESTTYPE;
                    wikiCase.SupportCategory__c = ITSMSConstants.NEWHIRE;
                    string[] wikiSubjArgs = new string[] {  pc.FirstName__c, pc.LastName__c, StartDate}; 
                    wikiCase.Subject = string.format(ITSMSConstants.WIKI_SUBJECT, wikiSubjArgs); 
                    wikiCase.Type = pc.Type;
                    childCases.add(wikiCase);
                }
                // check if case for Remote access is needed
                if (pc.IsRemoteAccessRequired__c == 'Yes'|| ITSMSConstants.REMOTE_OPTIONS.contains('#'+pc.IsRemoteAccessRequired__c +'#'))
                {
                    Case remoteCase = new Case();
                    remoteCase.Category__c = ITSMSConstants.REMOTE_CATEGORY;
                    remoteCase.CategoryDetails__c = ITSMSConstants.REMOTE_CATEGORYDETAIL;
                    remoteCase.ContactId = pc.NewHireContact__c;
                    string[] remoteArgs = new string[] { pc.IsRemoteAccessRequired__c };
                    remoteCase.DescriptionRichText__c = string.format(ITSMSConstants.REMOTE_DESCRIPTION, remoteArgs);
                    remoteCase.ManagerUser__c = pc.ManagerUser__c;
                    remoteCase.Origin = pc.Origin;
                    remoteCase.ParentId = pc.Id;
                    remoteCase.RecordTypeId = pc.RecordTypeId;
                    remoteCase.NewHireType__c = pc.NewHireType__c;
                    remoteCase.EmployeeType__c = pc.EmployeeType__c;                    
                    remoteCase.RequestingForUser__c= pc.RequestingForUser__c;
                    remoteCase.Requestor__c = pc.Requestor__c;
                    remoteCase.IsRemoteAccessRequired__c = pc.IsRemoteAccessRequired__c;
                    remoteCase.ServiceDeskProduct__c = ITSMSConstants.REMOTE_PRODUCT;
                    remoteCase.ServiceRequestType__c = ITSMSConstants.REMOTE_SERVICEREQUESTTYPE;
                    remoteCase.SupportCategory__c = ITSMSConstants.NEWHIRE;
                    string[] remoteSubjArgs = new string[] {  pc.FirstName__c, pc.LastName__c, StartDate}; 
                    remoteCase.Subject = string.format(ITSMSConstants.REMOTE_SUBJECT, remoteSubjArgs); 
                    remoteCase.Type = pc.Type;
                    childCases.add(remoteCase);
                }
                // check if Perforce case is needed
                if (pc.IsPerforceAccessRequired__c == 'Yes' || ITSMSConstants.PERFORCE_OPTIONS.contains('#'+pc.IsPerforceAccessRequired__c +'#'))
                {
                    Case perforceCase = new Case();
                    perforceCase.Category__c = ITSMSConstants.PERFORCE_CATEGORY;
                    perforceCase.CategoryDetails__c = ITSMSConstants.PERFORCE_CATEGORYDETAIL;
                    perforceCase.ContactId = pc.NewHireContact__c;
                    string[] perforceArgs = new string[] {pc.PerforceServerFolders__c};
                    perforceCase.DescriptionRichText__c = string.format(ITSMSConstants.PERFORCE_DESCRIPTION, perforceArgs);
                    perforceCase.ManagerUser__c = pc.ManagerUser__c;
                    perforceCase.Origin = pc.Origin;
                    perforceCase.ParentId = pc.Id;
                    perforceCase.RecordTypeId = pc.RecordTypeId;
                    perforceCase.NewHireType__c = pc.NewHireType__c;
                    perforceCase.EmployeeType__c = pc.EmployeeType__c;                    
                    perforceCase.RequestingForUser__c= pc.RequestingForUser__c;
                    perforceCase.Requestor__c = pc.Requestor__c;
                    perforceCase.IsPerforceAccessRequired__c = pc.IsPerforceAccessRequired__c;
                    perforceCase.PerforceServerFolders__c = pc.PerforceServerFolders__c;
                    perforceCase.ServiceDeskProduct__c = ITSMSConstants.PERFORCE_PRODUCT;
                    perforceCase.ServiceRequestType__c = ITSMSConstants.PERFORCE_SERVICEREQUESTTYPE;
                    perforceCase.SupportCategory__c = ITSMSConstants.NEWHIRE;
                    string[] perforceSubjArgs = new string[] { pc.FirstName__c, pc.LastName__c, StartDate };
                    perforceCase.Subject = string.format(ITSMSConstants.PERFORCE_SUBJECT, perforceSubjArgs); 
                    perforceCase.Type = pc.Type;
                    childCases.add(perforceCase);
                }
                //  check if Agile case is needed
                if (pc.AgileAccessRequired__c == 'Yes'|| ITSMSConstants.AGILE_OPTIONS.contains('#'+pc.AgileAccessRequired__c +'#'))
                {
                    Case agileCase = new Case();
                    agileCase.Category__c = ITSMSConstants.AGILE_CATEGORY;
                    agileCase.CategoryDetails__c = ITSMSConstants.AGILE_CATEGORYDETAIL;
                    agileCase.ContactId = pc.NewHireContact__c;
                    string accessLevel = ViasatUtilityClass.replaceNullForString(pc.AgileAccessLevel__c, 'not entered');
                    string additionalRoles = ViasatUtilityClass.replaceNullForString(pc.AdditionalAgileRolesRequired__c, 'not entered');
                    string modeledAccount = ViasatUtilityClass.replaceNullForString(pc.AgileModelUser__c, 'not entered');
                    if (pc.AgileModelUser__c!= null)
                        modeledAccount = pc.AgileModelUser__r.FirstName+' '+pc.AgileModelUser__r.LastName;
                    string[] agileArgs = new string[] { pc.AgileAccessRequired__c, accessLevel, additionalRoles, modeledAccount};
                    agileCase.DescriptionRichText__c = string.format(ITSMSConstants.AGILE_DESCRIPTION, agileArgs);
                    agileCase.ManagerUser__c = pc.ManagerUser__c;
                    agileCase.Origin = pc.Origin;
                    agileCase.ParentId = pc.Id;
                    agileCase.RecordTypeId = pc.RecordTypeId;
                    agileCase.NewHireType__c = pc.NewHireType__c;
                    agileCase.EmployeeType__c = pc.EmployeeType__c;                    
                    agileCase.RequestingForUser__c = pc.RequestingForUser__c;
                    agileCase.Requestor__c = pc.Requestor__c;
                    agileCase.ServiceDeskProduct__c = ITSMSConstants.AGILE_PRODUCT;  
                    agileCase.SupportCategory__c = ITSMSConstants.NEWHIRE;
                    agileCase.AgileAccessLevel__c = pc.AgileAccessLevel__c;
                    agileCase.AdditionalAgileRolesRequired__c = pc.AdditionalAgileRolesRequired__c;
                    agileCase.AgileModelUser__c = pc.AgileModelUser__c;
                    agileCase.ServiceRequestType__c = ITSMSConstants.AGILE_SERVICEREQUESTTYPE;
                    string[] agileSubjArgs = new string[] { pc.FirstName__c, pc.LastName__c, StartDate };
                    agileCase.Subject = string.format(ITSMSConstants.AGILE_SUBJECT, agileSubjArgs); 
                    agileCase.Type = pc.Type;
                    childCases.add(agileCase);
                }
                // check if Subscriber/BackOffice case is needed
                if (ITSMSConstants.SUBSCRIBE_OPTIONS.contains('#'+pc.BackofficeSystemsAccess__c+'#'))
                {
                    Case subscriberCase = new Case();
                    subscriberCase.Category__c = ITSMSConstants.SUBSCRIBE_CATEGORY;
                    subscriberCase.CategoryDetails__c = ITSMSConstants.SUBSCRIBE_CATEGORYDETAIL;
                    subscriberCase.ContactId = pc.NewHireContact__c;
                    string exedeBackOffice = ViasatUtilityClass.replaceNullForString(pc.ExedeBackOfficeJumpBox__c , 'not entered');
                    string systemDetails = ViasatUtilityClass.replaceNullForString(pc.BackofficeSystemDetails__c , 'not entered');
                    string[] subscribeArgs = new string[] { pc.BackofficeSystemsAccess__c, exedeBackOffice, systemDetails};
                    subscriberCase.DescriptionRichText__c = string.format(ITSMSConstants.SUBSCRIBE_DESCRIPTION, subscribeArgs);
                    subscriberCase.ManagerUser__c = pc.ManagerUser__c;
                    subscriberCase.Origin = pc.Origin;
                    subscriberCase.ParentId = pc.Id;
                    subscriberCase.RecordTypeId = pc.RecordTypeId;
                    subscriberCase.NewHireType__c = pc.NewHireType__c;
                    subscriberCase.EmployeeType__c = pc.EmployeeType__c;                    
                    subscriberCase.RequestingForUser__c= pc.RequestingForUser__c;
                    subscriberCase.Requestor__c = pc.Requestor__c;
                    subscriberCase.ExedeBackOfficeJumpBox__c = pc.ExedeBackOfficeJumpBox__c;
                    subscriberCase.BackofficeSystemDetails__c = pc.BackofficeSystemDetails__c;
                    subscriberCase.BackofficeSystemsAccess__c = pc.BackofficeSystemsAccess__c;
                    subscriberCase.ServiceDeskProduct__c = ITSMSConstants.SUBSCRIBE_PRODUCT;
                    subscriberCase.SupportCategory__c = ITSMSConstants.NEWHIRE;
                    subscriberCase.ServiceRequestType__c = ITSMSConstants.SUBSCRIBE_SERVICEREQUESTTYPE;
                    string[] subscribeSubjArgs = new string[] { pc.FirstName__c, pc.LastName__c, StartDate};
                    subscriberCase.Subject = string.format(ITSMSConstants.SUBSCRIBE_SUBJECT, subscribeSubjArgs); 
                    subscriberCase.Type = pc.Type;
                    childCases.add(subscriberCase);
                }
                // check if Telecom case is needed
                if (pc.NOCAgents__c == true)
                {
                    Case telecomCase = new Case();
                    telecomCase.Category__c = ITSMSConstants.TELECOM_CATEGORY;
                    telecomCase.CategoryDetails__c = ITSMSConstants.TELECOM_CATEGORYDETAIL;
                    telecomCase.ContactId = pc.NewHireContact__c;
                    string mirrorAgent = ViasatUtilityClass.replaceNullForString(pc.AgentToMirror__c , 'not entered');
                    if (pc.AgentToMirror__c != null)
                        mirrorAgent = pc.AgentToMirror__r.FirstName+' '+pc.AgentToMirror__r.LastName;
                    string[] telecomArgs = new string[] {string.valueOf(pc.NOCAgents__c), mirrorAgent};
                    telecomCase.DescriptionRichText__c = string.format(ITSMSConstants.TELECOM_DESCRIPTION, telecomArgs);
                    telecomCase.ManagerUser__c = pc.ManagerUser__c;
                    telecomCase.Origin = pc.Origin;
                    telecomCase.ParentId = pc.Id;
                    telecomCase.RecordTypeId = pc.RecordTypeId;
                    telecomCase.NewHireType__c = pc.NewHireType__c;
                    telecomCase.EmployeeType__c = pc.EmployeeType__c;                    
                    telecomCase.RequestingForUser__c= pc.RequestingForUser__c;
                    telecomCase.Requestor__c = pc.Requestor__c;
                    telecomCase.AgentToMirror__c = pc.AgentToMirror__c;
                    telecomCase.NOCAgents__c = pc.NOCAgents__c;
                    telecomCase.ServiceDeskProduct__c = ITSMSConstants.TELECOM_PRODUCT;
                    telecomCase.SupportCategory__c = ITSMSConstants.NEWHIRE;
                    telecomCase.ServiceRequestType__c = ITSMSConstants.TELECOM_SERVICEREQUESTTYPE;
                    string[] telecomSubjArgs = new string[] { pc.FirstName__c, pc.LastName__c, StartDate};
                    telecomCase.Subject = string.format(ITSMSConstants.TELECOM_SUBJECT, telecomSubjArgs); 
                    telecomCase.Type = pc.Type;
                    childCases.add(telecomCase);
                }
                pc.ChildCasesCreated__c = true;
            }
        }
        // insert new child cases     
        if (childCases.size() > 0)
        {
            //   Fetch the assignment rules on case
            AssignmentRule assignRule = new AssignmentRule();
            assignRule = [select id from AssignmentRule where SobjectType = 'Case' and Active = true limit 1];
            if (assignRule != null)
            {
                //  Create DMLOptions for "Assign using active assignment rules" checkbox
                Database.DMLOptions dmlOpts = new Database.DMLOptions();
                dmlOpts.assignmentRuleHeader.assignmentRuleId= assignRule.id;
                //   Set DMLOption on each case instance so that assignment rules are executed
                for (Case c:childCases)
                {
                    c.setOptions(dmlOpts);
                }
            }
            ITSMSUtilityClass.insertCases(childCases);
        }
        // update parent cases as these were updated with the new hire contact
        // and flag indicating child cases were generated 
        if (parentCases.size() > 0)
            ITSMSUtilityClass.updateCases(parentCases);
        // execute send of email 
        ITSMSNewHireEmailNotice.sendNewHireNotice(parentCaseIds);
    }
}