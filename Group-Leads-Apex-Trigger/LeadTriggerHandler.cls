/**
 * @description: Handles all Lead Trigger events.
 * It includes logic for handling after insert events.
 * 
 * TODO: Make configuring timeWindow easier if it need to change regularly, i.e. moving it to 
 * custom metadata types
 * TODO: fixing the timestamp on the Campaign, currently 2hours behind local time
 */
public class LeadTriggerHandler {
    /**
     * @description method called to group all provided Lead records to a Campaign record
     * @param leadRecords List of Lead records that will be grouped to a Campaign record.
     */
    public static void groupLeadsToCampaign(Map<Id,Lead> leadRecords){
        Set<Id> leadOwnerIds = new Set<Id>();
        
        /** Get all the Owner Ids from all the Leads that were
         * created during the bulk creation process
         * Expecting one OwnerId
         */ 
        for (Lead leadRecord:leadRecords.values()){
            leadOwnerIds.add(leadRecord.OwnerId);
        }
        
        /** Get all the Owner Names from the OwnerIds extracted
         * Expecting one user name
         */
        List<String> userNames = new List<String>();
        for (User userRecord:[SELECT Name FROM User WHERE Id IN :leadOwnerIds]){
            userNames.add(userRecord.Name);
        }
        
        /** Get all relevant campaign records that are not older than a given datetime
         * Currently the timeframe is set to now - 10 minutes
         * Expecting one record.
         */
        DateTime timeWindow = datetime.now().addMinutes(-10);
		Map<Id,Campaign> campaignRecords = new Map<Id,Campaign>([SELECT Id FROM Campaign WHERE OwnerId IN :leadOwnerIds AND Name LIKE 'Foobar%' AND CreatedDate > :timeWindow ORDER BY CreatedDate DESC]);
        
        /** Add the campaign recordIds into a List
         */
        List<Id> campaignRecordIds = new List<Id>();
        for (Campaign campaignRecord:campaignRecords.values()){
            campaignRecordIds.add(campaignRecord.Id);
        }
        
        /** Calls the helper function that groups all
         * the relevant lead records to the existing campaign,
         * or a newly created campaign if an existing one 
         * isn't found
         */
        LeadTriggerHelper.groupLeadsToCampaign(leadRecords,campaignRecordIds,userNames);
    }

}