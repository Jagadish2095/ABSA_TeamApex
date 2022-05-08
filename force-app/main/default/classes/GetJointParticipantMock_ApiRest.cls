@isTest
global class GetJointParticipantMock_ApiRest implements HttpCalloutMock
{
    Private String typeTest;
    
    global GetJointParticipantMock_ApiRest (final String typeTest)
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
            response.setBody('{"nbrRetrv":"2","jntEntry":[{"idDocType":"1","idNumber":"8505057384091","initials":"M","titleCode":"1","surname":"GAJBAJIA","resAddrLine1":"UNIT-30","resAddrLine2":"NOTTING HILL","resSuburb":"FERNDALE","resTown":"FERNDALE","resPosCde":"2194","firstNames":"MEERA","homeTelCode":"0","homeTelephone":"","workTelCode":"0","workTelephone":"","cellphone":"616133895","practiceNumber":"","birthDate":"19850505","sourceOfIncome":"20","dateIdentified":"0","dateVerified":"0","employeeIdentified":"","employeeVerified":"","taxNumber":"0","clientNationality":"SOU01","countryOfOrigin":"","tempPermitNumber":"","permitExpiryDate":"0","homeTcodex":"","workTcodex":"","cellx":"0616133895","groupScheme":"0","groupSchemeEmp":"","dateIssued":"0","dateExempted":"0","empExempted":"","statusOfExempt":"","exemptionInd":"","countryOfRes":"SO003","countryOfBirth":"SO003","occupationStatus":"5","occupationCode":"1","saTaxRegis":"","rsonSaTaxNotGiven":"","foreignTaxRegis":"","foreignTaxData":[{"foreignTaxCtry":"","foreignTaxNo":"","rsonFtaxNotGiven":""},{"foreignTaxCtry":"","foreignTaxNo":"","rsonFtaxNotGiven":""},{"foreignTaxCtry":"","foreignTaxNo":"","rsonFtaxNotGiven":""},{"foreignTaxCtry":"","foreignTaxNo":"","rsonFtaxNotGiven":""}]},{"idDocType":"1","idNumber":"8505059291096","initials":"S","titleCode":"1","surname":"RAMAN","resAddrLine1":"UNIT-30","resAddrLine2":"NOTTING HILL","resSuburb":"FERNDALE","resTown":"FERNDALE","resPosCde":"2194","firstNames":"SITA","homeTelCode":"0","homeTelephone":"","workTelCode":"0","workTelephone":"","cellphone":"616133895","practiceNumber":"","birthDate":"19850505","sourceOfIncome":"20","dateIdentified":"0","dateVerified":"0","employeeIdentified":"","employeeVerified":"","taxNumber":"0","clientNationality":"SOU01","countryOfOrigin":"","tempPermitNumber":"","permitExpiryDate":"0","homeTcodex":"","workTcodex":"","cellx":"0616133895","groupScheme":"0","groupSchemeEmp":"","dateIssued":"0","dateExempted":"0","empExempted":"","statusOfExempt":"","exemptionInd":"","countryOfRes":"SO003","countryOfBirth":"SO003","occupationStatus":"5","occupationCode":"2","saTaxRegis":"","rsonSaTaxNotGiven":"","foreignTaxRegis":"","foreignTaxData":[{"foreignTaxCtry":"","foreignTaxNo":"","rsonFtaxNotGiven":""},{"foreignTaxCtry":"","foreignTaxNo":"","rsonFtaxNotGiven":""},{"foreignTaxCtry":"","foreignTaxNo":"","rsonFtaxNotGiven":""},{"foreignTaxCtry":"","foreignTaxNo":"","rsonFtaxNotGiven":""}]}]}');     
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