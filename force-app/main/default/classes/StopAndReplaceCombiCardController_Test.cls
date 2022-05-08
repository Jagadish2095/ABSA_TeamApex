@isTest
public class StopAndReplaceCombiCardController_Test {

    
    @testSetup
    static void dataCreation(){
        Account account = new Account(Name = 'Test Account');
        insert account;
        
        Contact contact = new Contact(LastName='Test contact', AccountId = account.Id, Email = 'agents@support.co.za');
        insert contact;
    }
    
   @isTest 
    public static void testCIGetAccount(){
        List<Account> accountList = TestDataFactory.getPersonAccounts('lastName', 'Individual_Client', 1);
        accountList[0].LastName = 'SKOSANA';
        accountList[0].ID_Type__pc ='SA Identity Document';
        accountList[0].ID_Number__pc='8505225522085';
        accountList[0].CIF__c='ARENTAL001';
        insert accountList;
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CIgetAcctLinkedToClientCodeMock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.CI_GET_ACCT_LINKED_TO_CLIENT_CODE});
        
        Test.startTest();
        String responseBean = StopAndReplaceCombiCardController.getAccountDetails(accountList[0].Id);
        system.assertNotEquals(null, responseBean, 'Assert Failed');
        Test.stopTest();
    }
    @isTest 
    public static void testclose(){
        
        Test.setMock(HttpCalloutMock.class, new CCcloseV2Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.CCCLOSE});

       
        Test.startTest();
        String closeCombicard = StopAndReplaceCombiCardController.closeCombicard('4451430000040415', 'CUSREQ','PORSRV');
        system.assertNotEquals(null, closeCombicard, 'Assert Failed');
        Test.stopTest();

    }

    
   
    @isTest 
    public static void testIssue(){

        Test.setMock(HttpCalloutMock.class, new CCissueCombiCard_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {CCissueCombiCard_IH_v1.INTEGRATION_SERVICE_NAME});

       
        Test.startTest();  
        String issueCombiCard = StopAndReplaceCombiCardController.issueCombiCard('00000004053443100', '8013', 'N', '1565', 'N', '', '', '', '', '8013', 'H', 'BBBBDO 008', '00000004053443100', '0', '04938050012744758','04938050012744758');
        system.assertNotEquals(null, issueCombiCard, 'Assert Failed');
        Test.stopTest();

    }
    
   @isTest 
    public static void testPortfolio(){

        Test.setMock(HttpCalloutMock.class, new CCGetPortfolioDetailV1_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.CC_GET_PORTFOLIO_DETAIL_V1});

       
        Test.startTest();  
        String getPortfolioDetails = StopAndReplaceCombiCardController.getPortfolioDetails('04483850000155586');
        system.assertEquals(null, getPortfolioDetails, 'Assert Failed');
        Test.stopTest();

    } 
    @isTest 
    public static void testpersonDetail(){
       
        List<Account> accountList = TestDataFactory.getPersonAccounts('lastName', 'Individual_Client', 1);
        accountList[0].LastName = 'SKOSANA';
        accountList[0].ID_Type__pc ='SA Identity Document';
        accountList[0].ID_Number__pc='8505225522085';
        accountList[0].CIF__c='ARENTAL001';
        insert accountList;
        
        Test.startTest();  
        String personDetails =  StopAndReplaceCombiCardController.personDetails(accountList[0].Id);
        system.assertNotEquals(null, personDetails, 'Assert Failed');
        Test.stopTest();

    } 
    
    
}