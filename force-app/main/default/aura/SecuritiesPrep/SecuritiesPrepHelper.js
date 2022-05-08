({
    loadSecurities: function (component, event, helper) {
        helper.showSpinner(component);
        var OpportunityId = component.get("v.recordId");
        var action = component.get("c.getSecuritiesOffered");
        action.setParams({
            "oppId": OpportunityId
        });
        action.setCallback(this, function (res) {
            var state = res.getState();
            if (state === "SUCCESS") {
                var nameList = [];
                var mandatedOfficialsList = [];
                var serviceResponse = res.getReturnValue();
                var existingSecurities;
                if (serviceResponse['securitiesOfferedList']) {
                    existingSecurities = serviceResponse['securitiesOfferedList'];
                    var conList = serviceResponse['conlist'];
                    for (var i in conList) {
                        nameList.push({
                            label: conList[i].Contact.Name,
                            value: conList[i].Contact.Name
                        });
                        mandatedOfficialsList.push({
                            label: conList[i].Contact.Name,
                            value: conList[i].Contact.Name
                        });
                    }
                }
                component.set('v.nameList', nameList);
                component.set('v.mandatedOfficialsList', mandatedOfficialsList);
                component.set('v.existingSecurities', existingSecurities);
                component.set('v.existingSecuritiesWrapper', serviceResponse['securityWrapperList']);
                console.log('existingSecuritiesWrapper::: ' + JSON.stringify(serviceResponse['securityWrapperList']));
            }
            helper.hideSpinner(component);
        });
        $A.enqueueAction(action);
    },

    // Added by Diksha For Flight Centre Case Creation W-007167
    createFlightCentreCase: function (component, event, helper) {
        var OpportunityId = component.get("v.recordId");
        var action = component.get("c.createBondRegistrationCase");
        console.log('selectedSecurity'+component.get('v.selectedSecurity'));
        console.log('oppId'+OpportunityId);
        console.log('accId'+component.get("v.accountRecord").AccountId);
        
        action.setParams({
            "oppId": OpportunityId,
            "accId": component.get("v.accountRecord").AccountId,
            "secId": component.get("v.selectedSecurity"),
            "caseRecType": "Bond Registration Flight Centre"
        });
         action.setCallback(this, function (res) {
            var state = res.getState();
            if (state === "SUCCESS") {
               var serviceResponse = res.getReturnValue();
                if(serviceResponse){
                    helper.fireToast("Success", "Case created Successfully. ", "success");
                }
            }})
        $A.enqueueAction(action);
            
         
    },

    //Open Modal
    openSecurityLinkModal: function (component) {
        $A.util.addClass(component.find('linkSecurityProviderModal'), 'slds-fade-in-open');
        $A.util.addClass(component.find('Modalbackdrop'), 'slds-backdrop--open');
    },

    //Close Modal
    closeSecurityLinkModal: function (component) {
        component.set("v.errorMessageModal", null);
        component.set("v.accountData", null);
        $A.util.removeClass(component.find('Modalbackdrop'), 'slds-backdrop--open');
        $A.util.removeClass(component.find('linkSecurityProviderModal'), 'slds-fade-in-open');
    },

    //Show Spinner
    showSpinner: function (component) {
        component.set("v.showSpinner", true);
    },

    //Hide Spinner
    hideSpinner: function (component) {
        component.set("v.showSpinner", false);
    },

    //Lightning toastie
    fireToast: function (title, msg, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: title,
            message: msg,
            type: type
        });
        toastEvent.fire();
    },

    getAddresses: function (component, accId, conId) {
        var searchId;
        if (conId != null) {
            searchId = conId;
        } else {
            searchId = accId;
        }
        var action = component.get("c.getAddresses");
        action.setParams({
            "accId": searchId
        });
        action.setCallback(this, function (res) {
            var state = res.getState();
            if (state === "SUCCESS") {
                component.set("v.addressList", res.getReturnValue());
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.log('Callback to getAddresses Failed. Error : [' + JSON.stringify(errors) + ']');
            } else {
                console.log('Callback to getAddresses Failed.');
            }
        });
        $A.enqueueAction(action);
    },

    /**    insertSecurityContactRecords : function(component,selectedSecurity, selectedListForName, role){
            var action = component.get("c.insertSecurityContactRecords");
            action.setParams({
                "selectedSecurity": selectedSecurity,
                "selectedListForName" : selectedListForName,
                "role": role
            });
            action.setCallback(this,function(res){
                var state = res.getState();
                if(state==="SUCCESS"){
                    //do Nothing
                }
            });
            $A.enqueueAction(action);
        },**/

    //JQUEV
    getAccountDataHelper: function (component, event, helper) {
        component.set("v.isModalSpinner", true);
        //var action = component.get("c.getAccountData");
        var action = component.get("c.getAccountContactRelationData");
        var identifier = event.target.getAttribute('data-idNumber');
        var OpportunityId = component.get("v.recordId");
        action.setParams({
            identificationNumber: identifier,
            OpportunityId: OpportunityId
        });
        action.setCallback(this, function (response) {
            component.set("v.isModalSpinner", false);
            var state = response.getState();
            if (state === "SUCCESS") {
                var resp = response.getReturnValue();

                if (!$A.util.isEmpty(resp)) {
                    component.set('v.accountColumns', [
                        { label: 'Name', fieldName: 'Name', type: 'text' },
                        { label: 'ID Number', fieldName: 'ID_Number__pc', type: 'Text' },
                        { label: 'Passport Number', fieldName: 'Passport_Number__pc', type: 'Text' },
                        { label: 'Registration Number', fieldName: 'Registration_Number__c', type: 'Text' },
                        { label: 'CIF', fieldName: 'CIF__c', type: 'Text' }]);
                    var options = [];

                    for (var i = 0; i < resp.length; i++) {
                        options.push({
                            Id: resp[i].ContactId, Name: resp[i].Contact.Name, ID_Number__pc: resp[i].Account.ID_Number__pc,
                            Passport_Number__pc: resp[i].Account.Passport_Number__pc,
                            Registration_Number__c: resp[i].Account.Registration_Number__c, CIF__c: resp[i].Account.CIF__c
                        });
                    }
                    component.set("v.accountData", options);
                } else {
                    //show error message to create account
                    component.set("v.errorMessageModal", "No account found for ID/Passport/Registration Number: " + identifier + ". Please create an account for this security to link it to.");
                }
            } else if (state === "ERROR") {
                var errors = response.getError();
                component.set("v.errorMessage", "Apex error SecuritiesPrepController.getAccountData: " + JSON.stringify(errors));
            } else {
                component.set("v.errorMessage", "Unexpected error occurred, SecuritiesPrepController.getAccountData state returned: " + state);
            }
        });
        $A.enqueueAction(action);
    },

    showDocumentsStubs: function (component, event, helper, secType, secProvType, lim) {
        var action = component.get("c.getSecurityDocumentTypes");
        action.setParams({
            "securityType": secType,
            "securityProviderType": secProvType,
            "limited": lim
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.securityDocuments", response.getReturnValue());
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.log('Callback to getSecurityDocumentTypes Failed. Error : [' + JSON.stringify(errors) + ']');
            } else {
                console.log('Callback to getSecurityDocumentTypes Failed.');
            }
        });
        $A.enqueueAction(action);
    },

    /**
    * @description Set file size attributes.
    **/
    MAX_FILE_SIZE: 4500000, //Max file size 4.5 MB
    CHUNK_SIZE: 750000, //Chunk Max size 750Kb
    /**
     * @description upload function.
     **/
    upload: function (component, event) {
        component.set("v.showLoadingSpinner", true);
        var fileInput = component.find("fileId").get("v.files");
        var file = fileInput[0];
        var self = this;
        if (file.size > self.MAX_FILE_SIZE) {
            component.set("v.showLoadingSpinner", false);
            component.set(
                "v.fileName",
                "Alert : File size cannot exceed " +
                self.MAX_FILE_SIZE +
                " bytes.\n" +
                " Selected file size: " +
                file.size
            );
            return;
        }
        var objFileReader = new FileReader();
        objFileReader.onload = $A.getCallback(function () {
            var fileContents = objFileReader.result;
            var base64 = "base64,";
            var dataStart = fileContents.indexOf(base64) + base64.length;
            fileContents = fileContents.substring(dataStart);
            self.uploadProcess(component, file, fileContents);
        });
        objFileReader.readAsDataURL(file);
    },
    /**
     * @description upload files function.
     **/
    uploadProcess: function (component, file, fileContents) {
        var startPosition = 0;
        // calculate the end size or endPostion using Math.min() function which is return the min. value
        var endPosition = Math.min(
            fileContents.length,
            startPosition + this.CHUNK_SIZE
        );
        // start with the initial chunk, and set the attachId(last parameter)is null in begin
        this.uploadInChunk(
            component,
            file,
            fileContents,
            startPosition,
            endPosition,
            "",
            startPosition + this.CHUNK_SIZE > fileContents.length
        );
    },
    /**
     * @description upload chunks function.
     **/
    uploadInChunk: function (component, file, fileContents, startPosition, endPosition, attachId, isDone, event) {
        var getchunk = fileContents.substring(startPosition, endPosition);
        //var checkCmp = component.find("radioGrp");
        var signedManually = false;
        //if (checkCmp.get("v.value") == 'Yes') {
        //signedManually = true;
        //}
        var action = component.get("c.saveChunk");
        action.setParams({
            parentId: component.get("v.selectedSecurity"),
            fileName: component.get("v.documentType"),
            base64Data: encodeURIComponent(getchunk),
            contentType: file.type,
            fileId: attachId,
            done: isDone,
            documentType: component.get("v.documentType"),
            signedManually: signedManually
        });
        action.setCallback(this, function (response) {
            attachId = response.getReturnValue();
            var state = response.getState();
            if (state === "SUCCESS") {
                startPosition = endPosition;
                endPosition = Math.min(
                    fileContents.length,
                    startPosition + this.CHUNK_SIZE
                );
                // check if the start position is still less then end position
                // then call again 'uploadInChunk' method ,
                // else, display alert msg and hide the loading spinner
                if (startPosition < endPosition) {
                    this.uploadInChunk(
                        component,
                        file,
                        fileContents,
                        startPosition,
                        endPosition,
                        attachId,
                        startPosition + this.CHUNK_SIZE > fileContents.length
                    );
                } else {
                    component.set("v.fileName", "File is uploaded successfully");
                    component.set("v.showLoadingSpinner", false);
                    /*var compEvent = component.getEvent("refreshListEvent");
                    compEvent.fire();*/
                }
                // handle the response errors
            } else if (state === "INCOMPLETE") {
                alert("From server: " + response.getReturnValue());
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    getAppProdcts: function (component, event, helper, ids, selectedAccounts) {
        var action = component.get("c.getApplicationProducts");
        action.setParams({
            ids: ids
        });
        action.setCallback(this, function (response) {
            var resp = response.getReturnValue();
            var state = response.getState();
            if (state === "SUCCESS") {
                var removedAccounts = [];
                var selectedRecords = [];
                resp.forEach(function (result) {
                    selectedAccounts.forEach(function (acc) {
                        if (acc.Id == result.Id && (result.Product_Status__c != undefined || result.Product_Status__c == 'Declined' || result.Product_Status__c == 'Withdraw' || result.Product_Status__c == 'Not Taken Up')) {
                            removedAccounts.push(acc);
                            //selectedAccounts.splice(acc, 1);
                        } else if (acc.Id == result.Id && (result.Product_Status__c == undefined || result.Product_Status__c == 'Accepted' || result.Product_Status__c == 'Pending' || result.Product_Status__c == 'FulFilled')) {
                            selectedRecords.push(acc);
                        }
                    })
                });

                component.set("v.newExistingSecuritiesOffered", selectedRecords);
                component.set("v.notApprovedAccounts", removedAccounts);
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    }
})