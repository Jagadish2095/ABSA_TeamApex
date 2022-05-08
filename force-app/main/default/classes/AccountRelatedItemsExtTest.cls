/**
 * Test Class for AccountRelatedItemsExt
 * @author  Koketso Mpshane
 * @date    09/04/2020
 */
@isTest
public class AccountRelatedItemsExtTest {
    @isTest
    static void testAutoConvertClosedLead() {
        Account acc = new Account(Name = 'testAccount');
        insert acc;

        Financial_Product__c testFinancialProduct = new Financial_Product__c(Name = 'Test', Product_Type__c = '', Business_Unit__c = 'Business Banking');
        insert testFinancialProduct;

        RecordType retailRecordType = [SELECT Id, DeveloperName FROM RecordType WHERE SObjectType = 'Lead' AND DeveloperName = 'Retail_Sales_Lead'];

        Lead leadRecord = new Lead();
        leadRecord.FirstName = 'Test';
        leadRecord.LastName = 'Lead';
        leadRecord.Status = 'Unallocated';
        leadRecord.Hot_Deal__c = false;
        leadRecord.RecordTypeId = retailRecordType.Id;
        leadRecord.FinServ__RelatedAccount__c = acc.Id;
        leadRecord.Bypass_Validation_Rules__c = true;
        leadRecord.Product_Interest_1__c = testFinancialProduct.Id;
        insert leadRecord;

        Map<String, Schema.RecordTypeInfo> caseRecordTypeMap = Case.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
        Case caseRec = new Case();
        caseRec.Communication_Method__c = 'Email';
        caseRec.Status = 'New';
        caseRec.Origin = 'Email';
        caseRec.AccountId = acc.Id;
        caseRec.Email__c = 'test@test.com';
        caseRec.RecordTypeId = caseRecordTypeMap.get('Complaint').getRecordTypeId();
        caseRec.Subject = 'normal case';
        caseRec.Description = 'test';
        caseRec.Expectation_of_the_Customer__c = 'test';
        caseRec.Incident_Date__c = date.today().addDays(-1);
        insert caseRec;

        Test.startTest();
        AccountRelatedItemsExt.fetchClientCases(leadRecord.FinServ__RelatedAccount__c);
        Test.stopTest();
    }
}