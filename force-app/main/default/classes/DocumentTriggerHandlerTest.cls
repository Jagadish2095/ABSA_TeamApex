/**
* Test Class for Classification
* @description       : Document trigger handler Test Class
* @author            : Sandeep Ch
* @since             : 08/03/2021
*
**/
@isTest
public class DocumentTriggerHandlerTest { 
    /**
     * @description : Test Method.
 
     **/    
	@isTest
    public static void documentTriggerhandlerTestMethod1() {
        WimiTestDataFactory testDataFactorydoc = new WimiTestDataFactory();
        Document__c appDoc = testDataFactorydoc.testApplicationFormDocument;
        
         String caserecordTypeId  = Schema.SObjectType.case.getRecordTypeInfosByName().get('FIC Case').getRecordTypeId();
        List<Account> accountList = TestDataFactory.getPersonAccounts('lastName', 'Individual_Client', 1);
        accountList[0].LastName = 'ABSA TEST';
        accountList[0].ID_Type__pc ='SA Identity Document';
        accountList[0].ID_Number__pc='6211275132089';
        accountList[0].AccountNumber ='6211275132089';
        accountList[0].Country_of_Citizenship__c =  'South Africa';
        accountList[0].PersonBirthdate = Date.valueOf('1962-11-27');
        accountList[0].Gender__pc = 'Male';
        insert accountList;
        list<case> testcase=TestDataFactory.getCases('FIC_Case',1);        
        testcase[0].RecordtypeId=caserecordTypeId;
        testcase[0].AccountId=accountList[0].id;
        testcase[0].External_Reference_Number__c = 'abcde'+system.now();
        insert testcase[0];
        system.debug('testcase[0]>>'+testcase[0].RecordtypeId);
        Document__c doc1 = new Document__c();
        doc1.Name = 'test1';
        doc1.ConfidenceLevel__c = 'low';
        doc1.Case_External_Reference__c = testcase[0].External_Reference_Number__c;
        doc1.Reference__c = '123456abcd'+system.now();
        insert doc1;
        
        System.assertequals(doc1.id!= null,true);
        
    }
}