/**@description AIC_CaseUpdateCISResponse Test Class
* @comment : caseUpdateOnCisResp
* @author  Anu Dhaka
* @since 2021-09-28
* **/
@isTest
public class AIC_CaseUpdateCISResponse_Test {
    
    @testSetup static void testDataSetup() {
        List<Account> accountList = TestDataFactory.getPersonAccounts('lastName', 'Individual_Client', 1);
        accountList[0].LastName = 'ABSA TEST';
        accountList[0].ID_Type__pc ='SA Identity Document';
        accountList[0].ID_Number__pc='6211275132089';
        accountList[0].AccountNumber ='6211275132089';
        accountList[0].Country_of_Citizenship__c =  'South Africa';
        accountList[0].PersonBirthdate = Date.valueOf('1962-11-27');
        accountList[0].Gender__pc = 'Male';
        insert accountList; 
        
        String caserecordTypeId  = Schema.SObjectType.case.getRecordTypeInfosByName().get('FIC Case').getRecordTypeId();
        list<case> testcaselist=TestDataFactory.getCases('FIC_Case',2);
        testcaselist[0].RecordtypeId=caserecordTypeId;
        testcaselist[0].AccountId=accountList[0].id;
        testcaselist[0].Type__c = null;
        testcaselist[0].Incident_Date__c=system.Today().addDays(-1);
        testcaselist[1].RecordtypeId=caserecordTypeId;
        testcaselist[1].AccountId=accountList[0].id;
        testcaselist[1].Incident_Date__c=system.Today().addDays(-1);
        testcaselist[1].Type__c = null;
        
        insert testcaselist;
        testcaselist[1].ParentId=testcaselist[0].id;
        update testcaselist;
    }
    @isTest
    public  static void caseupdateonCisHighTest(){
        case caseRec=[SELECT ID FROM CASE WHERE ParentId!=NULL LIMIT 1];
        Document__c doc1 = new Document__c();
        doc1.Case__c = caseRec.Id;
        doc1.Reference__c = 'Test';
        doc1.ConfidenceLevel__c = 'Low';
        insert doc1;
        Document__c doc2 = new Document__c();
        doc2.Case__c = caseRec.Id;
        doc2.Reference__c = 'Test';
        doc2.ConfidenceLevel__c = 'High';
        insert doc2;
        
        Test.startTest();
            AIC_CaseUpdateCISResponse.caseUpdateOnCisResp(caseRec.Id,'High'); 
        Test.stopTest();
        List<case> caseRecAfterUpdate=[SELECT ID,status FROM CASE Where ParentId!=NULL LIMIT 1];
        System.assertEquals(caseRecAfterUpdate.size()>0, true);
    }
    @isTest
    public  static void caseupdateonCisLowTest(){
        case caseRec=[SELECT ID FROM CASE Where ParentId!=NULL LIMIT 1];
        Test.startTest();
            AIC_CaseUpdateCISResponse.caseUpdateOnCisResp(caseRec.id,'Low');
        Test.stopTest();
        List<case> caseRecAfterUpdate=[SELECT ID,status FROM CASE Where ParentId!=NULL LIMIT 1];
        System.assertEquals(caseRecAfterUpdate.size()>0, true);
    }
    @isTest
    public  static void caseupdateonCisUnknownTest(){
        case caseRec=[SELECT ID FROM CASE Where ParentId!=NULL LIMIT 1];
        Test.startTest();            
            AIC_CaseUpdateCISResponse.caseUpdateOnCisResp(caseRec.id,'Unknown');
        Test.stopTest();
        List<case> caseRecAfterUpdate=[SELECT ID,status FROM CASE Where ParentId!=NULL LIMIT 1];
        System.assertEquals(caseRecAfterUpdate.size()>0, true);
    }
}