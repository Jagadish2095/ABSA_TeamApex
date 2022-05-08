({
	myAction : function(component, event, helper) {
		
	},
    
    doInit: function(component, event, helper) {
        helper.fetchPickListVal(component, 'ID_Type__pc', 'idType');
        helper.fetchPickListVal(component, 'Client_Type__c', 'clientType');
        helper.fetchPickListVal(component, 'Nationality__pc', 'nationality');
        helper.fetchPickListVal(component, 'Country_of_Residence__pc', 'countryResidence');
        helper.fetchPickListVal(component, 'Country_of_Birth__pc', 'countryBirth');
        helper.fetchPickListVal(component, 'Country_of_Registration__c', 'countryRegistration');
        
        helper.checkOnInitValidity(component);
        helper.checkAccountRecordType(component);
        helper.checkCasaStatus(component);
    },
    
    doCasaScreening : function(component, event, helper) {
        helper.casaScreening(component);
	},
    
    redoScreening : function(component, event, helper) {
        component.set("v.showCasaScreen", true);
        component.set("v.showFinishedScreen", false);
	},
    
    refreshStatus : function(component, event, helper) {
        helper.refreshStatus(component);
	},
    
    onPicklistIdTypeChange: function(component, event, helper) {
        component.set("v.account.ID_Type__pc", event.getSource().get("v.value"));
    },
    onPicklistClientTypeChange: function(component, event, helper) {
        component.set("v.account.Client_Type__c", event.getSource().get("v.value"));
    },
    onPicklistNationalityChange: function(component, event, helper) {
        component.set("v.account.Nationality__pc", event.getSource().get("v.value"));
    },
    onPicklistCountryResidenceChange: function(component, event, helper) {
        component.set("v.account.Country_of_Residence__pc", event.getSource().get("v.value"));
    }, 
    onPicklistCountryBirthChange: function(component, event, helper) {
        component.set("v.account.Country_of_Birth__pc", event.getSource().get("v.value"));
    },
    onPicklistCountryRegistrationChange: function(component, event, helper) {
        component.set("v.account.Country_of_Registration__c ", event.getSource().get("v.value"));
    },
})