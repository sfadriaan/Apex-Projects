@isTest
public class LeadTriggerHelperTest {
    
    // Tests the creation of a Campaign Record
    @isTest
    public static void unitTestCampaignRecordCreation(){
        Final Integer NUMBER_OF_USER_NAMES=1;
        String userName = null;
        List<String> userNames = new List<String>();
        for (Integer i=0; i<NUMBER_OF_USER_NAMES;i++){
        	userNames.add('Username '+i);
        }
        
        List<Campaign> campaignRecords = new List<Campaign>();
        campaignRecords = LeadTriggerHelper.createCampaignRecords(userNames);
        Assert.areEqual(NUMBER_OF_USER_NAMES,campaignRecords.size(),'Only one Campaign Records should be created');
    }
    
    // Tests the creation of multiple Campaign Records
    @isTest
    public static void bulkTestCampaignRecordCreation(){
        Final Integer NUMBER_OF_USER_NAMES=201;
        String userName = null;
        List<String> userNames = new List<String>();
        for (Integer i=0; i<NUMBER_OF_USER_NAMES;i++){
        	userNames.add('Username '+i);
        }
        
        List<Campaign> campaignRecords = new List<Campaign>();
        campaignRecords = LeadTriggerHelper.createCampaignRecords(userNames);
        Assert.areEqual(NUMBER_OF_USER_NAMES,campaignRecords.size(),'The correct number of Campaign Records were not created');
    }
    
    //Tests if one Lead record is added to a Campaign record as a
    //campaign member
    @isTest
    public static void unitTestGroupOneLeadToOneCampaign(){
        List<String> userNames = new List<String>();
        userNames.add('Adriaan van Niekerk');
        
        
        List<Campaign> campaignRecords = new List<Campaign>();
        Campaign campaignRecord = new Campaign(Name ='Test Campaign');
        campaignRecords.add(campaignRecord);
        insert campaignRecords;
        
        List<Id> campaignRecordIds = new List<Id>();
        for (Campaign cr:campaignRecords){
            campaignRecordIds.add(cr.Id);
        }
        
        List<Lead> leadRecords = new List<Lead>();
        Lead leadRecord = new Lead(LastName = 'Test Lead', Company='Private');
        leadRecords.add(leadRecord);
        insert leadRecords;
        
        Map<Id,Lead> map_LeadRecords = new Map<Id,Lead>();
        map_LeadRecords.putAll(leadRecords);
        
        LeadTriggerHelper.groupLeadsToCampaign(map_LeadRecords, campaignRecordIds, userNames);
        
        List<CampaignMember> campaignMembers = new List<CampaignMember>([SELECT Id FROM CampaignMember]);
        Assert.areEqual(1,campaignMembers.size(),'Only one Campaign Member should be created');    
    }
    
    //Tests if multiple Lead records are added to a Campaign records
    //as campaign members
    @isTest
    public static void bulkTestGroupLeadsToOneCampaign(){
        Final Integer NUMBER_OF_LEADS = 300;
        
        List<String> userNames = new List<String>();
        userNames.add('Adriaan van Niekerk');
        
        List<Campaign> campaignRecords = new List<Campaign>();
        Campaign campaignRecord = new Campaign(Name ='Test Campaign');
        campaignRecords.add(campaignRecord);
        insert campaignRecords;
        
        List<Id> campaignRecordIds = new List<Id>();
        for (Campaign cr:campaignRecords){
            campaignRecordIds.add(cr.Id);
        }
        
        List<Lead> leadRecords = new List<Lead>();
        for (Integer i=0;i<NUMBER_OF_LEADS;i++){
            leadRecords.add(new Lead(LastName = 'Test Lead '+i, Company='Private'));
        }
        
        insert leadRecords;
        system.debug(leadRecords);
        
        Map<Id,Lead> map_LeadRecords = new Map<Id,Lead>();
        map_LeadRecords.putAll(leadRecords);
        
        LeadTriggerHelper.groupLeadsToCampaign(map_LeadRecords, campaignRecordIds, userNames);
        
        List<CampaignMember> campaignMembers = new List<CampaignMember>([SELECT Id FROM CampaignMember]);
        Assert.areEqual(NUMBER_OF_LEADS,campaignMembers.size(),'More than one Campaign Member record should be created');    
    }
    
    //Tests if multiple Lead records are added to a Campaign that is created
    //as no existing CampaignRecordId is provided.
    @isTest
    public static void bulkTestGroupLeadsToNewlyCreatedCampaign(){
        Final Integer NUMBER_OF_LEADS = 300;
        
        List<String> userNames = new List<String>();
        userNames.add('Adriaan van Niekerk');
        
        List<Id> campaignRecordIds = new List<Id>();
        
        List<Lead> leadRecords = new List<Lead>();
        for (Integer i=0;i<NUMBER_OF_LEADS;i++){
            leadRecords.add(new Lead(LastName = 'Test Lead '+i, Company='Private'));
        }
        
        insert leadRecords;
        system.debug(leadRecords);
        
        Map<Id,Lead> map_LeadRecords = new Map<Id,Lead>();
        map_LeadRecords.putAll(leadRecords);
        
        LeadTriggerHelper.groupLeadsToCampaign(map_LeadRecords, campaignRecordIds, userNames);
        
        List<CampaignMember> campaignMembers = new List<CampaignMember>([SELECT Id FROM CampaignMember]);
        Assert.areEqual(NUMBER_OF_LEADS,campaignMembers.size(),'More than one Campaign Member record should be created');    
    }
}