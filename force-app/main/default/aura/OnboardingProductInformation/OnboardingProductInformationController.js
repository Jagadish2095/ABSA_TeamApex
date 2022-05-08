({
    doInit: function(component, event, helper) {
        helper.getOpp(component,event,helper);//Added By Himani Joshi
        helper.showSelectedProduct(component, event, helper);
        var securityoffered = component.get("v.OppRecord.Security_Type_Offered__c");

        if(securityoffered !=undefined ){
            component.set("v.showDisabled",true);
        }else{
           component.set("v.showDisabled",false);
        }
    },

    SaveProduct : function(component, event, helper){
        helper.saveSelectedProduct(component, event, helper);
    },
    updateIllustrative: function(component, event, helper)
    {
        helper.saveIllustrativeDecision(component, event, helper);
    },
    handleChange: function(component, event, helper){
    	component.find("appCreditForm").submit();
        component.set("v.showDisabled",true);
	}
})