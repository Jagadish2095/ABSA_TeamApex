/**
 * @description documentStubControllerTest Description
 *
 */
@IsTest
public with sharing class documentStubControllerTest {
    @TestSetup
    static void makeData() {
        Date todaysDate = System.today();
        Account acc = new Account(Name = 'Test New Bus Client', Client_Type__C = 'Private Company');
        insert acc;
        Map<String, Schema.RecordTypeInfo> opportunityRecordTypeMap = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
        User userRec = new UsersSelector().selectById(UserInfo.getUserId());
        List<Site__c> sitecodes;
        if (userRec.SiteCode__c != null){
            sitecodes = new SitesSelector().selectBySiteCode(userRec.SiteCode__c);
        } else{
            sitecodes = new List<Site__c>();
        }

                    //Get Standard Pricebook Id
        PriceBook2 priceBookItem  = new Pricebook2(Name = 'Standard Price Book 2009', Description = 'Price Book 2009 Products', IsActive = true);
        insert priceBookItem;

        Opportunity cpfOpp = new Opportunity();
        cpfOpp.Name = 'CPF Onboarding';
        cpfOpp.RecordTypeId = opportunityRecordTypeMap.get('Merchant_Onboarding').getRecordTypeId();
        cpfOpp.AccountId = acc.id;
        cpfOpp.StageName = 'Confirm Client Eligibility';
        cpfOpp.closeDate = todaysDate.addDays(7);
        cpfOpp.priceBook2Id = priceBookItem.id;

        //Capturing Sitecode of loggedin User while creating opportunity if user has site code
        if (!sitecodes.isEmpty()){
            cpfOpp.Site__c = sitecodes[0].Id;
        }

        insert cpfOpp;
    }

    @isTest
    public static void testupdateOppFormStatus() {
        Opportunity cpfOpp = [Select id, Name from Opportunity where Name = 'CPF Onboarding'];
        test.startTest();
        documentStubController.generateDoc(cpfOpp.Id, 'ABSA 6171 EX - Commercial Property Finance Loan');
        documentStubController.generateDoc(cpfOpp.Id, 'ABSA 6157 EX - OD Facility Letter');
        System.assertNotEquals(null,documentStubController.generateDoc(cpfOpp.Id, 'Credit Onboarding Quote'),'not null');
        test.stopTest();
    }
}