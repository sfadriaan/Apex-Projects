public class LeadTriggerHelper {
    
    /**
     * @description Creates CampaignMember records that associate all provided Lead records
     * to the provided Campaign record. If no Campaign record is provided, one will be created.
     * @param leadRecords List of Lead records that will be grouped to a Campaign record.
     * @param campaignRecordIds List of Ids for the relevant Campaign records that will be used
     * @param userNames List of user names that is used to create Campaign records
     */
    public static void groupLeadsToCampaign(Map<Id,Lead> leadRecords, List<Id> campaignRecordIds, List<String> userNames){
        
        /** Checks first if a List of Campaign records have been provided.
         * If none is provided, then Campaign records are created for each
         * provided user name
        */
        if (campaignRecordIds.size() == 0){
            List<Campaign> campaignRecords = new List<Campaign>();
            campaignRecords = createCampaignRecords(userNames);
            for (Campaign campaignRecord:campaignRecords){
                campaignRecordIds.add(campaignRecord.Id);
            }
        }
        
        /** Creates a List of Campaign Member records to 
         * be created for the given Lead Ids and Campaign records
        */
        List<CampaignMember> campaignMembers = new List<CampaignMember>();
        for (Id campaignRecordId:campaignRecordIds){
        	for (Id leadRecordId:leadRecords.keySet()){
            	campaignMembers.add(new CampaignMember(CampaignId=campaignRecordId, LeadId=leadRecordId));	
        	}    
        }
        insert campaignMembers;
    }

    /**
     * @description Creates a Campaign record for each provided User Name.
     * Example Campaign Name where userName = Adriaan van Niekerk, 
     * is in the format of "Foobar Adriaan van Niekerk yyyy-MM-dd hh:mm:ss"
     * @param userNames List of Strings that will be used to create Campaign records.
     */
    @TestVisible
    private static List<Campaign> createCampaignRecords(List<String> userNames){
        List<Campaign> campaignRecords = new List<Campaign>();
        for (String userName:userNames){
            campaignRecords.add(new Campaign(Name ='Foobar '+ userName +' '+datetime.now()));
        }
        insert campaignRecords;
        return campaignRecords;
    } 

}