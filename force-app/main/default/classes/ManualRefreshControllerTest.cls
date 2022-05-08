/**
* @description -Test class for ManualRefreshController
* @author   Saiteja : ABSA
* @since   2021-03-09 
*
**/

@isTest
public class ManualRefreshControllerTest {
    @isTest
    public static void testClientData(){  
        Account acct = new Account();
        acct.Name='testacct';
        insert acct;
        ManualRefreshController.ClientData getAcct = new ManualRefreshController.ClientData();
        getAcct.clientAcc = acct;
        Document__c doc = new Document__c();
        doc.Name = 'Attestation.pdf';
        doc.Type__c = 'Attestation';
        doc.Reference__c = '2683723-293892-kajska';
        doc.Account__c = acct.id;
        doc.ECM_Type__c = 'Ent_Agreement';
        insert doc;
        
        Test.startTest();
        ManualRefreshController.getData(acct.id);
        //ManualRefreshController.refreshDate(acct.id,'2022-03-09T12:31:38.923Z');
        ManualRefreshController.getDependentMap(acct,'Client_Type__c','Place_of_Residence__c','Client_Group__c');
        system.assertEquals(getAcct.clientAcc,acct);
        Test.stopTest();
    }
        /* @isTest
    public static void ECMLogin() {
    
    insertSettings();
    Test.startTest();
    ManualRefreshController.ECMLogin();
    Test.stopTest();
    } */
    
    @isTest
    public static void testmethod2(){
        insertSettings();
        Account acc = new Account(Name = 'Test New Bus Client', Client_Type__C = 'Private Company',Registration_Number__c='5678',CIF__c ='3574',
                                  AccountNumber='6478');
        insert acc;
        Document__c doc = new Document__c();
        doc.Name = 'Attestation.pdf';
        doc.Type__c = 'Attestation';
        doc.Reference__c = '2683723-293892-kajska';
        doc.Account__c = acc.id;
        doc.ECM_Type__c = 'Ent_Agreement';
        insert doc;
        String body = '{"LoginResult" : {"Status" : "OK", "Details" : "null"}, "Token" : "1234567890"}';
        Test.setMock(HttpCalloutMock.class, new ECM_Mock_ApiRest(body));
        List<Document__c> docts = new List <Document__c>();
        Test.startTest();
        ManualRefreshController.attDocument(acc.id,'Attestation');
        ManualRefreshController.getDocContent(doc.id);
        docts = ManualRefreshController.getdocuments(acc.id);
        system.assertNotEquals(null,docts);
        Test.stopTest();
    }
    /**
    * @description -  Method to add endpoints
    **/
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
    /**
    * @description -  class to implemets HttpcalloutMock
    **/
    public class ECM_Mock_ApiRest implements HttpCalloutMock {
        /**
    * @description -  
    **/
        public String body { get; set; }
        /**
    * @description -  
    **/
        public ECM_Mock_ApiRest() {}
        /**
    * @description -  
    * @param body
    **/
        public ECM_Mock_ApiRest(String body) {
            this.body = body;
        }
        /**
    * @description -  Method to get Response
    * @param request
    * @return response
    **/
        public HTTPResponse respond(HTTPRequest request) {
            HTTPResponse response = new HTTPResponse();
            response.setStatusCode(200);
            response.setBody(body);
            response.setHeader('Content-Type', 'application/json');
            return response;
        }
    } 
    @isTest
    public static void testUBOListView(){
        Account account = new Account(Name = 'Test Account');
        account.RecordTypeId = schema.SObjectType.account.getRecordTypeInfosByName().get('Business Prospect').getRecordTypeId();
        account.Country_of_Incorporation__c='South Africa';
        account.Client_Group__c = 'Non Individual';
        account.CASA_Reference_Number__c = '12233';
        account.CIF__c = '';
        account.Countries_Traded_With__c = 'South Africa';
        account.Source_of_Income__c = 'Donation';
        insert account;
        String relParties;
        
        Test.startTest();
        relParties=ManualRefreshController.getRelatedParties(account.id);
        system.assertnotEquals(null,relParties);
        Test.stopTest();
    }
}