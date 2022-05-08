({
    doInit : function(component, event, helper){
        helper.reasonToCancel(component);
        component.set('v.selectedAccountNumber',component.get('v.selectedAccountNumberToFlow'));        
   
    },
    
    
    onTelephoneBanking : function(component, event, helper){
        var teleBankingCheck = component.find("teleBankingCheck").get("v.checked");
        if(teleBankingCheck === true){
            component.set("v.telephoneBanking",'Y'); 
            component.find("noneCheck").set("v.disabled", true);
        }else{
            component.set("v.telephoneBanking",'N');
            component.find("noneCheck").set("v.disabled", false);
        }
    },
    
    
    onATMCheck : function(component, event, helper){
        var atmCheck = component.find("atmCheck").get("v.checked"); 
        if(atmCheck === true){
            component.set("v.atm",'Y'); 
            component.find("noneCheck").set("v.disabled", true);
        }else{
            component.set("v.atm",'N'); 
            component.find("noneCheck").set("v.disabled", false);
        }
    },
    
    onDebit : function(component, event, helper){
        var debitOrderCheck = component.find("debitOrderCheck").get("v.checked"); 
        if(debitOrderCheck === true){
            component.set("v.debitOrder",'Y'); 
            component.find("noneCheck").set("v.disabled", true);
        }else{
            component.set("v.debitOrder",'N'); 
            component.find("noneCheck").set("v.disabled", false);
        }
    },
    
    onPickNPay : function(component, event, helper){
        var pickPayCheck = component.find("debitOrderCheck").get("v.checked"); 
        if(pickPayCheck === true){
            component.set("v.pickPay",'Y'); 
            component.find("noneCheck").set("v.disabled", true);
        }else{
            component.set("v.pickPay",'N'); 
            component.find("noneCheck").set("v.disabled", false);
        }
    },
    
    onStoreVendor : function(component, event, helper){
        var storeVenderCheck = component.find("storeVenderCheck").get("v.checked"); 
        if(storeVenderCheck === true){
            component.set("v.storeVender",'Y');
            component.find("noneCheck").set("v.disabled", true);
        }else{
            component.set("v.storeVender",'N'); 
            component.find("noneCheck").set("v.disabled", false);
        }
    },
    
    onMobile : function(component, event, helper){
        var mobileCheck = component.find("mobileCheck").get("v.checked"); 
        if(mobileCheck === true){
            component.set("v.mobile",'Y'); 
            component.find("noneCheck").set("v.disabled", true);
        }else{
            component.set("v.mobile",'N'); 
            component.find("noneCheck").set("v.disabled", false);
        }
    },
    
    onNone : function(component, event, helper){
        var noneCheck = component.find("noneCheck").get("v.checked"); 
        if(noneCheck === true){
            component.set("v.none",'Y'); 
            component.find("teleBankingCheck").set("v.disabled", true);
            component.find("atmCheck").set("v.disabled", true);
            component.find("debitOrderCheck").set("v.disabled", true);
            component.find("pickPayCheck").set("v.disabled", true);
            component.find("storeVenderCheck").set("v.disabled", true);
            component.find("mobileCheck").set("v.disabled", true);
        }else{
            component.set("v.none",'N'); 
            component.find("teleBankingCheck").set("v.disabled", false);
            component.find("atmCheck").set("v.disabled", false);
            component.find("debitOrderCheck").set("v.disabled", false);
            component.find("pickPayCheck").set("v.disabled", false);
            component.find("storeVenderCheck").set("v.disabled", false);
            component.find("mobileCheck").set("v.disabled", false);
        }
    },
    
    
    submitYes : function(component, event, helper){
        var selectedReason =  component.find("selectReasonId").get("v.value");  
        
        if(selectedReason =='' || selectedReason == null  ){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message":" Reasons for cancellation Cannot Be Blank.",
                "type":"error"
            });
            toastEvent.fire();   
        } else{
            helper.submitYes(component);  
        }
        
    },
    
    submitNo : function(component, event, helper){

        component.set("v.none",'N'); 
        component.find("teleBankingCheck").set("v.disabled", false);
        component.find("atmCheck").set("v.disabled", false);
        component.find("debitOrderCheck").set("v.disabled", false);
        component.find("pickPayCheck").set("v.disabled", false);
        component.find("storeVenderCheck").set("v.disabled", false);
        component.find("mobileCheck").set("v.disabled", false);
    }
    
    
})