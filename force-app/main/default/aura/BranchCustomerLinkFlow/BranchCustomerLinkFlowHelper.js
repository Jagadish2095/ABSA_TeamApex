({  
	      
	    /* 
	     * Function that will dynamically construct the path (progressIndicator) bar based on the value of the "activeStages" attribute. 
	     */  
          initPath : function(component, event, helper) {  
	          
	        var progressIndicator = component.find('progressIndicator');  
	        var body = [];  
	          
	        var activeStages = component.get("v.activeStages");  
	          
	        //for each value in the activeStages list, we create a new element of "lightning:progressStep" and  
	        //we add it to the progressIndicator component to costruct our path.  
	        var stage;  
	        for (var key in activeStages) {  
	              
	            stage = activeStages[key];  
	              
	            $A.createComponent(  
	                "lightning:progressStep",  
	                {  
                        "id": "vertical-progress-indicator",
	                    "aura:id": "step_" + stage.name,  
                        "label": stage.label,  
	                    "value": stage.name,  
                        "orientation":"vertical"
	                },  
	                function(newProgressStep, status, errorMessage){  
                    // Add the new step to the progress array  
	                    if (status === "SUCCESS") {  
	                        body.push(newProgressStep);  
	                        progressIndicator.set("v.body", body);  
	                    }  
	                      
	                    //Handle error cases here.  
	                }  
	            );  
	        }  
	          
	    }  
	})