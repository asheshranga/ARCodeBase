/*********************************************************************************
Name         : DealerUtility
Created By   : Srikanth Kudumula
Created Date : 10/08/2015
Project      : Dealer POrtal
Usages       : Controller to get the values from custom settings

Change Log:
<Date>      <Modified By>       <Change Description>

*********************************************************************************/
    
Public with sharing class DealerUtility{
	public static Map<String,DealerKeyValueStore__c> MapKeyValue=DealerKeyValueStore__c.getAll();
	
	/**
	*   @author Srikanth Kudumula
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
	*   @author Srikanth Kudumula
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
	* @author Srikanth Kudumula
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
	* @author Srikanth Kudumula
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
	* @author Srikanth Kudumula
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
	* @author Srikanth Kudumula
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
	* @author Srikanth Kudumula 
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
}