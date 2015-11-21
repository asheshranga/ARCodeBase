/*********************************************************************************
Name         : AtlasWebServiceTest
Created By   : Lynnet Ambrocio
Company Name : Slalom Consulting
Project      : ViaSat Wisp
Created Date : 8/19/2015
Usages       : Test Class for Apex Class: AtlasWebService
*********************************************************************************/
@isTest
private class AtlasWebServiceTest {

    static testMethod void testGeneratecreatedTimestamp() {
        AtlasWebService ws = new AtlasWebService();
        
        Test.startTest();
        ws.generatecreatedTimestamp();
        Test.stopTest();
    }
    
    static testMethod void testGenerateexpiredTimestamp() {
        AtlasWebService ws = new AtlasWebService();
        
        Test.startTest();
        ws.generateexpiredTimestamp();
        Test.stopTest();
    }
    
    static testMethod void testGenerateNounce() {
        AtlasWebService ws = new AtlasWebService();
        
        Test.startTest();
        ws.generateNounce();
        Test.stopTest();
    }
    
    static testMethod void testGenerateTimestamp() {
        AtlasWebService ws = new AtlasWebService();
        
        Test.startTest();
        ws.generateTimestamp();
        Test.stopTest();
    }
    
    static testMethod void testParseGetSubscriber() {
        AtlasWebService ws = new AtlasWebService();
        XmlStreamWriter writer = new XmlStreamWriter();

        writer.writeStartDocument('utf-8', '1.0');        
        writer.writeStartElement(null, 'Liasse', null);

        writer.writeStartElement(null, 'Modele', null);
        writer.writeStartElement(null, 'Id', null);
        writer.writeCharacters('7');

        writer.writeEndElement();
        writer.writeEndElement();
        writer.writeEndElement();
        writer.writeEndDocument();

        String xml = writer.getXmlString();
        
        Test.startTest();
        ws.parseGetSubscriber(xml);
        Test.stopTest();
    }
    
    static testMethod void testiInvokeAtlasService_1() {
        AtlasWebService ws = new AtlasWebService();
        
        // Setup test data
        ws.searchAccount = '12345678';
        ws.searchUserName = 'johnDoe';
        ws.searchAccountNumber = '12345678';
        
        Test.startTest();
        ws.invokeAtlasService();
        List<SelectOption> env = ws.getEnv();
        String theTime = ws.getthetime();
        Test.stopTest();
        
        //Verify
        System.assertEquals(null, ws.wsEnv);
        System.assertEquals(2, env.size());
        
        System.assertEquals('12345678', ws.searchAccount);
        System.assertEquals('johnDoe', ws.searchUserName);
        System.assertEquals('12345678', ws.searchAccountNumber);
        System.assertEquals(null, ws.searchInternalServiceAgreementRef);
        
        System.assertEquals(null, ws.subscriberkey);
        System.assertEquals('search', ws.serviceTab);
        
        System.assertEquals(null, ws.invoiceNum);
        System.assertEquals(null, ws.name);
        
        System.assertEquals(null, ws.value);
        System.assertEquals(null, ws.text);
        
        System.assertEquals(System.now(), ws.timestarted);
        System.assertEquals(null, ws.timestopped);
        //System.assertEquals(ws.timestopped.getTime() - ws.timestarted.getTime(), ws.callDuration);
        
        System.assertEquals('POST', ws.wsMethod);
        System.assertEquals('https://webservices.test.wildblue.net/PublicSearch/v1/services/PublicSearchService', ws.wsEndPoint);
        System.assertNotEquals(null, ws.wsRequestMsg);
        System.assertEquals(null, ws.searchResult);
        System.assertEquals(null, ws.wsReturn);
        
        System.assertEquals(String.valueof(System.now()), theTime);
    }
    
    static testMethod void testiInvokeAtlasService2() {
        AtlasWebService ws = new AtlasWebService();
        
        // Setup test data
        ws.searchAccount = '12345678';
        ws.searchUserName = 'johnDoe';
        ws.searchAccountNumber = '12345678';
        ws.serviceTab = 'billingsummary';
        
        Test.startTest();
        ws.invokeAtlasService();
        List<SelectOption> env = ws.getEnv();
        String theTime = ws.getthetime();
        Test.stopTest();
        
    }
    
    static testMethod void testiInvokeAtlasService3() {
        AtlasWebService ws = new AtlasWebService();
        
        // Setup test data
        ws.searchAccount = '12345678';
        ws.searchAccountNumber = '12345678';
        ws.serviceTab = 'currentusage';
        
        Test.startTest();
        ws.invokeAtlasService();
        List<SelectOption> env = ws.getEnv();
        String theTime = ws.getthetime();
        Test.stopTest();
        
    }
    
    static testMethod void testiInvokeAtlasService4() {
        AtlasWebService ws = new AtlasWebService();
        
        // Setup test data
        ws.searchAccount = '12345678';
        ws.serviceTab = 'currentusage';
        
        Test.startTest();
        ws.invokeAtlasService();
        List<SelectOption> env = ws.getEnv();
        String theTime = ws.getthetime();
        Test.stopTest();
        
    }
    
    static testMethod void testiInvokeAtlasService5() {
        AtlasWebService ws = new AtlasWebService();
        
        // Setup test data
        ws.serviceTab = 'currentusage';
        ws.searchAccount = '12345678';
        ws.searchUserName = 'johnDoe';
        ws.searchAccountNumber = '12345678';
        ws.searchInternalServiceAgreementRef = '5678';
        
        Test.startTest();
        ws.invokeAtlasService();
        List<SelectOption> env = ws.getEnv();
        String theTime = ws.getthetime();
        Test.stopTest();
        
    }
}