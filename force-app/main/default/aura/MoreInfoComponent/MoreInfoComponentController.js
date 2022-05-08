({
    
    doInit : function(component,event,helper){
         var action = component.get("c.getListViewId");
         action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
            var results = response.getReturnValue();
                component.set("v.listviewID",results.Id);
                
            }
               
      });
         $A.enqueueAction(action);
    },
	handleLoad : function(component, event, helper) {
	
    helper.hideSpinner(component);    
	
	},
    
    showInfo:function(component, event, helper) {
        component.set("v.showInfo", true);
    },
    
  
    handleSuccess : function(component, event, helper) {
        event.preventDefault();
        
         var approver = component.get("v.simpleRecord");
           var approverId= approver.Approval_Owner__c;
           var userId = $A.get("$SObjectType.CurrentUser.Id");
        if(approverId==null || approverId!=userId){
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
            fields.More_Info_Comment__c = component.find('MoreInfoComment').get('v.value');
            console.log('value comment---'+component.find('MoreInfoComment').get('v.value'));
             fields.More_Info_Decision__c = component.find('MoreInfoDecisionConfirmation').get('v.value');
          console.log('value decision---'+component.find('MoreInfoDecisionConfirmation').get('v.value'));
            component.find('recordHandler').submit(fields);
           
            helper.showSpinner(component);
            
            
        var recordId =  component.get("v.recordId");
        //var infoCat = component.find('MoreInfoCategory').get('v.value');
        //var infoDes = component.find('MoreInfoDecisionConfirmation').get('v.value');

        
       
            helper.hideSpinner(component); 
        }
    },
    
    updateComment :function(component,event,helper){
         var action = component.get("c.rejectApprovalProcessforMoreInfo");
         action.setParams({
            "oppId": component.get("v.recordId")
        });
      action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var results = response.getReturnValue();
                if(!results.IsAmendmentRequired__c){
             component.find('notifLib').showToast({
            "title": "Decision Saved!",
            "message": "Decision has been saved successfully.",
            "variant": "success"
        	});
                }
                else{
                    var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Error!",
                            "message": "The Credit Bureau Report is no longer valid. Re-process the application ",
                            "type":"error"
                        });
                        toastEvent.fire();
                    
                    
                }
                
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
          
      });
         $A.enqueueAction(action);
        
    }
})