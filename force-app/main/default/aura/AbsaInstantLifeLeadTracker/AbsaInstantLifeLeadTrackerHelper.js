({
	leadTrackerList : function(component,event,helper) {	 
     var action = component.get("c.getAbsaInstantLifLeadTracker");
        action.setCallback(this, function(response) {
          $A.util.removeClass(component.find("mySpinner"), "slds-show");        
            var state = response.getState();
            if (state === "SUCCESS") {               
                var respObj = JSON.parse(response.getReturnValue());                      
              try{
                    if (respObj.statusCode == 200 && respObj.Leads != null ){
                        var outputTable =  respObj.Leads;
                        var outputTableNew=[];
                        if((!$A.util.isUndefinedOrNull(outputTable)) && outputTable.length > 0)
                        {
                            component.set("v.displayLeads","showMe");
                            for (var i=0; i< outputTable.length; i++)
                            {
                                var item = outputTable[i];
                                console.log('lead item' + item.LeadStatus);
                                var leadItem = {customerFirstName: item.FirstName,                                           
                                           customerLastName:item.LastName,
                                           dataLeadSent: item.LeadDate,
                                           callBackDate:item.CallbackDateTime,
                                           callBackTime:item.CallbackDateTime,
                                           leadStatus: item.LeadStatus};
                               
                                outputTableNew.push(leadItem);
                            } 
                            component.set('v.data', outputTableNew);                    
                        }
                        else {
                            
                        } 
                    }else if(respObj.statusCode == 200 && respObj.ValidationErrors[0].Message != null){                   
                         this.showToast("error", "Error", respObj.ValidationErrors[0].Message);
                    }else if(respObj.statusCode == 200 && respObj.Leads == null && respObj.ValidationErrors[0].Message == null){                        
                           this.showToast("error", "Error", 'No Leads Found');
                        } 
                  }catch(ex) {                  
                    this.showToast("error", "Error", ex.message);
                }
            }
            
        });   
        $A.enqueueAction(action);    
	},
    
    getAgentName : function(component,event, helper)
    {
    var action = component.get("c.getAgentName");       
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var respObj = response.getReturnValue();
                component.set('v.agentName', respObj);
            }       
     });
    $A.enqueueAction(action);
    },
     showToast : function (type, title, message)
    {
        var toastEvent = $A.get("e.force:showToast");
        if(toastEvent) {
            toastEvent.setParams({
                "title": title,
                "message": message,
                 "mode": 'sticky',
                "type": type
            });
            toastEvent.fire();
        } else {
            alert(message);
        }
    },
     navHome: function(component, event, helper)
    {
        var homeEvent = $A.get("e.force:navigateToURL");
        homeEvent.setParams({
            "url": "/home/home.jsp"
        });
        homeEvent.fire();
    },
})