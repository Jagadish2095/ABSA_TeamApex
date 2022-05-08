/**
 * Apex Enterprise Design Patterns
 * @description Selector Layer for Group Member object
 *
 * @author  Poulami Banerjee
 * @since   2021-05-13
 */
@isTest
public class CampaignsSelectorTest {
    
    @isTest
	private static void testSelectSObjectsByCode() {
		Campaign tstCampaign = new Campaign();
		tstCampaign.Name = 'DD - Flexi Funeral Online';
		tstCampaign.IsActive = true;
        tstCampaign.Campaign_Code__c = 'FlexiOnline';
		insert tstCampaign;
		CampaignsSelector grs = new CampaignsSelector();
        Campaign gr=grs.selectByCodeName('FlexiOnline');
        System.assertNotEquals(null, grs);
        grs.getSObjectFieldList();
        grs.getSObjectType();
		
	}

}