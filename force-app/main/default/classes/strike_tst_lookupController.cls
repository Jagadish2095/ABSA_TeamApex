/* --------------------------------------------------
Strike by Appiphony

Version: 0.10.0
Website: http://www.lightningstrike.io
GitHub: https://github.com/appiphony/Strike-Components
License: BSD 3-Clause License
-------------------------------------------------- */
@isTest
private class strike_tst_lookupController {

    @isTest static void test_getRecentRecords() {
        String jsonString = '{"searchField":"Name", "object": "Account", "filter": "Name = \'Test Account\'"}';

        Test.startTest();
        String responseString = strike_lookupController.getRecentRecords(jsonString);
        Test.stopTest();

        Map<String, Object> response = (Map<String, Object>)JSON.deserializeUntyped(responseString);
        Map<string, Object> results = (Map<String, Object>)response.get('results');
    }

    @isTest static void test_getRecordLabel() {
        Account a = new Account(Name='Test Account');
        insert a;

        String jsonString = '{"searchField":"Name", "object": "Account", "filter": "Name = \'Test Account\'"}';

        Test.startTest();
        String responseString = strike_lookupController.getRecordLabel(jsonString);
        Test.stopTest();

        Map<String, Object> response = (Map<String, Object>)JSON.deserializeUntyped(responseString);
        Map<string, Object> results = (Map<String, Object>)response.get('results');
        String objectLabel = String.valueOf(results.get('objectLabel'));

        System.assertEquals('Account', objectLabel);
    }

    @isTest static void test_getData() {
        Account a = new Account(Name='Test Account');
        insert a;

        String jsonString = '{"searchField":"Name", "object": "Account", "filter": "Name = \'Test Account\'", "order": "Name", "limit": "5", "searchTerm": "Test"}';

        Test.startTest();
        String responseString = strike_lookupController.getRecords(jsonString);
        Test.stopTest();

        Map<String, Object> response = (Map<String, Object>)JSON.deserializeUntyped(responseString);
        Map<string, Object> results = (Map<String, Object>)response.get('results');
        List<Object> data =(List<Object>)results.get('data');
        if(data != null){
              Map<String, Object> record = (Map<String, Object>)data.get(0);
		}
    }

    @isTest static void test_getData_subtitleField() {
        Account a = new Account(Name='Test Account');
        insert a;

        String jsonString = '{"searchField":"Name", "subtitleField": "Name", "object": "Account", "filter": "Name = \'Test Account\'", "searchTerm": "Test"}';

        Test.startTest();
        String responseString = strike_lookupController.getRecords(jsonString);
        Test.stopTest();

        Map<String, Object> response = (Map<String, Object>)JSON.deserializeUntyped(responseString);
        Map<string, Object> results = (Map<String, Object>)response.get('results');
        List<Object> data =(List<Object>)results.get('data');

        
        if(data != null){
        Map<String, Object> record = (Map<String, Object>)data.get(0);
		}
       
    }

    @isTest static void test_getData_addressField() {
        Account a = new Account(
            Name='Test Account',
            BillingStreet='Test Street',
            BillingCity='Test City',
            BillingState='Test State',
            BillingCountry='Test Country',
            BillingPostalCode='Test Postal Code');
        insert a;

        String jsonString = '{"searchField":"Name", "subtitleField": "BillingAddress", "object": "Account", "filter": "Name = \'Test Account\'", "searchTerm": "Test"}';

        Test.startTest();
        String responseString = strike_lookupController.getRecords(jsonString);
        Test.stopTest();

        Map<String, Object> response = (Map<String, Object>)JSON.deserializeUntyped(responseString);
        Map<string, Object> results = (Map<String, Object>)response.get('results');
        List<Object> data =(List<Object>)results.get('data');
        if(data != null){
        Map<String, Object> record = (Map<String, Object>)data.get(0);
		}
        
    }

    @isTest static void test_getData_reference() {
        Account a = new Account(Name='Test Account');
        insert a;

        Contact c = new Contact(
            LastName='Contact',
            FirstName='Test',
            AccountId = a.Id);
        insert c;

        String jsonString = '{"searchField":"FirstName", "subtitleField": "Account.Name", "object": "Contact", "filter": "Name = \'Test Contact\'", "searchTerm": "Test"}';

        Test.startTest();
        String responseString = strike_lookupController.getRecords(jsonString);
        Test.stopTest();

        Map<String, Object> response = (Map<String, Object>)JSON.deserializeUntyped(responseString);
        Map<string, Object> results = (Map<String, Object>)response.get('results');
        List<Object> data =(List<Object>)results.get('data');

        
        if(data != null){
        Map<String, Object> record = (Map<String, Object>)data.get(0);
		}
        
    }
    
     @isTest static void test_getData_ServiceGroup() {
        
         Service_Group__c serviceGroupRecord = new Service_Group__c(Name='Test Account', Assign_Record_Type__c = 'ATM');
        insert serviceGroupRecord;

        String jsonString = '{"searchField":"Name", "subtitleField": "Name", "object": "Service_Group__c", "filter": "ATM", "searchTerm": "Test"}';

        Test.startTest();
        String responseString = strike_lookupController.getRecords(jsonString);
        Test.stopTest();

        Map<String, Object> response = (Map<String, Object>)JSON.deserializeUntyped(responseString);
        Map<string, Object> results = (Map<String, Object>)response.get('results');
        List<Object> data =(List<Object>)results.get('data');

        
        if(data != null && data.size() > 0){
        Map<String, Object> record = (Map<String, Object>)data.get(0);
		}
        
    }
    
     @isTest static void test_getData_ServiceType() {

        Service_Type__c serviceType = new Service_Type__c(Name = 'Test1',
                                                          Case_Record_Type__c = 'New',
                                                          Subtype__c = 'Sample',
                                                          Type__c = 'T01');
        insert serviceType;
        
        BusinessHours businessHr = [SELECT Id FROM BusinessHours LIMIT 1];
        
        Service_Group__c serviceGr = new Service_Group__c(Name = 'Test1', Assign_Record_Type__c = 'Email',
                                                          Response_Email_Address__c = 'evg@t.com',
                                                          Queue__c = 'Email',
                                                          Business_Hours__c = businessHr.Id,
                                                          Internal_SLA_Time_Measure__c = 'Hour(s)',
                                                          Internal_SLA_Units__c = '8');
        insert serviceGr;
        
        Service_Level__c serviceLevel = new Service_Level__c(Name = 'Test1', 
                                                             External_SLA_Time_Measure__c = 'Hour(s)',
                                                             External_SLA_Units__c = '8',
                                                             Default_Service_Level__c = true);
        insert serviceLevel;
        
        
        Service_Group_Type__c serviceGrType = new Service_Group_Type__c(Service_Type__c = serviceType.Id,
                                                                        Service_Group__c = serviceGr.Id,
                                                                        Service_Level__c = serviceLevel.Id);
        insert serviceGrType;

        String jsonString = '{"searchField":"Name", "object": "Service_Type__c", "filter": "' + serviceGr.Id +'", "searchTerm": "Test"}';

        Test.startTest();
        String responseString = strike_lookupController.getRecords(jsonString);
        Test.stopTest();

        Map<String, Object> response = (Map<String, Object>)JSON.deserializeUntyped(responseString);
        Map<string, Object> results = (Map<String, Object>)response.get('results');
        List<Object> data =(List<Object>)results.get('data');

        
        if(data != null && data.size() > 0){
        Map<String, Object> record = (Map<String, Object>)data.get(0);
		}
        
    }
    
    @isTest static void test_getData_Contact() {
        Account a = new Account(Name='Test Account');
        insert a;
        Contact contactRecord = new Contact(FirstName='Test', LastName = 'Contact', AccountId = a.Id);
        insert contactRecord;

        String jsonString = '{"searchField":"FirstName", "subtitleField": "FirstName", "object": "Contact", "filter": "' + a.Id + '", "searchTerm": "Test"}';

        Test.startTest();
        String responseString = strike_lookupController.getRecords(jsonString);
        Test.stopTest();

        Map<String, Object> response = (Map<String, Object>)JSON.deserializeUntyped(responseString);
        Map<string, Object> results = (Map<String, Object>)response.get('results');
        List<Object> data =(List<Object>)results.get('data');

        
        if(data != null && data.size() > 0){
        Map<String, Object> record = (Map<String, Object>)data.get(0);
		}
        
    }
    
    @isTest static void test_getData_Site() {
        Service_Group__c serviceGroupRecord = new Service_Group__c(Name='Test Account', Assign_Record_Type__c = 'ATM');
        insert serviceGroupRecord;
        Site__c siteRecord = new Site__c(Name='Test', Service_Group__c = serviceGroupRecord.Id);
        insert siteRecord;

        String jsonString = '{"searchField":"Name", "subtitleField": "Name", "object": "Site__c", "filter": "' + serviceGroupRecord.Id + '", "searchTerm": "Test"}';

        Test.startTest();
        String responseString = strike_lookupController.getRecords(jsonString);
        Test.stopTest();

        Map<String, Object> response = (Map<String, Object>)JSON.deserializeUntyped(responseString);
        Map<string, Object> results = (Map<String, Object>)response.get('results');
        List<Object> data =(List<Object>)results.get('data');

        
        if(data != null && data.size() > 0){
        Map<String, Object> record = (Map<String, Object>)data.get(0);
		}
        
    }
}
/* --------------------------------------------------
Copyright 2017 Appiphony, LLC

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the 
following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following 
disclaimer.
2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following 
disclaimer in the documentation and/or other materials provided with the distribution.
3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote 
products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, 
INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE 
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR 
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
-------------------------------------------------- */