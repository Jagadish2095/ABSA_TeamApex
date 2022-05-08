({
    /*@ Author: Tinashe M Shoko
 	**@ Date: 03/04/2020
 	**@ Description: Method to fetch the linked Application Product Merchant Id
    ** associated with the Opportunity*/
    fetchAcceptedCardsData: function(component, event, helper) {
        var recordId = component.get("v.recordId");
        var applicationProductMerchantId = component.get("v.applicationProductMerchantId");
        var productFamily = component.get("v.oppProductRecord.Product2.Family");
        var action = component.get("c.getAcceptedCardsData");
        action.setParams({
            "opportunityId": recordId,
            "applicationProductMerchantId": applicationProductMerchantId,
            "productFamily": productFamily
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state == "SUCCESS") {
                var responseMap = response.getReturnValue();
                if (responseMap != null) {
                    var error = responseMap['error'];
                    if (error) {
                        component.set("v.errorMessage", error);
                    } else {
                        component.set("v.applicationProductMerchantId", responseMap['applicationProductMerchantId']);
                        component.set("v.preSelectedCardValues", responseMap['preSelectedCards'].split(';'));

                        var availableCards = responseMap['availableCards'].split(';');
                        var items = [];
                        for (var i = 0; i < availableCards.length; i++) {
                            var item = {
                                "label": availableCards[i],
                                "value": availableCards[i]
                            };
                            items.push(item);
                        }
                        component.set("v.availableCardOptions", items);
                    }
                }
            } else if(state === "ERROR"){
                var errors = response.getError();
                component.set("v.errorMessage", "getApplication: Apex error: [" + JSON.stringify(errors) + "]. ");
            } else {
                component.set("v.errorMessage", "getApplication: Apex error. ");
            }
        });
        $A.enqueueAction(action);
    },

    /** determine when to popup message to advise clients to register with certain
    financial institutions for respective card types **/
    msgToClient: function(component, event, helper) {
        var arrSelectedCards = component.find("dualListboxCards").get("v.value");

        if (!$A.util.isEmpty(arrSelectedCards)) {
            var splitCardList=[];
            var msg = 'Please ensure you inform the client to register with the Financial Institution of';
            for(var i = 0; i < arrSelectedCards.length; i++){
                if ( //arrSelectedCards[i] == "American Express" || // Tinashe - W-005501
                    arrSelectedCards[i] == "Buy-aid" ||
                    arrSelectedCards[i] == "Cape Consumer" ||
                    arrSelectedCards[i] == "Diners Club" ||
                    arrSelectedCards[i] == "Iemas" ||
                    arrSelectedCards[i] == "Koopkrag" ||
                    arrSelectedCards[i] == "Pretorium Trust" || // PJAIN: 20200623: W-005002
                    arrSelectedCards[i] == "Samba") {

                    splitCardList.push(arrSelectedCards[i]);
                }
            }

            if (splitCardList.length > 0) {
                msg = 'Please ensure you inform the client to register with the Financial Institution of ' + splitCardList.join(', ') + ' and get a membership number';
                component.set("v.cardItems", msg);
                component.set("v.openModal",true);
            }
        }
    },

    handleFormSubmit : function(component, event, helper) {
        var arrSelectedCards = component.find("dualListboxCards").get("v.value");

        if (!$A.util.isEmpty(arrSelectedCards) && arrSelectedCards.length > 0) {
            var amexNumber = component.find('AMEX_Merchant_Number').get('v.value');
            var numbers = /^[0-9]+$/; // AMEX number field is a string in object but should only accept number, made as such in case card number starts with a 0
            var amexFound = false;

            for(var i = 0; i < arrSelectedCards.length; i++){
                if (arrSelectedCards[i] === "American Express") {
                    amexFound = true;

                    if ($A.util.isEmpty(amexNumber)) {
                        component.set("v.cmpFormStatus", "invalid");
                        helper.fireToast("Error!", "The field 'AMEX Merchant Number' cannot be empty when one of the selected cards is American Express!", "error");
                        return;
                    } else if (!amexNumber.match(numbers)) {
                        component.set("v.cmpFormStatus", "invalid");
                        helper.fireToast("Error!", "The field 'AMEX Merchant Number' must only contain digits 0-9!", "error");
                        return;
                    } else if (!amexNumber.substring(0,3).match(/968/g)) {
                        component.set("v.cmpFormStatus", "invalid");
                        helper.fireToast("Error!", "The field 'AMEX Merchant Number' must start with digits 968!", "error");
                        return;
                    }
                }
            }

            if (!amexFound && !$A.util.isEmpty(amexNumber)) {
                component.set("v.cmpFormStatus", "invalid");
                helper.fireToast("Error!", "The field 'AMEX Merchant Number' must only be populated when one of the selected cards is American Express!", "error");
            } else {
                component.find("selectedCards").set("v.value", arrSelectedCards.join(';'));
                component.find("acceptedCardsForm").submit(); // no errors so submit form
                // msg for client to register with particular financial institutions
                // for certain card types
                helper.msgToClient(component, event, helper);
            }
        } else {
            component.set("v.cmpFormStatus", "invalid");
        }
    },

    //Lightning toastie
    fireToast : function(title, msg, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title":title,
            "message":msg,
            "type":type
        });
        toastEvent.fire();
    }
})