({
    getAppPrdctCpfRec :function(component, event, helper) {
        var action = component.get("c.getAppProdctCpfRec");
        action.setParams({
            "oppId": component.get("v.recordId"),
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var appPrdctCpfRec = response.getReturnValue();
                console.log("appPrdctCpfRecId 3: " + JSON.stringify(appPrdctCpfRec));
                component.set("v.appPrdctCpfRec", appPrdctCpfRec);
                if(appPrdctCpfRec.Is_Sectional_Title_Plan_Approved__c	 != '' && appPrdctCpfRec.Is_Sectional_Title_Plan_Approved__c!= null ){
                    component.set("v.approvedsectitleplans", appPrdctCpfRec.Is_Sectional_Title_Plan_Approved__c);
                }
                if(appPrdctCpfRec.Is_Upon_Completion_Of_Development__c	 != '' && appPrdctCpfRec.Is_Upon_Completion_Of_Development__c!= null ){
                    component.set("v.uponcompofdev", appPrdctCpfRec.Is_Upon_Completion_Of_Development__c);
                }

            } else {
                console.log("Failed with state: " + JSON.stringify(appPrdctCpfRec));
            }
            
        });
        
        $A.enqueueAction(action);
    },
    getAppConClauseCpfRec :function(component, event, helper) {
        var action = component.get("c.getAppContractClauseRec");
        
        action.setParams({
            "oppId": component.get("v.recordId"),
            "type":'Other Drawdown conditions'
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                //debugger;
                var appConClauseRec = response.getReturnValue();
                console.log("newOtherDrawDownConditions: " + JSON.stringify(appConClauseRec));
              	component.set("v.newOtherDrawDownConditions",response.getReturnValue());
              
            }else {
                console.log("Failed with state: " + JSON.stringify(appConClauseRec));
            }
        });
        
        $A.enqueueAction(action);
    },
    getAppConClauseCpfReclst :function(component, event, helper) {
        var action = component.get("c.getAppContractClauseRec");
        
        action.setParams({
            "oppId": component.get("v.recordId"),
            "type":'Other Final Drawdown Conditions'
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                //debugger;
                var appConClauseRec = response.getReturnValue();
                console.log("newOtherFinalDrawDownConditions: " + JSON.stringify(appConClauseRec));
              	component.set("v.newOtherFinalDrawDownConditions",response.getReturnValue());
              
            }else {
                console.log("Failed with state: " + JSON.stringify(appConClauseRec));
            }
        });
        
        $A.enqueueAction(action);
    },
    AddOtherdrawdown : function(component, event) {
        var otherdrawdown = component.get("v.newOtherDrawDownConditions");
        otherdrawdown.push({
            'sobjectType' : 'Application_Contract_Clause__c',
        });
        component.set("v.newOtherDrawDownConditions",otherdrawdown);   
    },
    AddOtherfinaldrawdown: function(component, event) {
        var otherfinaldrawdown = component.get("v.newOtherFinalDrawDownConditions");
        otherfinaldrawdown.push({
            'sobjectType' : 'Application_Contract_Clause__c',
        });
        component.set("v.newOtherFinalDrawDownConditions",otherfinaldrawdown);   
    },
    SaveOtherfinaldrawdown: function(component, event) {
        console.log("finaldatefordrawdown"+component.find("finaldatefordrawdown").get("v.value"));
       var action = component.get("c.insertOtherDrawDownConditions");
       action.setParams({
            "recId" : component.get("v.appPrdctCpfRec.Id"),
            "newOtherDrawDownConditions" : component.get("v.newOtherDrawDownConditions"),
           	"newOtherFinalDrawDownConditions" : component.get("v.newOtherFinalDrawDownConditions"),
           	"approvedsectitleplans" : component.get("v.approvedsectitleplans"),
           	"uponcompofdev" : component.get("v.uponcompofdev"),
            "finaldatefordrawdown": component.find("finaldatefordrawdown").get("v.value")

        });
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS"){
                var Appprdctcpfrecs = response.getReturnValue();
               console.log('Appprdctcpfrecs---'+JSON.stringify(Appprdctcpfrecs));
                //var toastEvent = $A.get("e.force:showToast");
                this.fireToast("Success!","Application Product CPF record updated Successfully","success");
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +errors[0].message);
                    }
                }else{
                    console.log("Unknown error");
                }
            }
           // this.hideSpinner(component);
           component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
        
    },

        //Lightning toastie
    fireToast : function(title, msg, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title":title,
            "message":msg,
            "type":type
        });
        toastEvent.fire();
    }

})