public with sharing class ExedeOOEController {
    public class ExedeProductDTO {
        //--- Data from back office
        @AuraEnabled
        public String PackageReference;
        @AuraEnabled
        public String EquipmentType;
        @AuraEnabled
        public String DisplayName;
        @AuraEnabled
        public String Description;
        @AuraEnabled
        public String DataCapacity;
        @AuraEnabled
        public List<Integer> DataCapacityBars;        
        @AuraEnabled
        public String DownloadSpeed;
        @AuraEnabled
        public Integer DownloadSpeedPercent;        
        @AuraEnabled
        public String SpeedUnit;        
        @AuraEnabled
        public String BonusFeature;   
        
        @AuraEnabled
        public AtlasPubCatlogServiceXmlschemaV2.Feature[] features;
        
        @AuraEnabled
        public featureDetails[] FeaturesMap;
        
        //--- Data from Salesforce ExedeProduct
        @AuraEnabled
        public decimal Rating;
        @AuraEnabled
        public decimal Usage;        
        @AuraEnabled
        public decimal Discount;                
        @AuraEnabled
        public String MarketingTitle;
        @AuraEnabled
        public String MarketingDescription;
        @AuraEnabled
        public String LinkTitle;
        
        public void ExedeProductDTO () {
            //---Nothing
        }
    }
    
    public static Map<String,ExedeProductDTO> ExedeProducts;
    
    public class featureDetails {
        @AuraEnabled
        public String FeatureName;
        @AuraEnabled
        public String FeatureValue;        
    }
    
    @AuraEnabled 
    public static OOEHistory__c getOrderHistoryBySessionID(String sessionid) {
        OOEHistory__c loHistory = [select id, Name, SessionID__c, location__c,StreetAddress__c,City__c,State__c,PostalCode__c,
                                   StepServiceAvailablity__c,StepPackageSelection__c,StepPersonalInformation__c,StepPaymentInformation__c,StepOrderPreview__c,StepOrderConfirmation__c
                                   from OOEHistory__c
                                   where SessionID__c = :sessionid];
        if (loHistory == null) {
            loHistory = new OOEHistory__c(SessionID__c=sessionid);
        }           
        
        return loHistory;
    }
    
    @AuraEnabled
    public static void saveOrder(OOEHistory__c ooehistory) {
    	update ooehistory;    
    }
    
    @AuraEnabled
    public static OOEFlowStep__c[] getFlowStepsByName(String flowname) {        
        return [SELECT Id, Name, DisplayOrder__c, PageReference__c, IconClass__c
                FROM OOEFlowStep__c 
                WHERE OOEFlow__r.name = :flowname 
                ORDER BY DisplayOrder__c];
    }
    
    @AuraEnabled
    public static ExedeProductDTO getExedeProductByName(String packagereference) {
        /*
return [SELECT Id, Name, Rating__c, MarketingTitle__c, MarketingDescription__c,LinkTitle__c
FROM ExedeProduct__c 
WHERE name = :name];
*/
        system.debug('Get Package info for - ' + packagereference);
        return ExedeProducts.get(packagereference);
    }
    
    @AuraEnabled
    public static List<ExedeProductDTO> getExedeProducts(Integer MaxProductsToDisplay, String postalcode) {
        ExedeProducts = new Map<String, ExedeProductDTO>();               
        
        //--- Get the Service Availability
        System.debug('...Get Service Info for portal code - ' + postalcode);
        Map<String,String> serviceInfo = AtlasIntegrationUtility.getServiceAvailability(postalCode, 'WB_DIRECT');        
        System.debug('......Service Info - ' + serviceInfo);
        
        //--- Now get the packages based on the beamNumber got above
        System.debug('...Get Packages for Beam - ' + serviceInfo.get('beamNumber') + ' Satellite - ' + serviceInfo.get('satelliteName'));
        AtlasPubCatlogServiceXmlschemaV2.Package_x[] packages= AtlasIntegrationUtility.getPackages('WB_DIRECT','RESIDENTIAL','newConnect',Integer.valueOf(serviceInfo.get('beamNumber')),serviceInfo.get('satelliteName'));
        System.debug('......Package Info - ' + packages.size());
        
        //--- Populate the Product DTO by combining data from API and data from Salesforce objects
        //---- a. Get Salesforce Plan Attributes Marketing Text
        Map<String,String> bonusFeaturesMap = new Map<String,String>(); 
        List<AtlasPlanAttributes__c> apaList = [select AttributeValue__c, SelfcareText__c from AtlasPlanAttributes__c];
        for(AtlasPlanAttributes__c apa : apaList){
            bonusFeaturesMap.put(apa.AttributeValue__c,apa.SelfcareText__c);
        }
        
        //--- a. Get API Data
        Set<String> PackageReferences = new Set<String>();
        for (AtlasPubCatlogServiceXmlschemaV2.Package_x p:packages) {
            ExedeProductDTO pDTO = new ExedeProductDTO();
            pDTO.PackageReference = p.packageReference;
            pDTO.EquipmentType = p.equipmentType;
            pDTO.DisplayName = p.displayName;
            pDTO.Description = p.description;
            pDTO.features = p.feature;
            
            pDTO.LinkTitle = 'Learn More';
            pDTO.Usage = 45;
            pDTO.Discount = 0;
            
            PackageReferences.add(p.packageReference);
            System.debug('... Package ' + p.packageReference);
            
            pDTO.FeaturesMap = new List<featureDetails>();
            for(AtlasPubCatlogServiceXmlschemaV2.feature f : p.feature){
                if(f.name == 'DATA_CAP_GB') 
                    pDTO.DataCapacity = f.value;
                if(f.name == 'DOWNLOAD_RATE') 
                    pDTO.DownloadSpeed = f.value;
                if(f.name == 'DOWNLOAD_RATE_UNIT')
                    pDTO.SpeedUnit = f.value;
                if(f.name == 'BONUS_FEATURE'){
                    if(pDTO.BonusFeature == null) {
                        pDTO.BonusFeature = bonusFeaturesMap.get(f.value);                           
                    }
                    else
                        pDTO.BonusFeature += '<br/>' + BonusFeaturesMap.get(f.value);
                }
                
                featureDetails f1 = new featureDetails();
                f1.FeatureName = f.name;
                f1.FeatureValue = f.value;
                pDTO.FeaturesMap.add(f1);
            }
            
            //--- Get the
            pDTO.DataCapacityBars = new List<Integer>(); 
            if(pDTO.DataCapacity!=null) {
                decimal d = Decimal.valueOf(pDTO.DataCapacity);
                integer dataCap = d.intValue();
                for(Integer i=0; i<dataCap; i++){
                    pDTO.DataCapacityBars.add(i);
                }
            }
            
            pDTO.DownloadSpeedPercent = 0;
            if (pDTO.DownloadSpeed!=null) {
                Integer d = Integer.valueOf(pDTO.DownloadSpeed);
                
                pDTO.DownloadSpeedPercent = d*100/25;
            }
            ExedeProducts.put(p.packageReference,pDTO);              
        }
        
        //--- b. Get Salesforce Data
        //--- Had to explictly use Integer.valeuOf to get the integer type
        Integer liMaxProducts = Integer.valueOf(MaxProductsToDisplay);
        
        List<ExedeProduct__c> products = [SELECT Id, Name, PackageReference__c, Rating__c, Usage__c, Discount__c, MarketingTitle__c, MarketingDescription__c,LinkTitle__c 
                                          FROM ExedeProduct__c
                                          WHERE PackageReference__c in :PackageReferences
                                          ORDER BY DisplayOrder__c];
        
        for (ExedeProduct__c p:products) {
            if (ExedeProducts.containsKey(p.packageReference__c)) {
                ExedeProductDTO pDTO = ExedeProducts.get(p.packageReference__c);
                
                pDTO.Rating = p.Rating__c;
                pDTO.Usage = p.Usage__c;
                pDTO.Discount = (p.Discount__c==null) ? 0:p.Discount__c ;
                pDTO.MarketingTitle = p.MarketingTitle__c;
                pDTO.MarketingDescription = p.MarketingDescription__c;
                pDTO.LinkTitle = p.LinkTitle__c;
                
                System.debug('... Package Updated ' + p.packageReference__c);
                
                ExedeProducts.put(p.packageReference__c,pDTO);                
            }
        }
        
        List<ExedeProductDTO> pDTOs = new List<ExedeProductDTO>();
        for (String k: ExedeProducts.keySet()) 
            pDTOs.add(ExedeProducts.get(k));
        return pDTOs;
    }
    
    @AuraEnabled
    public static String getPostalCode(Integer lat, Integer lng) {
        // Instantiate a new http object
        Http h = new Http();
        
        // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
        HttpRequest req = new HttpRequest();
        String url = 'https://maps.googleapis.com/maps/api/geocode/json?key=AIzaSyC7FcMBPMYgsg5YMtTj_hN5eg4QfloYmto&latlng='+lat+','+lng+'&sensor=true';    
        req.setEndpoint(url);
        req.setMethod('GET');
        
        // Send the request, and return a response
        String lsReturn;
        try {
            HttpResponse res = h.send(req);
            lsReturn = res.getBody();
        } catch (Exception e) {
            lsReturn = 'Error calling google api - ' + e.getMessage();
        }
        
        //System.debug('Google API Return - ' + lsReturn);
        return lsReturn;
    }
}