({
  
    doInit: function(component, event, helper) {
        
         helper.getReqProd(component, event, helper);
          var actions = helper.getRowActions.bind(this, component);
          component.set("v.columnsReqProd", [
            {label: 'Product', fieldName: 'productName', type: 'String'},
            //{label: 'Product Type', fieldName: 'productType', type: 'String'},
            {label: 'Product Type', fieldName: 'productType', type: 'String'},
            {label: 'Account Number', fieldName: 'productAccountNumber', type: 'String'},
            {label: 'Amount', fieldName: 'productAmount', type: 'String'},
            {label: 'System Decision', fieldName: 'sysDecision', type: 'String'},
            {label: 'Final Decision', fieldName: 'finalDecision', type: 'String'},
            {label: 'Product Status', fieldName: 'productStatus', type: 'String'}
            
        ]);
        
          var action = component.get("c.getListViewId");

      action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
            var results = response.getReturnValue();
                component.set("v.listviewID",results.Id);
                
            }
               
      });
         $A.enqueueAction(action);
        
         helper.hideSpinner(component); 
    },
	handleSuccess : function(component, event, helper) {
        event.preventDefault();
        var approver = component.get("v.simpleRecord");
           var approverId= approver.Approval_Owner__c;
           var userId = $A.get("$SObjectType.CurrentUser.Id");
        if(approverId==null || approverId!=userId ){// || approverId!=userId
          var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "error",
                "title": "Error!",
                "message": "Only the allocated sanctioner can make changes to this record"
            });
             toastEvent.fire();     
        }
        else{
          var fields = event.getParam('fields');
          
            component.find('recordHandler').submit(fields);
         var action = component.get("c.acceptApprovalProcessforSanctioning");
         var opp;
         action.setParams({
            "oppId": component.get("v.recordId")
        });
      action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                opp = response.getReturnValue();
             
          //Added By Himani Joshi
            if(opp.IsAmendmentRequired__c){
            component.find('notifLib').showToast({
            "title": "",
            "message": "The Credit Bureau Report is no longer valid. Re-process the application",
            "variant": "error"
        });
            
        }else{
             component.find('notifLib').showToast({
            "title": "Decision Saved!",
            "message": "Decision submitted successfully.",
            "variant": "success"
        });
        
         var urlto ='/lightning/o/Opportunity/list?filterName='+component.get("v.listviewID");
          console.log('urlto---'+urlto);
         // window.open(urlto,'_top');
          
          var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
            workspaceAPI.closeTab({tabId: focusedTabId});
        
        })
        .catch(function(error) {
            console.log(error);
        }); 
          
          workspaceAPI.openTab({
        url: '/lightning/o/Opportunity/list?filterName='+component.get("v.listviewID"),
                focus: true
       }).catch(function(error) {
            console.log(error);
        });
        
        }
                
            }else if (state === "ERROR") {
                var errors = response.getError();
                 component.find('notifLib').showToast({
            "title": "",
            "message": ""+errors[0].message,
            "variant": "error"
        });
               // component.set("v.errorMessage", "Apex error FulfillmentApplicationController.getClientData: " + JSON.stringify(errors));
            } else {
                component.set("v.errorMessage", "Unexpected error occurred,  state returned: " + state);
            }          
      });
         
         $A.enqueueAction(action);
        }
       
	}
})