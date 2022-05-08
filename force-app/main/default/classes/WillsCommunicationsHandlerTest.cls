@isTest
public class WillsCommunicationsHandlerTest {
    
    @isTest
    private static void testselectCasaFieldsByPersonContactSetId() {        
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();    
        Account tstAccount = testDataFactory.testAccount;
        Set<Id> personContactIdSet = new Set<Id>();
        Set<Id> accId = new Set<Id>();
        personContactIdSet.add(testDataFactory.testAccount.PersonContactId);
        accId.add(testDataFactory.testAccount.Id);
        AccountsSelector acs = new AccountsSelector();
        List<Account> accs1 = acs.selectCasaFieldsByPersonContactSetId(personContactIdSet) ;
        List<Account> accs2 = acs.selectCasaFieldsBySetId(accId);
        System.debug('Language : '+testDataFactory.testAccount.Communication_Language__pc);
        System.debug('Comm type : '+testDataFactory.testApplication.Preferred_Communication_Method__c);
        tstAccount = acs.selectByOpportunityId(testDataFactory.testOpportunity.Id);
    }
    
    @isTest
    public static void testWillsCommunicationsHandlerAfrEmail() {
        WimiTestDataFactory testDataFactorya = new WimiTestDataFactory();
        WillsCommunicationsHandler.sendWillRegisteredCommunication(testDataFactorya.testOpportunity.id);
    }
    
    @isTest
    public static void testWillsCommunicationsHandlerAfrSMS() {        
        WillsTestDataFactory testDataFactoryb = new WillsTestDataFactory();       
        WillsCommunicationsHandler.sendWillRegisteredCommunication(testDataFactoryb.testOpportunityAfrSMS.id);
    }
    
    @isTest
    public static void testWillsCommunicationsHandlerEngEmail() {        
        WillsTestDataFactory testDataFactoryc = new WillsTestDataFactory();       
        WillsCommunicationsHandler.sendWillRegisteredCommunication(testDataFactoryc.testOpportunityEngEmail.id);
    }
    
    @isTest
    public static void testWillsCommunicationsHandlerEngSMS() {
        WillsTestDataFactory testDataFactoryd = new WillsTestDataFactory();
        WillsCommunicationsHandler.sendWillRegisteredCommunication(testDataFactoryd.testOpportunityEngSMS.id);
    }
}