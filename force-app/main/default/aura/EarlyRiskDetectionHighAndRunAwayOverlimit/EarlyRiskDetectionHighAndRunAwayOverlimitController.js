({
    doInit : function(component, event, helper) {
        var accountNumber =  component.get("v.selectedAccountNumberToFlow");
        if(accountNumber){
        accountNumber = accountNumber.slice(0,-2) + '00'; 
        component.set("v.selectedAccountNumberFromFlow", accountNumber);
        }
    },
    onNext : function(component, event, helper) {
        component.set("v.showNextButton",true);
    },
    closeCase: function(component, event, helper) {
        component.find("statusField").set("v.value", "Closed");
        component.find("descriptionField").set("v.value", "Case closed because customer has promise to pay.");
        component.find("caseEditForm").submit();
        $A.get("e.force:refreshView").fire();
    },
    handleCaseLoad: function(component, event, helper){
        component.set("v.phoneNumber", component.find("clientNumber").get("v.value"));
         component.set("v.clientName", component.find("clientName").get("v.value"));
        let modalsToDisplay = component.get("v.modalsToDisplay");
        var modalObject = new Object();
        for (var element of modalsToDisplay) {
            console.log(element);
            modalObject[element] = true;
        }
        component.set("v.modalObject", modalObject);
        
         if('ERD- Runway And Highover Limit Awaiting Response'.includes(component.find("caseType__cField").get("v.value"))){
         
           component.set("v.selectedAccountNumberToFlow", component.find("selectedAccountNumber").get("v.value"));
        }
       
        
          
        
    },
})