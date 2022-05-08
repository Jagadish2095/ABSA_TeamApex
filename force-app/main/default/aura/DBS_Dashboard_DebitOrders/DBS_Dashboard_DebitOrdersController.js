({
	getSelectedDebitOrderTransaction : function(component, event, helper) {
		var select_id = event.currentTarget.id; 
        
        //Get selected recording using Id
        var debitsObj = component.get("v.data.debitsData"); 
        
        var selected_record = debitsObj[select_id];  
        
        //load it 
        component.set("v.selectedDebitOrder", selected_record);
        component.set("v.debitOrderReversalModal", true);  
        
      }
})