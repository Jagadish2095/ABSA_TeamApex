({
      getCMSContrOffcRecs : function(component, event, helper) {
       
        var oppRecId = component.get("v.recordId");
        //var oppRecId = '0061x00000IzzPgAAJ';
        
        if (oppRecId) {
            var action = component.get("c.displayContrOffcRecs");  //get all records
            
            action.setParams({
                oppRecId : oppRecId
            });
           
            // Add callback behavior for when response is received
            action.setCallback(this, function(response) {
                var state = response.getState();
                // alert('state'+state);
                if (component.isValid() && state === "SUCCESS") {
                    var ContrOffcRecs = response.getReturnValue();
                    component.set("v.contOffcList", ContrOffcRecs); 
                    component.find("dtTable").set("v.selectedRows", component.get('v.preSelectedRows'));
                    
                }
            });     
            $A.enqueueAction(action);
        }
    },
  /*
    handleSaveEdition:function(cmp, event, helper) {
        
        var draftValues = event.getParam('draftValues');
        console.log(draftValues);
        var action = cmp.get("c.updateAddress");
        action.setParams({"add" : draftValues});
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                cmp.set("v.addList",[]); 
                cmp.set('v.columns', []);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                        "message": "Address has been Successfully Refreshed.",
                        "type":"success"
                    });
             toastEvent.fire();
                 var action2 = cmp.get("c.displayAddresses");  
                 action2.setParams({
                     accRecId : cmp.get("v.accRecId")
                 });
                 
                 
                 action2.setCallback(this, function(response2) {
                     var state2 = response.getState();
                     if (cmp.isValid() && state2 === "SUCCESS") {
                         var addList = response2.getReturnValue();
                         cmp.set('v.columns', [
                             {label: 'Street', fieldName: 'Shipping_Street__c', type: 'text' ,editable: true},
                             {label: 'Suburb', fieldName: 'Shipping_Suburb__c', type: 'text' ,editable: true},
                             {label: 'City', fieldName: 'Shipping_City__c', type: 'text' ,editable: true},
                          //{label: 'State/Province', fieldName: 'Shipping_State_Province__c', type: 'text' ,editable: true},//W-006583
                             {label: 'Country', fieldName: 'Shipping_Country__c', type: 'text' ,editable: true},
                             {label: 'Zip Postal code', fieldName: 'Shipping_Zip_Postal_Code__c', type: 'text' ,editable: true},
                             {label: 'Address Type', fieldName: 'Address_Type__c', type: 'text' ,editable: false}
                             
                         ]);
                         cmp.set("v.addList",addList); 
                         
                     }
                 });     
                 $A.enqueueAction(action2); 
             }
            else {
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "An error occured while updating address, please try again.",
                    "type":"error"
                });
                toastEvent.fire();
            }
            
        });
        $A.enqueueAction(action);       
    },    */
    
    deleteRecord: function (component, row) {
        var rows = component.get('v.contOffcList');
        var rowIndex = rows.indexOf(row);

        rows.splice(rowIndex, 1);
        component.set('v.contOffcList', rows);
    },
  

    //Show lightning spinner
    showSpinner: function (component) {
        var spinner = component.find("ltngSpinner");
        $A.util.removeClass(spinner, "slds-hide");
    },

    //Hide lightning spinner
    hideSpinner: function (component) {
        var spinner = component.find("ltngSpinner");
        $A.util.addClass(spinner, "slds-hide");
    },

    //Lightning toastie
    fireToast : function(title, msg, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title":title,
            "message":msg,
            "type":type
        });
        toastEvent.fire();
    },
                             
     //Function to show toast for Errors/Warning/Success
      getToast: function(title, msg, type) {
        var toastEvent = $A.get("e.force:showToast");
    
        toastEvent.setParams({
          title: title,
          message: msg,
          type: type
        });
    
        return toastEvent;
      },
    
    submitforCMSLinkingHelper: function(component, event, helper) {
        this.showSpinner(component);
        var checkselectedRowsIdsList = component.get("v.selectedRowsIdsList");
        console.log('checkselectedRowsIdsList -> ' + checkselectedRowsIdsList.length);
        var action = component.get("c.linkBankersSelected");
        action.setParams({oppId:component.get("v.recordId"),
                          contOffcRecs: checkselectedRowsIdsList
                          });
        action.setCallback(this, function(response) {
            this.hideSpinner(component); //hide the spinner
            var state = response.getState();
            if (state === "SUCCESS") {
                var respmsg = response.getReturnValue();
                console.log('respmsg '+JSON.stringify(respmsg));
                console.log('length '+respmsg.length);
                if(respmsg!=null & respmsg.length >= 1){
                    var errormsgs='';
                    var i;
                    for (i in respmsg) {
                        errormsgs += respmsg[i] + ";";
                    }
                 var toastEvent = this.getToast("Info!", errormsgs, "warning");   
                    toastEvent.fire();
                //var CMSResponse = response.getReturnValue();
                //console.log('returnValue' + JSON.stringify(CMSResponse));
               /* if(CMSResponse != null && CMSResponse.length > 0){
                     var toastEvent = this.getToast("Info!", errormsgs, "warning");
                }*/
                }    
                else{
                     var toastEvent = this.getToast("Success!", 'Banker is Linked to Account', "Success");
                    toastEvent.fire();
                   
                }
            }    
           this.hideSpinner(component);
        });
        $A.enqueueAction(action);
    },
    deleteRecordsHelper: function(component, event, helper) {
        this.showSpinner(component);
        var checkselectedRowsIdsList = component.get("v.selectedRowsIdsList");
        console.log('checkselectedRowsIdsList215 -> ' + checkselectedRowsIdsList);
        var action = component.get("c.deleteCMSContrOffcRecs");
        action.setParams({oppId:component.get("v.recordId"),
                          contOffcRecsIds: checkselectedRowsIdsList
                          });
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            //alert('state224--'+state);
            if (state === "SUCCESS") {
                var Response = response.getReturnValue();
                console.log('returnValue224' + JSON.stringify(Response));
                debugger;
                if(Response == 'success'){
                    var toastEvent = this.getToast("Success!", 'Control Officer Record successfully deleted', "Success");
                  
                }
                else{
                     var toastEvent = this.getToast("Info!", Response, "warning");
                }
                
            }else{
                var toastEvent = this.getToast("Error!", 'Something went wrong.', "error");
                 
                  
            }
             toastEvent.fire();
            this.hideSpinner(component); //hide the spinner
        });
        $A.enqueueAction(action);
    },
    //W-008562
    fetchOpportunityStage  : function (component) {
        var action = component.get("c.validateOpportunityStage");
       action.setParams({
           recordId: component.get("v.recordId")
       });
       action.setCallback(this, function(response) {
           console.log('state '+response.getState());
           var state = response.getState();
           if (state === "SUCCESS") {
               console.log('stage '+response.getReturnValue());
               var stage = response.getReturnValue();
                component.set("v.oppStage", stage);
                
           }
            });
       $A.enqueueAction(action);
   },   
})