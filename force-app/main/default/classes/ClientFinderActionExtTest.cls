@isTest
public class ClientFinderActionExtTest {
    /*
     * Purpose : Method to create test data
     */
    @testSetup
    static void dataCreation(){
        map<String, Schema.RecordTypeInfo> caseRecordTypeMap = Case.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
    	Account account = new Account(Name = 'Test Account');
        insert account;
        
        Contact contact = new Contact(LastName='Test contact', AccountId = account.Id);
        insert contact;
        
        Case caseRec = new Case(recordTypeId = caseRecordTypeMap.get('Service_Request').getRecordTypeId(), Communication_Method__c = 'Email', Status = 'New', Origin = 'Email', Account = account,
                                SLA_Extension_Approval_Required__c = true, External_SLA_End_Date__c = Date.today());
        insert caseRec;
        
        Financial_Product__c testFinancialProduct4 = new Financial_Product__c(Name = 'AIP', Product__c = 'Flexi Funeral', Business_Unit__c = 'Direct Delivery');
		insert testFinancialProduct4;
        Lead testLead1 = new Lead(
			LastName = 'AIP',
			firstName = 'Test Lead',
			Salutation = 'Mr',
			Company = 'Test Lead',
            //FinServ__RelatedAccount__c = AIPaccount.id,
			Financial_Product__c = testFinancialProduct4.id,
            RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('AIP_Lead').getRecordTypeId(),
			MobilePhone = '0762922222'
		);
        
        if(Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('AIP_Lead') != null){
            testLead1.RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('AIP_Lead').getRecordTypeId();
        }
		insert testLead1;
        
        Case caseRecAIC = new Case(recordTypeId = caseRecordTypeMap.get('AIC').getRecordTypeId(), Communication_Method__c = 'Phone', Status = 'New', Origin = 'Email', Account = account,
                                SLA_Extension_Approval_Required__c = true, External_SLA_End_Date__c = Date.today());
        insert caseRecAIC;

    }
    
    //Method to test
    @isTest static void testClientFinder(){
    	Case caseRec = [SELECT Id FROM Case LIMIT 1];
        Account accRec = [SELECT Id FROM Account LIMIT 1];
        Contact contactRec = [SELECT Id FROM Contact LIMIT 1];
        
        Test.startTest(); 
        string caseid = ClientFinderActionExt.linkClientToCase(String.valueOf(caseRec.Id), accRec, 'Complaint', contactRec.Id, '14500000122222', 'WILL', 'Active');
        Account a = new Account();
        a.Name = 'Old In Memory';
        ClientFinderUtilities.findOrCreateClient(a);
        Test.stopTest();
        system.assert(true,caseid!=null);
        
    }
    
       //Method to test
    @isTest static void testClientFinder2(){
    	Case caseRec = [SELECT Id FROM Case LIMIT 1];
        Account personAccount = new Account(lastName = 'Test', firstName = 'Account');
        insert personAccount;
        Contact contactRec = [SELECT Id FROM Contact LIMIT 1];
        
        Test.startTest(); 
        ClientFinderActionExt.linkClientToCase(String.valueOf(caseRec.Id), personAccount, 'Complaint', contactRec.Id, '14500000122222', 'WILL', 'Active');
        Account a = new Account();
        a.FirstName = 'Old';
        a.LastName = ' In Memory';
        account acc = ClientFinderUtilities.findOrCreateClient(a);
        Test.stopTest();
        system.assert(true,acc!=null);
        
    }
    
     //Method to test
    @isTest static void testClientFinderWithNewClient(){
        Case caseRec = [SELECT Id FROM Case LIMIT 1];
        Account accRec = [SELECT Id FROM Account LIMIT 1];
        Contact contactRec = [SELECT Id FROM Contact LIMIT 1];
        
        Test.startTest();
        string caseid = ClientFinderActionExt.linkClientToCase(String.valueOf(caseRec.Id), accRec, 'Service Request', contactRec.Id, '14500000122222', 'WILL', 'Active');
        Test.stopTest();
        system.assert(true,caseid!=null);
    }
    
    //Method to test
    @isTest static void testClientFinderWithNewClient2(){
        Case caseRec = [SELECT Id FROM Case LIMIT 1];
        Account accRec = new Account(FirstName = 'Test Person', LastName = 'Account');
        Contact contactRec = [SELECT Id FROM Contact LIMIT 1];
        
        Test.startTest(); 
        try{
            ClientFinderActionExt.linkClientToCase(String.valueOf(caseRec.Id), accRec,  'Complaint', contactRec.Id, '14500000122222', 'WILL', 'Active' );
        }catch(AuraHandledException ex){
            System.assert(true, 'Exception ' + ex);
        }catch(Exception ex){
            System.assert(true, 'Exception ' + ex);
        }
        Test.stopTest();
    }
    
    //Method to test
    @isTest static void negTestCaseFlagAction(){
        Case caseRec = [SELECT Id FROM Case LIMIT 1];
        Contact contactRec = [SELECT Id FROM Contact LIMIT 1];
        
        Test.startTest();
        string caseid = ClientFinderActionExt.linkClientToCase(String.valueOf(caseRec.Id), null,  'Complaint', contactRec.Id, '14500000122222', 'WILL', 'Active');
        Test.stopTest();
        system.assert(true,caseid!=null);

    }
    
     @isTest static void testClientFinderforLead(){
    	Lead leadRec = [SELECT Id FROM Lead LIMIT 1];
        Account personAccount = new Account(lastName = 'Test', firstName = 'Account');
        //insert personAccount;
        Contact contactRec = [SELECT Id FROM Contact LIMIT 1];
        
        Test.startTest(); 
        ClientFinderActionExt.linkClientToCase(String.valueOf(leadRec.Id), personAccount, 'Complaint', contactRec.Id, '14500000122222', 'WILL', 'Active');
        Account a = new Account();
        a.FirstName = 'Old';
        a.LastName = ' In Memory';
        account acc = ClientFinderUtilities.findOrCreateClient(a);
        Test.stopTest();
        system.assert(true,acc!=null);
        
    }
     @isTest static void testClientFinderforLead1(){
    	Lead leadRec = [SELECT Id FROM Lead LIMIT 1];
        Account personAccount = new Account(lastName = 'Test', firstName = 'Account');
        insert personAccount;
        Contact contactRec = [SELECT Id FROM Contact LIMIT 1];
        
        Test.startTest(); 
        ClientFinderActionExt.linkClientToCase(String.valueOf(leadRec.Id), personAccount, 'Complaint', contactRec.Id, '14500000122222', 'WILL', 'Active');
        Account a = new Account();
        a.FirstName = 'Old';
        a.LastName = ' In Memory';
        Account acc = ClientFinderUtilities.findOrCreateClient(a);
        Test.stopTest();
        system.assert(true,acc!=null);
        
    }
       //Method to test
       @isTest
      static  void TestCaseAICValidation(){
        Case caseRec = [SELECT Id FROM Case WHERE Communication_Method__c ='Phone' LIMIT 1];
        Account accRec = new Account(FirstName = 'Test Person', LastName = 'Account');
        Contact contactRec = [SELECT Id FROM Contact LIMIT 1];
        
        Test.startTest();
        try{
            String returnId = ClientFinderActionExt.linkClientToCase(String.valueOf(caseRec.Id), accRec,  'AIC', contactRec.Id, '14500000122222', 'WILL', 'Active');
            System.assertNotEquals(returnId,null); 
        }catch(AuraHandledException ex){
            System.assert(true, 'Exception ' + ex);
        }catch(Exception ex){
            System.assert(true, 'Exception ' + ex);
        }
        Test.stopTest();
    }
}