({
  getSelectedSimHoldRecord : function(component, event, helper) {
        
    var select_id = event.currentTarget.id; 
        
        //Get selected recording using Id
        var simData = component.get("v.data.simsData");   
        
        var selected_record = simData[select_id];  
        
        //load it 
        component.set("v.selectedSimHold", selected_record);
        component.set("v.simHoldReleaseModal", true);    
  }
})