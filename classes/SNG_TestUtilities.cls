/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 *
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */

@isTest
public class SNG_TestUtilities {

    public static final transient Id VALID_ID = 'a1he0000000EkAr';
    public static final transient String VALID_MAC_ADDR = '00:a0:bc:25:cf:28';
    public static final transient String ACCOUNT_NAME = 'testAccount';
    private static Integer serialNumber = 0;

    private static Map<String, RecordType> recordTypes = new Map<String, RecordType>();
    
    public static Modem__c insertEquipment(boolean isActive)
    {
       return insertEquipment('testTerminal', VALID_MAC_ADDR, ACCOUNT_NAME, isActive);
    }

    public static Modem__c insertEquipment(String equipmentName, String macAddress, Account a, boolean isActive)
    {
        return insertEquipment(equipmentName, macAddress, a, String.valueOf(++serialNumber), isActive, '1234561');
    }

    public static Modem__c insertEquipment(String equipmentName, String macAddress, Account a, String serNum, boolean isActive)
    {
        return insertEquipment(equipmentName, macAddress, a, serNum, isActive, '1234561');
    }

    public static Modem__c insertEquipment(String equipmentName, String macAddress, Account a, String serNum, boolean isActive, String salesOrder)
    {
        Terminal__c testEquip = new Terminal__c();
        testEquip.Nickname__c = equipmentName;
        testEquip.Account__r = a;
        testEquip.Account__c = a.Id;
        testEquip.SerialNumber__c = String.valueOf(++serialNumber);
        testEquip.SalesOrder__c = salesOrder;

        Product2 testTerminalType = insertTerminalType(isActive);
        testEquip.TerminalType__r = testTerminalType;
        testEquip.TerminalType__c = testTerminalType.Id;
        insert testEquip;
        Modem__c modem = constructModem(macAddress, a, testEquip, serNum);
        insert modem;        
        return modem;
    }

    public static Modem__c insertEquipment(String equipmentName, String macAddress, String accountName, boolean isActive)
    {
        return insertEquipment(equipmentName, macAddress, accountName, String.valueOf(++serialNumber), isActive, '1234561');
    }

    public static Modem__c insertEquipment(String equipmentName, String macAddress, String accountName, String serNum, boolean isActive)
    {
        return insertEquipment(equipmentName, macAddress, accountName, serNum, isActive, '1234561');
    }

    public static Modem__c insertEquipment(String equipmentName, String macAddress, String accountName, String serNum, boolean isActive, String salesOrder )
    {
        Account a = insertAccount(accountName);

        Terminal__c testEquip = new Terminal__c();
        testEquip.Nickname__c = equipmentName;
        testEquip.Account__r = a;
        testEquip.Account__c = a.Id;
        testEquip.SerialNumber__c = serNum;
        testEquip.SalesOrder__c = salesOrder;

        Product2 testTerminalType = insertTerminalType(isActive);
        testEquip.TerminalType__r = testTerminalType;
        testEquip.TerminalType__c = testTerminalType.Id;
        insert testEquip;
        
        Modem__c modem = constructModem(macAddress, a, testEquip, serNum);
        insert modem;        
        return modem;
    }

    public static Modem__c insertModem(String macAddress, String serialNum, boolean withTerminal) {

        if (withTerminal == false) {
            return insertModem(insertAccount('testAccount'), '1143775 - Modem used for Auto Acquire systems', macAddress,
                                serialNum, null);
        }
        else {
            // create Terminal with active Terminal Type
            Account account = insertAccount('testAccount');
            Product2 terminalType = constructTerminalTypes(1,true)[0];
            insert terminalType;
            Terminal__c terminal = new Terminal__c();
            terminal.Account__c = account.Id;
            terminal.SerialNumber__c = '0';
            terminal.TerminalType__c = terminalType.Id;
            terminal.SalesOrder__c = '1234561';
            insert terminal;

            System.debug('Terminal account ID = ' + terminal.Account__c);
            System.debug('Terminal ID = ' + terminal.Id);
            System.debug('Terminal Type = ' + terminal.TerminalType__c);

            // create the Modem with the terminal
            return insertModem(account, '1143775 - Modem used for Auto Acquire systems', macAddress,
                                serialNum, terminal);
        }
    }

    public static Modem__c insertModem(Account account, String partNumber, String macAddress, String serialNum, Terminal__c terminal) {
        Modem__c modem = new Modem__c();
        modem.Account__r = account;
        modem.Account__c = account.Id;
        modem.PartNumber__c = partNumber;
        modem.Name = macAddress;
        modem.SerialNumber__c = serialNum;
        if (terminal != null)
            modem.Terminal__c =  terminal.Id;

        insert modem;
        return modem;
    }

    public static Modem__c insertModem(String macAddress, Account a, Terminal__c t) {
        Modem__c modem = constructModem(macAddress, a, t);
        insert modem;
        return modem;
    }

    public static List<ModemServicePlan__c> insertListOfModemServicePlans(Integer numberOfMsps, String accountName) {
        Integer numOfTerminalTypes=1;
        Integer numOfServicePlanTypes=1;
        List<ModemServicePlan__c> msps = constructListOfModemServicePlans(numberOfMsps, accountName, numOfTerminalTypes, numOfServicePlanTypes);
        insert msps;
        return msps;
    }

    //****************************************************************************
    public static List<ModemServicePlan__c> insertListOfModemServicePlans(Integer numberOfMsps) {
        return insertListOfModemServicePlans(numberOfMsps, 'testAccount');
    }

    public static ModemServicePlan__c insertModemServicePlan(boolean isModemActive, boolean isServicePlanActive) {
        Account a = ViasatTestUtility.createAccounts(1, 'testAccount')[0];
        insert a;
        Modem__c modem = insertEquipment('testAccount', VALID_MAC_ADDR, a, isModemActive);        
        ModemServicePlan__c msp = constructModemServicePlan(modem, insertServicePlan(modem.Account__r, insertServicePlanType(isServicePlanActive),'1'));
        insert msp;
        return msp;
    }

    public static ModemServicePlan__c insertModemServicePlan(Modem__c modem, ServicePlan__c servicePlan) {
        return insertModemServicePlan(modem, servicePlan, servicePlan.StartDate__c, servicePlan.EndDate__c);
    }

    public static ModemServicePlan__c insertModemServicePlan(Modem__c modem, ServicePlan__c servicePlan, Date startDate, Date endDate) {
        ModemServicePlan__c msp = constructModemServicePlan(modem, servicePlan, startDate, endDate);
        insert msp;
        return msp;
    }

    //****************************************************************************
    public static ServicePlan__c insertServicePlan(Account account, boolean servicePlanActive) {
        // SalesOrder must be unique:
        ServicePlan__c servicePlan = constructServicePlan(account, insertServicePlanType(servicePlanActive), '1111111');      
        insert servicePlan;
        return servicePlan;
    }

    public static ServicePlan__c insertServicePlan(Account account, Product2 servicePlanType, String salesOrder) {
        ServicePlan__c servicePlan = constructServicePlan(account, servicePlanType, salesOrder);     
        insert servicePlan;
        return servicePlan;
    }

    public static ServicePlan__c insertServicePlan(Account account, Product2 servicePlanType, Date startDate, Date endDate){
        ServicePlan__c servicePlan = constructServicePlan(account, servicePlanType, '1');        
        servicePlan.StartDate__c = startDate;
        servicePlan.EndDate__c = endDate;
        insert servicePlan;
        return servicePlan;
    }

    public static List<ServicePlan__c> insertListOfServicePlans(Integer numberOfServicePlans) {
        Account account = SNG_TestUtilities.insertAccount('testAccount');
        Product2 servicePlanType = SNG_TestUtilities.insertServicePlanType(true);
        List<ServicePlan__c> servicePlans = constructServicePlans(new Account[]{account}, numberOfServicePlans, new Product2[]{servicePlanType}, null);        
        insert servicePlans;
        return servicePlans;
    }

    public static ServicePlan__c[] insertListOfServicePlansWithUniqueAccounts(Integer numberOfServicePlans) {
        Product2 servicePlanType = insertServicePlanType(true);

        Account[] accounts = ViasatTestUtility.createAccounts(numberOfServicePlans, 'testAccount_');
        insert accounts;

        ServicePlan__c[] servicePlans = new ServicePlan__c[numberOfServicePlans];
        for(Integer i = 0; i < numberOfServicePlans; ++i) {
            servicePlans[i] = constructServicePlan(accounts[i], servicePlanType, 'testServicePlan_' + i);
        }
        insert servicePlans;

        return servicePlans;
    }

    public static Product2[] insertListOfServicePlanTypes(final Integer numToInsert, final boolean isActive) {
        Product2[] products = new Product2[numToInsert];
        for (Integer i = 0; i < numToInsert; ++i) {
            products[i] = constructServicePlanType('testServicePlanType_' + numToInsert, isActive);
        }
        insert products;
        return products;
    }

    public static Product2 insertServicePlanType(boolean isActive) {
        Product2 spt = constructServicePlanType('servicePlanType', isActive);
        insert spt;
        return spt;
    }

    private static Product2 constructServicePlanType(String name, boolean isActive) {
        return ViasatTestUtility.createProducts(1, 'Exede', SNG_ServicePlan.SERVICE_PLAN_TYPE_RECORD_TYPE_NAME, name, isActive)[0];
    }

    public static Terminal__c insertTerminal(Account account, String serialNum){
        return insertTerminal(account, serialNum, '1234561');
    }

    public static Terminal__c insertTerminal(Account account, String serialNum, String salesOrder) {
        Product2 terminalType = insertTerminalType(true);
        Terminal__c terminal = new Terminal__c();
        terminal.Account__c = account.Id;
        terminal.SerialNumber__c = serialNum;
        terminal.TerminalType__c = terminalType.Id;
        terminal.TerminalType__r = terminalType;
        terminal.SalesOrder__c = salesOrder;

        insert terminal;
        return terminal;
    }

    public static List<Terminal__c> insertTerminals(Account account, integer num)
    {
        List<Product2> terminalTypes = ViasatTestUtility.createProducts(num, 'Exede', SNG_Terminal.TERMINAL_TYPE_RECORD_TYPE_NAME, 'testTerminalType_', true);
        insert terminalTypes;

        list<Terminal__c> terminals = SNG_TestUtilities.constructTerminals(account, num, terminalTypes, 'testTerminal');
        insert terminals;
        return terminals;
    }

    public static Product2 insertProduct2(String productName, String recordTypeName, boolean isActive) {
        Product2 prod = ViasatTestUtility.createProducts(1, 'Exede', recordTypeName, productName, isActive)[0];
        insert prod;
        return prod;
    }

    private static Modem__c insertModem(boolean isActive)
    {
        return insertModem(insertAccount('testAccount'), isActive);
    }

    private static Modem__c insertModem(Account a, boolean isActive)
    {
        return insertEquipment('testAccount', VALID_MAC_ADDR, a, isActive);
    }

    public static Account insertAccount(String accountName){
        Account a = ViasatTestUtility.createAccounts(1, accountName)[0];
        insert a;
        return a;
    }

    public static Product2[] insertListOfTerminalTypes(final Integer numToInsert, final boolean isActive) {
        Product2[] products = new Product2[numToInsert];
        for (Integer i = 0; i < numToInsert; ++i) {
            products[i] = constructTerminalType('testTerminalType_' + numToInsert, isActive);
        }
        insert products;
        return products;
    }

    public static Product2 insertTerminalType(boolean isActive) {
        Product2 t = constructTerminalType('testTerminalType', isActive);
        insert t;
        return t;
    }

    private static Product2 constructTerminalType(final String terminalTypeName, final boolean isActive) {
        return ViasatTestUtility.createProducts(1, 'Exede', SNG_Terminal.TERMINAL_TYPE_RECORD_TYPE_NAME, terminalTypeName, isActive)[0];
    }

    public static DateTime setStartTimeToday()
    {
        // change this to last 5 min interval, or some time in the past
        DateTime now = System.now();
        DateTime startTime = now.addSeconds(-now.second());
        startTime = startTime.addMinutes(-Math.mod(startTime.minute(), 5));
        return startTime;
    }

    private static String getValidMacAddressForNumber(Integer num) {
        final String prefix = '00:a0:bc:';
        final Integer maxLength = 6;
        final String colon = ':';

        String numInHex = NumberUtils.toHexString(num);
        if (maxLength >= numInHex.length()) {
            while (maxLength > numInHex.length()) {
                numInHex = String.valueOf(0) + numInHex;
            }

            final String macAddr = prefix + numInHex.substring(0, 2) + colon + numInHex.substring(2, 4) + colon + numInHex.substring(4);
            return macAddr;
        } else {
            throw new SNG_Exception('Number is too big to create a valid MAC address: ' + num);
        }
    }

    private static RecordType getRecordType(final String recordTypeName) {
        RecordType recType = recordTypes.get(recordTypeName);
        if (null == recType) {
            recType = [SELECT Id, Name FROM RecordType WHERE Name = :recordTypeName];
            recordTypes.put(recordTypeName, recType);
        }
        return recType;
    }



    //****************************************************************************
    // CONSTRUCT SNG OBJECTS
    //****************************************************************************
    public static Product2[] constructTerminalTypes(final Integer numToInsert, final boolean isActive) {
        return ViasatTestUtility.createProducts(numToInsert, 'Exede', SNG_Terminal.TERMINAL_TYPE_RECORD_TYPE_NAME, 'testTerminalType_', isActive);
    }

    public static Product2[] constructServicePlanTypes(final Integer numToInsert, final boolean isActive) {
        return ViasatTestUtility.createProducts(numToInsert, 'Exede', SNG_ServicePlan.SERVICE_PLAN_TYPE_RECORD_TYPE_NAME, 'testServicePlanType_', isActive);
    }

    //****************************************************************************
    public static final transient String VALID_MAC_ADDRprefix = '00:a0:bc:';

    public static Modem__c constructModem(String macAddress, Account a, Terminal__c t, string serialNumberPrefix) {
        return constructModems(a, 1, new Terminal__c[]{t}, macAddress, serialNumberPrefix)[0];
    }

    private static Modem__c constructModem(String macAddress, Account a, Terminal__c t) {
        Modem__c modem = new Modem__c();
        modem.Name = macAddress;
        modem.PartNumber__c = macAddress;
        modem.SerialNumber__c = macAddress;
        modem.MacAddress__c = macAddress;
        modem.Account__r = a;
        modem.Account__c = a.Id;
        modem.Terminal__r = t;
        modem.Terminal__c = t.Id;
        return modem;
    }
    
    public static List<Modem__c> constructModemsWithUniqueTerminals(Account account, Integer num) 
    {
        List<Product2> terminalTypes = ViasatTestUtility.createProducts(num, 'Exede', SNG_Terminal.TERMINAL_TYPE_RECORD_TYPE_NAME, 'testTerminalType_', true);
        insert terminalTypes;

        list<Terminal__c> terminals = SNG_TestUtilities.constructTerminals(account, num, terminalTypes, 'testTerminal');
        insert terminals;
        
        List<Modem__c> modems = SNG_TestUtilities.constructModems(account, num, terminals, VALID_MAC_ADDRprefix, 'serialNumberPrefix');
        return modems;
    }

    public static list<Modem__c> constructModemsWithUniqueAccounts(Integer num) 
    {
        List<Product2> terminalType = ViasatTestUtility.createProducts(1, 'Exede', SNG_Terminal.TERMINAL_TYPE_RECORD_TYPE_NAME, 'testTerminalType_', true);
        insert terminalType;

        Account[] accounts = ViasatTestUtility.createAccounts(num, 'testAccount_');     
        insert accounts;
        
        //Terminal__c[] terminals = new Terminal__c[num];
        //for(Integer i = 0; i < num; ++i) {
        //    terminals[i] = constructTerminals(accounts[i], 1, terminalType, 'testTerminal' +String.valueOf(i), String.valueOf(i))[0];
        //}
        Terminal__c[] terminals = constructTerminals(accounts, 1, terminalType, 'testTerminal', '');
        insert terminals;
        
        list<Modem__c> modems = new list<Modem__c>();
        for(Integer i = 0; i < num; ++i) {
            modems.add(constructModems(accounts[i], 1, new Terminal__c[]{terminals[i]}, getValidMacAddressForNumber(VALID_MAC_ADDRprefix,i), String.valueOf(i))[0]);
        }
        return modems;
    }

//    public static List<Modem__c> constructModems(Account a, integer numOfObjsPerAccounts, Terminal__c[] terminals, string ipPrefix)
//    {
//        return constructModems(a, numOfObjsPerAccounts, terminals, ipPrefix, 'MSN');
//    }
    
    public static List<Modem__c> constructModems(Account a, integer numOfObjsPerAccounts, Terminal__c[] terminals, string ipPrefix, string serialNumberPrefix)
    {
        string[] ipAddresses = new string[numOfObjsPerAccounts];
        if (ipPrefix == null) ipPrefix = (numOfObjsPerAccounts==1 ? '00:A0:BC:99:00:01' : VALID_MAC_ADDRprefix);
        for (Integer i=0; i < numOfObjsPerAccounts; i++){   
            ipAddresses[i] = (ipPrefix.length()==17 ? ipPrefix : getValidMacAddressForNumber(ipPrefix,i));
        }
        return constructModems(new Account[]{a}, numOfObjsPerAccounts, terminals, ipAddresses, serialNumberPrefix);
    }
        
    public static List<Modem__c> constructModems(Account[] accounts, integer numOfObjsPerAccounts, Terminal__c[] terminals, string[] ipAddresses, string serialNumberPrefix)
    {
        // some fields should be unique: 
        //string uniqueNumber = string.ValueOf(System.now().millisecond());
        
        list<Modem__c> newobjs = new list<Modem__c>();
        integer uNum=0;
        for (Integer j=0; j < accounts.size(); j++)
        {
          Account a = accounts[j];
          for (Integer i=0; i < numOfObjsPerAccounts; i++)
          {           
            Modem__c newo = new Modem__c();
            newo.Account__c = a.Id;
            newo.Account__r = a;

            newo.SerialNumber__c = serialNumberPrefix + string.valueOf(uNum);
            newo.Name = ipAddresses[i];
            newo.MacAddress__c = ipAddresses[i];
            newo.PartNumber__c= ipAddresses[i];
            
            newo.Terminal__c = terminals[i].Id;
            newo.Terminal__r = terminals[i];

            newobjs.add(newo);      
            uNum++;
          }  
        }         
        return newobjs;     
    }

    //****************************************************************************
    public static ServicePlan__c constructServicePlan(Account account, Product2 servicePlanType, String salesOrder) {
        
        return constructServicePlans(new Account[]{account}, 1, new Product2[]{servicePlanType}, salesOrder)[0];        
    }

    // Construct (numberOfAccounts * numberOfProducts) ServicePlans__c
    public static list<ServicePlan__c> constructServicePlansForUniqueAccounts(Integer numberOfAccounts, Integer numberOfProducts) {
        Account[] accounts = ViasatTestUtility.createAccounts(numberOfAccounts, 'testAccount_');        
        insert accounts;

        Product2[] servicePlanTypes = ViasatTestUtility.createProducts(numberOfProducts, 'Exede', SNG_ServicePlan.SERVICE_PLAN_TYPE_RECORD_TYPE_NAME, 'testServicePlanType_', true);
        insert servicePlanTypes;

        return constructServicePlans(accounts, servicePlanTypes.size(), servicePlanTypes, null);
    }


    public static List<ServicePlan__c> constructServicePlans(Account[] accounts, integer numOfObjsPerAccounts, Product2[] servicePlanTypes, string namePrefix)
    {
        // The following fields should be unique and needs to be an integer
        if (namePrefix==null) 
            namePrefix=''; //initialize to zero. 
        else
            System.assert(true, IsInteger(namePrefix)); //if non-null, must be an integer

        integer SALESORDER_REQ_LENGTH =  (Integer) SNGEnvVars__c.getOrgDefaults().SalesOrderNumericLength__c;
        
        list<ServicePlan__c> newobjs = new list<ServicePlan__c>();
        integer uNum = 0;
        for (Integer j=0; j < accounts.size(); j++)
        {
            Account a = accounts[j];
            
            for (Integer i=0; i < numOfObjsPerAccounts; i++)
            {
                ServicePlan__c newo = new ServicePlan__c();
                Product2 p = servicePlanTypes[0];
                if (servicePlanTypes.size() > i)
                    p = servicePlanTypes[i];
                newo.ServicePlanType__c = p.Id;
                newo.ServicePlanType__r = p;
                
                newo.Industry__c='Other';
                newo.StartDate__c=System.Today();
                newo.EndDate__c=System.Today().addDays(200);
                //(uNum==0 && namePrefix!='' ? namePrefix : namePrefix + string.valueOf(uNum));           
                if (namePrefix.length() < SALESORDER_REQ_LENGTH)
                {
                    String uNumStr = String.valueOf(uNum);
                    integer padLength = SALESORDER_REQ_LENGTH - uNumStr.length();
                    System.assert(namePrefix.length() <= padLength);
                    newo.SalesOrder__c =  StringUtils.rightPad(namePrefix, SALESORDER_REQ_LENGTH - uNumStr.length(), '0') + uNumStr;
                }
                else
                {
                    newo.SalesOrder__c = namePrefix;
                }
          
                newo.Account__c = a.Id;
                newo.Account__r = a;

                newobjs.add(newo);  
                uNum++;
            }
        }
        return newobjs;     
    }

    public static String generateSalesOrder(integer salesOrderNumber)
    {
        String salesOrderNumberStr = String.valueOf(salesOrderNumber);
        integer SALESORDER_REQ_LENGTH =  (Integer) SNGEnvVars__c.getOrgDefaults().SalesOrderNumericLength__c;

        System.assert(salesOrderNumberStr.length() <= SALESORDER_REQ_LENGTH);

        return (salesOrderNumberStr.length() < SALESORDER_REQ_LENGTH) ? 
                   StringUtils.rightPad('', SALESORDER_REQ_LENGTH - salesOrderNumberStr.length(), '0') + salesOrderNumberStr :
                   String.valueOf(salesOrderNumberStr);

    }

    public static ServicePlan__c createServicePlan(Account account, Date startDate, Date endDate, Product2 servicePlanType, String salesOrder)
    {
        ServicePlan__c servicePlan = new ServicePlan__c(); 
        
        servicePlan.StartDate__c = startDate;
        servicePlan.EndDate__c = endDate; 
        servicePlan.Account__c = account.Id;
        servicePlan.SalesOrder__c = salesOrder;
        servicePlan.ServicePlanType__r = servicePlanType;
        servicePlan.ServicePlanType__c = servicePlanType.Id;
        
        insert servicePlan;
        return servicePlan;
    }

    private static boolean isInteger(String strValue)
    {
        boolean retValue = true;

        try
        {
            Integer.valueOf(strValue);
        }
        catch (Exception e)
        {
            retValue = false;
        }

        return retValue;
    }

    //****************************************************************************
    public static Terminal__c constructTerminal(String namePrefix, Account a, Product2 terminalType, String serNum) {
        return constructTerminals(new Account[]{a}, 1, new Product2[]{terminalType}, namePrefix, serNum)[0];
    }

    public static List<Terminal__c> constructTerminals(Account a, integer numOfObjsPerAccounts, Product2[] terminalTypes, string namePrefix)
    {
        return constructTerminals(new Account[]{a}, numOfObjsPerAccounts, terminalTypes, namePrefix, '');
    }
    
    public static List<Terminal__c> constructTerminals(Account[] accounts, integer numOfObjsPerAccounts, Product2[] terminalTypes, string namePrefix, string uniqueNumber)
    {
        // The following fields should be unique and needs to be an integer
        if (uniqueNumber==null) 
            uniqueNumber=''; //initialize to zero. 
        else
            System.assert(true, IsInteger(uniqueNumber)); //if non-null, must be an integer

        integer SALESORDER_REQ_LENGTH =  (Integer) SNGEnvVars__c.getOrgDefaults().SalesOrderNumericLength__c;


        Product2[] termTypes = terminalTypes;

        // The following fields should be unique: SerialNumber__c, TrackingNumber__c, SalesOrder__c
        //string uniqueNumber = string.ValueOf(System.now().millisecond());
        if (namePrefix == null) namePrefix='';

        list<Terminal__c> newobjs = new list<Terminal__c>();
        integer uNum = 0;
        for (Integer j=0; j < accounts.size(); j++)
        {
          Account a = accounts[j];
          for (Integer i=0; i < numOfObjsPerAccounts; i++)
          {
            Terminal__c newo = new Terminal__c();
            //newo.IsActive = true;
            newo.Account__c = a.Id;
            newo.SerialNumber__c = 'SN' + string.valueOf(uNum) + uniqueNumber;
            newo.TrackingNumber__c = 'TN' + string.valueOf(uNum) + uniqueNumber;
            //newo.SalesOrder__c = string.valueOf(uNum) + uniqueNumber;   
            if (uniqueNumber.length() < SALESORDER_REQ_LENGTH)
            {
                String uNumStr = String.valueOf(uNum);
                integer padLength = SALESORDER_REQ_LENGTH - uNumStr.length();
                System.assert(uniqueNumber.length() <= padLength);
                newo.SalesOrder__c =  StringUtils.rightPad(uniqueNumber, SALESORDER_REQ_LENGTH - uNumStr.length(), '0') + uNumStr;
            }
            else
            {
                newo.SalesOrder__c = uniqueNumber;
            }
          

            newo.Nickname__c = (uNum==0 && namePrefix!='' ? namePrefix : namePrefix + string.valueOf(uNum) + uniqueNumber);
            
            if (termTypes.size() > 0)
            {
                Product2 termType = termTypes[0];
                if (termTypes.size() > 1)
                    termType = termTypes[i];
                
                newo.TerminalType__r = termType;
                newo.TerminalType__c = termType.Id;
            }
            newo.Account__r = a;
            newo.ShipDate__c= DateTime.now().date();
            
            newobjs.add(newo);      
            uNum++;
          }
        }
        return newobjs;     
    }

    //****************************************************************************
    public static List<ModemServicePlan__c> constructModemServicePlans(List<Modem__c> modems, ServicePlan__c servicePlan, Date startDate, Date endDate)
    {
        //System.assert(startDate >= servicePlan.StartDate__c);
        //System.assert(endDate <= servicePlan.EndDate__c);
                                                                                           
        list<ModemServicePlan__c> newobjs = new list<ModemServicePlan__c>();
        for (Integer i=0; i < modems.size(); i++)
        {
            ModemServicePlan__c newo = new ModemServicePlan__c();
            newo.Modem__r = modems[i]; 
            //newo.ServicePlan__r = servicePlan;
            newo.StartDate__c = startDate;
            newo.EndDate__c = endDate;
            newo.Modem__c=modems[i].id;
            newo.ServicePlan__c=servicePlan.id;
            //newo.Status__c = 'Active'; NOT WRITABLE
            newobjs.add(newo);
        }               

        return newobjs;     
    }


    public static ModemServicePlan__c constructModemServicePlan(Modem__c modem, ServicePlan__c servicePlan) {
        return constructModemServicePlan(modem, servicePlan, servicePlan.StartDate__c, servicePlan.EndDate__c);
    }

    public static ModemServicePlan__c constructModemServicePlan(Modem__c modem, ServicePlan__c servicePlan, Date startDate, Date endDate) {
        list<Modem__c> modems = new list<Modem__c>();
        modems.add(modem);
        ModemServicePlan__c msp = constructModemServicePlans(modems, servicePlan, startDate, endDate)[0];
        return msp;
    }
    
    public static List<ModemServicePlan__c> constructListOfModemServicePlans(Integer numberOfMsps, String accountName,
                                                                          Integer numOfTerminalTypes, Integer numOfServicePlanTypes) 
    {
        Account account = SNG_TestUtilities.insertAccount(accountName);

        Product2[] terminalTypes = ViasatTestUtility.createProducts(numOfTerminalTypes, 'Exede', SNG_Terminal.TERMINAL_TYPE_RECORD_TYPE_NAME, 'testTerminalType_', true);         
        insert terminalTypes;

        Product2[] servicePlanTypes = ViasatTestUtility.createProducts(numOfServicePlanTypes, 'Exede', SNG_ServicePlan.SERVICE_PLAN_TYPE_RECORD_TYPE_NAME, 'testServicePlanType', true);
        insert servicePlanTypes;

        Terminal__c[] terminals = constructTerminals(account, numberOfMsps, terminalTypes, '');//equipmentName);
        insert terminals;

        Modem__c[] modems = SNG_TestUtilities.constructModems(account, numberOfMsps, terminals, SNG_TestUtilities.VALID_MAC_ADDRprefix, 'SN');
        insert modems;
        
        ServicePlan__c[] servicePlans = constructServicePlans(new Account[]{account}, numberOfMsps, servicePlanTypes, null);        
        insert servicePlans;

        list<ModemServicePlan__c> msps = constructModemServicePlans(modems, servicePlans);
        return msps;
    }

    public static List<ModemServicePlan__c> constructModemServicePlans(list<Modem__c> newModems, list<ServicePlan__c> newSPs)
    {
        Modem__c[] modems = newModems;                                            
        ServicePlan__c[] sps = newSPs;
                                                                                           
        list<ModemServicePlan__c> newobjs = new list<ModemServicePlan__c>();
        for (Integer i=0; i < newModems.size(); i++)
        {
            ModemServicePlan__c newo = new ModemServicePlan__c();
            newo.Modem__r = modems[i]; 
            newo.ServicePlan__r = sps[i];
            newo.StartDate__c = sps[i].StartDate__c;
            newo.EndDate__c = sps[i].EndDate__c;
            newo.Modem__c=modems[i].id;
            newo.ServicePlan__c=sps[i].id;
            //newo.Status__c = 'Active'; NOT WRITABLE
            newobjs.add(newo);
        }                   
        return newobjs;     
    }


    public static ModemServicePlan__c createModemServicePlan(Modem__c modem, ServicePlan__c servicePlan)
    {
        ModemServicePlan__c msp = new ModemServicePlan__c(); 
        
        msp.Modem__c = modem.Id;
        msp.Modem__r = modem;
        msp.ServicePlan__c = servicePlan.Id;
        msp.ServicePlan__r = servicePlan;
        msp.StartDate__c = servicePlan.StartDate__c;
        msp.EndDate__c = servicePlan.EndDate__c;  
        
        return msp;
    }

    public static ModemServicePlan__c createModemServicePlan(Modem__c modem, ServicePlan__c servicePlan, Date startDate, Date endDate)
    {
        ModemServicePlan__c msp = new ModemServicePlan__c(); 
        
        msp.Modem__c = modem.Id;
        msp.Modem__r = modem;
        msp.ServicePlan__c = servicePlan.Id;
        msp.ServicePlan__r = servicePlan;
        msp.StartDate__c = startDate;
        msp.EndDate__c = endDate;  
        
        return msp;
    }   

    public static String getValidMacAddressForNumber(String prefix, Integer num) {
        String numInHex = NumberUtils.toHexString(num);
        if (6 >= numInHex.length()) {
            while (6 > numInHex.length()) {
                numInHex = String.valueOf(0) + numInHex;
            }
            final String macAddr = prefix + numInHex.substring(0, 2) + ':' + numInHex.substring(2, 4) + ':' + numInHex.substring(4);
            return macAddr;
        } else
            throw new SNG_Exception('Number is too big to create a valid MAC address: ' + num);
    }
    
    public static String getHexDirectionFromUtc(String plusOrMinus)
    {
        String hexValue;
        if ('+' == plusOrMinus)
            hexValue = '2b';
        else if ('-' == plusOrMinus)
            hexValue = '2d';
        else
            hexValue = '4f';
        return hexValue;
    }
}