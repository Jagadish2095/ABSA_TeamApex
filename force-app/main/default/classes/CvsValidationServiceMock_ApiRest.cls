/**
 * @description       : 
 * @author            : muvhuso.nekhubvi@absa.africa
 * @last modified on  : 2021-09-29
 * @last modified by  : muvhuso.nekhubvi@absa.africa
**/
@isTest
global class CvsValidationServiceMock_ApiRest implements HttpCalloutMock
{
    Private String typeTest;
    
    /**
    * @description 
    * @author muvhuso.nekhubvi@absa.africa | 2021-09-29 
    * @param typeTest 
    **/
    global CvsValidationServiceMock_ApiRest (final String typeTest)
    {
        this.typeTest = typeTest;
    }
    
    // Implement this interface method

    /**
    * @description 
    * @author muvhuso.nekhubvi@absa.africa | 2021-09-29 
    * @param request 
    * @return HTTPResponse 
    **/
    global HTTPResponse respond(HTTPRequest request) 
    {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader(StringConstants.CONTENT_TYPE_STRING, 'application/json');
      
        if(typeTest == StringConstants.POSITIVE_STRING)
        {
            response.setBody('{"statusCode":"0"}');
            //response.setBody('{"header":{"applicationId":"SIEBEL","clientType":"00101","clientTypeGroup":"I","errorMessagesLanguage":"EN","version":"1.0"},"client":{"surname":"TestP_surname","firstname":"TestP_firstname","initials":"T","dateOfBirth":"15111999","gender":"1","idNumber":{"documentType":"3","number":"P595959","dateIssued":"?","expiryDate":"?","countryOfIssueCode":"SO003","tempResidentPerNo":"?","permitExpiryDate":"?"},"titleCode":"1","homeLanguage":"?","correspondenceLanguage":"E","maritalStatus":"1","maritalContractType":"2","nationalityCode":"SOU01","numberOfDependants":"?","incomeTaxNo":"?","universityCode":"?","postMatricIndicator":"N","postMatricQualification":"?","residentialStatus":"?","socialGrant":"N","creditWorthinessConsent":"N","countryOfBirthCode":"SO003","clientCode":"?"},"contactInfo":{"cellPhoneNo":"0845560989","emailAddress":"testp@gmail.com","homePhone":{"dialCode":"011","number":"0115077000"},"homeFax":{"dialCode":"011","number":"0115077000"},"workPhone":{"dialCode":"011","number":"0115077000"},"workFax":{"dialCode":"011","number":"0115077000"},"homeAddress":{"line1":"1 RUBGY ST","line2":"POSTALADDRESSLINE2","suburb":"?","city":"AALWYNFLEUR","postalCode":"6670","countryCode":"SO003"},"postalAddress":{"line1":"1 RUBGY ST","line2":"POSTALADDRESSLINE2","city":"AALWYNFLEUR","postalCode":"6670","countryCode":"SO003"}},"marketingInfo":{"email":"N","mail":"N","sms":"N","telephone":"Y","massMarketing":"Y","marketingMailIndicator":"Y","preferredCommunicationChannel":"4"},"employmentInfo":{"workAddress":{"line1":"?","line2":"?","suburb":"?","city":"?","postalCode":"?","countryCode":"?"},"employerName":"?","employmentSector":"?","occupationCode":"?","occupationLevel":"?","occupationStatus":"06","monthlyIncome":"?","sourceOfFunds":"?","groupSchemeCode":"?","groupSchemeEmployeeNumber":"?"},"businessInfo":{"sicCode":"?","registrationNumber":"?","practiceOrTrustNo":"?","countryIncorporated":"?","internetWebSite":"?","vatRegistrationNo":"?","vatRegistrationNoAccount":"?","yearEnd":"?","address":{"line1":"?","line2":"?","suburb":"?","city":"?","postalCode":"?","countryCode":"?"},"cpaThreshold":"?","ncaThreshold":"?","exconExpiryDate":"?","site":"?","countryEntityOperates":{"countyCode":"?"},"registeredAddress":{"line1":"?","line2":"?","suburb":"?","city":"?","postalCode":"?","countryCode":"?"},"headOfficeAddress":{"line1":"?","line2":"?","suburb":"?","city":"?","postalCode":"?","countryCode":"?"}},"holds":{"appliedDebtCounselling":"?","businessAddressIndicator":"?","businessRescueAffectedPartyIndicator":"?","curatorshipIndicator":"?","dateAppliedDebtCounselling":"?","dateBusinessRescueIssued":"?","dateDebtCounsellingOrderIssued":"?","debtCounsellingOrderIssued":"?","deceasedEstateIndicator":"?","employerAddressIndicator":"?","executorsAddressIndicator":"?","fraudRiskIndicator":"?","identificationIndicator":"?","indicatorDeclaredInsolvent":"?","inBusinessRescueIndicator":"?","insolventEstateIndicator":"?","inLiquidityIndicator":"?","judicialManagementIndicator":"?","placedInBusinessRescueBy":"?","postalAddressIndicator":"?","regNumberIndicator":"?","residentialAddressIndicator":"?","spouseDeceasedIndicator":"?","voluntaryCrtConsolidationIndicator":"?","finCrimeHoldIndicator":"?","clientAgreementIssuedIndicator":"?"},"fica":{"dateExempted":"?","dateIdentified":"?","dateVerified":"?","empNoDateExempted":"?","empOrAttorneyNo":"?","empOrAttorneyNoDateVerified":"?","exempted":"?","exemptionIndicator":"?"},"accountAddress":{"line1":"?","line2":"?","suburb":"?","city":"?","postalCode":"?","countryCode":"?"},"executorAddress":{"line1":"?","line2":"?","suburb":"?","city":"?","postalCode":"?","countryCode":"?"},"designationCode":"?","contactPerson":"?","contactPersonIdNo":"?","affectedPersonReg":"?","noOfParticipants":"?","recipientName1":"?","recipientName2":"?","subClassificationCode":"?","detailedClassification":"?","detailedClassificationPcent":"?","nextOfKin":{"relationshipCode":"?","surname":"?","firstname":"?","relatedToPartSurname":"?","relatedToPartInitials":"?","relatedToPartTitleCode":"?","contactDetail":{"cellPhoneNo":"?","emailAddress":"?","homePhone":{"dialCode":"?","number":"?"},"homeFax":{"dialCode":"?","number":"?"},"workPhone":{"dialCode":"?","number":"?"},"workFax":{"dialCode":"?","number":"?"},"homeAddress":{"line1":"1 RUBGY ST","line2":"POSTALADDRESSLINE2","city":"AALWYNFLEUR","postalCode":"6670","countryCode":"SO003"},"postalAddress":{"line1":"1 RUBGY ST","line2":"POSTALADDRESSLINE2","city":"AALWYNFLEUR","postalCode":"6670"}}},"jointParticipants":{"clientType":"?","clientTypeGroup":"?","client":{"surname":"?","firstname":"?","initials":"?","dateOfBirth":"?","gender":"?","idNumber":{"documentType":"?","number":"?","dateIssued":"?","expiryDate":"?","countryOfIssueCode":"?","tempResidentPerNo":"?","permitExpiryDate":"?"},"titleCode":"?","homeLanguage":"?","correspondenceLanguage":"?","maritalStatus":"?","maritalContractType":"?","nationalityCode":"?","numberOfDependants":"?","incomeTaxNo":"?","universityCode":"?","postMatricIndicator":"?","postMatricQualification":"?","residentialStatus":"?","socialGrant":"?","creditWorthinessConsent":"?","countryOfBirthCode":"?","clientCode":"?"},"contactInfo":{"cellPhoneNo":"?","emailAddress":"?","homePhone":{"dialCode":"?","number":"?"},"homeFax":{"dialCode":"?","number":"?"},"workPhone":{"dialCode":"?","number":"?"},"workFax":{"dialCode":"?","number":"?"},"homeAddress":{"line1":"?","line2":"?","suburb":"?","city":"?","postalCode":"?","countryCode":"?"},"postalAddress":{"line1":"?","line2":"?","suburb":"?","city":"?","postalCode":"?","countryCode":"?"}},"marketingInfo":{"email":"?","mail":"?","sms":"?","telephone":"?","massMarketing":"?","marketingMailIndicator":"?","preferredCommunicationChannel":"?"},"employmentInfo":{"workAddress":{"line1":"?","line2":"?","suburb":"?","city":"?","postalCode":"?","countryCode":"?"},"employerName":"?","employmentSector":"?","occupationCode":"?","occupationLevel":"?","occupationStatus":"?","monthlyIncome":"?","sourceOfFunds":"?","groupSchemeCode":"?","groupSchemeEmployeeNumber":"?"},"holds":{"appliedDebtCounselling":"?","businessAddressIndicator":"?","businessRescueAffectedPartyIndicator":"?","curatorshipIndicator":"?","dateAppliedDebtCounselling":"?","dateBusinessRescueIssued":"?","dateDebtCounsellingOrderIssued":"?","debtCounsellingOrderIssued":"?","deceasedEstateIndicator":"?","employerAddressIndicator":"?","executorsAddressIndicator":"?","fraudRiskIndicator":"?","identificationIndicator":"?","indicatorDeclaredInsolvent":"?","inBusinessRescueIndicator":"?","insolventEstateIndicator":"?","inLiquidityIndicator":"?","judicialManagementIndicator":"?","placedInBusinessRescueBy":"?","postalAddressIndicator":"?","regNumberIndicator":"?","residentialAddressIndicator":"?","spouseDeceasedIndicator":"?","voluntaryCrtConsolidationIndicator":"?","finCrimeHoldIndicator":"?","clientAgreementIssuedIndicator":"?"},"fica":{"dateExempted":"?","dateIdentified":"?","dateVerified":"?","empNoDateExempted":"?","empOrAttorneyNo":"?","empOrAttorneyNoDateVerified":"?","exempted":"?","exemptionIndicator":"?"}},"validatorSet":"?"}');     
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