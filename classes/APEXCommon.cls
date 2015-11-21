/*********************************************************************************
Name:              APEXCommon
Created By :       Rakesh ------
Created Date:      7th August 15
Project:           Virgin America
Usage:             It is common class between classes : It contain common code
*********************************************************************************/
public with sharing class APEXCommon
{
    // send email to user
    public static void SendSingleEmailViaUserId(Id targetId,string subject, string body)
    {
        try
        {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setTargetObjectId(targetId);
            mail.setSaveAsActivity(false);
            mail.setSubject(subject);
            mail.setHtmlBody(body); 
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });  
           
        }
        catch(Exception e)
        {
            system.debug('#Error:'+e);
        }
    }
}