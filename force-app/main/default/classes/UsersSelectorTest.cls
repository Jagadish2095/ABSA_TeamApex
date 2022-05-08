/**
* Apex Enterprise Design Patters
* @description Test Class for the Selector layer for User objects
*
* @author  Himanshu Nimje
* @since   28/03/2019
* @lastmodifiedDate   11/12/2021
*/

@IsTest
private class UsersSelectorTest {
    /**
    * @description 
    * @author almas.aleem@absa.africa | 2021-07-12 
    **/
    @testSetup static void setup() {
        
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');       
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        String uniqueName = orgId + dateString + randomInt;
        User uObj = new User();
        uObj.ProfileId = [SELECT Id FROM Profile LIMIT 1].Id;
        uObj.LastName = 'JKumar';
        uObj.Email = 'brokerNoteUser@gmail.com';
        uObj.Username = uniqueName + '@test' + orgId + '.org';
        uObj.CompanyName = 'TEST';
        uObj.Title = 'Mr.';
        uObj.EmailEncodingKey = 'ISO-8859-1';
        uObj.Alias = uniqueName.substring(18, 23);
        uObj.TimeZoneSidKey = 'America/Los_Angeles';
        uObj.LocaleSidKey = 'en_US';
        uObj.LanguageLocaleKey = 'en_US';
        uObj.Advisor_Code__c='98765';
        Insert uObj;
       
        
       
    }
    

    
    /**
    * @description 
    * @author almas.aleem@absa.africa | 2021-07-12 
    
    **/
    @isTest
    static void  testGetSObjectType() {
        System.assert(new UsersSelector().getSObjectType() != null);
    }

    /**
    * @description 
    * @author almas.aleem@absa.africa | 2021-07-12 
   
    **/

    @isTest
    static  void testgetSObjectFieldList() {
        System.assert(new UsersSelector().getSObjectFieldList() != null);
    }

    /**
    * @description 
    * @author almas.aleem@absa.africa | 2021-07-12 
    
    **/
    @isTest
    static  void testselectById() {

        WillsTestDataFactory testDataFactory = new WillsTestDataFactory();
        UsersSelector ucs = new UsersSelector();
        User tstUser = testDataFactory.testUser;

        System.assert(ucs.selectById(tstUser.Id) != null);
        Set<Id> idSet = new Set<Id>();
        idSet.add(tstUser.Id);
        System.assert(ucs.selectById(idSet) != null);
        Set<String> bidSet = new Set<String>();
        bidSet.add(tstUser.BRID__c);
        System.assert(ucs.selectByBridNumbers(bidSet) != null);
        System.assert(ucs.userwithEmployeeNumber('12345') != null);
        System.assert(ucs.userwithSiteCode(tstUser.Id) != null);
        System.assert(ucs.selectByBridNumber(tstUser.BRID__c,1) != null);
        System.assert(ucs.selectByBridNumber(tstUser.BRID__c) != null);
        List<User> usByAbNum = ucs.selectByAbNumber('ABNumber');
        System.assert(ucs.selectByOpportunityOwnerId(testDataFactory.testOpportunity.OwnerId) != null);
        Set<String> idOwnerS = new Set<String>();
        idOwnerS.add(tstUser.Id);
        List<User> usByIdStringSet = ucs.selectuserfortask(idOwnerS);
        List<User> usByActiveUsr = ucs.selectactiveusersById();
        Set<Id> userIdSet = new Set<Id>();
        userIdSet.add(tstUser.Id);
        List<User> usByIdSet = ucs.selectByIdWithRole(userIdSet);
        Set<String> emailSet = new Set<String>();
        emailSet.add('test@test.com');
        List<User> usByEmailSet = ucs.selectByEmail(emailSet);
        LIST<User> usByIdProfileName = ucs.selectById(tstUser.Id,'profileName');
        LIST<User> usByIdRoleName = ucs.selectByroleId(tstUser.Id,'roleName');
        String adviserCode = '98765';
        //ucs.selectByIdRefunds(tstUser.Id);
        ucs.selectByAdviserCode(adviserCode);
        ucs.selectUserById(tstUser.Id);
    }
}