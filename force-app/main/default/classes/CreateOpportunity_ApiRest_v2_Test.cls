@IsTest
private class CreateOpportunity_ApiRest_v2_Test {
    
    
    public static testMethod void testCreateOpportunityIndividualPositive(){
        
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey='Africa/Johannesburg',
                          UserName=uniqueUserName);
        
        String createOpportunityRequestBody = '{"willNumber":"","postalAddressSuburb":"CENTRAL","postalAddressPostalCode":"6229","postalAddressLine2":"","postalAddressLine1":"123 WF NKOMO","postalAddressCountry":"","postalAddressCity":"UITENHAGE","physicalAddressSuburb":"CENTRAL","physicalAddressPostalCode":"6229","physicalAddressLine2":"","physicalAddressLine1":"123 WF NKOMO","physicalAddressCountry":"South Africa","physicalAddressCity":"UITENHAGE","origLeadId":"1-VOYZGM","origAdviserBRID":"A59153321","origAdviserABNumber":"ABJMA96","opptyType":"Cross Sell","opptySubProduct":"Estate Provider Plan","opptySouceType":"Siebel Campaign","opptySalesChannel":"Virtual Advisor","opptyProduct":"Estate Provider Plan","opptyName":"LESEGO LEBOTSE - EPP","estateValue":"","clientWorkNumber":"+270115563232","clientType":"Individual","clientTitle":"Mrs","clientSourceofIncome":"","clientPrefLanguage":"","clientOnboardingChannel":"Siebel System","clientOccupationStatus":"Full time Employed","clientOccupationCategory":"","clientOccupation":"Accountant","clientNationality":"South Africa","clientMaritalStatus":"Married","clientMaritalContractType":"By community of property","clientLastName":"LEBOTSE","clientInitials":"L","clientIncomeBracket":"","clientIdType":"SA Identity Document","clientIdNumber":"9012090586088","clientId":"1-VOYLJJ","clientHomeNumber":"","clientGender":"Female","clientFirstName":"LESEGO","clientEmail":"jamie.muir@absa.co.za","clientDOB":"1990-12-09","clientCountryofResidence":"","clientCountryofBirth":"South Africa","clientCIFCode":"LEBOTL 001","clientCellNumber":"+270660000000","CASAScreeningStatus":"Not Done","CASAScreeningDate":"","CASARiskStatus":"","CASAReferenceNumber":"","CASAAnalystComments":"","campaignName":"VA - Virtual Advice Inbound","campaignCode":"1-1749031401","callStartDateTime":"","callId":"","adviserBRID":"A59153321","adviserABNumber":"ABJMA96"}';
        
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {'Get Client Details', 'Get Joint Participant', 'Get Client Details By Id CIF', 'Get Involved Parties'});
        Test.setMock(HttpCalloutMock.class, new AccountCreate_CIF_MDM_Test.AccountCreate_CIF_MDM_Mock_ApiRest(StringConstants.POSITIVE_STRING, StringConstants.POSITIVE_STRING, StringConstants.POSITIVE_STRING, StringConstants.POSITIVE_STRING, 'Individual', null));
        
        CreateOpportunity_Req_IB_v1 requestBean = (CreateOpportunity_Req_IB_v1)JSON.deserialize(createOpportunityRequestBody, CreateOpportunity_Req_IB_v1.class);
        
        RestRequest request = new RestRequest();
        //Use the current base url - this is done to send headers with the request
        request.requestUri = System.URL.getSalesforceBaseURL().toExternalForm() + '/services/apexrest/createOpportunity/v02';
        request.httpMethod = 'POST';
        request.addHeader('transactionId', '1234');
        request.addHeader('initiator', 'John');
        request.addHeader('sender', 'Test System');
        RestContext.request = request;
        
        Test.startTest();        
        System.runAs(u) {
            string response = CreateOpportunity_ApiRest_v2.createOpportunity(requestBean);
        System.debug(response);
        }
        Test.stopTest();
    }
    
    public static testMethod void testCreateOpportunityIndividualPositiveNoInd(){
        
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey='Africa/Johannesburg',
                          UserName=uniqueUserName);
        
        String createOpportunityRequestBody = '{"willNumber":"","postalAddressSuburb":"CENTRAL","postalAddressPostalCode":"6229","postalAddressLine2":"","postalAddressLine1":"123 WF NKOMO","postalAddressCountry":"","postalAddressCity":"UITENHAGE","physicalAddressSuburb":"CENTRAL","physicalAddressPostalCode":"6229","physicalAddressLine2":"","physicalAddressLine1":"123 WF NKOMO","physicalAddressCountry":"South Africa","physicalAddressCity":"UITENHAGE","origLeadId":"1-VOYZGM","origAdviserBRID":"A59153321","origAdviserABNumber":"ABJMA96","opptyType":"Cross Sell","opptySubProduct":"Estate Provider Plan","opptySouceType":"Siebel Campaign","opptySalesChannel":"Virtual Advisor","opptyProduct":"Estate Provider Plan","opptyName":"LESEGO LEBOTSE - EPP","estateValue":"","clientWorkNumber":"+270115563232","clientType":"Individual","clientTitle":"Mrs","clientSourceofIncome":"","clientPrefLanguage":"","clientOnboardingChannel":"Siebel System","clientOccupationStatus":"Full time Employed","clientOccupationCategory":"","clientOccupation":"Accountant","clientNationality":"South Africa","clientMaritalStatus":"Married","clientMaritalContractType":"By community of property","clientLastName":"LEBOTSE","clientInitials":"L","clientIncomeBracket":"","clientIdType":"SA Identity Document","clientIdNumber":"9012090586088","clientId":"1-VOYLJJ","clientHomeNumber":"","clientGender":"Female","clientFirstName":"LESEGO","clientEmail":"jamie.muir@absa.co.za","clientDOB":"1990-12-09","clientCountryofResidence":"","clientCountryofBirth":"South Africa","clientCIFCode":"LEBOTL 001","clientCellNumber":"+270660000000","CASAScreeningStatus":"Not Done","CASAScreeningDate":"","CASARiskStatus":"","CASAReferenceNumber":"","CASAAnalystComments":"","campaignName":"VA - Virtual Advice Inbound","campaignCode":"1-1749031401","callStartDateTime":"","callId":"","adviserBRID":"A59153321","adviserABNumber":"ABJMA96"}';
        
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {'Get Client Details', 'Get Joint Participant', 'Get Client Details By Id CIF', 'Get Involved Parties'});
        Test.setMock(HttpCalloutMock.class, new AccountCreate_CIF_MDM_Test.AccountCreate_CIF_MDM_Mock_ApiRest(StringConstants.POSITIVE_STRING, StringConstants.POSITIVE_STRING, StringConstants.POSITIVE_STRING, StringConstants.POSITIVE_STRING, 'NoIndv', null));
        
        CreateOpportunity_Req_IB_v1 requestBean = (CreateOpportunity_Req_IB_v1)JSON.deserialize(createOpportunityRequestBody, CreateOpportunity_Req_IB_v1.class);
        
        RestRequest request = new RestRequest();
        //Use the current base url - this is done to send headers with the request
        request.requestUri = System.URL.getSalesforceBaseURL().toExternalForm() + '/services/apexrest/createOpportunity/v02';
        request.httpMethod = 'POST';
        request.addHeader('transactionId', '1234');
        request.addHeader('initiator', 'John');
        request.addHeader('sender', 'Test System');
        RestContext.request = request;
        
        Test.startTest();        
        System.runAs(u) {
            string response = CreateOpportunity_ApiRest_v2.createOpportunity(requestBean);
        System.debug(response);
        }
        Test.stopTest();
    }
    
    public static testMethod void testCreateOpportunityIndividualPositiveNoInd2(){
        
        String createOpportunityRequestBody = '{"willNumber":"","postalAddressSuburb":"CENTRAL","postalAddressPostalCode":"6229","postalAddressLine2":"","postalAddressLine1":"123 WF NKOMO","postalAddressCountry":"","postalAddressCity":"UITENHAGE","physicalAddressSuburb":"CENTRAL","physicalAddressPostalCode":"6229","physicalAddressLine2":"","physicalAddressLine1":"123 WF NKOMO","physicalAddressCountry":"South Africa","physicalAddressCity":"UITENHAGE","origLeadId":"1-VOYZGM","origAdviserBRID":"A59153321","origAdviserABNumber":"ABJMA96","opptyType":"Cross Sell","opptySubProduct":"Estate Provider Plan","opptySouceType":"Siebel Campaign","opptySalesChannel":"Virtual Advisor","opptyProduct":"Estate Provider Plan","opptyName":"LESEGO LEBOTSE - EPP","estateValue":"","clientWorkNumber":"+270115563232","clientType":"Individual","clientTitle":"Mrs","clientSourceofIncome":"","clientPrefLanguage":"","clientOnboardingChannel":"Siebel System","clientOccupationStatus":"Full time Employed","clientOccupationCategory":"","clientOccupation":"Accountant","clientNationality":"South Africa","clientMaritalStatus":"Married","clientMaritalContractType":"By community of property","clientLastName":"LEBOTSE","clientInitials":"L","clientIncomeBracket":"","clientIdType":"SA Identity Document","clientIdNumber":"9012090586088","clientId":"1-VOYLJJ","clientHomeNumber":"","clientGender":"Female","clientFirstName":"LESEGO","clientEmail":"jamie.muir@absa.co.za","clientDOB":"1990-12-09","clientCountryofResidence":"","clientCountryofBirth":"South Africa","clientCIFCode":"LEBOTL 001","clientCellNumber":"+270660000000","CASAScreeningStatus":"Not Done","CASAScreeningDate":"","CASARiskStatus":"","CASAReferenceNumber":"","CASAAnalystComments":"","campaignName":"VA - Virtual Advice Inbound","campaignCode":"1-1749031401","callStartDateTime":"","callId":"","adviserBRID":"A59153321","adviserABNumber":"ABJMA96"}';
        
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {'Get Client Details', 'Get Joint Participant', 'Get Client Details By Id CIF', 'Get Involved Parties'});
        Test.setMock(HttpCalloutMock.class, new AccountCreate_CIF_MDM_Test.AccountCreate_CIF_MDM_Mock_ApiRest(StringConstants.POSITIVE_STRING, StringConstants.NEGATIVE_STRING, StringConstants.POSITIVE_STRING, StringConstants.NEGATIVE_STRING, 'NoIndv', null));
        
        CreateOpportunity_Req_IB_v1 requestBean = (CreateOpportunity_Req_IB_v1)JSON.deserialize(createOpportunityRequestBody, CreateOpportunity_Req_IB_v1.class);
        
        RestRequest request = new RestRequest();
        //Use the current base url - this is done to send headers with the request
        request.requestUri = System.URL.getSalesforceBaseURL().toExternalForm() + '/services/apexrest/createOpportunity/v02';
        request.httpMethod = 'POST';
        request.addHeader('transactionId', '1234');
        request.addHeader('initiator', 'John');
        request.addHeader('sender', 'Test System');
        RestContext.request = request;
        
        Test.startTest();
        
        string response = CreateOpportunity_ApiRest_v2.createOpportunity(requestBean);
        System.debug(response);
        
        Test.stopTest();
    }
    
    public static testMethod void testCreateOpportunityIndividualPositiveNoIndBadResp(){
        
        String createOpportunityRequestBody = '{"willNumber":"","postalAddressSuburb":"CENTRAL","postalAddressPostalCode":"6229","postalAddressLine2":"","postalAddressLine1":"123 WF NKOMO","postalAddressCountry":"","postalAddressCity":"UITENHAGE","physicalAddressSuburb":"CENTRAL","physicalAddressPostalCode":"6229","physicalAddressLine2":"","physicalAddressLine1":"123 WF NKOMO","physicalAddressCountry":"South Africa","physicalAddressCity":"UITENHAGE","origLeadId":"1-VOYZGM","origAdviserBRID":"A59153321","origAdviserABNumber":"ABJMA96","opptyType":"Cross Sell","opptySubProduct":"Estate Provider Plan","opptySouceType":"Siebel Campaign","opptySalesChannel":"Virtual Advisor","opptyProduct":"Estate Provider Plan","opptyName":"LESEGO LEBOTSE - EPP","estateValue":"","clientWorkNumber":"+270115563232","clientType":"Individual","clientTitle":"Mrs","clientSourceofIncome":"","clientPrefLanguage":"","clientOnboardingChannel":"Siebel System","clientOccupationStatus":"Full time Employed","clientOccupationCategory":"","clientOccupation":"Accountant","clientNationality":"South Africa","clientMaritalStatus":"Married","clientMaritalContractType":"By community of property","clientLastName":"LEBOTSE","clientInitials":"L","clientIncomeBracket":"","clientIdType":"SA Identity Document","clientIdNumber":"9012090586088","clientId":"1-VOYLJJ","clientHomeNumber":"","clientGender":"Female","clientFirstName":"LESEGO","clientEmail":"jamie.muir@absa.co.za","clientDOB":"1990-12-09","clientCountryofResidence":"","clientCountryofBirth":"South Africa","clientCIFCode":"LEBOTL 001","clientCellNumber":"+270660000000","CASAScreeningStatus":"Not Done","CASAScreeningDate":"","CASARiskStatus":"","CASAReferenceNumber":"","CASAAnalystComments":"","campaignName":"VA - Virtual Advice Inbound","campaignCode":"1-1749031401","callStartDateTime":"","callId":"","adviserBRID":"A59153321","adviserABNumber":"ABJMA96"}';
        
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {'Get Client Details', 'Get Joint Participant', 'Get Client Details By Id CIF', 'Get Involved Parties'});
        Test.setMock(HttpCalloutMock.class, new AccountCreate_CIF_MDM_Test.AccountCreate_CIF_MDM_Mock_ApiRest(StringConstants.POSITIVE_STRING, StringConstants.POSITIVE_STRING, StringConstants.POSITIVE_STRING, StringConstants.POSITIVE_STRING, 'NoIndvBadResp', null));
        
        CreateOpportunity_Req_IB_v1 requestBean = (CreateOpportunity_Req_IB_v1)JSON.deserialize(createOpportunityRequestBody, CreateOpportunity_Req_IB_v1.class);
        
        RestRequest request = new RestRequest();
        //Use the current base url - this is done to send headers with the request
        request.requestUri = System.URL.getSalesforceBaseURL().toExternalForm() + '/services/apexrest/createOpportunity/v02';
        request.httpMethod = 'POST';
        request.addHeader('transactionId', '1234');
        request.addHeader('initiator', 'John');
        request.addHeader('sender', 'Test System');
        RestContext.request = request;
        
        Test.startTest();
        
        string response = CreateOpportunity_ApiRest_v2.createOpportunity(requestBean);
        System.debug(response);
        
        Test.stopTest();
    }
    
    public static testMethod void testCreateOpportunityIndividualInvalidClientType(){
        
        String createOpportunityRequestBody = '{"willNumber":"","postalAddressSuburb":"CENTRAL","postalAddressPostalCode":"6229","postalAddressLine2":"","postalAddressLine1":"123 WF NKOMO","postalAddressCountry":"","postalAddressCity":"UITENHAGE","physicalAddressSuburb":"CENTRAL","physicalAddressPostalCode":"6229","physicalAddressLine2":"","physicalAddressLine1":"123 WF NKOMO","physicalAddressCountry":"South Africa","physicalAddressCity":"UITENHAGE","origLeadId":"1-VOYZGM","origAdviserBRID":"A59153321","origAdviserABNumber":"ABJMA96","opptyType":"Cross Sell","opptySubProduct":"Estate Provider Plan","opptySouceType":"Siebel Campaign","opptySalesChannel":"Virtual Advisor","opptyProduct":"Estate Provider Plan","opptyName":"LESEGO LEBOTSE - EPP","estateValue":"","clientWorkNumber":"+270115563232","clientType":"Error","clientTitle":"Mrs","clientSourceofIncome":"","clientPrefLanguage":"","clientOnboardingChannel":"Siebel System","clientOccupationStatus":"Full time Employed","clientOccupationCategory":"","clientOccupation":"Accountant","clientNationality":"South Africa","clientMaritalStatus":"Married","clientMaritalContractType":"By community of property","clientLastName":"LEBOTSE","clientInitials":"L","clientIncomeBracket":"","clientIdType":"SA Identity Document","clientIdNumber":"9012090586088","clientId":"1-VOYLJJ","clientHomeNumber":"","clientGender":"Female","clientFirstName":"LESEGO","clientEmail":"jamie.muir@absa.co.za","clientDOB":"1990-12-09","clientCountryofResidence":"","clientCountryofBirth":"South Africa","clientCIFCode":"LEBOTL 001","clientCellNumber":"+270660000000","CASAScreeningStatus":"Not Done","CASAScreeningDate":"","CASARiskStatus":"","CASAReferenceNumber":"","CASAAnalystComments":"","campaignName":"VA - Virtual Advice Inbound","campaignCode":"1-1749031401","callStartDateTime":"","callId":"","adviserBRID":"A59153321","adviserABNumber":"ABJMA96"}';
        
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {'Get Client Details', 'Get Joint Participant', 'Get Client Details By Id CIF', 'Get Involved Parties'});
        Test.setMock(HttpCalloutMock.class, new AccountCreate_CIF_MDM_Test.AccountCreate_CIF_MDM_Mock_ApiRest(StringConstants.POSITIVE_STRING, StringConstants.POSITIVE_STRING, StringConstants.POSITIVE_STRING, StringConstants.POSITIVE_STRING, 'Individual', null));
        
        CreateOpportunity_Req_IB_v1 requestBean = (CreateOpportunity_Req_IB_v1)JSON.deserialize(createOpportunityRequestBody, CreateOpportunity_Req_IB_v1.class);
        
        RestRequest request = new RestRequest();
        //Use the current base url - this is done to send headers with the request
        request.requestUri = System.URL.getSalesforceBaseURL().toExternalForm() + '/services/apexrest/createOpportunity/v02';
        request.httpMethod = 'POST';
        request.addHeader('transactionId', '1234');
        request.addHeader('initiator', 'John');
        request.addHeader('sender', 'Test System');
        RestContext.request = request;
        
        Test.startTest();
        
        string response = CreateOpportunity_ApiRest_v2.createOpportunity(requestBean);
        System.debug(response);
        
        Test.stopTest();
    }
    
    public static testMethod void testCreateOpportunityNegativeNoBRID(){
        
        String createOpportunityRequestBody = '{"willNumber":"","postalAddressSuburb":"CENTRAL","postalAddressPostalCode":"6229","postalAddressLine2":"","postalAddressLine1":"123 WF NKOMO","postalAddressCountry":"","postalAddressCity":"UITENHAGE","physicalAddressSuburb":"CENTRAL","physicalAddressPostalCode":"6229","physicalAddressLine2":"","physicalAddressLine1":"123 WF NKOMO","physicalAddressCountry":"South Africa","physicalAddressCity":"UITENHAGE","origLeadId":"1-VOYZGM","origAdviserBRID":"A59153321","origAdviserABNumber":"ABJMA96","opptyType":"Cross Sell","opptySubProduct":"Estate Provider Plan","opptySouceType":"Siebel Campaign","opptySalesChannel":"Virtual Advisor","opptyProduct":"Estate Provider Plan","opptyName":"LESEGO LEBOTSE - EPP","estateValue":"","clientWorkNumber":"+270115563232","clientType":"Individual","clientTitle":"Mrs","clientSourceofIncome":"","clientPrefLanguage":"","clientOnboardingChannel":"Siebel System","clientOccupationStatus":"Full time Employed","clientOccupationCategory":"","clientOccupation":"Accountant","clientNationality":"South Africa","clientMaritalStatus":"Married","clientMaritalContractType":"By community of property","clientLastName":"LEBOTSE","clientInitials":"L","clientIncomeBracket":"","clientIdType":"SA Identity Document","clientIdNumber":"9012090586088","clientId":"1-VOYLJJ","clientHomeNumber":"","clientGender":"Female","clientFirstName":"LESEGO","clientEmail":"jamie.muir@absa.co.za","clientDOB":"1990-12-09","clientCountryofResidence":"","clientCountryofBirth":"South Africa","clientCIFCode":"LEBOTL 001","clientCellNumber":"+270660000000","CASAScreeningStatus":"Not Done","CASAScreeningDate":"","CASARiskStatus":"","CASAReferenceNumber":"","CASAAnalystComments":"","campaignName":"VA - Virtual Advice Inbound","campaignCode":"1-1749031401","callStartDateTime":"","callId":"","adviserBRID":"123411","adviserABNumber":"ABJMA96"}';
        
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {'Get Client Details', 'Get Joint Participant', 'Get Client Details By Id CIF', 'Get Involved Parties'});
        Test.setMock(HttpCalloutMock.class, new AccountCreate_CIF_MDM_Test.AccountCreate_CIF_MDM_Mock_ApiRest(StringConstants.POSITIVE_STRING, StringConstants.POSITIVE_STRING, StringConstants.POSITIVE_STRING, StringConstants.POSITIVE_STRING, 'Joint Account', null));
        
        CreateOpportunity_Req_IB_v1 requestBean = (CreateOpportunity_Req_IB_v1)JSON.deserialize(createOpportunityRequestBody, CreateOpportunity_Req_IB_v1.class);
        
        RestRequest request = new RestRequest();
        //Use the current base url - this is done to send headers with the request
        request.requestUri = System.URL.getSalesforceBaseURL().toExternalForm() + '/services/apexrest/createOpportunity/v02';
        request.httpMethod = 'POST';
        request.addHeader('transactionId', '1234');
        request.addHeader('initiator', 'John');
        request.addHeader('sender', 'Test System');
        RestContext.request = request;
        
        Test.startTest();
        
        string response = CreateOpportunity_ApiRest_v2.createOpportunity(requestBean);
        System.debug(response);
        
        Test.stopTest();
    }
    
    public static testMethod void testCreateOpportunityJointPositive(){
        
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey='Africa/Johannesburg',
                          UserName=uniqueUserName);
        
        String createOpportunityRequestBody = '{"willNumber":"","postalAddressSuburb":"CENTRAL","postalAddressPostalCode":"6229","postalAddressLine2":"","postalAddressLine1":"123 WF NKOMO","postalAddressCountry":"","postalAddressCity":"UITENHAGE","physicalAddressSuburb":"CENTRAL","physicalAddressPostalCode":"6229","physicalAddressLine2":"","physicalAddressLine1":"123 WF NKOMO","physicalAddressCountry":"South Africa","physicalAddressCity":"UITENHAGE","origLeadId":"1-VOYZGM","origAdviserBRID":"A59153321","origAdviserABNumber":"ABJMA96","opptyType":"Cross Sell","opptySubProduct":"Estate Provider Plan","opptySouceType":"Siebel Campaign","opptySalesChannel":"Virtual Advisor","opptyProduct":"Estate Provider Plan","opptyName":"LESEGO LEBOTSE - EPP","estateValue":"","clientWorkNumber":"+270115563232","clientType":"Joint & Several","clientTitle":"Mrs","clientSourceofIncome":"","clientPrefLanguage":"","clientOnboardingChannel":"Siebel System","clientOccupationStatus":"Full time Employed","clientOccupationCategory":"","clientOccupation":"Accountant","clientNationality":"South Africa","clientMaritalStatus":"Married","clientMaritalContractType":"By community of property","clientLastName":"LEBOTSE","clientInitials":"L","clientIncomeBracket":"","clientIdType":"SA Identity Document","clientIdNumber":"9012090586088","clientId":"1-VOYLJJ","clientHomeNumber":"","clientGender":"Female","clientFirstName":"LESEGO","clientEmail":"jamie.muir@absa.co.za","clientDOB":"1990-12-09","clientCountryofResidence":"","clientCountryofBirth":"South Africa","clientCIFCode":"LEBOTL 001","clientCellNumber":"+270660000000","CASAScreeningStatus":"Not Done","CASAScreeningDate":"","CASARiskStatus":"","CASAReferenceNumber":"","CASAAnalystComments":"","campaignName":"VA - Virtual Advice Inbound","campaignCode":"1-1749031401","callStartDateTime":"","callId":"","adviserBRID":"A59153321","adviserABNumber":"ABJMA96"}';
        
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {'Get Client Details', 'Get Joint Participant', 'Get Client Details By Id CIF', 'Get Involved Parties'});
        Test.setMock(HttpCalloutMock.class, new AccountCreate_CIF_MDM_Test.AccountCreate_CIF_MDM_Mock_ApiRest(StringConstants.POSITIVE_STRING, StringConstants.POSITIVE_STRING, StringConstants.POSITIVE_STRING, StringConstants.POSITIVE_STRING, 'Joint Account', null));
        
        CreateOpportunity_Req_IB_v1 requestBean = (CreateOpportunity_Req_IB_v1)JSON.deserialize(createOpportunityRequestBody, CreateOpportunity_Req_IB_v1.class);
        
        RestRequest request = new RestRequest();
        //Use the current base url - this is done to send headers with the request
        request.requestUri = System.URL.getSalesforceBaseURL().toExternalForm() + '/services/apexrest/createOpportunity/v02';
        request.httpMethod = 'POST';
        request.addHeader('transactionId', '1234');
        request.addHeader('initiator', 'John');
        request.addHeader('sender', 'Test System');
        RestContext.request = request;
        
        Test.startTest();        
        System.runAs(u) {
            string response = CreateOpportunity_ApiRest_v2.createOpportunity(requestBean);
        System.debug(response);
        }
        Test.stopTest();
    }
    
    public static testMethod void testCreateOpportunityJointPositiveNoJnt(){
        
        String createOpportunityRequestBody = '{"willNumber":"","postalAddressSuburb":"CENTRAL","postalAddressPostalCode":"6229","postalAddressLine2":"","postalAddressLine1":"123 WF NKOMO","postalAddressCountry":"","postalAddressCity":"UITENHAGE","physicalAddressSuburb":"CENTRAL","physicalAddressPostalCode":"6229","physicalAddressLine2":"","physicalAddressLine1":"123 WF NKOMO","physicalAddressCountry":"South Africa","physicalAddressCity":"UITENHAGE","origLeadId":"1-VOYZGM","origAdviserBRID":"A59153321","origAdviserABNumber":"ABJMA96","opptyType":"Cross Sell","opptySubProduct":"Estate Provider Plan","opptySouceType":"Siebel Campaign","opptySalesChannel":"Virtual Advisor","opptyProduct":"Estate Provider Plan","opptyName":"LESEGO LEBOTSE - EPP","estateValue":"","clientWorkNumber":"+270115563232","clientType":"Joint & Several","clientTitle":"Mrs","clientSourceofIncome":"","clientPrefLanguage":"","clientOnboardingChannel":"Siebel System","clientOccupationStatus":"Full time Employed","clientOccupationCategory":"","clientOccupation":"Accountant","clientNationality":"South Africa","clientMaritalStatus":"Married","clientMaritalContractType":"By community of property","clientLastName":"LEBOTSE","clientInitials":"L","clientIncomeBracket":"","clientIdType":"SA Identity Document","clientIdNumber":"9012090586088","clientId":"1-VOYLJJ","clientHomeNumber":"","clientGender":"Female","clientFirstName":"LESEGO","clientEmail":"jamie.muir@absa.co.za","clientDOB":"1990-12-09","clientCountryofResidence":"","clientCountryofBirth":"South Africa","clientCIFCode":"LEBOTL 001","clientCellNumber":"+270660000000","CASAScreeningStatus":"Not Done","CASAScreeningDate":"","CASARiskStatus":"","CASAReferenceNumber":"","CASAAnalystComments":"","campaignName":"VA - Virtual Advice Inbound","campaignCode":"1-1749031401","callStartDateTime":"","callId":"","adviserBRID":"A59153321","adviserABNumber":"ABJMA96"}';
        
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {'Get Client Details', 'Get Joint Participant', 'Get Client Details By Id CIF', 'Get Involved Parties'});
        Test.setMock(HttpCalloutMock.class, new AccountCreate_CIF_MDM_Test.AccountCreate_CIF_MDM_Mock_ApiRest(StringConstants.POSITIVE_STRING, StringConstants.POSITIVE_STRING, StringConstants.POSITIVE_STRING, StringConstants.POSITIVE_STRING, 'NoJnt', null));
        
        CreateOpportunity_Req_IB_v1 requestBean = (CreateOpportunity_Req_IB_v1)JSON.deserialize(createOpportunityRequestBody, CreateOpportunity_Req_IB_v1.class);
        
        RestRequest request = new RestRequest();
        //Use the current base url - this is done to send headers with the request
        request.requestUri = System.URL.getSalesforceBaseURL().toExternalForm() + '/services/apexrest/createOpportunity/v02';
        request.httpMethod = 'POST';
        request.addHeader('transactionId', '1234');
        request.addHeader('initiator', 'John');
        request.addHeader('sender', 'Test System');
        RestContext.request = request;
        
        Test.startTest();
        
        string response = CreateOpportunity_ApiRest_v2.createOpportunity(requestBean);
        System.debug(response);
        
        Test.stopTest();
    }
    
    public static testMethod void testCreateOpportunityJointNegative(){
        
        String createOpportunityRequestBody = '{"willNumber":"","postalAddressSuburb":"CENTRAL","postalAddressPostalCode":"6229","postalAddressLine2":"","postalAddressLine1":"123 WF NKOMO","postalAddressCountry":"","postalAddressCity":"UITENHAGE","physicalAddressSuburb":"CENTRAL","physicalAddressPostalCode":"6229","physicalAddressLine2":"","physicalAddressLine1":"123 WF NKOMO","physicalAddressCountry":"South Africa","physicalAddressCity":"UITENHAGE","origLeadId":"1-VOYZGM","origAdviserBRID":"A59153321","origAdviserABNumber":"ABJMA96","opptyType":"Cross Sell","opptySubProduct":"Estate Provider Plan","opptySouceType":"Siebel Campaign","opptySalesChannel":"Virtual Advisor","opptyProduct":"Estate Provider Plan","opptyName":"LESEGO LEBOTSE - EPP","estateValue":"","clientWorkNumber":"+270115563232","clientType":"Joint & Several","clientTitle":"Mrs","clientSourceofIncome":"","clientPrefLanguage":"","clientOnboardingChannel":"Siebel System","clientOccupationStatus":"Full time Employed","clientOccupationCategory":"","clientOccupation":"Accountant","clientNationality":"South Africa","clientMaritalStatus":"Married","clientMaritalContractType":"By community of property","clientLastName":"LEBOTSE","clientInitials":"L","clientIncomeBracket":"","clientIdType":"SA Identity Document","clientIdNumber":"9012090586088","clientId":"1-VOYLJJ","clientHomeNumber":"","clientGender":"Female","clientFirstName":"LESEGO","clientEmail":"jamie.muir@absa.co.za","clientDOB":"1990-12-09","clientCountryofResidence":"","clientCountryofBirth":"South Africa","clientCIFCode":"LEBOTL 001","clientCellNumber":"+270660000000","CASAScreeningStatus":"Not Done","CASAScreeningDate":"","CASARiskStatus":"","CASAReferenceNumber":"","CASAAnalystComments":"","campaignName":"VA - Virtual Advice Inbound","campaignCode":"1-1749031401","callStartDateTime":"","callId":"","adviserBRID":"A59153321","adviserABNumber":"ABJMA96"}';
        
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {'Get Client Details', 'Get Joint Participant', 'Get Client Details By Id CIF', 'Get Involved Parties'});
        Test.setMock(HttpCalloutMock.class, new AccountCreate_CIF_MDM_Test.AccountCreate_CIF_MDM_Mock_ApiRest(StringConstants.NEGATIVE_STRING, StringConstants.NEGATIVE_STRING, StringConstants.POSITIVE_STRING, StringConstants.NEGATIVE_STRING, 'Joint Account', null));
        
        CreateOpportunity_Req_IB_v1 requestBean = (CreateOpportunity_Req_IB_v1)JSON.deserialize(createOpportunityRequestBody, CreateOpportunity_Req_IB_v1.class);
        
        RestRequest request = new RestRequest();
        //Use the current base url - this is done to send headers with the request
        request.requestUri = System.URL.getSalesforceBaseURL().toExternalForm() + '/services/apexrest/createOpportunity/v02';
        request.httpMethod = 'POST';
        request.addHeader('transactionId', '1234');
        request.addHeader('initiator', 'John');
        request.addHeader('sender', 'Test System');
        RestContext.request = request;
        
        Test.startTest();
        
        string response = CreateOpportunity_ApiRest_v2.createOpportunity(requestBean);
        System.debug(response);
        
        Test.stopTest();
    }
    
    public static testMethod void testCreateOpportunityJointNoIntegrationSettingsNegative1(){
        
        String createOpportunityRequestBody = '{"willNumber":"","postalAddressSuburb":"CENTRAL","postalAddressPostalCode":"6229","postalAddressLine2":"","postalAddressLine1":"123 WF NKOMO","postalAddressCountry":"","postalAddressCity":"UITENHAGE","physicalAddressSuburb":"CENTRAL","physicalAddressPostalCode":"6229","physicalAddressLine2":"","physicalAddressLine1":"123 WF NKOMO","physicalAddressCountry":"South Africa","physicalAddressCity":"UITENHAGE","origLeadId":"1-VOYZGM","origAdviserBRID":"A59153321","origAdviserABNumber":"ABJMA96","opptyType":"Cross Sell","opptySubProduct":"Estate Provider Plan","opptySouceType":"Siebel Campaign","opptySalesChannel":"Virtual Advisor","opptyProduct":"Estate Provider Plan","opptyName":"LESEGO LEBOTSE - EPP","estateValue":"","clientWorkNumber":"+270115563232","clientType":"Joint & Several","clientTitle":"Mrs","clientSourceofIncome":"","clientPrefLanguage":"","clientOnboardingChannel":"Siebel System","clientOccupationStatus":"Full time Employed","clientOccupationCategory":"","clientOccupation":"Accountant","clientNationality":"South Africa","clientMaritalStatus":"Married","clientMaritalContractType":"By community of property","clientLastName":"LEBOTSE","clientInitials":"L","clientIncomeBracket":"","clientIdType":"SA Identity Document","clientIdNumber":"9012090586088","clientId":"1-VOYLJJ","clientHomeNumber":"","clientGender":"Female","clientFirstName":"LESEGO","clientEmail":"jamie.muir@absa.co.za","clientDOB":"1990-12-09","clientCountryofResidence":"","clientCountryofBirth":"South Africa","clientCIFCode":"LEBOTL 001","clientCellNumber":"+270660000000","CASAScreeningStatus":"Not Done","CASAScreeningDate":"","CASARiskStatus":"","CASAReferenceNumber":"","CASAAnalystComments":"","campaignName":"VA - Virtual Advice Inbound","campaignCode":"1-1749031401","callStartDateTime":"","callId":"","adviserBRID":"A59153321","adviserABNumber":"ABJMA96"}';
        
        Test.setMock(HttpCalloutMock.class, new AccountCreate_CIF_MDM_Test.AccountCreate_CIF_MDM_Mock_ApiRest(StringConstants.POSITIVE_STRING, StringConstants.POSITIVE_STRING, StringConstants.POSITIVE_STRING, StringConstants.POSITIVE_STRING, 'Joint Account', null));
        
        CreateOpportunity_Req_IB_v1 requestBean = (CreateOpportunity_Req_IB_v1)JSON.deserialize(createOpportunityRequestBody, CreateOpportunity_Req_IB_v1.class);
        
        RestRequest request = new RestRequest();
        //Use the current base url - this is done to send headers with the request
        request.requestUri = System.URL.getSalesforceBaseURL().toExternalForm() + '/services/apexrest/createOpportunity/v02';
        request.httpMethod = 'POST';
        request.addHeader('transactionId', '1234');
        request.addHeader('initiator', 'John');
        request.addHeader('sender', 'Test System');
        RestContext.request = request;
        
        Test.startTest();
        
        string response = CreateOpportunity_ApiRest_v2.createOpportunity(requestBean);
        System.debug(response);
        
        Test.stopTest();
    }
    
    public static testMethod void testCreateOpportunityJointNoIntegrationSettingsNegative2(){
        
        String createOpportunityRequestBody = '{"willNumber":"","postalAddressSuburb":"CENTRAL","postalAddressPostalCode":"6229","postalAddressLine2":"","postalAddressLine1":"123 WF NKOMO","postalAddressCountry":"","postalAddressCity":"UITENHAGE","physicalAddressSuburb":"CENTRAL","physicalAddressPostalCode":"6229","physicalAddressLine2":"","physicalAddressLine1":"123 WF NKOMO","physicalAddressCountry":"South Africa","physicalAddressCity":"UITENHAGE","origLeadId":"1-VOYZGM","origAdviserBRID":"A59153321","origAdviserABNumber":"ABJMA96","opptyType":"Cross Sell","opptySubProduct":"Estate Provider Plan","opptySouceType":"Siebel Campaign","opptySalesChannel":"Virtual Advisor","opptyProduct":"Estate Provider Plan","opptyName":"LESEGO LEBOTSE - EPP","estateValue":"","clientWorkNumber":"+270115563232","clientType":"Joint & Several","clientTitle":"Mrs","clientSourceofIncome":"","clientPrefLanguage":"","clientOnboardingChannel":"Siebel System","clientOccupationStatus":"Full time Employed","clientOccupationCategory":"","clientOccupation":"Accountant","clientNationality":"South Africa","clientMaritalStatus":"Married","clientMaritalContractType":"By community of property","clientLastName":"LEBOTSE","clientInitials":"L","clientIncomeBracket":"","clientIdType":"SA Identity Document","clientIdNumber":"9012090586088","clientId":"1-VOYLJJ","clientHomeNumber":"","clientGender":"Female","clientFirstName":"LESEGO","clientEmail":"jamie.muir@absa.co.za","clientDOB":"1990-12-09","clientCountryofResidence":"","clientCountryofBirth":"South Africa","clientCIFCode":"LEBOTL 001","clientCellNumber":"+270660000000","CASAScreeningStatus":"Not Done","CASAScreeningDate":"","CASARiskStatus":"","CASAReferenceNumber":"","CASAAnalystComments":"","campaignName":"VA - Virtual Advice Inbound","campaignCode":"1-1749031401","callStartDateTime":"","callId":"","adviserBRID":"A59153321","adviserABNumber":"ABJMA96"}';
        
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {'Get Client Details', 'Get Client Details By Id CIF'});
        Test.setMock(HttpCalloutMock.class, new AccountCreate_CIF_MDM_Test.AccountCreate_CIF_MDM_Mock_ApiRest(StringConstants.POSITIVE_STRING, StringConstants.POSITIVE_STRING, StringConstants.POSITIVE_STRING, StringConstants.POSITIVE_STRING, 'Joint Account', null));
        
        CreateOpportunity_Req_IB_v1 requestBean = (CreateOpportunity_Req_IB_v1)JSON.deserialize(createOpportunityRequestBody, CreateOpportunity_Req_IB_v1.class);
        
        RestRequest request = new RestRequest();
        //Use the current base url - this is done to send headers with the request
        request.requestUri = System.URL.getSalesforceBaseURL().toExternalForm() + '/services/apexrest/createOpportunity/v02';
        request.httpMethod = 'POST';
        request.addHeader('transactionId', '1234');
        request.addHeader('initiator', 'John');
        request.addHeader('sender', 'Test System');
        RestContext.request = request;
        
        Test.startTest();
        
        string response = CreateOpportunity_ApiRest_v2.createOpportunity(requestBean);
        System.debug(response);
        
        Test.stopTest();
    }
    
    public static testMethod void testCreateOpportunityNegative(){
        
        String createOpportunityRequestBody = '{"willNumber":"","postalAddressSuburb":"CENTRAL","postalAddressPostalCode":"6229","postalAddressLine2":"","postalAddressLine1":"123 WF NKOMO","postalAddressCountry":"","postalAddressCity":"UITENHAGE","physicalAddressSuburb":"CENTRAL","physicalAddressPostalCode":"6229","physicalAddressLine2":"","physicalAddressLine1":"123 WF NKOMO","physicalAddressCountry":"South Africa","physicalAddressCity":"UITENHAGE","origLeadId":"1-VOYZGM","origAdviserBRID":"A59153321","origAdviserABNumber":"ABJMA96","opptyType":"Cross Sell","opptySubProduct":"Estate Provider Plan","opptySouceType":"Siebel Campaign","opptySalesChannel":"Virtual Advisor","opptyProduct":"Estate Provider Plan","opptyName":"LESEGO LEBOTSE - EPP","estateValue":"","clientWorkNumber":"+270115563232","clientType":"Individual","clientTitle":"Mrs","clientSourceofIncome":"","clientPrefLanguage":"","clientOnboardingChannel":"Siebel System","clientOccupationStatus":"Full time Employed","clientOccupationCategory":"","clientOccupation":"Accountant","clientNationality":"South Africa","clientMaritalStatus":"Married","clientMaritalContractType":"By community of property","clientLastName":"LEBOTSE","clientInitials":"L","clientIncomeBracket":"","clientIdType":"SA Identity Document","clientIdNumber":"9012090586088","clientId":"1-VOYLJJ","clientHomeNumber":"","clientGender":"Female","clientFirstName":"LESEGO","clientEmail":"jamie.muir@absa.co.za","clientDOB":"1990-12-09","clientCountryofResidence":"","clientCountryofBirth":"South Africa","clientCIFCode":"LEBOTL 001","clientCellNumber":"+270660000000","CASAScreeningStatus":"Not Done","CASAScreeningDate":"","CASARiskStatus":"","CASAReferenceNumber":"","CASAAnalystComments":"","campaignName":"VA - Virtual Advice Inbound","campaignCode":"1-1749031401","callStartDateTime":"","callId":"","adviserBRID":"A59153321","adviserABNumber":"ABJMA96"}';
        
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {'Get Client Details', 'Get Joint Participant', 'Get Client Details By Id CIF', 'Get Involved Parties'});
        Test.setMock(HttpCalloutMock.class, new AccountCreate_CIF_MDM_Test.AccountCreate_CIF_MDM_Mock_ApiRest(StringConstants.POSITIVE_STRING, StringConstants.POSITIVE_STRING, StringConstants.POSITIVE_STRING, StringConstants.POSITIVE_STRING, 'Joint Account', null));
        
        CreateOpportunity_Req_IB_v1 requestBean = (CreateOpportunity_Req_IB_v1)JSON.deserialize(createOpportunityRequestBody, CreateOpportunity_Req_IB_v1.class);

        Test.startTest();
        
        string response = CreateOpportunity_ApiRest_v2.createOpportunity(requestBean);
        System.debug(response);
        
        Test.stopTest();
    }
}