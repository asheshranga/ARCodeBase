/*********************************************************************************
Name          : DealerChangePlanDTO 
Created By    : Jim Tunney
Modified By   : 
Company Name  : 
Project       : Dealer Portal
Created Date  : 2 Nov 2015
Modified Date : 
Usages        : Data Transfer Object for Change Plan information
*********************************************************************************/
global with sharing class DealerChangePlanDTO extends AtlasParentDTO {
    
	global List<DealerChangePlanDTO.changePlanPackage> changePlanPackages{get;set;}

    global String serviceItemReference{get;set;}
    
    global class changePlanPackage{
        //holds Data Capacity
        global Double dataCapacity{get;set;}
        
        //holds Package Price
        global Double price{get;set;}
        
        //holds Additional Data Allowance
        global String addlDataAllowance{get;set;}
        
        //holds Thresholds
        global String thresholds{get;set;}
        
        //holds Bonus Feature
        global String bonusFeature{get;set;}
        
        //holds Download Speed
        global String downloadSpeed{get;set;}
        
        //holds Free Zone info
        global String freeZone{get;set;}
        
        //holds master catalog reference
        global String masterCatalogReference{get;set;}
        
        //holds Plan Name (AKA Component Display Name)
        global String planName{get;set;}
        
        //holds Promotions
        global String promotions{get;set;}

        //holds Speed Unit(eg: mbps)
        global String speedUnit{get;set;}
        
        //holds Upload Speed
        global String uploadSpeed{get;set;}
        
        //holds Voice Adapter info
        global String voiceAdapter{get;set;}
        
        //holds Wireless Router info
        global String wirelessRtr{get;set;}        
        
         /**global changePlanPackage(Double Price, String planName, String masterCatalogReference, String dataCapacity, String downloadSpeed, String speedUnit, String bonusFeature){
            this.Price = Price;
            this.planName = planName;
            this.masterCatalogReference = masterCatalogReference;
            this.dataCapacity = Double.ValueOf(dataCapacity);
            this.downloadSpeed = downloadSpeed;
            this.speedUnit = speedUnit;
            this.bonusFeature = bonusFeature; */
        
       global changePlanPackage(Double Price, String planName, String masterCatalogReference, String dataCapacity, String downloadSpeed,String uploadSpeed, String freeZone,String voiceAdapter,String wirelessRtr,
        						String thresholds,String addlDataAllowance,String promotions){
                                    
            this.dataCapacity = Double.ValueOf(dataCapacity);
            this.price = price;
            this.addlDataAllowance = addlDataAllowance;
            this.thresholds = thresholds;                        
            this.downloadSpeed = downloadSpeed;   
            this.freeZone = freeZone;                        
            this.planName = planName;
            this.promotions = promotions;
            this.speedUnit = speedUnit;
            this.uploadSpeed = uploadSpeed;
            this.voiceAdapter = voiceAdapter;
            this.wirelessRtr = wirelessRtr;
            
            
        }              
    }   
}