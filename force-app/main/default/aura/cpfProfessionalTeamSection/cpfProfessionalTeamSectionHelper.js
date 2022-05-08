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
                if(appPrdctCpfRec.Gap_insurance__c	 != '' && appPrdctCpfRec.Gap_insurance__c!= null ){
                    component.set("v.gapinsurance", appPrdctCpfRec.Gap_insurance__c);
                }
                if(appPrdctCpfRec.Early_termination_fee__c	 != '' && appPrdctCpfRec.Early_termination_fee__c!= null ){
                    component.set("v.EarlyTerminationFee", appPrdctCpfRec.Early_termination_fee__c);
                }
                if(appPrdctCpfRec.Gap_insurance__c	 != '' && appPrdctCpfRec.Gap_insurance__c!= null ){
                    component.set("v.gapinsurance", appPrdctCpfRec.Gap_insurance__c);
                }
                if(appPrdctCpfRec.Conversion_options__c	 != '' && appPrdctCpfRec.Conversion_options__c!= null ){
                    component.set("v.showConversionField", appPrdctCpfRec.Conversion_options__c);
                }
                
                
            } else {
                console.log("Failed with state: " + JSON.stringify(appPrdctCpfRec));
            }
            
        });
        
        $A.enqueueAction(action);
    },
    
    updateAppPrdctcpf: function(component, event, helper) { 
        var quantitysurveyor,architect,landsurveyor,civilengineer,structuralengineer,
            mechanicalengineer,electricalengineer,townplanner,projectmanager,wetserviceengineer;
        if(component.find("quantitysurveyor") == undefined){
            quantitysurveyor=null;
        }else{
            quantitysurveyor = component.find("quantitysurveyor").get("v.value");
        }
        if(component.find("architect") == undefined){
            architect=null;
        }else{
            architect = component.find("architect").get("v.value");
        }
        if(component.find("landsurveyor") == undefined){
            landsurveyor=null;
        }else{
            landsurveyor = component.find("landsurveyor").get("v.value");
        }
        if(component.find("civilengineer") == undefined){
            civilengineer=null;
        }else{
            civilengineer = component.find("civilengineer").get("v.value");
        }
        if(component.find("structuralengineer") == undefined){
            structuralengineer=null;
        }else{
            structuralengineer = component.find("structuralengineer").get("v.value");
        }
        if(component.find("mechanicalengineer") == undefined){
            mechanicalengineer=null;
        }else{
            mechanicalengineer = component.find("mechanicalengineer").get("v.value");
        }
        if(component.find("electricalengineer") == undefined){
            electricalengineer=null;
        }else{
            electricalengineer = component.find("electricalengineer").get("v.value");
        }
        if(component.find("townplanner") == undefined){
            townplanner=null;
        }else{
            townplanner = component.find("townplanner").get("v.value");
        }
        if(component.find("projectmanager") == undefined){
            projectmanager=null;
        }else{
            projectmanager = component.find("projectmanager").get("v.value");
        }
        if(component.find("wetserviceengineer") == undefined){
            wetserviceengineer=null;
        }else{
            wetserviceengineer = component.find("wetserviceengineer").get("v.value");
        }
        
        var appProductcpf = new Object();
        appProductcpf.quantitysurveyor = quantitysurveyor;
        appProductcpf.architect= architect;
        appProductcpf.landsurveyor= landsurveyor;
        appProductcpf.civilengineer= civilengineer;
        appProductcpf.structuralengineer= structuralengineer;
        appProductcpf.mechanicalengineer=mechanicalengineer;
        appProductcpf.electricalengineer= electricalengineer;
        appProductcpf.townplanner= townplanner;
        appProductcpf.projectmanager= projectmanager; 
        appProductcpf.wetserviceengineer= wetserviceengineer;
        appProductcpf.newProfessionalTeamMember= component.get('v.newProfessionalTeamMember');

        var action = component.get("c.updateAppPrdctcpf");
        action.setParams({
            "recId" : component.get("v.appPrdctCpfRec.Id"),
            "objData": JSON.stringify(appProductcpf),
        });
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var oppRec = response.getReturnValue();
                console.log("generalinfo ="+JSON.stringify(oppRec));
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type":"success",
                    "message": "Application Product CPF record updated Successfully"
                });
                toastEvent.fire();
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
    
    getAppTeamMemberRec :function(component, event, helper) {
        var action = component.get("c.getAppTeamMemberRec");
        action.setParams({
            "oppId": component.get("v.recordId")
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var appteamMemberRec = response.getReturnValue();
                console.log("newteamMember: " + JSON.stringify(appteamMemberRec));
                component.set("v.newProfessionalTeamMember",response.getReturnValue());
                
            }else {
                console.log("Failed with state: " + JSON.stringify(appteamMemberRec));
            }
        });
        
        $A.enqueueAction(action);
    },
    
    
})