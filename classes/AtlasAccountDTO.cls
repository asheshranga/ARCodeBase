/*********************************************************************************
Name         : AtlasAccountDTO 
Created By   : Gaurav Gathania
Modified BY  : Gaurav Gathania
Company Name : NTT Data
Project      : ViaSat Atlas, Bangalore
Created Date : 28 October 2013
Modified Date: 13 November2013
Usages       : DTO(Data Transfer Object) object for Account Information
*********************************************************************************/
global with sharing  class AtlasAccountDTO extends AtlasParentDTO{
    
    global boolean isBillingDetailsPopulated{get;set;}
    /**
    * Holds the  email address of the customer contact. 
    */
    global String contactEmail{get;set;}
    /**
    * Holds the accountStatus   One of: pending, active, suspended, disconnected, or cancelled
    */
    global String accountStatus{get;set;}
    /**
    * Holds the provisionStatus     One of: pending, active, suspended, disconnected, or cancelled
    */
    global String provisionStatus{get;set;}
    /**
    * Holds the deviceProtocol  One of: pending, active, suspended, disconnected, or cancelled
    */
    global String deviceProtocol{get;set;}
    
    /**
    * Holds the  Account activationDate. 
    */
    global String activationDate{get;set;}
    /**
    * Holds the  Account any alternate email address for the customer.[string   80 ]
    */
    global String alternateEmail{get;set;}  
    /**
    * Holds the Billing  Account address to which the account bill is sent.--->>addressBean
    */
    global String billingAddress{get;set;}
    
    /**
    * Holds the  Line one of the  Billing address. Usually street number and name.
    */
    global String address1{get;set;}
    /**
    * Holds the  Line two of the  Billing address. Usually information such as apartment number.
    */
    global String address2{get;set;}
    /**
    * Holds the  The city of the  Billing address.
    */
    global String city{get;set;}
    /**
    * Holds the  The county of the Billing address.Reserved for future use.
    */
    global String county{get;set;}  
    /**
    * Holds the  The two-letter state abbreviation of the  Billing address.
    */
    global String state{get;set;}   
    /**
    * Holds the     The five-digit ZIP code of the Billing address.
    */
    global String zip{get;set;} 
    /**
    * Holds the     The plus four component of the ZIP code of the  Billingaddress.
    */
    global String zip4{get;set;}     
        
    /**
    * string    64  
    One of: list
        Enterprise
        Residence
        Residence with home office
        Small office
        Beta: Standard WildBlue Direct customer who is participating in a beta trial period.
        Government: Government facilities.
        Educational: Schools and libraries offered free service.
        VIP Chargeable: VIP customer that is affiliated with WildBlue (but not an employee), but all services are at a chargeable rate.
        VIP: VIP customer who is affiliated with WildBlue, but not an employee. Offered free service.
        Employee: WildBlue employee.
        Showroom: Long-term showroom.
        Demo/Training: WildBlue demonstration or training accounts.
        Test accounts: Test accounts, including production upgrade test.
        Owl/Canary: Engineering testing sites.
        Do Not Use: Accounts that were abandoned due to address or processing errors.
        ATT Trial: Tracking for ATT Trial customers.

    */
    global String customerType{get;set;}
    /**
    * Holds the  Account DOBReserved for future use.
    */
    global String dateOfBirth{get;set;}
    /**
    * Holds the  Account  contact person’s first name.
    */
    global String firstName{get;set;}
    /**
    * Holds the  Account  contact person’s Gender {Reserved for future use}.
    */
    global String gender{get;set;}
    /**
    * Holds the  Account  lastChangeDate {dateTime}.
    */
    global String lastChangeDate{get;set;}  
    /**
    * Holds the  Account  contact person’s last name.
    */
    global String lastName{get;set;}
    /**
    * Holds the  Account  contact person’s middle name.
    */
    global String middleName{get;set;}
    /**
    * Holds the telephone number at which the account contact can be reached during daytime hours.
    */
    global String phoneDaytime{get;set;}
    /**
    * Holds the telephone number at which the account contact can be reached during evening hours.
    */
    global String phoneEvening{get;set;}
    /**
    * Holds the mobile telephone number at which the account contact can be reached.
    */
    global String phoneMobile{get;set;}
    /**
    * Holds the location where service is established for an account.
    */
    global String serviceAddress{get;set;}
    /**
    * Holds  any suffix, such as Jr or III, to the contact name.
    */
    global String suffix{get;set;}
    /**
    * Holds  username of the contact .
    */
    //global String username{get{return Userinfo.getUserName();} set;}
    global String username{get;set;}
    
    /**
    * Holds  Service Level.
    */
    global String serviceLevel{get;set;}
    /**
    * Holds  account full name.
    */
    global string strAccountName{get{return accountFullName();}set;}
    
    
    /**
    * Holds  user image url.
    */  
    global string fullPhotoURL{get;set;}
    /**
    * Holds the  smallPhotoURL(cropped photo URL) 
    */    
    global string smallPhotoURL{get;set;} 
    /**
    * Holds  use account number.
    */
    global string strAccountNumber{get;set;}
    /**
    * Holds  use display account number.
    */
    global string displayAccNum{get;set;}
    /**
    * Holds  use display formatted account number.
    */
    global string displayFormatAccNum{get{return accountNOFormat(displayAccNum);}set;}
    /**
    * Holds  user account type.
    */
    global string strAccountType{get;set;}
    /**
    * Holds  us mobile number format.
    */
    global string strUSMobileNOFormat{get{return usMobileNoFormat();}set;}
    
    global string strAccountNOFormat{get{return accountNOFormat(strAccountNumber);}set;}
    
    /**
    * Holds  contactid.
    */
    global string contactId{get;set;}
    /**
    * Holds  secondaryPhoneNumber.
    */
    global string secondaryPhone{get;set;}
    /**
    
        marketSegment   string  64  One of:
    
            WB Retail
            WB Wholesale
            WB VAR
            ATT
            DISH Network
            DirecTV
    
        password    string  20  The user's password.
        passwordHint    string  100     The hint that the user has assigned to help remember the password.
        salesChannel    string  256     One of:
    
            WB_DIRECT
            DSI_MA
            DSI_SALES_ONLY
            NRTC
            ENTERPRISE
            ATT
            DISH_NETWORK
            DIRECTV

    

        */
            /**
        * Method is used to convert the mobile number to us format and return the string
        */
        global string usMobileNoFormat()
        {
            if(!(AtlasUtility.isEmpty(phoneMobile)) && !(phoneMobile.contains('-')))
                  {                  
                      String s = phoneMobile.trim();
                      return s.substring(0, 3) + '-' + s.substring(3, 6) + '-' + s.substring(6);                                          
                  }
                  else{
                  return phoneMobile;
                  }
        } 
        /**
        * Method is used to convert the acoount number and return the string
        */
        global string accountNOFormat(String strAccountNumber)
        {
            if(!(AtlasUtility.isEmpty(strAccountNumber)) && strAccountNumber.length()== 9)
            {
                String accountNumber = strAccountNumber.trim();
                  Pattern p =Pattern.compile('(\\d{3})(\\d{3})(\\d{3})');
                  Matcher m = p.matcher(accountNumber);
                  if (m.find()) {
                    
                    return  m.group(1)+'-'+ m.group(2)+'-'+m.group(3);
                  } 
                  else 
                  {
                     return '';
                  }
            }
            
            else if(!(AtlasUtility.isEmpty(strAccountNumber)) && strAccountNumber.length()== 10)
            {
                String accountNumber = strAccountNumber.trim();
                  Pattern p =Pattern.compile('(\\d{4})(\\d{4})(\\d{2})');
                  Matcher m = p.matcher(accountNumber);
                  if (m.find()) {
                    
                    return  m.group(1)+'-'+m.group(2)+'-'+m.group(3);
                  } 
                  else 
                  {
                     return '';
                  }
            }
            else
               return strAccountNumber;
        }
        /**
        * Method is used to convert the service Address 
        */ 
        global void populateServiceAddress(AtlasMainDTO mainDTO )
        {   serviceAddress=AtlasConstants.BLANK;
            serviceAddress+=mainDTO.serviceAdd1;
            if(!AtlasUtility.isEmpty(mainDTO.serviceAdd2))
                serviceAddress+=','+mainDTO.serviceAdd2;
            if(!AtlasUtility.isEmpty(mainDTO.serviceAddCounty))
                serviceAddress+='<br/>'+mainDTO.serviceAddCounty;
            if(!AtlasUtility.isEmpty(mainDTO.serviceAddCity))
                serviceAddress+='<br/>'+mainDTO.serviceAddCity;
            if(!AtlasUtility.isEmpty(mainDTO.serviceAddState))
                serviceAddress+=', '+mainDTO.serviceAddState;
            if(!AtlasUtility.isEmpty(mainDTO.serviceAddZip))
                serviceAddress+=' '+mainDTO.serviceAddZip;
            
        }
        /**
        * Method to return full name 
        */
        global string accountFullName()
        {
            if(firstName!=null&&lastName!=null)
            return firstName +' '+lastName;
            else if(firstName==null&&lastName!=null)
            return lastName;
            else if(firstName!=null&&lastName==null)
            return firstName;
            else
            return '';
        }
        
        /**
        * Method is used to convert the Billing Address  
         
        global void populateBillingAddress()
        {
            billingAddress=AtlasConstants.BLANK;
            billingAddress+=address1;
            if(!AtlasUtility.isEmpty(address2))
                billingAddress+='<br/>'+address2; 
            if(!AtlasUtility.isEmpty(county))
                billingAddress+='<br/>'+county;
            if(!AtlasUtility.isEmpty(city))
                billingAddress+='<br/>'+city;
            if(!AtlasUtility.isEmpty(state))
                billingAddress+=','+state;
            if(!AtlasUtility.isEmpty(zip))
                billingAddress+=','+zip;
        }
        */
        /**
        * Holds  business name.
        */
        global string businessName{get;set;} 
        /**
        * Holds  true if the account is VOIP
        */
        global boolean isVoipAccount{get;set;} 
        
    }