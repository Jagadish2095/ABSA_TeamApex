/**
* @description Test class Controller used by lightning components for User Selection in flow
*
* @author  Almas Aleem
* @version v1.0
* @since   2020-09-08
* 
*/
@isTest
public class UserSelectionControllerTest {

    /**
    * @description 
    * @author almas.aleem@absa.africa | 2021-07-12 
    **/
    @testSetup static void createData(){
        Profile ap = [SELECT Id FROM Profile WHERE Name = 'System Administrator (Custom)'];
        String orgId = userInfo.getOrganizationId();
        String dateString = Datetime.now().format('yyyMMddHHmmss');
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        String uniqueName = dateString + randomInt + '@test' + orgId + '.org';
        User testUser = new User();
        testUser.FirstName = 'WillTestUser';
        testUser.LastName = 'WillTtestData';
        testUser.Email = uniqueName;
        testUser.Username = uniqueName;
        testUser.BRID__c = '45789';
        testUser.EmailEncodingKey = 'ISO-8859-1';
        testUser.Alias = 'WillUser';
        testUser.TimeZoneSidKey = 'Africa/Johannesburg';
        testUser.LocaleSidKey = 'en_US';
        testUser.LanguageLocaleKey = 'en_US';
        testUser.ProfileId = ap.id ;
        testUser.Advisor_Code__c ='A12345';
        testUser.mobilePhone='0658992600';
        testUser.RBB_Super_Region__c='Cape';
        insert testUser;
}
    
        /**
        * @description 
        * @author almas.aleem@absa.africa | 2021-07-12 
        **/
        @isTest static void testLoadUsers() {
    Test.startTest();
        List<User> users = UserSelectionController.loadUsers('Credit_Onboarding');
        
        List<User> users1 = UserSelectionController.loadUsers('Merchant_Onboarding');
        
        System.assertNotEquals(null,users);
        Test.stopTest();
    }
}