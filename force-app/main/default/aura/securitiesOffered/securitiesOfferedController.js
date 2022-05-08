({
    doInit: function (component, event, helper) {
        component.set('v.columns', [
            {
                label: 'Principal/Shareholder Name', fieldName: 'FullName', type: 'url',
                typeAttributes: { label: { fieldName: 'FullName' }, taget: '_princilDetails' }
            },
            { label: 'Main', fieldName: 'isMain', type: 'text' },
            { label: 'CIF', fieldName: 'CIF', type: 'text' },
            { label: 'ID Number', fieldName: 'IDNumber', type: 'text' },
            { label: 'Controlling Interest %', fieldName: 'SharePercentage', type: 'percentage' },
            { label: 'CASA Reference', fieldName: 'CASAReferenceNumber', type: 'text' },
            { label: 'CASA Result', fieldName: 'CASAScreeningStatus', type: 'text' }
        ]);

        component.set('v.securitiesOfferedcolumns', [
            { label: 'Security Provider Name', fieldName: 'Name', type: 'text', wrapText: true },
            { label: 'Security Type', fieldName: 'Security_Type__c', type: 'text', wrapText: true },
            { label: 'Security Description', fieldName: 'Security_Description__c', type: 'text', wrapText: true},
            { label: 'Security Amount (R)', fieldName: 'securityAmount', type: 'currency' },
            { label: 'Nominal Value (R)', fieldName: 'Nominal_Value__c', type: 'currency'},
            { label: 'ASV %', fieldName: 'ASV_approved_by_Credit__c', type: 'percentage', initialWidth: 34, cellAttributes: { alignment: 'right' }},
            { label: 'ASV (R)', fieldName: 'Approved_security_value__c', type: 'currency'},
            { label: 'Specific Account', fieldName: 'Reference_Account_Number__c', type: 'text'}
            //,
            //{ type: 'action', typeAttributes: { rowActions: actions }}
        ]);

        helper.fetchData(component);
        helper.getExistingSecurities(component);
        helper.showSelectedProducts(component, event, helper);
        //helper.getExistingSecuritiesforAccount(component, event, helper);
        helper.getPrimaryAccount(component);
        //helper.getSumofSecuritiesOffered(component);
        //helper.asvCalculations(component, event, helper);
    },

    openNewSecuritiesTab : function(component, event, helper) {
        var oppId = component.get( "v.recordId" );
        var selectedRows = component.get('v.selectedRows');
        var selectedMember = event.getSource().get("v.name");
        console.log('selectedRows '+ selectedRows +' selected Id '+ selectedMember);

        var selectedMemberValue = component.get("v.selectedMemberValue");
        console.log('Add new security for ' + selectedMember);

        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:addNewSecurity",
            componentAttributes: {
                recordId :oppId,
                memberId :selectedMember
            }
        });
        evt.fire();
    },

    addExternalNewSecurity : function(component, event, helper) {
        component.set("v.showAddSecurityModal", true); 
        var selectedMemberValue = component.get("v.selectedMember");
        console.log('Add external security' );
    },

    //Close Product Term Request
    closeNewProductTermsModal: function(component, event, helper) {
        component.set("v.showAddSecurityModal", false); 
    },

    handlerefreshEvent : function(component, event, helper) {
        console.log('<<<<<<Tadamwa>>>>>');
        helper.getExistingSecurities(component);
    },
})