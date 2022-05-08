({
    
    //TdB - Call Match Termination Inquiry Service
    callMerchantMatchService : function(component, event, helper) {
        
        this.showSpinner(component);
        
        var action = component.get("c.callMatchTerminationService");
        
        action.setParams({
            "oppId" : component.get('v.recordId'),
            "existingMatchRiskRecords" : component.get("v.existingMatchData")
        });
        
        action.setCallback(this,function(res){
            var state = res.getState();
            
            if(component.isValid() && state==="SUCCESS"){
                
                var serviceResponse = JSON.parse(res.getReturnValue());
                
                //var inquiryMatches = serviceResponse.TerminationInquiry.PossibleInquiryMatches.InquiredMerchant;
                
                component.set('v.matchResponseBean',serviceResponse);
                component.set('v.matchResponseBeanString', JSON.stringify(serviceResponse));
                
                if(serviceResponse != null ) {
                    if(serviceResponse.Errors == null && serviceResponse.statusCode == '200') {
                        //Start changes By Himani for #W-005294
                        var matchRecordFound = false;
                        if(serviceResponse.TerminationInquiry && serviceResponse.TerminationInquiry.PossibleMerchantMatches){
                            serviceResponse.TerminationInquiry.PossibleMerchantMatches.forEach(function(item){
                                if(!matchRecordFound && item.TotalLength > 0){
                                    matchRecordFound = true;
                                }
                            });
                        }
                        if(!matchRecordFound){
                            if(serviceResponse.TerminationInquiry && serviceResponse.TerminationInquiry.PossibleInquiryMatches){
                                serviceResponse.TerminationInquiry.PossibleInquiryMatches.forEach(function(item){
                                    if(!matchRecordFound && item.TotalLength > 0){
                                        matchRecordFound = true;
                                    }
                                });
                            }
                        }
                        
                        var toastMessage = '';
                        if(matchRecordFound){
                            toastMessage = 'Match Inquiry check complete';
                            component.set("v.opportunityRecord.Trigger_Approval_Process__c", "Match Risk Check");
                            component.set("v.opportunityRecord.Approval_Status__c", "Pending");
                            component.set("v.opportunityRecord.Merchant_Match_Inquiry_Passed__c", false);
                        }else{
                            toastMessage = 'Match Inquiry check complete - No results returned';
                        }
                        component.set("v.opportunityRecord.Merchant_Match_Inquiry_Passed__c", true);
                        
                        component.find("opportunityForm").saveRecord($A.getCallback(function(saveResult) {
                            if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {
                                helper.fireToast('Success', toastMessage, 'success');
                            } else if (saveResult.state === "INCOMPLETE") {
                                component.set("v.errorMessage", "User is offline, device doesn't support drafts.");
                            } else if (saveResult.state === "ERROR") {
                                component.set("v.errorMessage", 'Problem saving record, error: ' + JSON.stringify(saveResult.error));
                            } else {
                                component.set("v.errorMessage", 'Unknown problem, state: ' + saveResult.state + ', error: ' + JSON.stringify(saveResult.error));
                            }
                        }));
                        //End Changes By Himani #W-005294
                        
                        $A.get('e.force:refreshView').fire();
                    } else {
                        var errorValue = null;
                        if(serviceResponse.Error != null ) {
                            console.log('serviceResponse.Errors : ' + serviceResponse.Error);
                            errorValue = serviceResponse.Error.Description;
                            this.fireToast('Match Risk Error', errorValue, 'Error');
                        } else if(serviceResponse.Errors != null && serviceResponse.Errors.Error_Z != null) {
                            console.log('serviceResponse.Error_Z : ' + serviceResponse.Errors.Error_Z);
                            errorValue = serviceResponse.Errors.Error_Z.Description;
                            this.fireToast('Match Risk Error', errorValue, 'Error');
                        } else if (serviceResponse.Errors != null && serviceResponse.Errors.Error != null) {
                            if(serviceResponse.Errors.Error.Description != null) {
                                errorValue = serviceResponse.Errors.Error.Description;
                            } else {
                                var errorLst = serviceResponse.Errors.Error;
                                for (var item in errorLst){
                                    console.log(errorLst[item].Description);
                                    if(!errorValue) {
                                        errorValue = errorLst[item].Description;
                                    } else {
                                        errorValue = errorValue + ';' + errorLst[item].Description;
                                    }
                                    
                                }
                            }
                            this.fireToast('Match Risk Error', errorValue, 'Error');
                        }
                        component.set('v.showMatchRiskTable',false);
                        this.hideSpinner(component);
                    }
                }else {
                    //Show error
                    this.hideSpinner(component);
                    this.fireToast('Match Risk Error', 'Match Risk Failed: Please contact your System Administrator', 'Error');
                }
                
                //this.hideSpinner(component);
                
            }else if(state === "ERROR"){
                var errors = res.getError();
                console.log('callMerchantMatchService.errors: ' + JSON.stringify(errors));
                component.set("v.errorMessage", "getApplication: Apex error: [" + JSON.stringify(errors) + "]. ");
                this.hideSpinner(component);
            } else {
                component.set("v.errorMessage", "getApplication: Apex error. ");
            }
            
        });
        $A.enqueueAction(action);
    },
    
    //Show lightning spinner
    showSpinner: function (component) {
        var spinner = component.find("theSpinner");
        $A.util.removeClass(spinner, "slds-hide");
    },
    
    //Hide lightning spinner
    hideSpinner: function (component) {
        var spinner = component.find("theSpinner");
        $A.util.addClass(spinner, "slds-hide");
    },
    
    //Lightning toastie
    fireToast : function(title, msg, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title":title,
            "message":msg,
            "type":type
        });
        toastEvent.fire();
    },
    
    //getInquiryData - Tinashe M Shoko
    //
    getInquiryData : function(component, event, helper) {
        component.set('v.possibleInquiryMerchantMatchesColumns', [
            {label: 'Date', fieldName: 'today', type: 'date'},
            {label: 'Business Name', fieldName: 'inquiryBusName', type: 'Text', wrapText: true},
            {label: 'City', fieldName: 'inquiryCity', type: 'text'},
            {label: 'Country', fieldName: 'inquiryCountry', type: 'Text'},
            {label: 'Reason Code', fieldName: 'inquiryReasonCode', type: 'Text'}]);
        
        var matchRequestBeanStr = component.get('v.matchRequestBeanString');
        matchRequestBeanStr = matchRequestBeanStr.substr(1,matchRequestBeanStr.length-2).replace(/&quot;/g,'"');
        var inquiryhAction = component.get("c.getMatchTerminationInquiry_Req_IB_v1List");
        
        inquiryhAction.setParams({
            "jsonStr" : matchRequestBeanStr
        });
        inquiryhAction.setCallback(this,function(response){
            var state = response.getState();
            if(state == "SUCCESS"){
                var responseValue = JSON.parse(response.getReturnValue());
                if (responseValue != null) {
                    var merchantData = [];
                    var principalData = [];
                    var inquiryBusName = responseValue[0].TerminationInquiryRequest.Merchant.Name;
                    var inquiryDoingBusAs = responseValue[0].TerminationInquiryRequest.Merchant.DoingBusinessAsName;
                    var inquiryMerchantID = 'N/A';
                    var inquiryMerchantcategoryCode = 'N/A';
                    var inquiryAddressLine1 = responseValue[0].TerminationInquiryRequest.Merchant.Address.Line1;
                    var inquiryAddressLine2 = responseValue[0].TerminationInquiryRequest.Merchant.Address.Line2;
                    var inquiryCity = responseValue[0].TerminationInquiryRequest.Merchant.Address.City;
                    var inquiryCountry = responseValue[0].TerminationInquiryRequest.Merchant.Address.Country;
                    var inquiryCode = 'N/A';
                    var inquiryPhoneNumber = responseValue[0].TerminationInquiryRequest.Merchant.PhoneNumber;
                    var inquiryAltPhoneNumber = responseValue[0].TerminationInquiryRequest.Merchant.AltPhoneNumber;
                    var inquiryNationalTaxID = responseValue[0].TerminationInquiryRequest.Merchant.NationalTaxId;
                    var inquirydateAddedOn = responseValue[0].TerminationInquiryRequest.Merchant.AddedOnDate;
                    var inquiryServiceProviderLegal = 'N/A';
                    var inquiryServiceProviderDBA = 'N/A';
                    var inquiryReasonCode = 'N/A';
                    
                    var resp = 'resp';
                    var today = new Date();
                    var dd = String(today.getDate()).padStart(2, '0');
                    var mm = String(today.getMonth() + 1).padStart(2, '0'); //January is 0!
                    var yyyy = today.getFullYear();
                    
                    today = mm + '/' + dd + '/' + yyyy;
                    
                    merchantData.push({Id: resp,inquiryBusName: inquiryBusName, inquiryDoingBusAs: inquiryDoingBusAs,
                                       inquiryMerchantID: inquiryMerchantID, inquiryMerchantcategoryCode: inquiryMerchantcategoryCode,
                                       inquiryMerchantcategoryCode: inquiryMerchantcategoryCode, inquiryAddressLine1: inquiryAddressLine1,
                                       inquiryAddressLine2: inquiryAddressLine2,inquiryCity: inquiryCity, inquiryCountry: inquiryCountry, inquiryCode: inquiryCode,
                                       inquiryPhoneNumber: inquiryPhoneNumber, inquiryAltPhoneNumber: inquiryAltPhoneNumber,
                                       inquiryNationalTaxID: inquiryNationalTaxID, inquirydateAddedOn: inquirydateAddedOn,
                                       inquiryServiceProviderLegal: inquiryServiceProviderLegal, inquiryServiceProviderDBA: inquiryServiceProviderDBA,
                                       inquiryReasonCode: inquiryReasonCode, today: today});
                    
                    var inquiryPrincipalsLength = responseValue[0].TerminationInquiryRequest.Merchant.Principal.length;
                    
                    for (var j=0; j<inquiryPrincipalsLength; j++) {
                        var inqPrincipalFirstName = responseValue[0].TerminationInquiryRequest.Merchant.Principal[j].FirstName;
                        var inqPrincipalMiddleInitial = '';
                        var inqPrincipalLastname = responseValue[0].TerminationInquiryRequest.Merchant.Principal[j].LastName;
                        var inqPrincipalAddrLine1 = responseValue[0].TerminationInquiryRequest.Merchant.Principal[j].Address.Line1;
                        var inqPrincipalAddrLine2 = responseValue[0].TerminationInquiryRequest.Merchant.Principal[j].Address.Line1;
                        var inqPrincipalAddrCity = responseValue[0].TerminationInquiryRequest.Merchant.Principal[j].Address.City;
                        var inqPrincipalAddrCountry = responseValue[0].TerminationInquiryRequest.Merchant.Principal[j].Address.Country;
                        var inqPrincipalAddrCode = 'N/A';
                        var inqPrincipalPhoneNumber = responseValue[0].TerminationInquiryRequest.Merchant.Principal[j].PhoneNumber;
                        var inqPrincipalAltPhoneNumber = responseValue[0].TerminationInquiryRequest.Merchant.Principal[j].AltPhoneNumber;
                        var inqPrincipalNationalIDSSN = responseValue[0].TerminationInquiryRequest.Merchant.Principal[j].NationalId;
                        var inqPrincipalDriverLicenseNumber = responseValue[0].TerminationInquiryRequest.Merchant.Principal[j].DriversLicense.Number;
                        var inqPrincipalDriverLicenseCountry = responseValue[0].TerminationInquiryRequest.Merchant.Principal[j].DriversLicense.Country;
                        
                        principalData.push({id: j,inqPrincipalFirstName: inqPrincipalFirstName, inqPrincipalLastname: inqPrincipalLastname,
                                            inqPrincipalAddrLine1: inqPrincipalAddrLine1, inqPrincipalAddrLine2: inqPrincipalAddrLine1,
                                            inqPrincipalAddrCity: inqPrincipalAddrCity, inqPrincipalAddrCountry: inqPrincipalAddrCountry,
                                            inqPrincipalAddrCode: inqPrincipalAddrCode, inqPrincipalPhoneNumber: inqPrincipalPhoneNumber,
                                            inqPrincipalAltPhoneNumber: inqPrincipalAltPhoneNumber, inqPrincipalNationalIDSSN: inqPrincipalNationalIDSSN,
                                            inqPrincipalDriverLicenseNumber: inqPrincipalDriverLicenseNumber, inqPrincipalDriverLicenseCountry: inqPrincipalDriverLicenseCountry});
                    }
                    component.set("v.inquiryMerchantData", merchantData);
                    component.set("v.inquiryPrincipalData", principalData);
                }
            }else if(state === "ERROR"){
                var errors = response.getError();
                console.log('getMatchTerminationInquiry_Req_IB_v1List.errors: ' + JSON.stringify(errors));
                component.set("v.errorMessage", "getApplication: Apex error: [" + JSON.stringify(errors) + "]. ");
                //this.hideSpinner(component);
            } else {
                component.set("v.errorMessage", "getApplication: Apex error. ");
            }
        });
        $A.enqueueAction(inquiryhAction);
    },
    
    //formatMatchReport - Tinashe M Shoko
    //
    formatMatchReport : function(component, event, helper) {
        component.set('v.possibleMerchantMatchescolumns', [
            {label: 'Date', fieldName: 'addedOnDate', type: 'date'},
            {label: 'Acquirer ID', fieldName: 'addedByAcquirerID', type: 'Text'},
            {label: 'Business Name', fieldName: 'businessName', type: 'Text', wrapText: true},
            {label: 'City', fieldName: 'city', type: 'text'},
            {label: 'Country', fieldName: 'country', type: 'Text'},
            {label: 'Reason Code', fieldName: 'terminationReasonCode', type: 'Text', wrapText: true}]);
        
        var dataTable = component.get("v.matchData");
        component.set("v.businessName", dataTable[0].BusinessName);
        component.set("v.operator", dataTable[0].Operator);
        component.set("v.city", dataTable[0].City);
        component.set("v.country", dataTable[0].Country);
        component.set("v.dateOfEnquiry", $A.localizationService.formatDate(dataTable[0].CreatedDate, "MMM dd, yyyy"));
        component.set("v.timeOfEnquiry", $A.localizationService.formatDate(dataTable[0].CreatedDate,"hh:mm:ss a"));
        
        var matchResponseBeanStr = component.get('v.matchResponseBeanString');
        matchResponseBeanStr = matchResponseBeanStr.substr(1,matchResponseBeanStr.length-2).replace(/&quot;/g,'"');
        var matchAction = component.get("c.getMatchTerminationInquiry_Resp_IB_v1List");
        
        matchAction.setParams({
            "jsonStr" : matchResponseBeanStr
        });
        matchAction.setCallback(this,function(response){
            var state = response.getState();
            if(state == "SUCCESS"){
                var responseValue = JSON.parse(response.getReturnValue());
                if (responseValue != null) {
                    component.set("v.transactionReferenceNumber", responseValue[0].TerminationInquiry.TransactionReferenceNumber);
                    var possibleMerchantMatches = [];
                    var merchantData = [];
                    var principalData = [];
                    var inquiryMerchantData = component.get("v.inquiryMerchantData");
                    var inquiryPrincipalData = component.get("v.inquiryPrincipalData");
                    
                    var inquiryPrincipalDataLength = inquiryPrincipalData.length;
                    for (var i=0; i<responseValue.length; i++) {
                        if (responseValue[i].TerminationInquiry.PossibleMerchantMatches != null) {
                            var possibleMerchantMatchesLength = responseValue[i].TerminationInquiry.PossibleMerchantMatches.length;
                            var resp = 'resp';
                            resp = resp.concat(resp, i.toString());
                            for (var j=0; j<possibleMerchantMatchesLength; j++) { // PossibleMerchantMatches loop
                                if (responseValue[i].TerminationInquiry.PossibleMerchantMatches[j].TerminatedMerchant != null) {
                                    var terminatedMerchantLength = responseValue[i].TerminationInquiry.PossibleMerchantMatches[j].TerminatedMerchant.length;
                                    var pmm = 'pmm';
                                    pmm = pmm.concat(resp,j.toString());
                                    for (var k=0; k<terminatedMerchantLength; k++) { // TerminatedMerchant loop
                                        var principalMatchLength = responseValue[i].TerminationInquiry.PossibleMerchantMatches[i].TerminatedMerchant[k].Merchant.Principal.length;
                                        
                                        var varAddedOnDate = responseValue[i].TerminationInquiry.PossibleMerchantMatches[j].TerminatedMerchant[k].Merchant.AddedOnDate;
                                        var varAddedByAcquirerID = responseValue[i].TerminationInquiry.PossibleMerchantMatches[j].TerminatedMerchant[k].Merchant.AddedByAcquirerID;
                                        var varBusinessName = responseValue[i].TerminationInquiry.PossibleMerchantMatches[j].TerminatedMerchant[k].Merchant.Name;
                                        var varCity = responseValue[i].TerminationInquiry.PossibleMerchantMatches[j].TerminatedMerchant[k].Merchant.Address.City;
                                        var varCountry = responseValue[i].TerminationInquiry.PossibleMerchantMatches[j].TerminatedMerchant[k].Merchant.Address.Country;
                                        var varTerminationReasonCode = responseValue[i].TerminationInquiry.PossibleMerchantMatches[j].TerminatedMerchant[k].Merchant.TerminationReasonCode;
                                        var varDoingBusinessAsName = responseValue[i].TerminationInquiry.PossibleMerchantMatches[j].TerminatedMerchant[k].Merchant.DoingBusinessAsName;
                                        var varAddressLine1 = responseValue[i].TerminationInquiry.PossibleMerchantMatches[j].TerminatedMerchant[k].Merchant.Address.Line1;
                                        var varAddressLine2 = responseValue[i].TerminationInquiry.PossibleMerchantMatches[j].TerminatedMerchant[k].Merchant.Address.Line2;
                                        var varAddressCountrySubdivision = responseValue[i].TerminationInquiry.PossibleMerchantMatches[j].TerminatedMerchant[k].Merchant.Address.CountrySubdivision;
                                        var varAddressProvince = responseValue[i].TerminationInquiry.PossibleMerchantMatches[j].TerminatedMerchant[k].Merchant.Address.Province;
                                        var varAddressPostalCode = responseValue[i].TerminationInquiry.PossibleMerchantMatches[j].TerminatedMerchant[k].Merchant.Address.PostalCode;
                                        var varPhoneNumber = responseValue[i].TerminationInquiry.PossibleMerchantMatches[j].TerminatedMerchant[k].Merchant.PhoneNumber;
                                        var varAltPhoneNumber = responseValue[i].TerminationInquiry.PossibleMerchantMatches[j].TerminatedMerchant[k].Merchant.AltPhoneNumber;
                                        var varNationalTaxId = responseValue[i].TerminationInquiry.PossibleMerchantMatches[j].TerminatedMerchant[k].Merchant.NationalTaxId;
                                        var varCountrySubdivisionTaxId = responseValue[i].TerminationInquiry.PossibleMerchantMatches[j].TerminatedMerchant[k].Merchant.CountrySubdivisionTaxId;
                                        var varServiceProvLegal = responseValue[i].TerminationInquiry.PossibleMerchantMatches[j].TerminatedMerchant[k].Merchant.ServiceProvLegal;
                                        var varServiceProvDBA = responseValue[i].TerminationInquiry.PossibleMerchantMatches[j].TerminatedMerchant[k].Merchant.ServiceProvDBA;
                                        var varUrl = responseValue[i].TerminationInquiry.PossibleMerchantMatches[j].TerminatedMerchant[k].Merchant.Url;
                                        var varIndex = i+1;
                                        var termm = 'termm';
                                        termm = termm.concat(pmm,k.toString());
                                        
                                        merchantData.push({Id: termm, respId: i, posMMId: j, merchantName: varBusinessName, doingBusinessAs: varDoingBusinessAsName,
                                                           merchantId: 'N/A', merchantCategoryCode: 'N/A', line1: varAddressLine1,
                                                           line2: varAddressLine2, city: varCity, country: varCountry, code: varAddressPostalCode,
                                                           phoneNumber: varPhoneNumber, altPhoneNumber: varAltPhoneNumber, nationalTaxID: varNationalTaxId, dateAddedOn: varAddedOnDate,
                                                           serviceProviderLegal: varServiceProvLegal, serviceProviderDBA: varServiceProvDBA,
                                                           reasonCode: varTerminationReasonCode, index: varIndex, totalLength: terminatedMerchantLength,
                                                           inquiryBusName: inquiryMerchantData[0].inquiryBusName, inquiryDoingBusAs: inquiryMerchantData[0].inquiryDoingBusAs,
                                                           inquiryMerchantID: inquiryMerchantData[0].inquiryMerchantID, inquiryMerchantcategoryCode: inquiryMerchantData[0].inquiryMerchantcategoryCode,
                                                           inquiryAddressLine1: inquiryMerchantData[0].inquiryAddressLine1,
                                                           inquiryAddressLine2: inquiryMerchantData[0].inquiryAddressLine2,inquiryCity: inquiryMerchantData[0].inquiryCity, inquiryCountry: inquiryMerchantData[0].inquiryCountry, inquiryCode: inquiryMerchantData[0].inquiryCode,
                                                           inquiryPhoneNumber: inquiryMerchantData[0].inquiryPhoneNumber, inquiryAltPhoneNumber: inquiryMerchantData[0].inquiryAltPhoneNumber,
                                                           inquiryNationalTaxID: inquiryMerchantData[0].inquiryNationalTaxID, inquirydateAddedOn: inquiryMerchantData[0].inquirydateAddedOn,
                                                           inquiryServiceProviderLegal: inquiryMerchantData[0].inquiryServiceProviderLegal, inquiryServiceProviderDBA: inquiryMerchantData[0].inquiryServiceProviderDBA,
                                                           inquiryReasonCode: inquiryMerchantData[0].inquiryReasonCode, today: inquiryMerchantData[0].today
                                                          });
                                        var plength;
                                        if (principalMatchLength >= inquiryPrincipalDataLength) {
                                            plength = principalMatchLength;
                                        } else {
                                            plength = inquiryPrincipalDataLength;
                                        }
                                        for (var l=0; l<plength; l++) { // TerminatedMerchant loop
                                            if (l<=principalMatchLength-1) {
                                                var varPrincipalFirstName = responseValue[i].TerminationInquiry.PossibleMerchantMatches[j].TerminatedMerchant[k].Merchant.Principal[l].FirstName;
                                                var varPrincipalMiddleInitial = responseValue[i].TerminationInquiry.PossibleMerchantMatches[j].TerminatedMerchant[k].Merchant.Principal[l].MiddleInitial;
                                                var varPrincipalLastName = responseValue[i].TerminationInquiry.PossibleMerchantMatches[j].TerminatedMerchant[k].Merchant.Principal[l].LastName;
                                                var varPrincipalAddressLine1 = responseValue[i].TerminationInquiry.PossibleMerchantMatches[j].TerminatedMerchant[k].Merchant.Principal[l].Address.Line1;
                                                var varPrincipalAddressLine2 = responseValue[i].TerminationInquiry.PossibleMerchantMatches[j].TerminatedMerchant[k].Merchant.Principal[l].Address.Line2;
                                                var varPrincipalAddressCity = responseValue[i].TerminationInquiry.PossibleMerchantMatches[j].TerminatedMerchant[k].Merchant.Principal[l].Address.City;
                                                var varPrincipalAddressCountry = responseValue[i].TerminationInquiry.PossibleMerchantMatches[j].TerminatedMerchant[k].Merchant.Principal[l].Address.Country;
                                                var varPrincipalAddressPostalCode = responseValue[i].TerminationInquiry.PossibleMerchantMatches[j].TerminatedMerchant[k].Merchant.Principal[l].Address.PostalCode;
                                                var varPrincipalPhoneNumber = responseValue[i].TerminationInquiry.PossibleMerchantMatches[j].TerminatedMerchant[k].Merchant.Principal[l].PhoneNumber;
                                                var varPrincipalAltPhoneNumber = responseValue[i].TerminationInquiry.PossibleMerchantMatches[j].TerminatedMerchant[k].Merchant.Principal[l].AltPhoneNumber;
                                                var varPrincipalNationalId = responseValue[i].TerminationInquiry.PossibleMerchantMatches[j].TerminatedMerchant[k].Merchant.Principal[l].NationalId;
                                                var varPrincipalDriversLicenseNumber = responseValue[i].TerminationInquiry.PossibleMerchantMatches[j].TerminatedMerchant[k].Merchant.Principal[l].DriversLicense.Number;
                                                var varPrincipalDriversLicenseCountry = responseValue[i].TerminationInquiry.PossibleMerchantMatches[j].TerminatedMerchant[k].Merchant.Principal[l].DriversLicense.Country;
                                            }
                                            var pmdata = 'pmdata';
                                            pmdata = pmdata.concat(termm,l.toString());
                                            if (l+1>inquiryPrincipalDataLength) {
                                                principalData.push({id: l+1,pmdata: pmdata, termId: termm, respId: i, posMMId: j, PrincipalFirstName: varPrincipalFirstName, PrincipalMiddleInitial: varPrincipalMiddleInitial,
                                                                    PrincipalLastName: varPrincipalLastName, PrincipalAddressLine1: varPrincipalAddressLine1,
                                                                    PrincipalAddressLine2: varPrincipalAddressLine2, PrincipalAddressCity: varPrincipalAddressCity,
                                                                    PrincipalAddressCountry: varPrincipalAddressCountry, PrincipalAddressPostalCode: varPrincipalAddressPostalCode,
                                                                    PrincipalPhoneNumber: varPrincipalPhoneNumber, PrincipalAltPhoneNumber: varPrincipalAltPhoneNumber,
                                                                    PrincipalNationalId: varPrincipalNationalId, PrincipalDriversLicenseNumber: varPrincipalDriversLicenseNumber,
                                                                    PrincipalDriversLicenseCountry: varPrincipalDriversLicenseCountry, principalMatchLength: plength,
                                                                    
                                                                    inqPrincipalFirstName: 'N/A', inqPrincipalLastname: 'N/A',
                                                                    inqPrincipalAddrLine1: 'N/A', inqPrincipalAddrLine2: 'N/A',
                                                                    inqPrincipalAddrCity: 'N/A', inqPrincipalAddrCountry: 'N/A',
                                                                    inqPrincipalAddrCode: 'N/A', inqPrincipalPhoneNumber: 'N/A',
                                                                    inqPrincipalAltPhoneNumber: 'N/A', inqPrincipalNationalIDSSN: 'N/A',
                                                                    inqPrincipalDriverLicenseNumber: 'N/A', inqPrincipalDriverLicenseCountry: 'N/A'
                                                                   });
                                                
                                            } else if (l+1>principalMatchLength) {
                                                principalData.push({id: l+1,pmdata: pmdata, termId: termm, respId: i, posMMId: j, PrincipalFirstName: 'N/A', PrincipalMiddleInitial: 'N/A',
                                                                    PrincipalLastName: 'N/A', PrincipalAddressLine1: 'N/A',
                                                                    PrincipalAddressLine2: 'N/A', PrincipalAddressCity: 'N/A',
                                                                    PrincipalAddressCountry: 'N/A', PrincipalAddressPostalCode: 'N/A',
                                                                    PrincipalPhoneNumber: 'N/A', PrincipalAltPhoneNumber: 'N/A',
                                                                    PrincipalNationalId: 'N/A', PrincipalDriversLicenseNumber: 'N/A',
                                                                    PrincipalDriversLicenseCountry: 'N/A', principalMatchLength: plength,
                                                                    
                                                                    inqPrincipalFirstName: inquiryPrincipalData[l].inqPrincipalFirstName, inqPrincipalLastname: inquiryPrincipalData[l].inqPrincipalLastname,
                                                                    inqPrincipalAddrLine1: inquiryPrincipalData[l].inqPrincipalAddrLine1, inqPrincipalAddrLine2: inquiryPrincipalData[l].inqPrincipalAddrLine1,
                                                                    inqPrincipalAddrCity: inquiryPrincipalData[l].inqPrincipalAddrCity, inqPrincipalAddrCountry: inquiryPrincipalData[l].inqPrincipalAddrCountry,
                                                                    inqPrincipalAddrCode: inquiryPrincipalData[l].inqPrincipalAddrCode, inqPrincipalPhoneNumber: inquiryPrincipalData[l].inqPrincipalPhoneNumber,
                                                                    inqPrincipalAltPhoneNumber: inquiryPrincipalData[l].inqPrincipalAltPhoneNumber, inqPrincipalNationalIDSSN: inquiryPrincipalData[l].inqPrincipalNationalIDSSN,
                                                                    inqPrincipalDriverLicenseNumber: inquiryPrincipalData[l].inqPrincipalDriverLicenseNumber, inqPrincipalDriverLicenseCountry: inquiryPrincipalData[l].inqPrincipalDriverLicenseCountry
                                                                    
                                                                   });
                                            } else {
                                                principalData.push({id: l+1,pmdata: pmdata, termId: termm, respId: i, posMMId: j, PrincipalFirstName: varPrincipalFirstName, PrincipalMiddleInitial: varPrincipalMiddleInitial,
                                                                    PrincipalLastName: varPrincipalLastName, PrincipalAddressLine1: varPrincipalAddressLine1,
                                                                    PrincipalAddressLine2: varPrincipalAddressLine2, PrincipalAddressCity: varPrincipalAddressCity,
                                                                    PrincipalAddressCountry: varPrincipalAddressCountry, PrincipalAddressPostalCode: varPrincipalAddressPostalCode,
                                                                    PrincipalPhoneNumber: varPrincipalPhoneNumber, PrincipalAltPhoneNumber: varPrincipalAltPhoneNumber,
                                                                    PrincipalNationalId: varPrincipalNationalId, PrincipalDriversLicenseNumber: varPrincipalDriversLicenseNumber,
                                                                    PrincipalDriversLicenseCountry: varPrincipalDriversLicenseCountry, principalMatchLength: plength,
                                                                    
                                                                    inqPrincipalFirstName: inquiryPrincipalData[l].inqPrincipalFirstName, inqPrincipalLastname: inquiryPrincipalData[l].inqPrincipalLastname,
                                                                    inqPrincipalAddrLine1: inquiryPrincipalData[l].inqPrincipalAddrLine1, inqPrincipalAddrLine2: inquiryPrincipalData[l].inqPrincipalAddrLine1,
                                                                    inqPrincipalAddrCity: inquiryPrincipalData[l].inqPrincipalAddrCity, inqPrincipalAddrCountry: inquiryPrincipalData[l].inqPrincipalAddrCountry,
                                                                    inqPrincipalAddrCode: inquiryPrincipalData[l].inqPrincipalAddrCode, inqPrincipalPhoneNumber: inquiryPrincipalData[l].inqPrincipalPhoneNumber,
                                                                    inqPrincipalAltPhoneNumber: inquiryPrincipalData[l].inqPrincipalAltPhoneNumber, inqPrincipalNationalIDSSN: inquiryPrincipalData[l].inqPrincipalNationalIDSSN,
                                                                    inqPrincipalDriverLicenseNumber: inquiryPrincipalData[l].inqPrincipalDriverLicenseNumber, inqPrincipalDriverLicenseCountry: inquiryPrincipalData[l].inqPrincipalDriverLicenseCountry
                                                                    
                                                                   });
                                            }
                                            
                                        }
                                    }
                                    possibleMerchantMatches.push({Id: i, posMMId: j,
                                                                  addedOnDate: varAddedOnDate, addedByAcquirerID: varAddedByAcquirerID,
                                                                  businessName: varBusinessName, city: varCity, country: varCountry,
                                                                  terminationReasonCode: varTerminationReasonCode});
                                }
                            }
                        }
                    }
                    component.set("v.possibleMerchantMatches", possibleMerchantMatches);
                    component.set("v.merchantData", merchantData);
                    component.set("v.principalData", principalData);
                }
            }else if(state === "ERROR"){
                var errors = response.getError();
                console.log('getMatchTerminationInquiry_Resp_IB_v1List.errors: ' + JSON.stringify(errors));
                component.set("v.errorMessage", "getApplication: Apex error: [" + JSON.stringify(errors) + "]. ");
                //this.hideSpinner(component);
            } else {
                component.set("v.errorMessage", "getApplication: Apex error. ");
            }
        });
        $A.enqueueAction(matchAction);
    },
})