@isTest
public class LeadTriggerHandlerTest {
    @isTest
    public static void bulkTestGroupLeadsToOneCampaign(){
		Final Integer NUMBER_OF_LEADS = 5;
        
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        // This code runs as the system user
        Profile profileRecord = [SELECT Id FROM Profile WHERE Name='Standard User'];
        
        User userRecord = new User(Alias = 'standt', 
                                   Email='standarduser@testorg.com',
                                   EmailEncodingKey='UTF-8', 
                                   LastName='Testing', 
                                   LanguageLocaleKey='en_US',
                                   LocaleSidKey='en_US', 
                                   ProfileId = profileRecord.Id,
                                   TimeZoneSidKey='America/Los_Angeles',
                                   UserName=uniqueUserName);
        insert userRecord;

        System.runAs(userRecord) {
        	// The following code runs as user 'userRecord'
        	System.debug('Current User: ' + UserInfo.getUserName());
            System.debug('Current Profile: ' + UserInfo.getProfileId());
        
        	List<Campaign> campaignRecords = new List<Campaign>();
        	Campaign campaignRecord = new Campaign(Name ='Foobar Adriaan van Niekerk yyyy-MM-dd hh:mm:ss',OwnerId=UserInfo.getUserId());
        	campaignRecords.add(campaignRecord);
        	insert campaignRecords;
            system.debug('Campaign records: '+campaignRecords);
        
        	List<Id> campaignRecordIds = new List<Id>();
        	for (Campaign cr:campaignRecords){
            	campaignRecordIds.add(cr.Id);
        	}
        
        	List<Lead> leadRecords = new List<Lead>();
        	for (Integer i=0;i<NUMBER_OF_LEADS;i++){
            	leadRecords.add(new Lead(LastName = 'Test Lead '+i, Company='Private', OwnerId=UserInfo.getUserId()));
        	}
        
        	insert leadRecords;
            system.debug(leadRecords);
        
        	Map<Id,Lead> map_LeadRecords = new Map<Id,Lead>();
        	map_LeadRecords.putAll(leadRecords);
        	system.debug(map_LeadRecords);
        
        
       		LeadTriggerHandler.groupLeadsToCampaign(map_LeadRecords);
       
       	}
  
        List<CampaignMember> campaignMembers = new List<CampaignMember>([SELECT Id FROM CampaignMember]);
        List<Campaign> createdCampaignRecords = new List<Campaign>([SELECT Id FROM Campaign]);
        Assert.areEqual(NUMBER_OF_LEADS,campaignMembers.size(),'More than one Campaign Member record should be created');    
        Assert.areEqual(1,createdCampaignRecords.size(),'Just one Campaign record should be created');
    }
}