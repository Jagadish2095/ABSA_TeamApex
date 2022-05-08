({
	handleOnLoad : function(component, event, helper) {
        
        console.log('get rcordtype--'+component.get("v.recordTypeName"));
        //get user's of profile's credit manager 
          var action = component.get("c.loadUsers");
          action.setParams({
            "opprecordType": component.get("v.recordTypeName")
        });
          action.setCallback(this, function(response) {
               var state = response.getState();
            if (state === "SUCCESS") {
                
                var results = response.getReturnValue();
                
                console.log('results---',results);
                component.set("v.usersReturned",results);
                component.set('v.resultColumns', [
            			{label: 'User name', fieldName: 'Name', type: 'text'},
                    ]);
          }else{
                console.log("Failed with state: " + JSON.stringify(response));
            }
            
        });
        
        $A.enqueueAction(action);
        
		
	},
    
  setselectedUser: function(component, event, helper) {
		var selectedRows = event.getParam("selectedRows")[0];
        	 if (typeof selectedRows != "undefined") {
             		 var selectedUser = selectedRows;
                 	 component.set("v.userSelected",selectedUser);	
                 	 component.set("v.selectedUserId",selectedUser.Id);	
             }
        
	},
})