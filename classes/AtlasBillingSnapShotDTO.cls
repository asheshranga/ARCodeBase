/*********************************************************************************
Name         : AtlasBillingSnapShotDTO 
Created By   : Shiva Shankar N
Modified BY  : 
Company Name : NTT Data
Project      : ViaSat Atlas, Bangalore
Created Date : 4 november 2013
Usages       : DTO(Data Transfer Object) object for Billing Snap Shot Information 
*********************************************************************************/
global with sharing class AtlasBillingSnapShotDTO  extends AtlasParentDTO{
    
    /**
    * Holds amount to be paid.
    */
    global Double Amount{get;set;}
    /**
    * Holds next bill date.
    */
    global DateTime nextBillDate{get;set;}
    /**
    * Holds next bill date.
    */
    global DateTime paymentDate{get;set;}
    /**
    * Holds previous bill amount.
    */
    global Double prevoiusDueAmount{get;set;}
    
      /**
    * Holds bill amount failed or passed.
    */
    global boolean isPymentPopulated{get;set;}
    /**
    * Holds bill paid date.
    */
    global string strPaidDateString {get{if(paymentDate!=null){
           String dateStr=''+paymentDate;
           Integer firstHyphen=dateStr.indexOf('-');
           Integer secHyphen=dateStr.LastindexOf('-');
           Integer space=dateStr.indexOf(' ');
           String paidYear = dateStr.subString(0,firstHyphen); String paidMonth = dateStr.subString(firstHyphen+1,secHyphen); String paidDate = dateStr.subString(secHyphen+1,space);
           return paidMonth +'/' + paidDate +'/'+paidYear ;
        }
        else                      
         return AtlasConstants.BLANK;}set;}
    /**
    * Holds due date information.
    */
    global string strDueDate{get{if(nextBillDate!=null)
                                    {
                                       String dateStr = ''+nextBillDate;
                                       Integer firstHyphen =dateStr.indexOf('-');
                                       Integer secHyphen =dateStr.LastindexOf('-');
                                       Integer space =dateStr.indexOf(' ');
                                       String paidYear = dateStr.subString(0,firstHyphen); String paidMonth = dateStr.subString(firstHyphen+1,secHyphen); String paidDate = dateStr.subString(secHyphen+1,space);
                                       return paidMonth +'/' + paidDate +'/'+paidYear ;
                                    }
                                    else 
                                    return AtlasConstants.BLANK;
                                    }set;}
    /**
    * Holds month .
    */
    global string strMonth{get{return datetime.now().format('MMMMM');}set;}
    /**
    * Holds Calender date.
    */
    global string strDate{get{if(datetime.now().format('dd').startsWith('0'))
                                {
                                 return datetime.now().format('dd').replace('0','');
                                }
                                else return datetime.now().format('dd');}set;}
       
    /**
    * Holds bill amount failed or passed.
    */
    global boolean isPymentFailed{get;set;}
    /**
    * Holds string color information depends on payment passed or failed.
    */
    global string strColor{get{
                          if(isPymentFailed != null)
                          {     
                               if(isPymentFailed){
                                return 'red';}
                               else
                               return 'green';
                          }else return //AtlasConstants.BLANK;
                             'green';
                          }set;}
}