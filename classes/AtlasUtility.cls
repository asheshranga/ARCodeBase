/*********************************************************************************
Name         : AtlasUtility
Created By   : Shiva Shankar N
Created Date : 28 October 2013
Project      : ViaSat Atlas, Bangalore
Usages       : Controller to get the values from custom settings

Change Log:
<Date>      <Modified By>       <Change Description>
4/25/2014   K. Wortel           Added isAdmin Method
*********************************************************************************/

public with sharing class AtlasUtility
{
    public static Map<String,AtlasVfPageLinks__c> MapNameTOAllVAlues=AtlasVfPageLinks__c.getAll();
    public static Map<String,AtlasKeyValueStore__c> MapKeyValue=AtlasKeyValueStore__c.getAll();
    public static Map<string,AtlasWebServiceEndPoints__c> MapWebServiceEndpoints=AtlasWebServiceEndPoints__c.getAll();
    public static Map<string,AtlasSSOWebServiceEndPoints__c> MapSSOWebServiceEndpoints=AtlasSSOWebServiceEndPoints__c.getAll();
    public static Map<String, WISPKeyValueStore__c> MapWispKeyValue=WISPKeyValueStore__c.getAll();
    /**
    *   @author Gaurav Gathania
    *   @description - method to get getURL, taking an input parameter of type String
    *   @param name - name of the field
    *   @param String -  value of input field
    */   
    public static string getURL(String name)
    { 
        try{
            return MapNameTOAllVAlues.get(name).HyperlinkAddress__c;
        }        
        catch(Exception e){
            return null;
        }         
    }
    /**
    *   @author Gaurav Gathania
    *   @description - method to get getMapCode, taking an input parameter of type String
    *   @param name - name of the field
    *   @param String -  value of input field
    */    
    public static String getMapCode(String name)
    { 
        try{
            return MapKeyValue.get(name).Code__c;
        }        
        catch(Exception e){
            return null;
        }         
    }
    /**
    *   @author Gaurav Gathania
    *   @description - method to get getMapValue, taking an input parameter of type String
    *   @param name - name of the field
    *   @param String -  value of input field
    */   
    public static String getMapValue(String name)
    { 
        try{
            return MapKeyValue.get(name).Value__c;
        }        
        catch(Exception e){
            return null;
        }         
    }
    
    /**
    *   @author Gaurav Gathania
    *   @description - method to get HyperLinkText, taking an input parameter of type String
    *   @param name - name of the field
    *   @param String -  value of input field
    */
    public static String getHyperLinkText(string name)
    {
        try{
            return MapNameTOAllVAlues.get(name).HyperlinkText__c;
        }       
        catch(Exception e){
            return null;
        }                  
    }
    
    /**
    *   @author Gaurav Gathania
    *   @description - get Visibilitytaking an input parameter of type String
    *   @param name - name of the field
    *   @param Boolean -  value of input field
    */
    public static Boolean getVisibility(string name)
    {
        try{
            return MapNameTOAllVAlues.get(name).Visible__c;
        }       
        catch(Exception e){
            return null;
        }           
    } 
    
    /**
    *   @author Gaurav Gathania
    *   @description - method to get HyperLinkText, taking an input parameter of type String
    *   @param name - name of the field
    *   @param String -  value of input field
    */
    public static String getWebServiceHost(string name)
    {
        try{
            system.debug('-- get webservice host name ---> '+name);
            return MapWebServiceEndpoints.get(name).Host__c;
        }       
        catch(Exception e){
            return null;
        }                  
    } 
     public static String getSSOWebServiceEndPoint(string name)
    {
        try{
            return MapSSOWebServiceEndpoints.get(name).Host__c;
        }       
        catch(Exception e){
            return null;
        }                  
    }
    /**
    *   @author Gaurav Gathania
    *   @description - Checks the passed in input field for emptyness and return boolean value. *
    *   @param fldName - name of the field
    *   @param msg  - message to be displayed on UI  (can be select/enter)
    *   @param value -  value of input field
    */
    public static boolean isEmpty(String value){
        boolean flag=false;
        if(value==null||value.trim().equals(AtlasConstants.BLANK)){
            flag=true;      
        }
        return flag;
    }
    
    /**
    * @author Gaurav Gathania
    *  @description Check whether list is empty
    *  @param ex Exception which is printed in system log  
    *  @return Boolean True if String is empty or null else return false
    */
    public static boolean isEmpty(List<SObject> objList){       
        if(objList==null||objList.size()==0){
            return true;
        }else {
            return false;
        }
    }
    /**
    * @author Gaurav Gathania
    *  @description Check whether sObject is null
    *  @param ex Exception which is printed in system log  
    *  @return Boolean True if Sobject is null else return false
    */
    public static boolean isEmpty(SObject obj){         
        if(obj==null){
            return true;
        }else {
            return false;
        }
    }   
    
    /**
    * @author Gaurav Gathania
    *  @description Check whether list is empty
    *  @param ex Exception which is printed in system log  
    *  @return Boolean True if String is empty or null else return false
    */
    public static boolean isEmpty(List<object> objList){        
        if(objList==null||objList.size()==0){
            return true;
        }else {
            return false;
        }
    }

    /**
    * @author Gaurav Gathania
    * @date 03/18/2013
    * @description Check whether map is empty
    * @param map<String,Object> map to check whether is empty or not  
    * @return Boolean True if map is empty or null else return false
    */
    public static boolean isEmpty(Map<String,Object> objectMap){      
        if(objectMap==null||(objectMap !=null&&objectMap.size()==0)){
            return true;
        }else { 
            return false;
        }
    }
    
    /**
    * @author Gaurav Gathania 
    * @description Check whether Object is null
    * @param object to check whether it is null or not   
    * @return Boolean True if Object is null else return false
    */
    public static boolean isEmpty(Object obj){       
        if(obj==null){
            return true;
        }else {
            return false;
        }
    }  
    /**
    * @author shiva 
    * @description to send exception email
    * @param string to send exception   
    */
    public static void sendExceptionEmail(String Str)
    {
        Messaging.SingleEmailMessage mail=new Messaging.SingleEmailMessage();
        mail.setToAddresses(AtlasConstants.toAddresses);

        mail.setSubject('Webservice Issues : Exception cause at AtlasIntegration Utility by User :'+UserInfo.getUserName());
        mail.setSaveAsActivity(false);
        mail.setPlainTextBody('Test mail');
        mail.setHtmlBody(Str);
        mail.setUseSignature(true);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail});
    }
    /**
    * @author shiva 
    * @description to send exception email
    * @param string to send exception   
    */
    public static void sendExceptionEmail(String Str,String emailAdd)
    {
        Messaging.SingleEmailMessage mail=new Messaging.SingleEmailMessage();
         String[] toAddresses=new String[]{emailAdd};
        mail.setToAddresses(toAddresses);

        mail.setSubject('Webservice Issues : Exception cause at AtlasIntegration Utility by User :'+UserInfo.getUserName());
        mail.setSaveAsActivity(false);
        mail.setPlainTextBody('Test mail');
        mail.setHtmlBody(Str);
        mail.setUseSignature(true);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail});
    }
    /**
    public Static String walkThrough(DOM.XMLNode node){
        String result='\n';
        if (node.getNodeType()==DOM.XMLNodeType.COMMENT){
            return 'Comment('+node.getText()+')';
        }
        if (node.getNodeType()==DOM.XMLNodeType.TEXT){
            return 'Text('+node.getText()+')';
        }
        if (node.getNodeType()==DOM.XMLNodeType.ELEMENT){
            result+='Element:'+node.getName();
            if (node.getText().trim()!=''){
                result+=',text='+node.getText().trim();
            }
            if (node.getAttributeCount()>0){ 
                for (Integer i=0;i< node.getAttributeCount();i++){
                    result+=',attribute #'+i+':'+node.getAttributeKeyAt(i)+'='+node.getAttributeValue(node.getAttributeKeyAt(i), node.getAttributeKeyNsAt(i));
                }  
            }
            for (Dom.XMLNode child: node.getChildElements()){
                result+=walkThrough(child);
            }
            return result;
        }
        return AtlasConstants.BLACK_SPACE; //should never reach here 
    }
    **/
    
    /**
    *  @author Gaurav Gathania
    *  @description populateExceptionString on the DTO object
    *  @param String ClassNameMethodName
    *  @param AtlasParentDTO dtoObj,
    *  @param Exception e
    *  @return Boolean True if String is empty or null else return false
    */
    public static AtlasParentDTO populateExceptionString(String ClassNameMethodName,AtlasParentDTO dtoObj,Exception e)
    {
        if(e instanceOf AtlasException)
        {   
            AtlasException ex=(AtlasException)e;
            dtoObj.exceptionStr=ex.errorMessage;            
        }
        else
            dtoObj.exceptionStr='';
        dtoObj.isPopulated=false;
        return dtoObj;
    }
    /**
    *  @author Gaurav Gathania
    *  @description populateSuccess on the DTO object and nullify Excepton
    *  @param String ClassNameMethodName
    *  @param AtlasParentDTO dtoObj 
    *  @return Boolean True if String is empty or null else return false
    */
    public static AtlasParentDTO populateSuccess(AtlasParentDTO dtoObj)
    {
        dtoObj.exceptionStr=null;
        dtoObj.isPopulated=true;
        return dtoObj;
    }
    
    /**
    *  @author shiva shankar
    *  @description randomNumberGenerator
    *  @param nul
    *  @param null
    *  @return integer 
    */
    public static integer randomNumberGenerator()
    {
        try
        {
            if(integer.valueof(getMapValue(AtlasConstants.NO_OF_SERVERS))!=0)
            {   
                system.debug('---AtlasConstants.NO_OF_SERVERS---> '+ AtlasConstants.NO_OF_SERVERS);
                Integer i=Math.round((Math.random() * (integer.valueof(getMapValue(AtlasConstants.NO_OF_SERVERS)) - 1)) + 1);
                return i;
            }
            else
            return 1;
        }catch(Exception e)
        {
            return 1;
        }
        
    }
    
    /**
    *   @author Kelly Wortel
    *   @description - Checks if the logged in user is allowed to "log-in" as a user.
    */
    public static boolean isAdmin(){
        
        // Load in the custom setting for Admin Profiles
        AtlasKeyValueStore__c AtlasKVS = AtlasKeyValueStore__c.getValues('Admin Profiles');
        String adminProfiles = AtlasKVS.Value__c;
        // Check if the current user is an authorized Admin
        return adminProfiles.contains(UserInfo.getProfileId().left(15));
                
    } 
    
    /**
    *   @author Gaurav Gathania
    *   @description - method to get getMapValue from Wisp, taking an input parameter of type String
    *   @param name - name of the field
    *   @param String -  value of input field
    */   
    public static String getMapWispValue(String name)
    { 
        try{
            return MapWispKeyValue.get(name).Value__c;
        }        
        catch(Exception e){
            return null;
        }         
    }  
    
    /**
    *   @author Tejesh Kumar
    *   @description - method to get Wisp Url, taking an input parameter of type String
    *   @param name - name of the field
    *   @param String -  value of input field
    */   
    public static string getWispURL(String name)
    { 
        try{
            return MapWispKeyValue.get(name).URL__c;
        }        
        catch(Exception e){
            return null;
        }         
    } 


    //---------------------------------------------------------------------------
    // Commonly used methods that generate Timestamps, Nounce
    //---------------------------------------------------------------------------
    
    // Generate created timestamp in GMT
    public static String generatecreatedTimestamp()
    {
       return DateTime.now().addminutes(-5).formatgmt('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
    }
    // Generate expires timestamp in GMT
    public static String generateexpiredTimestamp()
    {
       return DateTime.now().addMinutes(5).formatgmt('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');          
    }
    // Generate timestamp in GMT
    public static String generateTimestamp()
    {
       return DateTime.now().formatgmt('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
    }
    // Generate Nounce, random number base64 encoded
    public static String generateNounce()
    {
        return EncodingUtil.base64Encode(Blob.valueOf(String.valueOf(Crypto.getRandomLong())));
    }
}