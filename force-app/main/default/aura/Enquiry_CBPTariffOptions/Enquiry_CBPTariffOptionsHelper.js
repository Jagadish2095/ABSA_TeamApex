({
    //getValueBundleOptions
    getPricingSchemes: function (component) {
        component.set("v.showSpinner", true);

        let action = component.get('c.cqGetValueBundleOptions');

        let clientKey = component.get('v.clientKey');

        action.setParams({
            clientKey: clientKey
        });

        action.setCallback(this, function (response) {
            let state = response.getState();

            if (state === "SUCCESS") {
                let optionsResponse = response.getReturnValue();

                let pricingSchemeOptions = [];
                let priceSchemeOptionsDesc = [];

                if (!optionsResponse.length) {
                    let toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error",
                        "message": "There are no available Pricing Scheme options for current Client",
                        "mode": "sticky",
                        "type": "error"
                    });
                    toastEvent.fire();

                    return;
                }

                optionsResponse.forEach(function (option) {
                    if (option.PRICING_SCHEME_INDICATOR || option.CBP_SCHEME_DESCRIPTION || option.CBP_PRICING_SCHEME_CODE) {
                        let schemeCode = option.CBP_PRICING_SCHEME_CODE;

                        pricingSchemeOptions.push({
                            label: option.CBP_SCHEME_DESCRIPTION,
                            value: schemeCode
                        });

                        priceSchemeOptionsDesc.push({
                            label: schemeCode,
                            value: schemeCode,
                            desc: option.CBP_SCHEME_DESCRIPTION
                        });
                    }
                });

                component.set('v.pricingSchemeOptions', pricingSchemeOptions);
                component.set('v.priceSchemeOptionsDesc', priceSchemeOptionsDesc);

                component.set('v.showSpinner', false);
            } else if (state === "ERROR") {
                let toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error",
                    "message": response.getError()[0].message,
                    "mode": "sticky",
                    "type": "error"
                });
                toastEvent.fire();
            }
        });

        $A.enqueueAction(action);
    },

    getComponentDataAttributes: function () {
        return [
            'tariffOptionsValue',
            'accountNumber',
            'pricingScheme',
        ];
    },

    checkValidity: function (component) {
        let selectedOption = component.get("v.tariffOptionsValue");
        let componentField = component.find(selectedOption);

        if (component.get('v.dataHasBeenSent')) {
            componentField.reportValidity();
        }

        return componentField.get('v.validity').valid;
    },

    setTariffLabels: function (component) {
        let customLabels = [
            { label: $A.get("$Label.c.Enquiry_Account_Number"), value: "accountNumber" },
            { label: $A.get("$Label.c.Enquiry_Pricing_Scheme"), value: "pricingScheme" }
        ];
        component.set('v.tariffOptions', customLabels);
    },
})