({
    //Helper Class
    MAX_FILE_SIZE: 4500000, //Max file size 4.5 MB
    CHUNK_SIZE: 750000,      //Chunk Max size 750Kb
    
    callCIFService: function (component) {
        component.set("v.showConflictSpinner", true);
        var objectId = component.get("v.recordId");
        var CIFAddress = component.get("v.selectedCIFAddress");
        var gsAddress = component.get("v.selectedGoldenSourceAddress");
        
        if( CIFAddress != null ){
            var address1 = component.get("v.addressName1");
            var address2 = component.get("v.addressName2");
            var suburbName = component.get("v.suburbName");
            var cityName = component.get("v.cityName");
            var countryName = component.get("v.countryName");
            var postalCode = component.get("v.postalCode");
            var indicator = 'Y';
        }else if( gsAddress != null ){
            var address1 = component.get("v.gAddressName1");
            var address2 = component.get("v.gAddressName2");
            var suburbName = component.get("v.gSuburbName");
            var cityName = component.get("v.gCityName");
            var countryName = component.get("v.gCountryName");
            var postalCode = component.get("v.gPostalCode");
            var indicator = 'U';
        }
        var action = component.get("c.updateCIF");
        action.setParams({
            "objectId": objectId,
            "address1": address1,
            "address2": address2,
            "suburbName": suburbName,
            "cityName": cityName,
            "countryName": countryName,
            "postalCode": postalCode,
            "indicator": indicator,
            "sourceIncome"  : component.get("v.attestationSourceOfIncome"),
            "occupationStatus" :component.get("v.attestationstatus")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var respObj = JSON.parse(response.getReturnValue());
                if(respObj != null && respObj != undefined &&  respObj !=''){
                    component.set("v.showConflictSpinner", false);
                    var message = respObj.CIupdClientAttestationV20Response.outputArea.message;
                    var type= 'success';
                    this.showToast(component, event, message, type);
                    component.set('v.isAttestation',false);
                    component.set('v.isShowInit',true);
                    
                }else if(data == null){
                    component.set("v.showConflictSpinner", false);
                    var message = 'CIF Update Service Failed!';
                    var type= 'error';
                    this.showToast(component, event, message, type);
                    component.set('v.isAttestation',false);
                }
            }else{
                console.log("Failed with state: " +state);
                component.set("v.showConflictSpinner", false);
                var errors = response.getError();
                var message = errors[0].message;
                var type= 'error';
                this.showToast(component, event, message, type);
                component.set('v.isAttestation',false);
            }
        });
        $A.enqueueAction(action);
        
    },
    
    
    //helper method which will call the compliance pack service and gets the compliance information
    fetchData: function (component) {
        component.set("v.showSpinner", true);
        var objectId = component.get("v.recordId");
        var action = component.get("c.getData");
        action.setParams({
            "objectId": objectId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                if(data != null && data.message == null){
                    component.set("v.accRec",  data.accRec);
                    component.set("v.serviceGroup",  data.serviceGroup);
                    component.set("v.idNum", data.IDNum);
                    component.set("v.healthStatus", data.complianceStatus);
                    component.set("v.riskRating", data.riskRating);
                    component.set("v.fullName", data.fullName);
                    component.set("v.IDNumber", data.IDNumber);
                    component.set("v.partyType", data.partyType);
                    component.set("v.partySubType", data.partySubType);
                    component.set("v.Title", data.titleMap[data.fullName]);
                    component.set("v.nextRefreshDate", data.nextRefreshDate);
                    //component.set("v.lastRefreshDate", data.lastRefreshDate);
                    if(data.serviceGroup === true){
                        if(Date.parse(data.FICAAddressAttestedDate)>=Date.parse(data.IdentificationAttestedDate)){
                            component.set("v.lastRefreshDate", data.IdentificationAttestedDate);
                        }else{
                            component.set("v.lastRefreshDate", data.FICAAddressAttestedDate);
                        }
                    }
                    component.set("v.FICLockStatus", data.FICLockStatus);
                    component.set("v.missingData", data.missingData);
                    component.set("v.missingDocuments", data.missingDocuments);
                    component.set("v.FICAAddressAttestedDate", data.FICAAddressAttestedDate);
                    component.set("v.IdentificationAttestedDate", data.IdentificationAttestedDate);
                    component.set("v.PEPStatus", data.PEPStatus);
                    //component.set("v.partyRelationship", data.partyRelationship);
                    component.set("v.occupation", data.occupation);
                    component.set("v.purposeOfAccount", data.purposeOfAccount);
                    component.set("v.sourceOfFunds", data.sourceOfFunds);
                    component.set("v.notificationSent", data.notificationSent);
                    component.set("v.daysDue", data.daysDue);
                    if(data.serviceGroup === true){
                        if(parseInt(data.daysDue) > 90 && parseInt(data.daysDue) <=120){
                           component.set("v.notificationSent",'120 of 180 Days');
                        }else if(parseInt(data.daysDue) > 60 && parseInt(data.daysDue) <=90){
                           component.set("v.notificationSent",'90 of 180 Days');
                        }else if(parseInt(data.daysDue) > 30 && parseInt(data.daysDue) <=60){
                           component.set("v.notificationSent",'60 of 180 Days');
                        }else if(parseInt(data.daysDue) > 15 && parseInt(data.daysDue) <=30){
                            component.set("v.notificationSent",'30 of 180 Days');
                        }else if(parseInt(data.daysDue) > 0 && parseInt(data.daysDue) <=15){
                            component.set("v.notificationSent",'15 of 180 Days');
                        }else if(parseInt(data.daysDue) > 180){
                            component.set("v.notificationSent",'Customer is not due for refresh');
                        }else{
                            component.set("v.notificationSent",'None');
                        }
                    }
                    component.set("v.expectedTransactionActivity", data.expectedTransactionActivity);
                    component.set("v.addressName1", data.addressName1);
                    component.set("v.addressName2", data.addressName2);
                    component.set("v.suburbName", data.suburbName);
                    component.set("v.cityName", data.cityName);
                    component.set("v.countryName", data.countryName);
                    component.set("v.postalCode", data.postalCode);
                    var cifAddress = [];
                    cifAddress.push({
                        label: data.cifAddress,
                        value: 'CIF'
                    });
                    component.set("v.cifAddresses", cifAddress);
                    component.set("v.clientSearchResultColumns", data.DataLightning);
                    component.set("v.IsRBBBanker", data.IsRBBBanker);
                    component.set("v.gAddressName1", data.gAddressName1);
                    component.set("v.gAddressName2", data.gAddressName2);
                    component.set("v.gSuburbName", data.gSuburbName);
                    component.set("v.gCityName", data.gCityName);
                    component.set("v.gCountryName", data.gCountryName);
                    component.set("v.gPostalCode", data.gPostalCode);
                    // Mapping the values with Custom Metadta and passing it to FICManuaUserRefresh Component by Mohammed Junaid u
                    component.set("v.NADashboardValues", data.NADashboardValues);
                    var obj = data.NADashboardValues;
                    component.set("v.NANextRefreshDate", obj['Next Refresh Date'] );
                    component.set("v.NAPartySubtype", obj['Party subType']);
                    var goldenSourceAddress = [];
                    goldenSourceAddress.push({
                        label: data.goldenSourceAddress,
                        value: 'goldenSource'
                    });
                    component.set("v.goldenSourceAddresses", goldenSourceAddress);
                    component.set("v.attestationstatus", data.attestationstatus);
                    component.set("v.attestationSourceOfIncome", data.attestationSourceOfIncome);
                    if(data.goldenSourceAddress != null && data.goldenSourceAddress != ''){
                        component.set("v.isgoldenSourceAddress", true);
                    }
                    if(data.cifAddress != null && data.cifAddress != ''){
                        component.set("v.iscifAddress", true);
                    }
                    if(data.attestation == true){
                        var refreshDate = data.nextRefreshDate;
                        var todayDate = new Date();
                        refreshDate = new Date(refreshDate);
                        var timeDifference = refreshDate.getTime() - todayDate.getTime();
                        var daysDifference = Math.ceil(timeDifference / (1000 * 3600 * 24));
                        var compliantStatus = data.complianceStatus;
                        compliantStatus = compliantStatus.replace(/\s+/g, '');
                        compliantStatus = compliantStatus.toLowerCase();
                        console.log('The Compliant Status is: '+compliantStatus);
                        console.log('The days difference is: '+daysDifference);
                        if(compliantStatus == "partialcompliant" && daysDifference <= 180 ){
                            component.set("v.attestation", data.attestation);
                        	this.fetchPicklistvalues(component, event,'Source_of_Income__c');
                            this.fetchPicklistvalues(component, event,'Occupation_Status__c');}
                    }
                    this.getImageInfo(component);
                }else if(data != null && data.message != null){
                    component.set("v.dataFound", false);
                    var errors = data.message;
                    component.set("v.showSpinner", false);
                    component.set("v.showError",true);
                    component.set("v.errorMessage",errors);
                }else{
                    component.set("v.dataFound", false);
                    var errors = 'There is no data found for this Account';
                    component.set("v.showSpinner", false);
                    component.set("v.showError",true);
                    component.set("v.errorMessage",errors);
                }
            }
            else{
                console.log("Failed with state: " +state);
                component.set("v.dataFound", false);
                component.set("v.showSpinner", false);
                component.set("v.showError",true);
                var errors = response.getError();
                component.set("v.errorMessage",errors[0].message);
            }
        });
        $A.enqueueAction(action);
        
    },
    
    //Helper function that will get us the profile pic that is to be displayed on the dashboard.
    getImageInfo: function(component) {
        var accRec = component.get("v.accRec");
        if (accRec.Client_Type__c == 'Individual' || accRec.Client_Type__c =='Individual - Minor' || accRec.Client_Type__c == 'Non - Resident Entity' || accRec.Client_Type__c == 'Private Individual' || accRec.Client_Type__c == 'Staff' || accRec.Client_Type__c == 'Staff Joint and Several'){
            var action = component.get("c.callHanisService");
            var idNo = component.get("v.idNum");
            action.setParams({
                idNumber: idNo
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                var message = "";
                if (component.isValid() && state === "SUCCESS") {
                    var respObjHanis = JSON.parse(response.getReturnValue());
                    component.set('v.hanisResponse',respObjHanis);
                    if (respObjHanis.statusCode == 200) {
                        if(respObjHanis.image != null  && respObjHanis.image != ''){
                            var src = "data:image/png;base64, ";
                            src += respObjHanis.image;
                            component.set("v.image", src);}
                        else{
                            var msg = 'No Profile Pic available for this individual';
                        	var type= 'error';
                        	this.showToast(component, event, msg, type);
                        }
                    }else{
                        var msg = 'Profile Picture Download Failed! ';
                        var type= 'error';
                        this.showToast(component, event, msg, type);
                    }
                }else{
                    var errors = response.getError();
                    component.set("v.errorMessage",errors[0].message);
                    var msg = 'The image download failed as, '+errors[0].message;
                    var type= 'error';
                    this.showToast(component, event, msg, type );
                }
                component.set("v.showSpinner", false);
            });
            $A.enqueueAction(action);
        } else{
            var msg = "No Profile Pic it's an Entity";
            var type= 'error';
            this.showToast(component, event, msg, type );
            component.set("v.showSpinner", false);
        } 
    },
    
    //Used to get the Account Field Set to determine which Client results columns to display
    //We are already getting the Fica Requirements details from FetchData helper method so we have commented the aura handler
    getClientFieldSet: function(component, event) {
        var objectId = component.get("v.recordId");
        var action = component.get("c.getTableFields");
        action.setParams({
            "objectId": objectId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.clientSearchResultColumns", response.getReturnValue());
            } else if (state === "ERROR") {
                var msg = 'There was an error while fetching FICA Requirements';
                var type = 'error';
                this.showToast(component, event, msg, type );
            }
            
        });
        $A.enqueueAction(action);
    },
    
    //Function which calls the big form to update the missing data
    callSaveComp : function(component, event, helper){
        var recId = component.get("v.recordId");
        var evt = $A.get("e.force:navigateToComponent");
        console.log('Event '+evt);
        evt.setParams({
            componentDef : "c:ContinueWithOnboarding" ,
            componentAttributes : {
                recordId : recId
            }
        });
        evt.fire();
    },
    
    
    showSuccessToast : function(component, event, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "type" : "success",
            "message": message
        });
        toastEvent.fire();
    },
    
    showToast : function(component, event, message, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type" : type,
            "message": message
        });
        toastEvent.fire();
    },
    
    /**
* @description download function to download file from AMBER.
**/
    download: function (cmp, row) {
        var objectId = cmp.get("v.recordId");
        var action = cmp.get("c.getUploadedDoc");
        cmp.set("v.showSmallSpinner", true);
        
        action.setParams({
            parentId : objectId,
            documentType : row.missingDoc
        });
        action.setCallback(
            this,
            $A.getCallback(function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var obj = response.getReturnValue();
                    if(obj != null){
                        var msg = 'File Is Downloaded Succesfully !!!';
                        /* var jObj = JSON.stringify(response.getReturnValue());
                    console.log(jObj);
                    var obj = JSON.parse(jObj);
                    console.log(obj);
                    var data = obj.Data;
                    var fileName = obj.FileName; */
                        console.log('The data is : '+ obj['Data'] );
                        var element = document.createElement("a");
                        element.setAttribute("href", "data:application/octet-stream;content-disposition:attachment;base64," + obj['Data']);
                        element.setAttribute("download", obj['FileName']);
                        element.style.display = "none";
                        document.body.appendChild(element);
                        element.click();
                        document.body.removeChild(element);
                        cmp.set("v.showSmallSpinner", false);
                        this.showSuccessToast(cmp, event, msg);}
                } else {
                    var errors = response.getError();
                    cmp.set("v.errorMessage",errors[0].message);
                    cmp.set("v.showSmallSpinner", false);
                    var msg = 'The download failed as, '+errors[0].message;
                    var type = 'error';
                    this.showToast(cmp, event, msg, type);
                }
            })
        );
        $A.enqueueAction(action);
    },
    
    //redirect to Hl_clinetAttestation
    attestCustomer : function(component, event, helper){
        var recId = component.get("v.recordId");
        var navigateEvent = $A.get("e.force:navigateToComponent");
        navigateEvent.setParams({
            componentDef: "c:HL_ClientAttestation",
            componentAttributes : {
                recordId : recId,
                missingDocuments :  component.get("v.missingDocuments"),
                missingData :component.get("v.missingData"),
                healthStatus :component.get("v.healthStatus"),
                daysDue :component.get("v.daysDue"),
                jointsParentCode :component.get("v.jointsParentCode")
            }
            
        });
        navigateEvent.fire();
    },
    fetchPicklistvalues : function(component, event, fieldName){
        var objectName;
        if(fieldName == 'Source_of_Income__c'){
            objectName = 'Account';
        }
        else{
            objectName = 'Contact';
        }
        var action = component.get("c.getPickListValues");
        action.setParams({
            "objectName": objectName,
            "selectedField":fieldName
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var list = response.getReturnValue();
                if(fieldName == 'Source_of_Income__c'){
                    component.set("v.sourceOfIncomePicklistValues", list);
                }else if(fieldName == 'Occupation_Status__c'){
                    component.set("v.occupationStatusPicklistValues", list);
                }
            }else{
                var Msg = 'Failed To fetch the Picklist values';
            }
        });
        $A.enqueueAction(action);
    },

    checkUser: function(component, event, helper) { 
        let action = component.get("c.checkAICUser");
        action.setCallback(this, function(response) {
            let state = response.getState();
            let responseData = response.getReturnValue();

            if (state === "SUCCESS") {
                if (!$A.util.isEmpty(responseData)) {
                  if(responseData === true){
                      component.set("v.isAICUser", true);
                  }

                }

            } else if (state === "ERROR") {
                let errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },

})