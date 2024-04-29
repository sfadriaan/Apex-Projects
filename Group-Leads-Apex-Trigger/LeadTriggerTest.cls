/**
 * @description: Test Class for the Lead Apex Trigger
 * 
 * TODO: Create Data factory for the creation of all the 
 * necessary test records 
 */

@isTest
public class LeadTriggerTest {
    @isTest
    public static void bulkInsertLeadRecords(){
        Final Integer NUMBER_OF_LEADS = 300;
        
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
        	List<Id> campaignRecordIds = new List<Id>();
        
        	List<Lead> leadRecords = new List<Lead>();
        	for (Integer i=0;i<NUMBER_OF_LEADS;i++){
            	leadRecords.add(new Lead(LastName = 'Test Lead '+i,Company='Private', LeadSource='Foobar', OwnerId=UserInfo.getUserId()));
        	}
        
        	insert leadRecords;
    	}
        List<CampaignMember> campaignMembers = new List<CampaignMember>([SELECT Id FROM CampaignMember]);
        Assert.areEqual(NUMBER_OF_LEADS,campaignMembers.size(),'More than one Campaign Member record should be created');    

    }
}