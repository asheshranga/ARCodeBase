/*********************************************************************************
    Name         : DealerServiceManager 
    Created By   : 
    Modified BY  : 
    Company Name : NTT Data
    Project      : Dealer Portal
    Created Date : 11/7/2015
    Modified Date : 
    Usages       : Integration Service Manager to call Integration Ultitlity
*********************************************************************************/
public with sharing class DealerServiceManager {
	
	/**
    * @author Srikanth Kudumula
    * @Calls AtlasIntegrationUtility to get getALaCartePackages
    * @return DealerMainDTO mainDTO
    */  
    public static DealerMainDTO getALaCartePackages(DealerMainDTO mainDTO)
    { 
        /*AtlasBuyMoreDTO buyMoreDTOObj=mainDTO.buyMoreDTOObj;
        AtlasPubCatlogServiceXmlschemaV2.Package_Test[] usagePckg;
        try{
            usagePckg=AtlasIntegrationUtility.getALaCartePackages(buyMoreDTOObj.externalSystemName, buyMoreDTOObj.externalAccountReference, buyMoreDTOObj.transactionType);
            if(!AtlasUtility.isEmpty(usagePckg) )
            {
                buyMoreDTOObj.usageItems=new List<AtlasBuyMoreDTO.UsageItem>();
                for(AtlasPubCatlogServiceXmlschemaV2.Package_Test p: usagePckg)
                {        AtlasPubCatlogServiceXmlschemaV2.PackageItem pckItem=p.optionGroup[0].packageItem[0];
                    buyMoreDTOObj.usageItems.add(new AtlasBuyMoreDTO.UsageItem(pckItem.packageItemReference,pckItem.packageItemPrice[0].masterCatalogReference,pckItem.displayName,pckItem.packageItemPrice[0].price) );
                } 
                AtlasUtility.populateSuccess(buyMoreDTOObj);
            }
        }catch(Exception e)
        {
            AtlasUtility.populateExceptionString(thisClassName+':getALaCartePackages',buyMoreDTOObj,e);
        }*/
        return mainDTO;
    }

}