({
    capitalizeOnlyFirstLetter: function(stringValue) {
        var returnValue = '';
        if (stringValue) {
            var lowerCaseString = stringValue.toLowerCase();
            returnValue = lowerCaseString.charAt(0).toUpperCase() + lowerCaseString.slice(1);
        }
        return returnValue;
    },
    filterValuesHelper: function(component, event) {
        var val = component.find("inputValue");
        var inputValue = val.get("v.value");
        
        var pick_list = component.get("v.pickListValues");
        
        component.set("v.show_list_class","");   
        var filtered_list = [];
        for (let i = 0; i < pick_list.length; i++) {
            //let pick_value = pick_list[i].value;
            let pick_value = pick_list[i].label;
            pick_value = pick_value.toUpperCase();
            inputValue = inputValue.toUpperCase();
            if(inputValue && pick_value){  
                //var capVal = this.capitalizeOnlyFirstLetter(inputValue);
    
                if (pick_value.startsWith(inputValue)) {  
                    filtered_list.push(pick_list[i]);
                }
            }
        }    
        if(filtered_list.length == 0){         
           // let not_found = [{"label":"Not found...","value":""}];
           //filtered_list = not_found;
            component.set("v.show_list_class","slds-hide");
            component.set("v.icon_type","utility:down");   
        }
        
		component.set("v.tempPickListVals", filtered_list); 
    },
	dropDownHelper : function(component, event) {
        
        component.set("v.tempPickListVals", component.get("v.pickListValues")); 

		let display_class = component.get("v.show_list_class");

         if(display_class){
            component.set("v.show_list_class","");
            component.set("v.icon_type","utility:up");
            return;
        }
        if(!display_class){
            component.set("v.show_list_class","slds-hide");
            component.set("v.icon_type","utility:down");   
            return;
        }                        
	},    
})