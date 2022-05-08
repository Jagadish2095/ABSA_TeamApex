({
    doInit : function(component, event, helper) {
           // get the fields API name and pass it to helper function
           var controllingFieldAPI = component.get("v.controllingFieldAPI");
           var dependingFieldAPI = component.get("v.dependingFieldAPI");
           var objDetails = component.get("v.objDetail");
           // call the helper function
           helper.fetchPicklistValues(component, event, helper);
       },

   isRefreshed: function(component, event, helper) {
       component.find("controllerFldSelect").set("v.value","--- None ---");
       component.find("dependentFldSelect").set("v.value","--- None ---");
       component.set("v.bDisabledDependentFld" , true);
       component.set("v.bDisabledSave" , true);
       helper.fetchPicklistValues(component, event, helper);
   },

       onControllerFieldChange: function(component, event, helper) {
           var controllerValueKey = event.getSource().get("v.value"); // get selected controller field value
           var depnedentFieldMap = component.get("v.depnedentFieldMap");

           if (controllerValueKey != '--- None ---') {
               component.set("v.bDisabledSave" , false);
               var ListOfDependentFields = depnedentFieldMap[controllerValueKey];

               if(component.find("controllerFldSelect").get("v.value") === 'Call Back'){
                   console.log( 'iscallback 1 >>>' + component.get("v.isCallBack"));
                   component.set("v.isCallBack" , true);

               }else {
                   component.set("v.isCallBack" , false);
                   console.log( 'iscallback3 >>>' + component.get("v.isCallBack"));
               }

               if(ListOfDependentFields.length > 0){
                   component.set("v.bDisabledDependentFld" , false);
                   component.set("v.bDisabledSave" , true);
                   helper.fetchDepValues(component, ListOfDependentFields);

               }else{
                   component.set("v.bDisabledDependentFld" , true);
                   component.set("v.listDependingValues", ['--- None ---']);
                   component.set("v.bDisabledSave" , false);
               }

           } else {
               component.set("v.listDependingValues", ['--- None ---']);
               component.set("v.bDisabledDependentFld" , true);
                component.set("v.isCallBack" , false);
                component.set("v.bDisabledSave" , true);
           }
       },

       onDependentFieldChange: function(component, event, helper) {
           var callReason = component.find("dependentFldSelect").get("v.value");
           var isDisabled = component.get("v.bDisabledDependentFld");

           console.log('isDisabled >>>' + isDisabled);
           console.log('callReason >>>' + callReason);


           if(isDisabled === true){
              component.set("v.bDisabledSave" , false);
           } else
           if(callReason === '--- None ---' &&  isDisabled === false){
                component.set("v.bDisabledSave" , true);
           } else {
               component.set("v.bDisabledSave" , false);
           }
       },


       onLanguageFieldChange: function(component, event, helper) {
          var selectedLang = component.find("lang").get("v.value");
          if(selectedLang != ''){
               component.set("v.bDisabledSave" , false);
          } else {
              component.set("v.bDisabledSave" , true);
          }

       },

       saveData: function(component, event, helper){

                   var callOutcome = component.find("controllerFldSelect").get("v.value");
                   var callReason = component.find("dependentFldSelect").get("v.value");
                   var calldatetime;
                   var callLanguage;
                   //showSpinner(component, event, helper);
                   component.set("v.spinner", true);

                   if(component.get("v.isCallBack" ) == true){
                       calldatetime = component.find("calldate").get("v.value");
                       callLanguage = component.find("lang").get("v.value");

                       if(calldatetime === null || calldatetime === ''){
                           calldatetime = null;
                       }
                       if( calldatetime === ''){
                           calldatetime = null;
                       }

                   }else{
                      calldatetime = null;
                      callLanguage = '';
                   }

                   var recId = component.get("v.recordId");
                   var action = component.get("c.saveOutcome");
                    action.setParams({
                           "recordId" : recId,
                           "outcome" : callOutcome,
                           "reason" : callReason,
                           "callBackTime" : calldatetime,
                           "callBackLanguage" : callLanguage

                       });

                       action.setCallback(this, function(response) {
                       if (response.getState() == "SUCCESS") {
                           var StoreResponse = response.getReturnValue();
                           $A.get('e.force:refreshView').fire();
                           component.find("controllerFldSelect").set("v.value","--- None ---");
                           component.find("dependentFldSelect").set("v.value","--- None ---");
                           component.set("v.isCallBack" , false);
                           component.set("v.bDisabledSave" , true);
                           component.set("v.bDisabledDependentFld" , true);
                           //hideSpinner(component, event, helper);
                           component.set("v.spinner", false);
                           var toastEvent = $A.get("e.force:showToast");
                                toastEvent.setParams({
                                    "title": "Success!",
                                    "message": "Task created successfully",
                                    "type":"success"
                                });
                                toastEvent.fire();

                       }else {
                           var state = response.getState();
                            console.log("Failed with state: " + state);
                            var errors = response.getError();
                            var errorMessage = 'An error has occurred: \n' + errors[0].message;
                            //hideSpinner(component, event, helper);
                            component.set("v.spinner", false);
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                "title": "Error!",
                                "message": errorMessage,
                                "type":"error"
                            });
                            toastEvent.fire();
                        }
                   });
                   $A.enqueueAction(action);

                  },
      showSpinner: function(component, event, helper) {
              component.set("v.spinner", true);
          },

          hideSpinner : function(component,event,helper){
              component.set("v.spinner", false);
          }
});