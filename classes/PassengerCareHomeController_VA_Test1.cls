/*
    Test Class : PassengerCareHomeController_VA_Test1
    Controller : PassengerCareHomeController_VA
    Created By : Rakesh
    Created Date : 25th August 15
    Description : 
    Log :        
*/

@isTest(seeAllData=true)
private class PassengerCareHomeController_VA_Test1 
{
    static testMethod void UnitTest() 
    {
       Case EmailCase = new case(Subject='subj',suppliedEmail='Test@gmail.com',SuppliedName='Test last name',description='test description',origin='phone');
      
        //Visaulforce page setup
        Test.setCurrentPageReference(new PageReference('Page.PassengerCareNewHanu'));        
        PassengerCareUtility.getQueueIdByName('PassengerCare');
        PassengerCareUtility.getObjectRecordTypeId(CASE.SObjectType,'PAssengerCare');
        PassengerCareConstants constant = new PassengerCareConstants();
        System.assertEquals(PassengerCareConstants.EMAIL_TO_US,PassengerCareConstants.EMAIL_TO_US);
 
         
         
         
        //Intialization of controller
        PassengerCareNewHanuController cont = new PassengerCareNewHanuController();        
        cont.EmailCase = EmailCase;
        //Method call        
        cont.submit();  
        cont.getLiveAgentCaseMapping();
        
        
        

     }    
}