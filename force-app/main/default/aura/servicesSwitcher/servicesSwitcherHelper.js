({  
    handleInit : function(component, event) {

        console.log('selectedAccount----> ' + JSON.stringify(component.get('v.accountSelected')));
        let serviceLabel = component.get('v.serviceLabel');

        let attributeName = this.getTargetComponentDetails(serviceLabel).attribute;

        if (attributeName) {
            component.set(attributeName, true);

        } else {
            console.log('attributeName is undefined');
        }
    },

    /**
     * For new service add custom label to cmpWhatDoYouWantToDoToday (array in helper)
     * and add label with new attribute and component here for aura:if to show and call target component
     */
    getTargetComponentDetails: function(label) {

        let labelsWithDetails = [
            { label : $A.get("$Label.c.Category_Change"), attribute: 'v.showCategoryChange', componentDef: 'c:categoryChangeContainer'},
            { label: $A.get("$Label.c.Price_Scheme_Change"), attribute : 'v.showPriceSchemeChange', componentDef: 'c:priceSchemeChangeContainer'}
        ];

        let componentDetails = labelsWithDetails.find(item => {
            return item.label === label;
        });

        return componentDetails;
    },

    handlestartBioFlow : function(component, event) {
        let accountSelected = component.get('v.accountSelected');

        let cif = accountSelected.CIF__c;
        let idNumber = accountSelected.ID_Number__pc;

        if (this.validateCifAndIdNumber(cif, idNumber)) {
            let buttonName = event.getSource().get('v.name');

            let componentDef = this.getTargetComponentDetails(component.get('v.serviceLabel')).componentDef;

            let useBio = buttonName === 'bio' ? true : false;

            var evt = $A.get("e.force:navigateToComponent");

            let eventParams = {
                componentDef : componentDef,             
                componentAttributes: {
                    useBiometrics: useBio,
                    clientDetails: component.get('v.accountSelected')
                }
            };
            
            evt.setParams(eventParams);

            evt.fire();
        }
    },

    validateCifAndIdNumber : function(cif, idNumber) {
        
        if (!cif) {
            let noCifToast = $A.get("e.force:showToast");

            noCifToast.setParams({
                title: "Error",
                type: "error",
                message: "The CIF (CIF__c) field of current Account is blank!"
            });
            noCifToast.fire();

            return;
        }

        if (!idNumber) {
            let noIdNumberToast = $A.get("e.force:showToast");

            noIdNumberToast.setParams({
                title: "Error",
                type: "error",
                message: "The ID Number (ID_Number__pc) field of current Account is blank!"
            });
            noIdNumberToast.fire();

            return;
        }

        return true;
    }
})