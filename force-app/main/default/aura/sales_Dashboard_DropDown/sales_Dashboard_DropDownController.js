({
	dropDownHandler : function(component, event, helper) {
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
    selectedHandler: function(component, event, helper) {
        let selected_id = event.currentTarget.dataset.id;
        
        let sel_value = component.get("v.selected_value");
        let pick_list = component.get("v.agentStatus");
               
        for(let key in pick_list){
            if(pick_list[key].auxCode == selected_id){
                component.set("v.selected_row" , {'label': pick_list[key].label, 'value': pick_list[key].value, 'auxCode' : pick_list[key].auxCode});
                break;
            } 
        } 
        
        if(selected_id == '11'){
            helper.logoutHelper(component, event);
        }else{
          helper.changeStatusHelper(component, event);    
        }
        
        for(let key in pick_list){
            if(pick_list[key].auxCode == selected_id){
                pick_list[key].selected = true;
                selected_id = pick_list[key].label; 
                component.set("v.selected_row" , {'label': pick_list[key].label, 'value': pick_list[key].value, 'auxCode' : pick_list[key].auxCode});
            }else{
                pick_list[key].selected = false;
            }
        }
         
        component.set("v.agentStatus", pick_list);
        if(selected_id == '0' || selected_id == 'Available'){ 
            component.set("v.selected_value_class", "green");            
        }else{
            component.set("v.selected_value_class", "");
        }
        component.set("v.show_list_class","slds-hide");
        component.set("v.icon_type","utility:down");
        component.set("v.selected_value", selected_id);
	},
})