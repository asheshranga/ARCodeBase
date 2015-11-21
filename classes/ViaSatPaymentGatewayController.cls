public class ViaSatPaymentGatewayController {
    
    public class applicationException extends Exception {}
    
    //--- Controller main method
    public ViaSatPaymentGatewayController() {
        saveCard=false;
        resultCode='none';
        chargeTo='CC';
        
        String contactId = ApexPages.currentPage().getParameters().get('id');
        contactId = ((contactId==null) || (contactId.trim().equals(''))) ? null:contactId;
        
        try {
            customer = [select id,firstname,lastname,email from contact where id=:contactId];
        } catch (Exception e) {
            //---Do Nothing
        }
    }
    
    public class PaymentInfo {
        public string cardNumber {get;set;}    
        public string cardExpMonth {get;set;}
        public string cardExpYear {get;set;}
        public string cardName {get;set;}
        public string amount {get;set;} 
        public string transactionRef {get;set;}
        public string tender {get;set;}
        public string transactionType {get;set;}
    }
    
    public string cardNumber {get;set;}    
    public string cardExpMonth {get;set;}
    public string cardExpYear {get;set;}
    public string amount {get;set;}
    public string resultCode {get;set;}
    public string resultInfo {get;set;}
    public string resultMsg {get;set;}
    public string resultRef {get;set;}
    
    public contact customer {get;set;}
    public Id customerID {get {return (customer==null) ? null:customer.Id;}set;}
    public String chargeTo {get;set;}
    public boolean saveCard {get;set;}
    public String cardName {get;set;}
    
    public List<SelectOption> getPaymentAccounts() {
        List<SelectOption> options = new List<SelectOption>();    
        options.add(new SelectOption('CC','New Credit Card'));
        
        try {
            for(PaymentGatewayTransaction__c p: [select id, PaymentOnFileName__c from PaymentGatewayTransaction__c where customer__c=:customer.id and TransactionType__c = 'Payment On File'])
                options.add(new SelectOption(p.id,p.PaymentOnFileName__c));
        } catch (Exception e) {
            //---Do Nothing
        }
        
        chargeTo='CC';
        return options;
    }
    
    public pageReference saveCardInfo() {
        map<String,String> response = new map<String,String>();
        System.debug('saveCard = ' + saveCard);
        System.debug('Card Name = ' + cardName);
        System.debug('result code = ' + resultCode);
        if ((saveCard) && (resultCode.equalsIgnoreCase('0'))) {
            PaymentInfo paymentDetails = new PaymentInfo();
            
            paymentDetails.cardNumber = cardNumber;
            paymentDetails.cardExpMonth = cardExpMonth;
            paymentDetails.cardExpYear = cardExpYear;

            paymentDetails.amount = '0';
            paymentDetails.transactionRef = null;
            
            cardName=(cardName==null)? 'Card 001':cardName;
            paymentDetails.cardName = cardName;
            
            paymentDetails.transactionType = 'Payment On File';
            
            response = invokePaymentService(paymentDetails);
            if ((response == null) || (!response.get('RESULT').equals('0'))) {
                resultCode = response.get('RESULT');
                resultMsg = 'Ooops! Unable to save payment - ' + response.get('RESPMSG');
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, resultMsg));
            } else {
                resultCode = '0';
                resultMsg = 'Successfully submitted payment and saved the card information';                
            }
        }        
        
        return null;
    }
    
    public pageReference submitPayment() {      
        map<String,String> response = new map<String,String>();
        
        PaymentInfo paymentDetails = new PaymentInfo();
        paymentDetails.cardNumber = cardNumber;
        paymentDetails.cardExpMonth = cardExpMonth;
        paymentDetails.cardExpYear = cardExpYear;
        paymentDetails.cardName = cardName;
        paymentDetails.amount = amount;
        paymentDetails.transactionRef = null;
                
        if (chargeTo.equalsIgnoreCase('CC')) {
            paymentDetails.transactionType = 'Sale';
            paymentDetails.transactionRef = null;                        
        } else {
            paymentDetails.transactionType = 'Sale';
            paymentDetails.transactionRef = chargeTo;
        }
        
        response = invokePaymentService(paymentDetails);        
        if ((response != null) && (!response.get('RESULT').equalsIgnoreCase('0'))) {
            resultCode = response.get('RESULT');
            resultMsg = 'Ooops! Unable to submit payment - ' + response.get('RESPMSG');
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Ooops! Unable to submit payment - ' + response.get('RESPMSG')));    
        } else {
            resultCode = '0';
            resultMsg = 'Successfully submitted the payment';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Successfully submitted the payment'));
        } 
        
        return null;
    }   
    
    private Map<String,String> parseResponse (String resp) {
        Map<String,String> ret = new Map<String,String>();
        String[] wsReturnInfo = resp.split('\\&');
        for (String wsFieldInfo: wsReturnInfo) {
            string[] fieldinfo = wsFieldInfo.split('\\=');
            ret.put(fieldinfo[0], fieldinfo[1]);
        }        
        
        return ret;
    }
    
    private map<String,String> invokePaymentService(PaymentInfo paymentInfo) {
        map<String,String> responseReturn = new map<String,String>();
        
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setEndpoint('https://pilot-payflowpro.paypal.com');
        req.setTimeout(80000);
        req.setHeader('Content-Type', 'text/xml; charset=utf-8');
        req.setHeader('SOAPAction', 'https://pilot-payflowpro.paypal.com');
        
        String wsRequestMsg='PARTNER=PayPal&PWD=viasat2000!&VENDOR=hanupayflow1&USER=hanupayflow1';
        String[] wsRequestArgs;
        
        try {
            if (paymentInfo.transactionType.equals('Sale')) {
                if ((paymentInfo.transactionRef != null) && (!paymentInfo.transactionRef.trim().equals(''))) {
                    String ref=[select PaymentGatewayTransactionID__c from PaymentGatewayTransaction__c where id=:chargeTo limit 1].PaymentGatewayTransactionID__c;
                    wsRequestMsg = wsRequestMsg + '&TENDER={0}&TRXTYPE={1}&ORIGID={2}&AMT={3}';
                    wsRequestArgs = new String[] {'C','S',ref,paymentInfo.amount};        	            
                        } else {
                            wsRequestMsg = wsRequestMsg + '&TENDER={0}&TRXTYPE={1}&ACCT={2}&EXPDATE={3}&AMT={4}';
                            wsRequestArgs = new String[] {'C','S',paymentInfo.cardNumber,paymentInfo.cardExpMonth+paymentInfo.cardExpYear,paymentInfo.amount};                            
                                }                     
            }
            
            if (paymentInfo.transactionType.equals('Payment On File')) {
                wsRequestMsg = wsRequestMsg + '&TENDER={0}&TRXTYPE={1}&ACCT={2}&EXPDATE={3}';
                wsRequestArgs = new String[] {'C','L',paymentInfo.cardNumber,paymentInfo.cardExpMonth+paymentInfo.cardExpYear};
                    }
            
            req.setBody(string.format(wsRequestMsg,wsRequestArgs));
            
        } catch (Exception e) {
            throw new applicationException ('Service Input Validation Failed - ' + e.getMessage());  
        }
        
        Http http = new Http();
        DateTime reqTime=null;
        DateTime resTime=null;        
        try {
            //---Execute web service call here
            reqTime = System.now();       
            HTTPResponse res = http.send(req);   
            
            //---Parse the response
            resTime = System.now();  
            responseReturn = parseResponse(res.getBody());            
        } catch(Exception e) {
            if (responseReturn==null)
                responseReturn = new map<String,String>();
            
            if ((responseReturn == null) || (responseReturn.get('RESULT')==null)) {
                responseReturn.put('RESULT','-999');
                responseReturn.put('RESPMSG',e.getMessage());
            }
        }  finally {
            insertTransactionHistory(paymentInfo.transactionType,customerID,paymentInfo.cardName, Decimal.valueOf(paymentInfo.amount), paymentInfo.transactionRef, reqTime, resTime, responseReturn);            
        }
        return responseReturn;
    }
    
    @future
    public static void insertTransactionHistory(String txnType, Id customerID, String cardName, Decimal txnAmount, Id reference, DateTime reqTime, DateTime resTime, map<string,string> resInfo) {
        try {
            PaymentGatewayTransaction__c pgt = new PaymentGatewayTransaction__c();
            
            pgt.TransactionType__c = txnType;
            pgt.PaymentGatewayTransactionID__c = resInfo.get('PNREF');            
            pgt.Status__c = resInfo.get('RESULT');
            pgt.ResponseMessage__c = resInfo.get('RESPMSG');
            pgt.RequestTime__c = reqTime;
            pgt.ResponseTime__c = resTime;
            pgt.Customer__c = customerID;
            pgt.Parent__c = reference;
            pgt.PaymentOnFileName__c = cardName;
            pgt.Amount__c = txnAmount;
            
            insert pgt;
        } catch (Exception e) {
            //--- do nothing
        }
    }    
}