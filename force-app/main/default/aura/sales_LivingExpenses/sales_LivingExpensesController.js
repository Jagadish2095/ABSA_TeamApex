({
	myAction : function(component, event, helper) {
		
	},
    clear : function(component,event,helper){
        let id_name = event.getSource().getLocalId();
        if (id_name == 'clear_groceries'){
             component.set('v.client.groceries','');
            
        } else if (id_name == 'clear_contact_number'){
            component.set('v.client.contact_number','');
            
        } else if (id_name == 'clear_domestic_garderner_worker_etc'){
            component.set('v.client.domestic_garderner_worker_etc','');
            
        } else if (id_name == 'clear_telephone_cellphone'){
            component.set('v.client.telephone_cellphone','');
            
        } else if (id_name == 'clear_education_school_loan_repayment'){
            component.set('v.client.education_school_loan_repayment','');
            
        } else if (id_name == 'clear_transport_petrol_excl_vehicle_finance'){
            component.set('v.client.transport_petrol_excl_vehicle_finance','');
            
        } else if (id_name == 'clear_insurance_and_funeral_policies'){
            component.set('v.client.insurance_and_funeral_policies','');
            
        } else if (id_name == 'clear_municipal_levies_rates_taxes_water_light'){
            component.set('v.client.municipal_levies_rates_taxes_water_light','');
            
        }  else if (id_name == 'clear_security'){
            component.set('v.client.security','');
            
        }  else if (id_name == 'clear_rental'){
            component.set('v.client.rental','');
            
        } else if (id_name == 'clear_maintenance'){
            component.set('v.client.maintenance','');
            
        } else if (id_name == 'clear_entertainment'){
            component.set('v.client.entertainment','');
            
        } else if (id_name == 'clear_specify_other_expenses'){
            component.set('v.client.specify_other_expenses','');
            
        } else if (id_name == 'clear_amount'){
            component.set('v.client.amount','');
            
        } else if (id_name == 'clear_necessary_expenses'){
            component.set('v.client.necessary_expenses','');
            
        } 
       
    },
    addAllLivingExpenses: function(component, event){
        
        var client =  component.get("v.client");
        
        if(client.groceries){
            component.set("v.groceries_condition", false)
        }else{
            component.set("v.groceries_condition", true)
        }
        
        let groceries = 0;
        let domestic_garderner_worker_etc = 0;
        let telephone_cellphone = 0;
        let education_school_loan_repayment = 0;
        let transport_petrol_excl_vehicle_finance =  0;
        let insurance_and_funeral_policies =  0;
        let municipal_levies_rates_taxes_water_light =  0;
        let security = 0;
        let rental =  0;
        let maintenance =  0;
        let entertainment =  0;
        let specify_other_expenses =  0;
        let amount =  0;
        
        groceries = client.groceries ? parseFloat(client.groceries) : 0;
        domestic_garderner_worker_etc = client.domestic_garderner_worker_etc ? parseFloat(client.domestic_garderner_worker_etc) : 0;
        telephone_cellphone = client.telephone_cellphone ? parseFloat(client.telephone_cellphone) : 0;
        education_school_loan_repayment = client.education_school_loan_repayment ? parseFloat(client.education_school_loan_repayment) : 0;
        transport_petrol_excl_vehicle_finance = client.transport_petrol_excl_vehicle_finance ? parseFloat(client.transport_petrol_excl_vehicle_finance) : 0;
        insurance_and_funeral_policies = client.insurance_and_funeral_policies ? parseFloat(client.insurance_and_funeral_policies) : 0;
        municipal_levies_rates_taxes_water_light = client.municipal_levies_rates_taxes_water_light ? parseFloat(client.municipal_levies_rates_taxes_water_light) : 0;
        security = client.security ? parseFloat(client.security) : 0;
        rental = client.rental ? parseFloat(client.rental) : 0;
        maintenance = client.maintenance ? parseFloat(client.maintenance) : 0;
        entertainment = client.entertainment ? parseFloat(client.entertainment) : 0;
        specify_other_expenses = client.specify_other_expenses ? parseFloat(client.specify_other_expenses) : 0;
        amount = client.amount ? parseFloat(client.amount) : 0;
        
        let totalExpense = groceries + domestic_garderner_worker_etc + telephone_cellphone + education_school_loan_repayment + transport_petrol_excl_vehicle_finance +insurance_and_funeral_policies + municipal_levies_rates_taxes_water_light + security + rental + maintenance + entertainment + specify_other_expenses + amount;
        
        component.set("v.client.necessary_expenses",totalExpense);
        
    },
})