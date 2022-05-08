({
   closeModal: function(component, event, helper) {
	  helper.displayError(component, event, false);        
      helper.closeModalhelper(component, event);          
   }, 
   loginHandler: function(component, event, helper) {
      let loggedInUser = component.get("v.loggedInUser");
       console.log(JSON.stringify(loggedInUser));
  
       component.set("v.loggedInUser", loggedInUser);
      if(!loggedInUser.station_id){
          helper.displayError(component, event, true); 
          return;
      }
      helper.displayError(component, event, false); 
            
      helper.closeModalhelper(component, event);  
       

       var login = component.getEvent("updateLogin");
       login.setParams({  
           "station_id": component.get("v.loggedInUser.station_id")
       }).fire();          
   },    
})