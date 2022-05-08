({
    getMainEntityMandatoryDocs: function (component, event, helper) {

        var action = component.get("c.getAlDocuments");

        action.setParams({
          "opportunityId": component.get("v.recordId")
        });
        action.setCallback(this, function (response) {
          var state = response.getState();

          if (state === "SUCCESS") {
            var responsevalue = response.getReturnValue();

            console.log("DOc List" + responsevalue);
              
               responsevalue.forEach(function(record){
                   
                    record.linkName = '/servlet/servlet.FileDownload?file='+record.File_Id__c;
                });
            component.set("v.documentsList", responsevalue);
          } else if (state === "ERROR") {
            var errors = response.getError();

            if (errors) {
              if (errors[0] && errors[0].message) {
                console.log("Error message: " + errors[0].message);
              }
            } else {
              console.log("Unknown error");
            }
          }
        });
        $A.enqueueAction(action);
      },
    getRelatedEntityMandatoryDocs: function (component, event, helper) {

        var action = component.get("c.getAlRelatedEntityDocuments");

        action.setParams({
          "opportunityId": component.get("v.recordId")
        });
        action.setCallback(this, function (response) {
          var state = response.getState();

          if (state === "SUCCESS") {
            var responsevalue = response.getReturnValue();

            console.log("DOc List" + responsevalue);
            component.set("v.realetedPartydocumentsList", responsevalue);
              
          } else if (state === "ERROR") {
            var errors = response.getError();

            if (errors) {
              if (errors[0] && errors[0].message) {
                console.log("Error message: " + errors[0].message);
              }
            } else {
              console.log("Unknown error");
            }
          }
        });
        $A.enqueueAction(action);
      },
    getRelatedEntityMandatoryDocsforAccount: function (component, event, helper) {

        var action = component.get("c.getAlRelatedEntityDocumentsforaccount");

        action.setParams({
          "AccountId": component.get("v.recordId")
        });
        action.setCallback(this, function (response) {
          var state = response.getState();

          if (state === "SUCCESS") {
            var responsevalue = response.getReturnValue();

            console.log("DOc List" + responsevalue);
            component.set("v.realetedPartydocumentsList", responsevalue);
              
          } else if (state === "ERROR") {
            var errors = response.getError();

            if (errors) {
              if (errors[0] && errors[0].message) {
                console.log("Error message: " + errors[0].message);
              }
            } else {
              console.log("Unknown error");
            }
          }
        });
        $A.enqueueAction(action);
      },
        getRelatedEntityMandatoryDocsforCase: function (component, event, helper) {

        var action = component.get("c.getAlRelatedEntityDocumentsforcase");

        action.setParams({
          "caseId": component.get("v.recordId")
        });
        action.setCallback(this, function (response) {
          var state = response.getState();

          if (state === "SUCCESS") {
            var responsevalue = response.getReturnValue();

            console.log("DOc List" + responsevalue);
            component.set("v.realetedPartydocumentsList", responsevalue);
              
          } else if (state === "ERROR") {
            var errors = response.getError();

            if (errors) {
              if (errors[0] && errors[0].message) {
                console.log("Error message: " + errors[0].message);
              }
            } else {
              console.log("Unknown error");
            }
          }
        });
        $A.enqueueAction(action);
      },
     refresh: function (component) {
        var action = component.get("c.dummyRefresh");
        action.setCallback(this, function(response) {
            var state = response.getState();
             if (state === 'SUCCESS'){
                $A.get('e.force:refreshView').fire();
            } else {
                 //do something
            }
        });
        $A.enqueueAction(action);
       // $A.get('e.force:refreshView').fire();
    },


})