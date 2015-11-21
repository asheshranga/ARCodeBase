/**
 * This class contains helper functions to determine whether a modem can be successfully added or
 * updated in the database.
 */
public with sharing class SNG_Modem {
    
    /**
     * Given a list of modem Ids, create a Map of ID to modem objects
     *
     * @param   modemIds    List of modem IDs
     * @return              Map of modem IDs to their respective modem records
     */
    public static Map<Id, Modem__c> buildMapOfModems(List<Id> modemIds) { 

        return new Map<Id, Modem__c>([SELECT Id, Name, Account__c, Account__r.Name, Terminal__c, Terminal__r.TerminalType__c 
                                        FROM Modem__c WHERE Id IN :modemIds]);
    }


    /**
     * Updates associated Modem and Terminal pairs that have had their accounts changed: 
     * 1) deassociate the lookup between the modem and its terminal
     * 2) update the modems and terminals
     * 3) retrieve the updated modems and terminals
     * 4) reassociated corresponding modems and terminals 
     *
     * @param   modems      List of Modem objects with changed Accounts
     * @param   terminals   List of Terminals with changed Accounts  
     */
    public static void reassociateModemWithTerminal(List<Modem__c> modems, List<Terminal__c> terminals)
    {
        Map<Id, Id> modemToTerminal = new Map<Id, Id>();

        // Build Map of Modem IDs to Terminal IDs and deassociate modem's lookup to the terminal
        for (Modem__c modem : modems)
        {
            modemToTerminal.put(modem.Id, modem.Terminal__c);
            modem.Terminal__c = null;
        }

        // update Modems and Terminals
        update modems;
        update terminals;

        // Retrieve list of modems that were updated
        List<Modem__c> updatedModems = [SELECT Id, Name, Account__c, Terminal__c FROM Modem__c WHERE Id IN :modemToTerminal.keySet()];

        // Associate modems with their previous terminals
        for (Modem__c modem : updatedModems)
        {
            modem.Terminal__c = modemToTerminal.get(modem.Id);
        }

        // update reassociated modems
        update updatedModems;
    }


    /**
     * Looks up the MSPs for the given modem active between a specified start and end date.
     *
     * @param   modem       The modem to return the active MSP for
     * @param   startDate   The start date range to look for Modem/Service Plans.
     * @param   endDate     The end date range to look for Modem/Service Plan.
     * @return              The active MSP for the given modem
     *                      If no active MSP for the given modem, an empty list is returned.
     */
    public static List<ModemServicePlan__c> getMspsForModem(final Modem__c modem, final Date startDate, final Date endDate) {
        
        List<ModemServicePlan__c> msps = [SELECT Modem__r.Name, StartDate__c, EndDate__c FROM ModemServicePlan__c 
                                          WHERE Modem__c = :modem.Id AND
                                                StartDate__c <= :endDate AND 
                                                EndDate__c >= :startDate 
                                                ORDER BY StartDate__c ASC];  
        return msps;
    }


    /**
     * Looks up the active MSP for the given modem
     *
     * @param   modem   The modem to return the active MSP for
     * @return          The active MSP for the given modem
     *                  If no active MSP for the given modem, null is returned.
     */
    public static ModemServicePlan__c getActiveMspForModem(final Modem__c modem) {
        ModemServicePlan__c msp = null;
        
        try {
            msp = [SELECT Id, StartDate__c, EndDate__c FROM ModemServicePlan__c WHERE Modem__c = :modem.Id 
                    AND Status__c = :SNG_ModemServicePlan.MSP_STATUS_ACTIVE];
        } catch(QueryException e) {
            System.debug('No MSP found for modem ' + modem.Name
                         + '\nException: ' + e.getMessage());
        }
        
        return msp;
    }

    
    // Trigger handling code starts here

    public static Map<Modem__c, String> handleBeforeInsert(final Modem__c[] newModems) {
        return handleBeforeUpdate(new Map<Id, Modem__c>(), newModems);
    }


    public static Map<Modem__c, String> handleBeforeUpdate(final Map<Id, Modem__c> oldModems, final Modem__c[] newModems) {
        final Map<Modem__c, String> modemError = new Map<Modem__c, String>();

        // Run the validation
        Modem__c[] modemsPassingValidation = SNG_ModemValidation.validateBeforeUpdate(oldModems, newModems, modemError);

        // Post-processing on the modem object itself would go here. Instead, it's done in a Workflow Rule now.

        return modemError;
    }


    /**
     * Validates modem changes identified in a "before delete" trigger. Supports only the delete case.
     *
     * @param oldModems     old modems from trigger
     * @return              map of modems with errors
     */
    public static Map<Id, String> handleBeforeDelete(final Map<Id, Modem__c> oldModems) {
        final Map<Id, String> modemError = new Map<Id, String>();

        Modem__c[] modemsPassingValidation = SNG_ModemValidation.validateBeforeDelete(oldModems, modemError);

        // No post-processing on the modem object since it's being deleted

        return modemError;
    }


    public static void handleAfterInsert(final Modem__c[] newModems) {
        handleAfterUpdate(new Map<Id, Modem__c>(), newModems);
    }


    public static void handleAfterUpdate(final Map<Id, Modem__c> oldModems, final Modem__c[] newModems) {
        handleAfterUpdatePostProcessing(oldModems, newModems);
    }


    public static void handleAfterDelete(final Modem__c[] oldModems) {
        resetModemDataInTerminals(oldModems);
    }


    /**
     * Verifies the terminal referenced in Modem has been changed in the update.
     *
     * @param   oldModem        The modem object prior to the update.
     * @param   newModem        The modem object after the update.
     *
     * @return                  Whether the terminal object has been updated or not.
     */ 
    public static boolean isTerminalChanged(final Modem__c oldModem, final Modem__c newModem) {
        return null == oldModem || oldModem.Terminal__c != newModem.Terminal__c;
    }


    /**
     * Verifies the Modem name has been changed in the update.
     *
     * @param   oldModem        The modem object prior to the update.
     * @param   newModem        The modem object after the update.
     *
     * @return                  Whether the Name field has been updated or not.
     */ 
    private static boolean isNameChanged(final Modem__c oldModem, final Modem__c newModem) {
        return null == oldModem || oldModem.Name != newModem.Name;
    }

    private static void handleAfterUpdatePostProcessing(final Map<Id, Modem__c> oldModems, final Modem__c[] newModems) {
        // Get the terminals that need to be updated as a result of this insert/update trigger processing
        final Map<Id, Modem__c> terminalIdToModem = new Map<Id, Modem__c>();
        final Map<Id, Terminal__c> terminalsToUpdate = getTerminalsToUpdate(oldModems, newModems, terminalIdToModem);

        // Reset modem dependent data in terminals
        SNG_Terminal.resetModemDependentDataWithoutUpdate(terminalsToUpdate.values());

        // Update terminal association with modems
        updateModemTerminalAssociation(terminalsToUpdate, terminalIdToModem);

        // Actually update the terminals that need to be updated
        update terminalsToUpdate.values();
    }

    private static Map<Id, Terminal__c> getTerminalsToUpdate(final Map<Id, Modem__c> oldModems, final Modem__c[] modemsPassingValidation, 
                                                             final Map<Id, Modem__c> terminalIdToModem) {
        final Set<Id> terminalIds = new Set<Id>();
        for (Modem__c newModem : modemsPassingValidation) {
            final Modem__c oldModem = oldModems.get(newModem.Id);

            // If terminal changed, need to update the old and new terminal (if not null)
            if (isTerminalChanged(oldModem, newModem)) {
                if (null != oldModem && null != oldModem.Terminal__c) {
                    terminalIds.add(oldModem.Terminal__c);
                    terminalIdToModem.put(oldModem.Terminal__c, null);
                }

                if (null != newModem.Terminal__c) {
                    terminalIds.add(newModem.Terminal__c);
                    terminalIdToModem.put(newModem.Terminal__c, newModem);
                }
            }

            // If the name (mac address) changed, need to update only the new terminal
            else if (isNameChanged(oldModem, newModem) && null != newModem.Terminal__c) {
                terminalIds.add(newModem.Terminal__c);
                terminalIdToModem.put(newModem.Terminal__c, newModem);
            }
        }

        return new Map<Id, Terminal__c>([SELECT Id, Name, DownloadSinrBackEnd__c, GbDownloaded__c, GbTotal__c, GbUploaded__c, IpAddress__c, 
                                        MacAddress__c, OnlineTime__c, PeersAvgUploadSymbolRateBackEnd__c, PeersOnlineBackEnd__c, 
                                        StatusBackEnd__c, UploadSymbolRateBackEnd__c FROM Terminal__c WHERE Id = :terminalIds FOR UPDATE]);
    }

    private static void updateModemTerminalAssociation(final Map<Id, Terminal__c> terminalsToUpdate, final Map<Id, Modem__c> terminalIdToModem) {
        for (Id terminalId : terminalIdToModem.keySet()) {
            final Modem__c modem = terminalIdToModem.get(terminalId);
            final Terminal__c terminal = terminalsToUpdate.get(terminalId);

            if (null != terminal) {
                updateTerminalMacAddressField(terminal, modem);
            }
        }
    }

    private static void updateTerminalMacAddressField(final Terminal__c terminal, final Modem__c modem) {
        SNG_ExceptionUtil.throwIfNullObject(terminal, 'Terminal to associate for modem is null');
        //For now just update the MAC address field in the terminal object
        // NOTE: This needs to use modem.Name rather than modem.MacAddress__c here since the Name is changed by the user
        //       and MacAddress__c is changed later in a Workflow Rule Action.
        terminal.MacAddress__c = (null != modem ? modem.Name : null);
    }

    private static void resetModemDataInTerminals(final Modem__c[] modems) {
        Id[] terminalIds = new List<Id>();
        for (Modem__c modem : modems) {
            terminalIds.add(modem.Terminal__c);
        }
        final Terminal__c[] terminals = [SELECT DownloadSinrBackEnd__c, GbDownloaded__c, GbTotal__c, GbUploaded__c, IpAddress__c, 
                                   MacAddress__c, OnlineTime__c, PeersAvgUploadSymbolRateBackEnd__c, PeersOnlineBackEnd__c, 
                                   StatusBackEnd__c, UploadSymbolRateBackEnd__c FROM Terminal__c WHERE Id = :terminalIds FOR UPDATE];

        SNG_Terminal.resetModemDependentDataWithoutUpdate(terminals);
        update terminals;
    }

}