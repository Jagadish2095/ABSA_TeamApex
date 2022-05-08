({
    recolveSBU : function(component,helper,SBU){
        if(SBU == 'F'){
            return 'RETAIL BANKING SERVICES';
        }else if(SBU == 'E'){
            return 'PRIVATE BANK'; 
        }else if(SBU == 'B'){
            return 'ABSA WEALTH';     
        }
    },
    
    updateMissingDocs : function(component,helper,event){
       // component.get("v.recordId")
      let action = component.get("c.getCase");
        action.setParams({
            "recordId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            let state = response.getState();
            let responseData = response.getReturnValue();
            this.getCaseData(component,helper,event);
        });
        $A.enqueueAction(action);
    },
    
    getCaseData : function(component,helper,event){
        //this.showSpinner(component);
        component.set("v.showSpinner", true);
    	let action = component.get("c.getCase");
        action.setParams({
            "recordId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            let state = response.getState();
            let responseData = response.getReturnValue();
            if (state === "SUCCESS") {
               // this.hideSpinner(component);
              
                if (!$A.util.isEmpty(responseData)) {
                    component.set('v.cas', responseData);
                    component.set('v.accRecordId', component.get('v.cas.AccountId'));
                    component.set('v.isVisible', true);
                    if(responseData.AccountId != null){
                       component.set('v.businessUnit', helper.recolveSBU(component,event, responseData.Account.SBU_Segment__c));
                    }
                    
                    if(responseData.MissingDocuments__c != null && (responseData.RecordType.Name == 'Home Loans' || responseData.RecordType.Name == 'AOL')){
                    var toastEvent = $A.get("e.force:showToast");
						toastEvent.setParams({
							type : 'warning',
							mode: 'sticky',
							title: 'Missing Documents',
							message: responseData.MissingDocuments__c
						});
					toastEvent.fire()
                   }
                }
                component.set("v.showSpinner", false);
            } else if (state === "ERROR") {
                //this.hideSpinner(component);
                component.set("v.showSpinner", false);
                let errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
                component.set("v.showSpinner", false);

            }
        });
        $A.enqueueAction(action);
    },
    
      //Function to show spinner when loading
    showSpinner: function (component) {
        var spinner = component.find("TheSpinner");
        $A.util.removeClass(spinner, "slds-hide");
    },
    
    //Function to hide spinner after loading
    hideSpinner: function (component) {
        var spinner = component.find("TheSpinner");
        $A.util.addClass(spinner, "slds-hide");
    },

    fetchPickListVal: function(component, fieldName) {
        var action = component.get("c.getselectOptions");
        action.setParams({
            "objObject": component.get("v.objInfo"),
            "fld": fieldName
        });
        var opts = [];
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var allValues = response.getReturnValue();
 
                if (allValues != undefined && allValues.length > 0) {
                    opts.push({
                        class: "optionClass",
                        label: "--- None ---",
                        value: ""
                    });
                }
                for (var i = 0; i < allValues.length; i++) {
                    opts.push({
                        class: "optionClass",
                        label: allValues[i],
                        value: allValues[i]
                    });
                }
                if(fieldName == 'Occupation_Status__pc'){
                    component.set("v.OccupationStatusoptions", opts);
                }
                if(fieldName == 'Occupation_Category__pc'){
                    component.set("v.OccupationCategoryoptions", opts);
                }
            }
        });
        $A.enqueueAction(action);
    }
});