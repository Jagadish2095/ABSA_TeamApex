/**
* Test class for NatisRequestVehicleSelection
*
* @author  Rudolf Niehaus : CloudSmiths
* @since   2020-02-23
*
**/
@isTest
public class NatisRequestVehicleSelectionTest {

    @isTest 
    public static void testNatisRequestGetDoc() {
    
        WillsTestDataFactory testDataFactory = new WillsTestDataFactory();
		testDataFactory.testAccount.CIF__c = 'bboys001';
        update testDataFactory.testAccount;
        
        insertSettings();

        String body = '{"QueryResult": {"Status": "Ok", "Details": "Some details"}, "Documents": {"Document":{"ItemType": "NATISDoc", "PID": "1234567890"}}}';
        Test.setMock(HttpCalloutMock.class, new ECM_Mock_ApiRest(body));

        Test.startTest();
        
            NatisRequestVehicleSelection.getNatisDocs( testDataFactory.testAccount.Id );

        Test.stopTest();

    }
    @isTest //RN - Need this as the ConnectAPI is called in the casetriggerfunctions 
    public static void testNatisRequestSendDoc() {
        
		map<String, Schema.RecordTypeInfo> caseRecordTypeMap = Case.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
        Account account = new Account(Name = 'Test Account');
        insert account;
		Contact con = new Contact();
        con.LastName = 'testNatis';
        con.FirstName = 'NatisTest';
        con.Email = 'Natis@test.co.za';
        insert con;
        
        Case caseRec = new Case(Communication_Method__c = 'Email',
                                Status = 'New',
                                Origin = 'Email', 
                                AccountId = account.Id,
                                Email__c = 'test@test.com',
                               	recordTypeId = caseRecordTypeMap.get('Service_Request').getRecordTypeId(),
                                Subject = 'test',
                                Description = 'test',
                               	Type__c = 'abc',
                                Out_Of_SLA_Comments__c = 'Test',
                           		Out_Of_SLA_Reason__c = 'Account Closed',
                                Bypass_Validation_Rules__c = true);
        
        insert caseRec;
        
        insertSettings();
        String body = '{"LoginResult" : {"Status" : "OK", "Details" : "null"}, "Token" : "1234567890"}';
        Test.setMock(HttpCalloutMock.class, new ECM_Mock_ApiRest(body));

        List<String> docList = new List<String>();
        docList.add('86 3 ICM7 UGOLSDB8 NATISDoc59 26 A1001001A20C02B53006A5171118 A20C02B53006A517111 14 1913');
        String emailAddress = 'test@test.com';
        
        Test.startTest();
        
            NatisRequestVehicleSelection.sendNatisDocs(docList, emailAddress, caseRec.Id);

        Test.stopTest();

    }
    public static void insertSettings() {
        List<String> endpoints = new List<String>();
        endpoints.add('ECM Query Path');
        endpoints.add('ECM Authenication Path');
        endpoints.add('ECM Add Path');
        endpoints.add('ECM Logout Path');
        endpoints.add('ECM GetItemType Path');
        endpoints.add('ECM Get Path');
        endpoints.add('ECM GetItemTypes Path');
        IntegrationTestDataFactory.insertIntegrationSettings('API Manager', endpoints);
    }
    
    public class ECM_Mock_ApiRest implements HttpCalloutMock {
        
        public String body { get; set; }
        
        public ECM_Mock_ApiRest() {}
        
        public ECM_Mock_ApiRest(String body) {
            this.body = body;
        }
        
        public HTTPResponse respond(HTTPRequest request) {
            HTTPResponse response = new HTTPResponse();
            response.setStatusCode(200);
            response.setBody(body);
            response.setHeader('Content-Type', 'application/json');
            return response;
        }
    }
    
}