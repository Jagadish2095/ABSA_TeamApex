({
	Submit : function(component, event, helper) {
        helper.showSpinner(component);
		var action = component.get("c.verificationCheck");
        var accountId = component.get("v.CaseAccountId");
        var customerCIF = component.get("v.cif");
        console.log('Call class');

        //action.setParams({accountId:accountId});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('-----SUCCESS-----');
                var result = response.getReturnValue();
                console.log('Results -------> ' + result);
                
                if(result != null){
                    //var arrayResults = result.Split('#');
                    
                    if(result != ''){
                        if(result == 'No Data'){
                            helper.hideSpinner(component);
                            component.set("v.customerVerified" , false);
                        	component.set("v.messageError" , "No Active Call Data , click next to verify customer");
                        	component.set("v.verified" , false);
                        	component.set("v.taskId" , result);
                            component.set("v.message","")
                        }else if(result == 'Not Verified'){
                            helper.hideSpinner(component);
                            component.set("v.customerVerified" , false);
                        	component.set("v.message" , "");
                        	component.set("v.verified" , false);
                            component.set("v.messageError","Customer not verified , click next to verify customer");
                        }else{
                            helper.hideSpinner(component);
                            var arrayString = result.split('#');
                            if(arrayString[3] == customerCIF){
                            	component.set("v.customerVerified" , true);
                        		component.set("v.message" , "Customer verified , click next to continue");
                        		component.set("v.verified" , false);
                        		component.set("v.taskId" , arrayString[0]);
                            	component.set("v.verifiedFlow" , arrayString[1]);
                            	component.set("v.Identified" , arrayString[2]);
                            	component.set("v.messageError","");
                            
                                
                            }else{
                                helper.hideSpinner(component);
                                component.set("v.customerVerified" , false);
                        		component.set("v.message" , "");
                        		component.set("v.verified" , false);
                        		component.set("v.taskId" , arrayString[0]);
                            	component.set("v.verifiedFlow" , arrayString[1]);
                            	component.set("v.Identified" , arrayString[2]);
                            	component.set("v.messageError","Customer not verified , click next to verify customer");
                            }
                        }
                        
                    }else{
                        helper.hideSpinner(component);
                        component.set("v.customerVerified" , false);
                        component.set("v.messageError" , "Customer not verified , click next to verify customer");
                        component.set("v.verified" , false);
                        component.set("v.message","");
                    }
                }else{
                    	helper.hideSpinner(component);
                    	component.set("v.messageError" , "No Active Call Data , click next to verify customer");
                    	component.set("v.verified" , false);
                    	component.set("v.message","");
                }
             } else if(state === "ERROR"){
                 		helper.hideSpinner(component);
                		component.set("v.messageError" , "Service Issue .......Please Contact System Administrator , click next to verify customer");
                 		component.set("v.verified" , false);
                 		component.set("v.message","");
                 		
               			
            } 
        });
        $A.enqueueAction(action);
	}
})