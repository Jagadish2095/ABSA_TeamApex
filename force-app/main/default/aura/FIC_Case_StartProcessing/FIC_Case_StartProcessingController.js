({
       doInit: function(component, event, helper) {


       
       },
    redirectToCase  : function(component,event,helper) {

        let cases=component.get("v.queueCases")
      //  let buttonLabel = component.get("v.typeOfButton");
        if( component.get("v.typeOfButton") == 'New'){

                    var navigateEvent = $A.get("e.force:navigateToComponent");
                    navigateEvent.setParams({
                        componentDef: "c:CaseOverride",
                        componentAttributes : {
                              recordId : cases[0].Id,
                         }

                    });
                    navigateEvent.fire();

        }
        if( component.get("v.typeOfButton") == 'Change case owner'){

            component.set("v.showChangeOwnerModal" , true);

        }
        else{
             component.set("v.showSpinner", true)
            helper.openCase(component,event,helper, cases[0]);
        }
    },
closeModal : function(component,event,helper) {
component.set("v.showChangeOwnerModal" , false);
},

handleSaveButton : function(component,event,helper) {
   helper.changeCaseOwner(component,event, helper);
  },

    handleComponentEvent : function(component, event, helper) {

        //Get the selected sObject record from the component event
        var selectedsObjectGetFromEvent = event.getParam("recordByEvent");
        component.set("v.selectedLookUpRecord" , selectedsObjectGetFromEvent);



	},

})