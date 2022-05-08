({
    /*@ Author: Danie Booysen
 	**@ Date: 26/03/2020
 	**@ Description: Method to fetch Application Product-Merchant record id*/
    getApplicationProductMerchant: function(component) {

        var action = component.get("c.getApplicationProductMerchant");
        action.setParams({
            "opportunityIdP": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var responseValue = response.getReturnValue();
                if (responseValue != null && responseValue.Id != null) {
                    component.set("v.applicationProductMerchantId", responseValue.Id);
                }
            } else if(response.getState() === "ERROR"){
                var errors = response.getError();
                component.set("v.errorMessage", "getApplication: Apex error: [" + JSON.stringify(errors) + "]. ");
            } else {
                component.set("v.errorMessage", "getApplication: Apex error. ");
            }
        });
        $A.enqueueAction(action);
    },

    /*@ Author: Danie Booysen
 	**@ Date: 31/03/2020
 	**@ Description: Method to calculate product/services exposure values*/
    calcResult: function(component, sourceLocalId){

        var annualCardTurnover = component.find("annualCardTurnoverRand").get("v.value");
        var goodsAndServicesTaken = component.find("goodsAndServicesTakenAtPOS").get("v.value");
        var oneToSevenDays = component.find("1To7DaysValue").get("v.value");
        var eightToFourteenDays = component.find("8To14DaysValue").get("v.value");
        var fifteenToThirtyDays = component.find("15To30DaysValue").get("v.value");
        var thirtyToSixtyDays = component.find("30To60DaysValue").get("v.value");
        var sixtyDays = component.find("60DaysValue").get("v.value");

        var calulatedCardTurnoverDeferredDelivery = component.find("cardTurnoverDeferredDelivery").get("v.value");

        var goodsAndServicesDeferredDelivery = '0';
        var cardTurnoverWithDeferredDelivery = '0';
        var days1To7Exposure = '0';
        var days8To14Exposure = '0';
        var days15To30Exposure = '0';
        var days30To60Exposure = '0';
        var days60PlusExposure = '0';

        if(sourceLocalId == 'annualCardTurnoverRand' && annualCardTurnover !== null){
            //Do Nothing
        }else if(sourceLocalId == 'goodsAndServicesTakenAtPOS' && goodsAndServicesTaken !== null){
            if(goodsAndServicesTaken>100){
                // Show toast
                helper.fireToast("error", "Error!", "The Percentage Of Goods And Services Taken Away At Point Of Sale Cannot Be More Than 100%.");
            }else{
                goodsAndServicesDeferredDelivery = 100-goodsAndServicesTaken;
                cardTurnoverWithDeferredDelivery = Math.round((annualCardTurnover*(goodsAndServicesDeferredDelivery/100)/12));

                component.set("v.calulatedGoodsServicesDeferredDelivery", goodsAndServicesDeferredDelivery);
                component.set("v.calulatedCardTurnoverDeferredDelivery", cardTurnoverWithDeferredDelivery);
            }
        }else if(sourceLocalId == '1To7DaysValue' && oneToSevenDays !== null){

            days1To7Exposure = Math.round((calulatedCardTurnoverDeferredDelivery*(oneToSevenDays/100)/4));
            component.set("v.calulatedGoodsDelivered1To7DaysExposure", days1To7Exposure);
        }else if(sourceLocalId == '8To14DaysValue' && eightToFourteenDays !== null){

            days8To14Exposure = Math.round((calulatedCardTurnoverDeferredDelivery*(eightToFourteenDays/100)/2));
            component.set("v.calulatedGoodsDelivered8To14DaysExposure",days8To14Exposure);
        }else if(sourceLocalId == '15To30DaysValue' && fifteenToThirtyDays !== null){

            days15To30Exposure = Math.round((calulatedCardTurnoverDeferredDelivery*(fifteenToThirtyDays/100)));
            component.set("v.calulatedGoodsDelivered15To30DaysExposure",days15To30Exposure);
        }else if(sourceLocalId == '30To60DaysValue' && thirtyToSixtyDays !== null){

            days30To60Exposure = Math.round((calulatedCardTurnoverDeferredDelivery*(thirtyToSixtyDays/100)*1.5));
            component.set("v.calulatedGoodsDelivered30To60DaysExposure",days30To60Exposure);
        }else if(sourceLocalId == '60DaysValue' && sixtyDays !== null){

            days60PlusExposure = Math.round((calulatedCardTurnoverDeferredDelivery*(sixtyDays/100)*2));
            component.set("v.calulatedGoodsDelivered60DaysExposure",days60PlusExposure);
        }else if(sourceLocalId == 'salesActivityForm'){
            /**This calculates the exposure when the component loads which is when the sourceLocalId is: salesActivityForm **/
            goodsAndServicesDeferredDelivery = 100-goodsAndServicesTaken;
            cardTurnoverWithDeferredDelivery = Math.round((annualCardTurnover*(goodsAndServicesDeferredDelivery/100)/12));

            component.set("v.calulatedGoodsServicesDeferredDelivery", goodsAndServicesDeferredDelivery);
            component.set("v.calulatedCardTurnoverDeferredDelivery", cardTurnoverWithDeferredDelivery);

            days1To7Exposure = Math.round((cardTurnoverWithDeferredDelivery*(oneToSevenDays/100)/4));
            component.set("v.calulatedGoodsDelivered1To7DaysExposure", days1To7Exposure);

            days8To14Exposure = Math.round((cardTurnoverWithDeferredDelivery*(eightToFourteenDays/100)/2));
            component.set("v.calulatedGoodsDelivered8To14DaysExposure",days8To14Exposure);

            days15To30Exposure = Math.round((cardTurnoverWithDeferredDelivery*(fifteenToThirtyDays/100)));
            component.set("v.calulatedGoodsDelivered15To30DaysExposure",days15To30Exposure);

            days30To60Exposure = Math.round((cardTurnoverWithDeferredDelivery*(thirtyToSixtyDays/100)*1.5));
            component.set("v.calulatedGoodsDelivered30To60DaysExposure",days30To60Exposure);

            days60PlusExposure = Math.round((cardTurnoverWithDeferredDelivery*(sixtyDays/100)*2));
            component.set("v.calulatedGoodsDelivered60DaysExposure",days60PlusExposure);
            /***/
        }
        this.calcTotalExpResult(component);
    },

    /*@ Author: Danie Booysen
 	**@ Date: 31/03/2020
 	**@ Description: Method to calculate the total product/services exposure & percentage values*/
    calcTotalExpResult: function(component){

        //Exposure value R
        var exposure1To7Days = component.get("v.calulatedGoodsDelivered1To7DaysExposure");
        var exposure8To14Days = component.get("v.calulatedGoodsDelivered8To14DaysExposure");
        var exposure15To30Days = component.get("v.calulatedGoodsDelivered15To30DaysExposure");
        var exposure30To60Days = component.get("v.calulatedGoodsDelivered30To60DaysExposure");
        var exposure60Days = component.get("v.calulatedGoodsDelivered60DaysExposure");
		//Percentage value of exposure
        var percentage1To7Days = component.find("1To7DaysValue").get("v.value");
        var percentage8To14Days = component.find("8To14DaysValue").get("v.value");
        var percentage15To30Days = component.find("15To30DaysValue").get("v.value");
        var percentage30To60Days = component.find("30To60DaysValue").get("v.value");
        var percentage60Days = component.find("60DaysValue").get("v.value");
        if(!percentage1To7Days){
            percentage1To7Days = 0;
        }
        if(!percentage8To14Days){
            percentage8To14Days = 0;
        }
        if(!percentage15To30Days){
            percentage15To30Days = 0;
        }
        if(!percentage30To60Days){
            percentage30To60Days = 0;
        }
        if(!percentage60Days){
            percentage60Days = 0;
        }

        var totalcalcExposure = 0;
        var totalcalcPercentage = 0;
        totalcalcExposure = parseFloat(exposure1To7Days)+parseFloat(exposure8To14Days)+parseFloat(exposure15To30Days)+parseFloat(exposure30To60Days)+parseFloat(exposure60Days);
        totalcalcPercentage = parseFloat(percentage1To7Days)+parseFloat(percentage8To14Days)+parseFloat(percentage15To30Days)+parseFloat(percentage30To60Days)+parseFloat(percentage60Days);
        component.set("v.calulatedTotalExposure", totalcalcExposure);
        component.set("v.calulatedTotalPercentage", totalcalcPercentage);
    },

    /*@ Author: Danie Booysen
 	**@ Date: 01/04/2020
 	**@ Description: Method to validate the percentage values of the Exposure Matrix*/
    validate: function(component, helper){

        var isError = false;

        var goodsAndServicesTaken = component.find("goodsAndServicesTakenAtPOS").get("v.value");
        var calulatedTotalPercentage = component.get("v.calulatedTotalPercentage");

        console.log("goodsAndServicesTaken: "+goodsAndServicesTaken + ". totalPercentage: "+calulatedTotalPercentage);

        if(goodsAndServicesTaken>100){
            isError = true;

            // Show toast
            helper.fireToast("error", "Error!", "The Percentage Of Goods And Services Taken Away At Point Of Sale Cannot Be More Than 100%.");
        }
        if(calulatedTotalPercentage!==100){
            isError = true;

            // Show toast
            helper.fireToast("error", "Error!", "The Total Of Deferred Delivery Sales Percentage Should Be Equal To 100%. It Cannot Be Lower Or More Than 100%.");
        }
        return isError;
    },

    // J QUEV 2020-05-07
    // Method to validate all fields
    // Called onLoad so does not need to show the errors on the fields
    // This version of the method validates lightning:inputField
    allFieldsValid: function(component) {

        var arrayAuraIdsToBeValidated = component.get("v.arrayAuraIdsToBeValidated");
        var arrayFields = [];
        console.log("arrayAuraIdsToBeValidated.length: " + arrayAuraIdsToBeValidated.length);
        for (var i = 0; i < arrayAuraIdsToBeValidated.length; i++) {
            var inputCmp = component.find(arrayAuraIdsToBeValidated[i]);
            if (inputCmp) {
                Array.isArray(inputCmp) ? arrayFields.push.apply(arrayFields, inputCmp) : arrayFields.push(inputCmp);
            }
        }
        console.log("arrayFields.length: " + arrayFields.length);
        // Show error messages if required fields are blank
        var allValid = arrayFields.reduce(function (validFields, inputCmp) {

            var inputCmpValue = inputCmp.get("v.value");
            var inputCmpRequired = inputCmp.get("v.required");
            var inputCmpValid = true;
            console.log("inputCmpValue: " + inputCmpValue);
            console.log("inputCmpRequired: " + inputCmpRequired);
            if(inputCmpRequired && $A.util.isEmpty(inputCmpValue)){
                inputCmpValid = false;
            }

            return validFields && inputCmpValid;
        }, true);

        return allValid;
    },

    /*@ Author: Danie Booysen
 	**@ Date: 16/04/2020
 	**@ Description: Method that shows the spinner*/
    showSpinner : function(component, event, helper){
        $A.util.removeClass(component.find("spinner"), "slds-hide");
    },

    /*@ Author: Danie Booysen
 	**@ Date: 16/04/2020
 	**@ Description: Method that hides the spinner*/
    hideSpinner : function(component, event, helper){
        $A.util.addClass(component.find("spinner"), "slds-hide");
    },

    /*@ Author: Danie Booysen
 	**@ Date: 05/05/2020
 	**@ Description: Method that fires a toast message(event)*/
     fireToast : function(type, title, message){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type": type,
            "title": title,
            "message": message
        });
        toastEvent.fire();
    },

    /*@ Author: Danie Booysen
 	**@ Date: 17/04/2020
 	**@ Description: Method that set the required attribute of an inputField*/
    setRequired : function(component, fieldAuraId, booleanVal){
        var field = component.find(fieldAuraId);

        field.set("v.required",booleanVal);
    },

    /*@ Author: Danie Booysen
 	**@ Date: 05/05/2020
 	**@ Description: Method that resets the value of an inputField to the original (database value)
     **               This would work if the field is an Array (multiple fields with the same id) of fields or just a single field element*/
    resetFieldValue : function(component){

        let fields = component.get("v.resetFieldsList");
        for(var i = 0; i<fields.length; i++){
            var thisField = component.find(fields[i]);
            var isFieldArray = Array.isArray(thisField);

            if(isFieldArray){
                thisField.forEach(function(field) {
                    if(field){
                        field.reset();
                    }
                });
            }else{
                if(thisField){
                    thisField.reset();
                }
            }
        }
    },

    // @Author: Danie Booysen: 2020-08-12 (W-005252)
    // @Description: Method to determine field visibility for the product of the component
    // If the aura Id or field name is returned from the Apex controller the slds-hide class is removed to display the field
    fieldVisibility: function(component, event, helper) {
        var action = component.get("c.determineFieldVisibility");
        action.setParams({
            "opportunityIdP": component.get("v.recordId"),
            "componentNameP": "MerchantSalesActivity"
        });
        action.setCallback(this, function(response) {
            if(response.getState() == "SUCCESS") {
                var responseValue = response.getReturnValue();
                if(responseValue){
                    var dynamicFieldsVisible = component.get("v.dynamicFieldsVisible");
                    var dynamicFieldsRequired = component.get("v.dynamicFieldsRequired");
                    for (var i = 0; i<responseValue.length; i++) {
                        dynamicFieldsVisible[responseValue[i].Field_Name__c] = true;
                        if (responseValue[i].Is_Required__c === true) {
                            dynamicFieldsRequired[responseValue[i].Field_Name__c] = true;
                        }
                    }
                    component.set("v.dynamicFieldsVisible", dynamicFieldsVisible);
                    component.set("v.dynamicFieldsRequired", dynamicFieldsRequired);
                }
            }else if(response.getState() === "ERROR"){
                var errors = response.getError();
                component.set("v.errorMessage", "fieldVisibility: Apex error: [" + JSON.stringify(errors) + "]. ");
            }else{
                component.set("v.errorMessage", "fieldVisibility: Apex error. ");
            }
        });
        $A.enqueueAction(action);
    }
})