({  
    doInit: function(component, event, helper) {
       // alert('do init')
        var opts = [];
                    opts.push({
						class: 'optionClass',
						label: '--- None ---',
						value: ''
					});
                    opts.push({
						class: 'optionClass',
						label: 10000,
						value: 10000
					});
                    component.set('v.UnveilingBenefitCoverOptions', opts);// added by pranav for PPR changes
        helper.showSpinner(component);
        helper.fetchOpportunityDetails(component);
		var actions = [
            { label: 'Update Details', iconName: 'utility:edit', name: 'update_details' },
            { label: 'Delete', iconName: 'utility:delete', name: 'delete' }
        ];
         if(component.get("v.opptyRecordType") != 'Direct Delivery Sales Opportunity'){
         component.set('v.columns', [
            		{ label: 'First Name', fieldName: 'First_Name__c', type: 'text' },
            		{ label: 'Last Name', fieldName: 'Last_Name__c', type: 'text' },
            		{ label: 'RSA ID Number', fieldName: 'RSA_ID_Number__c', type: 'text' },
            		{ label: 'Date of Birth', fieldName: 'Date_of_Birth__c', type: 'date' },
            		{ label: 'Age', fieldName: 'Age__c', type: 'number' },
            		{ label: 'Benefit Split %', fieldName: 'Benefit_Split__c', type: 'percent' },
            		{ label: 'Party Type(s)', fieldName: 'Party_Type__c', type: 'text' },
            		{ type: 'action', typeAttributes: { rowActions: actions } }
               ]);
             helper.retrieveSpouseDOB(component);
         }
        helper.fetchData(component);       
        helper.checkSpouseQuoted(component);
        helper.hideSpinner(component);
        helper.setHelpTextAfterFuneral(component);
        helper.setHelpTextGrocery(component);
        helper.setHelpTextUnveiling(component);
        helper.setHelpTextWaiver(component);
        console.log('selectedMainMemberCoverFromFlow',component.get("v.selectedMainMemberCoverFromFlow"));
        
    },
    
	addSpouse: function (component, event, helper) {
         
        //Remove spaces 
        var firstName = component.get("v.spouse.First_Name__c");
        if (!(/\S/.test(firstName))) {
            firstName = firstName.replace(/\s+/g, '');
        	component.set("v.spouse.First_Name__c", firstName);
        }
        
    	var lastName = component.get("v.spouse.Last_Name__c");
    	if (!(/\S/.test(lastName))) {
            lastName = lastName.replace(/\s+/g, '');
    		component.set("v.spouse.Last_Name__c", lastName);
        }
        
        var allValid = component.find('spouseForm').reduce(function (validSoFar, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            inputCmp.focus();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        
        //Check if date is in past
        var now = new Date();
        var selectedDate = new Date(component.get("v.spouse.Date_of_Birth__c"));
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
        //Check Age
         var today = new Date();
         var birthDate = new Date(component.get("v.spouse.Date_of_Birth__c"));
         var age = today.getFullYear() - birthDate.getFullYear();
         var m = today.getMonth() - birthDate.getMonth();
         if (m < 0 || (m === 0 && today.getDate() < birthDate.getDate())) {
             age--;
         }
        
        //Added by Kalyani on Age Validation for Direct Delivery Sales Opportunity
        if(component.get('v.opptyRecordType') == 'Direct Delivery Sales Opportunity'){
            if(Number(age) < 18 || Number(age) > 70) {
                allValid = false; 
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Spouse Age should be in between 18 and 70.",
                    "type":"error"
                });
                toastEvent.fire();
            }
            var coverValue = component.find("flexiFuneralCover").get('v.value');
            if(coverValue == null || coverValue == ''){
            var toastEvent = $A.get('e.force:showToast');
	  		toastEvent.setParams({
					title: 'Error!',
					message: 'Please enter the Cover value.',
					type: 'error'
		    	});
	   		toastEvent.fire();
       		}
        }
        if (allValid) {
            
            var isAlsoBeneficiary = component.get("v.isAlsoBeneficiary");
            var isValid = true;
            if(isAlsoBeneficiary == true){
                //Check if beneficiary is older than 18
                /*var today = new Date();
                var birthDate = new Date(component.get("v.spouse.Date_of_Birth__c"));
                var age = today.getFullYear() - birthDate.getFullYear();
                var m = today.getMonth() - birthDate.getMonth();
                if (m < 0 || (m === 0 && today.getDate() < birthDate.getDate())) {
                    age--;
                }*/
                
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
                        var newBeneficiarySplit = component.get("v.spouse.Benefit_Split__c");
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
                            component.set("v.spouse.Benefit_Split__c", null);
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
                            component.set("v.spouse.Benefit_Split__c", null);
                        }
                        
                        if(isValid){
                
                            helper.showSpinner(component);
                    
                            var oppParty = component.get("v.spouse");
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
                                        component.set("v.spouse",name);
                                        
                                        // show success notification
                                        var toastEvent = $A.get("e.force:showToast");
                                        toastEvent.setParams({
                                            "title": "Success!",
                                            "message": "Spouse Successfully Added",
                                            "type":"success"
                                        });
                                        toastEvent.fire();
                                        
                                        component.find("newSpouseButton").set("v.disabled", true);
                                    }
                                }
                                else{
                                    // show error notification
                                    var toastEvent = $A.get("e.force:showToast");
                                    toastEvent.setParams({
                                        "title": "Error!",
                                        "message": "Error adding Spouse. Please try again",
                                        "type":"error"
                                    });
                                    toastEvent.fire();
                                }
                                helper.hideSpinner(component);
                            });
                            $A.enqueueAction(action);
                            $A.get('e.force:refreshView').fire();
                            
                            component.set("v.showNewPanel", false);
                
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
                if(component.get("v.opptyRecordType") == 'Direct Delivery Sales Opportunity')
              		component.find("addSpouse").set("v.disabled", true);
                var oppParty = component.get("v.spouse");
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
                        component.set("v.spouse",name);
                         // show success notification
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Success!",
                            "message": "Spouse Successfully Added",
                            "type":"success"
                        });
                        toastEvent.fire();
                        if(component.get("v.opptyRecordType") == 'Direct Delivery Sales Opportunity')
                        	component.set("v.showNewPanel", false);
                            
                        component.find("newSpouseButton").set("v.disabled", true);                        
                    }
                    else{
                        // show error notification
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Error!",
                            "message": "Error adding Spouse. Please try again",
                            "type":"error"
                        });
                        toastEvent.fire();
                    }
                    helper.hideSpinner(component);
                });
                $A.enqueueAction(action);
                $A.get('e.force:refreshView').fire();
                
                if(component.get("v.opptyRecordType") != 'Direct Delivery Sales Opportunity')
                	component.set("v.showNewPanel", false);
                
                var a = component.get('c.onUpdate');
                $A.enqueueAction(a);
                
            }
        }
    },
    
    
    handleRowAction: function (cmp, event, helper) {
        var action = event.getParam('action');
        console.log('action',action);
        var row = event.getParam('row');
        console.log('row',row);
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
                        cmp.set("v.spouse", response.getReturnValue());
                        cmp.set("v.showUpdatePanel", true);
                        cmp.set("v.currentSplit", cmp.get("v.spouse.Benefit_Split__c"));

                        if(cmp.get("v.spouse.Party_Type__c").includes("Beneficiary")){
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
                helper.removeSpouse(cmp, row)
                
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
    
    onUpdate: function(cmp, evt) {
        helper.fetchData(component);
        helper.retrieveSpouseDOB(component);
        helper.checkSpouseQuoted(component);
	 },
    
    onUpdateCheck: function(cmp, evt) {
        var checkCmp = cmp.find("updateCheckbox");
        cmp.set("v.isAlsoBeneficiaryUpdate", checkCmp.get("v.value"));
	 },
    
    newSpouse: function(component, event, helper) {
        component.set("v.showNewPanel", true);
        component.set("v.showQuoteScreen", true);
        component.set("v.showSpouseScreen", false);
        component.set('v.showCommissionScreen', false);
        helper.fetchquotelineitems(component,'newspouse');
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
        
        //Check if beneficiary is older than 18
                var today = new Date();
                var birthDate = new Date(component.get("v.spouse.Date_of_Birth__c"));
                var age = today.getFullYear() - birthDate.getFullYear();
                var m = today.getMonth() - birthDate.getMonth();
                if (m < 0 || (m === 0 && today.getDate() < birthDate.getDate())) {
                    age--;
           		}
        
         //Added by Kalyani on Age Validation for Direct Delivery Sales Opportunity
         if(component.get('v.opptyRecordType') == 'Direct Delivery Sales Opportunity'){
            if(Number(age) < 18 || Number(age) > 70) {
                allValid = false; 
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Spouse Age should be in between 18 and 70.",
                    "type":"error"
                });
                toastEvent.fire();
            }
            var coverValue = component.find("flexiFuneralCover").get('v.value');
            if(coverValue == null || coverValue == ''){
            var toastEvent = $A.get('e.force:showToast');
	  		toastEvent.setParams({
					title: 'Error!',
					message: 'Please enter the Cover value.',
					type: 'error'
		    	});
	   		toastEvent.fire();
       		}
        }
        
        if (allValid) {
            
            var isAlsoBeneficiaryUpdate = component.get("v.isAlsoBeneficiaryUpdate");
            var isValid = true;
            
            if(isAlsoBeneficiaryUpdate == true){
                //Check if beneficiary is older than 18
                /*var today = new Date();
                var birthDate = new Date(component.get("v.spouse.Date_of_Birth__c"));
                var age = today.getFullYear() - birthDate.getFullYear();
                var m = today.getMonth() - birthDate.getMonth();
                if (m < 0 || (m === 0 && today.getDate() < birthDate.getDate())) {
                    age--;
                }*/
                
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
                        var newBeneficiarySplit = component.get("v.spouse.Benefit_Split__c");
                        
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
                            component.set("v.spouse.Benefit_Split__c", null);
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
                            component.set("v.spouse.Benefit_Split__c", null);
                        }
                        
                        if(isValid){                        
                            var oppParty = component.get("v.spouse");
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
                                        component.set("v.spouse",name);
                                        
                                        // show success notification
                                        var toastEvent = $A.get("e.force:showToast");
                                        toastEvent.setParams({
                                            "title": "Success!",
                                            "message": "Spouse Successfully Updated",
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
                                        "message": "Error updating Spouse. Please try again",
                                        "type":"error"
                                    });
                                    toastEvent.fire();
                                }
                            });
                            $A.enqueueAction(action)
                            $A.get('e.force:refreshView').fire();
                            
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
                var oppParty = component.get("v.spouse");
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
                        component.set("v.spouse",name);
                        
                        // show success notification
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Success!",
                            "message": "Spouse Successfully Updated",
                            "type":"success"
                        });
                        toastEvent.fire();                       
                    }
                    else{
                        // show error notification
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Error!",
                            "message": "Error updating Spouse. Please try again",
                            "type":"error"
                        });
                        toastEvent.fire();
                    }
                });
                $A.enqueueAction(action)
                $A.get('e.force:refreshView').fire();
                
                var a = component.get('c.onUpdate');
                $A.enqueueAction(a);
                component.set("v.showUpdatePanel", false);
                component.set("v.showNewPanel", false);
            }
        }
    },
    
    // Added for Direct Delivery Spouse Quote
    onBenefitCheck: function(component, event, helper) {
        
		var benefitCheckSource = event.getSource().getLocalId();
        var benefitCheckValue = event.getSource().get('v.value');
        var benefitName = event.getSource().get("v.label");
		if (benefitCheckSource == 'GroceryBenefitCheckbox') {
           var groceryBenefit = component.find("GroceryBenefitSelect");
            if(benefitCheckValue == true)
           		groceryBenefit.set('v.disabled',false);
            else{
                 groceryBenefit.set('v.disabled',true);
                 component.set('v.selectedGroceryBenefitCoverValue', '');
                 component.set('v.GroceryBenefitPremium', 0);
				 component.set('v.GroceryBenefitPremiumLbl', 'Premium : R0.00');
           		 }
               
			} else if(benefitCheckSource == 'AfterfuneralBenefitCheckbox'){
				var funeralBenefit = component.find("afterfuneralSelect");
            	if(benefitCheckValue == true)
           			funeralBenefit.set('v.disabled',false);
            	else{
                 	funeralBenefit.set('v.disabled',true);
                 	component.set('v.selectedFuneralBenefitCoverValue', '--- None ---');
                 	component.set('v.AfterFuneralBenefitPremium', 0);
				 	component.set('v.AfterFuneralBenefitPremiumLbl', 'Premium : R0.00');
            	}
               
			}
        	else if(benefitCheckSource == 'UnveilingBenefitCheckbox'){
				var unveilingBenefit = component.find("unveilingSelect");
                if(benefitCheckValue == true){
                    unveilingBenefit.set('v.disabled',false);
                    var opts = [];
                    opts.push({
						class: 'optionClass',
						label: '--- None ---',
						value: ''
					});
                    opts.push({
						class: 'optionClass',
						label: 10000,
						value: 10000
					});
                    component.set('v.UnveilingBenefitCoverOptions', opts);
                }
            	else{
                	unveilingBenefit.set('v.disabled',true);
                	component.set('v.selectedUnveilingBenefitCoverValue', '--- None ---');
                	component.set('v.UnveilingBenefitPremium', 0);
					component.set('v.UnveilingBenefitPremiumLbl', 'Premium : R0.00');
            	}     
			}
		
        	if(benefitCheckValue == false){
            	var benefitMap = component.get('v.benefitMap');
                var Premium;
            	for(var i = 0; i < benefitMap.length; i++){
                	if(benefitMap[i].Name == benefitName){
                        Premium = benefitMap[i].premium;
                    	benefitMap.splice(i,1);
                	}
            	}
                var finalPremium = Number(component.get('v.totalPremium')) - Number(Premium);
                component.set('v.totalPremium', finalPremium);
				component.set('v.totalPremiumLbl', 'Total Premium : R' + finalPremium);
            	component.set('v.benefitMap',benefitMap);
        }
	},
    
    // Added for Direct Delivery Spouse Quote
   	onPicklistCoverChange: function(component, event, helper) {
		var sumInsured = event.getSource().get('v.value');
        var sumSource = event.getSource().getLocalId();
        var benefitName = event.getSource().get("v.label");
        var opptyRecordType = component.get('v.opptyRecordType');
        var opptyProductInt = component.get('v.opptyProductInt');
		if (sumInsured == '') {
            if(sumSource == 'flexiFuneralCover'){
                component.set('v.CoverPremium', 0);
				component.set('v.CoverPremiumLbl', 'Premium : R0.00');
            }
            else if(sumSource == 'GroceryBenefitSelect'){
                component.set('v.GroceryBenefitPremium', 0);
				component.set('v.GroceryBenefitPremiumLbl', 'Premium : R0.00');
            }
            else if(sumSource == 'afterfuneralSelect'){
                component.set('v.AfterFuneralBenefitPremium', 0);
				component.set('v.AfterFuneralBenefitPremiumLbl', 'Premium : R0.00');
            }
            else if(sumSource == 'unveilingSelect'){
                component.set('v.UnveilingBenefitPremium', 0);
				component.set('v.UnveilingBenefitPremiumLbl', 'Premium : R0.00');
            }
           
        } else {
            if(opptyRecordType === 'Direct Delivery Sales Opportunity'){

                  if(sumSource === 'flexiFuneralCover' || sumSource === 'GroceryBenefitSelect'){
                    if(sumInsured == 15000)
                        helper.calculatePremium(component, component.get('v.MainMemberPremiumRate'), 0 , sumInsured, sumSource);
                    else if(sumInsured == 1000)
                        helper.calculatePremium(component, component.get('v.MainMemberGroceryRate'), 0 , sumInsured, sumSource);
                    else
                        helper.getPremiumMatrices(component, sumInsured, 'Flexi Funeral Discount',sumSource);
                  }
            	else if(sumSource === 'afterfuneralSelect')
                	helper.calculatePremium(component, component.get('v.MainMemberFuneralRate'), 0 , sumInsured, sumSource);
                else if(sumSource === 'unveilingSelect')
                        helper.calculatePremium(component, component.get('v.MainMemberUnveilingRate'), 0 , sumInsured, sumSource);
               
			   }
            }
            helper.calculateTotal(component);
		},
    
    	newQuoteProcess: function(component, event, helper) {
			
			component.set('v.showQuoteScreen', true);
			component.set('v.showCommissionScreen', false);
            component.set('v.showSpouseScreen', true);
            component.set('v.isEditQuote', true);
            var spouseAge = component.get("v.spouseAge").toString().match(/^-?\d+(?:)?/)[0];
            helper.fetchquotelineitems(component,'editquote');
            helper.getPremiumMatrices(component, spouseAge, 'Flexi Funeral Rate');
		},
    
     	//Cancel button 
    	cancelAndCloseTab : function(component, event, helper) {
        	//Close focus tab and navigate home
        	component.set('v.showQuoteScreen', false);
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
             var today = new Date();
             var birthDate = new Date(component.get("v.spouse.Date_of_Birth__c"));
             var age = today.getFullYear() - birthDate.getFullYear();
             var m = today.getMonth() - birthDate.getMonth();
             if (m < 0 || (m === 0 && today.getDate() < birthDate.getDate())) {
                    age--;
           	}
            component.set("v.spouseAge",Number(age));
            if(component.get('v.opptyRecordType') == 'Direct Delivery Sales Opportunity')
            	helper.getPremiumMatrices(component, Number(age), 'Flexi Funeral Rate');
    	},
    
 		handleChange : function(component, event, helper) {
      		var response = event.getSource().getLocalId();
      		component.set("v.value", response);
      		var coverValue = component.find("flexiFuneralCover").get('v.value');
      		if(coverValue == null || coverValue == ''){
            var toastEvent = $A.get('e.force:showToast');
	  		toastEvent.setParams({
					title: 'Error!',
					message: 'Please enter the Cover value.',
					type: 'error'
		    	});
	   		toastEvent.fire();
       		}
      		else{
          		helper.mapOpportunityLineItem(component, event);
                helper.updateSpouse(component);
                helper.createNewQuote(component);
                component.set("v.showNewPanel", false);
        		component.set("v.showQuoteScreen", false);
        		component.set('v.showCommissionScreen', true);
            	//var navigate = component.get("v.navigateFlow");
      			//navigate("NEXT");
        	}
   		}
})