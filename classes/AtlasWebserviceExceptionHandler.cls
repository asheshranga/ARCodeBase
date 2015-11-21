/*********************************************************************************
Name         : Atlas_Webservice_ExceptionHandler
Created By   : NTT Data
Modified BY  : 
Company Name : NTT Data
Project      : ViaSat Atlas, Bangalore
Created Date : 18 October2013
Usages       : Used to handle Exceptions during Webservice Callouts.
*********************************************************************************/
//To log WebserviceName,Request,Response,ErrorMessage,InboundOrOutbound,IsError
public class AtlasWebserviceExceptionHandler{
    
    public static Atlas_Webservice_Log__c insertWebserviceLog(String WebserviceName, String Request,
                  String Response,String ErrorMessage, String InboundOrOutbound, Boolean IsError)
    {
        Atlas_Webservice_Log__c wLog=new Atlas_Webservice_Log__c();
        wLog.Webservice_Name__c=WebserviceName;
        wLog.Request__c=Request;
        wLog.Response__c=Response;
        wLog.Error_Message__c=ErrorMessage;
    wLog.Inbound_Outbound__c=InboundOrOutbound;
        If(IsError == True)
            wLog.IsError__c=AtlasConstants.TRUE_VALUE;
        else
            wLog.IsError__c='False';        
        return wLog;
    }
    //To update the webservice log object
    public static Atlas_Webservice_Log__c updateWebserviceLog(Atlas_Webservice_Log__c wl)
    {
        update wl;
        return wl;
    }
}