@isTest
global class RefreshRegulatoryComplianceMock_ApiRest implements HttpCalloutMock 
{
    Private String typeTest;
    
    global RefreshRegulatoryComplianceMock_ApiRest (final String typeTest)
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
            response.setBody('{"content":{"compliance":{"nextRefreshDate":"2019-02-02","missingDocuments":[{"code":"ProofOfId","description":"ProofOfId"},{"code":"ProofOfAddress","description":"ProofOfAddress"}],"missingData":["cityOfResidence","residentialAddress","occupationOrTypeOfBusiness","sourceOfIncome"],"partyFlags":[{"effectiveDate":null,"yesNoFlag":false,"type":{"code":"TIN Not Provided","description":"TIN Not Provided"},"status":"Angola"},{"effectiveDate":"2018-09-27","yesNoFlag":true,"type":{"code":"processStatus","description":"processStatus"},"status":"In Progress"}]},"attestation":{"address":{"attestedAddress":null,"attestedAddressDocument":null,"goldenSourceAddress":{"matches":false,"document":{"source":"ECM","lastRefreshDate":null,"nextRefreshDate":null,"receivedDate":"2018-10-08","uniqueIdInSourceSystem":"92 3 ICM7 UGOLSDB13 Ext_Cust_Info59 26 A1001001A18J08B34949J1739418 A18J08B34949J173941 14 2110","vettedDate":null,"context":null,"type":{"code":"ProofOfAddress","description":"ProofOfAddress"},"subType":{"code":"CPBCertificate","description":"CPBCertificate"}},"addressName1":"ARNUD","addressName2":"","suburbName":"MALMESBURY","cityName":"MALMESBURY","postalCode":"7300"},"matches":false,"goldenSourceDocument":{"present":true}},"identification":{"attestedId":{"number":"8701215081089","type":{"code":"ID Number","description":"ID Number"},"expiryDate":null,"issueDate":"2013-07-25"},"attestedIdDocument":null,"goldenSourceId":{"number":"8701215081089","type":null,"expiryDate":null,"issueDate":"2013-01-25","ficaAttestationDate":null,"matches":true,"document":{"source":"ECM","lastRefreshDate":null,"nextRefreshDate":null,"receivedDate":"2018-10-08","uniqueIdInSourceSystem":"92 3 ICM7 UGOLSDB13 Ent_ProofOfId59 26 A1001001A18J08B34950A1739618 A18J08B34950A173961 14 1282","vettedDate":null,"context":null,"type":{"code":"ProofOfId","description":"ProofOfId"},"subType":{"code":"HANISCertificate","description":"HANISCertificate"}}},"matches":true,"goldenSourceDocument":{"present":true}}},"status":"NOTATTESABLE"}}');
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