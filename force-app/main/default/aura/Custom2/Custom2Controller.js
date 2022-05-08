({
   doInit : function(component, event, helper) {
	  var getSelectRecord = component.get("v.oRecord");
        if((getSelectRecord.Id).substring(0,3) != '005')
       {
           component.set("v.DisplayName", getSelectRecord.Site__r.Cities_PickList__c);           
       }
       else
       {
           component.set("v.DisplayName", getSelectRecord.Name);
       }
    },
    selectRecord : function(component, event, helper){      
    // get the selected record from list  
      var getSelectRecord = component.get("v.oRecord");
       console.log("value= "+JSON.stringify(getSelectRecord));
    // call the event   
      var compEvent = component.getEvent("oSelectedRecordEvent");
    // set the Selected sObject Record to the event attribute.  
         compEvent.setParams({"recordByEvent" : getSelectRecord });  
    // fire the event  
         compEvent.fire();
    },
})