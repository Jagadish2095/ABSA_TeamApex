({
	myAction : function(component, event, helper) {
		
	},
    
    doInit: function(component, event, helper) {
        helper.doInit(component);       
    },
    
    newFna : function (component, event, helper) { 
        helper.newFna(component);
    },
    
    onPicklistBankActionChange: function(component, event, helper) {
        component.set("v.fna.Cash_Action__c", event.getSource().get("v.value"));
    },
    
    onPicklistLispSharesActionChange: function(component, event, helper) {
        component.set("v.fna.Investment_Action__c", event.getSource().get("v.value"));
    },
    
    onPicklistFixedPropertiesActionChange: function(component, event, helper) {
        component.set("v.fna.Fixed_Properties_Action__c", event.getSource().get("v.value"));
    },
    
    onPicklistLifePoliciesActionChange: function(component, event, helper) {
        component.set("v.fna.Life_Policies_Action__c", event.getSource().get("v.value"));
    },
    
    onPicklistOtherAssetsActionChange: function(component, event, helper) {
        component.set("v.fna.Other_Assets_Action__c", event.getSource().get("v.value"));
    },
    
    navigateToAssetsAfterMotivation : function (component, event, helper) {
        component.set("v.showAssets", true);
        component.set("v.showLiabilities", false);
        component.set("v.showResults", false);
        component.set("v.showMotivation", false);
    },
    
    navigateToMotivation : function (component, event, helper) {        
        component.set("v.showAssets", false);
        component.set("v.showLiabilities", false);
        component.set("v.showResults", false);
        component.set("v.showMotivation", true);
    },
    
    saveFna : function(component, event, helper) {
        helper.saveFna(component);
    },
    
    saveShortFna : function(component, event, helper) {
        helper.saveShortFna(component);
    },
    
    createNewFna : function (component, event, helper) {  
        component.set("v.fna.lump_sum_Assets_Capture__c", null);
        component.set("v.fna.Comment__c", null);
        
        component.set("v.showInitialSelect", true);
        component.set("v.showResults", false);
    },
    
    createNewShortFna : function (component, event, helper) {
        component.set("v.fna.lump_sum_Assets_Capture__c", null);
        component.set("v.fna.Comment__c", null);
        
        component.set("v.showInitialSelect", true);
        component.set("v.showShortResults", false);
    },
    
    cancelFunc : function (component, event, helper) {
        component.set("v.showInitialSelect", false);
        component.set("v.showMotivation", false);
        component.set("v.showShortAssets", false);
        var a = component.get('c.doInit');
        $A.enqueueAction(a);
    },
    
    openConfirmation: function(component, event, helper) {
      // for Display Model,set the "isOpen" attribute to "true"
      component.set("v.showConfirmation", true);
   	},
 
    closeConfirmation: function(component, event, helper) {
        // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
        component.set("v.showConfirmation", false);
    },
    
    confrimAndClose: function(component, event, helper) {
        // Display alert message on the click on the "Like and Close" button from Model Footer 
        // and set set the "isOpen" attribute to "False for close the model Box.
        component.set("v.showConfirmation", false);
        var a = component.get('c.cancelFunc');
        $A.enqueueAction(a);
    }
})