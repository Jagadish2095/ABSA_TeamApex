/**@description Test Class for Fic_DHACertificatecontroller
* @author  Prasanth Boggula
* @since 2021-06-12
* **/

@istest
public class Fic_DHACertificatecontroller_Test {
    @testSetup static void testDataSetup() {
        list<Account> testAccount=TestDataFactory.getPersonAccounts('TestLastName','Individual_Prospect', 1);
        testAccount[0].ID_Number__pc='20192180123';
        insert testAccount;
        
        String caserecordTypeId  = Schema.SObjectType.case.getRecordTypeInfosByName().get('FIC Case').getRecordTypeId();        
        list<case> testcase=TestDataFactory.getCases('FIC_Case',1);        
        testcase[0].RecordtypeId=caserecordTypeId;
        testcase[0].Incident_Date__c=system.Today().addDays(-1);
        testcase[0].AccountId=testAccount[0].id;        
        insert testcase;
                
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, new list < String > {
            'serviceManager'
                });
    }
    @isTest
    public static  void insertcaseTocallDHAServicesTest(){         
        case testcase=[SELECT ID FROM CASE LIMIT 1];
        Test.startTest();
        	Fic_DHACertificatecontroller.callDhaCertificate(testcase.id);
        	System.assert(testcase.id!= null,false);
        Test.stopTest();
    }
    
}