/**@description HL_clientAttestation test class
* @comment : getAccount
* @author  Prasanth B
* @since 2021-05-20
* **/ 
@isTest
public class HL_clientAttestation_test {
    
    @testSetup static void testDataSetup() {
        //String recordTypeId  = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Individual Prospect').getRecordTypeId();
        list<Account> testAccount=TestDataFactory.getPersonAccounts('TestLastName','Individual_Prospect', 1);
        testAccount[0].Occupation_Status__pc = 'Part Time Employed';
        testAccount[0].Occupation_Category__pc = 'Other';
        testAccount[0].ShippingCountry = 'South Africa';
        testAccount[0].ID_Number__pc = '7401017341085';
        testAccount[0].CIF__c = 'SAMSOJ 537';
        insert testAccount;
        String caserecordTypeId  = Schema.SObjectType.case.getRecordTypeInfosByName().get('Home Loans').getRecordTypeId();        
        list<case> testcase=TestDataFactory.getCases('FIC_Case',1);        
        testcase[0].RecordtypeId=caserecordTypeId;
        testcase[0].Incident_Date__c=system.Today().addDays(-1);
        testcase[0].AccountId=testAccount[0].id;        
        insert testcase;
    }
    @isTest
    public  static  void initclientAttestationTest(){
        Account acc=[Select id,LastName, RecordType.name from Account limit 1];        
        System.assertEquals('Individual Prospect', acc.RecordType.name, false);
        Test.startTest();
        HL_clientAttestation.initClientAttestation(acc.id, '3',new List<String>{'id'});         
        Test.stopTest();
    }
    
    @isTest
    public  static  void getaccounttest(){
        Account acc=[Select id,LastName, RecordType.name from Account limit 1];        
        System.assertEquals('Individual Prospect', acc.RecordType.name, false);
        
        Test.startTest();
        HL_clientAttestation.getAccount(acc.id);
        Test.stopTest();
    }
    @isTest
    public  static  void updateStagetest(){
        Account acc=[Select id,LastName, RecordType.name from Account limit 1];
        System.assertEquals('Individual Prospect', acc.RecordType.name, false);
        
        Test.startTest();
        HL_clientAttestation ca=new HL_clientAttestation();
        ca.accountRecord=acc;
        ca.daysdue='2';
        ca.missingDocumentsString='id';
        ca.missingDocumentsString='id';
        HL_clientAttestation.updateStage('Perform Attestation',ca,'NonCompliant');
        Test.stopTest();
    }
    
    @isTest
    public  static  void casecreationtest(){        
        Account acc=[Select id,LastName,PersonContactId,PersonContact.Email,Stage__c,RecordType.name from Account limit 1];
        System.assertEquals('Individual Prospect', acc.RecordType.name, false);
        
        Test.startTest();
        HL_clientAttestation ca=new HL_clientAttestation();
        ca.accountRecord=acc;
        ca.daysdue='2';
        ca.missingDocumentsString='id';
        HL_clientAttestation.casecreation('test@gf.com',ca,'TELEPHONIC','');
        HL_clientAttestation.casecreation('test@gf.com',ca,'EMAIL','');
        HL_clientAttestation.missingDocsList(new List<String>{'ProofOfId'});
        Test.stopTest();
    }   
    @isTest
    public  static  void updateCIFservice(){ 
        
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new list<String> {'updateCIF'});
        Test.setMock(HttpCalloutMock.class, new getUpdateCIFMock_APIRest(StringConstants.POSITIVE_STRING));

        Account acc=[Select id,LastName,PersonContactId,Occupation_Status__pc,Occupation_Category__pc,PersonContact.Email,Stage__c,RecordType.name from Account limit 1];
        
        Integration_Translation__c translation10 = new Integration_Translation__c();
        translation10.Name = 'Other';
        translation10.External_Value__c = '10';
        translation10.Internal_Value__c = 'Other';
        translation10.System_Name__c = 'CIF';
        translation10.Value_Type__c = 'Occupation Category';
        translation10.Direction__c = 'Outbound';
        insert translation10;
          
        Integration_Translation__c translation11 = new Integration_Translation__c();
        translation11.Name = 'Part Time Employed';
        translation11.External_Value__c = '8';
        translation11.Internal_Value__c = 'Part Time Employed';
        translation11.System_Name__c = 'CIF';
        translation11.Value_Type__c = 'Occupation Status';
        translation11.Direction__c = 'Outbound';
        insert translation11;


        Integration_Translation__c translation12 = new Integration_Translation__c();
        translation12.Name = 'South Africa';
        translation12.External_Value__c = 'SO003';
        translation12.Internal_Value__c = 'South Africa';
        translation12.System_Name__c = 'CIF';
        translation12.Value_Type__c = 'Country';
        translation12.Direction__c = 'Outbound';
        insert translation12;

        System.assertEquals('Individual Prospect', acc.RecordType.name, false);
        
        Test.startTest();
        HL_clientAttestation.updateClientAttenstation(acc.id ,'' );
        Test.stopTest();
    }           
}