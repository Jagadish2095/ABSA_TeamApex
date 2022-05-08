@isTest
global class GetRegulatoryComplianceMock_ApiRest implements HttpCalloutMock 
{
    Private String typeTest;
    
    global GetRegulatoryComplianceMock_ApiRest (final String typeTest)
    {
        this.typeTest = typeTest;
    }
    
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) 
    {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader(StringConstants.CONTENT_TYPE_STRING, 'application/json');
      
        if(typeTest == StringConstants.POSITIVE_STRING)
        {
            response.setBody('{ "content":{ "missingDocuments":[ { "code":"ProofOfId", "description":"ProofOfId" }, { "code":"ProofOfAddress", "description":"ProofOfAddress" } ], "missingData":[ "cityOfResidence", "countryOfResidence", "residentialAddress", "occupationOrTypeOfBusiness", "sourceOfIncome" ], "reusableDocuments":[ { "source":"CRS", "lastRefreshDate":"2014-07-12", "nextRefreshDate":"2024-03-15", "receivedDate":"2014-07-12", "uniqueIdInSourceSystem":"Test1903140002", "vettedDate":"2014-07-12", "context":null, "type":{ "code":"ProofOfId", "description":"ProofOfId" } } ], "refreshableDocuments":[ { "source":"CRS", "lastRefreshDate":"2018-06-04", "nextRefreshDate":"2019-06-04", "receivedDate":"2018-06-04", "uniqueIdInSourceSystem":"Test1902040002", "vettedDate":"2018-06-04", "context":null, "type":{ "code":"ProofOfId", "description":"ProofOfId" } } ], "partyFlags":[ { "effectiveDate":"2018-09-10", "yesNoFlag":true, "type":{ "code":"Contact method : Email", "description":"Contact method : Email" }, "status":"Yes" }, { "effectiveDate":"2018-09-10", "yesNoFlag":true, "type":{ "code":"Marketing Consent", "description":"Marketing Consent" }, "status":"Yes" }, { "effectiveDate":"2018-09-10", "yesNoFlag":false, "type":{ "code":"Marketing Preference : Call", "description":"Marketing Preference : Call" }, "status":"No" }, { "effectiveDate":"2018-09-10", "yesNoFlag":true, "type":{ "code":"Marketing Preference: Email", "description":"Marketing Preference: Email" }, "status":"Yes" }, { "effectiveDate":"2018-09-10", "yesNoFlag":false, "type":{ "code":"Marketing Preference: Mail", "description":"Marketing Preference: Mail" }, "status":"No" }, { "effectiveDate":"2018-09-10", "yesNoFlag":true, "type":{ "code":"Marketing Preference: SMS", "description":"Marketing Preference: SMS" }, "status":"Yes" }, { "effectiveDate":null, "yesNoFlag":false, "type":{ "code":"SBU Segment", "description":"SBU Segment" }, "status":"F" } ] }, "links":[] }');            
            response.setStatusCode(200);
        }
        else if(typeTest == StringConstants.NEGATIVE_STRING)
        {
            response.setBody(StringConstants.ERROR_MSG_READ_TIMED_OUT);
            response.setStatusCode(400);
        }
        else if(typeTest == StringConstants.UNHANDLED_EXCEPTION_STATUS)
        {
            response.setBody('{}');
            response.setStatusCode(500);
        }
        return response; 
    }
}