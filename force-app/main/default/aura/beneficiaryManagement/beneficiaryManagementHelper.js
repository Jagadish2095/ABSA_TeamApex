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
                var data = response.getReturnValue();
                console.log('data',data);
                console.log('component.get("v.ProductNameFromFlow")',component.get("v.ProductNameFromFlow"));
                    for (var i = 0; i < data.length; i++){
                        console.log('data[i].Beneficiary_Product__c',data[i].Beneficiary_Product__c);
                        if(data[i].Beneficiary_Product__c !== undefined)
                        	if(!data[i].Beneficiary_Product__c.includes(component.get("v.ProductNameFromFlow"))){
                            	data.splice(i,1);
                                i--;
                        }
                    }
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
                var oppPartyDetailsMap = {};
                var existingData =response.getReturnValue();
                if(existingData.length > 0){
                    for(var i=0;i<existingData.length; i++){  
                        oppPartyDetailsMap[existingData[i].Id]=existingData[i];
                        
                    }   
                    component.set("v.allBeneficiariesMap",oppPartyDetailsMap);
                }
                else{
                    component.set("v.allBeneficiariesMap",'');
                }
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);
    },
    
    removeBeneficiary: function (cmp, row) {
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
                        this.fetchData(cmp);
                        var number = a.getReturnValue();
                        if(number < 5){
                          if(cmp.get("v.oppRecordType") != 'Direct Delivery Sales Opportunity'){
                            cmp.find("newBeneficiaryButton").set("v.disabled", false);
                            }
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
        });
        $A.enqueueAction(action)
        $A.get('e.force:refreshView').fire();
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
    
    showSpinner: function (component) {
        var spinner = component.find("TheSpinner");
        $A.util.removeClass(spinner, "slds-hide");
    },
    
    hideSpinner: function (component) {
        var spinner = component.find("TheSpinner");
        $A.util.addClass(spinner, "slds-hide");
    },
    
    getOpportunitypartyDetails :function(component,event) {
        
        component.set("v.showSpinner",true);
        var oppId = component.get("v.recordId");
        var action = component.get("c.getAllPartyData");
        action.setParams({
            "oppId": oppId
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            console.log('state '+state)
            if (state === "SUCCESS") {
                var oppPartyDetailsMap = {};//OpportunityPartyDetailsMap
                var allBeneficiariesData = component.get("v.allBeneficiaries");
                //var allOportunityParytData=component.get("v.OpportunityPartyDetailsList");
                var allOportunityParytData=[];
                var existingData =a.getReturnValue();
                console.log('existingData',existingData);
                if(existingData.length > 0){
                    for(var i=0;i<existingData.length; i++){
                        if(existingData[i].Relationship__c !='Main Member'){ 
                            allBeneficiariesData.push(existingData[i]);
                            allOportunityParytData.push(existingData[i]);
                            oppPartyDetailsMap[existingData[i].Id]=existingData[i];
                        }
                    }   
                    
                    component.set("v.allBeneficiaries",allBeneficiariesData) ;
                    component.set("v.OpportunityPartyDetailsMap",oppPartyDetailsMap); //opportunity party data except rider details
                    component.set("v.OpportunityPartyDetailsList",allOportunityParytData);
                }
                if(allBeneficiariesData.length == 0){
                    //this.getOpportunityDetails(component,event);
                }else{
                    component.set("v.showSpinner",false);
                }
                
            }
        });
        $A.enqueueAction(action);
    },
    
    generateFamilyPicklistOptions :function(component,event){
        var oppPrtyData = component.get("v.OpportunityPartyDetailsList");
        var opts = [];
        if(oppPrtyData.length > 0){
            opts.push({
                class: "optionClass",
                label: "--- None ---",
                value: ""
            });
            for(var i = 0; i < oppPrtyData.length; i++){
                if(oppPrtyData[i].Relationship__c !== 'Main Member' && (Number(oppPrtyData[i].Age_As_Number__c) > 18 || Number(oppPrtyData[i].Age__c) > 18)){
                      opts.push({
                    	class: "optionClass",
                    	label: oppPrtyData[i].First_Name__c,
                    	value: oppPrtyData[i].Id
                	});
                }
            }
            component.set("v.existingFamilyOptions",opts);
            component.set("v.showexistingFamilyOptions",true);//only show when options are there
        }
        
    },
    
    saveOppPartyData : function(component,event,helper){
        var oppPartyData =component.get("v.allBeneficiaries");
        var oppPartyDeleteData =component.get("v.OpportunityPartyDetailsListDelete");
        if(oppPartyData.length >0 ){
            var action = component.get("c.insertOppPartyData");
            action.setParams({
                "oppPartyListInsert": oppPartyData,
                "oppPartyListInsertdelete" : oppPartyDeleteData
            });
            action.setCallback(this, function(a) {
                var state = a.getState();
                if (state === "SUCCESS") {
                    console.log('success');
                    this.fetchData(component);
                }else{
                    console.log('Error '+JSON.stringify(a.getError()));
                }
            });
            $A.enqueueAction(action);
        }
    },
    fetchOppData: function (component) {
        var oppId = component.get("v.recordId");
        var action = component.get("c.getOppRec");
        action.setParams({
            "oppId": oppId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                component.set("v.oppRecordType", data.RecordType.Name);
                if(component.get("v.oppRecordType") == 'Direct Delivery Sales Opportunity'){
                    component.set("v.toggleBeneficiaryButton", false);
                }
                var actions =[];
        	if(component.get("v.oppRecordType") != 'Direct Delivery Sales Opportunity'){
            
    	 		actions = [
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
            
        	}
        	else{
            
           		actions = [
            		{ label: 'Update Details', iconName: 'utility:edit', name: 'update_details' },
            		{ label: 'Remove', iconName: 'utility:delete', name: 'Remove' }
        		]; 
            
             	component.set('v.columns', [
            		{ label: 'First Name', fieldName: 'First_Name__c', type: 'text' },
            		{ label: 'Last Name', fieldName: 'Last_Name__c', type: 'text' },
            		{ label: 'RSA ID Number', fieldName: 'RSA_ID_Number__c', type: 'text' },
            		{ label: 'Date of Birth', fieldName: 'Date_of_Birth__c', type: 'date' },
            		{ label: 'Age', fieldName: 'Age__c', type: 'number' },
            		{ label: 'Party Type(s)', fieldName: 'Party_Type__c', type: 'text' },
            		{ type: 'action', typeAttributes: { rowActions: actions } }
        		]);           
        	 }              
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);
    },
    
  	removeBeneficiaryParty: function (cmp, row) {
    	var oppPartyId = cmp.get("v.updateRecordId");
        var action = cmp.get("c.removeBeneficiaryParty");
        
        action.setParams({
            "oppPartyId": oppPartyId,
            "productName":cmp.get("v.ProductNameFromFlow")
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state === "SUCCESS") {
                              
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
        });
        $A.enqueueAction(action)
        $A.get('e.force:refreshView').fire();
    }
    
})