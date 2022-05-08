({
     init: function (component, event, helper) {
         var actions = [
             { label: 'Edit Details', name: 'edit_details' }
            
         ];
         component.set('v.columns', [
             {label: 'Control Officer Type', fieldName: 'Control_Officer_Type__c', type: '' ,editable: false},
             {label: 'Control Officer Number', fieldName: 'Control_Officer_Number__c', type: 'text' ,editable: false},
             {label: 'Branch/Region Site', fieldName: 'Branch_Region_Site__c', type: 'text' ,editable: false},
             {label: 'Group or Individual', fieldName: 'Group_or_Individual__c', type: 'text' ,editable: false},
             {label: 'Captured by Employee', fieldName: 'Captured_by_Employee__c', type: 'text' ,editable: false},
             { type: 'action', typeAttributes: { rowActions: actions }}
              
              ]);
        helper.getCMSContrOffcRecs(component,event, helper);
        //helper.getAccountDetails(component,event, helper);
        helper.fetchOpportunityStage(component);// W-08562
    }, 
    
    doAction : function(component, event, helper) {
        // PJAIN: 20200530: Minor logic change
        var methodArguments = event.getParam('arguments');

        if (methodArguments) {
            var accRecId = methodArguments.accId; //params
            component.set("v.accRecId", accRecId);
            helper.getAddresses(component, event, helper);
        }
    },
            
  
            
    handleSave : function(component, event, helper) {
        //helper.handleSaveEdition(component, event, helper);        
    },
            
    createNewCntrOffcRecord : function (component, event, helper) {
      //W-008562
      if(component.get("v.oppStage") == 'Closed'){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type":"error",
            "title": "Error!",
            "message": "You are not allowed to add new control officers as it is associated with closed opportunity"
        });
        toastEvent.fire();
    }else{
        var oppRecId = component.get("v.recordId");
        var contOffcRec = component.get("v.contOffcRecord");
        var flag = false;
       
        if(contOffcRec.Control_Officer_Type__c != '' && contOffcRec.Control_Officer_Type__c != undefined && contOffcRec.Control_Officer_Type__c  != null &&
          contOffcRec.Control_Officer_Number__c != '' && contOffcRec.Control_Officer_Number__c != undefined && contOffcRec.Control_Officer_Number__c != null ){
            flag = true;
        }
           if(!flag){
            var toast = helper.getToast('Required field', 'Please fill all required fields.', 'error');
            toast.fire();
            return null;
        }
		 //var newcontOffcRecord = component.get("v.contOffcRecord");
        //Calling the Apex Function to create Contact
        var createNewCntrOffcAction = component.get("c.createNewCntrOffcRec");
    
        //Setting the Apex Parameter
        createNewCntrOffcAction.setParams({
          	newCntrOffcRecord: contOffcRec,
            oppRecId : oppRecId
        });
    
        //Setting the Callback
        createNewCntrOffcAction.setCallback(this, function(response) {
          var stateCase = response.getState();
          if (stateCase === "SUCCESS") {
           		var allrecordsList = response.getReturnValue();
                component.set("v.contOffcList",allrecordsList);
               component.set("v.showNewContOffcModal", false);
              var toastEvent = helper.getToast("Success!", 'Control Officer Details successfully created', "Success");
            toastEvent.fire();
              
          } else if (stateCase === "ERROR") {
            var message = "";
            var errors = response.getError();
            if (errors) {
              for (var i = 0; i < errors.length; i++) {
                for (
                  var j = 0;
                  errors[i].pageErrors && j < errors[i].pageErrors.length;
                  j++
                ) {
                  message +=
                    (message.length > 0 ? "\n" : "") +
                    errors[i].pageErrors[j].message;
                }
                if (errors[i].fieldErrors) {
                  for (var fieldError in errors[i].fieldErrors) {
                    var thisFieldError = errors[i].fieldErrors[fieldError];
                    for (var j = 0; j < thisFieldError.length; j++) {
                      message +=
                        (message.length > 0 ? "\n" : "") +
                        thisFieldError[j].message;
                    }
                  }
                }
                if (errors[i].message) {
                  message += (message.length > 0 ? "\n" : "") + errors[i].message;
                }
              }
            } else {
              message += (message.length > 0 ? "\n" : "") + "Unknown error";
            }
    
            // show Error message
            var toastEvent = helper.getToast("Error!", message, "Error");
            toastEvent.fire();
    
            //helper.hideSpinner(component);
          }
        });
    
        //adds the server-side action to the queue
        $A.enqueueAction(createNewCntrOffcAction);
    }  
	},
    
    openNewContOffcModal : function(component, event, helper) {
        component.set("v.contOffcRecord");
        component.set("v.showNewContOffcModal", true);
    },        
            
    closeNewContOffcModal : function(component, event, helper) {
        component.set("v.showNewContOffcModal", false);       
    },
    
   // Added method to set attribute whenever the selection changes
    handleRowSelectionChange : function(component, event, helper) {
        var selectedRows = event.getParam('selectedRows');
        component.set('v.selectedRows', selectedRows);
        var selectedRowsIds = [];
        for(var i=0;i<selectedRows.length;i++){
            selectedRowsIds.push(selectedRows[i].Id); 
            component.set("v.selectedRowsIdsList", selectedRowsIds);
        }  
        var checkselectedRowsIdsList = component.get("v.selectedRowsIdsList");
        console.log('checkselectedRowsIdsList -> ' + checkselectedRowsIdsList);
    },
    handleRowAction: function (component, event, helper) {
        var action = event.getParam('action');
        switch (action.name) {
            case 'edit_details':
                var row = event.getParam('row');
                /*var editRecordEvent = $A.get("e.force:editRecord");
                editRecordEvent.setParams({
                    "recordId": row.Id
                });
                editRecordEvent.fire();  */
                component.set("v.contOffcEditRecId",row.Id);
                component.set("v.showEditcontOffcModal",true);
            	break;
        }
    },
    refreshRecords : function (component, event, helper) {
        helper.getCMSContrOffcRecs(component,event, helper);
    },
    editContOffcRecord: function (component, event, helper) {
       //W-008562
       if(component.get("v.oppStage") == 'Closed'){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type":"error",
            "title": "Error!",
            "message": "You are not allowed to update control officers information as it is associated with closed opportunity"
        });
        toastEvent.fire();
    }else{
        var ControlOfficerType = component.find("ControlOfficerType").get("v.value");
        var ControlOfficerNumber = component.find("ControlOfficerNumber").get("v.value");

        var flag = false;
        if(ControlOfficerType != null && ControlOfficerType != undefined && ControlOfficerType !='' &&
          ControlOfficerNumber != null && ControlOfficerNumber != undefined && ControlOfficerNumber !=''){
           flag = true;
        }
        if(!flag){
            var toast = helper.getToast('Required field', 'Please fill all required fields.', 'error');
            toast.fire();
            return null;
        }
        var editForm = component.find("editRecordForm");
        editForm.submit();
      }
    },
    closeContOffcModal: function (component, event, helper) {
         component.set("v.showEditcontOffcModal",false);
    },
    handleOnSuccess: function (component, event, helper) {
        component.set("v.showEditcontOffcModal",false);
        var toastEvent = helper.getToast("Success!", 'Control Officer Details successfully updated', "Success");
        toastEvent.fire();
    },
    handleOnLoad: function (component, event, helper) {
        
      
    },
    
    handleClientTypeChange: function (component, event, helper) {
        var selectedval = event.getSource().get("v.value");
        helper.getAddressTypes(component, event, selectedval);
    },
    renderFields: function(component, event, helper) {
        var officerType;
        if(component.get("v.showEditcontOffcModal") == true){
            officerType = component.find("ControlOfficerType");
        }else if(component.get("v.showNewContOffcModal") == true){
            officerType = component.find("ControlOfficerTypeNew");
        }
       
         console.log('officerType'+officerType);
        var officervalue = officerType.get("v.value");
         console.log('officervalue'+officervalue);

        
        if (officervalue == "CM – CREDIT ANALYST COMMERCIAL BANK"   || officervalue == "CA – CREDIT ANALYST SME BANKING" || officervalue == "BM – BRANCH MANAGER"){
            component.set("v.renderfields", true);

        }        
        else{
            component.set("v.renderfields", false);

  }
    },
   
    submitforCMSLinking : function(component, event, helper) {
       //W-008562
       if(component.get("v.oppStage") == 'Closed'){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type":"error",
            "title": "Error!",
            "message": "You are not allowed to submit for cms linking as it is associated with closed opportunity"
        });
        toastEvent.fire();
    } else{
        var checkselectedRowsIdsList = component.get("v.selectedRowsIdsList");
        console.log('checkselectedRowsIdsList -> ' + checkselectedRowsIdsList.length);
        if(checkselectedRowsIdsList.length == 0){
             helper.showSpinner(component);
             var toastEvent = helper.getToast("Info!", "Please select at least one record for CMS Linking", "warning");
             toastEvent.fire();
             helper.hideSpinner(component); //hide the spinner
        }else{
              helper.submitforCMSLinkingHelper(component, event, helper);
        }
      } 
    },  
    
    deleteRecords: function (component, event, helper) {
      //W-008562
      if(component.get("v.oppStage") == 'Closed'){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type":"error",
            "title": "Error!",
            "message": "You are not allowed to delete control officers information as it is associated with closed opportunity"
        });
        toastEvent.fire();
    }else{
        helper.deleteRecordsHelper(component, event, helper);
    }
      },
})