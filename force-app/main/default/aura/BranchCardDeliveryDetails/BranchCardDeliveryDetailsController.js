({
    init: function(component, event, helper)
    {
        helper.fetchDeliveryOptions(component);
        helper.fetchAddressOptions(component);
        helper.fetchData(component);
        helper.getProductValues(component);
    },

    applicationProductLoaded: function(component, event, helper) {
        var payload = event.getParam('recordUi');
        var addressOptionsValue = payload.record.fields['AddressType__c'].value;
        var deliveryOptionsValue = payload.record.fields['Card_Delivery_Method__c'].value;
        component.set('v.deliveryOptionsValue', deliveryOptionsValue);
        component.set('v.addressOptionsValue', addressOptionsValue);
        if (deliveryOptionsValue == 'Branch') {
            helper.setSiteResult(component, event, helper);
        }
        if (!component.get('v.completeTwo')) {
            component.set('v.updating', false);
        }
    },

    applicationProductSubmit: function(component, event, helper) {
        helper.clearAddress(component);
        var deliveryOptionsValue = component.get("v.deliveryOptionsValue");
        var siteName = '';
        var siteCode = '';
        var addressOptionsValue = '';
        event.preventDefault();
        var eventFields = event.getParam("fields");
        if (deliveryOptionsValue == 'Courier') {
            helper.setAddress(component, helper);
            addressOptionsValue = component.get("v.addressOptionsValue");
        }
        if (deliveryOptionsValue == 'Branch') {
            var siteComponent = component.find('branchSite');
            siteName = siteComponent.get('v.siteName');
            siteCode = siteComponent.get('v.siteCode');
        }
        var street = component.get("v.deliveryStreet");
        var postal = component.get("v.deliveryPostalCode");
        var suburb = component.get("v.deliverySuburb");
        var city = component.get("v.deliveryCity");
        var province = component.get("v.deliveryProvince");
        var country = component.get("v.deliveryCountry");
        eventFields["AddressType__c"] = addressOptionsValue;
        eventFields["Delivery_Address_1__c"] = street;
        eventFields["Postal_code__c"] = postal;
        eventFields["Suburb__c"] = suburb;
        eventFields["Town__c"] = city;
        eventFields["Province__c"] = province;
        eventFields["Country__c"] = country;
        eventFields["Card_Delivery_Site_Code__c"] = siteCode;
        eventFields["CardDeliverySite__c"] = siteName;
        eventFields["Card_Delivery_Method__c"] = deliveryOptionsValue;
        component.find('ApplicationProductDetail').submit(eventFields);
        component.set('v.completeTwo', true);
    },

    applicationProductError : function(component, event, helper) {
        component.set('v.completeTwo', false);
        var errorMessage = event.getParam("message");
        var eventDetails = event.getParam("error");
        component.find('branchFlowFooter').set('v.heading', errorMessage);
        component.find('branchFlowFooter').set('v.message', JSON.stringify(eventDetails));
        component.find('branchFlowFooter').set('v.showDialog', true);
        component.set('v.updating', false);
    },

    applicationProductSuccess : function(component, event, helper) {
        var navigate = component.get('v.navigateFlow');
        var actionClicked = component.get('v.actionClicked');

        var promise = helper.executeCompleteTwo(component, helper)
        .then(
            $A.getCallback(function(result) {
                component.set('v.updating', false);
                navigate(actionClicked);
            }),
            $A.getCallback(function(error) {
                component.set('v.updating', false);
                if (component.get('v.salaryAccountError') || component.get('v.debitAccountError')) {
                    component.set('v.showAccountPopUp', true);
                } else {
                    component.find('branchFlowFooter').set('v.heading', 'Error executeCompleteTwo');
                    component.find('branchFlowFooter').set('v.message', error);
                    component.find('branchFlowFooter').set('v.showDialog', true);
                }
            })
        );
    },

    handleNavigate: function(component, event, helper) {
        var navigate = component.get('v.navigateFlow');
        var actionClicked = event.getParam('action');
        var globalId = component.getGlobalId();
        component.set('v.updating', true);
        component.set('v.actionClicked', actionClicked);

        switch(actionClicked) {
            case 'NEXT':
            case 'FINISH':
                if (helper.checkValidity(component, helper) == 'pass') {
                    document.getElementById(globalId + '_applicationproduct_submit').click();
                } else {
                    component.set('v.updating', false);
                }
                break;
            case 'BACK':
            case 'PAUSE':
                component.set('v.updating', false);
                navigate(actionClicked);
                break;
        }
    }
})