({
	 getCustomerInfo : function(component,event,helper){
       
        var clientCode = component.get("v.CIFfromFlow");
        this.showSpinner(component);
        var action = component.get("c.getCustomerInfo");
        action.setParams({
            clntAcctNbr : component.get("v.accountNumber"),
            inpClientCode : clientCode,
        });
        action.setCallback(this,function(response){
            var state = response.getState();
           
            if(state === "SUCCESS"){
                var resp = response.getReturnValue();
                
                var respValue = JSON.parse(resp);
              
                if ($A.util.isUndefinedOrNull(respValue)) {
                    
                    component.set("v.errorMessage3", "Error: Blank response received from service.");
                }
                for(let item in respValue){
                   
                    if(`${respValue[item]}` === 'null'){                       
                        `${respValue[item] = ''}`
                    }
                }
                component.set("v.CustomerInitialsandSurname",respValue.initials+' '+respValue.surname);
                component.set("v.CellphoneNumber",respValue.cellphone);
                component.set("v.EmailAddress",respValue.emailAddress);
                component.set("v.ResidentialAddress",respValue.postlAddrLine1+','+respValue.postlAddrLine2+','+
                              respValue.postlSuburb+','+respValue.postlTown+','+respValue.postlCodeRsa);
                
            }else if(state == "ERROR"){
                var errors = response.getError();
                if (errors) {
                   
                    if (errors[0] && errors[0].message) {
                        component.set("v.errorMessage3", errors[0].message);
                    }
                } else {
                    component.set("v.errorMessage3", "Error No details found");
                }
            }
            this.hideSpinner(component);
        });
        $A.enqueueAction(action);
    },
    
    getContractInfo : function(component,event,helper){
       
         var accNum = component.get("v.accountNumber");
        var abNumber = component.get("v.currentUser.AB_Number__c");
        this.showSpinner(component);
        var action = component.get("c.getContractInfo");
        action.setParams({
            accNumber : accNum,
            abNumber : abNumber
        });
        action.setCallback(this,function(response){
            var state = response.getState();
          
            if(state === "SUCCESS"){
                var resp = response.getReturnValue();
                var respValue = JSON.parse(resp);
                if ($A.util.isUndefinedOrNull(respValue)) {
                   
                    component.set("v.errorMessage2", "Error: Blank response received from service.");
                }
                for(let item in respValue.BAPI_SF_ACCNT_DESCR.ACCOUNT_RESP[0]){
                  
                    if(`${respValue.BAPI_SF_ACCNT_DESCR.ACCOUNT_RESP[0][item]}` === 'null'){                       
                        `${respValue.BAPI_SF_ACCNT_DESCR.ACCOUNT_RESP[0][item] = ''}`
                    }
                }
                
                var  selectedOptions=[];
                let items = respValue.BAPI_SF_ACCNT_DESCR.ACCOUNT_RESP;
                let num = 0;
                for (let i = 0, len = items.length; i < len; i++) {
                    num++;
                   
                    selectedOptions.push({
                        Id : num, 
                        Name : items[i].MODEL
                    });
                }
                component.set("v.SelectVehicle",selectedOptions);
                component.set("v.AccountStatus",respValue.BAPI_SF_ACCNT_DESCR.ACCOUNT_RESP[0].STATUS);
               
                component.set("v.MakeandModeofvehicle",respValue.BAPI_SF_ACCNT_DESCR.ACCOUNT_RESP[0].MANUFACTURER);
               
                component.set("v.Vinnumber",respValue.BAPI_SF_ACCNT_DESCR.ACCOUNT_RESP[0].VIN);
             
               
            }else if(state == "ERROR"){
                var errors = response.getError();
                if (errors) {
                   
                    if (errors[0] && errors[0].message) {
                        component.set("v.errorMessage2", errors[0].message);
                    }
                } else {
                    component.set("v.errorMessage2", "Error No details found");
                }
            }
            this.hideSpinner(component);
        });
        $A.enqueueAction(action);
    },
    
    saveReasonandCloseCase: function (component, event, helper) {
     
        var description = component.find("descriptionField").get("v.value");
        if (description) {
            description += "Reason : " + component.get("v.Reason");
        } else {
            description = "Reason : " + component.get("v.Reason");
        }
        component.find("descriptionField").set("v.value", description);
        component.find("statusField").set("v.value", "Closed");
        component.find("caseCloseEditForm").submit();
        $A.get("e.force:refreshView").fire();
    },
    
    
    showSpinner: function (component) {
        component.set("v.showSpinner", true);
    },
    
    hideSpinner: function (component) {
        component.set("v.showSpinner", false);
    },
    
    fireToastEvent: function (title, msg, type) {
    var toastEvent = $A.get("e.force:showToast");
    toastEvent.setParams({
      title: title,
      message: msg,
      type: type
    });
    toastEvent.fire();
  }
})