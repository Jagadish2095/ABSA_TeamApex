({
    handleCaseLoad: function(component, event, helper) {
             component.set("v.phoneNumber",  component.find("clientNumber").get("v.value"));
         if(component.find("originalServiceGroupId").get("v.value") ==='Everyday Banking - Collections' &&
              component.find("type").get("v.value")=== 'Service Request'){
                   component.set("v.firstFraud", true);
                    let button = component.find('previousButton');
                                         button.set('v.disabled',true);
              }
              if(component.find("originalServiceGroupId").get("v.value") ==='Everyday Banking - Collections' &&
                            component.find("type").get("v.value")=== 'Early risk detection- Possible fraud detection'){
                   //converting plastic number to accountNumber
                   let accountNumber = component.get("v.selectedAccountNumberToFlow")
                   accountNumber = accountNumber.slice(0, -2) + '00';
                   component.set("v.selectedAccountNumberToFlow", accountNumber);
              }
                if(component.find("originalServiceGroupId").get("v.value") ==='Everyday Banking - Collections' &&
                                          component.find("type").get("v.value")=== 'Early Risk Detection Awaiting'){
                                          component.set("v.awaitingCase", true);
                                          component.set("v.openCollectionCycle", false);
                                          component.set("v.openDocument", false);
                                          component.set("v.openContactWithCustomer", true);
                                          }
        let modalsToDisplay = component.get("v.modalsToDisplay");
        var modalObject = new Object();
        for (var element of modalsToDisplay) {
            console.log(element);
            modalObject[element] = true;
        }
        component.set("v.modalObject", modalObject);
        component.set("v.phoneNumber", component.find("clientNumber").get("v.value"))
        component.set("v.proofOfId", null)
    },

    onPrevious: function(component, event, helper) {
        if(component.get("v.openCollectionCycle")===true){
          var navigate = component.get("v.navigateFlow");
                navigate("BACK");
        }
        else   if(component.get("v.openDocument")===true){
          component.set("v.openDocument",false);
          component.set("v.openCollectionCycle",true);
          component.set("v.showNextButton",true);
          if(component.get("v.firstFraud")===true){
               let button = component.find('previousButton');
               button.set('v.disabled',true);
          }
          }
           else  if(component.get("v.openContactWithCustomer")===true){
          component.set("v.openDocument",true);
          component.set("v.openContactWithCustomer",false);
          component.set("v.showNextButton",true);
            component.set("v.selectedValueSMSNumber", '');
           component.set("v.getDateFromCalendar", '');
           component.set("v.firstFraud", false);
          }
    },

    onNext: function(component, event, helper) {
         if(component.get("v.openCollectionCycle")===true){
        component.set("v.openCollectionCycle", false);
        component.set("v.openDocument", true);
           component.set("v.showNextButton", false);
            let button = component.find('previousButton');
            button.set('v.disabled',false);
        }
        else  if(component.get("v.openDocument")===true){

        component.set("v.openDocument", false);
        component.set("v.openContactWithCustomer", true);
         component.set("v.showNextButton", false);
         component.set("v.showEscalateButton", false);
         component.set("v.firstFraud", true);
        }
    },
    closeSecondPart: function(component, event, helper) {
        component.set("v.closeSecondPart", true);
        component.set("v.openContactWithCustomer", false);
    },
    closeCase: function(component, event, helper) {
             component.find("statusField").set("v.value", "Closed");
                      component.find("outOfSLA").set("v.value", "case closed");
                      component.find("outOfSLAReason").set("v.value", "Turn-around Times/SLA");
                      component.find("caseOutcome").set("v.value", component.get("v.valueCaseOutcome"));
                     component.find("caseEditForm").submit();
                     $A.get('e.force:refreshView').fire();
    },
    hideButtons: function(component, event, helper) {
        component.set("v.selectedValueSMSNumber", '');
        component.set("v.getDateFromCalendar", '');
    },


    sendSMS: function(component, event, helper) {
        component.set("v.openDocument", true);
        component.set("v.openContactWithCustomer", false);
        helper.handleSendSms(component, event);
    },

    handleChange: function(component, event, helper) {
        var changeValue = event.getParam("value");
        if (changeValue === 'true') {
            component.set("v.showNextButton", true);
        } else {
            component.set("v.showNextButton", false);
        }
    },

    getDate: function(component, event, helper) {
        component.set("v.createReminderButtonNext", true)
    },

   handleCaseError: function(component, event, helper) {
        var error = event.getParams();
          var errorMessage = event.getParam("message");
    },
    handleChangeCallingCustomer: function(component, event, helper) {
        var changeValue = event.getParam("value");
        if (changeValue === 'true') {
            component.set("v.showSelectNotificationNumber", false);
            component.set("v.showCaseOutcome", true);
        } else {
            component.set("v.showCaseOutcome", false);
            component.set("v.showSelectNotificationNumber", true);
            component.set("v.createEventSendSMS", true);
        }
    },

    changeCaseOwner: function(component, event, helper) {
        helper.changeOwnerOfCase(component, event, helper);
    },
    handleContactMethod: function(component, event, helper) {
        var changeValue = component.find("picklistContactMethod");
        changeValue = Array.isArray(changeValue) ? changeValue[0].get("v.value") : changeValue.get("v.value");
        if(changeValue==='Send an SMS'){
            component.set("v.showCaseOutcome", false)
             component.set("v.createEventSendSMS", false);
        }else{

              component.set("v.showCaseOutcome", true)
              component.set("v.valueFromCallingCustomer", true)
              component.set("v.showSelectNotificationNumber", false)
        }
    },

    createEvent: function(component, event, helper) {
        helper.createEvent(component, event, helper);
    },

    getSupportingDocuments: function(component, event, helper) {
        let itWasRetreved = component.get("v.itWasRetreved");
        console.log(itWasRetreved);
        if (itWasRetreved === false) {
            helper.getSupportingDocuments(component, event);
        }
    },

    openIframe: function(component, event, helper) {
        var selectedDocumentId = event.target.getAttribute("data-produto");
        component.set("v.selectedDocumentId", selectedDocumentId);
    },

    closeSelectedDocumentViewer: function(component, event, helper) {
        component.set("v.selectedDocumentId", null);
    },
    sendSMSAndCreateReminder: function(component, event, helper) {
      helper.sendSMSAndCreateReminder(component, event, helper);
    },
});