({
     openCase: function(component,event, helper, cases) {
             var action = component.get("c.assignToUser");

            action.setParams({
                   "caseToAssign": cases,
             });
             action.setCallback(this, function(response) {
              //store state of response
              var state = response.getState();
               if (state === "SUCCESS") {

                    component.set("v.showSpinner", false)
               var navEvt = $A.get("e.force:navigateToSObject");
                 navEvt.setParams({
                    "recordId": cases.Id,
                });
                 navEvt.fire();
              }
              });
          $A.enqueueAction(action);
        },


     changeCaseOwner: function(component,event, helper) {
	let priority = component.find("PriorityCase").get("v.value");
     let comment = component.find("CommentsCase").get("v.value");
     let status = component.find("StatusCase").get("v.value");
        console.log('priority' + priority)
        console.log('comment' + comment)

        let caseToChange = component.get("v.selectedCase")
            caseToChange.Priority= priority
            caseToChange.Comments__c= comment
            caseToChange.Status= status
            console.log(caseToChange)
          var action = component.get("c.changeCaseOwner");
        console.log('start')
          console.log(caseToChange)
                    action.setParams({
                           "caseToChange": caseToChange,
                           "userId" : component.get("v.selectedLookUpRecord").Id
                     });
                     action.setCallback(this, function(response) {
                      //store state of response
                      var state = response.getState();
                       if (state === "SUCCESS") {
                        component.set("v.showChangeOwnerModal", false)
                      }
                      });
                  $A.enqueueAction(action);

     }
})