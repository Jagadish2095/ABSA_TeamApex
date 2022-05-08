({
	first_payment_date : function(component, event, helper) {//13 Feb 2020  //DD/MM/YYYY 2020-02-13
       
        let string_date = component.get("v.client.first_payment_date").toString();
        
        if(string_date.includes("-")){
            let modified_date = string_date.substring(8, 10)+"/"+string_date.substring(5, 7)+"/"+string_date.substring(0, 4);
            component.set("v.client.first_payment_date",modified_date);
        }else if(string_date.includes("/")){
            component.set("v.client.first_payment_date",string_date);
        }
    },
})