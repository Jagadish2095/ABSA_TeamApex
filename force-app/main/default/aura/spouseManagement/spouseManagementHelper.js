({
    fetchData: function (component) {
        var oppId = component.get("v.recordId");
        var action = component.get("c.getPartyData");
        action.setParams({
            "oppId": oppId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.data", response.getReturnValue());
                console.log('spouse',component.get("v.data"));
                component.set("v.allBeneficiaries", response.getReturnValue());
               if(response.getReturnValue().length >= 1){
                    component.find("newSpouseButton").set("v.disabled", true);

                   if(component.get("v.opptyRecordType") == 'Direct Delivery Sales Opportunity'){
                       this.mapOpportunityLineItem(component);
                       component.set("v.showNewPanel", false);
                       component.set("v.showQuoteScreen", false);
                       component.set("v.showCommissionScreen", true);
                   }                     
                }
                console.log('data@@'+response.getReturnValue().length);
                var beneficiaries = component.get("v.allBeneficiaries");
                var totalSplit = 0;
                for (var i = 0; i < beneficiaries.length; i++) {
                    component.set("v.spouseAge",beneficiaries[i].Age__c);
                    component.set("v.spouse", beneficiaries[i]);
                    if(beneficiaries[i].Benefit_Split__c != null && beneficiaries[i].Party_Type__c.includes("Beneficiary")){
                        totalSplit += beneficiaries[i].Benefit_Split__c;
                    }                    
                }
                component.set("v.totalBeneficiarySplit", totalSplit);
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
                	component.set("v.spouse.Date_of_Birth__c", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    
    checkSpouseQuoted: function (component) {
        var oppId = component.get('v.recordId');
        var action = component.get("c.checkIfSpouseQuoted");

        action.setParams({
            "oppId": oppId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if(response.getReturnValue() == false ){
                    component.find("newSpouseButton").set("v.disabled", true);
                }
                if(component.get("v.opptyRecordType") == 'Direct Delivery Sales Opportunity')
                      this.retrieveQuoteData(component);
                }
        });
        $A.enqueueAction(action);
    },
    
    removeSpouse: function (cmp, row) {
        var oppPartyId = cmp.get("v.updateRecordId");
        var action = cmp.get("c.removeOpportunityParty");
        var oppRecordType = cmp.get("v.opptyRecordType");
        var oppId = cmp.get('v.recordId');
        var benefit = cmp.get('v.lineItemMap');
        
        action.setParams({
            "oppPartyId": oppPartyId
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state === "SUCCESS") {
                
                if(oppRecordType == 'Direct Delivery Sales Opportunity'){
                	var action = cmp.get("c.removeDDQuote");
                
                	action.setParams({
            			"OpportunityPartyId": oppPartyId,
                    	"oppId": oppId,
						"totalPremium": cmp.get('v.totalPremium').toString(),
						"product": cmp.get('v.selectedProductNameFromFlow'),
                		"lineItems": JSON.stringify(benefit),
                		"partyType": 'Spouse'
        			});
                    
                    action.setCallback(this, function(response) {
            		var state = response.getState();
            		if (state === "SUCCESS") {
                		cmp.set('v.showCommissionScreen', false);
						cmp.find("newSpouseButton").set("v.disabled", false);
                        cmp.set("v.spouse",{});
            		}
        		});
        			$A.enqueueAction(action);
             	}
                
                // show success notification
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "Spouse Successfully Removed",
                    "type":"success"
                });
                toastEvent.fire();
                
                //Remove from view
                var rows = cmp.get('v.data');
                var rowIndex = rows.indexOf(row);
                
                rows.splice(rowIndex, 1);
                cmp.set('v.data', rows);
                
                cmp.find("newSpouseButton").set("v.disabled", false);
            }
            else{
                // show error notification
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Error removing Spouse. Please try again",
                    "type":"error"
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
        $A.get('e.force:refreshView').fire();
    },
    
    showSpinner: function (component) {
        var spinner = component.find("TheSpinner");
        $A.util.removeClass(spinner, "slds-hide");
    },
    hideSpinner: function (component) {
        var spinner = component.find("TheSpinner");
        $A.util.addClass(spinner, "slds-hide");

    },
    
    fetchOpportunityDetails: function(component) {
        component.set('v.showSpinner', true);
        
        if(component.get('v.recordId') !== undefined)
            var oppId = component.get('v.recordId');
        
        else{
            var oppId = component.get('v.selectedOppIdFromFlow');
            component.set("v.recordId", oppId);
        }
        
       
        var action = component.get('c.fetchOpportunityRecord');
        action.setParams({
            oppId: oppId
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
           			if (state === 'SUCCESS') {
                
                var opportunities = a.getReturnValue();
                if (a.getReturnValue() != null){
					//component.set("v.objTypes", opportunities[0]);
                	var opptyRecordType = opportunities[0].Opportunity_Record_Type_Name__c;
                    for(var k in opportunities[0]){
                        if(k == 'Product_Interest__c'){
                            var opptyProductInt = opportunities[0].Product_Interest__r.Product__c;
                        	component.set('v.opptyProductInt', opptyProductInt);
                        }
                	}
                    component.set('v.opptyRecordType', opptyRecordType);
                 }
                //Set picklist values
                if(opptyRecordType === 'Direct Delivery Sales Opportunity'){
                    this.fetchPickListVal(component, 'Flexi_Funeral_Cover__c', 'flexiFuneralCover');
					this.fetchPickListVal(component, 'Grocery_Benefit_Cover__c', 'GroceryBenefitCover');
            		this.fetchPickListVal(component, 'Benefit_Cover__c', 'funeralBenefit');
            		this.fetchPickListVal(component, 'Unveiling_Benefit_Cover__c', 'unveilingBenefit');
                    var actions = [
            			//{ label: 'Update Details', iconName: 'utility:edit', name: 'update_details' },
            			{ label: 'Delete', iconName: 'utility:delete', name: 'delete' }
        			];
                    component.set('v.columns', [
            		{ label: 'First Name', fieldName: 'First_Name__c', type: 'text' },
            		{ label: 'Last Name', fieldName: 'Last_Name__c', type: 'text' },
            		{ label: 'RSA ID Number', fieldName: 'RSA_ID_Number__c', type: 'text' },
                    { label: 'Gender', fieldName: 'Gender__c', type: 'text' },
            		{ label: 'Date of Birth', fieldName: 'Date_of_Birth__c', type: 'date' },
            		{ label: 'Age', fieldName: 'Age__c', type: 'number' },
            		{ type: 'action', typeAttributes: { rowActions: actions } }
             ]);
                }
			}
            component.set('v.showSpinner', false);
        });
        $A.enqueueAction(action);
    },
    
    
    fetchPickListVal: function(component, fieldName, elementId) {
        this.showSpinner(component);
        var action = component.get('c.getselectOptions');
        action.setParams({
            objObject: component.get('v.pricingMatrix'),
            fld: fieldName
        });
        var opts = [];
        action.setCallback(this, function(response) {
            if (response.getState() == 'SUCCESS') {
                let maxvalue = Number(component.get('v.selectedMainMemberCoverFromFlow'));
                console.log('Max value '+maxvalue);
                var allValues = response.getReturnValue();
                if (allValues != undefined && allValues.length > 0) {
                    opts.push({
                        class: 'optionClass',
                        label: '--- None ---',
                        value: ''
                    });
                }
                for (var i = 0; i < allValues.length; i++) {
                    if(elementId == 'flexiFuneralCover') {
                        if(allValues[i] == maxvalue) { //if(allValues[i] <= maxvalue) {changed by pranav on 01-06-2021
                            opts.push({
                                class: 'optionClass',
                                label: allValues[i],
                                value: allValues[i]
                            });
                        }
                    } else {
                        opts.push({
                            class: 'optionClass',
                            label: allValues[i],
                            value: allValues[i]
                        });
                    }
                }
                if (elementId == 'flexiFuneralCover') {
                    component.set('v.CoverOptions', opts);
                    console.log('opts spous'+JSON.stringify(opts));
                } else if (elementId == 'GroceryBenefitCover') {
                    component.set('v.GroceryBenefitCoverOptions', opts);
                } else if (elementId == 'funeralBenefit') {
                    component.set('v.FuneralBenefitCoverOptions', opts);
                }else if (elementId == 'unveilingBenefit') {
                    component.set('v.UnveilingBenefitCoverOptions', opts);
                }
                
                this.hideSpinner(component);
                
            }
        });
        $A.enqueueAction(action);
    },
    
    
    calculateTotal: function(component) {
		var coverPremium = component.get('v.CoverPremium');
		var GroceryBenefitPremium = component.get('v.GroceryBenefitPremium');
		var funeralFeePremium = component.get('v.AfterFuneralBenefitPremium');
		var UnveilingBenefitPremium = component.get('v.UnveilingBenefitPremium');

		var total =
			(Number(coverPremium) +
			Number(GroceryBenefitPremium) +
			Number(funeralFeePremium) +
			Number(UnveilingBenefitPremium)).toFixed(2);
		component.set('v.totalPremium', total);
		component.set('v.totalPremiumLbl', 'Total Premium : R' + total);
	},
    
    mapOpportunityLineItem: function(component,event) {
        
		var benefit = component.get('v.benefitMap');
        var partyData = component.get('v.data');
        var newlst = [];
        for(var i = 0; i < benefit.length; i++){
            for(var j = 0; j < partyData.length; j++){
                newlst.push({
        				Name: benefit[i].Name,
        				premium: benefit[i].premium,
                        SumInsured: benefit[i].SumInsured,
                    	OppPartyId : partyData[j].Id
    		});
          }
        }
        console.log('newlst',newlst);
        component.set('v.lineItemMap',newlst);
        this.retrieveQuoteData(component);
	},

 	calculatePremium: function(component, rate, discount,sumInsured,sumSource) {
        
		var label = '';
        var premium = '';
        console.log('rate',rate);
        console.log('discount',discount);
        console.log('sumInsured',sumInsured);
        console.log('sumSource',sumSource);
        var total = (((sumInsured * rate) - ((discount * sumInsured * rate)/100))/1000);
        console.log('total',total);
        if(sumSource === 'flexiFuneralCover'){
            component.set('v.CoverPremium', total.toFixed(2));
			component.set('v.CoverPremiumLbl',  'Premium : R' + total.toFixed(2));
            label = 'Flexi Funeral';
            premium = total.toFixed(2);
        }	
        else if(sumSource == 'GroceryBenefitSelect'){
            component.set('v.GroceryBenefitPremium', (Number(total)*12).toFixed(2));
		    component.set('v.GroceryBenefitPremiumLbl', 'Premium : R' + (Number(total)*12).toFixed(2));
            label = 'Grocery Benefit';
            premium = (Number(total)*12).toFixed(2);
        }
        else if(sumSource == 'afterfuneralSelect'){
            component.set('v.AfterFuneralBenefitPremium', total.toFixed(2));
			component.set('v.AfterFuneralBenefitPremiumLbl', 'Premium : R' + total.toFixed(2));
            label = 'After Funeral Benefit';
            premium = total.toFixed(2);
        }
        else if(sumSource == 'unveilingSelect'){
            component.set('v.UnveilingBenefitPremium', total.toFixed(2));
			component.set('v.UnveilingBenefitPremiumLbl', 'Premium : R' + total.toFixed(2));
            label = 'Unveiling Benefit';
            premium = total.toFixed(2);
        }
            var benefitDetails = {};
            benefitDetails.Name = label;
            benefitDetails.premium = premium;
            benefitDetails.SumInsured = sumInsured;
        	benefitDetails.OppPartyId = '';
            var newlst = [];
            var benefit = component.get('v.benefitMap');
            if(benefit.length > 0){
            	for (var i = 0; i < benefit.length; i++){
                    if(benefit[i].Name == label)
                    	 benefit.splice(i,1);
                }
        	}
            if(benefit[0] == undefined)
                newlst.push(benefitDetails);
            else{
                for (var i = 0; i < benefit.length; i++){
                	newlst[Number(i)+1] = benefit[i];
            	}
                newlst[0] = benefitDetails;  
           	}
            component.set('v.benefitMap',newlst);
            this.calculateTotal(component);
	},

    retrieveQuoteData: function(component) {
		component.set('v.showSpinner', true);
		var oppId = component.get('v.recordId');
		var action = component.get('c.getQuoteLineItemsData');
		action.setParams({
			oppId: oppId,
            partyType: 'Spouse',
            productName: component.get('v.selectedProductNameFromFlow')
		});
		action.setCallback(this, function(response) {
			var state = response.getState();
            console.log('state',state);
			if (state === 'SUCCESS') {
                var returnValue = response.getReturnValue();
                console.log('returnValue',returnValue);
                if (returnValue == null){                  
                    var benefit = component.get('v.lineItemMap');
                    var newlst = [];
                    var totalPremium = 0;
                    for (i = 0; i < benefit.length; i++) {
                        newlst.push({
        						Benefit__c: benefit[i].Name,
        						Premium__c: benefit[i].premium,
                                Policy_Cover__c: benefit[i].SumInsured
    					});
                        totalPremium += (Number(benefit[i].premium));
                    }
                    component.set("v.response", newlst);
                    if(benefit.length > 0)
                    	component.set("v.isQuoteDone", false);
                    if(component.find("BACK") !== undefined && benefit.length > 0)
                    	component.find("BACK").set("v.disabled", true);
                    if(component.find("EditQuote") !== undefined && benefit.length > 0)
                    	component.find("EditQuote").set("v.disabled", true);
                    component.set("v.quoteTotal", totalPremium.toFixed(2));
                    if(component.find("newSpouseButton") !== undefined){
                        var spouseButton = component.find("newSpouseButton");
                        if(component.get("v.allBeneficiaries").length == 0)
                        	spouseButton.set("v.disabled", false);
                    }
                }
                 if (returnValue != null) {
                    component.set("v.response", returnValue);
                    component.set("v.showCommissionScreen", true);
                    component.set("v.showNewPanel", false);
                    component.set("v.showQuoteScreen", false);

                    if(component.find("newSpouseButton") !== undefined)
                    	component.find("newSpouseButton").set("v.disabled", true);
					var i;
					var totalMainLifePremium = 0;
					for (i = 0; i < returnValue.length; i++) {
						totalMainLifePremium += Number(returnValue[i].Premium__c);
					}
					component.set('v.quoteTotal', totalMainLifePremium.toFixed(2));
                    component.set('v.totalPremium', totalMainLifePremium.toFixed(2));
					component.set('v.totalPremiumLbl', 'Total Premium : R' + totalMainLifePremium.toFixed(2));
				} 
			}
			component.set('v.showSpinner', false);
		});
		$A.enqueueAction(action);
	},
    
    //Added by Kalyani to fetch Quote LineItems
    fetchquotelineitems : function(component,source) {
        component.set('v.showSpinner', true);
        var oppId = component.get('v.recordId');
        var opptyProductInt = component.get('v.selectedProductNameFromFlow');
        var action = component.get('c.getQuoteLineItemsData');
        action.setParams({
            oppId: oppId,
            partyType: 'Main Member',
            productName: component.get('v.selectedProductNameFromFlow')
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                if (response.getReturnValue() != null) {
                    var quoteLineItems = response.getReturnValue();
                    for (var i = 0; i < quoteLineItems.length; i++) {
                        if(quoteLineItems[i].Benefit__c == 'Grocery Benefit') {
                            component.find("GroceryBenefitCheckbox").set('v.disabled',false);
                            component.set('v.MainMemberGroceryBenefitValue',quoteLineItems[i].Policy_Cover__c);
                            var opts = [];
                            opts.push({
                                class: 'optionClass',
                                label: '--- None ---',
                                value: ''
                            });
                            opts.push({
                                class: 'optionClass',
                                label: quoteLineItems[i].Policy_Cover__c,
                                value: quoteLineItems[i].Policy_Cover__c
                            });
                            component.set('v.GroceryBenefitCoverOptions', opts);
                        }
                        if(quoteLineItems[i].Benefit__c == 'Unveiling Benefit') {
                            component.find("UnveilingBenefitCheckbox").set('v.disabled',false);
                        }
                        if(quoteLineItems[i].Benefit__c == 'After Funeral Benefit') {
                            component.find("AfterfuneralBenefitCheckbox").set('v.disabled',false);
                        }
                    }
                }
                if(source == 'editquote') {
                    this.getExistingQuote(component);
                }
            }
            component.set('v.showSpinner', false);
        });
        $A.enqueueAction(action);
    },

    getExistingQuote: function(component) {
        
		component.set('v.showSpinner', true);
        var oppId = component.get('v.recordId');
		var opptyRecordType = component.get('v.opptyRecordType'); 
        var opptyProductInt = component.get('v.selectedProductNameFromFlow');
		var action = component.get('c.getQuoteLineItemsData');
		action.setParams({
			oppId: oppId,
            partyType: 'Spouse',
            productName: component.get('v.selectedProductNameFromFlow')
		});
		action.setCallback(this, function(a) {
			var state = a.getState();
			if (state === 'SUCCESS') {
				if (a.getReturnValue() != null) {
					var quoteLineItems = a.getReturnValue();
                    component.set('v.quoteLineItems', quoteLineItems);
                    var newlst = [];
                    var totalQuote ;
                    var benefit = component.get('v.benefitMap');
					var i;
					for (i = 0; i < quoteLineItems.length; i++) {
                     if(opptyRecordType === 'Direct Delivery Sales Opportunity'){
                         newlst.push({
        						Name: quoteLineItems[i].Benefit__c,
        						premium: quoteLineItems[i].Premium__c,
                                SumInsured: quoteLineItems[i].Policy_Cover__c,
                             	OppPartyId: quoteLineItems[i].OpportunityPartyId__c
    						});
                         totalQuote += Number(quoteLineItems[i].Premium__c);
 						if (quoteLineItems[i].Benefit__c == 'Flexi Funeral') {
                            component.set('v.selectedCoverValue',quoteLineItems[i].Policy_Cover__c);
                            component.set('v.CoverPremium',quoteLineItems[i].Premium__c);
                            component.set('v.CoverPremiumLbl',  'Premium : R' + quoteLineItems[i].Premium__c);
                        }
                        else if(quoteLineItems[i].Benefit__c == 'Grocery Benefit'){
                            component.set('v.isGroceryBenefitSelected',true);
                            component.find('GroceryBenefitSelect').set('v.disabled', false);
                            component.set('v.selectedGroceryBenefitCoverValue',quoteLineItems[i].Policy_Cover__c);
                            component.set('v.GroceryBenefitPremium',quoteLineItems[i].Premium__c);
                            component.set('v.GroceryBenefitPremiumLbl',  'Premium : R' + quoteLineItems[i].Premium__c);
						}
						else if(quoteLineItems[i].Benefit__c == 'Unveiling Benefit'){
                            component.set('v.isUnveilingBenefitSelected',true);
                            component.find('unveilingSelect').set('v.disabled', false);
                            component.set('v.selectedUnveilingBenefitCoverValue',quoteLineItems[i].Policy_Cover__c);
                            component.set('v.UnveilingBenefitPremium',quoteLineItems[i].Premium__c);
                            component.set('v.UnveilingBenefitPremiumLbl',  'Premium : R' + quoteLineItems[i].Premium__c);
						}
                		else if(quoteLineItems[i].Benefit__c == 'After Funeral Benefit'){
                            component.set('v.isFuneralBenefitSelected',true);
                            component.find('afterfuneralSelect').set('v.disabled', false);
                            component.set('v.selectedFuneralBenefitCoverValue',quoteLineItems[i].Policy_Cover__c);
                            component.set('v.AfterFuneralBenefitPremium',quoteLineItems[i].Premium__c);
                            component.set('v.AfterFuneralBenefitPremiumLbl',  'Premium : R' + quoteLineItems[i].Premium__c);
						}
                      }
					}
					component.set('v.benefitMap',newlst);
                    component.set('v.quoteTotal', totalQuote.toFixed(2));
				}
			}
			component.set('v.showSpinner', false);
		});
		$A.enqueueAction(action);
	},
    
    updateSpouse: function(component, event) {
        
         this.mapOpportunityLineItem(component, event);
         if(component.get('v.opptyRecordType') == 'Direct Delivery Sales Opportunity'){
            //if(component.get("v.spouse.Age_As_Number__c") < 18 || component.get("v.spouse.Age_As_Number__c") > 70) {
             if(component.get("v.spouseAge") < 18 || component.get("v.spouseAge") > 70) {
                allValid = false; 
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Spouse Age should be in between 18 and 70.",
                    "type":"error"
                });
                toastEvent.fire();
            }
        }
                var oppParty = component.get("v.spouse");
                var oppPartyId = component.get("v.spouse.Id"); 
                var oppId = component.get("v.recordId");
                var action = component.get("c.updateOpportunityParty");
                action.setParams({
                    "oppParty": oppParty,
                    "oppId": oppId,
                    "oppPartyId": oppPartyId,
                    "isAlsoBeneficiaryUpdate": component.get("v.isAlsoBeneficiaryUpdate")

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
                        this.createNewQuote(component);
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
                    $A.get('e.force:refreshView').fire();

					var a = component.get('c.doInit');
					$A.enqueueAction(a);
                });
                $A.enqueueAction(action)
    },
    
	createNewQuote: function(component) {
		
		if (component.get('v.totalPremium') !== 0) {
			this.showSpinner(component);
            
			var oppId = component.get('v.recordId');
            var benefit = component.get('v.lineItemMap');
            console.log('benefit',benefit);
			var action = component.get('c.createDDQuote');
            
			action.setParams({
				oppId: oppId,
				totalPremium: component.get('v.totalPremium').toString(),
				product: component.get('v.selectedProductNameFromFlow'),
                lineItems: JSON.stringify(benefit),
                partyType: 'Spouse',
			});
			action.setCallback(this, function(a) {
				var state = a.getState();
				if (state === 'SUCCESS') {
					// show success notification
					var toastEvent = $A.get('e.force:showToast');
					toastEvent.setParams({
						title: 'Success!',
						message: 'Quote Successfully Created',
						type: 'success'
					});
					toastEvent.fire();
					component.set('v.showCommissionScreen', true);
                    var editQuote=component.get("v.showQuoteEdit");
                    if(editQuote ==true){
                        //showQuoteEditEvent
                        component.set("v.updateQuoteScreenClose",false);
                        
                    }else{
                        var navigate = component.get("v.navigateFlow");
                        navigate("NEXT");
                    }
                    
				} else {
					// show error notification
					var toastEvent = $A.get('e.force:showToast');
					toastEvent.setParams({
						title: 'Error!',
						message: 'Error creating new quote. Please try again!',
						type: 'error',
						mode: 'sticky'
					});
					toastEvent.fire();
				}
				//this.retrieveQuoteData(component);
				this.hideSpinner(component);
				$A.get('e.force:refreshView').fire();

				var a = component.get('c.doInit');
				$A.enqueueAction(a);
			});
			$A.enqueueAction(action);
		}
	},
    
    updateLineItem: function(component) {
         
        var coverValue = component.get('v.selectedCoverValue');
        var groceryValue = component.get('v.selectedGroceryBenefitCoverValue');
        var funeralValue = component.get('v.selectedFuneralBenefitCoverValue');
        console.log('funeralValue',funeralValue);
        var unveilingValue = component.get('v.selectedUnveilingBenefitCoverValue');
        if(coverValue == 15000 && component.get('v.MainMemberPremiumRate') != null)
            this.calculatePremium(component, component.get('v.MainMemberPremiumRate'), 0 , coverValue, 'flexiFuneralCover');
        else
            this.getPremiumMatrices(component, coverValue, 'Flexi Funeral Discount','flexiFuneralCover');
        
        if(groceryValue == 1000 && component.get('v.MainMemberGroceryRate') != '')
            this.calculatePremium(component, component.get('v.MainMemberGroceryRate'), 0 , groceryValue, 'GroceryBenefitSelect');
        else
            this.getPremiumMatrices(component, groceryValue, 'Flexi Funeral Discount','GroceryBenefitSelect');
        
        if(funeralValue != '' && component.get('v.MainMemberFuneralRate') != '')
            this.calculatePremium(component, component.get('v.MainMemberFuneralRate'), 0 , funeralValue, 'afterfuneralSelect');
        
        if(unveilingValue != '' && component.get('v.MainMemberUnveilingRate') != '')
            this.calculatePremium(component, component.get('v.MainMemberUnveilingRate'), 0 , unveilingValue, 'unveilingSelect');
	},

    
	getPremiumMatrices: function(component, sumInsured, product, sumSource) {
        
		component.set('v.showSpinner', true);
		var oppId = component.get('v.recordId');
		var action = component.get('c.getPricingMatrix');
		action.setParams({
			oppId: oppId,
			sumInsured: sumInsured,
			product: product
		});
		action.setCallback(this, function(a) {
			var state = a.getState();
			if (state === 'SUCCESS') {
                var pricingMatrix = a.getReturnValue();
                console.log('pricingMatrix',pricingMatrix);
                for(var k in pricingMatrix){
                if(product == 'Flexi Funeral Rate'){
                    if(k == 'Spouse_Rate__c')
                     	component.set('v.MainMemberPremiumRate', pricingMatrix.Spouse_Rate__c);
                    if(k == 'Grocery_Benefit_Rate__c')
                     	component.set('v.MainMemberGroceryRate', pricingMatrix.Grocery_Benefit_Rate__c);
                    if(k == 'Unveiling_Benefit_Rate__c')
                     	component.set('v.MainMemberUnveilingRate', pricingMatrix.Unveiling_Benefit_Rate__c);
                    if(k == 'After_Burial_Benefit_Rate__c')
                     	component.set('v.MainMemberFuneralRate', pricingMatrix.After_Burial_Benefit_Rate__c);
                }
                else if(product == 'Flexi Funeral Discount'){
                    if(sumSource == 'flexiFuneralCover'){
                        if(k == 'FF_Spouse_Discount_Rate__c'){
                        	component.set('v.MainMemberDiscountRate', pricingMatrix.FF_Spouse_Discount_Rate__c);
                        	this.calculatePremium(component, component.get('v.MainMemberPremiumRate'),pricingMatrix.FF_Spouse_Discount_Rate__c, sumInsured, sumSource);
                        }
                     }
                    if(sumSource == 'GroceryBenefitSelect'){
                        if(k == 'FF_Grocery_Benefit_Discount_Rate__c'){
                        	component.set('v.MainMemberGroceryDiscountRate', pricingMatrix.FF_Grocery_Benefit_Discount_Rate__c);
                        	this.calculatePremium(component, component.get('v.MainMemberGroceryRate'), pricingMatrix.FF_Grocery_Benefit_Discount_Rate__c, sumInsured, sumSource);
                        }
                     }
                  }
              }
                console.log('response',component.get('v.response'));
                if(component.get('v.response').length > 0)
                    this.updateLineItem(component);
			}
			component.set('v.showSpinner', false);
		});
		$A.enqueueAction(action);
        
	},
    
	setHelpTextAfterFuneral: function(component) {
    	    var afterFuneralBenefitHelp = $A.get("$Label.c.DD_After_Funeral_Benefit");
            component.set('v.afterFuneralBenefitHelpText', afterFuneralBenefitHelp);
    },
    
    setHelpTextGrocery: function(component) {
          var groceryBenefitHelp = $A.get("$Label.c.DD_Grocery_Benefit");
          component.set('v.groceryBenefitHelpText', groceryBenefitHelp);
    },
    
    setHelpTextUnveiling: function(component) {
          var unveilingBenefitHelp = $A.get("$Label.c.DD_Unveiling_Benefit");
          component.set('v.unveilingBenefitHelpText', unveilingBenefitHelp);
    },
    
    setHelpTextWaiver: function(component) {
		  var waiverBenefitHelp = $A.get("$Label.c.DD_Waiver_of_Premium");
          component.set('v.waiverBenefitHelpText', waiverBenefitHelp);
    }
    
})