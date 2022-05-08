({
    getAccountDetails : function(component, event, helper) {
        
        var action = component.get("c.getAccount");
        console.log("Opp Id " + component.get("v.recordId"));
        action.setParams({
            "oppId": component.get("v.recordId"),
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var acc = response.getReturnValue();
                console.log("acc " + JSON.stringify(acc));
                component.set("v.accId", acc.Id);
                component.set("v.accRec", acc);

                if(acc.SPM_Platform_Type__c != null){
                    component.set("v.isPlatform", true);
                }else{
                    component.set("v.isPlatform", false);
                }

                console.log("Is Platform Account " + component.get("v.isPlatform"));

            }
            else {
                console.log("Failed with state: " + JSON.stringify(response));
            }
        });
        $A.enqueueAction(action);
    },
    
    getAppDetails : function(component, event, helper) {
        
        var action = component.get("c.getAppRec");
        console.log("Opp Id " + component.get("v.recordId"));
        action.setParams({
            "oppId": component.get("v.recordId"),
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var app = response.getReturnValue();
                console.log("app " + JSON.stringify(app));
                
                component.set("v.appId", app.Id);
                
            }
            else {
                console.log("Failed with state: " + JSON.stringify(response));
            }
        });
        $A.enqueueAction(action);
    },
    
    
    
    
    //update Account details
    updateAppDetails : function(component, event, helper) {
        
        var appRecid  = component.get("v.appId");
        console.log(appRecid);
        var action = component.get("c.updateAppDetails");
        
        var  age ,health ,occupationStatus,monthlyincome;
        
        if(component.find("age") == undefined){
            age=null;
        }else{
            age = component.find("age").get("v.value");
        }
        if(component.find("health") == undefined){
            health=null;
        }else{
            health = component.find("health").get("v.value");
        }
        if(component.find("occupationStatus") == undefined){
            occupationStatus=null;
        }else{
            occupationStatus = component.find("occupationStatus").get("v.value");
        }
        if(component.find("monthlyincome") == undefined){
            monthlyincome=null;
        }else{
            monthlyincome = component.find("monthlyincome").get("v.value");
        }
        
        
        action.setParams({ 
            
            "age":age,
            "health":health,
            "occupationStatus":occupationStatus,
            "monthlyincome":monthlyincome,
            "intendedInvestmentTerm" : component.find("intendedInvestmentTerm").get("v.value"),
            "investmentExperience" : component.find("investmentExperience").get("v.value"),
            "understandFinancialMarketsandInvest" : component.find("understandFinancialMarketsandInvest").get("v.value"),
            "investmentOpportunities" : component.find("investmentOpportunities").get("v.value"),
            "numberOfDependants" : component.find("numberOfDependants").get("v.value"),
            "relationToInflation" : component.find("relationToInflation").get("v.value"),
            "liquidityToCoverEmergencies" : component.find("liquidityToCoverEmergencies").get("v.value"),
            "appRecid" : appRecid});  
        
        
        
        
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var applicationDetails = response.getReturnValue();
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type":"success",
                    "message": "Application updated Successfully"
                });
                toastEvent.fire();
                
            }
            else if (state === "INCOMPLETE") {
                //cmp.set('v.showSpinner', true);
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " +errors[0].message);
                        }
                    }else{
                        console.log("Unknown error");
                    }
                }
            
        });
        $A.enqueueAction(action);
    },
    
    CalculateScore : function(component, event, helper) {
        var action = component.get("c.CalculateScore");
        //  console.log("App Id " + component.get("v.appId"));
        action.setParams({
            // "appRecid": component.get("v.appId"),
            "oppId": component.get("v.recordId"),
            
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var appRec = response.getReturnValue();
                console.log("totalscore " + JSON.stringify(appRec));
                component.set("v.totalscore",appRec.Total_Score__c);
                component.set("v.showSpinner", false);
                
            }
            else {
                console.log("Failed with state: " + JSON.stringify(response));
            }
            $A.get('e.force:refreshView').fire();$A.get('e.force:refreshView').fire();
        });
        $A.enqueueAction(action);
    },
    
    
    
    
})