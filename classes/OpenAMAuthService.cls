public class OpenAMAuthService {

   public class OpenAMAuthServiceException extends Exception {} 

   //--------------------------------------------------------------------------
   //--- Method to get the OpenAM Token
   //--------------------------------------------------------------------------
   public static String getAuthToken(String asOpenAMBaseURL, String asUserName, String asPassword) {
      String lsToken = null;

      String lsEndPoint = '%BASEURL%/identity/authenticate?username=%USERNAME%&password=%PASSWORD%';
      
      if (asOpenAMBaseURL != null)
         lsEndPoint = lsEndPoint.replaceALL('%BASEURL%',asOpenAMBaseURL);

      if (asUserName != null)
         lsEndPoint = lsEndPoint.replaceALL('%USERNAME%',asUserName);

      if (asPassword != null)
         lsEndPoint = lsEndPoint.replaceALL('%PASSWORD%',asPassword);
         
      try {
         //--- Execute web service call here
         HTTPResponse res = HTTPRequestCallOut.invokeService(lsEndPoint,'POST',9000,'',''); 
         if (res!=null) {
            Integer liStatus = res.getStatusCode();
            String lsReturn = res.getBody();
                        
            if ((liStatus==200) && (lsReturn!=null))  {
               List<string> loReturnLines = lsReturn.split('\r');
               for (string lsLine: loReturnLines) {
                  if (lsLine.indexOf('token.id=')>=0)
                     lsToken = lsReturn.replaceAll('token.id=','').trim();
               }
            }

            system.debug('OpenAM Auth Response Status = ' + liStatus);
            system.debug('OpenAM Auth Response Body = ' + lsReturn);        
            system.debug('Token ID = ' + lsToken);             
         }
      } catch(Exception e) {
         System.debug('Error Invoking OpenAM Auth Service' + e.getMessage());
         throw  new OpenAMAuthServiceException('Error Invoking OpenAM Auth Service - ' + e.getMessage());
      } 
      
      return lsToken;
   }
   
   
   //--------------------------------------------------------------------------
   //--- Method to Validate OpenAM Token
   //--------------------------------------------------------------------------
   public static Boolean validateToken(String asOpenAMBaseURL, String asToken) {
      Boolean lbValid = false;
      
      String lsEndPoint = '%BASEURL%/identity/isTokenValid?tokenid=%TOKEN%';
      
      if (asOpenAMBaseURL != null)
         lsEndPoint = lsEndPoint.replaceALL('%BASEURL%',asOpenAMBaseURL);
         
      if (asToken != null)
         lsEndPoint = lsEndPoint.replaceALL('%TOKEN%',asToken);   
         
      try {
         //--- Execute web service call here
         HTTPResponse res = HTTPRequestCallOut.invokeService(lsEndPoint,'GET',9000,'',''); 
         if (res!=null) {
            Integer liStatus = res.getStatusCode();
            String lsReturn = res.getBody();
                        
            if ((liStatus==200) && (lsReturn!=null))  {
               List<string> loReturnLines = lsReturn.split('\r');
               for (string lsLine: loReturnLines) {
                  if (lsLine.indexOf('boolean=')>=0)
                     lbValid = Boolean.valueOf(lsReturn.replaceAll('boolean=','').trim());
               }
            }

            system.debug('OpenAM Valid Token Response Status = ' + liStatus);
            system.debug('OpenAM Valid Token Response Body = ' + lsReturn);        
            system.debug('Valid Token? ' + lbValid);             
         }
      } catch(Exception e) {
         System.debug('Error Invoking OpenAM Valid Token Service' + e.getMessage());
         throw  new OpenAMAuthServiceException('Error Invoking OpenAM Auth Valid Token Service - ' + e.getMessage());
      } 
      
      return lbValid;        
   }
}