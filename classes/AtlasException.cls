/*********************************************************************************
Name         : AtlasException
Created By   : Gaurav Gathania
Modified BY  : Gaurav Gathania
Company Name : NTT Data
Project      : ViaSat Atlas, Bangalore
Created Date : 13 November 2013
Modified Date: 14 November 2013
Usages       : To handle the all types of exceptions
*********************************************************************************/
global virtual with sharing class AtlasException  extends Exception{
	
	
	global String errorCode{get;set;}
	global String errorMessage{get;set;}
	
	
	/**
 	 * @author Gaurav Gathania
 	 * @date 11/14/2013
 	 * @description - This Subtype of AtlasException is thrown when input parameters to service method are incorrect
 	 *				  For this type of exception codes will start with 'A_IDE_'   	
 	 */
	global class InputDataException extends AtlasException
	{
		global InputDataException(String errorCode,String errorMessage){
			super(errorMessage);
            this.errorCode=errorCode;
            this.errorMessage=errorMessage;
       }
    } 
		
	/**
 	 * @author Gaurav Gathania
 	 * @date 11/14/2013
 	 * @description - This Subtype of AtlasException is thrown when any business rule is violated
 	 *				  For this type of exception codes will start with 'A_BRE_'   	
 	 */
	global class BusinessRuleException extends AtlasException
	{
		global BusinessRuleException(String errorCode,String errorMessage){
            super(errorMessage);
            this.errorCode=errorCode;
            this.errorMessage=errorMessage;
       }
    }	
	
	/**
 	 * @author Gaurav Gathania
 	 * @date 11/14/2013
 	 * @description - This Subtype of AtlasException is thrown when any exception is generated  while accessing data
 	 *				  For this type of exception codes will start with 'A_DAE_'   	
 	 */
	global class DataAccessException extends AtlasException
	{
		global DataAccessException(String errorCode,String errorMessage){
			super(errorMessage);
            this.errorCode=errorCode;
            this.errorMessage=errorMessage;
       }
    }
    
    /**
 	 * @author Gaurav Gathania
 	 * @date 11/14/2013
 	 * @description - This Subtype of AtlasException is thrown when exception is generated while performing DML operation
 	 *				  For this type of exception codes will start with 'A_DMLE_'   	
 	 */
    global class DMLException extends AtlasException
	{
		global DMLException(String errorCode,String errorMessage){
			super(errorMessage);
            this.errorCode=errorCode;
            this.errorMessage=errorMessage;
       }
    }
    
    /**
 	 * @author Gaurav Gathania
 	 * @date 11/14/2013
 	 * @description - This Subtype of AtlasException is thrown when exception is generated while making callout
 	 *				  For this type of exception codes will start with 'A_COE_'   	
 	 */
    global class CalloutException extends AtlasException
	{
		global CalloutException(String errorCode,String errorMessage){
			super(errorMessage);
            this.errorCode=errorCode;
            this.errorMessage=errorMessage;
       }
    }
    
     /**
 	 * @author Gaurav Gathania
 	 * @date 11/14/2013
 	 * @description - This Subtype of AtlasException is thrown when any configuration is missing
 	 *				  For this type of exception codes will start with 'A_CDE_'   	
 	 */
    global class ConfigDataException extends AtlasException
	{
		global ConfigDataException(String errorCode,String errorMessage){
			super(errorMessage);
            this.errorCode=errorCode;
            this.errorMessage=errorMessage;
       }
    }
    
     /**
 	 * @author Gaurav Gathania
 	 * @date 11/14/2013
 	 * @description - This Subtype of AtlasException is thrown when exception is generated due to invalid data
 	 *				  For this type of exception codes will start with 'A_INVDE_'   	
 	 */
    global class InvalidDataException extends AtlasException
	{
		global InvalidDataException(String errorCode,String errorMessage){
			super(errorMessage);
            this.errorCode=errorCode;
            this.errorMessage=errorMessage;
       }
    }
    
     /**
 	 * @author Gaurav Gathania
 	 * @date 11/14/2013
 	 * @description - This Subtype of AtlasException is thrown when exception is generated due to invalid data
 	 *				  For this type of exception codes will start with 'A_GEN_'   	
 	 */
    global class GeneralException extends AtlasException
	{
		global GeneralException(String errorCode,String errorMessage){
			super(errorMessage);
            this.errorCode=errorCode;
            this.errorMessage=errorMessage;
       }
    }
    
     

}