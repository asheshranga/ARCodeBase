public with sharing class SMSflightMapCtrl {
    public Flight_Perf__c flightPerfObj {get;set;}
    public List<Flight__c> flightStati {get;set;}
    public Map<Id, Flight_Perf__c> flightMap {get;set;}
    public String SerializeMap {get;set;}
    public String SerializeStati {get;set;}
    
    public SMSflightMapCtrl(ApexPages.StandardController stdController) {
        Set<String> notActiveSet = new Set<String>{'Pushback', 'Taxi', 'Arrived'};
        
        
        flightStati = [Select Id, Flight_Number__c, Status__c, peds__c, ocode__c, MAC__c from Flight__c where Status__c not in :notActiveSet];
        Set<Id> flightSet = new Set<Id>();
        for (Integer i = 0; i < flightStati.size(); i++) { 
            flightSet.add(flightStati[i].Id);
        }
        System.debug('Flights: ' + flightStati);
        System.debug('Flight set: ' + flightSet);
        List<Flight_Perf__c> flightPerfs = [Select Name, Altitude__c, Flight__c, tstamp__c, lat__c, long__c from Flight_Perf__c where Flight__c in :FlightSet order by tstamp__c desc]; 
        System.debug('Flight Perfs: ' + flightPerfs);
        flightMap = new Map<Id, Flight_Perf__c>();
        Integer flightPerf;
            for (flightPerf = 0; flightPerf < flightPerfs.size(); flightPerf++) {
                if (flightMap.get(flightPerfs[flightPerf].Flight__c) != null){
                    continue;
                }
                else {
                    flightMap.put(FlightPerfs[flightPerf].Flight__c, flightPerfs[flightPerf]);
                }
            }
            SerializeMap=JSON.serialize(flightMap);
            SerializeStati=JSON.serialize(flightStati);   
    }
}