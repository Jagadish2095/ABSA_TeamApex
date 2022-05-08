({ 
   //Added by Diksha For Refresh
    refreshData: function(component, event, helper) {
        var accId;
         if(component.get("v.recordId") == undefined) {
            accId = component.get("v.accRecordId"); //when the component is on the NTB form
        } else {
            accId = component.get("v.recordId") //when the component is on the Account form
        }

        var UBOdetails;
        var action = component.get("c.parentAccountWrapper");
        action.setParams({"accountId" : accId,
                          "includeControllingInterest" : true
                         });
                                 action.setCallback(this, function(response) {
            
            var state = response.getState();
            if (state == "SUCCESS")
            {
                                
                var data = response.getReturnValue();
                var temojson1 = JSON.parse(JSON.stringify(data).split('Accwrplist').join('_children').split('childwrplist').join('_children'));
                component.set('v.gridData',  JSON.parse(temojson1)); 
                this.sortData(component);
                
            }else 
            {
                console.log ('error');
            }
            
            //Added an option by chandra to add Sub-Member dated 06/07/2020
            var actions = this.getRowActions.bind(this, component);
            
            var columns = [
                {
                    type: 'text',
                    fieldName: 'Shareholder',
                    label: 'Shareholder',
                    initialWidth: 200
                },
                {
                    type: 'text',
                    fieldName: 'Type',
                    label: 'Type'
                },
                {
                    type: 'number',
                    fieldName: 'ShareholderCount',
                    label: 'Shareholder Count'
                },
                {
                    type: 'decimal',
                    fieldName: 'ParentShareholding',
                    label: 'Parent Shareholding',
                    sortable: true
                },
                {
                    type: 'decimal',
                    fieldName: 'Controllinginterest',
                    label: 'Controlling interest'
                },
                {
                    type: 'text',
                    fieldName: 'UBO',
                    label: 'UBO'
                },
                {
                    type: 'action', typeAttributes: { rowActions: actions } 
                }
            ];
            
            component.set('v.gridColumns', columns);
            
        });
        
        $A.enqueueAction(action);
   },
    
    
    /****************@ Author: Chandra****************************************
 	****************@ Date: 08/07/2020****************************************
 	****************@ Work Id: W-004939***************************************
 	***@ Description: Method Added by chandra to show modal to add sub entity*/
    
    showModalToAddSubEntity : function(component, event, helper, shareholderName, accRecId, primaryEntityId) {
        var shareholderName = shareholderName;
      // alert(component.get("v.selectedRowsParentClientType"));
       console.log('parentRelationship--'+ component.get("v.parentRelationshipId"));
        $A.createComponent("c:addingSubMember", {entityName : shareholderName,
                                                 accRecId : accRecId,
                                                 primaryEntityId : primaryEntityId,
                                                 accountClientType:component.get("v.selectedRowsParentClientType"),
                                                 parentRelationshipId: component.get("v.parentRelationshipId"),
                                                 processTyperp: component.get("v.processTyperp")},
                           function(content, status) {
                               if (status === "SUCCESS") {
                                   component.find('overlayLib').showCustomModal({
                                       header: "Add a Sub-Entity",
                                       body: content,
                                       showCloseButton: true,
                                       cssClass: "mymodal",
                                       closeCallback: function() {
                                       }
                                   })
                               }
                           });
    },
    
    /****************@ Author: Chandra****************************************
 	****************@ Date: 08/07/2020****************************************
 	****************@ Work Id: W-004939***************************************
 	***@ Description: Method Added by chandra to Delete sub entity************/
    
    handleDeleteRecord: function(component, event, helper) {
        component.find("recordToDelete").deleteRecord($A.getCallback(function(deleteResult) {
            if (deleteResult.state === "SUCCESS" || deleteResult.state === "DRAFT") {
                console.log("Record is deleted.");
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "title": "Deleted",
                    "message": "The record was deleted."
                });
                resultsToast.fire();
                component.set("v.showDeleteRelationshipConfirmation",false);
            }
            else if (deleteResult.state === "INCOMPLETE") {
                console.log("User is offline, device doesn't support drafts.");
            }
                else if (deleteResult.state === "ERROR") {
                    console.log('Problem deleting record, error: ' +
                                JSON.stringify(deleteResult.error));
                }
                    else {
                        console.log('Unknown problem, state: ' + deleteResult.state +
                                    ', error: ' + JSON.stringify(deleteResult.error));
                    }
        }));
    } ,
    
    /****************@ Author: Chandra****************************************
 	****************@ Date: 08/07/2020****************************************
 	****************@ Work Id: W-004939***************************************
 	***@ Description: Method Added by chandra to set action******************/
    getRowActions : function (component, row, doneCallback) {
        var actions ;
        
        if (row['accType'] == 'AccountContact') {
            
            actions = [  
            { label: 'View', name: 'view' },
            { label: 'Edit', name: 'edit' },
            { label: 'Delete', name: 'delete' }
        	];
        }
        
        if (row['accType'] == 'AccountAccount') {
            
            actions = [  
            { label: 'Add a Sub-Member', name: 'add_a_submember'},
            { label: 'View', name: 'view' },
            { label: 'Edit', name: 'edit' },
            { label: 'Delete', name: 'delete' }
        	];
        } 
        
        setTimeout($A.getCallback(function () {
        doneCallback(actions);
        }), 200);
    },
    
    /****************@ Author: Chandra****************************************
 	****************@ Date: 16/07/2020****************************************
 	****************@ Work Id: W-004945***************************************
 	***@ Description: Method Added by chandra to calculate controlling perct*/
    
    calculateControllingPercentageforAccAccRel: function (component, event, helper, recordId, sharePercentage, roles) {
        var action = component.get("c.parentAccountWrapper");
        action.setParams({
            "accountId": recordId,
            "includeControllingInterest" : true
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var retVal = response.getReturnValue();
            if (state === "SUCCESS") {
                this.hideSpinner(component);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "Record is updated successfully.",
                    "type":"success"
                });
                toastEvent.fire();
                component.set("v.showRelationshipEdit", false);
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);
    },
    
    /****************@ Author: Chandra****************************************
 	****************@ Date: 16/07/2020****************************************
 	****************@ Work Id: W-004945***************************************
 	***@ Description: Method Added by chandra to calculate controlling perct*/
    
    deleteRelatedHierarchyRecords: function (component, event, helper, recordId) {
     //   var action = component.get("c.deleteRelatedHierarchyRecords");
     //   action.setParams({
     //       "accAccRelId": recordId
     //   });
        var action = component.get("c.calculateControllingInterest");
         action.setParams({
            "relPartyId": recordId,
            "deletionRec": recordId,
            "primaryEntityId": component.get("v.deleteRowPrimaryEntityId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var retVal = response.getReturnValue();
            if (state === "SUCCESS") {
                this.hideSpinner(component);
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "title": "Deleted",
                    "message": "The record was deleted."
                });
                resultsToast.fire();
                component.set("v.showDeleteRelationshipConfirmation",false);
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);
    },
    
    sortData: function (component, fieldName, sortDirection) {
        var data = component.get("v.gridData");
        var reverse = sortDirection !== 'desc';
        data.sort(this.sortBy(fieldName, reverse));
        component.set("v.gridData", data);
    },
    sortBy: function (field, reverse, primer) {
        var key = primer ?
            function(x) {return primer(x[field])} :
            function(x) {return x[field]};
        reverse = !reverse ? 1 : -1;
        return function (a, b) {
            return a = key(a), b = key(b), reverse * ((a > b) - (b > a));
        }
    },
    
    /****************@ Author: Chandra*****************************************
 	****************@ Date: 16/07/2020*****************************************
 	****************@ Work Id: W-004945****************************************
 	***@ Description: Method Added by chandra to Re-Evaluate Controlling Perct*/
    
    reEvaluateControllingPercentage: function (component, event, helper, recordId) {
      console.log("recordId " + recordId);
      console.log("deleteRowPrimaryEntityId " + component.get("v.deleteRowPrimaryEntityId"));
      //  var action = component.get("c.reEvaluateControllingPercentage");
       //  action.setParams({
       //     "recordId": recordId,
       //     "primaryEntityId" : component.get("v.primaryEntityId")
      // });   
        
        var action = component.get("c.deleteAccConRecord");
        action.setParams({
            "Id": recordId,
            "deletionRec": recordId,
            "primaryEntityId" : component.get("v.deleteRowPrimaryEntityId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var retVal = response.getReturnValue();
            if (state === "SUCCESS") {
                
                console.log("Success " + state);
                this.handleDeleteRecord(component, event, helper);
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);
    },
    
    /****************@ Author: Chandra*****************************************
 	****************@ Date: 16/07/2020*****************************************
 	****************@ Work Id: W-004945****************************************
    ****************Function to show spinner when loading**********************/
    showSpinner: function(component) {
        var spinner = component.find("TheSpinner");
        $A.util.removeClass(spinner, "slds-hide");
    },
    
    /****************@ Author: Chandra*****************************************
 	****************@ Date: 16/07/2020*****************************************
 	****************@ Work Id: W-004945****************************************
    ****************Function to hide spinner after loading**********************/
    hideSpinner: function(component) {
        var spinner = component.find("TheSpinner");
        $A.util.addClass(spinner, "slds-hide");
    },
     // W-008562
     getOpportunityStage: function (component, event, helper, accId) {
        var action = component.get("c.opportunityStage");
        action.setParams({
            "accountId": accId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var retVal = response.getReturnValue();
                console.log("Success " + state);
                component.set("v.OppStage",retVal);
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);
    }, 
    // W-8562 - Closed opportunity validation
    closedOpportunityValidation : function(component, event, helper) {
        
       var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type":"error",
                "title": "Error!",
                "message": "You are not allowed to update application record as it is associated with closed opportunity"
            });
       toastEvent.fire();
    },  
   
})