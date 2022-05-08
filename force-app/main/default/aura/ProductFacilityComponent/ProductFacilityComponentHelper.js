({
    handleDoInit: function(component) {
        var options = [{
                label: "Yes",
                value: "Yes"
            },
            {
                label: "No",
                value: "No"
            }
        ];
        component.set("v.options", options);
        var AddresseeOptions = [{
                label: "--None--",
                value: "--None--",
                selected: "true"
            },
            {
                label: 'The Proprietor',
                value: 'The Proprietor'
            },
            {
                label: 'The Partner(s)',
                value: 'The Partner(s)'
            },
            {
                label: 'The Member(s)',
                value: 'The Member(s)'
            },
            {
                label: 'The Director(s)',
                value: 'The Director(s)'
            },
            {
                label: 'The Shareholders(s)',
                value: 'The Shareholders(s)'
            },
            {
                label: 'The Trustee(s)',
                value: 'The Trustee(s)'
            },
            {
                label: 'Other',
                value: 'Other'
            }
        ];
        component.set('v.AddresseeOptions', AddresseeOptions);
        var AddresseetitleOptions = [{
                label: "--None--",
                value: "--None--",
                selected: "true"
            },
            {
                label: 'Dear Sir(s)',
                value: 'Dear Sir(s)'
            },
            {
                label: 'Dear Madam(s)',
                value: 'Dear Madam(s)'
            },
            {
                label: 'Dear Sir(s) / Madam(s)',
                value: 'Dear Sir(s) / Madam(s)'
            },
        ];
        component.set('v.AddresseetitleOptions', AddresseetitleOptions);
                                     
        var action = component.get("c.fetchOutNCAproductLst");
        action.setParams({
            "oppId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var results = response.getReturnValue();
                console.log('results---' + JSON.stringify(results));
                console.log('results---' + results.length);
                component.set("v.facilityWrap", results);
            }

        });
        $A.enqueueAction(action);
    }
})