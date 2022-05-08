({
	myAction : function(component, event, helper) {
		
	},
    
    doInit: function(component, event, helper) {  
        helper.fetchPickListVal(component, 'Occupation_Category__pc', 'occupationCategory');
        helper.fetchPickListVal(component, 'Occupation_Status__pc', 'occupationStatus');
        helper.fetchPickListVal(component, 'Income_Source__pc', 'sourceIncome');
        helper.fetchPickListVal(component, 'Countries_Traded_With__c', 'countriesTraded');
        
        helper.checkOnInitValidity(component);
        helper.riskRatingData(component);
        
        helper.checkAccountRecordType(component);
    },
    
    doRiskScreening : function(component, event, helper) {
        helper.riskScreening(component);
        helper.riskRatingData(component);
	},
    
    redoScreening : function(component, event, helper) {
        component.set("v.showRiskScreen", true);
        component.set("v.showFinishedScreen", false);
	},
    
    onPicklistOccupationCategoryChange: function(component, event, helper) {
        component.set("v.account.Occupation_Category__pc", event.getSource().get("v.value"));
    },
    onPicklistOccupationStatusChange: function(component, event, helper) {
        component.set("v.account.Occupation_Status__pc", event.getSource().get("v.value"));
    },
    onPicklistSourceIncomeChange: function(component, event, helper) {
        component.set("v.account.Income_Source__pc", event.getSource().get("v.value"));
    },
    multiPicklistCountriesTradedChange: function(component, event, helper) {
        component.set("v.account.Countries_Traded_With__c", event.getSource().get("v.value"));
        //alert(component.get("v.countriesTradedValues"));
    },
})