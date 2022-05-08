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
                component.set("v.allBeneficiaries", response.getReturnValue());
                console.log('data@@'+response.getReturnValue().length);
                if(response.getReturnValue().length >= 1){
                   if(component.get("v.recordtype") == 'Direct Delivery Sales Opportunity'){
						var partyData = component.get("v.data");
                       	var newlst = [];
                        var extendedlst = [];
                       	for (var i = 0; i < partyData.length; i++) {
                            if(partyData[i].Relationship__c == component.get("v.dependantTypeFromFlow"))
                                newlst.push(partyData[i]); 
                            else if(partyData[i].Relationship__c != 'Child' && partyData[i].Relationship__c != 'Spouse' && partyData[i].Party_Type__c != 'Spouse' && partyData[i].Party_Type__c != 'Beneficiary')
                                extendedlst.push(partyData[i]);
                        }
                       console.log('extendedlst len=='+extendedlst.length);
                       if(component.get("v.dependantTypeFromFlow") == 'Child') {
                           component.set("v.data", newlst);
                           
                            if(newlst.length >= 10) {
                               component.find("newDependantButton").set("v.disabled", true);
                           }
                       }
                       else {
                           component.set("v.data", extendedlst);
                           if(extendedlst.length >= 8) {
                               component.find("newDependantButton").set("v.disabled", true);
                           }
                       }
                   }    
                }
                var beneficiaries = component.get("v.allBeneficiaries");
                var totalSplit = 0;
                for (var i = 0; i < beneficiaries.length; i++) {
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
    
    //Added by Kalyani for Direct Delivery Sales Opportunity 
    fetchrecordtype : function (component) {
        var action = component.get("c.getOpportunitydata");
        action.setParams({
            "oppId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var opportunities = response.getReturnValue();
                component.set("v.recordtype",opportunities[0].Opportunity_Record_Type_Name__c);
                for(var k in opportunities[0]){
                        if(k == 'Product_Interest__c'){
                            var opptyProductInt = opportunities[0].Product_Interest__r.Product__c;
                        	component.set('v.opptyProductInt', opptyProductInt);
                        }
                	}
                if(opportunities[0].Opportunity_Record_Type_Name__c == 'Direct Delivery Sales Opportunity') {
                	this.fetchPickListVal(component, 'Flexi_Funeral_Cover__c');
                    if(component.get('v.dependantTypeFromFlow') == 'Extended Family Member') {
                        this.fetchextendedfamilyrelation(component);
                        component.find("newDependantButton").set('v.label','New Extended Family Member');
                    }
                    if(component.get('v.dependantTypeFromFlow') == 'Child')
                        component.find("newDependantButton").set('v.label','New Child');
                }
            }
            else {
                console.log("Failed with state: " + state);
            }
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
                console.log('respose=='+response.getReturnValue());
                if(response.getReturnValue() == true){
                    component.find("newDependantButton").set("v.disabled", false);
                }
                else{
                    component.find("newDependantButton").set("v.disabled", true);
                }
                if(component.get("v.recordtype") == 'Direct Delivery Sales Opportunity')
                      this.retrieveQuoteData(component);
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);
    },
    
    updateDependant : function(component) {
        var oppPartyId = component.get("v.updateRecordId");
        var action = component.get("c.getSingleParty");
        if(component.get("v.recordtype") == 'Direct Delivery Sales Opportunity'){
            var benefit = component.get('v.dependantMap');
        	var data = component.get("v.data");
            component.set("v.showUpdatePanel", true);
        }
        action.setParams({
            "oppPartyId": oppPartyId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('dependant',response.getReturnValue());
                component.set("v.dependant", response.getReturnValue());
                component.set("v.showUpdatePanel", true);
                component.set("v.currentSplit", component.get("v.dependant.Benefit_Split__c"));
                
                if(component.get("v.dependant.Party_Type__c").includes("Beneficiary")){
                    var chkBox = component.find("updateCheckbox");
                    chkBox.set("v.value", true);
                    component.set("v.isAlsoBeneficiaryUpdate", true);
                }
                else{
                    component.set("v.isAlsoBeneficiaryUpdate", false);
                }
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);
        //$A.get('e.force:refreshView').fire();
    },
    
    removeDependant: function (cmp, row) {
        var oppPartyId = cmp.get("v.updateRecordId");
        var action = cmp.get("c.removeOpportunityParty");
        var oppId = cmp.get('v.recordId');
        var dependantData = cmp.get('v.dependantMap');
        var newlst = [];

        action.setParams({
            "oppPartyId": oppPartyId
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state === "SUCCESS") {
                
                 if(cmp.get("v.recordtype") == 'Direct Delivery Sales Opportunity'){
                     
            			for(var j = 0; j < dependantData.length; j++){
							if(dependantData[j].Id != null || dependantData[j].Id != '')
                                newlst.push({
        							Name: cmp.get('v.selectedProductNameFromFlow'),
        							premium: dependantData[j].Premium,
                        			SumInsured: dependantData[j].SumAssured,
                    				OppPartyId : dependantData[j].Id
    						});
          				}
                	var action = cmp.get("c.removeDDQuote");
                
                	action.setParams({
            			"OpportunityPartyId": oppPartyId,
                    	"oppId": oppId,
						"totalPremium": '',
						"product": cmp.get('v.selectedProductNameFromFlow'),
                		"lineItems": JSON.stringify(newlst),
                		"partyType": cmp.get('v.dependantTypeFromFlow')
        			});
                    
                    action.setCallback(this, function(response) {
            		var state = response.getState();
            		if (state === "SUCCESS") {
                		//cmp.set('v.showCommissionScreen', false);
            		}
        		});
        			$A.enqueueAction(action);
                    cmp.set('v.showCommissionScreen', true);
             	}
                
                // show success notification
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "Dependant Successfully Removed",
                    "type":"success"
                });
                toastEvent.fire();
                
                //Commented by Kalyani to Remove from view
                if(cmp.get("v.recordtype") != 'Direct Delivery Sales Opportunity'){
                	var rows = cmp.get('v.data');
                	var rowIndex = rows.indexOf(row);
        
                	rows.splice(rowIndex, 1);
                	cmp.set('v.data', rows);
                }
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
        });
        $A.enqueueAction(action);
        //$A.get('e.force:refreshView').fire();
    },
    
    //Added by Kalyani for Direct Delivery Sales Opportunity     
    fetchPickListVal: function(component, fieldName) {
		this.showSpinner(component);

		var action = component.get('c.getselectOptions');
		action.setParams({
			objObject: component.get('v.pricingMatrix'),
			fld: fieldName
		});
		var opts = [];
		action.setCallback(this, function(response) {
			if (response.getState() == 'SUCCESS') {
                let maxvalue = Number(component.get('v.selectedMainMemberCoverFromFlow')) <= 50000 ? Number(component.get('v.selectedMainMemberCoverFromFlow')) : 50000 ;
                var allValues = response.getReturnValue()
				if (allValues != undefined && allValues.length > 0) {
					opts.push({
						class: 'optionClass',
						label: '--- None ---',
						value: ''
					});
				}
				for (var i = 0; i < allValues.length; i++) {
                    if(allValues[i] <= maxvalue) {
                        opts.push({
                            class: 'optionClass',
                            label: allValues[i],
                            value: allValues[i]
                        });
                    }
                }
				component.set('v.CoverOptions', opts);
				
				this.hideSpinner(component);
			}
		});
		$A.enqueueAction(action);
	},
    
    calculateTotal: function(component) {
		var coverPremium = component.get('v.CoverPremium');
		var total =(Number(coverPremium)).toFixed(2);
		component.set('v.totalPremium', total);
		component.set('v.totalPremiumLbl', 'Total Premium : R' + total);
	},
        
    mapDependant: function(component,event) {
        var self = this;  //Added by Kalyani
		var benefit = component.get('v.dependantMap');
        var data = component.get("v.data");
        var newlst = [];
        var partylst = [];
        if(component.get('v.dependant.Relationship__c') == undefined)
            component.set('v.dependant.Relationship__c','Child');
       
        if(data[0] == undefined){
            partylst.push({
        			First_Name__c: component.get('v.dependant.First_Name__c'),
        			Last_Name__c: component.get('v.dependant.Last_Name__c'),
                	RSA_ID_Number__c: component.get('v.dependant.RSA_ID_Number__c'),
                    Age__c: component.get('v.dependentAge'),
                	Date_of_Birth__c: component.get('v.dependant.Date_of_Birth__c'),
                	Relationship__c: component.get('v.dependant.Relationship__c'),
                	Gender__c: component.get('v.dependant.Gender__c'),
                	SumAssured: component.get('v.selectedCoverValue'),
                	Premium: component.get('v.CoverPremium')
    		});    
        }
        else{
            for (var i = 0; i < data.length; i++) {
                partylst[Number(i)+1] = data[i];      
            }
            	partylst[0] = {	First_Name__c: component.get('v.dependant.First_Name__c'),
        						Last_Name__c: component.get('v.dependant.Last_Name__c'),
                                RSA_ID_Number__c: component.get('v.dependant.RSA_ID_Number__c'),
                    			Age__c: component.get('v.dependentAge'),
                    			Date_of_Birth__c: component.get('v.dependant.Date_of_Birth__c'),
                                Gender__c: component.get('v.dependant.Gender__c'),
                				Relationship__c: component.get('v.dependant.Relationship__c'),
                				SumAssured: component.get('v.selectedCoverValue'),
                				Premium: component.get('v.CoverPremium')
    						  };
        }
       if(benefit[0] == undefined){
                newlst.push({
        			First_Name__c: component.get('v.dependant.First_Name__c'),
        			Last_Name__c: component.get('v.dependant.Last_Name__c'),
                	RSA_ID_Number__c: component.get('v.dependant.RSA_ID_Number__c'),
                    //Age_As_Number__c: component.get('v.dependant.Age_As_Number__c'),
                    Date_of_Birth__c: component.get('v.dependant.Date_of_Birth__c'),
                	Relationship__c: component.get('v.dependant.Relationship__c'),
                	Gender__c: component.get('v.dependant.Gender__c'),
                	Party_Type__c: 'Dependant',
                    Id: component.get('v.dependant.Id'),
                	Opportunity__c: component.get('v.recordId')
    			});
           component.set('v.currentdependant',newlst);
            }
        	else{
            	for (var i = 0; i < benefit.length; i++) {
                    newlst[Number(i)+1] = benefit[i];
                }
                newlst[0] = {	First_Name__c: component.get('v.dependant.First_Name__c'),
        						Last_Name__c: component.get('v.dependant.Last_Name__c'),
                				RSA_ID_Number__c: component.get('v.dependant.RSA_ID_Number__c'),
                    			//Age_As_Number__c: component.get('v.dependant.Age_As_Number__c'),
                    			Date_of_Birth__c: component.get('v.dependant.Date_of_Birth__c'),
                				Relationship__c: component.get('v.dependant.Relationship__c'),
                				Gender__c: component.get('v.dependant.Gender__c'),
                				Party_Type__c: 'Dependant',
                             	Id: component.get('v.dependant.Id'),
                             	Opportunity__c: component.get('v.recordId')
    						 };
                component.set('v.currentdependant',newlst[0]);
        	}
        console.log('partylst',partylst);
        console.log('newlst',newlst);
        component.set('v.data',partylst);
        component.set('v.dependantMap',newlst);
        component.set("v.showNewPanel", false);
		component.set("v.dependant",{});
        component.set("v.selectedCoverValue",'');
        component.set("v.CoverPremiumLbl",'Premium : R0.00');
        if(component.get('v.dependantTypeFromFlow') == 'Extended Family Member' && component.get('v.data').length >= 8) {
            component.find("newDependantButton").set("v.disabled", true);
        }
        
        else if(component.get('v.dependantTypeFromFlow') == 'Child' && component.get('v.data').length >= 10) {
            component.find("newDependantButton").set("v.disabled", true);
        }
        
        //self.createNewQuote(component);  //Added by Kalyani
	},
    
    	createNewQuote: function(component) {
		
			this.showSpinner(component);
			var oppId = component.get('v.recordId');
            var dependantData = component.get('v.data');
        	var dependantObject = component.get('v.dependantMap');
            var newlst = [];
            console.log('dependantObject==',JSON.stringify(dependantObject));
            console.log('dependantData==',JSON.stringify(dependantData));
            
        	var action = component.get("c.createOpportunityParties");
        	action.setParams({
                    	"oppPartyList": dependantObject,
                    	//"oppPartyList": component.get('v.currentdependant'),
                    	"oppId": oppId
                	});
        	action.setCallback(this, function(response) {
                
                 var state = response.getState();
                 console.log('state',state);
                 var oppParties = response.getReturnValue();
                 console.log('oppParties',oppParties);
                
                 if (state === "SUCCESS") {
                     
                    this.showSpinner(component);
					var action = component.get('c.createDDQuote');
                    
            		for(var i = 0; i < oppParties.length; i++){
            			for(var j = 0; j < dependantData.length; j++){
                            if(oppParties[i].First_Name__c == dependantData[j].First_Name__c && oppParties[i].Last_Name__c == dependantData[j].Last_Name__c 
                               && oppParties[i].Date_of_Birth__c == dependantData[j].Date_of_Birth__c) 
                				newlst.push({
                                    Name: component.get('v.selectedProductNameFromFlow'),
                                    premium: dependantData[j].Premium,
                                    SumInsured: dependantData[j].SumAssured,
                                    OppPartyId : oppParties[i].Id
                                });
                            
                            
                            else if(dependantData[j].Id != undefined || dependantData[j].Id != null)  
                                newlst.push({
                                    Name: component.get('v.selectedProductNameFromFlow'),
                                    premium: dependantData[j].Premium,
                                    SumInsured: dependantData[j].SumAssured,
                                    OppPartyId : dependantData[j].Id
                                });
                            
          				}
        			}
                    console.log('newlst=='+JSON.stringify(newlst)); 
					action.setParams({
						oppId: oppId,
						totalPremium: '',
						product: component.get('v.selectedProductNameFromFlow'),
                		lineItems: JSON.stringify(newlst),
                		partyType: component.get('v.dependantTypeFromFlow')
					});
                     
						action.setCallback(this, function(response) {
						var state = response.getState();
						if (state === 'SUCCESS') {
							// show success notification
							var toastEvent = $A.get('e.force:showToast');
							toastEvent.setParams({
							title: 'Success!',
							message: 'Quote Successfully Created',
							type: 'success'
							});
							toastEvent.fire();     
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
					//this.hideSpinner(component);
					//$A.get('e.force:refreshView').fire();

					var a = component.get('c.doInit');
					$A.enqueueAction(a);
                            
				});
				$A.enqueueAction(action);
              }
           });
		$A.enqueueAction(action);
        //this.hideSpinner(component);
	},

    
    retrieveQuoteData: function(component) {
        
		component.set('v.showSpinner', true);
		var oppId = component.get('v.recordId');
		var action = component.get('c.getQuoteLineItemsData');
		action.setParams({
			oppId: oppId,
            partyType: component.get('v.dependantTypeFromFlow'),
            productName: component.get('v.selectedProductNameFromFlow')
		});
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state === 'SUCCESS') {
                var returnValue = response.getReturnValue();
                console.log('returnValue=='+JSON.stringify(returnValue));
                
                if (returnValue == null){
                    if(component.find("newDependantButton") !== undefined)
                    	component.find("newDependantButton").set("v.disabled", false);
                    var benefit = component.get('v.lineItemMap');
                    var newlst = [];
                    var totalPremium = 0;
                    for (i = 0; i < benefit.length; i++) {
                        newlst.push({
        						Benefit__c: benefit[i].Name,
        						Premium__c: benefit[i].premium,
                                Policy_Cover__c: benefit[i].SumInsured
    					});
                        totalPremium += (Number(benefit[i].premium)).toFixed(2);
                    }
                    component.set("v.response", newlst);
                    if(benefit.length > 0)
                    	component.set("v.isQuoteDone", false);
                    if(component.find("BACK") !== undefined)
                    	component.find("BACK").set("v.disabled", false);
                    component.set("v.quoteTotal", totalPremium);
                }
                 if (returnValue != null) {
                     
                    component.set("v.response", returnValue);
                    component.set("v.isQuoteDone", true);
                     
                    var dependantData = component.get('v.data');
                     console.log('dependantdata=='+JSON.stringify(dependantData));
                    component.set("v.showCommissionScreen", true);
                     
                     if(component.find("newDependantButton") !== undefined){
                         if(component.get('v.dependantTypeFromFlow') == 'Extended Family Member' && dependantData.length >= 8) {
                             component.find("newDependantButton").set("v.disabled", true);
                             
                         } else if(component.get('v.dependantTypeFromFlow') == 'Child' && dependantData.length >= 10) {
                             component.find("newDependantButton").set("v.disabled", true);
                         } else {
                             component.find("newDependantButton").set("v.disabled", false);
                         }
                     }
					var i;
					var totalMainLifePremium = 0;
					for (i = 0; i < returnValue.length; i++) {
						totalMainLifePremium += Number(returnValue[i].Premium__c);
                        for (var j = 0; j < dependantData.length; j++) {
                            console.log('dependantDataId=='+dependantData[j].Id+'OpportunityPartyId=='+returnValue[i].OpportunityPartyId__c);
                            if(dependantData[j].Id == returnValue[i].OpportunityPartyId__c){
                                dependantData[j].SumAssured = returnValue[i].Policy_Cover__c;
                                dependantData[j].Premium = returnValue[i].Premium__c;
                            }
						}
                    }
					component.set('v.quoteTotal', totalMainLifePremium.toFixed(2));
                    component.set('v.data', dependantData);
                    console.log('data===='+JSON.stringify(component.get('v.data')));
					
				} 
			}
			component.set('v.showSpinner', false);
		});
		$A.enqueueAction(action);
	},
    
     	calculatePremium: function(component, rate, discount,sumInsured,sumSource) {
        
        	var total = (((sumInsured * rate) - ((discount * sumInsured * rate)/100))/1000).toFixed(2);
            console.log('total',total);
        	if(sumSource === 'flexiFuneralCover'){
            	component.set('v.CoverPremium', total);
				component.set('v.CoverPremiumLbl',  'Premium : R' + total);
        	}	
            	this.calculateTotal(component);
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
                    console.log('coverValue',component.get('v.selectedCoverValue'));
                	for(var k in pricingMatrix){
                	if(product == 'Flexi Funeral Rate'){
                    	if(k == 'Child_Rate__c')
                     		component.set('v.MainMemberPremiumRate', pricingMatrix.Child_Rate__c);
                        else if(k == 'Extended_Member_Rate__c')
                            component.set('v.MainMemberPremiumRate', pricingMatrix.Extended_Member_Rate__c);
                	}
              	}
                    if(component.get('v.selectedCoverValue') != null && component.get('v.MainMemberPremiumRate') != null){
                        if(component.get('v.selectedCoverValue') == 15000)
                			this.calculatePremium(component, component.get('v.MainMemberPremiumRate'), 0 , component.get('v.selectedCoverValue'), 'flexiFuneralCover');
            			else
                			this.calculatePremium(component, component.get('v.MainMemberPremiumRate'), 18.61646 , component.get('v.selectedCoverValue'), 'flexiFuneralCover');
                    }
				}
				component.set('v.showSpinner', false);
			});
			$A.enqueueAction(action);
		},
    
    fetchextendedfamilyrelation : function (component) {
    	this.showSpinner(component);
        
      	var action = component.get('c.getselectOptions');
		action.setParams({
			objObject: component.get('v.dependant'),
			fld: 'Relationship__c'
		});
		var opts = [];
		//var action = component.get('c.getextendfamilyrelation');
		//var opts = [];
		action.setCallback(this, function(response) {
			if (response.getState() == 'SUCCESS') {
                var unwantedlist = ['Main Member','Unknown','Spouse','Child','Daughter','Son','Husband','Wife','Parent','Gardener or Caretaker','Chauffer'];
				var allValues = response.getReturnValue();
                console.log('allValues',allValues);
				if (allValues != undefined && allValues.length > 0) {
					opts.push({
						class: 'optionClass',
						label: '--- None ---',
						value: ''
					});
				}
				for (var i = 0; i < allValues.length; i++) {
                    if(!unwantedlist.includes(allValues[i])) {
                        opts.push({
                            class: 'optionClass',
                            label: allValues[i],
                            value: allValues[i]
                        });
                    }
				}
				component.set('v.extendedfamilyOptions', opts);
				
				this.hideSpinner(component);
			}
		});
		$A.enqueueAction(action);
	    
    },

    showSpinner: function (component) {
        var spinner = component.find("TheSpinner");
        $A.util.removeClass(spinner, "slds-hide");
    },
    hideSpinner: function (component) {
        var spinner = component.find("TheSpinner");
        $A.util.addClass(spinner, "slds-hide");
    }
})