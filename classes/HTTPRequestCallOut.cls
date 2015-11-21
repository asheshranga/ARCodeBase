public class HTTPRequestCallOut {
   public class HTTPRequestCallOutException extends Exception {}
   
   //--------------------------------------------------------------------------
   //--- Method to invoke a HTTP Request
   //--------------------------------------------------------------------------   
   public static HTTPResponse invokeService (String asEndPoint, String asMethod, Integer aiTimeOut, String asContentType, String asCookie) {
      HttpRequest req = new HttpRequest();
      HTTPResponse res = null;
      Http http = null;
       
      http = new Http();
      try {
      
         //--- Set the request properties
         req.setMethod(asMethod);
         req.setEndpoint(asEndPoint);
         req.setTimeout(aiTimeOut);

        if (Test.isRunningTest())
            req.setBody('<soapenv:Envelope><soapenv:Body>Call 1</soapenv:Body></soapenv:Envelope>');
      
         //--- Set content type and cookie if passed
         if ((asContentType != null) && (!asContentType.trim().equals('')))
               req.setHeader('Content-type', asContentType);

         if ((asCookie != null) && (!asCookie.trim().equals('')))
               req.setHeader('Cookie', asCookie);
               
         //--- Execute web service call here
         res = http.send(req);          
      } catch(Exception e) {
         System.debug('Error Invoking Service' + e.getMessage());
         throw  new HTTPRequestCallOutException('Error Invoking Service - ' + e.getMessage());
      }
      
      return res;
   }
}