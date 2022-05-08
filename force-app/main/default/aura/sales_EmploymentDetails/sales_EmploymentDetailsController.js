({
	 checkLenght_sa_tax: function(component,event,helper){   
        var client =  component.get("v.client");
        var sa_income_tax_number =  component.get("v.client.sa_income_tax_number");
        var reason_sa_income_tax_number_not_given_value =  component.get("v.client.reason_sa_income_tax_number_not_given_value");
        if(sa_income_tax_number){
            component.set("v.sa_income_tax_reason_grayout",true);
            component.set("v.reason_sa_income_tax_number_not_given_value","");
            component.set("v.reason_sa_income_tax_number_not_given_label","");
            if(sa_income_tax_number.toString().length == 10 ){
                component.set("v.client.sa_income_tax_number_validation","");
                component.set("v.client.sa_tax_dropdown_validation","");
            }
            
        }else if(reason_sa_income_tax_number_not_given_value){
            component.set("v.sa_income_tax_grayout",true);
            component.set("v.sa_income_tax_reason_grayout",false);
            component.set("v.sa_income_tax_number","");
            component.set("v.client.sa_income_tax_number_validation","");
            component.set("v.client.sa_tax_dropdown_validation","");
        }
        
        let client_registed_for_income_tax  = component.get("v.client.client_registed_for_income_tax");
        if(client_registed_for_income_tax == "Y"){
            if(!reason_sa_income_tax_number_not_given_value && !sa_income_tax_number){
                component.set("v.sa_income_tax_grayout",false);
                component.set("v.sa_income_tax_reason_grayout",false);
            }
        }
         
         
        
        
    },
    checkLenght_foreign_tax: function(component,event,helper){ 
        var foreign_income_tax_number =  component.get("v.client.foreign_income_tax_number");
        var reason_foreign_income_tax_num_not_given_value =  component.get("v.client.reason_foreign_income_tax_num_not_given_value");
        if(foreign_income_tax_number){
            component.set("v.foreign_income_tax_reason_grayout",true);
            component.set("v.reason_foreign_income_tax_num_not_given_value","");
            component.set("v.reason_foreign_income_tax_num_not_given_label","");
            if(foreign_income_tax_number.toString().length>2){
                component.set("v.client.foreign_income_tax_number_validation","");
                component.set("v.client.foreign_tax_dropdown_validation","");
            }
            
        }else if(reason_foreign_income_tax_num_not_given_value){
            component.set("v.foreign_income_tax_grayout",true);
            component.set("v.foreign_income_tax_reason_grayout",false);
            component.set("v.foreign_income_tax_number","");
            component.set("v.client.foreign_income_tax_number_validation","");
            component.set("v.client.foreign_tax_dropdown_validation","");
        }
        
        
        
        let client_registered_for_foreign_income_tax  = component.get("v.client.client_registered_for_foreign_income_tax");
        
        if(client_registered_for_foreign_income_tax == "Y"){
            if(!reason_foreign_income_tax_num_not_given_value && !foreign_income_tax_number){
                component.set("v.foreign_income_tax_grayout",false);
                component.set("v.foreign_income_tax_reason_grayout",false);
            }
        }
        
        
    },
        
       
    checkLenght: function(component,event,helper){   
        
        
        
         //SA tax 
       /* var sa_income_tax_number =  component.get("v.client.sa_income_tax_number"); 
         if (!sa_income_tax_number){
            component.set("v.client.sa_income_tax_number_validation", '');

         } else{
        if(sa_income_tax_number.toString().length > 0 && sa_income_tax_number.toString().length < 10){            
            component.set("v.client.sa_income_tax_number_validation", 'SA tax should be 10 digits');
             
            
        }  else {
            component.set("v.client.sa_income_tax_number_validation", '');
            
        }
             
         }
         
         //foreign tax
         var foreign_income_tax_number =  component.get("v.client.foreign_income_tax_number"); 
         if (!foreign_income_tax_number){
            component.set("v.client.foreign_income_tax_number_validation", '');

         } else{
        if(foreign_income_tax_number.toString().length > 0 && foreign_income_tax_number.toString().length < 3 ){            
           component.set("v.client.foreign_income_tax_number_validation", 'Tax should be more than 2 digit');
            
        }  else {
            component.set("v.client.foreign_income_tax_number_validation", '');
            
        }
            
         } */
         
    },
    
    check_validation_sa_tax: function(component,event,helper){
        
        // SA INCOME TAX
                let client_registed_for_income_tax  = component.get("v.client.client_registed_for_income_tax");
                let sa_income_tax_number = component.get("v.client.sa_income_tax_number");
                if(client_registed_for_income_tax == 'N'){           
                    component.set("v.client.reason_sa_income_tax_number_not_given_value", "");
                    component.set("v.client.reason_sa_income_tax_number_not_given_label", "");
                    component.set("v.client.sa_income_tax_number","");
                }else if(client_registed_for_income_tax == 'Y'){
                    
                    let sa_income_tax_number = component.get("v.client.sa_income_tax_number");
                    let reason_sa_income_tax_number_not_given_value = component.get("v.client.reason_sa_income_tax_number_not_given_value");
                    
                    if(sa_income_tax_number){
                        component.set("v.sa_income_tax_grayout",false);
                        component.set("v.sa_income_tax_reason_grayout",true);
                        component.set("v.client.reason_sa_income_tax_number_not_given_value","");
                        component.set("v.client.reason_sa_income_tax_number_not_given_label","");
                    }else if(reason_sa_income_tax_number_not_given_value){
                        component.set("v.sa_income_tax_grayout",true);
                        component.set("v.sa_income_tax_reason_grayout",false);
                        component.set("v.client.sa_income_tax_number","");
                    }
                    
                    if(!reason_sa_income_tax_number_not_given_value && !sa_income_tax_number){
                        component.set("v.sa_income_tax_grayout",false);
                        component.set("v.sa_income_tax_reason_grayout",false);
                    }
                    
                    
        
               }   
               if(client_registed_for_income_tax){
                    component.set("v.client.client_registed_for_income_tax_validation","");
               }
    },
    check_validation_foreign_tax: function(component,event,helper){
        
        //FOREGN INCOME TAX
                    let client_registered_for_foreign_income_tax  = component.get("v.client.client_registered_for_foreign_income_tax");
                    let foreign_income_tax_number = component.get("v.client.foreign_income_tax_number");
                    if(client_registered_for_foreign_income_tax == 'N'){           
                        component.set("v.client.reason_foreign_income_tax_num_not_given_value", "");
                        component.set("v.client.reason_foreign_income_tax_num_not_given_label", "");
                        component.set("v.client.foreign_income_tax_number","");
                    }else if(client_registered_for_foreign_income_tax == 'Y'){
                        
                        let foreign_income_tax_number = component.get("v.client.foreign_income_tax_number");
                        let reason_foreign_income_tax_num_not_given_value = component.get("v.client.reason_foreign_income_tax_num_not_given_value");
                        
                        if(foreign_income_tax_number){
                            component.set("v.foreign_income_tax_grayout",false);
                            component.set("v.foreign_income_tax_reason_grayout",true);
                            component.set("v.client.reason_foreign_income_tax_num_not_given_value","");
                            component.set("v.client.reason_foreign_income_tax_num_not_given_label","");
                        }else if(reason_foreign_income_tax_num_not_given_value){
                            component.set("v.foreign_income_tax_grayout",true);
                            component.set("v.foreign_income_tax_reason_grayout",false);
                            component.set("v.client.foreign_income_tax_number","");
                        }
                        
                        if(!reason_foreign_income_tax_num_not_given_value && !foreign_income_tax_number){
                            component.set("v.foreign_income_tax_grayout",false);
                            component.set("v.foreign_income_tax_reason_grayout",false);
                        }
                    

                    }
        
        if(client_registered_for_foreign_income_tax){
            component.set("v.client.client_registered_for_foreign_income_tax_validation","");
        }
            
    },
    
    check_validation: function(component,event,helper){
                var client =  component.get("v.client");    
                (client.occupational_status_value) ? (component.set("v.occupational_status_condition", false)) : ( component.set("v.occupational_status_condition", true));         
                if((client.occupational_status_value == '04') || (client.occupational_status_value == '05') || (client.occupational_status_value == '06') || (client.occupational_status_value == '07') || (client.occupational_status_value == '10'))
                {
                    component.set("v.client.occupation_level_value", "");
                    component.set("v.client.occupation_level_label", "");
                    
                    component.set("v.client.occupation_code_value", "");
                    component.set("v.client.occupation_code_label", "");
                }
                
                (client.monthly_income_value) ? (component.set("v.monthly_income_condition", false)) : ( component.set("v.monthly_income_condition", true));  
                (client.source_of_income_value) ? (component.set("v.source_of_income_condition", false)) : ( component.set("v.source_of_income_condition", true));  
                (client.frequency_of_income_value) ? (component.set("v.frequency_of_income_condition", false)) : ( component.set("v.frequency_of_income_condition", true));  
                //(client.client_banks_with_absa_value) ? (component.set("v.client_banks_with_absa_condition", false)) : ( component.set("v.client_banks_with_absa_condition", true)); 
                (client.empl_postal_address_line_1) ? (component.set("v.employers_name_condition", false)) : ( component.set("v.employers_name_condition", true));  
                (client.empl_postal_address_line_1_3) ? (component.set("v.empl_postal_address_line_1_3_condition", false)) : ( component.set("v.empl_postal_address_line_1_condition", true)); 
        
                
                
                    
           
       /* let client_registered_for_foreign_income_tax  = component.get("v.client.client_registered_for_foreign_income_tax");
        if(client_registered_for_foreign_income_tax == 'N'){           
            component.set("v.client.reason_foreign_income_tax_num_not_given_value", "");
            component.set("v.client.reason_foreign_income_tax_num_not_given_label", "");
            //component.set("v.client.client_registered_for_foreign_income_tax","");

        } */
    },
    
    employers_name_check  : function(component, event, helper){
        var employers_name = component.find("employers_name").get("v.value");
        if($A.util.isEmpty(employers_name)){component.set("v.employers_name_condition", false);}    
},
    empl_postal_address_line_1_3_check  : function(component, event, helper){
        var empl_postal_address_line_1_3 = component.find("empl_postal_address_line_1_3").get("v.value");
        if($A.util.isEmpty(empl_postal_address_line_1_3)){component.set("v.empl_postal_address_line_1_3_condition", false);}    
},
    empl_town_city_foreign_country_check  : function(component, event, helper){
        var empl_town_city_foreign_country = component.find("empl_town_city_foreign_country").get("v.value");
        if($A.util.isEmpty(empl_town_city_foreign_country)){component.set("v.empl_town_city_foreign_country_condition", false);}    
},
    reason_sa_income_tax_number_check  : function(component, event, helper){
        var reason_sa_income_tax_number_not_given = component.find("reason_sa_income_tax_number_not_given").get("v.value");
        if($A.util.isEmpty(reason_sa_income_tax_number_not_given)){component.set("v.reason_sa_income_tax_number_not_given_condition", false);}    
},
     /*client_banks_with_absa_check  : function(component, event, helper){
        var client_banks_with_absa = component.find("client_banks_with_absa").get("v.radioSelValue");
        if(!$A.util.isEmpty(client_banks_with_absa)){component.set("v.client_banks_with_absa_condition", false);}    
},*/
    
    
  
    
    
    clear : function(component,event,helper){
        let id_name = event.getSource().getLocalId();
        if (id_name == 'clear_empl_postal_address_line_1'){
             component.set('v.client.empl_postal_address_line_1','');
            
        } else if (id_name == 'clear_empl_town_city_foreign_country'){
             component.set('v.client.empl_town_city_foreign_country','');
            
        } else if (id_name == 'clear_reason_sa_income_tax_number_not_given'){
             component.set('v.client.reason_sa_income_tax_number_not_given','');
            
        } else if (id_name == 'clear_reason_foreign_income_tax_num_not_given'){
             component.set('v.client.reason_foreign_income_tax_num_not_given',''); 
            
        } else if (id_name == 'clear_sa_income_tax_number'){
             component.set('v.client.sa_income_tax_number',''); 
             
        }  else if (id_name == 'clear_foreign_income_tax_number'){
             component.set('v.client.foreign_income_tax_number','');
        }
        else if (id_name == 'clear_empl_postal_code'){
             component.set('v.client.empl_postal_code','');
        }
    },
    current_employment_since : function(component, event, helper) {//13 Feb 2020  //DD/MM/YYYY 2020-02-13
        
        let string_date = component.get("v.client.current_employment_since").toString();
        if(string_date.includes("-")){
            let modified_date = string_date.substring(8, 10)+"/"+string_date.substring(5, 7)+"/"+string_date.substring(0, 4);
            component.set("v.client.current_employment_since",modified_date);
        }else if(string_date.includes("/")){
            component.set("v.client.current_employment_since",string_date);
        }
    },
})