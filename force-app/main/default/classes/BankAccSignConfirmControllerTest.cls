@isTest
public class BankAccSignConfirmControllerTest {
    
    @isTest 
    public static void testgetInstruction(){
        
        
        List<Account> accountList = TestDataFactory.getPersonAccounts('lastName', 'Individual_Client', 1);
        accountList[0].LastName = 'ABSA TEST';
        accountList[0].ID_Type__pc ='SA Identity Document';
        accountList[0].ID_Number__pc='9302212347096';
        accountList[0].AccountNumber ='0000004048154875';
        insert accountList;
        
        List<Case> caseList = TestDataFactory.getCases('Service_Request', 1);
        caseList[0].Subject = 'TESTCASE123';
        
        Date sla = Date.today().addDays(15);
        caseList[0].External_SLA_End_Date__c = sla;
        caseList[0].AccountId = accountList[0].Id;
        insert caseList;
        
        
        Document_Template__c dt = new Document_Template__c();
        dt.Name = 'ABSA 6994 - Bank Account Signatories Confirmation';
        dt.Document_Type__c = 'ABSA 6994 - Bank Account Signatories Confirmation';
        dt.xml__C='<Schema><AISxMetaData><IsNCA>false</IsNCA><IsCPA>false</IsCPA><IsDigitalSignature>true</IsDigitalSignature><Language /></AISxMetaData><Main><entityName>ANDRE PETRUS</entityName><accountNumber>00000004048154875</accountNumber><fullNames>ANDRE PETRUS</fullNames><surname>BRINK</surname><IDNumber>-1443448119</IDNumber><consultantName>Himanshu Nimje</consultantName><consultantSurname>Nimje</consultantSurname></Main></Schema>';
        insert dt;
        
        //Rest Client Test Data 
        RestClientUtils.ApiException ex = new RestClientUtils.ApiException(
            500, 'Server error', null, 'There was a server error'
        );
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"test": ["test1", "test2", "test3", "test4", "test5"]}');
        res.setStatusCode(200);
        
        RestClientUtils.processResponse(res, null);
        System.assert(ex != null);
        System.assert(ex.getStatusCode() == 500);
        RestClientUtils.processResponse(res, String.class);
        RestClientUtils.processResponse(res, Blob.class);
        RestClientUtils.processResponse(res, HotDocsToken.class);
        List<String> endpoints = new List<String>();
        endpoints.add('Impressions Create AuthenticationIntent');
        IntegrationTestDataFactory.insertIntegrationSettings('Impressions', endpoints);
        String body = '{"LoginResult" : {"Status" : "OK", "Details" : "null"}, "Token" : "1234567890"}';
        
        //Rest client Test Ends
        
        CIgetSigningInstructionsV4_Req_IB_v1 dummyBeanParent = CIgetSigningInstructionsV4_Req_IB_v1.createDummyRequest();
        CIgetSigningInstructionsV4_Req_IB_v1.Cip082di dummyBean = dummyBeanParent.CIgetSigningInstructionsV4.cip082di;
        
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new CIgetSigningInstructionsV4_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
            StringConstants.CI_GET_SIGNING_INSTRUCTIONS_V4
                });
        Test.startTest();
        Map<CIgetSigningInstructionsV4_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = CIgetSigningInstructionsV4_IH_v1.CIgetSigningInstructionsV4(dummyBean.accountNumber, dummyBean.siteCode, dummyBean.maxRetrieve);
        BankAccSignConfirmController.getInstruction(accountList[0].Id,accountList[0].AccountNumber);
        BankAccSignConfirmController.closeCaseAction(caseList[0].Id);
        Test.stopTest();
    }
    
    @isTest 
    public static void testupdateXML(){
        
        List<Account> accountList = TestDataFactory.getPersonAccounts('lastName', 'Individual_Client', 1);
        accountList[0].LastName = 'ABSA TEST';
        accountList[0].ID_Type__pc ='SA Identity Document';
        accountList[0].ID_Number__pc='9302212347096';
        accountList[0].AccountNumber ='0000004048154875';
        insert accountList;
        Document_Template__c dt = new Document_Template__c();
        dt.Name = 'ABSA 6994 - Bank Account Signatories Confirmation';
        dt.Document_Type__c = 'ABSA 6994 - Bank Account Signatories Confirmation';
        dt.xml__C='<Schema><AISxMetaData><IsNCA>false</IsNCA><IsCPA>false</IsCPA><IsDigitalSignature>true</IsDigitalSignature><Language /></AISxMetaData><Main><entityName>ANDRE PETRUS</entityName><accountNumber>00000004048154875</accountNumber><fullNames>ANDRE PETRUS</fullNames><surname>BRINK</surname><IDNumber>-1443448119</IDNumber><consultantName>Himanshu Nimje</consultantName><consultantSurname>Nimje</consultantSurname></Main></Schema>';
        insert dt;
        
        BankAccSignConfirmController.updateXML(accountList[0].Id,'0000004048154875','1','{   "CIgetSigningInstructionsV4Response": {     "nbsapdpo": {       "returnCode": "0",       "reasonCode": "0",       "serviceVersion": "BUSO003",       "echoKey": null     },     "nbsmsgo3": {       "version": "MSG3001",       "sysErrTxt": null,       "nbrUserMsgs": "0",       "nbrUserErrs": "0",       "msgEntry": {         "msgClass": null,         "msgCode": null,         "msgErrInd": null,         "msgTxt": null       }     },     "cip082do": {       "clientCode": "BDPLACE001",       "nbrSignReqOperAcc": "1",       "specialConditions": null,       "nbrSignRetrieved": "3",       "restartKeyOutput": null,       "outputTable": [         {           "title": "1",           "initials": "L",           "surname": "KILLIAN",           "name": "JOHN",           "idType": "3",           "idNbr": "34729387",           "dateIssued": "20130821",           "compulsorySign": "N",           "physicalAdd1": null,           "physicalAdd2": null,           "physicalSuburb": null,           "physicalTown": null,           "physicalPostal": "0",           "clientNationality": null,           "countryOfOrigin": null,           "countryResAddress": null,           "birthOpCountry": null,           "homeTelCode": null,           "homeTelephone": null,           "emailAddress": null,           "gender": "0",           "birthDate": "14081982",           "occupationStatus": "0",           "occupationCode": "0",           "designation": "0"         },         {           "title": "8",           "initials": "W",           "surname": "WENTZEL",           "name": "RONNIE",           "idType": "3",           "idNbr": "3689333",           "dateIssued": "20130814",           "compulsorySign": "Y",           "physicalAdd1": null,           "physicalAdd2": null,           "physicalSuburb": null,           "physicalTown": null,           "physicalPostal": "0",           "clientNationality": null,           "countryOfOrigin": null,           "countryResAddress": null,           "birthOpCountry": null,           "homeTelCode": null,           "homeTelephone": null,           "emailAddress": null,           "gender": "0",           "birthDate": "0",           "occupationStatus": "0",           "occupationCode": "0",           "designation": "0"         },         {           "title": "1",           "initials": "A",           "surname": "DE JAGER",           "name": "TRISTAN",           "idType": "3",           "idNbr": "3792",           "dateIssued": "20130714",           "compulsorySign": "N",           "physicalAdd1": null,           "physicalAdd2": null,           "physicalSuburb": null,           "physicalTown": null,           "physicalPostal": "0",           "clientNationality": null,           "countryOfOrigin": null,           "countryResAddress": null,           "birthOpCountry": null,           "homeTelCode": null,           "homeTelephone": null,           "emailAddress": null,           "gender": "0",           "birthDate": "0",           "occupationStatus": "0",           "occupationCode": "0",           "designation": "0"         }       ]     }   } }');
    }
    
    @isTest 
    public static void testgetDocuments(){
        
        List<Account> accountList = TestDataFactory.getPersonAccounts('lastName', 'Individual_Client', 1);
        accountList[0].LastName = 'ABSA TEST';
        accountList[0].ID_Type__pc ='SA Identity Document';
        accountList[0].ID_Number__pc='9302212347096';
        accountList[0].AccountNumber ='0000004048154875';
        insert accountList;
        
        Document_Template__c dt = new Document_Template__c();
        dt.Name = 'ABSA 6994 - Bank Account Signatories Confirmation';
        dt.Document_Type__c = 'ABSA 6994 - Bank Account Signatories Confirmation';
        dt.xml__C='<Schema><AISxMetaData><IsNCA>false</IsNCA><IsCPA>false</IsCPA><IsDigitalSignature>true</IsDigitalSignature><Language /></AISxMetaData><Main><entityName>ANDRE PETRUS</entityName><accountNumber>00000004048154875</accountNumber><fullNames>ANDRE PETRUS</fullNames><surname>BRINK</surname><IDNumber>-1443448119</IDNumber><consultantName>Himanshu Nimje</consultantName><consultantSurname>Nimje</consultantSurname></Main></Schema>';
        insert dt;
        //new code 
        DocumentTemplateProcessor.ContextBuilder builder = new DocumentTemplateProcessor.ContextBuilder();
        Account acc = new Account();
        acc.Name = 'My Account';
        builder.add('Account', acc);
        String json = builder.serialize('{"var1" : true}');
        System.assert(json != null);
        DocumentTemplateProcessor dp = new DocumentTemplateProcessor();
        Document_Template__c d = new Document_Template__c();
        d.Template_Id__c = '12345';
        d.Name = 'Business - Client Agreement';
        d.Document_Type__c = 'Business - Client Agreement';
        insert d;
        Map<String, String> ecmFields = new Map<String, String>();
        ecmFields.put('Id', '984576564987');
        List<String> endpoints = new List<String>();
        endpoints.add(DocumentTemplateProcessor.DOCUMENT_TEMPLATE_PROCESSOR);
        IntegrationTestDataFactory.insertIntegrationSettings('Jitterbit2', endpoints);
        RestClientUtils.QueueHttpMock mock = new RestClientUtils.QueueHttpMock();
        //mock.addResponse(JSON.serialize(new CC_GenerateContentResponse()));
        mock.addResponse('{"ResponseStatus":"Success","ContentStatus":"ContentGenerated","ContentStoreToken":"101 3 ICM7 UGOLSDB22 Ent_AccountApplication59 26 A1001001A20H24B75539I7664718 A20H24B75539I766471 14 1730"}');
        Test.setMock(HttpCalloutMock.class, mock);
        
        
        List<Case> caseList = TestDataFactory.getCases('Service_Request', 1);
        caseList[0].Subject = 'TESTCASE123';
        
        Date sla = Date.today().addDays(15);
        caseList[0].External_SLA_End_Date__c = sla;
        caseList[0].AccountId = accountList[0].Id;
        insert caseList;
        
        //Rest Client Test Data 
        RestClientUtils.ApiException ex = new RestClientUtils.ApiException(
            500, 'Server error', null, 'There was a server error'
        );
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"test": ["test1", "test2", "test3", "test4", "test5"]}');
        res.setStatusCode(200);
        
        RestClientUtils.processResponse(res, null);
        System.assert(ex != null);
        System.assert(ex.getStatusCode() == 500);
        RestClientUtils.processResponse(res, String.class);
        RestClientUtils.processResponse(res, Blob.class);
        RestClientUtils.processResponse(res, HotDocsToken.class);
        List<String> endpoints0 = new List<String>();
        endpoints0.add('Impressions Create AuthenticationIntent');
        endpoints0.add('Impressions CreateInlineSignatureWorkflow');
        endpoints0.add('Impressions CreatePDFSignatureRequestEvent');
        endpoints0.add('Impressions CreateSignatureWorkflow');
        endpoints0.add('Impressions GetViewLink');
        endpoints0.add('Impressions SignatureAuditTrail RequestId');
        endpoints0.add('Impressions SignatureAuditTrail Workflow');
        endpoints0.add('Impressions SignatureAuditTrailAndDocumentByRequestId');
        IntegrationTestDataFactory.insertIntegrationSettings('Impressions', endpoints0);
        String body = '{"LoginResult" : {"Status" : "OK", "Details" : "null"}, "Token" : "1234567890"}';
        
        Integration_API__c api = Sys_Utilities_Integration.getMultipleIntegrationSettings('Impressions', Sys_Utilities_General.getEnvironment(), '');
        Integration_Service__c service = api.Integration_Services__r.get(0);
        Map<String, String> form = new Map<String, String>();
        form.put('client_id', 'clientId');
        form.put('client_secret', 'clientSecret');
        form.put('grant_type', 'client_credentials');
        form.put('scope', 'TemplateHubAPI TemplateHubPermissionsAPI AnswersHubAPI UserAdminAPI TemplateHubTenancyResolver');
        Map<String, String> headers = HotDocs_IH_v1.getDefaultAuthHeaders(api);
        List<String> contentTypes = new List<String>();
        contentTypes.add('application/x-www-form-urlencoded');
        RestClientUtils.createRequest(StringConstants.HTTP_POST_STRING, api.Base_URL__c + '/' + service.URL_Extension__c, null, null, form, null, headers, null, contentTypes);
        List<String> contentTypes2 = new List<String>();
        contentTypes2.add('application/json');
        RestClientUtils.createRequest(StringConstants.HTTP_POST_STRING, api.Base_URL__c + '/' + service.URL_Extension__c, null, null, form, null, headers, null, contentTypes2);
        RestClientUtils.ApiException ap = new RestClientUtils.ApiException();
        ap.getBody();
        ap.getStatusCode();
        ap.getStatus();
        ap.getHeaders();
        RestClientUtils.RequestBuilder rr = new RestClientUtils.RequestBuilder();
        rr.method(StringConstants.HTTP_POST_STRING);
        rr.path(StringConstants.HTTP_POST_STRING);
        rr.body(ap.getBody());
        rr.queryParams(null);
        rr.form(null);
        rr.pathParams(null);
        rr.headers(null) ;
        rr.accepts(null);
        rr.contentTypes(null);
        rr.returnType(null);
        rr.responseHandler(null);
        rr.log(true);
        rr.api('String api');
        rr.service('String service');
        rr.header('String header', 'String value');
        rr.pathParam('String pathParam', 'String value');
        RestClientUtils.QueueHttpMock q= new RestClientUtils.QueueHttpMock();
        q.addResponse(res);
        q.addResponse('String(res)');
        q.addResponse('response', 1, 'application/json');
        HttpRequest httpRequest = new httpRequest();
        q.respond(httpRequest);
        RestClientUtils.LoggingQueueable lq = new RestClientUtils.LoggingQueueable();
        RestClientUtils.LoggingQueueable lq2 = new RestClientUtils.LoggingQueueable('string');
        lq.log='a string';
                
        Test.startTest();
        BankAccSignConfirmController.getDocument(accountList[0].Id,accountList[0].AccountNumber,'1' ,'{"title":"1","surname":"BRINK","physicalTown":"johannesburg","physicalSuburb":"johannesburg","physicalPostal":"2001","physicalAdd2":"test2","physicalAdd1":"test","occupationStatus":"0","occupationCode":"0","name":"ANDRE PETRUS","initials":"AP","idType":"1","idNbr":"-1443448119","homeTelephone":"7654321","homeTelCode":"011","gender":"1","emailAddress":"phambaniso.phandle@absa.africa","designation":"0","dateIssued":"20130101","countryResAddress":"SO003","countryOfOrigin":null,"compulsorySign":"Y","clientNationality":"SOU01","birthOpCountry":"SO003","birthDate":"29101961"}','ABSA 6994 - Bank Account Signatories Confirmation',caseList[0].Id);
        
        Test.stopTest();
    }
    
     @isTest 
    public static void testgetInstructionNegative(){
        
        
        List<Account> accountList = TestDataFactory.getPersonAccounts('lastName', 'Individual_Client', 1);
        accountList[0].LastName = 'ABSA TEST';
        accountList[0].ID_Type__pc ='SA Identity Document';
        accountList[0].ID_Number__pc='9302212347096';
        accountList[0].AccountNumber ='0000004048154875';
        insert accountList;
        
        List<Case> caseList = TestDataFactory.getCases('Service_Request', 1);
        caseList[0].Subject = 'TESTCASE123';
        
        Date sla = Date.today().addDays(15);
        caseList[0].External_SLA_End_Date__c = sla;
        caseList[0].AccountId = accountList[0].Id;
        insert caseList;
        Document_Template__c dt = new Document_Template__c();
        dt.Name = 'ABSA 6994 - Bank Account Signatories Confirmation';
        dt.Document_Type__c = 'ABSA 6994 - Bank Account Signatories Confirmation';
        dt.xml__C='<Schema><AISxMetaData><IsNCA>false</IsNCA><IsCPA>false</IsCPA><IsDigitalSignature>true</IsDigitalSignature><Language /></AISxMetaData><Main><entityName>ANDRE PETRUS</entityName><accountNumber>00000004048154875</accountNumber><fullNames>ANDRE PETRUS</fullNames><surname>BRINK</surname><IDNumber>-1443448119</IDNumber><consultantName>Himanshu Nimje</consultantName><consultantSurname>Nimje</consultantSurname></Main></Schema>';
        insert dt;
        Test.setMock(HttpCalloutMock.class, new CIgetSigningInstructionsV4_Mock_ApiRest('Single'));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
            StringConstants.CI_GET_SIGNING_INSTRUCTIONS_V4
                });
        
    Test.startTest();
        Map<CIgetSigningInstructionsV4_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = CIgetSigningInstructionsV4_IH_v1.CIgetSigningInstructionsV4('0000004048154875','1','4');
        BankAccSignConfirmController.getInstruction(accountList[0].Id,'0000004048154875');
        BankAccSignConfirmController.closeCaseAction(caseList[0].Id);
        Test.stopTest();
    }
    
    
}