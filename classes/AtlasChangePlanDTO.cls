/*********************************************************************************
Name         : AtlasChangePlanDTO 
Created By   : Srikanth Kudumula
Modified BY  : Srikanth Kudumula
Company Name : NTT Data
Project      : ViaSat Atlas
Created Date : 4 Apr 2015
Modified Date : 4 Apr 2015
Usages       : DTO object for Change Plan information
*********************************************************************************/

global with sharing  class AtlasChangePlanDTO extends AtlasParentDTO{
    
    global List<AtlasChangePlanDTO.changePlanPackage> changePlanPackages{get;set;}
    /** 
    *  holds Package Price
    **/
    global String serviceItemReference{get;set;}
    global class changePlanPackage{
        /** 
        *  holds Package Price
        **/
        global Double Price{get;set;}
        /** 
        *  holds Plan Name
        **/
        global String planName{get;set;}
        /** 
        *  holds Data Capacity
        **/
        global Double dataCapacity{get;set;}
        /** 
        *  holds Download Speed
        **/
        global String downloadSpeed{get;set;}
        /** 
        *  holds Speed Unit(eg: mbps)
        **/
        global String speedUnit{get;set;}
        /** 
        *  holds Bonus Feature
        **/
        global String masterCatalogReference{get;set;}
        /** 
        *  holds Bonus Feature
        **/
        global String bonusFeature{get;set;}
        
        global List<Integer> numOfBars {get;set;}
        
        global changePlanPackage(Double Price, String planName, String masterCatalogReference, String dataCapacity, String downloadSpeed, String speedUnit, String bonusFeature){
            this.Price = Price;
            this.planName = planName;
            this.masterCatalogReference = masterCatalogReference;
            this.dataCapacity = Double.ValueOf(dataCapacity);
            this.downloadSpeed = downloadSpeed;
            this.speedUnit = speedUnit;
            this.bonusFeature = bonusFeature;
            //this.numOfBars = noOfBars;
            //system.debug('----Integer.valueOf(this.DataCapacity)--->'+Integer.valueOf(this.DataCapacity));
            List<Integer> dummyList = new List<Integer>();
            decimal d = Decimal.valueOf(dataCapacity);
            integer dataCap = d.intValue();
            for(Integer i=0; i<Integer.valueOf(dataCap) ; i++){
                dummyList.add(i);
            }
            this.numOfBars = dummyList;
        } 
                                 
	}
}