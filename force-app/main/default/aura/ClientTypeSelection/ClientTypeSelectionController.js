({
	doInit : function(component, event, helper) {
		component.set("v.showClientType",true);
        helper.fetchClientGroupValues(component, event, helper);
	},
    closeRPModal: function(component, event, helper) {
		component.find("popuplib").notifyClose();		
	},
    sendClientType: function(component, event, helper) {
        var clientTypeValue = component.find("clientTypeId").get("v.value");
        var clientGroup = component.find("clientGroupId").get("v.value");
        var placeofresidence = component.find("placeOfResidenceId").get("v.value");
        
        if(clientGroup!='' && clientTypeValue!='' && placeofresidence!=''){
            //Mbuyiseni Mbhokane: Added private company as client type
            if(clientTypeValue=='Private Individual' || clientTypeValue=='Trusts' || clientTypeValue=='Private Company' || clientTypeValue=='Close Corporation' || 
               clientTypeValue=='Foreign Listed Company' || clientTypeValue=='Foreign Trust' || clientTypeValue=='Public Listed Company' || 
               clientTypeValue=='Foreign Company' || clientTypeValue=='Co-operative' || clientTypeValue=='Incorporated Company' ||
               clientTypeValue=='Non Profit Organizations (NGO)' || clientTypeValue=='Clubs/Societies/Associations/Other Informal Bodies'||
               clientTypeValue=='Non Profit Companies' || clientTypeValue=='PARTNERSHIP' || clientTypeValue=='Central Bank or Regulator' || 
               clientTypeValue=='Deceased Estate' || clientTypeValue=='Regulated Credit Entities and Financial Institutions') {
                var applicationEvent = $A.get("e.c:clientTypeEvent");
                applicationEvent.setParams({
                    "selectedclienttype" : clientTypeValue,
                    "selectedclientgroup" : clientGroup,
                    "selectedplaceOfResidence":placeofresidence,
                });
                applicationEvent.fire();
                component.find("popuplib").notifyClose();
            } else{
                var toastEvent = helper.getToast("Error", "You are not allowed to Onboard or add this Entity as a Related Party - " + clientTypeValue , "error"); //
            	toastEvent.fire();
            }
            
        } else{
            var toastEvent = helper.getToast("Error", "Please complete fields", "error");
            toastEvent.fire();
        }
        
        
	},
    setClientTypeValue : function(component, event, helper) {
        helper.fetchClientTypeValues(component, event, helper);
    },
    
    setClientPlaceOfResidenceValue : function(component, event, helper) {
        if(component.find("clientTypeIdField")) {
            component.find("clientTypeIdField").set("v.value", component.find("clientTypeId").get("v.value"));
        }
    },
})