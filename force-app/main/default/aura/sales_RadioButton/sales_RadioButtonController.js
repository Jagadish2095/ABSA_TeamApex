({
    changeValue: function(component, event, helper) {     
    	var radioSelValue = component.get("v.radioSelValue");
        let radioValues = component.get("v.radioValues");
        
        if(!radioSelValue){
            for (let i in radioValues) {            
                radioValues[i].checked = false;
            } 
            component.set("v.radioValues", radioValues);
            return;              
        }
    },
	selectedValueHandler : function(component, event, helper) {       
		let selected_id = event.currentTarget.dataset.id;
        let radioValues = component.get("v.radioValues");
        
        if(!selected_id){
            for (let i in radioValues) {            
                radioValues[i].checked = false;
            } 
             component.set("v.radioValues", radioValues);
            return;            
        }
        
        if(selected_id == "Yes"){
            component.set("v.radioSelValue", "Y"); 
        }else if(selected_id == "No"){
            component.set("v.radioSelValue", "N");
        }else if(selected_id == "Verified"){
            component.set("v.radioSelValue", selected_id); 
        }else if(selected_id == "Express loan"){
            component.set("v.radioSelValue", selected_id); 
        }else if(selected_id == "Balance transfer loan"){
            component.set("v.radioSelValue", selected_id); 
        }else if(selected_id == "Micro loan"){
            component.set("v.radioSelValue", selected_id); 
        }else if(selected_id == "Personal loan"){
            //component.set("v.radioSelValue", component.get("v.client.personal_loan")); //  value for personal loan is "00", we need to find value for other produst
           component.set("v.radioSelValue", "00");
        }else if(selected_id == "Study loan"){
            component.set("v.radioSelValue", selected_id); 
        }else if(selected_id == "Revolving loan"){
            component.set("v.radioSelValue", selected_id); 
        }	
        
        for (let i in radioValues) {            
            //radioValues[i].checked = (radioValues[i].value == selected_id) ? radioValues[i].checked = true : radioValues[i].checked = false;
            if(radioValues[i].value == 'Express loan'){
                radioValues[i].checked = false;
            }else if(radioValues[i].value == 'Balance transfer loan'){
                radioValues[i].checked = false;
            }else if(radioValues[i].value == 'Micro loan'){
                radioValues[i].checked = false;
            }else if(radioValues[i].value == 'Study loan'){
                radioValues[i].checked = false;
            }else if(radioValues[i].value == 'Revolving loan'){
                radioValues[i].checked = false;
            }else if(radioValues[i].value == selected_id){
                radioValues[i].checked = true
            }else{
                radioValues[i].checked = false;
            }
        } 

        /*for (let i in radioValues) {            
            radioValues[i].checked = (radioValues[i].value == selected_id) ? radioValues[i].checked = true : radioValues[i].checked = false;
        } */
        
        		
        component.set("v.radioValues", radioValues);
	}
})