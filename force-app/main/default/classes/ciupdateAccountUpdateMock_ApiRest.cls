@isTest
global  class ciupdateAccountUpdateMock_ApiRest implements HttpCalloutMock {
     
Private String typeTest;
public ciupdateAccountUpdateMock_ApiRest(final String typeTest){
        this.typeTest = typeTest;
    }
    
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{ "absaRewardInd":"N","affectedPerson":"01","agriData": { "percentage": "0" },"applyDebtCounsel":"N","bankingSector":"1","birthDate":"19680426","businessAddrSeqNbr":"0","businessAddrType":"0","businessPostal":"0","cellphone":"0719890293","cellphoneBankInd":"Y","changeNumber":"139","clientCode":"GREENJ 154","clientNationality":"SOU01","clientType":"000101","companyYearEnd":"0","contOride":"0","corporateDivision":"A","counselOrderIssue":"0","courtAuthrityHold":"N","curatorshipHold":"N","minorChildren": "0","casaRefNum": "0","branchClientOpen": "272","dateBusRescueIss":"0","dateClientOpened":"20170826","dateExempted":"0","dateIdentified":"20201018","dateIssued":"0","dateLastChanged":"20200922","dateVerified":"20201025","deceasedEstateHld":"N","deceasedSpouseHld":"N","designation":"0","dteApplyCounsel":"0","dteOrderIssue":"0","emailAddress":"absa@absaa.africa","emailMarkInd":"N","employeeIdentified":"9153802","employeeVerified":"9153802","employerAddrHold":"N","employerAddrSeqNbr":"0","employerAddrType":"02","employerPostal":"2001","employmentSector":"1","exconExpiryDate":"0","exemptionIndicator":"00","exemptionStatus":"N","exliPolicy":"N","exstPolicy":"N","faxHomeCode":"0","faxHomeNumber":"0","faxWorkCode":"0","faxWorkNumber":"0","firstNames":"JOHN EBUSUK","flexiFuneralPolicy":"N","gender":"1","groupScheme":"0","haveQualification":"N","hoCodeRsa":"2001","homeLanguage":"E","homeTelCode":"12","homeTelephone":"3170432", "ibrAffected":"N","idDocType":"1", "idNumber":"8108267889080","idRequiredHold":"N","incomeGroup":"07","initials":"J","inivPolicy":"N","inliPolicy":"N","insolventIndicator":"N","insolvntEstateHld":"N","instPolicy":"N","internetBankinInd":"Y","language":"E","liabilityIndicator":"N","mailInd":"N","mandateCaptureHld":"N","mariageContrctType":"1","maritalStatus":"1","marketingConcent":"N","miltaryComtmntInd":"N","nbrOfAccounts":"31","noOfJointPartcpnt":"0","notificationInd":"Y","occupancyType":"B","occupationCode":"6","occupationLevel":"4","occupationStatus":"1","permitExpDte":"0","physicalAddrHold":"N","physicalAddrSeqNbr":"0","physicalAddrType":"01","physicalPostal":"2001","pingitReceive":"N","pingitWallet":"N","placedBy":"0","postalAddrHold":"N","postlAddrLine1":"15 TRYE STREET","postlCodeRsa":"2001","postlTown":"JOHAANNESBURG","powerAttornyHold":"N","prefrdCommtionMthd":"01","prohibitedInd":"N","regCodeRsa":"2001","savngStatementHold":"N","sbuSegment":"F","sec129DeliveryAddr":"0","secondaryCard":"N","securityIndicator":"N","siccCode5":"00000","sicCode":"0","siteLastChanged":"35370","smsMarketInd":"N","socialGrant":"N","sourceOfIncome":"28","subSegment":"F1","surname":"MATHESSESSSS","taxNumber":"0","telebankIndicator":"N","teleMarkInd":"N","tellerLastChanged":"1197779","thirdPartyInd":"N","titleCode":"03","unclaimedFundsInd":"N","updAddressInd":"N","updDateInd":"22092020","updEmailInd":"Y","updTelephoneInd":"N","whatQualification":"0","workTelCode":"12","workTelephone":"3170432"}');
        
        if(typeTest == StringConstants.POSITIVE_STRING){
            response.setStatusCode(200);
        }else if(typeTest == StringConstants.NEGATIVE_STRING){
            response.setStatusCode(400);
        }
        return response; 
    }
}