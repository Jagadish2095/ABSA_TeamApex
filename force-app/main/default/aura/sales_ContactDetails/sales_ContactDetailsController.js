({
    checkLenght: function(component,event,helper){          
        var emailLenght =  component.get("v.client.email_address");        
        if(emailLenght.length == 0){
            component.set("v.client.email_address_validation", '');
        }
        const isNumeric = ch => 
                {   
                    return ch.match(/^[0-9]+$/i) !== null;
                }         
        var workTelNum =  component.get("v.client.work_telephone_number");
        if(workTelNum.length == 0){           
            component.set("v.client.work_telephone_number_validation", '');
        }
        else if(workTelNum.length > 0 && workTelNum.length < 10)
        {          
            component.set("v.client.work_telephone_number_validation", 'Please enter 10 digits');
        }
        else{
            component.set("v.client.work_telephone_number_validation", '');
        }
        
        if (workTelNum.length == 10){
            if (workTelNum.substring(0,1) != 0){component.set("v.client.work_telephone_number_validation", 'First number should be 0');}
        }
        
        
        var homeTelNum =  component.get("v.client.home_telephone_number");
        if(homeTelNum.length == 0){           
            component.set("v.client.home_telephone_number_validation", '');
        }
        else if(homeTelNum.length > 0 && homeTelNum.length < 10)
        {          
            component.set("v.client.home_telephone_number_validation", 'Please enter 10 digits');
        }
        else{
            component.set("v.client.home_telephone_number_validation", '');
        }
        
         if (homeTelNum.length == 10){
            if (homeTelNum.substring(0,1) != 0){component.set("v.client.home_telephone_number_validation", 'First number should be 0');}
        }
        
        var workFaxNum =  component.get("v.client.work_fax_number");
        if(workFaxNum.length == 0){           
            component.set("v.client.work_fax_number_validation", '');
        }
        else if(workFaxNum.length > 0 && workFaxNum.length < 10)
        {          
            component.set("v.client.work_fax_number_validation", 'Please enter 10 digits');
        }
        else{
            component.set("v.client.work_fax_number_validation", '');
        }
        if (workFaxNum.length == 10){
            if (workFaxNum.substring(0,1) != 0){component.set("v.client.work_fax_number_validation", 'First number should be 0');}
        }
        var homeFaxNum =  component.get("v.client.home_fax_number");
        if(homeFaxNum.length == 0){           
            component.set("v.client.home_fax_number_validation", '');
        }
        else if(homeFaxNum.length > 0 && homeFaxNum.length < 10)
        {          
            component.set("v.client.home_fax_number_validation", 'Please enter 10 digits');
        }
        else{
            component.set("v.client.home_fax_number_validation", '');
        }
        if (homeFaxNum.length == 10){
            if (homeFaxNum.substring(0,1) != 0){component.set("v.client.home_fax_number_validation", 'First number should be 0');}
        }
    },
    check_validation: function(component,event,helper){
          var client =  component.get("v.client");
          (client.residential_address_country_value) ? (component.set("v.residential_address_country_condition", false)) : ( component.set("v.residential_address_country_condition", true));        
          (client.residential_status_value) ? (component.set("v.residential_status_condition", false)) : ( component.set("v.residential_status_condition", true));        
          (client.section_129_notice_delivery_address_value) ? (component.set("v.section_129_notice_condition", false)) : ( component.set("v.section_129_notice_condition", true));        
          (client.preffered_communication_value) ? (component.set("v.preffered_communication_condition", false)) : ( component.set("v.preffered_communication_condition", true));         
    	  (client.credit_worthiness) ? (component.set("v.credit_worthiness_condition", false)) : ( component.set("v.credit_worthiness_condition", true));  
          (client.absa_group_electronic) ? (component.set("v.absa_group_electronic_condition", false)) : ( component.set("v.absa_group_electronic_condition", true));        
        if(client.residential_status_value != 'O'){
            component.set("v.client.outstanding_bond", '');
            component.set("v.client.realistic_market_value", '');
        }
        
        if((client.postal_address_line_2.toUpperCase()).includes("EXT") || (client.postal_address_line_2.toUpperCase()).includes("EXTENSION") || (client.postal_address_line_2.toUpperCase()).includes("UITBR") || (client.postal_address_line_2.toUpperCase()).includes("UITBREIDING")){
             component.set("v.client.postal_address_line_2_validation", 'Not contain EXT, EXTENSION, UITBR, UITBREIDING'); 
        }else{
             component.set("v.client.postal_address_line_2_validation",""); 
        }
    },
    /*postal_address_line_1_3_check  : function(component, event, helper){
                var postal_address_line_1_3 = component.find("postal_address_line_1_3").get("v.value");
                if($A.util.isEmpty(postal_address_line_1_3)){component.set("v.postal_address_line_1_3_condition", false);}    
    },*/
    postal_address_line_1_check  : function(component, event, helper){
                var postal_address_line_1 = component.find("postal_address_line_1").get("v.value");
                if($A.util.isEmpty(postal_address_line_1)){component.set("v.postal_address_line_condition", false);}    
    },
    town_city_foreign_country_check  : function(component, event, helper){
            var town_city_foreign_country = component.find("town_city_foreign_country").get("v.value");
            if($A.util.isEmpty(town_city_foreign_country)){component.set("v.town_city_foreign_country_condition", false);}    
    },  
    clear : function(component,event,helper){
        let id_name = event.getSource().getLocalId();
        if (id_name == 'clear_outstanding_bond'){
            component.set('v.client.outstanding_bond','');
            
        } else if (id_name == 'clear_realistic_market_value'){
            component.set('v.client.realistic_market_value','');
            
        } else if (id_name == 'clear_town_city_foreign_country'){
            component.set('v.client.town_city_foreign_country','');
            
        } else if (id_name == 'clear_work_telephone_number'){
            component.set('v.client.work_telephone_number','');
            component.set('v.client.work_telephone_number_validation','');
            
        } else if (id_name == 'clear_home_telephone_number'){
            component.set('v.client.home_telephone_number','');
            component.set('v.client.home_telephone_number_validation','');
            
        } else if (id_name == 'clear_work_fax_number'){
            component.set('v.client.work_fax_number','');
            component.set('v.client.work_fax_number_validation','');
            
        } else if (id_name == 'clear_home_fax_number'){
            component.set('v.client.home_fax_number','');
            component.set('v.client.home_fax_number_validation','');
            
        } else if (id_name == 'clear_email_address'){
            component.set('v.client.email_address','');
            component.set('v.client.email_address_validation','');            
        }
        else if (id_name == 'clear_postal_code'){
            component.set('v.client.postal_code','');
            //component.set('v.client.email_address_validation','');
            
        }
    },
	validateEmail : function(component, event, helper) {
   
		var isValidEmail = true; 
        var emailField = component.find("email_address");
        var emailFieldValue = emailField.get("v.value");       
        var regExpEmailformat = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;  
        
        if(!$A.util.isEmpty(emailFieldValue)){   
            if(emailFieldValue.match(regExpEmailformat)){
			  emailField.set("v.errors", [{message: null}]);
              $A.util.removeClass(emailField, 'slds-has-error');
              isValidEmail = true;
        }else{
             $A.util.addClass(emailField, 'slds-has-error');
             emailField.set("v.errors", [{message: "Please enter a valid email address"}]);
             isValidEmail = false;
        }
       }
      
     // if Email Address is valid then execute code     
       if(isValidEmail){
         // code write here..if Email Address is valid. 
       }
	},   
    current_address_since : function(component, event, helper) {//13 Feb 2020  //DD/MM/YYYY 2020-02-13
        let string_date = component.get("v.client.current_address_since").toString();
        
        if(string_date.includes("-")){
            let modified_date = string_date.substring(8, 10)+"/"+string_date.substring(5, 7)+"/"+string_date.substring(0, 4);
            component.set("v.client.current_address_since",modified_date);
        }else if(string_date.includes("/")){
            component.set("v.client.current_address_since",string_date);
        }
        
    },
})