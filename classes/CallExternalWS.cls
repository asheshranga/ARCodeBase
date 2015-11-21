public with sharing class  CallExternalWS {
    Public String wsEndPoint { get {return wsEndPoint;} set;}
    Public String wsRequestMsg {get {return wsRequestMsg;} set;}
    Public String timenow {get;set;}
    public boolean istest{get;set;}
    Public String getthetime()
    {
        return String.valueof(System.now());
    }
    Public String wsReturn { 
       get { return wsReturn ; }      
       set;    
    }
    
    public CallExternalWS () {
        timenow = string.valueof(System.now());
        istest=false;
    }
    
    public void invokeExternalWs() {
        HttpRequest req = new HttpRequest();
        //AtlasAccInfoWsdlPublicwebse.AccountInfoEndpoint testws = new AtlasAccInfoWsdlPublicwebse.AccountInfoEndpoint();
        //testws.endpoint_x = 'https://webservices.test.wildblue.net/AccountInfoService/services/AccountInfoService';
        //AtlasAccInfoXmlschemaPublic.billingSummary response = testws.getBillingSummary('-30N2oYkYXFepplHUgLC2Vd7wd6qKbMk9txAtl7w9QBRO_6BlZh6wrNoR8IOkKzYEWOWNBcuRC2lY6WHxaa49vyKWNbzLdQHm7uMx2NosdnvM7ktGTTlUEwBAx_GYjtNPcYYbgcTRXM');
        //Set HTTPRequest Method
        
        req.setMethod('POST');
        //req.setEndpoint('https://ws.dev.viasat.com/Salesforce/SerialNumberWS/validateSerialNumber');
        req.setEndpoint(wsEndPoint);
        req.setTimeout(80000);
        req.setHeader('Content-Type', 'text/xml; charset=utf-8');
        req.setHeader('SOAPAction', wsEndPoint);
        
        string lsSOAPMsg = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:typ="http://viasat.com/SerialNumber/types">'+
                           '   <soapenv:Header/>'+
                           '   <soapenv:Body>'+
                           '      <typ:order>'+
                           '         <typ:linecount>112</typ:linecount>'+
                           '         <typ:account>1212</typ:account>'+
                           '         <typ:orderlines>'+
                           '            <!--Zero or more repetitions:-->'+
                           '            <typ:line serialnumber="1212" itemnumber="1212" sfrowid="1212">?</typ:line>'+
                           '         </typ:orderlines>'+
                           '      </typ:order>'+
                           '   </soapenv:Body>'+
                           '</soapenv:Envelope>';
        req.setBody(wsRequestMsg);
        
        Http http = new Http();
        try {
          //Execute web service call here       
          HTTPResponse res = http.send(req);   
        
          //Helpful debug messages
          wsReturn = res.getBody();
//wsReturn = 'got Data1';
                    
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Successfully executed the web service. Status=' + res.getStatus() + ' Status Code=' + res.getStatusCode()));
       } catch(Exception e) {
            System.debug('Error Invoking the service' + e.getMessage());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ooops! Unable to invoke the service - ' + e.getMessage()));
       }       
    }
}