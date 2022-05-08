({
	myAction : function(component, event, helper) {
		
	},
    
    doInit: function(component, event, helper) {
        helper.showSpinner(component);

        if(component.get('v.recordId') == undefined){       
            var oppId = component.get('v.selectedOppIdFromFlow');
            component.set("v.recordId", oppId);
        }
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
            { label: 'Party Type(s)', fieldName: 'Party_Type__c', type: 'text' },
            { type: 'action', typeAttributes: { rowActions: actions } }
        ]);
        
        //Added by Kalyani for Direct Delivery Sales Opportunity 
        helper.fetchrecordtype(component);
        
        helper.fetchData(component);
        helper.checkFuneralBenefitAdded(component);  
        helper.hideSpinner(component);
    },
    
    onUpdate: function(cmp, evt) {
        helper.fetchData(cmp);
        helper.checkFuneralBenefitAdded(cmp);
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
                
        //Added by Kalyani on Age Validation for Direct Delivery Sales Opportunity
         if(component.get('v.recordtype') == 'Direct Delivery Sales Opportunity'){
             if(component.get("v.dependantTypeFromFlow") == 'Extended Family Member' && Number(age) > 75) {
                 allValid = false; 
                 var toastEvent = $A.get("e.force:showToast");
                 toastEvent.setParams({
                     "title": "Error!",
                     "message": "Dependant Age should be less than 75.",
                     "type":"error"
                 });
                 toastEvent.fire();
             }
            else if(component.get("v.dependantTypeFromFlow") == 'Child' && Number(age) > 70) {
                allValid = false; 
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Dependant Age should be less than 70.",
                    "type":"error"
                });
                toastEvent.fire();
            }
             var coverValue = component.find("flexiFuneralCover").get('v.value');
             if(coverValue == null || coverValue == ''){
                 allValid = false;
                 var toastEvent = $A.get('e.force:showToast');
                 toastEvent.setParams({
                     title: 'Error!',
                     message: 'Please enter the Cover value.',
                     type: 'error'
                 });
                 toastEvent.fire();
             } 
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
            if(Number(age) > 21 && component.get('v.recordtype') != 'Direct Delivery Sales Opportunity'){
                allValid = false; 
                // show error notification
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "A dependant cannot be older than 21 years of age.",
                    "type":"error"
                });
                toastEvent.fire();
            }
        }
        
        if (allValid) {
            var isAlsoBeneficiary = component.get("v.isAlsoBeneficiary");
            var isValid = true;
            
            if(isAlsoBeneficiary == true){
                //Check if the totalSplit > 100
                helper.showSpinner(component);

                var oppId = component.get("v.recordId");
                var action = component.get("c.getTotalBenefitSplit");
                action.setParams({
                    "oppId": oppId
                });
                action.setCallback(this, function(response) {
                    var state = response.getState();
                    if (state === "SUCCESS") {
                        component.set("v.totalBeneficiarySplit", response.getReturnValue());   
                        
                        var totalBeneficiarySplit = component.get("v.totalBeneficiarySplit");
                        var newBeneficiarySplit = component.get("v.dependant.Benefit_Split__c");
                        var total = (Number(totalBeneficiarySplit)) + Number(newBeneficiarySplit);
                        if(total > 100){
                            isValid = false;
                            // show error notification
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                "title": "Error!",
                                "message": "Total Benefit Split cannot be greater than 100%. Please try again",
                                "type":"error"
                            });
                            toastEvent.fire();
                            component.set("v.dependant.Benefit_Split__c", null);
                        }
                        else if(Number(age) < 18){
                            isValid = false;
                            // show error notification
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                "title": "Error!",
                                "message": "A beneficiary must be older than 18 years of age.",
                                "type":"error"
                            });
                            toastEvent.fire();
                            component.set("v.dependant.Benefit_Split__c", null);
                        }
                        
                        if(isValid){
                
                            helper.showSpinner(component);
                    
                            var oppParty = component.get("v.dependant");
                            var oppId = component.get("v.recordId");
                    
                            var action = component.get("c.createOpportunityParty");
                    
                            action.setParams({
                                "oppParty": oppParty,
                                "oppId": oppId,
                                "isAlsoBeneficiary": isAlsoBeneficiary
                            });
                            action.setCallback(this, function(a) {
                                var state = a.getState();
                                if (state === "SUCCESS") {
                                    var name = a.getReturnValue();
                                    if(name == null){
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
                                        component.set("v.dependant",name);
                                        component.set("v.isAlsoBeneficiary",false);
                                        
                                        // show success notification
                                        var toastEvent = $A.get("e.force:showToast");
                                        toastEvent.setParams({
                                            "title": "Success!",
                                            "message": "Dependant Successfully Added",
                                            "type":"success"
                                        });
                                        toastEvent.fire();
                                    }
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
                                helper.hideSpinner(component);
                            });
                            $A.enqueueAction(action)
                            $A.get('e.force:refreshView').fire();
                            
                            component.set("v.showNewPanel", false);
                
                            //var a = component.get('c.doInit');
                            //$A.enqueueAction(a);
                            var a = component.get('c.onUpdate');
                			$A.enqueueAction(a);
                        }
                    }
                    else {
                        isValid = false;
                        console.log("Failed with state: " + state);
                		var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                "title": "Error!",
                                "message": "An error has occured. Please try again",
                                "type":"error"
                            });
                        toastEvent.fire();
                    }
                    helper.hideSpinner(component);
                });
                $A.enqueueAction(action);
            }
            //Else Not Beneficiary
            else{
                helper.showSpinner(component);
                if(component.get('v.recordtype') == 'Direct Delivery Sales Opportunity') {
                    helper.mapDependant(component);
                    //helper.createNewQuote(component);
                    helper.hideSpinner(component);
                    component.set("v.showCommissionScreen", true);
                    component.set("v.isQuoteDone", false);
                }
                else{
                	var oppParty = component.get("v.dependant");
                	var oppId = component.get("v.recordId");
                
                	var action = component.get("c.createOpportunityParty");
        
                	action.setParams({
                    	"oppParty": oppParty,
                    	"oppId": oppId,
                    	"isAlsoBeneficiary": isAlsoBeneficiary
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
                    	helper.hideSpinner(component);
                	});
                    $A.enqueueAction(action);
                	$A.get('e.force:refreshView').fire();
                
                	component.set("v.showNewPanel", false);   
                	//var a = component.get('c.doInit');
                	//$A.enqueueAction(a);
                 	var a = component.get('c.onUpdate');
                	$A.enqueueAction(a);
                }
            }
        }
    },
    
    	//Added by Kalyani for Direct Delivery Sales Opportunity 
    	onPicklistCoverChange: function(component, event, helper) {
        	var sumInsured = event.getSource().get('v.value');
        	var sumSource = event.getSource().getLocalId();
            if (sumInsured == '') {
                if(sumSource == 'flexiFuneralCover'){
                component.set('v.CoverPremium', 0);
				component.set('v.CoverPremiumLbl', 'Premium : R0.00');
            	}
            }
            else if(sumInsured == 15000)
                helper.calculatePremium(component, component.get('v.MainMemberPremiumRate'), 0 , sumInsured, sumSource);
            else
                helper.calculatePremium(component, component.get('v.MainMemberPremiumRate'), 18.61646 , sumInsured, sumSource);
    	},
    
    	//Cancel button 
    	cancelAndCloseTab : function(component, event, helper) {
        	//Close focus tab and navigate home
        	component.set('v.showNewPanel', false);
			component.set('v.showCommissionScreen', true);
            component.set('v.isEditQuote', false);
    	},
    
    	handleNext : function(component, event, helper) {
      		var response = event.getSource().getLocalId();
      		component.set("v.value", response);
            var navigate = component.get("v.navigateFlow");
            if(response == 'Quote'){
                helper.createNewQuote(component);
            }
            else
                navigate(response);
  	 	},
    
    	calculateDOB : function(component, event, helper) {
             //Get age
        	var today = new Date();
        	var birthDate = new Date(component.get("v.dependant.Date_of_Birth__c"));
        	var age = today.getFullYear() - birthDate.getFullYear();
        	var m = today.getMonth() - birthDate.getMonth();
        	if (m < 0 || (m === 0 && today.getDate() < birthDate.getDate())) {
            	age--;
        	}
            component.set("v.dependentAge",Number(age));
			if(component.get('v.recordtype') == 'Direct Delivery Sales Opportunity')
            	helper.getPremiumMatrices(component, Number(age), 'Flexi Funeral Rate');
        	
    	},
        
    	editRow :  function(component, event, helper) {

             var index = event.getParam("indexVar");
             component.set("v.indexVar",index);
             component.set("v.showUpdatePanel",true);
             component.set("v.dependant",event.getParam("raiderDetails"));
             if(event.getParam("raiderDetails").Age__c !== undefined){
                var dependentAge = event.getParam("raiderDetails").Age__c.toString().match(/^-?\d+(?:)?/)[0];
                helper.getPremiumMatrices(component, dependentAge, 'Flexi Funeral Rate');
             }
             component.set("v.selectedCoverValue",event.getParam("raiderDetails").SumAssured);
             component.set("v.CoverPremium",event.getParam("raiderDetails").Premium);
             component.set('v.CoverPremiumLbl',  'Premium : R' + event.getParam("raiderDetails").Premium);
    	},
    
    	removeDeletedRow: function(component, event, helper) {
         
         // get the selected row Index for remove, from Lightning Event Attribute  
          	var index = event.getParam("indexVar");
            console.log('event=='+event);
          	var allRowsList = component.get("v.data");
          	allRowsList.splice(index, 1);
          	component.get("v.dependantMap").splice(index, 1);
          	component.set("v.data", allRowsList);
            //Added by Kalyani to make button enable
            if(component.get('v.dependantTypeFromFlow') == 'Extended Family Member' && component.get('v.data').length < 8) {
                component.find("newDependantButton").set("v.disabled", false);
            }
            
            else if(component.get('v.dependantTypeFromFlow') == 'Child' && component.get('v.data').length < 10) {
                component.find("newDependantButton").set("v.disabled", false);
            }
            if(event.getParam("raiderDetails").Id != undefined){
                component.set("v.updateRecordId",event.getParam("raiderDetails").Id);
                helper.removeDependant(component);
            }    
     	},
    
    	handleRowAction: function (cmp, event, helper) {
        	var action = event.getParam('action');
        	var row = event.getParam('row');
        	cmp.set("v.updateRecordId", row.Id);

        	switch (action.name) {
            	case 'update_details':
                //alert('Showing Details: ' + row.Id + JSON.stringify(row));
                var oppPartyId = cmp.get("v.updateRecordId");
                var action = cmp.get("c.getSingleParty");
                action.setParams({
                    "oppPartyId": oppPartyId
                });
                action.setCallback(this, function(response) {
                    var state = response.getState();
                    if (state === "SUCCESS") {
                        cmp.set("v.dependant", response.getReturnValue());
                        cmp.set("v.showUpdatePanel", true);
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
                });
                $A.enqueueAction(action);
                $A.get('e.force:refreshView').fire();
                
                break;
            case 'delete':
                helper.removeDependant(cmp, row)
                
                //var a = cmp.get('c.doInit');
                //$A.enqueueAction(a);
                 var a = cmp.get('c.onUpdate');
                $A.enqueueAction(a);
                $A.get('e.force:refreshView').fire();
                
                break;
        }
    },
    
    onCheck: function(cmp, evt) {
        var checkCmp = cmp.find("checkbox");
        cmp.set("v.isAlsoBeneficiary", checkCmp.get("v.value"));
	 },
    
    onUpdateCheck: function(cmp, evt) {
        var checkCmp = cmp.find("updateCheckbox");
        cmp.set("v.isAlsoBeneficiaryUpdate", checkCmp.get("v.value"));
	 },
    
    newDependant: function(component, event) {
        component.set("v.showNewPanel", true);
        component.set("v.showCommissionScreen", false);
	 },
    
    openConfirmation: function(component, event, helper) {
      // for Display Model,set the "isOpen" attribute to "true"
      component.set("v.showUpdatePanel", true);
   	},
 
    closeConfirmation: function(component, event, helper) {
        // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
        component.set("v.showUpdatePanel", false);
        component.set("v.dependant",{});
        component.set("v.selectedCoverValue",'');
        component.set("v.CoverPremiumLbl",'Premium : R0.00');
    },
    
    confrimAndClose: function(component, event, helper) {
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
        
          //Added by Kalyani on Age Validation for Direct Delivery Sales Opportunity
         if(component.get('v.recordtype') == 'Direct Delivery Sales Opportunity'){
             if(component.get("v.dependantTypeFromFlow") == 'Extended Family Member' && Number(age) > 75) {
                 allValid = false; 
                 var toastEvent = $A.get("e.force:showToast");
                 toastEvent.setParams({
                     "title": "Error!",
                     "message": "Dependant Age should be less than 75.",
                     "type":"error"
                 });
                 toastEvent.fire();
             }
            else if(component.get("v.dependantTypeFromFlow") == 'Child' && Number(age) > 70) {
                allValid = false; 
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Child Age should be less than 70.",
                    "type":"error"
                });
                toastEvent.fire();
            }
             var coverValue = component.find("flexiFuneralCover").get('v.value');
             if(coverValue == null || coverValue == ''){
                 allValid = false;
                 var toastEvent = $A.get('e.force:showToast');
                 toastEvent.setParams({
                     title: 'Error!',
                     message: 'Please enter the Cover value.',
                     type: 'error'
                 });
                 toastEvent.fire();
             } 
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
            if(Number(age) > 21 && component.get('v.recordtype') != 'Direct Delivery Sales Opportunity'){
                allValid = false; 
                // show error notification
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "A dependant cannot be older than 21 years of age.",
                    "type":"error"
                });
                toastEvent.fire();
            }
        }
        
        if (allValid) {
            
            var isAlsoBeneficiaryUpdate = component.get("v.isAlsoBeneficiaryUpdate");
            var isValid = true;
            
            if(isAlsoBeneficiaryUpdate == true){
                //Check if the totalSplit > 100
                helper.showSpinner(component);

                var oppId = component.get("v.recordId");
                var action = component.get("c.getTotalBenefitSplit");
                action.setParams({
                    "oppId": oppId
                });
                action.setCallback(this, function(response) {
                    var state = response.getState();
                    if (state === "SUCCESS") {
                        component.set("v.totalBeneficiarySplit", response.getReturnValue());   
                        
                        var currentValue = component.get("v.currentSplit");
                        if(currentValue == null){
                            currentValue = 0;
                        }
                        var totalBeneficiarySplit = component.get("v.totalBeneficiarySplit");
                        var newBeneficiarySplit = component.get("v.dependant.Benefit_Split__c");
                        
                        var total = ((Number(totalBeneficiarySplit))-(Number(currentValue))) + Number(newBeneficiarySplit);
                        if(total > 100){
                            isValid = false;
                            // show error notification
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                "title": "Error!",
                                "message": "Total Benefit Split cannot be greater than 100%. Please try again",
                                "type":"error"
                            });
                            toastEvent.fire();
                            component.set("v.dependant.Benefit_Split__c", null);
                        }
                        else if(Number(age) < 18){
                            isValid = false;
                            // show error notification
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                "title": "Error!",
                                "message": "A beneficiary must be older than 18 years of age.",
                                "type":"error"
                            });
                            toastEvent.fire();
                            component.set("v.dependant.Benefit_Split__c", null);
                        }
                        
                        if(isValid){                        
                            var oppParty = component.get("v.dependant");
                            var oppPartyId = component.get("v.updateRecordId"); 
                    
                            var action = component.get("c.updateOpportunityParty");
                            action.setParams({
                                "oppParty": oppParty,
                                "oppId": oppId,
                                "oppPartyId": oppPartyId,
                                "isAlsoBeneficiaryUpdate": isAlsoBeneficiaryUpdate
                            });
                            action.setCallback(this, function(a) {
                                var state = a.getState();
                                if (state === "SUCCESS") {
                                    var name = a.getReturnValue();
                                    if(name == null){
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
                                }
                                else{
                                    // show error notification
                                    var toastEvent = $A.get("e.force:showToast");
                                    toastEvent.setParams({
                                        "title": "Error!",
                                        "message": "Error updating Dependant1. Please try again",
                                        "type":"error"
                                    });
                                    toastEvent.fire();
                                }
                            });
                            $A.enqueueAction(action)
                            $A.get('e.force:refreshView').fire();
                            
                            //var a = component.get('c.doInit');
                            //$A.enqueueAction(a);
                            var a = component.get('c.onUpdate');
                			$A.enqueueAction(a);
                            component.set("v.showUpdatePanel", false);
                            component.set("v.showNewPanel", false);
                        }
                        
                    }
                    else {
                        isValid = false;
                        console.log("Failed with state: " + state);
                		var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                "title": "Error!",
                                "message": "An error has occured. Please try again",
                                "type":"error"
                            });
                        toastEvent.fire();
                    }
                    helper.hideSpinner(component);
                });
                $A.enqueueAction(action);     
            }
            //Else Not Beneficiary
            else{
                var oppParty = component.get("v.dependant");
                var oppPartyId = component.get("v.updateRecordId"); 
                
                if(component.get('v.recordtype') == 'Direct Delivery Sales Opportunity') {
                    var index = component.get("v.indexVar");
                    var allRowsList = component.get("v.data");
                    var allDependantList = component.get("v.dependantMap");
                    allRowsList.splice(index, 1);
                    component.get("v.dependantMap").splice(index, 1);
                    component.set("v.data", allRowsList);
                    helper.mapDependant(component);
                    component.set("v.showUpdatePanel", false);
                    component.set("v.showCommissionScreen", true);
                    component.set("v.isQuoteDone", false);
                    helper.hideSpinner(component);
                }
                  else{
                	var action = component.get("c.updateOpportunityParty");
                	action.setParams({
                    	"oppParty": oppParty,
                    	"oppId": oppId,
                    	"oppPartyId": oppPartyId,
                    	"isAlsoBeneficiaryUpdate": isAlsoBeneficiaryUpdate
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
                		});
                		$A.enqueueAction(action);
                		$A.get('e.force:refreshView').fire();
                		//var a = component.get('c.doInit');
                		//$A.enqueueAction(a);
                		var a = component.get('c.onUpdate');
                		$A.enqueueAction(a);
                		component.set("v.showUpdatePanel", false);
                		component.set("v.showNewPanel", false);
                 	 }
            	 }
        	 }
   		 },
})