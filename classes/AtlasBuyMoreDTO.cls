/*********************************************************************************
Name         : AtlasBuyMoreDTO 
Created By   : Gaurav Gathaniaa
Modified BY  : Gaurav Gathaniaa
Company Name : NTT Data
Project      : ViaSat Atlas, Bangalore
Created Date : 8 November 2013
Modified Date : 13 November 2013
Usages       : DTO object for buy more information
*********************************************************************************/

global with sharing  class AtlasBuyMoreDTO extends AtlasParentDTO{
	
	
	  /**
    * Holds the  Account No. 
    */
    global List<BuyMoreButton> buyMoreButtonList{get;set;}
    
    
    global class BuyMoreButton{
    	
	   	/**
	    * Holds the  GB Value. 
	    */
	    global Integer GB{get;set;}
	    	/**
	    * Holds the  Gb Value in text 
	    */
	    global String  strGBValue {get{if(GB != null)
	    								{
	    									return GB + AtlasConstants.STR_GB;
	    								}
	    								else
	    								return AtlasConstants.BLANK;
	    								}set;}
	    
	    /**
	    * Holds the  currency type. 
	    */
	    global double currencyValue{get;set;}
	    
	    /**
	    * Holds the amount value. 
	    */
	    global string strcurrency{get{if(currencyValue!=null)
	    	      						{
	    	      							return AtlasConstants.STR_CURRENCY+currencyValue;
	    	      						}
	    								else
	    								return AtlasConstants.BLANK;} set;}
	    
	    /**
	    * Holds the Button Value. 
	    */
	    global String strButton{get{if(strGBValue!=null&&strcurrency!=null)
									    {
									    	return strGBValue +' @ '+ strcurrency;
									    }
									    else 
									    return AtlasConstants.BLANK;
									    }set;}
	    
    }
    
    
    	global String externalSystemName{get;set;}
		global String externalTransactionReference{get;set;}
		global String externalServiceAgreementReference{get;set;}
		global String responseURL{get;set;}
		global String salesChannel{get;set;}
		global String enteredBy{get;set;}
		global String soldBy{get;set;}
		global String marketingSourceCode{get;set;}
		global String referralSourceCode{get;set;}
		global String note{get;set;}
		global String transactionType{get;set;}
		global List<AtlasBuyMoreDTO.UsageItem>  usageItems{get;set;}
		global String debugTemp{get;set;}
		global String externalAccountReference{get;set;}
		global AtlasBuyMoreDTO(String externalSystemName,String externalTransactionReference,String externalServiceAgreementReference,String responseURL,String salesChannel,String enteredBy,String soldBy,String marketingSourceCode,String referralSourceCode,String note,List<AtlasBuyMoreDTO.UsageItem> usageItems,String transactionType, String externalAccountReference )
		{
			this.externalSystemName=externalSystemName;
			this.externalTransactionReference=externalTransactionReference;
			this.externalServiceAgreementReference=externalServiceAgreementReference;
			this.responseURL=responseURL;
			this.salesChannel=salesChannel;
			this.enteredBy=enteredBy;
			this.soldBy=soldBy;
			this.marketingSourceCode=marketingSourceCode;
			this.referralSourceCode=referralSourceCode;
			this.note= note;
			this.usageItems=usageItems;
			this.transactionType=transactionType;
			this.externalAccountReference = externalAccountReference;
		}
		global AtlasBuyMoreDTO()
		{
			
		}
    
    global class UsageItem {
		global String externalOneTimeChargeReference{get;set;}
        global String masterCatalogNumber{get;set;}
        global String displayName{get;set;} 
        global Double price{get;set;} 
        global string buttonString{get;set;}
        global UsageItem(String externalOneTimeChargeReference,String masterCatalogNumber,String displayName,Double price)
        {
        	this.externalOneTimeChargeReference=externalOneTimeChargeReference;
        	this.masterCatalogNumber=masterCatalogNumber;
        	this.displayName=displayName;
        	this.price=price;
        	buttonString=displayName.replace(' ','');
        }
	}
    
    
	
	
}