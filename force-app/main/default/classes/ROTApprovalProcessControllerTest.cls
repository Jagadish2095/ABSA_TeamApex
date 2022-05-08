/**
* Descripton: Test class for the ROTApprovalProcessController
* Class Name: ROTApprovalProcessControllerTest
* @author  	: Manish
*/
@isTest
public class ROTApprovalProcessControllerTest {

    @testSetup static void setup() {
        Account testAccount;
        Case newCase;
            
            // Create common test account
            testAccount = new Account(CIF__c = 'I001',
                                      Client_Type__c = 'PRIVATE INDIVIDUAL',
                                      LastName = 'Test Account',
                                      PersonEmail = 'test@test.com',
                                      PersonMobilePhone = '0123456789'
                                     );
            
            insert testAccount;
            
            Product2 prod = new Product2();
            prod.name ='test prod';
            insert prod;
            
            // Create common test Case
            Map<String, Schema.RecordTypeInfo> caseRecordTypeMap = Case.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
            System.debug('caseRecordTypeMap '+caseRecordTypeMap);
            newCase = new Case(Communication_Method__c = 'Email',
                               Status = 'New',
                               Origin = 'Email', 
                               AccountId = testAccount.Id,
                               Risk_Management_Centre__c = 'Digital Fraud',
                               Email__c = 'test@test.com',
                               Subject = 'test',
                               Description = 'test',
                               Expectation_of_the_Customer__c = 'test',
                               Incident_Date__c = date.today(),
                               Product_Search__c= prod.Id,
                               ROT_Approval_Status__c = 'Submitted',
                               ROT_Approval_Stage__c = 'Leg 1',
                               Type__c = 'Create New Restriction Groups',
                               recordTypeId = caseRecordTypeMap.get('Service_Request').getRecordTypeId());
            insert newCase;
    }
    
    @isTest
    private static void submitROTApprovalProcess() {
        System.Test.startTest();
        Case caseRecord = [SELECT Id,ROT_Approval_Status__c,ROT_Approval_Stage__c FROM Case WHERE Subject='test' LIMIT 1];
        
        RestrictionGroup__c currentRestriction = new RestrictionGroup__c();
        currentRestriction.Status__c = 'Added';
        currentRestriction.GroupID__c = 'Test';
        currentRestriction.Case__c = caseRecord.Id;
        currentRestriction.Restriction_ID__c ='Test';
        insert currentRestriction;
        
        try{
            ROTApprovalProcessController.validateRequest(caseRecord.Id);
            ROTApprovalProcessController.submitROTApprovalProcess(caseRecord.Id, caseRecord);
            
            
            IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ROTMoveToProduction_IH_v1.INTEGRATION_SERVICE_NAME});
            caseRecord.ROT_Approval_Status__c = 'Leg2 Approved';
            update caseRecord;
        }
        catch(Exception e){
            System.debug('error '+e.getMessage());
        }
        System.Test.stopTest();
    }
}