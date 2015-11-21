/*********************************************************************************
Name         : AtlasParentDTO 
Created By   : NTT Data
Modified BY  : Gaurav Gathania
Company Name : NTT Data
Project      : ViaSat Atlas, Bangalore
Created Date : 10 December 2013
Usages       : Parent DTO object for Information Across constructors
*********************************************************************************/

global virtual with sharing class AtlasParentDTO{
	
	
		/**
	* Holds the Populated Status
	*/
 	global boolean isPopulated{get;set;}
	
	/**
	* Holds the Exception String . 
	*/
 	global String exceptionStr{get;set;}
 	

}