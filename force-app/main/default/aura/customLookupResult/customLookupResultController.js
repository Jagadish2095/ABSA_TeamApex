({
   selectRecord : function(component, event, helper){   
    // get the selected record from list  
      var getSelectRecord = component.get("v.oRecord");
    // call the event   
      var compEvent = component.getEvent("oSelectedRecordEvent");
    // set the Selected sObject Record to the event attribute.  
         compEvent.setParams({"recordByEvent" : getSelectRecord });  
    // fire the event  
         compEvent.fire();
    },
    
    getUpdatedBankName : function(component, event) { 
        //Get the event message attribute
        var message = event.getParam("message"); 
        //Set the handler attributes based on event data 
        var obj = {'sobjectType':'Lookup__c','Name':message};
        component.set("v.oRecord", obj); 
        
        
        // call the event   
        var compEvent = component.getEvent("oSelectedRecordEvent");
        // set the Selected sObject Record to the event attribute.  
        compEvent.setParams({"recordByEvent" : obj});  
        // fire the event  
        compEvent.fire();
    },
})