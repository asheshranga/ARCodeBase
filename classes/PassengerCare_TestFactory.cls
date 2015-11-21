@isTest public class PassengerCare_TestFactory{
    //--- Returns a valid Mock Contact
    public static Contact buildTestContact(String FName, String LName, String email){
        Contact newContact = new Contact();
        newContact.Accountid = PassengerCareUtility.getObjectIdByName('account', PassengerCareConstants.ACCOUNT_NAME);
        newContact.FirstName = FName;
        newContact.LastName = LName;
        newContact.Email = email;
        return newContact;              
    }
}