({
	myAction : function(component, event, helper) {
		
	},
    clear : function(component,event,helper){
        let id_name = event.getSource().getLocalId();
        if (id_name == 'clear_gross_income'){
             component.set('v.client.gross_income','');
            
        } else if (id_name == 'clear_salary_deductions'){
            component.set('v.client.salary_deductions','');
            
        } else if (id_name == 'clear_net_salary_income_month_1'){
            component.set('v.client.net_salary_income_month_1','');
            
        } else if (id_name == 'clear_net_salary_income_month_2'){
            component.set('v.client.net_salary_income_month_2','');
            
        } else if (id_name == 'clear_net_salary_income_month_3'){
            component.set('v.client.net_salary_income_month_3','');
            
        } else if (id_name == 'clear_salary_deducted_fixed_debit'){
            component.set('v.client.salary_deducted_fixed_debit','');
            
        } else if (id_name == 'clear_rental_income'){
            component.set('v.client.rental_income','');
            
        } else if (id_name == 'clear_other_additional_income'){
            component.set('v.client.other_additional_income','');
            
        } else if (id_name == 'clear_total_net_monthly_income'){
            component.set('v.client.total_net_monthly_income','');
            
        } else if (id_name == 'clear_bond_mortgage'){
            component.set('v.client.bond_mortgage','');
            
        } else if (id_name == 'clear_loan_overdraft'){
            component.set('v.client.loan_overdraft','');
            
        } else if (id_name == 'clear_credit_cards'){
            component.set('v.client.credit_cards','');
            
        } else if (id_name == 'clear_asset_and_finance_repayment'){
            component.set('v.client.asset_and_finance_repayment','');
            
        }  else if (id_name == 'clear_retail_accounts'){
            component.set('v.client.retail_accounts','');
            
        } else if (id_name == 'clear_other_debt_repayment'){
            component.set('v.client.other_debt_repayment','');
            
        } else if (id_name == 'clear_total_dept_repayment'){
            component.set('v.client.total_dept_repayment','');
            
        } else if (id_name == 'clear_surplus_shortage'){
            component.set('v.client.surplus_shortage','');
            
        }  else if (id_name == 'clear_total_monthly_expenses'){
            component.set('v.client.total_monthly_expenses','');
        }  

    },
    ValidateAndUpdateAmount: function(component, event){
        let gross_income = component.get("v.client.gross_income");  
        let salary_deductions = component.get("v.client.salary_deductions"); 
          
        let net_salary_income_month = (gross_income? parseFloat(gross_income):0) - (salary_deductions? parseFloat(salary_deductions):0);
        component.set("v.client.net_salary_income_month_1",net_salary_income_month);
        component.set("v.client.net_salary_income_month_2",net_salary_income_month);
        component.set("v.client.net_salary_income_month_3",net_salary_income_month);
        
        let month1 = component.get("v.client.net_salary_income_month_1");
        let month2 = component.get("v.client.net_salary_income_month_2");
        let month3 = component.get("v.client.net_salary_income_month_3");
        
        
        let rental_income = component.get("v.client.rental_income");
        let other_additional_income = component.get("v.client.other_additional_income");
        //let total_net_monthly_income  =  ((net_salary_income_month*3)/3)+(rental_income? parseFloat(rental_income):0) - (salary_deducted_fixed_debit? parseFloat(salary_deducted_fixed_debit):0) + (other_additional_income? parseFloat(other_additional_income):0);
        let total_net_monthly_income  =  ((month1+month2+month3)/3)+(rental_income? parseFloat(rental_income):0) + (other_additional_income? parseFloat(other_additional_income):0);

        component.set("v.client.total_net_monthly_income",total_net_monthly_income);
        
         let monthly_income_range = component.get("v.client.monthly_income_label"); 
        
        if(gross_income && monthly_income_range){
            var removed_R = monthly_income_range.slice(1);
            
            if(removed_R.includes("-")){
                var index_x = removed_R.indexOf("-");
            }else if(removed_R.includes("+")){
                var index_x = removed_R.indexOf("+");
            }
            
            
            var first_range = parseFloat(removed_R.slice(0,index_x));
            
            if(removed_R.includes("-")){
                var second_range = parseFloat(removed_R.slice(index_x+1,removed_R.length));
                
                if(!(gross_income>=first_range && gross_income<=second_range)){
                    var message = "Employment  income range miss match";
                    component.set("v.monthly_income_range_condition", true);
                    component.set("v.client.monthly_income_range_validation",message);                                                 
                }else{
                    component.set("v.monthly_income_range_condition", false);
                    component.set("v.client.monthly_income_range_validation","");  
                }
            }else if(removed_R.includes("+")){
                
                if(!(gross_income>=first_range)){
                    var message = "Employment  income range miss match";
                    component.set("v.monthly_income_range_condition", true);
                    component.set("v.client.monthly_income_range_validation",message);                                                 
                }else{
                    component.set("v.monthly_income_range_condition", false);
                    component.set("v.client.monthly_income_range_validation","");  
                }
            }
           
        }else{
            var message = "Gross income required";
            component.set("v.monthly_income_range_condition", true);
            component.set("v.client.monthly_income_range_validation",message);    
        }
    },
    ValidateAndUpdateAmountMonthly: function(component, event){ 
        
        
        let month1 = component.get("v.client.net_salary_income_month_1");
        let month2 = component.get("v.client.net_salary_income_month_2");
        let month3 = component.get("v.client.net_salary_income_month_3");
        
        
        let rental_income = component.get("v.client.rental_income");
        let other_additional_income = component.get("v.client.other_additional_income");
        let total_net_monthly_income  =  ((month1+month2+month3)/3)+(rental_income? parseFloat(rental_income):0) + (other_additional_income? parseFloat(other_additional_income):0);
        
        component.set("v.client.total_net_monthly_income",total_net_monthly_income);
    },
    ValidateAndUpdateAmountTotalDebtRepayment : function(component, event){ 
        
        
        let bond_mortgage = component.get("v.client.bond_mortgage");
        let loan_overdraft = component.get("v.client.loan_overdraft");
        let credit_cards = component.get("v.client.credit_cards");
        let asset_and_finance_repayment = component.get("v.client.asset_and_finance_repayment");
        let retail_accounts = component.get("v.client.retail_accounts");
        let other_debt_repayment = component.get("v.client.other_debt_repayment");
        let salary_deducted_fixed_debit = component.get("v.client.salary_deducted_fixed_debit");
        
        let total_dept_repayment = (bond_mortgage? parseFloat(bond_mortgage):0) + (loan_overdraft? parseFloat(loan_overdraft):0) + (credit_cards? parseFloat(credit_cards):0) + (asset_and_finance_repayment? parseFloat(asset_and_finance_repayment):0)  + (retail_accounts? parseFloat(retail_accounts):0) + (other_debt_repayment? parseFloat(other_debt_repayment):0) + (salary_deducted_fixed_debit? parseFloat(salary_deducted_fixed_debit):0);
        component.set("v.client.total_dept_repayment",total_dept_repayment);
    },   
    ValidateAndUpdateAmountTotalMonthlyExpenses : function(component, event){ 
        
        
        let necessary_expenses = component.get("v.client.necessary_expenses");
        let total_dept_repayment = component.get("v.client.total_dept_repayment");
        
        
        let total_monthly_expenses = (necessary_expenses? parseFloat(necessary_expenses):0) + (total_dept_repayment? parseFloat(total_dept_repayment):0);
        component.set("v.client.total_monthly_expenses",total_monthly_expenses);
    },   
    ValidateAndUpdateAmountSurplusShortage: function(component, event){ 
        
        
        let total_net_monthly_income = component.get("v.client.total_net_monthly_income");
        let total_monthly_expenses = component.get("v.client.total_monthly_expenses");
        
        
        let surplus_shortage = (total_net_monthly_income? parseFloat(total_net_monthly_income):0) - (total_monthly_expenses? parseFloat(total_monthly_expenses):0);
        component.set("v.client.surplus_shortage",surplus_shortage);
    },
})