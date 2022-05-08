({
    check_validation: function(component,event,helper){
          var client =  component.get("v.client");
          (client.purpose_of_loan_value) ? (component.set("v.purpose_of_loan_condition", false)) : ( component.set("v.purpose_of_loan_condition", true)); 
        
          (client.number_of_payments_value) ? (component.set("v.number_of_payments_condition", false)) : ( component.set("v.number_of_payments_condition", true));        

           (client.initiation_fee_payment_method_value) ? (component.set("v.initiation_fee_payment_method_condition", false)) : ( component.set("v.initiation_fee_payment_method_condition", true));        

           (client.additional_loan_amount) ? (component.set("v.additional_loan_amount_condition", false)) : ( component.set("v.additional_loan_amount_condition", true));   
        
        if(client.purpose_of_loan_value != '02'){
            component.set("v.client.race_indicator_value","");
            component.set("v.client.race_indicator_label","");
        }

         
    },   
    
    clear : function(component,event,helper){
        let id_name = event.getSource().getLocalId();
        if (id_name == 'clear_other'){
            component.set('v.client.other','');
            
        } else if (id_name == 'clear_additional_loan_amount'){
            component.set('v.client.additional_loan_amount','');
            
        } else if (id_name == 'clear_settlement_other_products'){
            component.set('v.client.settlement_other_products','');
        }
        
    },
    /*totalAmount: function(component,event,helper){ 
                
        let total_amount = component.get("v.client.total_amount");
        let additional_loan_amount = component.get("v.client.additional_loan_amount");
        
        if(total_amount == undefined){
            total_amount = 0;
        }
        
        let sum = parseFloat(total_amount,10) + parseFloat(additional_loan_amount,10);
        
        if(sum){
            component.set("v.client.total_amount_plus_additional_amount",sum.toString());
        }else{
            component.set("v.client.total_amount",total_amount.toString());
            component.set("v.client.total_amount_plus_additional_amount",'');
        }
        
    }  */  
})