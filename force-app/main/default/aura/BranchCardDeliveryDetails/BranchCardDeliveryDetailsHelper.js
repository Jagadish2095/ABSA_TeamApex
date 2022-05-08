({
    deliveryOptions: [
        {'label': 'Branch', 'value': 'Branch'},
        {'label': 'Face to face', 'value': 'Courier'}
    ],

    addressOptions: [
        {'label': 'Residential address', 'value': 'Residential'},
        {'label': 'Work address', 'value': 'Employers'},
        {'label': 'Other', 'value': 'Card Delivery'}
    ],

    fetchDeliveryOptions: function(component) {
        component.set('v.deliveryOptions', this.deliveryOptions);
    },

    fetchAddressOptions: function(component) {
        component.set('v.addressOptions', this.addressOptions);
    },

    fetchData: function(component) {
        var action = component.get('c.getApplicationProductRecordId');
        var applicationRecordId = component.get('v.applicationRecordId');
        action.setParams({
            'applicationId' : applicationRecordId
        });
        action.setCallback(this, function(response) {
            var applicationProductRecordId = response.getReturnValue();
            component.set('v.applicationProductRecordId', applicationProductRecordId);
        });
        $A.enqueueAction(action);
    },

    getProductValues: function(component) {
        var cardProdSubProdGroupId = '';
        var productInfoResult = '';
        if (!component.get('v.isReferred')) {
            productInfoResult = JSON.parse(component.get('v.scoringResult'));
            cardProdSubProdGroupId = productInfoResult.applyResponse.z_return.application.productInformation[0].cardProdSubProdGroupId;
        } else {
            productInfoResult = JSON.parse(component.get('v.applicationInfoResponse'));
            cardProdSubProdGroupId = productInfoResult.getApplicationInformationResponse.z_return.application.productInformation.cardProdSubProdGroupId;
        }
        if (cardProdSubProdGroupId != '') {
            component.set('v.cardProdSubProdGroupId', cardProdSubProdGroupId);
        } else {
            alert('No product Information was returned with service result');
        }
    },

    setAddress: function(component, helper) {
        var selectedAddress = helper.getSelectedAddress(component);
        var addressComponent = component.find(selectedAddress);
        if (selectedAddress == 'otherAddress') {
            addressComponent.SubmitAddress();
        }
        var street = addressComponent.get("v.addressStreet");
        var postal = addressComponent.get("v.addressPostalCode");
        var suburb = addressComponent.get("v.addressSuburb");
        var city = addressComponent.get("v.addressCity");
        var province = addressComponent.get("v.addressProvince");
        var country = addressComponent.get("v.addressCountry");
        component.set("v.deliveryStreet", street);
        component.set("v.deliveryPostalCode", postal);
        component.set("v.deliverySuburb", suburb);
        component.set("v.deliveryCity", city);
        component.set("v.deliveryProvince", province);
        component.set("v.deliveryCountry", country);
    },

    clearAddress: function(component) {
        component.set("v.deliveryStreet", '');
        component.set("v.deliveryPostalCode", '');
        component.set("v.deliverySuburb", '');
        component.set("v.deliveryCity", '');
        component.set("v.deliveryProvince", '');
        component.set("v.deliveryCountry", '');
    },

    getSelectedAddress: function(component) {
        switch (component.get('v.addressOptionsValue')) {
            case 'Residential':
                return 'residentialAddress';
            case 'Employers':
                return 'employersAddress';
            case 'Card Delivery':
                return 'otherAddress';
        }
    },

    setSiteResult: function(component, event, helper) {
        var payload = event.getParam('recordUi');
        var siteComponent = component.find('branchSite');
        var siteName = payload.record.fields['CardDeliverySite__c'].value;
        var siteCode = payload.record.fields['Card_Delivery_Site_Code__c'].value;
        if ((!$A.util.isUndefinedOrNull(siteName))) {
            siteComponent.set('v.siteResult', siteName + ' (' + siteCode + ')');
        }
    },

    addValidation: function(component, componentAuraId, errorMsg) {
        var styleClass= 'slds-form-element__help validationCss';
        var errorComponent = component.find(componentAuraId);
        $A.util.addClass(errorComponent, 'slds-has-error');
        var globalId = component.getGlobalId();
        var elementId = (globalId + '_' + componentAuraId);
        var validationElementId = (elementId + '_Error');
        var errorElement = document.getElementById(elementId)
        var validationElement = document.createElement('div');
        validationElement.setAttribute('id', validationElementId);
        validationElement.setAttribute('class', styleClass);
        validationElement.textContent = errorMsg;
        errorElement.appendChild(validationElement);
    },

    removeValidation: function(component, componentAuraId) {
        var globalId = component.getGlobalId();
        var validationElementId = (globalId + '_' + componentAuraId + '_Error');
        var errorComponent = component.find(componentAuraId);
        $A.util.removeClass(errorComponent, 'slds-has-error');
        if(document.getElementById(validationElementId)) {
            var errorElement = document.getElementById(validationElementId);
            errorElement.parentNode.removeChild(errorElement);
        }
    },

    checkValidity: function(component, helper) {
        var returnValue = 'pass';
        var deliveryOptionsValue = component.get("v.deliveryOptionsValue");
        helper.removeValidation(component, 'deliveryOptionsRadioGroup');
        if (($A.util.isUndefinedOrNull(deliveryOptionsValue))) {
            helper.addValidation(component, 'deliveryOptionsRadioGroup', 'Please select an option.');
            returnValue = 'fail';
        } else if (deliveryOptionsValue == 'Branch') {
            var siteComponent = component.find('branchSite');
            if (!siteComponent.validate()) {
                returnValue = 'fail';
            }
        } else if (deliveryOptionsValue == 'Courier') {
            if (($A.util.isUndefinedOrNull(component.get('v.addressOptionsValue')))) {
                helper.addValidation(component, 'addressOptionsRadioGroup', 'Please select an option.');
                returnValue = 'fail';
            } else {
                var selectedAddress = helper.getSelectedAddress(component);
				returnValue = component.find(selectedAddress).validate();
            }
        }
        return returnValue;
    },

    executeCompleteTwo : function(component, helper) {
        component.set('v.salaryAccountError', false);
        component.set('v.salaryError', '');
        component.set('v.debitAccountError', false);
        component.set('v.debitError', '');
        return new Promise(function(resolve, reject) {
            let action = component.get('c.callCompleteTwo');

            var applicationRecordId = component.get('v.applicationRecordId');
            var applicationNumber = component.get('v.ccApplicationNumber');
            var lockVersionId = component.get('v.lockVersionId');
            var cardProdSubProdGroupId = component.get('v.cardProdSubProdGroupId')
            action.setParams({
                'applicationId': applicationRecordId,
                'applicationNumber': applicationNumber,
                'lockVersionId': lockVersionId,
                'cardProdSubProdGroupId': cardProdSubProdGroupId
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === 'SUCCESS') {
                    component.set('v.completeTwoResult', response.getReturnValue());
                    var completeTwoResult = JSON.parse(response.getReturnValue());
                    if (completeTwoResult.statusCode == 200) {
                       if ((completeTwoResult.applyResponse.z_return.responseCommons != null) &&
                            (completeTwoResult.applyResponse.z_return.responseCommons.responseMessages != null) &&
                            (completeTwoResult.applyResponse.z_return.responseCommons.responseMessages.length > 0)) {
                            var resultError = '';
                            for (var i = 0; i < completeTwoResult.applyResponse.z_return.responseCommons.responseMessages.length; i++) {
                                console.log(completeTwoResult.applyResponse.z_return.responseCommons.responseMessages[i].message);
                                resultError = resultError + completeTwoResult.applyResponse.z_return.responseCommons.responseMessages[i].message + '\r\n';
                                resultError = resultError.replace('&lt;', '<');
                                resultError = resultError.replace('&gt;', '>');
                                if (resultError.includes("SubmitSalaryAccountDetails:")) {
                                    component.set('v.salaryAccountError', true);
                                    component.set('v.salaryError', resultError);
                                }
                                if (resultError.includes("SubmitDebitOrderDetails:")) {
                                    component.set('v.debitAccountError', true);
                                    component.set('v.debitError', resultError);
                                }
                            }
    						reject(resultError);
                        } else {
                            lockVersionId = completeTwoResult.applyResponse.z_return.application.lockVersionId;
                            component.set('v.lockVersionId', lockVersionId);
							resolve(completeTwoResult);
                        }
                    } else {
                        reject(completeTwoResult);
                    }
                } else {
                    reject(response.getReturnValue());
                }
            });
            $A.enqueueAction(action);
        })
    }
})