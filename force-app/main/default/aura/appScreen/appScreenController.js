({
	myAction : function(component, event, helper) {
		
	},
    
    doInit: function(component, event, helper) {
        
    	var actions = [
            { label: 'Update Details', iconName: 'utility:edit', name: 'update_details' },
            { label: 'Delete', iconName: 'utility:delete', name: 'delete' }
        ];
        
        component.set('v.columns', [
            { label: 'First Name', fieldName: 'First_Name__c', type: 'text' },
            { label: 'Last Name', fieldName: 'Last_Name__c', type: 'text' },
            { label: 'RSA ID Number', fieldName: 'RSA_ID_Number__c', type: 'text' },
            { label: 'Date of Birth', fieldName: 'Date_of_Birth__c', type: 'date' },
            { label: 'Age', fieldName: 'Age__c', type: 'number' },
            { label: 'Relationship', fieldName: 'Relationship__c', type: 'text' },
            { label: 'Benefit Split %', fieldName: 'Benefit_Split__c', type: 'percent' },
            { label: 'Party Type(s)', fieldName: 'Party_Type__c', type: 'text' },
            { type: 'action', typeAttributes: { rowActions: actions } }
        ]);
        
        var actionsDep = [
            { label: 'Update Details', iconName: 'utility:edit', name: 'update_details' },
            { label: 'Delete', iconName: 'utility:delete', name: 'delete' }
        ];
        
        component.set('v.columnsDep', [
            { label: 'First Name', fieldName: 'First_Name__c', type: 'text' },
            { label: 'Last Name', fieldName: 'Last_Name__c', type: 'text' },
            { label: 'RSA ID Number', fieldName: 'RSA_ID_Number__c', type: 'text' },
            { label: 'Date of Birth', fieldName: 'Date_of_Birth__c', type: 'date' },
            { label: 'Age', fieldName: 'Age__c', type: 'number' },
            { label: 'Relationship', fieldName: 'Relationship__c', type: 'text' },
            { label: 'Party Type(s)', fieldName: 'Party_Type__c', type: 'text' },
            { type: 'action', typeAttributes: { rowActions: actionsDep } }
        ]);
        
        helper.fetchData(component,'Beneficiary');
        helper.fetchData(component,'Dependant');
        helper.checkFuneralBenefitAdded(component);
        helper.checkDependantValidity(component);
                
        helper.fetchPickListVal(component, 'Relationship__c', 'relationship');
        helper.fetchPickListVal(component, 'Relationship__c', 'relationshipUpdate');
        
        //check total benefit split
        var oppId = component.get("v.recordId");
        var action = component.get("c.checkTotalBenefitSplit");
        action.setParams({
            "oppId": oppId
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state === "SUCCESS") {
                var totalSplit = a.getReturnValue();
                if(totalSplit == 1){
                    component.find("newBeneficiaryButton").set("v.disabled", true);
                }
                else{
                    component.find("newBeneficiaryButton").set("v.disabled", false);
                }
            }
        });
        $A.enqueueAction(action);
        
        //check number and hide add beneficiaries button if necissary
        var oppId = component.get("v.recordId");
        var action = component.get("c.checkNumberOpportunityParty");
        action.setParams({
            "oppId": oppId
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state === "SUCCESS") {
                var number = a.getReturnValue();
                if(number >= 5){
                    component.find("newBeneficiaryButton").set("v.disabled", true);
                }
            }
        });
        $A.enqueueAction(action);
        
        helper.spouseValidity(component);
        helper.retrieveSpouseDOB(component);
        
        helper.checkOnInitValidity(component);
        
        helper.getAllEmails(component);
    },
    
    addBeneficiary: function (component, event, helper) {
        //Remove spaces 
        var firstName = component.get("v.beneficiary.First_Name__c");
        if (!(/\S/.test(firstName))) {
            firstName = firstName.replace(/\s+/g, '');
        	component.set("v.beneficiary.First_Name__c", firstName);
        }
        
    	var lastName = component.get("v.beneficiary.Last_Name__c");
    	if (!(/\S/.test(lastName))) {
            lastName = lastName.replace(/\s+/g, '');
    		component.set("v.beneficiary.Last_Name__c", lastName);
        }

 		//Check if form is valid
        var allValid = component.find('beneficiaryForm').reduce(function (validSoFar, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            inputCmp.focus();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        if(component.get("v.selectedRelationship") == ""){
           allValid = false; 
           var toastEvent = $A.get("e.force:showToast");
           toastEvent.setParams({
               "title": "Error!",
               "message": "A Relationship must be selected. Please try again",
               "type":"error"
           });
           toastEvent.fire();
        }
        if (allValid) {
            //Check if beneficiary is older than 18
            var today = new Date();
            var birthDate = new Date(component.get("v.beneficiary.Date_of_Birth__c"));
            var age = today.getFullYear() - birthDate.getFullYear();
            var m = today.getMonth() - birthDate.getMonth();
            if (m < 0 || (m === 0 && today.getDate() < birthDate.getDate())) {
                age--;
            }
    	
            //Check if the totalSplit > 100
            var totalBeneficiarySplit = component.get("v.totalBeneficiarySplit");
            var newBeneficiarySplit = component.get("v.beneficiary.Benefit_Split__c");
            var total = (Number(totalBeneficiarySplit)*100) + Number(newBeneficiarySplit);
            if(total > 100){
                // show error notification
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Total Benefit Split cannot be greater than 100%. Please try again",
                    "type":"error"
                });
                toastEvent.fire();
            }
            else if(Number(age) < 18){
                // show error notification
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "A beneficiary must be older than 18 years of age.",
                    "type":"error"
                });
                toastEvent.fire();
            }
            else{
                component.set("v.showSpinner", true);
                
                //check if duplicate
                var oppId = component.get("v.recordId");
                var action = component.get("c.checkDuplicateRecord");
                action.setParams({
                    "oppId": oppId,
                    "opParty": component.get("v.beneficiary"),
                });
                action.setCallback(this, function(a) {
                    var state = a.getState();
                    if (state === "SUCCESS") {
                        var isDuplicate = a.getReturnValue();
                        var continueWithSave = true;
                        if(isDuplicate == true){
                            var r = confirm("A record with these details have already been captured. Are you sure you want to still add the record?");
                            if (r == true) {
                                continueWithSave = true;
                            } else {
                                continueWithSave = false;
                            }
                        }
                        
                        if(continueWithSave){
                            //check number and hide add beneficiaries button if necissary
                            var action = component.get("c.checkNumberOpportunityParty");
                            action.setParams({
                                "oppId": oppId
                            });
                            action.setCallback(this, function(a) {
                                var state = a.getState();
                                if (state === "SUCCESS") {
                                    var number = a.getReturnValue();
                                    if(number >= 5){
                                        // show error notification
                                        var toastEvent = $A.get("e.force:showToast");
                                        toastEvent.setParams({
                                            "title": "Error!",
                                            "message": "No more beneficiaries can be added as the limit has been reached.",
                                            "type":"error"
                                        });
                                        toastEvent.fire();
                                    }
                                    else{
                                        var oppParty = component.get("v.beneficiary");
                                        var isAlsoDependant = component.get("v.isAlsoDependant");
                                
                                        var action = component.get("c.createOpportunityParty");
                                
                                        action.setParams({
                                            "oppParty": oppParty,
                                            "oppId": oppId
                                        });
                                        action.setCallback(this, function(a) {
                                            var state = a.getState();
                                            if (state === "SUCCESS") {
                                                var beneficiary = a.getReturnValue();
                                                component.set("v.beneficiary",beneficiary);
                                                component.set("v.selectedRelationship",null);
                                                
                                                //check number and hide add beneficiaries button if necissary
                                                var action = component.get("c.checkNumberOpportunityParty");
                                                action.setParams({
                                                    "oppId": oppId
                                                });
                                                action.setCallback(this, function(a) {
                                                    var state = a.getState();
                                                    if (state === "SUCCESS") {
                                                        var number = a.getReturnValue();
                                                        if(number >= 5){
                                                            component.find("newBeneficiaryButton").set("v.disabled", true);
                                                        }
                                                        
                                                        //check total benefit split
                                                        var action = component.get("c.checkTotalBenefitSplit");
                                                        action.setParams({
                                                            "oppId": oppId
                                                        });
                                                        action.setCallback(this, function(a) {
                                                            var state = a.getState();
                                                            if (state === "SUCCESS") {
                                                                var totalSplit = a.getReturnValue();
                                                                if(totalSplit == 1){
                                                                    component.find("newBeneficiaryButton").set("v.disabled", true);
                                                                }
                                                            }
                                                        });
                                                        $A.enqueueAction(action);
                                                    }
                                                });
                                                $A.enqueueAction(action);
                                                
                                                // show success notification
                                                var toastEvent = $A.get("e.force:showToast");
                                                toastEvent.setParams({
                                                    "title": "Success!",
                                                    "message": "Beneficiary Successfully Added",
                                                    "type":"success"
                                                });
                                                toastEvent.fire();
                                            }
                                            else{
                                                // show error notification
                                                var toastEvent = $A.get("e.force:showToast");
                                                toastEvent.setParams({
                                                    "title": "Error!",
                                                    "message": "Error adding Beneficiary. Please try again",
                                                    "type":"error"
                                                });
                                                toastEvent.fire();
                                            }
                                        });
                                        $A.enqueueAction(action)
                                        $A.get('e.force:refreshView').fire();
                                        
                                        component.set("v.showNewPanel", false);
                           
                                        helper.fetchData(component);
                                        helper.fetchPickListVal(component, 'Relationship__c', 'relationship');
                                        
                                        var a = component.get('c.doInit');
                            			$A.enqueueAction(a);
                                    }
                                }
                            });
                            $A.enqueueAction(action);
                        }
                    }
                    component.set("v.showSpinner", false);
                });
                $A.enqueueAction(action);
            }
        }
    },
    
    addDependant: function (component, event, helper) {
        //Remove spaces 
        var firstName = component.get("v.dependant.First_Name__c");
        if (!(/\S/.test(firstName))) {
            firstName = firstName.replace(/\s+/g, '');
        	component.set("v.dependant.First_Name__c", firstName);
        }
        
    	var lastName = component.get("v.dependant.Last_Name__c");
    	if (!(/\S/.test(lastName))) {
            lastName = lastName.replace(/\s+/g, '');
    		component.set("v.dependant.Last_Name__c", lastName);
        }
        
        var allValid = component.find('dependantForm').reduce(function (validSoFar, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            inputCmp.focus();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        //Check if date is in past
        var now = new Date();
        var selectedDate = new Date(component.get("v.dependant.Date_of_Birth__c"));
        if(selectedDate > now){
            allValid = false; 
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Date of Birth cannot be in the future.",
                "type":"error"
            });
            toastEvent.fire();
        }
        
        //Get age
        var today = new Date();
        var birthDate = new Date(component.get("v.dependant.Date_of_Birth__c"));
        var age = today.getFullYear() - birthDate.getFullYear();
        var m = today.getMonth() - birthDate.getMonth();
        if (m < 0 || (m === 0 && today.getDate() < birthDate.getDate())) {
            age--;
        }
        
        if(component.get("v.dependant.Relationship__c") == 'Spouse'){
            if(Number(age) < 18 || Number(age) > 70){
                allValid = false;
                // show error notification
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "A spouse must be older than 18 and younger than 70 years of age.",
                    "type":"error"
                });
                toastEvent.fire();
                component.set("v.spouse.Benefit_Split__c", null);
            }
        }
        else{
            if(Number(age) >= 21){
                allValid = false; 
                // show error notification
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "A dependent cannot be 21 and older than 21 years of age.",
                    "type":"error"
                });
                toastEvent.fire();
            }
        }
        
        if (allValid) {
            var isAlsoBeneficiary = component.get("v.isAlsoBeneficiary");
            var isValid = true;
            
            component.set("v.showSpinner", true);
            
            var oppParty = component.get("v.dependant");
            var oppId = component.get("v.recordId");
            
            var action = component.get("c.createOpportunityPartyDep");
            
            action.setParams({
                "oppParty": oppParty,
                "oppId": oppId
            });
            action.setCallback(this, function(a) {
                var state = a.getState();
                if (state === "SUCCESS") {
                    var name = a.getReturnValue();
                    component.set("v.dependant",name);
                    
                    // show success notification
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": "Dependant Successfully Added",
                        "type":"success"
                    });
                    toastEvent.fire();
                }
                else{
                    // show error notification
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": "Error adding Dependant. Please try again",
                        "type":"error"
                    });
                    toastEvent.fire();
                }
                component.set("v.showSpinner", false);
            });
            $A.enqueueAction(action);
            
            component.set("v.showNewPanelDep", false);
            
            var a = component.get('c.doInit');
            $A.enqueueAction(a);
        }
    },
    
    handleRowAction: function (cmp, event, helper) {
                
        var action = event.getParam('action');
        var row = event.getParam('row');
        cmp.set("v.updateRecordId", row.Id);

        switch (action.name) {
            case 'update_details':
                
                cmp.set("v.showSpinner", true);
                
                var oppPartyId = cmp.get("v.updateRecordId");
                var action = cmp.get("c.getSingleParty");
                action.setParams({
                    "oppPartyId": oppPartyId
                });
                action.setCallback(this, function(response) {
                    var state = response.getState();
                    if (state === "SUCCESS") {
                        cmp.set("v.beneficiary", response.getReturnValue());
                        cmp.set("v.showUpdatePanel", true);
                        cmp.set("v.currentSplit", cmp.get("v.beneficiary.Benefit_Split__c"));
                        cmp.set("v.selectedRelationshipUpdate", cmp.get("v.beneficiary.Relationship__c"));
                        
                        if(cmp.get("v.beneficiary.Party_Type__c").includes("Dependant")){
                            var chkBox = cmp.find("updateCheckbox");
							chkBox.set("v.value", true);
                            cmp.set("v.isAlsoDependantUpdate", true);
                        }
                        else{
                            cmp.set("v.isAlsoDependantUpdate", false);
                        }
                    }
                    else {
                        console.log("Failed with state: " + state);
                    }
                    cmp.set("v.showSpinner", false);
                });
                $A.enqueueAction(action);
                
                break;
            case 'delete':
                helper.removeBeneficiary(cmp, row);
                
                break;
        }
    },
    
    handleRowActionDep: function (cmp, event, helper) {

        var action = event.getParam('action');
        var row = event.getParam('row');
        cmp.set("v.updateRecordId", row.Id);

        switch (action.name) {
            case 'update_details':
                cmp.set("v.showSpinner", true);

                var oppPartyId = cmp.get("v.updateRecordId");
                var action = cmp.get("c.getSingleParty");
                action.setParams({
                    "oppPartyId": oppPartyId
                });
                action.setCallback(this, function(response) {
                    var state = response.getState();
                    if (state === "SUCCESS") {
                        cmp.set("v.dependant", response.getReturnValue());
                        cmp.set("v.showUpdatePanelDep", true);
                        
                        if(cmp.get("v.dependant.Relationship__c") == 'Spouse'){
                            cmp.set("v.disableSpouseDOBUpdate", true);
                        }
                        else{
                            cmp.set("v.disableSpouseDOBUpdate", false);
                        }
                        
                        cmp.set("v.currentSplit", cmp.get("v.dependant.Benefit_Split__c"));

                        if(cmp.get("v.dependant.Party_Type__c").includes("Beneficiary")){
                            var chkBox = cmp.find("updateCheckbox");
							chkBox.set("v.value", true);
                            cmp.set("v.isAlsoBeneficiaryUpdate", true);
                        }
                        else{
                            cmp.set("v.isAlsoBeneficiaryUpdate", false);
                        }
                    }
                    else {
                        console.log("Failed with state: " + state);
                    }
                    cmp.set("v.showSpinner", false);
                });
                $A.enqueueAction(action);
                
                break;
            case 'delete':
                helper.removeDependant(cmp, row)
                
                break;
        }
    },
            
    onPicklistRelationshipChange: function(component, event, helper) {
        component.set("v.beneficiary.Relationship__c", event.getSource().get("v.value"));
    },
    
    onPicklistRelationshipChangeUpdate: function(component, event, helper) {
        component.set("v.beneficiary.Relationship__c", event.getSource().get("v.value"));
    },
    
    onPicklistRelationshipDependantChange: function(component, event, helper) {
        if(event.getSource().get("v.value") == 'Spouse'){
            component.set("v.dependant.Date_of_Birth__c", component.get("v.spouseDateBirth"));
            component.set("v.disableSpouseDOB", true);
        }
        else{
            //component.set("v.dependant.Date_of_Birth__c", "");
            component.set("v.disableSpouseDOB", false);
        }
    },
    
    onPicklistRelationshipDependantChangeUpdate: function(component, event, helper) {
        if(event.getSource().get("v.value") == 'Spouse'){
            component.set("v.dependant.Date_of_Birth__c", component.get("v.spouseDateBirth"));
            component.set("v.disableSpouseDOBUpdate", true);
        }
        else{
            //component.set("v.dependant.Date_of_Birth__c", "");
            component.set("v.disableSpouseDOBUpdate", false);
        }
    },
    
    newBeneficiary: function(component, event) {
        component.set("v.showNewPanel", true);
    },
    
    cancelBeneficiary: function(component, event) {
        component.set("v.showNewPanel", false);
    },
    
    newDependant: function(component, event) {
        component.set("v.showNewPanelDep", true);
    },
    
    cancelDependant: function(component, event) {
        component.set("v.showNewPanelDep", false);
    },
    
    openConfirmation: function(component, event, helper) {
      // for Display Model,set the "isOpen" attribute to "true"
      component.set("v.showUpdatePanel", true);
   	},
 
    closeConfirmation: function(component, event, helper) {
        // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
        component.set("v.showUpdatePanel", false);
    },
    
    confrimAndClose: function(component, event, helper) {
        // Display alert message on the click on the "Like and Close" button from Model Footer 
        // and set set the "isOpen" attribute to "False for close the model Box.
        var allValid = component.find('updateForm').reduce(function (validSoFar, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            inputCmp.focus();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        if (allValid) {
            //Check if beneficiary is older than 18
            var today = new Date();
            var birthDate = new Date(component.get("v.beneficiary.Date_of_Birth__c"));
            var age = today.getFullYear() - birthDate.getFullYear();
            var m = today.getMonth() - birthDate.getMonth();
            if (m < 0 || (m === 0 && today.getDate() < birthDate.getDate())) {
                age--;
            }
            
            //Check if the totalSplit > 100
            var currentValue = component.get("v.currentSplit");
            var totalBeneficiarySplit = component.get("v.totalBeneficiarySplit");
            var newBeneficiarySplit = component.get("v.beneficiary.Benefit_Split__c");
            
            var total = ((Number(totalBeneficiarySplit)*100)-(Number(currentValue))) + Number(newBeneficiarySplit);
            if(total > 100){
                // show error notification
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Total Benefit Split cannot be greater than 100%. Please try again",
                    "type":"error"
                });
                toastEvent.fire();
            }
            else if(Number(age) < 18){
                // show error notification
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "A beneficiary must be older than 18 years of age.",
                    "type":"error"
                });
                toastEvent.fire();
            }
            else{   
                component.set("v.showSpinner", true);
                
                //check if duplicate
                var oppId = component.get("v.recordId");
                var action = component.get("c.checkDuplicateRecord");
                action.setParams({
                    "oppId": oppId,
                    "opParty": component.get("v.beneficiary"),
                });
                action.setCallback(this, function(a) {
                    var state = a.getState();
                    if (state === "SUCCESS") {
                        var isDuplicate = a.getReturnValue();
                        var continueWithSave = true;
                        if(isDuplicate == true){
                            var r = confirm("A record with these details have already been captured. Are you sure you want to still add the record?");
                            if (r == true) {
                                continueWithSave = true;
                            } else {
                                continueWithSave = false;
                            }
                        }
                        
                        if(continueWithSave){
            
                            var oppParty = component.get("v.beneficiary");
                            var oppPartyId = component.get("v.updateRecordId"); 
                            var isAlsoDependantUpdate = component.get("v.isAlsoDependantUpdate");
                    
                            var action = component.get("c.updateOpportunityParty");
                            action.setParams({
                                "oppParty": oppParty,
                                "oppPartyId": oppPartyId
                            });
                            action.setCallback(this, function(a) {
                                var state = a.getState();
                                if (state === "SUCCESS") {
                                    var name = a.getReturnValue();
                                    component.set("v.beneficiary",name);
                                    
                                    //check total benefit split
                                    var oppId = component.get("v.recordId");
                                    var action = component.get("c.checkTotalBenefitSplit");
                                    action.setParams({
                                        "oppId": oppId
                                    });
                                    action.setCallback(this, function(a) {
                                        var state = a.getState();
                                        if (state === "SUCCESS") {
                                            var totalSplit = a.getReturnValue();
                                            if(totalSplit == 1){
                                                component.find("newBeneficiaryButton").set("v.disabled", true);
                                            }
                                        }
                                    });
                                    $A.enqueueAction(action);
                                    
                                    // show success notification
                                    var toastEvent = $A.get("e.force:showToast");
                                    toastEvent.setParams({
                                        "title": "Success!",
                                        "message": "Beneficiary Successfully Updated",
                                        "type":"success"
                                    });
                                    toastEvent.fire();
                                }
                                else{
                                    // show error notification
                                    var toastEvent = $A.get("e.force:showToast");
                                    toastEvent.setParams({
                                        "title": "Error!",
                                        "message": "Error updating Beneficiary. Please try again",
                                        "type":"error"
                                    });
                                    toastEvent.fire();
                                }
                            });
                            $A.enqueueAction(action);
                            
                            helper.fetchData(component);
                            helper.fetchPickListVal(component, 'Relationship__c', 'relationship');
                            
                            component.set("v.showUpdatePanel", false);
                            component.set("v.showNewPanel", false);
                            
                            var a = component.get('c.doInit');
                            $A.enqueueAction(a);
                        }
                    }
                    component.set("v.showSpinner", false);
                });
                $A.enqueueAction(action);
            }
        }
    },
    
    openConfirmationDep: function(component, event, helper) {
      // for Display Model,set the "isOpen" attribute to "true"
      component.set("v.showUpdatePanelDep", true);
   	},
 
    closeConfirmationDep: function(component, event, helper) {
        // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
        component.set("v.showUpdatePanelDep", false);
        component.set("v.dependant.Relationship__c",null);
    },
    
    confrimAndCloseDep: function(component, event, helper) {
        // Display alert message on the click on the "Like and Close" button from Model Footer 
        // and set set the "isOpen" attribute to "False for close the model Box.
        var allValid = component.find('updateForm').reduce(function (validSoFar, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            inputCmp.focus();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        
        //Get age
        var today = new Date();
        var birthDate = new Date(component.get("v.dependant.Date_of_Birth__c"));
        var age = today.getFullYear() - birthDate.getFullYear();
        var m = today.getMonth() - birthDate.getMonth();
        if (m < 0 || (m === 0 && today.getDate() < birthDate.getDate())) {
            age--;
        }
        if(component.get("v.dependant.Relationship__c") == 'Spouse'){
            if(Number(age) < 18 || Number(age) > 65){
                allValid = false;
                // show error notification
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "A spouse must be older than 18 and younger than 65 years of age.",
                    "type":"error"
                });
                toastEvent.fire();
                component.set("v.spouse.Benefit_Split__c", null);
            }
        }
        else{
            if(Number(age) >= 21){
                allValid = false; 
                // show error notification
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "A dependent cannot be 21 and older than 21 years of age.",
                    "type":"error"
                });
                toastEvent.fire();
            }
        }
        
        if (allValid) {
            
            var isAlsoBeneficiaryUpdate = component.get("v.isAlsoBeneficiaryUpdate");
            var isValid = true;
            
            component.set("v.showSpinner", true);
            
            var oppParty = component.get("v.dependant");
            var oppId = component.get("v.recordId");
            var oppPartyId = component.get("v.updateRecordId"); 
            
            var action = component.get("c.updateOpportunityPartyDep");
            action.setParams({
                "oppParty": oppParty,
                "oppId": oppId,
                "oppPartyId": oppPartyId
            });
            action.setCallback(this, function(a) {
                var state = a.getState();
                if (state === "SUCCESS") {
                    var name = a.getReturnValue();
                    component.set("v.dependant",name);
                    
                    // show success notification
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": "Dependant Successfully Updated",
                        "type":"success"
                    });
                    toastEvent.fire();   
                }
                else{
                    // show error notification
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": "Error updating Dependant. Please try again",
                        "type":"error"
                    });
                    toastEvent.fire();
                }
                component.set("v.showSpinner", false);
            });
            $A.enqueueAction(action);
                        
            component.set("v.showUpdatePanelDep", false);
            component.set("v.showNewPanelDep", false);
            
            var a = component.get('c.doInit');
            $A.enqueueAction(a);
        }
    },
    
    validateApp: function(component, event, helper) {
        helper.checkEmailValidity(component);
    },
    
    onPicklistEmailChange: function(component, event, helper) {
    },
    
    onCompletedCheck: function(component, event) {
        var checkCmp = component.find("completedCheckbox");
        component.set("v.isCompleted", checkCmp.get("v.value"));
        if(checkCmp.get("v.value") == true){
            component.find("emailSelect").set("v.disabled", true);
            component.set("v.showAlternativeEmail", true);
        }
        else{
            component.find("emailSelect").set("v.disabled", false);
            component.set("v.showAlternativeEmail", false);
        }
    },
})