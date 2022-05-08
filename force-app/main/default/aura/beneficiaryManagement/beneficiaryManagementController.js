({
    doInit: function(component, event, helper) {
        
        if(component.get("v.recordId") == undefined)
            component.set("v.recordId", component.get("v.OpportunityIdFromFlow"));
        helper.showSpinner(component);
        helper.getOpportunitypartyDetails(component,event);
        helper.fetchData(component);
        helper.fetchOppData(component);
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
                    if(component.get("v.oppRecordType") != 'Direct Delivery Sales Opportunity'){
                    	component.find("newBeneficiaryButton").set("v.disabled", true);
                    }
                }
                else{
                    if(component.get("v.oppRecordType") != 'Direct Delivery Sales Opportunity'){
                    	component.find("newBeneficiaryButton").set("v.disabled", false);
                }
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
                     if(component.get("v.oppRecordType") != 'Direct Delivery Sales Opportunity'){
                   		 component.find("newBeneficiaryButton").set("v.disabled", true);
                     }
                }
            }
        });
        $A.enqueueAction(action);
        
        helper.hideSpinner(component); 
    },
    
    handleNext : function(component, event, helper) {
        
         var beneficiary = component.get("v.data");
         var response = event.getSource().getLocalId();

         if(beneficiary.length == 0 && response == 'NEXT'){
            	var toastEvent = $A.get('e.force:showToast');
	  			toastEvent.setParams({
					title: 'Error!',
					message: 'Please enter Beneficiary.',
					type: 'error'
		    	});
	   			toastEvent.fire();
       	}
        else if(beneficiary.length > 0 && response == 'NEXT' && component.get("v.ProductNameFromFlow") == 'Ultimate Protector'){
            if(beneficiary[0].Date_of_Birth__c == undefined || beneficiary[0].Date_of_Birth__c == null){
                    var toastEvent = $A.get('e.force:showToast');
	  				toastEvent.setParams({
						title: 'Error!',
						message: 'Please enter Date of Birth of Beneficiary.',
						type: 'error'
		    		});
	   				toastEvent.fire();
            } 
            else{
                component.set("v.value", response);
            	var navigate = component.get("v.navigateFlow");
            	navigate(response);
            }
        }
       /* else if(beneficiary.length > 0 && response == 'NEXT' && component.get("v.ProductNameFromFlow") == 'Health Assistance'){
           if(beneficiary[0].RSA_ID_Number__c == undefined || beneficiary[0].RSA_ID_Number__c == null){
                    var toastEvent = $A.get('e.force:showToast');
	  				toastEvent.setParams({
						title: 'Error!',
						message: 'Please enter ID Number of Beneficiary.',
						type: 'error'
		    		});
	   				toastEvent.fire();
            } 
            else{
                component.set("v.value", response);
            	var navigate = component.get("v.navigateFlow");
            	navigate(response);
            }
        }*/ //commneted on 11 06 2020 by pranav 
        else{
      		component.set("v.value", response);
            var navigate = component.get("v.navigateFlow");
            navigate(response);
        }
        
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
        
        //Added by Poulami to store the productname selected for the Beneficiary for Direct Delivery
        if(component.get("v.oppRecordType") == 'Direct Delivery Sales Opportunity'){
            component.set("v.beneficiary.Beneficiary_Product__c", component.get("v.ProductNameFromFlow"));
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
                helper.showSpinner(component);
                
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
                                    else if(component.get("v.oppRecordType") == 'Direct Delivery Sales Opportunity' && component.get("v.data").length > 0){
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
                                            "oppId": oppId,
                                            "isAlsoDependant": isAlsoDependant
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
                                                            if(component.get("v.oppRecordType") != 'Direct Delivery Sales Opportunity'){
                                                            	component.find("newBeneficiaryButton").set("v.disabled", true);
                                                            }
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
                                                                     if(component.get("v.oppRecordType") != 'Direct Delivery Sales Opportunity'){
                                                                    		component.find("newBeneficiaryButton").set("v.disabled", true);
                                                                     }
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
                            
                                        //var a = component.get('c.doInit');
                                        //$A.enqueueAction(a);
                                        
                                        helper.fetchData(component);
                                        helper.fetchPickListVal(component, 'Relationship__c', 'relationship');
                                    }
                                }
                            });
                            $A.enqueueAction(action);
                        }
                    }
                    helper.hideSpinner(component);
                });
                $A.enqueueAction(action);
            }
        }
    },
    
    handleRowAction: function (cmp, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        cmp.set("v.updateRecordId", row.Id);

        switch (action.name) {
            case 'update_details':
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
                     	if(cmp.get("v.oppRecordType") != 'Direct Delivery Sales Opportunity'){
                        if(cmp.get("v.beneficiary.Party_Type__c").includes("Dependant")){
                            var chkBox = cmp.find("updateCheckbox");
							chkBox.set("v.value", true);
                            cmp.set("v.isAlsoDependantUpdate", true);
                        }
                        else{
                            cmp.set("v.isAlsoDependantUpdate", false);
                        }
                      }
                        if(cmp.get("v.oppRecordType") == 'Direct Delivery Sales Opportunity'){
                            cmp.set("v.isAlsoDependantUpdate", true);
                        }
                    }
                    else {
                        console.log("Failed with state: " + state);
                    }
                });
                $A.enqueueAction(action);
                
                break;
            case 'delete':
                helper.removeBeneficiary(cmp, row);
                
                var a = cmp.get('c.doInit');
            	$A.enqueueAction(a);
                $A.get('e.force:refreshView').fire();
                
                break;
             case 'Remove':
                helper.removeBeneficiaryParty(cmp, row);
                
                var a = cmp.get('c.doInit');
            	$A.enqueueAction(a);
                $A.get('e.force:refreshView').fire();
        }
    },
    
    onCheck: function(cmp, evt) {
        var checkCmp = cmp.find("checkbox");
        cmp.set("v.isAlsoDependant", checkCmp.get("v.value"));
	 },
    
    onUpdateCheck: function(cmp, evt) {
        var checkCmp = cmp.find("updateCheckbox");
        cmp.set("v.isAlsoDependantUpdate", checkCmp.get("v.value"));
	 },
    
    onPicklistRelationshipChange: function(component, event, helper) {
        component.set("v.beneficiary.Relationship__c", event.getSource().get("v.value"));
    },
    
    onPicklistRelationshipChangeUpdate: function(component, event, helper) {
        component.set("v.beneficiary.Relationship__c", event.getSource().get("v.value"));
    },
    
    newBeneficiary: function(component, event) {
        component.set("v.showNewPanel", true);
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
            if(currentValue == 'undefined' || currentValue == undefined){
                currentValue = 0;
            }
            var totalBeneficiarySplit = component.get("v.totalBeneficiarySplit");
            var newBeneficiarySplit = component.get("v.beneficiary.Benefit_Split__c");
            console.log('currentValue '+currentValue);
            console.log('totalBeneficiarySplit '+totalBeneficiarySplit);
            console.log('newBeneficiarySplit '+newBeneficiarySplit);
            var total = ((Number(totalBeneficiarySplit)*100)-(Number(currentValue))) + Number(newBeneficiarySplit);
            console.log('total '+total);
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
            else if(component.get("v.ProductNameFromFlow") === "Health Assistance"
                    && (component.get("v.beneficiary.RSA_ID_Number__c") === undefined
                        || component.get("v.beneficiary.RSA_ID_Number__c") === ""))
            {
                // show error notification
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "RSA ID Number is Required for Health Assistance Beneficiaries",
                    "type":"error"
                });
                toastEvent.fire();
            }
            else{   
                helper.showSpinner(component);
                
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
                                "oppPartyId": oppPartyId,
                                "isAlsoDependantUpdate": isAlsoDependantUpdate
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
                                                 if(component.get("v.oppRecordType") != 'Direct Delivery Sales Opportunity'){
                                               		 component.find("newBeneficiaryButton").set("v.disabled", true);
                                                 }
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
                            $A.get('e.force:refreshView').fire();
                            
                            //var a = component.get('c.doInit');
                            //$A.enqueueAction(a);
                            
                            helper.fetchData(component);
                            helper.fetchPickListVal(component, 'Relationship__c', 'relationship');
                            
                            component.set("v.showUpdatePanel", false);
                            component.set("v.showNewPanel", false);
                        }
                    }
                    helper.hideSpinner(component);
                });
                $A.enqueueAction(action);
            }
        }
    },
    onPicklistselectedCaptureResponseChange : function(component, event, helper) {
       var selectedValue = event.getSource().get("v.value") ; 
        if(selectedValue != '' && selectedValue == 'Yes'){
            helper.generateFamilyPicklistOptions(component,event); 
            component.set("v.showNewPanel", false);
        }
        else if(selectedValue != '' && selectedValue == 'No'){
            component.set("v.showNewRiderButton",true);
            component.set("v.selectedFamilyMemberResponse",'');
            component.set("v.showexistingFamilyOptions",false);
            component.set("v.showNewPanel", true);
        }
        else if(selectedValue == ''){
            component.set("v.showexistingFamilyOptions",false);
            component.set("v.showNewRiderButton",false);
        }
    },
    onPicklistexistingFamilyOptionsChange :function(component, event, helper)
    {
        var selectedFamlyval = event.getSource().get("v.value");
        component.set("v.raiderDetails",{});
        let objTest = component.get("v.raiderDetails");
        var existingOppDetailMap = component.get("v.OpportunityPartyDetailsMap");
        var allBeneficiariesMap = component.get("v.allBeneficiariesMap");
        //Poulami commented for beneficiary check
        /*if(selectedFamlyval != ''
           && existingOppDetailMap != null
           && Object.keys(existingOppDetailMap).includes(selectedFamlyval)
           && (component.get("v.ProductNameFromFlow") != "Health Assistance"
               || (component.get("v.ProductNameFromFlow") === "Health Assistance"
                   && existingOppDetailMap[selectedFamlyval].RSA_ID_Number__c != undefined
                   && existingOppDetailMap[selectedFamlyval].RSA_ID_Number__c != "")))*/
        if(selectedFamlyval != ''
           && existingOppDetailMap != null
           && Object.keys(existingOppDetailMap).includes(selectedFamlyval))
        {
            objTest.Name=existingOppDetailMap[selectedFamlyval].First_Name__c+''+existingOppDetailMap[selectedFamlyval].Last_Name__c;
            objTest.First_Name__c =existingOppDetailMap[selectedFamlyval].First_Name__c;//component.get("v.opportunityDetails.Person_Account_First_Name__c");
            objTest.Last_Name__c =existingOppDetailMap[selectedFamlyval].Last_Name__c;//component.get("v.opportunityDetails.Person_Account_Last_Name__c");
            objTest.ID_Type__c =existingOppDetailMap[selectedFamlyval].ID_Type__c;
            objTest.RSA_ID_Number__c =existingOppDetailMap[selectedFamlyval].RSA_ID_Number__c;//component.get("v.opportunityDetails.ID_Number__c");
            objTest.Date_of_Birth__c =existingOppDetailMap[selectedFamlyval].Date_of_Birth__c;//component.get("v.opportunityDetails");
            objTest.Gender__c =existingOppDetailMap[selectedFamlyval].Gender__c;//component.get("v.opportunityDetails.Person_Account_Gender__c");
            objTest.Opportunity__c=component.get("v.recordId");
            objTest.Benefit_Split__c =existingOppDetailMap[selectedFamlyval].Benefit_Split__c;
            objTest.Relationship__c =existingOppDetailMap[selectedFamlyval].Relationship__c;
            
            if(existingOppDetailMap[selectedFamlyval].Beneficiary_Product__c == undefined)
                objTest.Beneficiary_Product__c = component.get("v.ProductNameFromFlow");
            else{
                if(!existingOppDetailMap[selectedFamlyval].Beneficiary_Product__c.includes(component.get("v.ProductNameFromFlow")))
                    objTest.Beneficiary_Product__c =existingOppDetailMap[selectedFamlyval].Beneficiary_Product__c+';'+component.get("v.ProductNameFromFlow");
            }           

            if(existingOppDetailMap[selectedFamlyval].Party_Type__c != null && existingOppDetailMap[selectedFamlyval].Party_Type__c != '' && existingOppDetailMap[selectedFamlyval].Party_Type__c != undefined){

                    if(!existingOppDetailMap[selectedFamlyval].Party_Type__c.includes('Beneficiary')){
                       objTest.Party_Type__c = 'Beneficiary;'+existingOppDetailMap[selectedFamlyval].Party_Type__c;  
                    }
            	} else {
                	objTest.Party_Type__c = 'Beneficiary';
            	}
            	objTest.Age__c =existingOppDetailMap[selectedFamlyval].Age__c;
           		objTest.Id =existingOppDetailMap[selectedFamlyval].Id;
            	var existedData = component.get("v.allBeneficiaries");
                
            if(allBeneficiariesMap == null){
                if(existedData.length >0){
                    //existedData.push(objTest);
                     var toastEvent = $A.get("e.force:showToast");
                     toastEvent.setParams({
                          "title": "Error!",
                          "message": "No more beneficiaries can be added as the limit has been reached.",
                          "type":"error"
                     });
                     toastEvent.fire();
                }else{
                    existedData=[];
                    existedData.push(objTest);
                }
            
                component.set("v.allBeneficiaries",existedData);
                component.set("v.data", existedData);  
            }
            else if(allBeneficiariesMap != null && !Object.keys(allBeneficiariesMap).includes(selectedFamlyval)){
                if(existedData.length >0){
                    //existedData.push(objTest);
                    var toastEvent = $A.get("e.force:showToast");
                     toastEvent.setParams({
                          "title": "Error!",
                          "message": "No more beneficiaries can be added as the limit has been reached.",
                          "type":"error"
                     });
                     toastEvent.fire();
                }else{
                    existedData=[];
                    existedData.push(objTest);
                }
            
                component.set("v.allBeneficiaries",existedData);
                component.set("v.data", existedData);  
            }
            component.set("v.raiderDetails",{});
            component.set("v.selectedCaptureResponse",''); //setting yes no to empty
            component.set("v.selectedFamilyMemberResponse",'');//seeting family response to empty
            component.set("v.showexistingFamilyOptions",false);
            helper.saveOppPartyData(component,event,helper);
        }
        
        /*if(selectedFamlyval != ''
           && existingOppDetailMap != null
           && component.get("v.ProductNameFromFlow") === "Health Assistance"
           && (existingOppDetailMap[selectedFamlyval].RSA_ID_Number__c === undefined
               || existingOppDetailMap[selectedFamlyval].RSA_ID_Number__c === ""))
        {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Please Add Beneficiary ID Number",
                "type":"error"
            });
            toastEvent.fire();
        }*/
         
        if(allBeneficiariesMap != null)
        {
         if(Object.keys(allBeneficiariesMap).includes(selectedFamlyval)){
             var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "information!",
                    "message": "Beneficiary Already Added",
                    "type":"info"
                });
                toastEvent.fire();
         }
        }
    },
})