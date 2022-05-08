({
    check_validation: function(component,event,helper){       
        var client = component.get("v.client");       
        
        if(client.title_value != '3'){
            var titleValue1 = client.title_value;
        }else{
            var titleValue2 = client.title_label;
        }
        
        (component.find("title").get("v.selectedValue")) ? (component.set("v.title_condition", false)) : ( component.set("v.title_condition", true));
        (component.find("country_of_birth").get("v.selectedValue")) ? (component.set("v.country_of_birth_condition", false)) : ( component.set("v.country_of_birth_condition", true));        
        (component.find("marital_status").get("v.selectedValue")) ? (component.set("v.marital_status_condition", false)) : ( component.set("v.marital_status_condition", true));
        
        
        (component.find("nationality").get("v.selectedValue")) ? (component.set("v.nationality_condition", false)) : ( component.set("v.nationality_condition", true));
        
        let marital_status = component.get("v.client.marital_status");
       
        let marital_status_value = component.get("v.client.marital_status_value");
        if(marital_status_value != '1'){           
            component.set("v.client.marital_contract_value", "");
            component.set("v.client.marital_contract_label", "");
        }
        
        let marital_contract_value = component.get("v.client.marital_contract_value");
        if(marital_contract_value != ''){           
            component.set("v.client.marital_contract_validation", "");          
        }
        
        (component.find("home_language").get("v.selectedValue")) ? (component.set("v.home_language_condition", false)) : ( component.set("v.home_language_condition", true));        

        if(client.dependents_value == '0' || client.dependents_value){
            component.set("v.dependents_condition", false);
        }else{
            component.set("v.dependents_condition", true);
        }
             
        (component.find("communication_language").get("v.selectedValue")) ? (component.set("v.communication_language_condition", false)) : ( component.set("v.communication_language_condition", true));
        
        // Joshua and Rakesh  14-09-2020
        let postRadioValue = component.get("v.client.does_client_havepostmatric_qualification");
        if(postRadioValue == 'N'){           
            component.set("v.client.post_matric_qualification_label", "");
            component.set("v.client.post_matric_qualification_value", "");
        }
        if(client.post_matric_qualification_value){
             component.set("v.post_matric_qualification_condition", false);
        }else{
            component.set("v.post_matric_qualification_condition", true);
        }
        // Joshua and Rakesh  14-09-2020
        if(component.get("v.client.verify_client")){
            component.set("v.client.verify_client_validation","");
            component.find("verify_client").set("v.checked", true);
        }else{
            component.set("v.client.verify_client","");
			component.find("verify_client").set("v.checked", false);            
        }
            
        //(component.find("post_matric_qualification1").get("v.selectedValue")) ? (component.set("v.post_matric_qualification_condition", false)) : ( component.set("v.post_matric_qualification_condition", true));
        //(component.find("post_matric_qualification2").get("v.selectedValue")) ? (component.set("v.post_matric_qualification_condition", false)) : ( component.set("v.post_matric_qualification_condition", true));
        (component.find("relationship").get("v.selectedValue")) ? (component.set("v.relationship_condition", false)) : ( component.set("v.relationship_condition", true));
    
    },    
    test: function (component, event, helper){
        alert(component.get("v.client.verify_client"));
        component.set("v.client.verify_client", '');
        alert(component.get("v.client.verify_client"));
        component.find("verify_client").set("v.checked", false);   
    },
    editForm: function (component, event, helper){
       component.find("casa_ref").set("v.disabled", true); 
       
       component.find("id_number").set("v.disabled", true);
       component.find("casa_ref").set("v.disabled", true);
       component.find("title").set("v.disabled", true);
       component.find("name").set("v.disabled", true);
       
       component.find("surname").set("v.disabled", true);
       component.find("initials").set("v.disabled", true);
       component.find("date_of_birth").set("v.disabled", true);
       component.find("gender").set("v.disabled", true);
       //component.find("accept_details").set("v.disabled", true);
       component.find("country_of_birth").set("v.disabled", true);
       component.find("marital_status").set("v.disabled", true);
       component.find("customer_qual").set("v.disabled", true);
       component.find("res_address").set("v.disabled", true);
       component.find("cell_number").set("v.disabled", true);
       component.find("occupation_status").set("v.disabled", true);
       component.find("sa_income_tax_no").set("v.disabled", true);
       
       component.find("employment_status").set("v.disabled", true);
       
   
       let obj = component.get("v.obj");

       component.set("v.obj", obj);
   },
   resetForm: function (component, event, helper){
              component.find("casa_ref").set("v.disabled", false); 
       
       component.find("id_number").set("v.disabled", false);
       component.find("casa_ref").set("v.disabled", false);
       component.find("title").set("v.disabled", false);
       component.find("name").set("v.disabled", false);
       
       component.find("surname").set("v.disabled", false);
       component.find("initials").set("v.disabled", false);
       component.find("date_of_birth").set("v.disabled", false);
       component.find("gender").set("v.disabled", false);
       //component.find("accept_details").set("v.disabled", false);
       component.find("country_of_birth").set("v.disabled", false);
       component.find("marital_status").set("v.disabled", false);
       component.find("customer_qual").set("v.disabled", false);
       component.find("res_address").set("v.disabled", false);
       component.find("cell_number").set("v.disabled", false);
       component.find("occupation_status").set("v.disabled", false);
       component.find("sa_income_tax_no").set("v.disabled", false);
       
       component.find("employment_status").set("v.disabled", false);
       
   
       let obj = component.get("v.obj");

       component.set("v.obj", obj); 
   },
    
    /*clear : function(component,event,helper){
        component.set('v.client.contact_number','');
    },*/
    
    clear : function(component,event,helper){
        let id_name = event.getSource().getLocalId();
        if (id_name == 'clear_nkin_first_name'){
             component.set('v.client.nkin_first_name','');           
        } else if (id_name == 'clear_nkin_surname'){
            component.set('v.client.nkin_surname','');
        }else if (id_name == 'clear_contact_number'){
            component.set('v.client.contact_number','');
        }
       
    },
    
})