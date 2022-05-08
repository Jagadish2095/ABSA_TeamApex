({
	fetchData: function (component, partyType) {
        component.set("v.showSpinner", true);

        var oppId = component.get("v.recordId");
        var action = component.get("c.getPartyData");
        action.setParams({
            "oppId": oppId,
            "partyType": partyType
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                if(partyType == 'Dependant'){
                    component.set("v.dataDep", data);
                    var depSize = 0;
                    for (var i = 0; i < data.length; i++) {
                        if(data[i].Relationship__c == 'Child'){
                            depSize++;
                        }   
                    }
                    
                    if(depSize >= 5){
                        component.set("v.disableChild", true);
                    }
                    else{
                        component.set("v.disableChild", false);
                    }
                    
                }
                else{
                    component.set("v.data", data);
                    component.set("v.allBeneficiaries", data);
                    
                    var beneficiaries = component.get("v.allBeneficiaries");
                    var totalSplit = 0;
                    for (var i = 0; i < beneficiaries.length; i++) {
                        if(beneficiaries[i].Benefit_Split__c != null){
                            totalSplit += beneficiaries[i].Benefit_Split__c;
                        }                    
                    }
                    component.set("v.totalBeneficiarySplit", totalSplit.toFixed(2));
                    component.set("v.totalBeneficiarySplitPercentage", Number(totalSplit*100).toFixed(0));
                }                
            }
            else {
                console.log("Failed with state: " + state);
            }
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },
    
    checkFuneralBenefitAdded: function (component) {
        var oppId = component.get("v.recordId");
        var action = component.get("c.checkIfFuneralBenefitTaken");
        action.setParams({
            "oppId": oppId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if(response.getReturnValue() == true){
                    component.set("v.disableChild", true);
                }
                //else{
                    //component.set("v.disableChild", false);
                //}
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);
    },
    
    checkDependantValidity: function (component) {
        var oppId = component.get("v.recordId");
        var action = component.get("c.dependantValidity");
        action.setParams({
            "oppId": oppId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if(component.find("newDependantButton") != null){
                    if(response.getReturnValue() == true){
                        component.find("newDependantButton").set("v.disabled", false);
                    }
                    else{
                        component.find("newDependantButton").set("v.disabled", true);
                    }
                }
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);
    },
    
    spouseValidity: function (component) {
        var oppId = component.get("v.recordId");
        var action = component.get("c.checkSpouseValidity");
        action.setParams({
            "oppId": oppId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if(response.getReturnValue() == true){
                    component.set("v.disableSpouse", true);
                }
                else{
                    component.set("v.disableSpouse", false);
                }
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);
    },
    
    retrieveSpouseDOB: function (component) {
        var oppId = component.get("v.recordId");
        var action = component.get("c.getSpouseDOB");
        action.setParams({
            "oppId": oppId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.spouseDateBirth", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    
    ifFuneralBenefitAdded: function (component) {
        var oppId = component.get("v.recordId");
        var action = component.get("c.checkIfFuneralBenefitTaken");
        action.setParams({
            "oppId": oppId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if(response.getReturnValue() == false){
                    component.set("v.disableChild", true);
                }
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);
    },
    
    removeBeneficiary: function (cmp, row) {
        cmp.set("v.showSpinner", true);

        var oppPartyId = cmp.get("v.updateRecordId");
        var action = cmp.get("c.removeOpportunityParty");

        action.setParams({
            "oppPartyId": oppPartyId
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state === "SUCCESS") {
                //check number and hide add beneficiaries button if necissary
                var oppId = cmp.get("v.recordId");
                var action = cmp.get("c.checkNumberOpportunityParty");
                action.setParams({
                    "oppId": oppId
                });
                action.setCallback(this, function(a) {
                    var state = a.getState();
                    if (state === "SUCCESS") {
                        var number = a.getReturnValue();
                        if(number < 5){
                            cmp.find("newBeneficiaryButton").set("v.disabled", false);
                        }
                    }
                });
                $A.enqueueAction(action);
                
                // show success notification
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "Beneficiary Successfully Removed",
                    "type":"success"
                });
                toastEvent.fire();
                
                //Remove from view
                var rows = cmp.get('v.data');
                var rowIndex = rows.indexOf(row);
        
                rows.splice(rowIndex, 1);
                cmp.set('v.data', rows);
            }
            else{
                // show error notification
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Error removing Beneficiary. Please try again",
                    "type":"error"
                });
                toastEvent.fire();
            }
            cmp.set("v.showSpinner", false);
            var a = cmp.get('c.doInit');
        	$A.enqueueAction(a);
        });
        
        $A.enqueueAction(action)
        $A.get('e.force:refreshView').fire();
    },
    
    removeDependant: function (cmp, row) {
        cmp.set("v.showSpinner", true);

        var oppPartyId = cmp.get("v.updateRecordId");
        var action = cmp.get("c.removeOpportunityPartyDep");

        action.setParams({
            "oppPartyId": oppPartyId
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state === "SUCCESS") {
                // show success notification
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "Dependant Successfully Removed",
                    "type":"success"
                });
                toastEvent.fire();
                
                //Remove from view
                var rows = cmp.get('v.dataDep');
                var rowIndex = rows.indexOf(row);
        
                rows.splice(rowIndex, 1);
                cmp.set('v.dataDep', rows);
            }
            else{
                // show error notification
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Error removing Dependant. Please try again",
                    "type":"error"
                });
                toastEvent.fire();
            }
            cmp.set("v.showSpinner", false);
            
            var a = cmp.get('c.doInit');
        	$A.enqueueAction(a);
        });
        $A.enqueueAction(action);
    },

    fetchPickListVal: function(component, fieldName, elementId) {
        var action = component.get("c.getselectOptions");
        action.setParams({
            "objObject": component.get("v.beneficiary"),
            "fld": fieldName
        });
        var opts = [];
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var allValues = response.getReturnValue();
 
                if(elementId == 'relationship'){
                    if (allValues != undefined && allValues.length > 0) {
                        opts.push({
                            class: "optionClass",
                            label: "--- None ---",
                            value: ""
                        });
                	}
                }         
                for (var i = 0; i < allValues.length; i++) {
                    opts.push({
                        class: "optionClass",
                        label: allValues[i],
                        value: allValues[i]
                    });
                }
                if(elementId == 'relationship'){
                    component.set("v.relationshipOptions", opts); 
                }
                else if(elementId == 'relationshipUpdate'){
                    component.set("v.relationshipOptionsUpdate", opts); 
                }
                //component.find(elementId).set("v.relationshipOptions", opts);
            }
        });
        $A.enqueueAction(action);
    },
    
    checkOnInitValidity: function (component) {       
        var oppId = component.get("v.recordId");
        var action = component.get("c.checkInitValidity");
        action.setParams({
            "oppId": oppId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var validity = response.getReturnValue();
                if(validity == 'Valid'){
        			component.set("v.showFinishedScreen", true);
                }
                else{
        			component.set("v.showFinishedScreen", false);
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    checkEmailValidity: function(component) {
        var checkCmp = component.find("completedCheckbox");
        //Alternative Email Selected
        if(checkCmp.get("v.value") == true){
            var motivationArr = [];
            motivationArr.push(component.find('altEmail'));
            var allValid = motivationArr.reduce(function (validSoFar, inputCmp) {
                inputCmp.showHelpMessageIfInvalid();
                inputCmp.focus();
                return validSoFar && inputCmp.get('v.validity').valid;
            }, true);
            var allEmails = component.get("v.emailOptions");
            var alternativeEmail = component.get("v.alternativeEmail");
            var isDuplicate = false;
            for (var i = 0; i < allEmails.length; i++) {
                if(alternativeEmail == allEmails[i].value){
                    isDuplicate = true;
                }
            } 
            if(isDuplicate){
                allValid = false;
                // show error notification
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "This email has already been added and cannot be added as an alternative again!",
                    "type":"error"
                });
                toastEvent.fire();
            }
            if (allValid) {
                this.checkIfValid(component, 'Alternative');
            }
        }
        //Else use default
        else{
            var motivationArr = [];
            motivationArr.push(component.find('emailSelect'));
            var allValid = motivationArr.reduce(function (validSoFar, inputCmp) {
                inputCmp.showHelpMessageIfInvalid();
                inputCmp.focus();
                return validSoFar && inputCmp.get('v.validity').valid;
            }, true);
            if (allValid) {
                this.checkIfValid(component, 'Default');
            }
        }    	
   	},
    
    checkIfValid: function (component, emailType) {
        component.set("v.showSpinner", true);
        
        var oppId = component.get("v.recordId");
        
        var action = component.get("c.checkDependantValidity");
        action.setParams({
            "oppId": oppId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var validity = response.getReturnValue();
                var continueWithSave = true;
                
                if(validity == 'Invalid Dependant'){
                    var confirmation = confirm("A Family Funeral Benefit product was selected but no child dependants have been added, are you sure you want to continue?");
                    if (confirmation == true) {
                        continueWithSave = true;
                    } else {
                        continueWithSave = false;
                    }
                }
                
                if(continueWithSave){
                    component.set("v.showSpinner", true);

                    var action = component.get("c.checkValidity");
                    action.setParams({
                        "oppId": oppId
                    });
                    action.setCallback(this, function(response) {
                        var state = response.getState();
                        if (state === "SUCCESS") {
                            var validity = response.getReturnValue();
                            
                            if(validity == 'Invalid Beneficiaries'){
                                // show error notification
                                var toastEvent = $A.get("e.force:showToast");
                                toastEvent.setParams({
                                    "title": "Error!",
                                    "message": "Beneficiaries must all add up to 100%.",
                                    "type":"error"
                                });
                                toastEvent.fire();
                            }
                            else if(validity == 'Invalid Spouse'){
                                // show error notification
                                var toastEvent = $A.get("e.force:showToast");
                                toastEvent.setParams({
                                    "title": "Error!",
                                    "message": "A spouse needs to be added if a quote was done on spouse. Please add a spouse or amend the quote.",
                                    "type":"error"
                                });
                                toastEvent.fire();
                            }
                                else{
                                    // show success notification
                                    var toastEvent = $A.get("e.force:showToast");
                                    toastEvent.setParams({
                                        "title": "Success!",
                                        "message": "Application Parties Successfully Validated.",
                                        "type":"success"
                                    });
                                    toastEvent.fire();
                                    
                                    //Update Valid Email
                                    if(emailType == 'Alternative'){
                                        this.saveEmailsAlterative(component);
                                    }
                                    else{
                                        this.saveEmailsDefault(component);
                                    }
                                    
                                    component.set("v.showFinishedScreen", true);                 
                                }
                        }
                        component.set("v.showSpinner", false);               
                    });
                    $A.enqueueAction(action);
                }
            }
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },
    
    saveEmailsDefault: function (component) {
        component.set("v.showSpinner", true);    
        
        var oppId = component.get("v.recordId");
        var emailAddress = component.get("v.selectedEmail");
        var action = component.get("c.saveEmail");
        action.setParams({
            "oppId": oppId,
            "emailAddress": emailAddress
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state === "SUCCESS") {
            }
            component.set("v.showSpinner", false);   
        });
        $A.enqueueAction(action);
    },
    
    saveEmailsAlterative: function (component) {
        component.set("v.showSpinner", true);    
        
        var oppId = component.get("v.recordId");
        var altEmailAddress = component.get("v.alternativeEmail");

        var action = component.get("c.saveAlternativeEmail");
        action.setParams({
            "oppId": oppId,
            "altEmailAddress": altEmailAddress
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state === "SUCCESS") {
            }
            component.set("v.showSpinner", false);    
        });
        $A.enqueueAction(action);
    },
    
    getAllEmails: function (component) {
		component.set("v.showSpinner", true);
        
        var oppId = component.get("v.recordId");
        var action = component.get("c.getEmails");
        action.setParams({
            "oppId": oppId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                if(data != null && data.length > 0){
                    var opts = [];
                    for (var i = 0; i < data.length; i++) {
                        opts.push({
                            class: "optionClass",
                            label: data[i],
                            value: data[i]
                        });
                    }
                    component.set("v.emailOptions", opts);
                    component.set("v.selectedEmail", data[0]);
                }
            }
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },
})