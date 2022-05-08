({
    getAppPrdctCpfRec :function(component, event, helper) {
        var action = component.get("c.getAppProdctCpfRec");
        action.setParams({
            "oppId": component.get("v.recordId"),
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var appPrdctCpfRecId = response.getReturnValue();
                console.log("appPrdctCpfRecId: " + JSON.stringify(appPrdctCpfRecId));
                component.set("v.appPrdctCpfRec", appPrdctCpfRecId); 
                component.set("v.appPrdctCpfRecId", appPrdctCpfRecId.Id);
                component.set("v.securityproviderconsent", appPrdctCpfRecId.Security_Provider_Consent__c);
            }else {
                console.log("Failed with state: " + JSON.stringify(appPrdctCpfRecId));
            }
        });
        
        $A.enqueueAction(action);
    },
    
    
    getSecOffRecCrossGuarantee :function(component, event, helper) {
        var action = component.get("c.getApplicationSecCpfRec");  
        console.log('component.get("v.SecurityClass")New'+component.get("v.SecurityClass"))
        
        action.setParams({
            "oppId": component.get("v.recordId"),
            "SecurityType":'Cross Guarantee',
            "SecurityClass":component.get("v.SecurityClass"),
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var SecOffRec = response.getReturnValue();
                console.log("getSecOffRec: " + JSON.stringify(SecOffRec));
                component.set("v.SecOffRec", SecOffRec); 
                if(SecOffRec !=null ){
                    component.set("v.Crossguarantee", SecOffRec.Cross_guarantee__c); 
                    console.log("SecOffRec.Id"+SecOffRec.Id);    
                    component.set("v.appsecurCrossguaranteeId", SecOffRec.Id);
                    component.set("v.Includingcessionofclaimsandloanaccount", SecOffRec.Including_cession_of_claims_and_loan_acc__c); 
                    component.set("v.cpfreleased", SecOffRec.To_be_released__c); 
                }
            }else {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "type":"error",
                    "message": "Please select CPF product."
                });
                    toastEvent.fire();
               // console.log("Failed with state: " + JSON.stringify(SecOffRec));
            }
        });
        
        $A.enqueueAction(action);
    },
    
    
    getSecOffRecCrossGuaranteeExist :function(component, event, helper) {
        var action = component.get("c.getApplicationSecCpfRecExist");  
        console.log('component.get("v.SecurityClass")existing'+component.get("v.SecurityClass"))
        action.setParams({
            "oppId": component.get("v.recordId"),
            "SecurityType":'Cross Guarantee',
            "SecurityClass":component.get("v.SecurityClass"),
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var SecOffRecExist = response.getReturnValue();
                console.log("getSecOffRecSecOffRecExist: " + JSON.stringify(SecOffRecExist));
                if(SecOffRecExist !=null ){
                    component.set("v.Crossguarantee", SecOffRecExist.Cross_guarantee__c); 
                    console.log("SecOffRec.IdExisting"+SecOffRecExist.Id);    
                    component.set("v.appsecurCrossguaranteeIdExist", SecOffRecExist.Id);
                    component.set("v.Includingcessionofclaimsandloanaccount", SecOffRecExist.Including_cession_of_claims_and_loan_acc__c); 
                    component.set("v.cpfreleased", SecOffRecExist.To_be_released__c); 
                    
                }
                
            }else {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "type":"error",
                    "message": "Please select CPF product."
                });
                    toastEvent.fire();
                //console.log("Failed with state: " + JSON.stringify(SecOffRec));
            }
        });
        
        $A.enqueueAction(action);
    },
    
    
    getSecOffRecSubAgmtofLoanAccts :function(component, event, helper) {
        var action = component.get("c.getApplicationSecCpfRec"); 
        action.setParams({
            "oppId": component.get("v.recordId"),
            "SecurityType":'Subordination Agreement of Loan Accounts',
            "SecurityClass":component.get("v.SecurityClass"),

        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var SecOffRec = response.getReturnValue();
                console.log("getSecOffRec: " + JSON.stringify(SecOffRec));
                component.set("v.SecOffRec", SecOffRec); 
                if(SecOffRec !=null ){
                    component.set("v.SubordinationAgreementofLoanAccounts", SecOffRec.Subordination_Agreement_of_Loan_Accounts__c); 
                    component.set("v.appsecSubAgreeId", SecOffRec.Id);
                }
            }else {
               var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "type":"error",
                    "message": "Please select CPF product."
                });
                    toastEvent.fire();
               // console.log("Failed with state: " + JSON.stringify(SecOffRec));
            }
        });
        
        $A.enqueueAction(action);
    },
    
        getSecOffRecSubAgmtofLoanAcctsExist :function(component, event, helper) {
        var action = component.get("c.getApplicationSecCpfRec"); 
        action.setParams({
            "oppId": component.get("v.recordId"),
            "SecurityType":'Subordination Agreement of Loan Accounts',
            "SecurityClass":component.get("v.SecurityClass"),

        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var SecOffRec = response.getReturnValue();
                console.log("getSecOffRec: " + JSON.stringify(SecOffRec));
                component.set("v.SecOffRec", SecOffRec); 
                if(SecOffRec !=null ){
                    component.set("v.SubordinationAgreementofLoanAccounts", SecOffRec.Subordination_Agreement_of_Loan_Accounts__c); 
                    component.set("v.appsecSubAgreeIdExist", SecOffRec.Id);
                }
            }else {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "type":"error",
                    "message": "Please select CPF product."
                });
                    toastEvent.fire();
              //  console.log("Failed with state: " + JSON.stringify(SecOffRec));
            }
        });
        
        $A.enqueueAction(action);
    },

    
    getUndertakingtoinjectcostoverrunfunds :function(component, event, helper) {
        var action = component.get("c.getApplicationSecCpfRec"); 
        action.setParams({
            "oppId": component.get("v.recordId"),
            "SecurityType":'Undertaking to inject cost overrun funds',
            "SecurityClass":component.get("v.SecurityClass"),

        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var SecOffRec = response.getReturnValue();
                console.log("getSecOffRec: " + JSON.stringify(SecOffRec));
                component.set("v.SecOffRec", SecOffRec); 
                if(SecOffRec !=null ){
                    component.set("v.Undertakingtoinjectcostoverrunfunds", SecOffRec.Undertaking_to_inject_cost_overrun_funds__c); 
                    component.set("v.appsecurUndertakingId", SecOffRec.Id);
                }
            }else {
                console.log("Failed with state: " + JSON.stringify(SecOffRec));
            }
        });
        
        $A.enqueueAction(action);
    },
    
    getUndertakingtoinjectcostoverrunfundsExist :function(component, event, helper) {
        var action = component.get("c.getApplicationSecCpfRec"); 
        action.setParams({
            "oppId": component.get("v.recordId"),
            "SecurityType":'Undertaking to inject cost overrun funds',
            "SecurityClass":component.get("v.SecurityClass"),

        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var SecOffRec = response.getReturnValue();
                console.log("getSecOffRec: " + JSON.stringify(SecOffRec));
                component.set("v.SecOffRec", SecOffRec); 
                if(SecOffRec !=null ){
                    component.set("v.Undertakingtoinjectcostoverrunfunds", SecOffRec.Undertaking_to_inject_cost_overrun_funds__c); 
                    component.set("v.appsecurUndertakingIdExist", SecOffRec.Id);
                }
            }else {
                console.log("Failed with state: " + JSON.stringify(SecOffRec));
            }
        });
        
        $A.enqueueAction(action);
    },

    
    
    getCrossDefaultClause :function(component, event, helper) {
        var action = component.get("c.getApplicationSecCpfRec"); 
        action.setParams({
            "oppId": component.get("v.recordId"),
            "SecurityType":'Cross Default Clause',
            "SecurityClass":component.get("v.SecurityClass"),
 
            
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var SecOffRec = response.getReturnValue();
                console.log("getSecOffRec: " + JSON.stringify(SecOffRec));
                component.set("v.SecOffRec", SecOffRec); 
                if(SecOffRec !=null ){
                    component.set("v.CrossDefaultClause", SecOffRec.Cross_default_clause__c); 
                    component.set("v.appsecurCrossdefaultId", SecOffRec.Id);
                }
            }else {
                console.log("Failed with state: " + JSON.stringify(SecOffRec));
            }
        });
        
        $A.enqueueAction(action);
    },
    
    getCrossDefaultClauseExist :function(component, event, helper) {
        var action = component.get("c.getApplicationSecCpfRec"); 
        action.setParams({
            "oppId": component.get("v.recordId"),
            "SecurityType":'Cross Default Clause',
            "SecurityClass":component.get("v.SecurityClass"),

        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var SecOffRec = response.getReturnValue();
                console.log("getSecOffRec: " + JSON.stringify(SecOffRec));
                component.set("v.SecOffRec", SecOffRec); 
                if(SecOffRec !=null ){
                    component.set("v.CrossDefaultClause", SecOffRec.Cross_default_clause__c); 
                    component.set("v.appsecurCrossdefaultIdExist", SecOffRec.Id);
                }
            }else {
                console.log("Failed with state: " + JSON.stringify(SecOffRec));
            }
        });
        
        $A.enqueueAction(action);
    },

   
    getcrossCollSecurityofferedCpfRec :function(component, event, helper) {
        var action = component.get("c.getApplicationSecCpfRec"); 
        action.setParams({
            "oppId": component.get("v.recordId"),
            "SecurityType":'Cross Collateralisation',
            "SecurityClass":component.get("v.SecurityClass"),
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var securityoffRec = response.getReturnValue();
                //console.log(":securityoffRecCross collater " + JSON.stringify(securityoffRec.Facilities__c));
              if(securityoffRec !=null ){
                    component.set("v.crossCollOptionGiven", securityoffRec.Cross_collateralisation__c); 
                    component.set("v.appsecurCrossCollaterId", securityoffRec.Id);
                 // if(securityoffRec.Facilities__c!=null){
                    if(securityoffRec.Facilities__c =='Insert specific facility detail'){
                        component.set("v.showfacilitydetail", true);}//}
                }
                
            }else {
                console.log("Failed with state: " + JSON.stringify(securityoffRec));
            }
        });
        
        $A.enqueueAction(action);
    }, 
 
    getcrossCollSecurityExist :function(component, event, helper) {
        var action = component.get("c.getApplicationSecCpfRecExist");        
        action.setParams({
            "oppId": component.get("v.recordId"),
            "SecurityType":'Cross Collateralisation',
            "SecurityClass":component.get("v.SecurityClass"),
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var securityoffRec = response.getReturnValue();
                var secoff=JSON.stringify(securityoffRec);
                console.log(":securityoffRec " + secoff);
              if(securityoffRec !=null ){
                    component.set("v.crossCollOptionGiven", securityoffRec.Cross_collateralisation__c); 
                    component.set("v.appsecurCrossCollaterIdExist", securityoffRec.Id);
                    if(securityoffRec.Facilities__c =='Insert specific facility detail')
                    component.set("v.showfacilitydetail", true);
                }
            }else {
                console.log("Failed with state: " + JSON.stringify(securityoffRec));
            }
        });
        
        $A.enqueueAction(action);
    }, 

    updateAppPrdctcpf : function(component, event, helper) {
        var SecurityProviderConsent=component.get("v.securityproviderconsent");
        var action = component.get("c.updateAppPrdctcpf");
        action.setParams({
            "recId" : component.get("v.appPrdctCpfRec.Id"),
            "SecurityProviderConsent":SecurityProviderConsent
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var appcpfrec = response.getReturnValue();
                console.log('appcpfrec---'+JSON.stringify(appcpfrec));
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
        });
        $A.enqueueAction(action);
        
    },
    
    insertSubAgreeforLoanAcct: function(component, event, helper) {
        var securityclass=component.get("v.SecurityClass");
        var SubordinationAgreementofLoanAccounts=component.get("v.SubordinationAgreementofLoanAccounts");
        var claimsby ,CPAdocumentversion;
        if(component.find("claimsby") == undefined){
            claimsby=null;
        }else{
            claimsby = component.find("claimsby").get("v.value");
        }
        if(component.find("CPAdocumentversion") == undefined){
            CPAdocumentversion=null;
        }else{
            CPAdocumentversion = component.find("CPAdocumentversion").get("v.value");
        }
        var action = component.get("c.insertSubAgreeforLoanAcct");
        action.setParams({
            "recId" : component.get("v.appPrdctCpfRec.Id"),
            "SubordinationAgreementofLoanAccounts" : SubordinationAgreementofLoanAccounts,
            "claimsby":claimsby,
            "CPAdocumentversion":CPAdocumentversion,
            "SecurityClass":securityclass,

        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS"){
                var oppRec = response.getReturnValue();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type":"success",
                    "message": "Security Offered CPF record created Successfully"
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
        });
        $A.enqueueAction(action);
        
    },
  
    
       insertSubAgreeforLoanAcctExist: function(component, event, helper) {
        var securityclass=component.get("v.SecurityClass");
        var SubordinationAgreementofLoanAccounts=component.get("v.SubordinationAgreementofLoanAccounts");
        var claimsby ,dateRegistered;
        if(component.find("claimsby") == undefined){
            claimsby=null;
        }else{
            claimsby = component.find("claimsby").get("v.value");
        }
        if(component.find("dateRegistered") == undefined){
            dateRegistered=null;
        }else{
            dateRegistered = component.find("dateRegistered").get("v.value");
        }
        var action = component.get("c.insertSubAgreeforLoanAcctExist");
        action.setParams({
            "recId" : component.get("v.appPrdctCpfRec.Id"),
            "SubordinationAgreementofLoanAccounts" : SubordinationAgreementofLoanAccounts,
            "claimsby":claimsby,
            "dateRegistered":dateRegistered,
            "SecurityClass":securityclass,

        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS"){
                var oppRec = response.getReturnValue();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type":"success",
                    "message": "Security Offered CPF record created Successfully"
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
        });
        $A.enqueueAction(action);
        
    },

    
    insertUndertakingtoinjectcostoverrunfunds: function(component, event, helper) {
        var securityclass=component.get("v.SecurityClass");
         var recId = component.get("v.appPrdctCpfRec.Id");
       // console.log(recId);

        var Undertakingtoinjectcostoverrunfunds=component.get("v.Undertakingtoinjectcostoverrunfunds");
        var whowillberesponsiblepay;
        if(component.find("whowillberesponsiblepay") == undefined){
            whowillberesponsiblepay=null;
        }else{
            whowillberesponsiblepay = component.find("whowillberesponsiblepay").get("v.value");
        }
        var action = component.get("c.insertUndertakingtoinjectcostoverrunfunds");
        action.setParams({
            "recId" : component.get("v.appPrdctCpfRec.Id"),
            "Undertakingtoinjectcostoverrunfunds" : Undertakingtoinjectcostoverrunfunds,
            "whowillberesponsiblepay":whowillberesponsiblepay,
            "SecurityClass":securityclass,

        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS"){
                var oppRec = response.getReturnValue();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type":"success",
                    "message": "Security Offered CPF record created Successfully"
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
        });
        $A.enqueueAction(action);
        
    },  
    
 
     insertUndertakingtoinjectcostoverrunfundsExist: function(component, event, helper) {
        var securityclass=component.get("v.SecurityClass");
        var Undertakingtoinjectcostoverrunfunds=component.get("v.Undertakingtoinjectcostoverrunfunds");
        var whowillberesponsiblepay,dateRegisteredunder;
        if(component.find("whowillberesponsiblepay") == undefined){
            whowillberesponsiblepay=null;
        }else{
            whowillberesponsiblepay = component.find("whowillberesponsiblepay").get("v.value");
        }
        if(component.find("dateRegisteredunder") == undefined){
            dateRegisteredunder=null;
        }else{
            dateRegisteredunder = component.find("dateRegisteredunder").get("v.value");
        }

        var action = component.get("c.insertUndertakingtoinjectcostoverrunfundsExist");
        action.setParams({
            "recId" : component.get("v.appPrdctCpfRec.Id"),
            "Undertakingtoinjectcostoverrunfunds" : Undertakingtoinjectcostoverrunfunds,
            "whowillberesponsiblepay":whowillberesponsiblepay,
            "dateRegisteredunder":dateRegisteredunder,
            "SecurityClass":securityclass,

        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS"){
                var oppRec = response.getReturnValue();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type":"success",
                    "message": "Security Offered CPF record created Successfully"
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
        });
        $A.enqueueAction(action);
        
    },  

    
    insertCrossDefaultClause: function(component, event, helper) {
          var securityclass=component.get("v.SecurityClass");
        var CrossDefaultClause=component.get("v.CrossDefaultClause");
        var crossdefaultclauseparty;
        if(component.find("crossdefaultclauseparty") == undefined){
            crossdefaultclauseparty=null;
        }else{
            crossdefaultclauseparty = component.find("crossdefaultclauseparty").get("v.value");
        }
        var action = component.get("c.insertCrossDefaultClause");
        action.setParams({
            "recId" : component.get("v.appPrdctCpfRec.Id"),
            "CrossDefaultClause" : CrossDefaultClause,
            "crossdefaultclauseparty":crossdefaultclauseparty,
            "SecurityClass":securityclass,

        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var crossdefaultcl = response.getReturnValue();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type":"success",
                    "message": "Security Offered CPF record created Successfully"
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
        });
        $A.enqueueAction(action);
        
    }, 
    
     insertCrossDefaultClauseExist: function(component, event, helper) {
         var securityclass=component.get("v.SecurityClass");
        var CrossDefaultClause=component.get("v.CrossDefaultClause");
        var crossdefaultclauseparty;
        if(component.find("crossdefaultclauseparty") == undefined){
            crossdefaultclauseparty=null;
        }else{
            crossdefaultclauseparty = component.find("crossdefaultclauseparty").get("v.value");
        }
        var action = component.get("c.insertCrossDefaultClauseExist");
        action.setParams({
            "recId" : component.get("v.appPrdctCpfRec.Id"),
            "CrossDefaultClause" : CrossDefaultClause,
            "crossdefaultclauseparty":crossdefaultclauseparty,
            "SecurityClass":securityclass,

        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var crossdefaultcl = response.getReturnValue();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type":"success",
                    "message": "Security Offered CPF record created Successfully"
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
        });
        $A.enqueueAction(action);
        
    }, 

    
    
    
    
    insertCrossguarantee: function(component, event, helper) {
        var securityclass=component.get("v.SecurityClass");
        var Crossguarantee=component.get("v.Crossguarantee");
        var Includingcessionofclaimsandloanaccount= component.get("v.Includingcessionofclaimsandloanaccount");
        var cpfreleased= component.get("v.cpfreleased");
        var Amount,InpreleaseCondtn,Inpwentorelease,byWho;
        
        if(component.find("Amount") == undefined){
            Amount=null;
        }else{
            Amount = component.find("Amount").get("v.value");
        }
        if(component.find("Inpwentorelease") == undefined){
            Inpwentorelease=null;
        }else{
            Inpwentorelease = component.find("Inpwentorelease").get("v.value");
        }
        if(component.find("InpreleaseCondtn") == undefined){
            InpreleaseCondtn=null;
        }else{
            InpreleaseCondtn = component.find("InpreleaseCondtn").get("v.value");
        }
        
        if(component.find("Bywho") == undefined){
            byWho=null;
        }else{
            byWho = component.find("Bywho").get("v.value");
        }
        
        var action = component.get("c.insertCrossguarantee");
        action.setParams({
            "recId" : component.get("v.appPrdctCpfRec.Id"),
            "Crossguarantee" : Crossguarantee,
            "Includingcessionofclaimsandloanaccount":Includingcessionofclaimsandloanaccount,
            "cpfreleased":cpfreleased,
            "Amount":Amount,
            "Inpwentoreleasemht":Inpwentorelease,
            "releasecondition":InpreleaseCondtn,
            "SecurityClass":securityclass,
            "buyWho": byWho 
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS"){
                var oppRec = response.getReturnValue();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type":"success",
                    "message": "Security Offered CPF record created Successfully"
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
        });
        $A.enqueueAction(action);
        
    }, 
    
    insertCrossguaranteeexist: function(component, event, helper) {
        var securityclass=component.get("v.SecurityClass");
        var Crossguarantee=component.get("v.Crossguarantee");
        var Includingcessionofclaimsandloanaccount= component.get("v.Includingcessionofclaimsandloanaccount");
        var cpfreleased= component.get("v.cpfreleased");
        var Amount,InpreleaseCondtn,Inpwentorelease,byWho;
        
        if(component.find("Amount") == undefined){
            Amount=null;
        }else{
            Amount = component.find("Amount").get("v.value");
        }
        if(component.find("Inpwentorelease") == undefined){
            Inpwentorelease=null;
        }else{
            Inpwentorelease = component.find("Inpwentorelease").get("v.value");
        }
        if(component.find("InpreleaseCondtn") == undefined){
            InpreleaseCondtn=null;
        }else{
            InpreleaseCondtn = component.find("InpreleaseCondtn").get("v.value");
        }
        if(component.find("Bywhoexist") == undefined){
            byWho=null;
        }else{
            byWho = component.find("Bywhoexist").get("v.value");
        }
   
        var action = component.get("c.insertCrossguaranteeexist");
        action.setParams({
            "recId" : component.get("v.appPrdctCpfRec.Id"),
            "Crossguarantee" : Crossguarantee,
            "Includingcessionofclaimsandloanaccount":Includingcessionofclaimsandloanaccount,
            "cpfreleased":cpfreleased,
            "Amount":Amount,
            "Inpwentoreleasemht":Inpwentorelease,
            "releasecondition":InpreleaseCondtn,
            "SecurityClass":securityclass,
            "byWho":byWho 
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS"){
                var oppRec = response.getReturnValue();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type":"success",
                    "message": "Security Offered CPF record created Successfully"
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
        });
        $A.enqueueAction(action);
        
    }, 
    
    
    insertcrossCollateralisation: function(component, event, helper) {
        var securityclass=component.get("v.SecurityClass");
        var crossCollOptionGiven =component.get("v.crossCollOptionGiven");
        var inputsecurityprovided,inputfacilities,Inputspecificdetails;
        if(component.find("inpsecprovided") == undefined){
            inputsecurityprovided=null;
        }else{
            inputsecurityprovided = component.find("inpsecprovided").get("v.value");
        }
        if(component.find("inpFacilities")  == undefined){
            inputfacilities=null;
        }else{
            inputfacilities = component.find("inpFacilities").get("v.value") ;
        }
        if(component.find("InpspecificdetailsNew") == undefined){
            Inputspecificdetails=null;
        }else{
            Inputspecificdetails = component.find("InpspecificdetailsNew").get("v.value");
        }
        var action = component.get("c.insertCrossCollRec");
        action.setParams({
            "recId" : component.get("v.appPrdctCpfRec.Id"),
            "secprovided" : inputsecurityprovided,
            "FacilitiesValue" : inputfacilities,
            "specificdetails" : Inputspecificdetails,
            "crossCollOptionGiven" : crossCollOptionGiven,
            "SecurityClass":securityclass,

        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var crossRec = response.getReturnValue();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type":"success",
                    "message": "Security Offered CPF record created Successfully"
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
        });
        $A.enqueueAction(action);
        
    },
    
    insertcrossCollateralisationExist: function(component, event, helper) {
        var securityclass=component.get("v.SecurityClass");
        var crossCollOptionGiven =component.get("v.crossCollOptionGiven");
        var inputsecurityprovided, inputfacilities, Inputspecificdetails;
        if(component.find("inpsecprovided") == undefined){
            inputsecurityprovided=null;
        }else{
            inputsecurityprovided = component.find("inpsecprovided").get("v.value");
        }
        if(component.find("inpFacilities") == undefined){
            inputfacilities=null;
        }else{
            inputfacilities = component.find("inpFacilities").get("v.value");
        }
        if(component.find("Inpspecificdetails") == undefined){
            Inputspecificdetails=null;
        }else{
            Inputspecificdetails = component.find("Inpspecificdetails").get("v.value");
        }
        console.log('Cross inputfacilities'+inputfacilities);
        var action = component.get("c.insertCrossCollRecExist");
        action.setParams({
            "recId" : component.get("v.appPrdctCpfRec.Id"),
            "secprovided" : inputsecurityprovided,
            "FacilitiesValue" : inputfacilities,
            "specificdetails" : Inputspecificdetails,
            "crossCollOptionGiven" : crossCollOptionGiven,
            "SecurityClass":securityclass,

        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var crossRec = response.getReturnValue();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type":"success",
                    "message": "Security Offered CPF record created Successfully"
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
        });
        $A.enqueueAction(action);
        
    },
    getopplineitemRec :function(component, event, helper) {
        var action = component.get("c.getprodName");
        var oppRecId=component.get("v.recordId");
        action.setParams({
            "oppId": component.get("v.recordId"),
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var getprodNamelst = response.getReturnValue();
                console.log(":getprodName " + JSON.stringify(getprodNamelst));
                component.set("v.prodName",getprodNamelst[0].Product_Name__c);
                console.log("Product Name : " + getprodNamelst[0].Product_Name__c);
                
            }else {
                console.log("Failed with state: " + JSON.stringify(getprodNamelst));
            }
        });
        
        $A.enqueueAction(action);
    },


})