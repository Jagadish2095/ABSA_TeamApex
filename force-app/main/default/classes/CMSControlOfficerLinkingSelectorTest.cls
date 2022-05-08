/**
*@description this is test class used for CMSControlOfficerLinkingSelector
*Apex Class CMSControlOfficerLinkingSelectorTest
* @author  Anka Ganta : Absa
* @version v1.0
* @since   2020-01-31
*
*/
@isTest
public class CMSControlOfficerLinkingSelectorTest {
    
    /** 
    * @description get all the cms records
    */
    @isTest
    static void displayContrOffcRecsTest(){
        
        Account account = new Account();
        account.Name = 'Test Account';
        insert account;
        
        Opportunity testOpp = new Opportunity();
        testOpp.Name = 'Test Opp Onboarding';
        testOpp.CloseDate = Date.today();
        testOpp.StageName = 'New';
        insert testOpp;
        System.debug('testOpp1+++'+testOpp);
        CMS_Control_Officer_Linking__c cmsRec = new CMS_Control_Officer_Linking__c();
        cmsRec.Control_Officer_Type__c='SBBM – ENTERPRISE EB / INSTANT BUSINESS';
        cmsRec.Control_Officer_Number__c='1';
        //cmsRec.Employee_Number__c='';
        cmsRec.Branch_Region_Site__c='8198';
        cmsRec.Group_or_Individual__c='Individual';
        cmsRec.Overall_Site_Code__c='25698';               
        cmsRec.Business_Segment_Indicator__c='LARGE BUSINESS';
        cmsRec.Business_Sub_Segment_Indicator__c='BUSINESS SECTOR';
        cmsRec.Banking_Sector__c='Business Banking Service';
        cmsRec.Franchise_Sector__c='AC KENTUCKY FRIED CHICKEN KFC';
        //cmsRec.Approved_by_Employee__c='9091968';
        cmsRec.Captured_by_Employee__c='0939943';
        insert cmsRec;
        cmsRec.Opportunity__c = testOpp.Id;
        System.debug('testOpp2+++'+testOpp);
        
        CMS_Control_Officer_Linking__c cmsRec1 = new CMS_Control_Officer_Linking__c();
        cmsRec1.Control_Officer_Type__c='SBBM – ENTERPRISE EB / INSTANT BUSINESS';
        cmsRec1.Control_Officer_Number__c='1';
        //cmsRec.Employee_Number__c='';
        cmsRec1.Branch_Region_Site__c='8198';
        cmsRec1.Group_or_Individual__c='Individual';
        cmsRec1.Overall_Site_Code__c='25698';               
        cmsRec1.Business_Segment_Indicator__c='LARGE BUSINESS';
        cmsRec1.Business_Sub_Segment_Indicator__c='BUSINESS SECTOR';
        cmsRec1.Banking_Sector__c='Business Banking Service';
        cmsRec1.Franchise_Sector__c='AC KENTUCKY FRIED CHICKEN KFC';
        //cmsRec.Approved_by_Employee__c='9091968';
        cmsRec1.Captured_by_Employee__c='0939943';
        
       
       List<CMS_Control_Officer_Linking__c> cmsRecList = new List<CMS_Control_Officer_Linking__c>();
       Set<String> recSet = new Set<String>();
       //delrecList.add(cmsRec.id);
       cmsRecList.add(cmsRec);
       recSet.add(cmsRec.id);
        Test.startTest();
        if(testOpp != null){
            CMSControlOfficerLinkingSelector cmsSelector = new CMSControlOfficerLinkingSelector();
             List<CMS_Control_Officer_Linking__c> ConformationOfBanker = cmsSelector.CMSRecsRelatedToOpp(testOpp.id);
             List<CMS_Control_Officer_Linking__c> ConformationOfBankerList = cmsSelector.selectByIds(recSet);             
          
        }
       
        System.assertNotEquals(null, testOpp.id);
        
        Test.stopTest();
    }

    /**
    *  @description : linkBankersSelectedTest
    */
    @isTest
    static void linkBankersSelectedTest(){
        
        GBcreateCmsContOffLinkV1_Req_IB_v1 dummyBeanParent = GBcreateCmsContOffLinkV1_Req_IB_v1.createDummyRequest();
        GBcreateCmsContOffLinkV1_Req_IB_v1.Gsp020i dummyBean = dummyBeanParent.GBcreateCmsContOffLinkV1.Gsp020i;
        
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new GBcreateCmsContOffLinkV1_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, new list < String > {
            StringConstants.GB_CREATE_CMS_CONTOFFLINK_V1
        });
        

          Account account = new Account();
        account.Name = 'Test Account';
        insert account;
        
        Opportunity testOpp = new Opportunity();
        testOpp.Name = 'Test Opp Onboarding';
        testOpp.CloseDate = Date.today();
        testOpp.StageName = 'New';
        testOpp.AccountId = account.Id;
        insert testOpp;
        System.debug('testOpp1+++'+testOpp);
        CMS_Control_Officer_Linking__c cmsRec = new CMS_Control_Officer_Linking__c();
        cmsRec.Control_Officer_Type__c='SBBM – ENTERPRISE EB / INSTANT BUSINESS';
        cmsRec.Control_Officer_Number__c='1';
        //cmsRec.Employee_Number__c='';
        cmsRec.Branch_Region_Site__c='8198';
        cmsRec.Group_or_Individual__c='Individual';
        cmsRec.Overall_Site_Code__c='25698';               
        cmsRec.Business_Segment_Indicator__c='LARGE BUSINESS';
        cmsRec.Business_Sub_Segment_Indicator__c='BUSINESS SECTOR';
        cmsRec.Banking_Sector__c='Business Banking Service';
        cmsRec.Franchise_Sector__c='AC KENTUCKY FRIED CHICKEN KFC';
        //cmsRec.Approved_by_Employee__c='9091968';
        cmsRec.Captured_by_Employee__c='0939943';
        insert cmsRec;
        cmsRec.Opportunity__c = testOpp.Id;
        System.debug('testOpp2+++'+testOpp);
       List<String> cmsRecList = new List<String>();
       cmsRecList.add(cmsRec.Id);
        
        Test.startTest();
        
        
        CMSControlOfficerLinkingController.linkBankersSelected(testOpp.id,cmsRecList);
        System.assertNotEquals(null, testOpp.id);
        
        Test.stopTest();
    }
    
    /** 
    * @description get all the cms records linked
    */
    @isTest
    static void linkBankersSelectedNegativeTest(){
        
        GBcreateCmsContOffLinkV1_Req_IB_v1 dummyBeanParent = GBcreateCmsContOffLinkV1_Req_IB_v1.createDummyRequest();
        GBcreateCmsContOffLinkV1_Req_IB_v1.Gsp020i dummyBean = dummyBeanParent.GBcreateCmsContOffLinkV1.Gsp020i;
        
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new GBcreateCmsContOffLinkV1_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, new list < String > {
            StringConstants.GB_CREATE_CMS_CONTOFFLINK_V1
        });
        

          Account account = new Account();
        account.Name = 'Test Account';
        insert account;
        
        Opportunity testOpp = new Opportunity();
        testOpp.Name = 'Test Opp Onboarding';
        testOpp.CloseDate = Date.today();
        testOpp.StageName = 'New';
        testOpp.AccountId = account.Id;
        insert testOpp;
        System.debug('testOpp1+++'+testOpp);
        CMS_Control_Officer_Linking__c cmsRec = new CMS_Control_Officer_Linking__c();
        cmsRec.Control_Officer_Type__c='SBBM – ENTERPRISE EB / INSTANT BUSINESS';
        cmsRec.Control_Officer_Number__c='1';
        //cmsRec.Employee_Number__c='';
        cmsRec.Branch_Region_Site__c='';
        cmsRec.Group_or_Individual__c='';
        cmsRec.Overall_Site_Code__c='';               
        cmsRec.Business_Segment_Indicator__c='';
        cmsRec.Business_Sub_Segment_Indicator__c='';
        cmsRec.Banking_Sector__c='';
        cmsRec.Franchise_Sector__c='';
        //cmsRec.Approved_by_Employee__c='9091968';
        cmsRec.Captured_by_Employee__c='0939943';
        insert cmsRec;
        cmsRec.Opportunity__c = testOpp.Id;
        System.debug('testOpp2+++'+testOpp);
       List<String> cmsRecList = new List<String>();
       cmsRecList.add(cmsRec.Id);
        
        Test.startTest();
        
        
        CMSControlOfficerLinkingController.linkBankersSelected(testOpp.id,cmsRecList);
        System.assertNotEquals(null, testOpp.id);
        
        Test.stopTest();
    }

}