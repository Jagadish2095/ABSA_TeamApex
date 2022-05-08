({
    doInit: function(component, event, helper)
    {

        component.set('v.isLoading', true);
        var oppId = component.get('v.selectedOppIdFromFlow');
        var product = component.get('v.selectedProductFromFlow');
        
        if(oppId === undefined)
        {
            oppId = component.get('v.recordId');
        }
        
        console.log("oppId " + oppId);
        
        if(oppId != undefined)
        {
            var action = component.get('c.getOpportunityDetails');
            action.setParams({
                'opportunityId' : oppId,
                'productName' : product
            });
            
            action.setCallback(this, function(response){
                var state = response.getState();
                
                console.log("STATE " + state);
                
                if(state === 'SUCCESS'){
                    var returnValue = response.getReturnValue();
                    if(returnValue != undefined
                       && returnValue.length > 0)
                    {
                        
                        let premiumTotal = 0;
                        let sumAssuredTotal = 0;
                        
                        let sumFlexiFuneral = 0;
                        let sumRoadCover = 0;
                        let sumHealthAssistance = 0;
                        let sumLawForYou = 0;
                        let sumUltimateProtector = 0;
                        
                        let flexiFuneralId;
                        let roadCoverId;
                        let healthAssistanceId;
                        let lawForYouId;
                        let ultimateProtectorId;
                        
                        returnValue.forEach( row => {
                            
                            if(row.partyType === component.get('v.productRoadCover'))
                            {
								sumRoadCover += row.totalPremium;
                            	roadCoverId = row.partyName;
                        	}
                              
                            if(row.partyType === component.get('v.productHealthAssistance'))
                            {
								sumHealthAssistance += row.totalPremium;
                                healthAssistanceId = row.partyName;
                        	}
                        
                            if(row.partyType === component.get('v.productLawForYou'))
                            {
								sumLawForYou += row.totalPremium;
                            	lawForYouId = row.partyName;
                        	}
                              
                            if(row.partyType === component.get('v.productUltimateProtector'))
                            {
								sumUltimateProtector += row.totalPremium;
                                ultimateProtectorId = row.partyName;
                        	}
                        
                            if(row.productName === component.get('v.productFlexiFuneral'))
                            {
								sumFlexiFuneral += row.totalPremium;
                                flexiFuneralId = row.partyName;
                                console.log('flexiFuneralId ' + flexiFuneralId);
                                
                                /*
                                if(row.opportunityParty != undefined)
                                {
                                    flexiFuneralId = row.opportunityParty.Id;
                                }*/
                        	}
                            
                            premiumTotal += row.totalPremium;
                            sumAssuredTotal += row.sumAssured;
                        });
                            
                        component.set('v.columnsDependants', [
                            { label: 'FIRST NAME', fieldName: 'First_Name__c', type: 'text' },
                            { label: 'LAST NAME', fieldName: 'Last_Name__c', type: 'text' },
                            { label: 'RELATIONSHIP', fieldName: 'Relationship__c', type: 'text' },
                            { label: 'ID NUMBER', fieldName: 'RSA_ID_Number__c', type: 'text' },
                            { label: 'GENDER', fieldName: 'Gender__c', type: 'text' },
                            { label: 'AGE', fieldName: 'Age__c', type: 'number' }
                        ]);
                        
                        helper.fetchDependantData(component);
                        
                        component.set('v.isLoading', false);
						component.set("v.showQuoteDetails", true);
                        component.set("v.response", returnValue);
                        component.set("v.grandTotalPremium", premiumTotal);
                        component.set("v.grandTotalSumAssured", sumAssuredTotal);
                    
                        component.set("v.grandTotalHealthAssistance", sumHealthAssistance);
                        component.set("v.grandTotalUltimateProtector", sumUltimateProtector);
                        component.set("v.grandTotalRoadCover", sumRoadCover);
                        component.set("v.grandTotalLawForYou", sumLawForYou);
                        component.set("v.grandTotalFlexiFuneral", sumFlexiFuneral);
                    
                        component.set("v.productRoadCoverUnique", roadCoverId);
                        component.set("v.productUltimateProtectorUnique", ultimateProtectorId);
                        component.set("v.productLawForYouUnique", lawForYouId);
                        component.set("v.productHealthAssistanceUnique", healthAssistanceId);
                        component.set("v.productFlexiFuneralUnique", flexiFuneralId);
                    }
                    else
                    {
                        component.set("v.isLoading", false);
                        component.set("v.showQuoteDetails", false);
                    }
                }
				else
				{
					component.set("v.isLoading", false);
					component.set("v.showQuoteDetails", false);
				}
            });
            $A.enqueueAction(action);
        }
        else
        {
            var message = 'No Quote Record Found';
            helper.showToast('error', 'Error!', message);
            component.set('v.isLoading', false);
			component.set("v.showQuoteDetails", false);    
        }
        
        if(product === undefined || product === '')
        {
			component.set("v.isQuoteSummary", false);
        }
        else
        {
			component.set("v.isQuoteSummary", true);
        }

    },
    editRow: function(component, event, helper)
	{
        console.log("Inside Edit Row");
        
        var oppId = component.get('v.selectedOppIdFromFlow');
        
        if(oppId === undefined)
        {
            oppId = component.get('v.recordId');
        }
        
        console.log("Opportunity Id " + oppId);
        
        component.set("v.opportunityId", oppId);
        var items = component.get('v.response');
        
        for(var i=0 ;i<items.length ;i++){
            if(items[i].productName =='Flexi Funeral' && items[i].partyType == 'Main Member'){
                
            }
        }
        
        if(items != undefined
           && items.length > 0)
        {
            var selectedItem = event.currentTarget;
            var index = selectedItem.dataset.record;
            var memberDetails = items[index];
            
            if(memberDetails != undefined)
            {
                console.log("Inside Member Details");
                
                if(memberDetails.productName == 'Health Assistance'
                   || memberDetails.partyType == 'Health Assistance')
                {
                    component.set("v.selectedProduct",'Health Assistance');
                    component.set("v.showUpdateModal",true);
                }else if(memberDetails.productName == 'Road Cover'
                   || memberDetails.partyType == 'Road Cover')
                {
                    component.set("v.selectedProduct",'Road Cover');
                    component.set("v.showUpdateModal",true); 
                }else if(memberDetails.productName == 'Ultimate Protector'
                         || memberDetails.partyType == 'Ultimate Protector')
                {
                    component.set("v.selectedProduct",'Ultimate Protector');
                    component.set("v.showUpdateModal",true);
                }
                else if(memberDetails.productName == 'Law 4 u'
                         || memberDetails.partyType == 'Law 4 u')
                {
                    component.set("v.selectedProduct",'Law 4 u');
                    component.set("v.showUpdateModal",true);
                }else if(memberDetails.productName == 'AVAF Credit Life'
                         || memberDetails.partyType == 'AVAF Credit Life')
                {
                    component.set("v.selectedProduct",'AVAF Credit Life');
                    component.set("v.showUpdateModal",true);
                }else if(memberDetails.productName == 'Extended Cover'
                         || memberDetails.partyType == 'Extended Cover')
                {
                    component.set("v.selectedProduct",'Extended Cover');
                    component.set("v.showUpdateModal",true);
                } 
                else if(memberDetails.productName == 'Flexi Funeral' && memberDetails.partyType == 'Main Member' ){
                    component.set("v.selectedProduct",'Flexi Funeral');
                    component.set("v.selectedPartyType",'Main Member');
                    component.set("v.showUpdateModal",true);
                }else if(memberDetails.productName == 'Flexi Funeral' && memberDetails.partyType == 'Spouse' ){
                    for(var i=0 ;i<items.length ;i++){
                        if(items[i].productName =='Flexi Funeral' && items[i].partyType == 'Main Member'){
                            component.set("v.mainMemcover",items[i].sumAssured);
                        }
                    }
                    console.log('inside spouse');
                    component.set("v.selectedProduct",'Flexi Funeral');
                    component.set("v.selectedPartyType",'Spouse');
                    component.set("v.showUpdateModal",true);
                }else if(memberDetails.productName == 'Flexi Funeral' && memberDetails.partyType == 'Extended Family Member' ){
                    console.log('inside spouse');
                    component.set("v.selectedProduct",'Flexi Funeral');
                    component.set("v.selectedPartyType",'Extended Family Member');
                    component.set("v.showUpdateModal",true);
                }else if(memberDetails.productName == 'Flexi Funeral' && memberDetails.partyType == 'Child' ){
                    console.log('inside spouse');
                    component.set("v.selectedProduct",'Flexi Funeral');
                    component.set("v.selectedPartyType",'Child');
                    component.set("v.showUpdateModal",true);
                }
                
                console.log("memberDetails.productName " + memberDetails.productName);
            }
        }
    },
    closeConfirmation: function(component, event, helper) 
    {
        component.set("v.showUpdateModal", false);
    },
})