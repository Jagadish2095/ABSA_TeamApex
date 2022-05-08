({
    doInit: function (component, event, helper) {
        helper.doBaseInit(component);
        helper.setTariffLabels(component);
    },

    tariffOptionTypeChangesClick: function (component, event, helper) {
        let pricingScheme = component.find('pricingScheme');
        let accountNumber = component.find('accountNumber');

        if (component.get("v.tariffOptionsValue") == 'pricingScheme') {
            if ($A.util.isEmpty(component.get('v.pricingSchemeOptions'))) {
                helper.getPricingSchemes(component);
            }

            $A.util.addClass(pricingScheme, 'tariff-enquiry-active-field');
            $A.util.removeClass(accountNumber, 'tariff-enquiry-active-field');
            component.set("v.accountNumber", '');
        } else if (component.get("v.tariffOptionsValue") == 'accountNumber') {
            $A.util.removeClass(pricingScheme, 'tariff-enquiry-active-field');
            $A.util.addClass(accountNumber, 'tariff-enquiry-active-field');
            component.set("v.pricingScheme", '');
        }

        helper.updateComponentData(component, helper);
    },

    handleTariffOptionsChange: function (component, event, helper) {
        helper.updateComponentData(component, helper);
    },
})