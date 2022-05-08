@isTest
public class sales_DashboardTest {
    @testSetup 
    static void setup() { 
        Sales_Client_Profile__c client = new Sales_Client_Profile__c(ID_Number__c='9306110611086',Full_Name__c='John Smith');
        insert client;
        
        Sales_Application__c appli = new Sales_Application__c(name='John Smith', Client__c = client.Id);
        insert appli;
            
        Sales_Casa_Reference__c casa = new Sales_Casa_Reference__c(Client_Casa__c = client.Id, Surname__c='Smith'); 
        insert casa;
        
        Sales_Call_History__c calls = new Sales_Call_History__c(Client_Call_History__c = client.Id, Name='001');
        insert calls;
        
        //Auth
        List<Integration_API__c> intList = new List<Integration_API__c>();
        intList.add(new Integration_API__c(Base_URL__c='https://esb.ext.api.uat.absa.co.za/enterprise-ext-uat/ext/integration/',Client_ID__c='X5iM4tV7qJ2uG7wJ', Client_Secret__c='5fc57ea1-0816', Environment__c='UAT', Name = 'DataPowerCP_INTEGRATION'));
		intList.add(new Integration_API__c(Base_URL__c='https://esb.ext.api.uat.absa.co.za/enterprise-ext-uat/ext/rbb/',Client_ID__c='6649833a-9c3c-4c87-b6f4-301', Client_Secret__c='O0uQ3lK5pE3uR0qO6oC1cG', Environment__c='UAT', Name = 'DataPowerSales'));
		intList.add(new Integration_API__c(Name = 'JitterbitAbsa330762',  Base_Url__c='https://absa330762.jitterbit.eu/rbservicesenvironmentuat/1.0/api/',  Client_ID__c='DIVE' ));
				
        insert intList;
        
        List<Sales_Authentication__c> authList  = new List<Sales_Authentication__c>();
        authList.add(new Sales_Authentication__c(Name='DataPowerCIF', applicationid__c='DIVE', BranchId__c='8196', deviceId__c='Browser',TellerId__c='ABRB745'));
    	authList.add(new Sales_Authentication__c(Name='DataPowerValidate', CLIENT_GROUP__c='individual'));
        authList.add(new Sales_Authentication__c(Name='DataPowerCIFUpdate', CLIENT_GROUP__c='individual', SYSTEM_ID__C ='DIVE'));
        insert authList;
                                 
    }
    /*************************************************************/
    /*************************SALES*******************************/
    /*************************************************************/        
    @isTest   
    static void posCiGetClientDetailsByIDNumber(){        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new sales_MockResponse());
        String clientData = '{"NBSAPDPI": {"NBSAPLI": {"consumerChannel": "test","providerApplication": "test","trace": "test"}},"NBSMSGI": {"NBSMSGI": {"messageLanguage": "test","messageTarget": "STD"}},"inputCopybookClssidi": {"inputDetails": {"idNumber": "test","idDocumentType": test,"cifClientGroup": "test","cifClientType": test,"maxRecordsToRetrieve": test,"restartSearchPosition": "","siteCode": test}}}';
		String IdNumber = '0000000000000';
        sales_DashboardController.ciGetClientDetailsByIDNumber(IdNumber, clientData); 
        //ResponseObj res = sales_DashboardController.ciGetClientDetailsByIDNumber('9306110611086');
        //system.assertEquals('200', res.Data.dataMap.getStatusCode);
        Test.stopTest();  
    }
    
    
    @isTest   
    static void posCiGetClientInfo(){        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new sales_MockResponse());   
         sales_DashboardController.ciGetClientInfo('inputKey');                              
        Test.stopTest();  
    }
    
    
    @isTest   
    static void posWQCASAScreenPrimaryClient(){      
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new sales_MockResponse()); 
        String clientData ='{"channel":"test","application":"test","trace":"","firstName":"test","surnameComp":"test","idType":"test","idRegNo":"test","clientTypeGrp":"test","dob":"test","nationality":"test","town":"test","territory":"test","cntryOfRes":"test","cntryOfBirth":"test","registerCity":"test","countryPassport":"test","headofficeTown":"test","headofficeCntry":"test","headofficeOtherCntry1":"test","headofficeOtherCntry2":"test","headofficeOtherCntry3":"test","headofficeOtherCntry4":"test","headofficeOtherCntry5":"test","sbu":"test","originatingSys":"test","branch":"test","teller":"test"}';         sales_DashboardController.wqcasascreenprimaryclient('inputKey');                              
        sales_DashboardController.wqcasascreenprimaryclient(clientData);                              
        Test.stopTest();  
    }
    
    @isTest   
    static void posWQRiskProfileClientV7(){      
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new sales_MockResponse()); 
        String clientData = '{"WQriskProfileClientV7Request":{"customerTypeCode":"test","customerStatusCode":"test","customerSourceUniqueId":"test","companyForm":"test","customerSourceRefID":"test","primeBranchID":"test","channel":"test","sbu":"test","originatingsystem":"test","employmentStatus":"test","occupation": "","businessSegment1":"test","cifkey":"test","IncorporationCountryCode":"test","absaCountryTradedWithTable":[{"absaCountriesTradedWith":"test"},{"absaCountriesTradedWith":"test"}],"absaCountryOfOperationTable":[{"absaCountryOfOperation":"test"},{"absaCountryOfOperation":"test"}],"absaSourceOfIncomeTable":[{"absaSourceOfIncome":"test"},{"absaSourceOfIncome":"test"}],"productCodeTable":[{"productCode":"test"},{"productCode":"test"}],"subProductCodeTable":[{"subProductCode":"test"},{"subProductCode":"test"}],"userId":"test"}}';        sales_DashboardController.wqriskprofileclientv7(clientData);                              
        Test.stopTest();  
    }
    
    @isTest   
    static void posWQgetCASADocumentsByRefNoV1(){        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new sales_MockResponse());   
        String clientData = '{"channel": "test","application": "test","trace": "test","ref_no": "test","version_i": "test"}'; 	
        sales_DashboardController.WQgetCASADocumentsByRefNoV1(clientData);                              
        Test.stopTest();  
    }
    
    @isTest   
    static void posWQConfirmDocumentReceipt(){      
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new sales_MockResponse()); 
        String clientData = '{"WQconfirmDocumentReceiptV2":{"nbsapdpi":{"channel":"test","application":"test","trace":"test"},"wqp131i":{"refNo":"test","version":"test","branch":"test","user":"test","docNo":"test","requiredDocs":[{"docCode":"test","received":"test","inOrder":"test","scanYn":"test"},{"docCode":"test","received":"test","inOrder":"test","scanYn":"test"},{"docCode":"test","received":"test","inOrder":"test","scanYn":"test"},{"docCode":"test","received":"test","inOrder":"test","scanYn":"test"},{"docCode":"test","received":"test","inOrder":"test","scanYn":"test"},{"docCode":"test","received":"test","inOrder":"test","scanYn":"test"},{"docCode":"test","received":"test","inOrder":"test","scanYn":"test"}]}}}';
        sales_DashboardController.WQconfirmDocumentReceipt(clientData);
        Test.stopTest();  
    }
    
    @isTest   
    static void posGetApplicationNum(){        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new sales_MockResponse());   
        String clientData = '{"SJMgenerateApplicationNumberV2":{"nbsapdpi":{"channel":"test","application":"test","trace":"test"},"nbsmsgi":{"msgLanguage":"test","msgTarget":"test","finalMsgClass":"","finalMsgCode":""},"sjp304i":{"origin":"test","corpCode":"test","branchCode":"test","branchSiteType":"test","agencyCode":"test","agencySiteType":"test","tellerCode":"test","supervisorCode":"test","clientCode":"test","prodCde":"test","consultEmplNo":"test"}}}';
        sales_DashboardController.getApplicationNum(clientData);                              
        Test.stopTest();  
    }
    
    @isTest   
    static void posInitiateApplication(){        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new sales_MockResponse()); 
        String clientData = '{"SJMinitiateApplicationV1":{"nbsapdpi":{"channel":"test","application":"test","trace":"test"},"nbsmsgi":{"msgLanguage":"test","msgTarget":"test","finalMsgId":{"finalMsgClass":"","finalMsgCode":""}},"sjp318i":{"applicationNo":"test","corpCode":"test","branchCode":"test","branchSiteType":"test","agencyCode":"test","agencySiteType":"test","tellerCode":"test","supervisorCode":"test"}}}';
        sales_DashboardController.initiateApplication(clientData);
        Test.stopTest(); 
    }
	
    @isTest   
    static void posSubmitApplication(){        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new sales_MockResponse());   
        sales_DashboardController.submitApplication('test');
        Test.stopTest(); 
    }
    
    @isTest   
    static void posGetDuplicateApplications(){        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new sales_MockResponse());   
        sales_DashboardController.getDuplicateApplications('test');
        Test.stopTest(); 
    }
    
    @isTest   
    static void posGetPlSettlementAccountsv2API(){        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new sales_MockResponse());   
        String clientData = '{"NBSAPDPI":{"NBSAPLI":{"consumerChannel":"test","providerApplication":"test","traceIndicator":"test"}},"MSGI":{"NBSMSGI":{"version":"test","messageLanguage":"test","messageTarget":"test"}},"SJMgetPLSettlementAccountsV2":{"SJMgetPLSettlementAccountsV2Input":{"corpCode":"test","branchCode":"test","branchSiteType":"test","agencyCode":"test","agencySiteType":"test","tellerCode":"test","supervisorCode":"test","applicationNo":"test","financeType":"test","loanAmount":"test"}}}';
        sales_DashboardController.getplsettlementaccountsv2api(clientData);                              
        Test.stopTest();  
    }
    
    @isTest   
    static void posSJMSubmitSettlementAcctsV3(){        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new sales_MockResponse());   
        String clientData = '{"finance_type": "test","application_number": "test","sett_account_number": "test","rl_account_number": "test","branch_code": "test","corp_code": "test","branch_site_type": "test","agency_code": "test","agency_site_type": "test","teller_code": "test","supervisor_code": "test","sett_corp": "test","channel": "test","application": "test","trace": "test","msg_language": "test","msg_target": "test"}'; 	
        sales_DashboardController.sjmsubmitsettlementacctsv3(clientData);                              
        Test.stopTest();  
    }
    
    @isTest   
    static void posSubmitPLInfo(){        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new sales_MockResponse());   
        String clientData = '{"SJMsubmitPLInfoV4":{"nbsapdpi":{"channel":"test","application":"test","trace":"test"},"nbsmsgi":{"msgLanguage":"test","msgTarget":"test","finalMsgId":{"finalMsgClass":"","finalMsgCode":""}},"sjb301di":{"applicationNo":"test","financeType":"test","purposeOfLoan":"test","purposeOfLoanRsn":"test","additLoanAmnt":"test","loanExposure5":"test","paymType":"test","noOfPaymts":"test","skipPayment":"test","initiationFeePaym":"test","paymFreq":"test","paymentMethod":"test","creditLifeInd":"test","corpCode":"test","branchCode":"test","branchSiteType":"test","agencyCode":"test","agencySiteType":"test","tellerCode":"test","supervisorCode":"test","amlrSelected":"test","balanceTransferInst":"test","scndCreditLife":"test"}}}';
        sales_DashboardController.submitPLInfo(clientData);                              
        Test.stopTest();  
    }
    
    @isTest   
    static void posSubmitCreditLifePolicyInfoV1(){        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new sales_MockResponse());   
        String clientData = '{"SJMsubmitCreditLifePolicyInfoV1":{"nbsapdpi":{"channel":"test","application":"test","trace":"test"},"nbsmsgi":{"msgLanguage":"test","msgTarget":"test","finalMsgClass":"","finalMsgCode":""},"sjb309i":{"corpCode":"test","branchCode":"test","branchSiteType":"test","agencyCode":"test","agencySiteType":"test","tellerCode":"test","supervisorCode":"test","clSchemeCode":"test","clSchemeName":"test","clBenefitDecs":"test","clGrossPremium":"test","clNettPremium":"test","clCommission":"test","clPolicyFee":"test"}}}';
        sales_DashboardController.submitCreditLifePolicyInfoV1(clientData);                              
        Test.stopTest();  
    }
    
    @isTest   
    static void posSjmGetCMSSMSInfo(){        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new sales_MockResponse());   
        String clientData = '{"NBSAPDPI":{"NBSAPLI":{"consumerChannel":"test","providerApplication":"test","traceIndicator":"test"}},"MSGI":{"NBSMSGI":{"version":"test","messageLanguage":"test","messageTarget":"test"}},"SJMgetCMSSMSInfoV2":{"SJMgetCMSSMSInfoV2Input":{"applicationNo":"test","corpCode":"test","branchCode":8392,"branchSiteType":34,"agencyCode":8392,"agencySiteType":34,"tellerCode":2693,"supervisorCode":"test"}}}';
        sales_DashboardController.sjmgetCMSSMSInfo(clientData);                              
        Test.stopTest();  
    }
    
    //
    @isTest   
    static void posvalidateClientDetails1(){        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new sales_MockResponse());   
        String clientData = '{"CIcreateClientV20":{"CIcreateClientV20Input":{"CRInd":"N","ClientAgrmntIssued":"N","CreditAutoVoice":"N","CreditEmail":"N","CreditPost":"N","CreditSMS":"N","CreditTel":"N","NonCREmail":"N","NonCRInd":"N","NonCRPost":"N","NonCRSMS":"N","NonCRTel":"N","NonCRVR":"N","SAtaxNumber":"0","affectedPerson":"0","ageiculturalDataTable":[{"agriClass":"0","percentage":"0"}],"birthDate":"19720301","branchClientOpen":"8392","businessAdd1":"","businessAdd2":"","businessAddrType":"0","businessPostal":"0","businessSuburb":"","businessTown":"","casaRefNum":"0","cellphone":"0821234567","clientNationality":"SOU01","clientType":"00101","clientWebsite":"","companyYearEnd":"0","contOride":"0","contactPerson":"","corporateDivision":"A","countryEntityOperatesTable":[{"countryEntOprt":"0"}],"countryHoAddress":"","countryIncorp":"","countryOfBirth":"SO003","countryOfOrigin":"SO003","countryRegAddress":"SO003","countryResAddress":"SO003","cpaThreshold":"","dateExempted":"0","dateIdentified":"20200416","dateIssued":"20200416","dateVerified":"20200416","designation":"0","emailAddress":"tes@test.com","emailMarkInd":"","employeeExempted":"","employeeIdentified":"9069257","employeeVerified":"9069257","employerAdd1":"178 main","employerAdd2":"","employerAddrType":"70","employerPostal":"2196","employerSuburb":"JOHANNESBURG","employerTown":"JOHANNESBURG","employmentSector":"06","exconExpiryDate":"0","exemptionIndicator":"","exemptionStatus":"N","faxHomeCode":"011","faxHomeNumber":"2594714","faxWorkCode":"0","faxWorkNumber":"0","firstNames":"TEST","foreignTaxDATATable":[{"foreignTaxCtry":"AF001","foreignTaxNo":"12341234","rsonFtaxNotRegis":""}],"foreignTaxRegis":"Y","gender":"2","groupScheme":"0","groupSchemeEmp":"","haveQualification":"N","hoAddrLine1":"","hoAddrLine2":"","hoCodeRsa":"0","hoSuburb":"","hoTown":"","homeLanguage":"E","homeTelCode":"0","homeTelephone":"","idNumber":"9343012426899","idType":"03","incomeGroup":"0","initials":"T","language":"E","mailInd":"","mariageCntrctType":"5","maritalStatus":"1","marketingConcent":"","militaryComtmntInd":"N","minorChildren":"0","ncaThreshold":"0","nkinCell":"","nkinDcdh":"","nkinDcdw":"","nkinEmail":"","nkinFname":"","nkinInitials":"","nkinJntSurname":"","nkinRelationship":"","nkinSurname":"","nkinTelh":"","nkinTelw":"","nkinTitle":"","noOfJointPartcpnt":"0","occupancyType":"S","occupationCode":"15","occupationLevel":"0","occupationStatus":"01","permitExpDte":"0","physicalTown":"JOHANNESBURG","physicalAdd1":"12 RIVONIA","physicalAdd2":"","physicalAddrType":"10","physicalPostal":"2001","physicalSuburb":"JOHANNESBURG","pingitReceive":"0","pingitWallet":"N","postlAddrLine1":"170 main","postlAddrLine2":"","postlCodeRsa":"2916","postlSuburb":"JOHANNESBURG","postlTown":"JOHANNESBURG","practiceNumber":"","prefrdCommtionMthd":"04","regAddrLine1":"","regAddrLine2":"","regCodeRsa":"0","regSuburb":"","regTown":"","resPermitNumber":"0","rsonSaTaxNotGiven":"","saTaxRegis":"N","sec129DeliveryAddr":"0","secondaryCard":"N","siccCode5":"0","smsMarketInd":"","socialGrant":"N","sourceOfIncome":"20","subClassCde":"","surname":"PERSONA","teleMarkInd":"N","tellerLastChanged":"1057488","thrdPartyInd":"N","titleCode":"21","updAddressInd":"","updDateInd":"0","updEmailInd":"","updTelephoneInd":"0","vatRegistrationNo":"","whatQualification":"0","workTelcode":"0","workTelephone":""}},"inputErrorMessage":{"errorMessageParameters":{"messageLanguage":"E","messageTarget":"STD"}},"inputHeaders":{"inputPayloadHeaders":{"consumerChannel":"BRANCH","providerApplication":"DIVE","traceIndicator":"Y"}}}';
        sales_DashboardController.validateClientDetails(clientData);                              
        Test.stopTest();  
    }
    
    @isTest   
    static void posupdateCIF(){        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new sales_MockResponse());   
        String clientData = '{"CIupdateClientDetailV20":{"CIupdateClientDetailV20Input":{"absaRewardInd":"N","affectedPerson":"0","agriClassTabel":[{"agriClass":"","percentage":"0"}],"applyDebtCounselInd":"N","bankingSector":"1","birthDate":"19910402","branchClientOpen":"8392","businessAdd1":"","businessAdd2":"","businessAddrSeqNbr":"0","businessAddrType":"0","businessPostal":"0","businessSuburb":"","businessTown":"","casaRefNum":"121155381","cellphone":"0821234567","cellphoneBankInd":"","changeNumber":"23","clientAgrmntIssued":"Y","clientCode":"TESTOT 680","clientNationality":"SOU01","clientType":"00101","clientWebsite":"","companyYearEnd":"0","contOride":"0","contactPerson":"N","corporateDivision":"A","countryHoAddress":"","countryIncorp":"","countryOfBirth":"SO003","countryOfOrigin":"","countryRegAddress":"SO003","countryResAddress":"SO003","courtAuthrityHold":"","cpaThreshold":"","creditMarketingAutoVoice":"N","creditMarketingEmail":"N","creditMarketingGroupInd":"N","creditMarketingPost":"N","creditMarketingSms":"N","creditMarketingTelephone":"N","curatorshipHold":"","dateBusRescueIss":"0","dateClientOpened":"20200511","dateExempted":"0","dateIdentified":"20200511","dateIssued":"20200511","dateLastChanged":"20200511","dateVerified":"20200511","debtCounselApplyDate":"0","debtCounselOrderIssueDate":"0","debtCounselOrderIssuedInd":"N","deceasedEstateHld":"","deceasedSpouseHld":"","designation":"0","emailAddress":"","emailMarkInd":"","employeeExempted":"","employeeIdentified":"9069257","employeeVerified":"9069257","employerAdd1":"22 johannesburg","employerAdd2":"","employerAddrHold":"","employerAddrSeqNbr":"0","employerAddrType":"70","employerPostal":"2196","employerSuburb":"johannesburg","employerTown":"johannesburg","employmentSector":"06","entOprtDataTabel":[{"countryEntOprt":""}],"exconExpiryDate":"0","exemptionIndicator":"","exemptionStatus":"N","exliPolicy":"","exstPolicy":"","faxHomeCode":"0","faxHomeNumber":"0","faxWorkCode":"0","faxWorkNumber":"0","firstNames":"TESTsix","flexiFuneralPolicy":"","foreignTaxDataTabel":[{"foreignTaxCtry":"","foreignTaxNo":"","rsonFtaxNotRegis":""}],"foreignTaxregis":"N","gender":"1","groupScheme":"0","groupSchemeEmp":"","haveQualification":"N","hoAddrLine1":"","hoAddrLine2":"","hoCodeRsa":"0","hoSuburb":"","hoTown":"","homeLanguage":"E","homeTelCode":"0","homeTelephone":"","ibrAffected":"","idDocType":"01","idNumber":"9104029073187","idRequiredHold":"","inBusinessRescue":"","incomeGroup":"0","initials":"T","inivPolicy":"","inliPolicy":"","insolventEstateHld":"","insolventIndicator":"","instPolicy":"","internetBankinInd":"","language":"E","liabilityIndicator":"","mailInd":"","mandateCaptureHld":"","maritalStatus":"3","marketingConcent":"","marriageContractType":"0","mclIndicator":"","miltaryComtmntInd":"N","minorChildren":"0","nbrOfAccounts":"0","ncaThreshold":"0","nkinCell":"0","nkinDcdh":"0","nkinDcdw":"0","nkinEmail":"","nkinFname":"","nkinInitials":"","nkinJntSurname":"","nkinRela":"0","nkinSurname":"","nkinTelh":"0","nkinTelw":"0","nkinTitle":"00","noOfJointPartcpnt":"0","nonCreditMarketingAutoVoice":"N","nonCreditMarketingEmail":"N","nonCreditMarketingGroupInd":"N","nonCreditMarketingPost":"N","nonCreditMarketingSms":"N","nonCreditMarketingTelephone":"N","notificationInd":"","occupancyType":"S","occupationCode":"15","occupationLevel":"0","occupationStatus":"01","permitExpDte":"0","physicalAdd1":"THREE","physicalAdd2":"","physicalAddrHold":"","physicalAddrSeqNbr":"0","physicalAddrType":"10","physicalPostal":"1111","physicalTown":"TdsirjT","physicalSuburb":"TdsirjT","pingitReceive":"0","pingitWallet":"N","placedBy":"0","postalAddrHold":"","postlAddrLine1":"jhb","postlAddrLine2":"jhb","postlCodeRsa":"2916","postlSuburb":"jhb","postlTown":"jhb","powerAttornyHold":"","practiceNumber":"","prefrdCommtionMthd":"04","prohibitedInd":"","regAddrLine1":"","regAddrLine2":"","regCodeRsa":"0","regSuburb":"","regTown":"","resPermitNbr":"0","rsonSaTaxNotregis":"","saTaxNumber":"0","saTaxRegis":"N","savngStatementHold":"","sbuSegment":"","sec129DeliveryAddr":"0","secondaryCardInd":"N","securityIndicator":"","sicCode":"0","siccCode5":"0","siteLastChanged":"8196","smsMarketInd":"","socialGrant":"N","sourceOfIncome":"20","subClassCde":"","subSegment":"","surname":"TESTFIVE","teleMarkInd":"N","telebankIndicator":"","tellerLastChanged":"1057488","thrdPartyInd":"N","titleCode":"01","unclaimedFundsInd":"","updAddressInd":"","updDateInd":"0","updEmailInd":"N","updTelephoneInd":"N","vatRegistrationNo":"","whatQualification":"0","workTelcode":"0","workTelephone":""}},"inputErrorMessage":{"errorMessageParameters":{"messageLanguage":"E","messageTarget":"STD"}},"inputHeaders":{"inputPayloadHeaders":{"consumerChannel":"BRANCH","providerApplication":"DIVE","traceIndicator":"Y"}}}';
        sales_DashboardController.updateCIF(clientData);                              
        Test.stopTest();  
    }
    //
    
    @isTest   
    static void posSubmitCMSContinuationProcess(){        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new sales_MockResponse());   
        sales_DashboardController.submitCMSContinuationProcess('test');
        Test.stopTest(); 
    }
    
    //submitQuoteDetail
    
    @isTest   
    static void posSaveTRIADAgreement(){        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new sales_MockResponse());   
        String clientData = '{"SJMsaveTRIADAgreementV1":{"nbsapdpi":{"channel":"test","application":"test","trace":"test"},"nbsmsgi":{"msgLanguage":"test","msgTarget":"test","finalMsgId":{"finalMsgClass":"test","finalMsgCode":"test"}},"sjb315i":{"corpCode":"test","branchCode":"test","branchSiteType":"test","agencyCode":"test","agencySiteType":"test","tellerCode":"test","supervisorCode":"test","applicationNo":"test","clientResponse":"test","continueIndicator":"test"}}}';
        sales_DashboardController.saveTRIADAgreement(clientData);                              
        Test.stopTest();  
    }
    
    @isTest   
    static void posGetClientCreditInfomaint(){        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new sales_MockResponse());   
        String clientData = '{"SJMgetClientCreditInfoMaintV2":{"nbsapdpi":{"channel":"test","application":"test","trace":"test"},"nbsmsgi":{"msgLanguage":"test","msgTarget":"test","finalMsgId":{"finalMsgClass":"test","finalMsgCode":"test"}},"sjp329i":{"applicationNo":"test","corpCode":"test","branchCode":"test","branchSiteType":"test","agencyCode":"test","agencySiteType":"test","tellerCode":"test","test"}}}';
        sales_DashboardController.getClientCreditInfomaint(clientData);                              
        Test.stopTest();  
    }
    
    @isTest   
    static void posSubmitClientDetail(){        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new sales_MockResponse());   
        String clientData = '{"SJMsubmitClientDetailV1":{"nbsapdpi":{"channel":"test","application":"test","trace":"test"},"nbsmsgi":{"msgLanguage":"test","msgTarget":"test","finalMsgId":{"finalMsgClass":"test","finalMsgCode":"test"}},"sjp620i":{"applicationNo":"test","saCitizen":"test","everInsolAdmin":"test","dteRehabInsolv":"test","appDebtCounselingAp":"test","bondAmtOutst":"test","resMarketVal":"test","resDteSince":"test","actualOccupation":"test","dtePresEmploy":"test","freqSalPayments":"test","spouseDetailsAvail":"test","employStatusSp":"test","corpCode":"test","branchCode":"test","branchSiteType":"test","agencyCode":"test","agencySiteType":"test","tellerCode":"test","supervisorCode":"test"}}}';
        sales_DashboardController.submitClientDetail(clientData);                              
        Test.stopTest();  
    }
    
    @isTest   
    static void posGetExpenses(){        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new sales_MockResponse());   
        sales_DashboardController.getExpenses('test');
        Test.stopTest(); 
    }
    
    @isTest   
    static void posSubmitExpense(){        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new sales_MockResponse());   
        String clientData = '{"NBSAPDPI":{"inputHeaders":{"channelName":"test","applicationName":"test","traceIndicator":"test"}},"NBSMSGI":{"inputErrorMessages":{"errorMessageLanguage":"test","errorMessageTarget":"test"}},"SJB321D":{"inputFields":{"corpCode":"test","branchCode":"test","branchSiteType":"test","agencyCode":"test","agencySiteType":"test","tellerCode":"test","supervisorCode":"test","applicationNumber":"test","totalGrossIncome":"test","netSalaryIncomeMonth1":"test","netSalaryIncomeMonth2":"test","netSalaryIncomeMonth3":"test","salaryDeductionFixedDebt":"test","retailIncome":"test","otherAdditionalIncome":"test","householdExpenses":"test","municipal":"test","domestic":"test","cell":"test","schoolUniversityFees":"test","transport":"test","insurance":"test","entertainment":"test","security":"test","rental":"test","maintenancePayment":"test","otherExpenses":"test","specifyOtherExpenses":"test","homeLoanInstallments":"test","loanOverdraft":"test","creditCardInstallments":"test","ISAInstallments":"test","retail":"test","otherInstallments":"test"}}}';
        sales_DashboardController.submitExpense(clientData);                              
        Test.stopTest();  
    }
    
    @isTest   
    static void posSjmGetFinancialDetailsV1(){        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new sales_MockResponse());   
        String clientData = '{"channel": "test","application": "test","trace": "test","msg_language": "test","msg_target": "test","application_number": "test","corp_code": "test","branch_code": "test","branch_site_type": "test","agency_code": "test","agency_site_type": "test","teller_code": "test","supervisor_code": "test"}'; 	
        sales_DashboardController.sjmgetfinancialdetailsv1(clientData);                              
        Test.stopTest();  
    }
    
    @isTest   
    static void posSaveFinancialDetails(){        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new sales_MockResponse());   
        String clientData = '{"SJMsaveFinancialDetailsV1":{"nbsapdpi":{"channel":"test","application":"test","trace":"test"},"nbsmsgi":{"msgLanguage":"test","msgTarget":"test","finalMsgId":{"finalMsgClass":"test","finalMsgCode":"test"}},"sjp322i":{"applicationNo":"test","mpCheqAccInst":"test","mpExtCheqInst":"test","mpCcInst":"test","mpPersLoanInst":"test","mpBondInst":"test","mpSavAccInst":"test","mpInvestAccInst":"test","spCheqAccInst":"test","spExtCheqInst":"test","spCcInst":"test","spPersLoanInst":"test","spBondInst":"test","spSavAccInst":"test","spInvestAccInst":"test","applNettWorth":"test","meApplNettWorth":"test","nettWorthSiteCode":"test","nettWorthDateCap":"test","mpOrdCredCommExt":"test","mpAssetFinCommExt":"test","mpMortLoanCommExt":"test","spOrdCredCommExt":"test","spAssetFinCommExt":"test","spMortLoanCommExt":"test","noAssurPolicy":"test","ccyyOldestAssPol":"test","affHousing":"test","suspAppl":"test","corpCode":"test","branchCode":"test","branchSiteType":"test","agencyCode":"test","agencySiteType":"test","tellerCode":"test","supervisorCode":"test"}}}';
        sales_DashboardController.saveFinancialDetails(clientData);                              
        Test.stopTest();  
    }
    
    @isTest   
    static void posProcessBlazeAdvisor(){        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new sales_MockResponse());   
        String clientData = '{"SJMprocessBlazeAdvisorV2":{"nbsapdpi":{"channel":"test","application":"test","trace":"test"},"nbsmsgi":{"msgLanguage":"test","msgTarget":"test","finalMsgId":{"finalMsgClass":"test","finalMsgCode":"test"}},"sjp317i":{"applicationNo":"test","continuation":"test","prevFunc":"test","origin":"test","corpCode":"test","branchCode":"test","branchSiteType":"test","agencyCode":"test","agencySiteType":"test","tellerCode":"test","supervisorCode":"test"}}}';
        sales_DashboardController.processBlazeAdvisor(clientData);                              
        Test.stopTest();  
    }
    
    @isTest   
    static void posGetCreditBureauDetails(){        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new sales_MockResponse());   
        String clientData = '{"NBSAPDPI":{"inputHeader":{"channelName":"test","applicationName":"test","traceIndicator":"test"}},"NBSMSGI":{"inputErrorMessage":{"errorMessageLanguage":"test","errorMessageTarget":"test"}},"SJB328I":{"inputCopybook":{"applicationNumber":"test","participantNumber":"test","corpCode":"test","branchCode":"test","branchSiteType":"test","agencyCode":"test","agencySiteType":"test","test","supervisorCode":"test"}}}';
        sales_DashboardController.getCreditBureauDetails(clientData);                              
        Test.stopTest();  
    }
    
    @isTest   
    static void posSaveCreditBureaDetails(){        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new sales_MockResponse());   
        String clientData = '{"NBSAPDPI":{"inputHeaders":{"channelName":"test","applicationName":"test","traceIndicator":"test"}},"NBSMSGI":{"inputErrorMessage":{"errorMessageLanguage":"test","errorMessageTarget":"test"}},"SJB323I":{"inputCopybook":{"applicationNumber":"test","participantNumber":"test","corpCode":"test","branchCode":"test","branchSiteType":"test","agencyCode":"test","agencySiteType":"test","test","supervisorCode":"test"}}}';
        sales_DashboardController.saveCreditBureaDetails(clientData);                              
        Test.stopTest();  
    }
    
    //
     @isTest   
    static void posrelinkCreditBureauDetails(){        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new sales_MockResponse());   
        //String clientData = '{"NBSAPDPI":{"inputHeaders":{"channelName":"test","applicationName":"test","traceIndicator":"test"}},"NBSMSGI":{"inputErrorMessage":{"errorMessageLanguage":"test","errorMessageTarget":"test"}},"SJB323I":{"inputCopybook":{"applicationNumber":"test","participantNumber":"test","corpCode":"test","branchCode":"test","branchSiteType":"test","agencyCode":"test","agencySiteType":"test","test","supervisorCode":"test"}}}';
        String clientData = '{"NBSAPDPI":{"NBSAPLI":{"consumerChannel":"SALESFORCE","providerAppliaction":"DIVE","traceIndictaor":"Y"}},"MSGI":{"NBSMSGI":{"messageLanguage":"E","messageTarget":"STD"}},"SJMrelinkCreditBureauDetailsV1":{"SJMrelinkCreditBureauDetailsV1Input":{"applicationNo":"42001780475","relink":"Y","corpCode":"ABS","branchCode":"8392","branchSiteType":"034","agencyCode":"8392","angencySiteType":"034","tellerCode":"2693","supervisorCode":2693}}}';
        sales_DashboardController.relinkCreditBureauDetails(clientData);                              
        Test.stopTest();  
    }
    //
    
    @isTest   
    static void posGetPLScoringResult(){        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new sales_MockResponse());   
        String clientData = '{"SJMgetPLScoringResultV1":{"nbsapdpi":{"channel":"test","application":"test","trace":"test"},"nbsmsgi":{"msgLanguage":"test","msgTarget":"test","finalMsgId":{"finalMsgClass":"test","finalMsgCode":"test"}},"sjp312i":{"corpCode":"test","branchCode":"test","branchSiteType":"test","agencyCode":"test","agencySiteType":"test","tellerCode":"test","supervisorCode":"test","applicationNo":"test"}}}';
        sales_DashboardController.getPLScoringResult(clientData);                              
        Test.stopTest();  
    }
    
    @isTest   
    static void posSavePLScoringResult(){        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new sales_MockResponse());   
        String clientData = '{"SJMsavePLScoringResultV1":{"nbsapdpi":{"channel":"test","application":"test","trace":"test"},"nbsmsgi":{"msgLanguage":"test","msgTarget":"test","finalMsgId":{"finalMsgClass":"test","finalMsgCode":"test"}},"sjp337i":{"applicationNo":"test","finalPlAmnt":"test","corpCode":"test","branchCode":"test","branchSiteType":"test","agencyCode":"test","agencySiteType":"test","tellerCode":"test","supervisorCode":"test"}}}';
        sales_DashboardController.savePLScoringResult(clientData);                              
        Test.stopTest();  
    }
    
    @isTest   
    static void posGetQuoteDetail(){        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new sales_MockResponse());   
        String clientData = '{"NBSAPDPI":{"inputHeader":{"channelName":"test","applicationName":"test","traceIndicator":"test"}},"NBSMSGI":{"inputErrorMessage":{"inputErrorMessageLanguage":"test","inputErrorMessageTarget":"test"}},"SJB332I":{"inputCopybookLayout":{"applicationNumber":"test","corpCode":"test","branchCode":"test","branchSiteType":"test","agencyCode":"test","agencySiteType":"test","tellerCode":"test","supervisorCode":"test"}}}';
        sales_DashboardController.getQuoteDetail(clientData);                              
        Test.stopTest();  
    }
    
    @isTest   
    static void posSubmitQuoteDetail(){        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new sales_MockResponse());   
		String application_number = 'test';
        sales_DashboardController.submitQuoteDetail(application_number);                              
        Test.stopTest();  
    }
    
    @isTest   
    static void posNHlistAcctsLinkedToAClientV1(){        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new sales_MockResponse());   
        String clientData = '{"log": "test","authenticate": "test","user": "test","division": "test","device": "test","origAddress": "test","combiNumber": "test","language": "test","cifkey": "test","nbrOfRecsToRtrv": "test","pagingKey": "test"}'; 	
        sales_DashboardController.NHlistAcctsLinkedToAClientV1(clientData);                              
        Test.stopTest();  
    }
    
    @isTest   
    static void posGetClientDetailsSOQl(){        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new sales_MockResponse());                 
        List<Sales_Client_Profile__c> res = sales_DashboardController.getClientDetailsSOQl('9306110611086');
                     
        System.AssertEquals(1, res.size()); 
                                        
        Test.stopTest(); 
    }
    
    @isTest   
    static void posgetClientProfile(){        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new sales_MockResponse());                 
        sales_DashboardController.getClientProfile('9306110611086');                              
        Test.stopTest(); 
    }
    
    @isTest   
    static void posGetUserInfo(){        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new sales_MockResponse());                 
        sales_DashboardController.getUserInfo();                              
        Test.stopTest(); 
    }
    
    @isTest   
    static void posSaveApplication(){        
        Test.startTest();
         List<Sales_Client_Profile__c> data = sales_DashboardController.getClientDetailsSOQl('9306110611086');

        String clientData = '{"profile_record_id": "'+data[0].Id+'","applcation_record_id": "'+data[0].Application__r[0].Id+'", "client_key": "","credit_worthiness": false,"absa_group_electronic": false,  "voice_recording": false,"sms": false, "email" :false, "i_accept_terms_and_conditions": false}';             
        sales_DashboardController.saveApplication(clientData);   
        
        Test.stopTest(); 
    }
    

    @isTest   
    static void posValidateClientDetails(){        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new sales_MockResponse());   
        String clientData = '{"date_of_birth": "2014-01-01",  "cellphone_number": "000000","nationality": "South African","customer_type": "test", "country_of_birth": "South Africa","gender": "Male","does_client_havepostmatric_qualification": "yes", "home_language": "zulu","id_number": "9112044343","id_type": "ID Number","communication_language": "zulu","marital_contract": "Incommunity of property","marital_status": "Married","post_matric_qualification": "test"}'; 	
        //sales_DashboardController.validateClientDetails(clientData);                              
        Test.stopTest();  
    }  
    
    @isTest   
    static void posSjmgetPlScoringresultV1(){        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new sales_MockResponse());   
        String clientData = '{"channel": "test","application": "test","trace": "test","msg_language": "test","msg_target": "test","application_number": "test","corp_code": "test","branch_code": "test","branch_site_type": "test","agency_code": "test","agency_site_type": "test","teller_code": "test","supervisor_code": "test"}'; 	
        //sales_DashboardController.sjmgetplscoringresultv1(clientData);                              
        Test.stopTest();  
    }   
            
    
    /*************************************************************/
    /*************************CHEWY*******************************/
    /*************************************************************/
    // Chewy apis Postman collection
    // https://www.getpostman.com/collections/303179d9da9710997398  

    @isTest   
    static void negLogin(){   
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new sales_MockResponse());                 
        List<String> res = sales_ChewyCTI.login('read_time_out', 'abhm512', '1001021');
        
        System.assertEquals('Failure', res[0]);           
        System.AssertEquals(2, res.size());     
        
        Test.stopTest();
    }    

    @isTest   
    static void posChangeAgentStatus(){        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new sales_MockResponse());                 
        List<String> res = sales_ChewyCTI.changeAgentStatus('abhm512','1001021', '7011', '0', 'READY');   
        
        //System.assertEquals('Success', res[0]);           
        //System.AssertEquals(4, res.size());   
        
        Test.stopTest();
    }    
    
    @isTest   
    static void posAcceptContact(){        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new sales_MockResponse());                 
        List<String> res = sales_ChewyCTI.acceptContact('abhm512', '7011');   
        
        //System.assertEquals('Success', res[0]);           
        //System.AssertEquals(4, res.size()); 
        
        Test.stopTest(); 
    }  
    
    @isTest   
    static void posCloseContact(){        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new sales_MockResponse());                 
        List<String> res = sales_ChewyCTI.closeContact('abhm512', '7011');  
        
        //System.assertEquals('Success', res[0]);           
        //System.AssertEquals(4, res.size()); 
        
        Test.stopTest(); 
    } 
    @isTest   
    static void posOnHold(){        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new sales_MockResponse());                 
        List<String> res = sales_ChewyCTI.onHold('7011', 'string','1001021', 'HOLD', 'abhm512');      
        
        //System.assertEquals('Success', res[0]);           
        //System.AssertEquals(4, res.size()); 
        
        Test.stopTest(); 
    }      
        
    @isTest   
    static void posLogoutContact(){        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new sales_MockResponse());                 
        List<String> res = sales_ChewyCTI.logout('abhm512', '1001021','');  
        
        //System.assertEquals('Success', res[0]);           
        //System.AssertEquals(4, res.size()); 
        
        Test.stopTest(); 
    }           
    @isTest   
    static void posAgentStatus(){        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new sales_MockResponse());                 
        List<String> res = sales_ChewyCTI.agentStatus('7011', 'abhm512');       
        Test.stopTest(); 
    }     
    
    @isTest   
    static void posClientProfiles(){        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new sales_MockResponse());     
        List<String> res = sales_ChewyCTI.clientProfiles('7011', '','', '','', '');       
        Test.stopTest(); 
    } 
    
    @isTest   
    static void posdownloadPDF(){  
        Sales_Application__c appli = [Select Id from Sales_Application__c LIMIT 1];
        
        Attachment attach = new Attachment(Name='Details.pdf', parentId=appli.Id, Body=Blob.valueOf('test'));
        insert attach;
        
        Test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new sales_MockResponse());     
        sales_DashboardController.downloadPDF(appli.Id);   
        Test.stopTest(); 
    }        
   
}