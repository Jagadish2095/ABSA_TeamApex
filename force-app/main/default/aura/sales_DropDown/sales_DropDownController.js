({
    closeAllDropdowns: function(component, event, helper) {
           var val = component.find("inputValue");
           var inputValue = val.get("v.value");
            if(!inputValue){
               component.set("v.selectedValue", '');
               component.set("v.selectedLabel", '');            
            }
  
            window.setTimeout(
                $A.getCallback(function() {
                    component.set("v.icon_type","utility:down");
                    component.set("v.show_list_class","slds-hide");  
                }), 200 
            );                       
    },
	dropDownHandler : function(component, event, helper) {
        if(component.get("v.grayout")){
           component.set("v.icon_type","utility:down");
           component.set("v.show_list_class","slds-hide");
           return;
        }
        helper.dropDownHelper(component, event);      
        
	},     
    selectedHandler: function(component, event, helper) {
        let selected_label = event.currentTarget.dataset.label;
        let selected_value = event.currentTarget.dataset.value;
       
        if(selected_label && selected_value){  
            component.set("v.icon_type","utility:down");
            component.set("v.show_list_class","slds-hide");             
            component.set("v.selectedValue", selected_value);
            component.set("v.selectedLabel", selected_label);
    	}
	}, 
    filterValues: function(component, event, helper) {
     
        helper.dropDownHelper(component, event);   
        helper.filterValuesHelper(component, event);
    }
})