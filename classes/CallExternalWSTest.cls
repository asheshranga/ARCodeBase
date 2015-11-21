@isTest(seealldata=true)
private class CallExternalWSTest 
{
    @isTest static void myUnitTest() 
    {
        string lsSOAPMsg = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:typ="http://viasat.com/SerialNumber/types">'+
                           '   <soapenv:Header/>'+
                           '   <soapenv:Body>'+
                           '      <typ:order>'+
                           '         <typ:linecount>1</typ:linecount>'+
                           '         <typ:account>1212</typ:account>'+
                           '         <typ:orderlines>'+
                           '            <!--Zero or more repetitions:-->'+
                           '            <typ:line serialnumber="1212" itemnumber="1212" sfrowid="a0TV0000000cnZ1MAI">?</typ:line>'+
                           '         </typ:orderlines>'+
                           '      </typ:order>'+
                           '   </soapenv:Body>'+
                           '</soapenv:Envelope>';
                              
        CallExternalWS cews = new CallExternalWS();
         cews.istest = true;
         cews.wsReturn = 'test';
         cews.wsEndPoint = 'https://ws.dev.viasat.com/Salesforce/SerialNumberWS/validateSerialNumber';
         cews.wsRequestMsg = lsSOAPMsg;
         cews.invokeExternalWs();


        
    }
}