({
    doInit: function(component, event, helper) { 
        
        
        helper.getpickListValue(component, event);
    },
    
    handleChange: function (component, event,helper) {
        
        var changeValue = event.getParam("value");
        console.log('changeValue'+changeValue);
        if(changeValue =="Yes" || changeValue=="Limited" || changeValue=="Ratcheting" || changeValue=="the Borrower" || changeValue=="the Parent"
          ||changeValue =="the Guarantor(s)"||changeValue =="the Security Provider(s)" || changeValue ==" the other Entity" || changeValue =="Standard Clause"){
            var titleyes = component.get("v.titleyes"); 
            console.log('titleyes'+titleyes);
            component.set("v.tooltipvalue",titleyes); 
        }
        else if (changeValue =="No" || changeValue=="Unlimited" || changeValue=="No Ratcheting" || changeValue=="the Borrower and its Subsidiaries"
                 || changeValue=="the Parent and its Subsidiaries"|| changeValue =="the Guarantor(s) and its Subsidiaries" || changeValue =="the Security Provider(s) and its Subsidiaries"
                ||changeValue =="the other Entity and its Subsidiaries" ||changeValue =="Payout In Tranches"){
            var titleno = component.get("v.titleno"); 
            console.log('titleno'+titleno);
            component.set("v.tooltipvalue",titleno); 
        }
        
    },
    
    
    
    
})