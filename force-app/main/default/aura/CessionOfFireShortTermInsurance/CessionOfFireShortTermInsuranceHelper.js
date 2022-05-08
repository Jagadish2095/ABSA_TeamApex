({
	SecurityCessionOfShortTermInsuranceHelper : function(component, event, helper) {
     var pageSize = component.get("v.pageSize");
     component.set('v.isHide', true);
     var action = component.get("c.getASVCessionOfFireShortTermInsuranceV1");
     var accountId = component.get("v.recordId");
     console.log("Account " + accountId);
             action.setParams({
            'accountId': accountId,
            
          });
         
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            console.log("State" + state);
            console.log("Get Cession General Pledges Response **********************************************************" + response);
            if (state === "SUCCESS" && response != null) {
                var storeResponse = JSON.parse(response.getReturnValue());
                console.log("Inside Method 1" + storeResponse);
                
                if(storeResponse != null){
                    console.log("List of Bonds ****** " + storeResponse);
               			 // if storeResponse size is equal 0 ,display No Result Found... message on screen. 
                	if (storeResponse.length > 0) {
                    	var bondsList = [];
                		var count = 0;
                
                		for(var key = 0 ; key < 2; key++){ 
                       		bondsList[count] = storeResponse[key];
					   		console.log('Bond list Muvhuso ' + storeResponse[key]);  
                       		count++;
                     	}
                        
                		console.log('Bond list ' + bondsList);
                		component.set("v.minimunListRecords", bondsList);
                		component.set("v.listOfSearchRecords", storeResponse);
                        component.set("v.paginationList", storeResponse);
                		component.set("v.searchRecordsSize", storeResponse.length);
                        component.set("v.start",0);
                        component.set("v.end",pageSize-1);
                		//component.set("v.isGenerated",true);
                        component.set("v.showTable",true);
                        component.set("v.totalSize", storeResponse.length);
                        
                		
                	} else {
                        //component.set("v.isGenerated",true);
                        console.log("Empty Security");
                        component.set("v.isSecurityEmpty",true);
                        
                	}
                		
                }else{
                    
                    //component.set("v.isGenerated",true);
                    component.set("v.showErrors",true);
                	component.set("v.errorMessage","No Securities");
                    
                }
            }else if(state == "ERROR"){
                var errors = response.getError();
                //component.set("v.isGenerated",true);
                component.set("v.showErrors",true);
                component.set("v.errorMessage",errors[0].message);
                
            }
            
        });
      // enqueue the Action  
        $A.enqueueAction(action);
	}
})