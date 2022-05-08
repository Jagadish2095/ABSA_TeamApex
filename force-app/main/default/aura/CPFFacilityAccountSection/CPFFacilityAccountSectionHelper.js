({
	 removeNewAccount: function (component) {
         component.getEvent("CPFApplicationFinancialAccCreation").setParams({
             "RowIndex" : component.get("v.rowindex")
         }).fire();
    },
    /*getAppFinAccCpfRec :function(component, event, helper) {
        var action = component.get("c.getAppFinAccfRec");
        var oppRecId=component.get("v.OppRecId");
        
        action.setParams({
            "oppId": component.get("v.OppRecId"),
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var appFinAccRec = response.getReturnValue();
                console.log(": " + JSON.stringify(appFinAccRec));
                
                
            }else {
                console.log("Failed with state: " + JSON.stringify(appFinAccRec));
            }
        });
        
        $A.enqueueAction(action);
    },*/
   /* deleteNewFacilityAccTempId: function (component, appProdAccId) {
        return new Promise(function (resolve, reject) {
            var action = component.get("c.deleteNewAccTempId");
            var toastEvent = $A.get("e.force:showToast");

            action.setParams({
                "appPrdAccId": appProdAccId
            });

            action.setCallback(this, function (response) {
                var state = response.getState();

                if (state == 'SUCCESS') {
                    resolve.call(this, response.getReturnValue());
                }
                else if (state == 'ERROR') {
                    var errors = response.getError();
                    reject.call(this, response.getError()[0]);
                }
            });

            $A.enqueueAction(action);
        });
    },*/
    
    /*UpdateAppFinAcc : function(component, event, helper) {
         var ExistingNumber=component.find("uniqueID").get("v.value");
        var accountnumber=component.find("inputAccNmbr").get("v.value");
        var outstandingBalance=component.find("inputOutstandingbalance").get("v.value");
        var balanceAsat=component.find("inputBalanceasat").get("v.value");
        var appFinAccRecId =component.get("v.appFinAccRec");
        var AppFinaccItemId=component.get("v.accItem.Id");
       alert('ExistingNumber '+ExistingNumber);
        alert('accountnumber '+accountnumber);
        alert('outstandingBalance '+outstandingBalance);
        alert('AppFinaccItemId '+AppFinaccItemId);
         var action = component.get("c.updateAppFinAccCpf");
       action.setParams({
           "OppRecId" : component.get("v.OppRecId"),
           "appFinAccRecId" : appFinAccRecId,
           "AppFinaccItemId" : AppFinaccItemId,
            "ExistingNumber" : ExistingNumber,
           "accountnumber" : accountnumber,
            "outstandingBalance" : outstandingBalance,
            "balanceAsat" : balanceAsat,
            
        });
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS"){
                var AppFinAcc = response.getReturnValue();
                alert('AppFinAcc '+JSON.stringify(AppFinAcc.Id));
               // component.set("v.appFinAccRec", AppFinAcc);
               // component.set("v.appFinAccRec.Id", AppFinAcc.Id);
               // component.set("v.opp", oppRec);
               // component.set("v.showSpinner", false);
                //$A.get('e.force:refreshView').fire();
                //this.refresh(component);
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
        });
        $A.enqueueAction(action);
    },*/
  /*  UpdateAppFinAcc : function(component, event, helper) {
         
         var action = component.get("c.UpdateAppFinAccCpf");
       action.setParams({
            "AppPrdctCPFId" : component.get("v.AppPrdctCPFId"),
           "OppRecId" : component.get("v.OppRecId"),
            
        });
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS"){
                var AppPrdctCPF = response.getReturnValue();
                alert('AppPrdctCPF '+JSON.stringify(AppPrdctCPF));
               
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type":"success",
                    "message": " updated Successfully"
                });
                toastEvent.fire();
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message123: " +errors[0].message);
                    }
                }else{
                    console.log("Unknown error");
                }
            }
           // this.hideSpinner(component);
        });
        $A.enqueueAction(action);
    },*/
})