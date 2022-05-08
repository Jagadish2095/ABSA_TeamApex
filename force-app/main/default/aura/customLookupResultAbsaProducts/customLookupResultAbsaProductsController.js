({
   selectProduct : function(component, event, helper){   
    // get the selected record from list 
      component.set("v.isOpen", true);
      
      var getSelectRecord = component.get("v.oRecord"); 
    },
    closeModel :function(component, event, helper){ 
      component.set("v.isOpen", false);
    },
    
})