/*
 * Cheque Update Holds controller test
 * @author André Pietersen
 * @created 2021-02-09
 */

@isTest
public class BranchUpdAcctHoldsControllerTest {
    public static final String POSITIVE_RESPONSE_BODY = '{"NBSAPDPO":{"outputHeader":{"NBNAPLO_ECHO_KEY":"","NBNAPLO_REASON_CODE":0,"NBNAPLO_RETURN_CODE":0,"NBNAPLO_VERSION":"","NBNAPLO_SERVICE_VERSION":"BUSO004"}},"CQS525O":{"outputCopybook":{"CQN525O_ACCOUNT_NBR_OUT":0,"CQN525O_CONFIRMATION_DETAILS":[{"CQN525O_DETAILS":""},{"CQN525O_DETAILS":""},{"CQN525O_DETAILS":""},{"CQN525O_DETAILS":""},{"CQN525O_DETAILS":""},{"CQN525O_DETAILS":""},{"CQN525O_DETAILS":""},{"CQN525O_DETAILS":""},{"CQN525O_DETAILS":""},{"CQN525O_DETAILS":""},{"CQN525O_DETAILS":""},{"CQN525O_DETAILS":""},{"CQN525O_DETAILS":""},{"CQN525O_DETAILS":""},{"CQN525O_DETAILS":""},{"CQN525O_DETAILS":""},{"CQN525O_DETAILS":""},{"CQN525O_DETAILS":""},{"CQN525O_DETAILS":""},{"CQN525O_DETAILS":""},{"CQN525O_DETAILS":""},{"CQN525O_DETAILS":""},{"CQN525O_DETAILS":""}]}},"NBSMSGO3":{"outputErrorMessage":{"NBNMSGO3_NBR_USER_ERRS":1,"NBSMSGO3_VERSION":"","NBNMSGO3_SYS_ERR_TXT":"","NBNMSGO3_NBR_USER_MSGS":1,"NBNMSGO3_MSG_ENTRY":[{"NBNMSGO3_MSG_ERR_IND":"E","NBNMSGO3_MSG_TXT":"Data has not been changed - please enter changes.","NBNMSGO3_MSG_CLASS":"CQSMGC01","NBNMSGO3_MSG_CODE":"0012"},{"NBNMSGO3_MSG_ERR_IND":"","NBNMSGO3_MSG_TXT":"","NBNMSGO3_MSG_CLASS":"","NBNMSGO3_MSG_CODE":""},{"NBNMSGO3_MSG_ERR_IND":"","NBNMSGO3_MSG_TXT":"","NBNMSGO3_MSG_CLASS":"","NBNMSGO3_MSG_CODE":""},{"NBNMSGO3_MSG_ERR_IND":"","NBNMSGO3_MSG_TXT":"","NBNMSGO3_MSG_CLASS":"","NBNMSGO3_MSG_CODE":""},{"NBNMSGO3_MSG_ERR_IND":"","NBNMSGO3_MSG_TXT":"","NBNMSGO3_MSG_CLASS":"","NBNMSGO3_MSG_CODE":""}]}}}';

    @testSetup
    static void makeData(){ 
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{CQupdAcctHoldsV5_IH_v1.INTEGRATION_SERVICE_NAME});
        
        Product2 prod = new Product2(Name = 'Cheque Product', Family = 'Cheque',ProductCode='11021');
        insert prod;      
         
        Pricebook2 pb = new Pricebook2();
        pb.IsActive=true;
        pb.id =test.getStandardPricebookId();
        update pb;
              
        PricebookEntry customPrice = new PricebookEntry(Pricebook2Id = pb.Id, Product2Id = prod.Id, UnitPrice = 12000, IsActive = true);
        insert customPrice;
        
        Account account = new Account();
        account.ID_Number__pc = '9308305015082';
        account.FirstName = 'TestCVSServicesHelper';
        account.LastName = 'Tester';
        account.Gender__pc = 'Male';
        account.Next_of_Kin_Last_Name__pc = 'Testing';
        account.Next_of_Kin_First_Name_s__pc = 'Testing';
        
        account.CIF__c='LTD 933';
        account.Language__c='english';
        account.Number_Of_Dependents__c=0;
        account.PersonEmail='test@absa.africa';
        account.PersonMobilePhone='0819908786';
        account.ID_Type__pc='PASSPORT';
        account.Nationality__pc='ZIM';
        account.Highest_Qualification__pc='Matric';
        account.Residential_Status__pc='Owner';
        account.Marital_Status__pc='MARRIED';
        account.CASA_Risk_Status__c = 'High';
        insert account;
       
        site__c siteRec=new site__c();
        siteRec.Site_Code__c='1334';
        siteRec.Name='Test';
        insert siteRec;        
   
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Opp Onboarding';
        opp.CloseDate = Date.today();
        opp.StageName = 'New';
        opp.Pricebook2Id=pb.id;
        opp.AccountId=account.id;
        opp.Site__c=siteRec.id;
        opp.CBPIndicator__c = '123456789';
        insert opp;
       
        OpportunityLineItem oppLineItem = new OpportunityLineItem();
        oppLineItem.OpportunityId = opp.id;
        oppLineItem.Product2Id = prod.id;
        oppLineItem.PricebookEntryId = customPrice.id;
        oppLineItem.Quantity = 1;
        oppLineItem.TotalPrice = 100;
        oppLineItem.Policy_Number__c='4048272164';
        insert oppLineItem;
    }

    static testMethod void updateAccountHolds() {
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
        
		Test.startTest();
        Opportunity opp = [SELECT Id FROM Opportunity WHERE Name = 'Test Opp Onboarding'];  
        BranchUpdAcctHoldsController.setOpportunityDetails(opp.Id);
        BranchUpdAcctHoldsController.updateAccountHolds(opp.Id);
               
        Test.stopTest();    
   	}
}