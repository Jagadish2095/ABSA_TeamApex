({
     init: function (component, event, helper) {
         
         var actions = [
            { label: 'Edit', name: 'edit_tradingAsName' },
            { label: 'Delete', name: 'delete_tradingAsName' }
        ];
        component.set('v.columns', [
            {label: 'Full Name', fieldName: 'Name', type: 'text' ,editable: false},
            {label: 'Registration/Incorporation Number', fieldName: 'Registration_Incorporation_Number__c', type: 'text' ,editable: false},
            {label: 'ID Type', fieldName: 'ID_Type__c', type: 'text' ,editable: false},
            {label: 'Client Group', fieldName: 'Client_Group__c', type: 'text' ,editable: false},
            {label: 'Client Type', fieldName: 'Client_Type__c', type: 'text' ,editable: false},
            {label: 'Date Established', fieldName: 'Date_Established__c', type: 'text' ,editable: false},
            {label: 'Country of Incorporation', fieldName: 'Country_of_Incorporation__c', type: 'text' ,editable: false},
            {label: 'Client Code', fieldName: 'CIF__c', type: 'text' ,editable: false},
            { type: 'action', typeAttributes: { rowActions: actions } }
            
        ]);
        helper.getTradingAsNames(component,event, helper);
         
    }, 
    
    doAction : function(component, event, helper) {
        helper.getTradingAsNames(component, event, helper);        
    },
    handleSave : function(component, event, helper) {
        helper.handleSaveEdition(component, event, helper);        
    },
            
    createTradingNameRecord : function (component, event, helper) {

        var existingId = component.get("v.tradingAsNameEditId");
        if(existingId != null) {
            helper.upsertTradingAsName(component, event, helper, false);
        } else {
            helper.upsertTradingAsName(component, event, helper, true);
        }
		 
	},
    
    openNewTradingNameModal : function(component, event, helper) {
        component.set("v.tradingNameRecord.Account__c", component.get("v.accRecId"));
        component.set("v.tradingNameRecord.Name", 'T/A ');
        component.set("v.showNewTradingNameModal", true); 
        component.set("v.tradingAsNameEditId", null);
        component.set("v.tradingNameRecId", null);
        component.set("v.tradingNameRecord.Id", null);
            console.log('accRecId : ' +  component.get("v.accRecId"));
    },        
            
    closeNewTradingNameModal : function(component, event, helper) {
        component.set("v.showNewTradingNameModal", false);       
    },
    
    handleRowAction: function (component, event, helper) {
        var action = event.getParam('action');
        switch (action.name) {
            case 'edit_tradingAsName':
                var row = event.getParam('row');    
                console.log(row.Id);
                component.set("v.tradingAsNameEditId",row.Id);
                helper.getSelectedTradingAsNameDetails(component, event, helper);
                component.set("v.showNewTradingNameModal",true);
            	break;
            case 'delete_tradingAsName':
                var row = event.getParam('row');
                console.log(row.Id);
                component.set("v.tradingAsNameDeleteId", row.Id);
                component.set("v.showDeleteConfirmation", true);
                break;
        }
    },
    

    confirmDeleteAction: function(component, event, helper) {
        component.set("v.showDeleteConfirmation", false);
        helper.deleteTradingAsName(component, event, helper);
    },

    cancelDeleteAction: function(component, event, helper) {
        component.set("v.showDeleteConfirmation", false);
    },

    
})