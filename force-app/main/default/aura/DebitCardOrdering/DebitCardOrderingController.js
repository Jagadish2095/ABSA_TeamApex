({
    doInit : function(component, event, helper) {
        //helper.showSpinner(component);
        helper.relatedParties(component, event, helper);
        //helper.staticBrandNumbers(component, event, helper);
        //helper.getAccountDetails(component, event, helper); 
        component.set("v.progressIndicatorFlag", "step1");
         //W-008562
         //helper.getOpportunityRec(component, event, helper);

    },
    
    //related parties datatable function
    updateSelectedText: function (component, event) {
        var selectedRows = event.getParam('selectedRows');
        var rowId = component.get('v.selectedRowId');
         //W-008562
         component.find("relatedPartiesListId").set("v.disabled", false);
        
        component.set('v.selectedRowsCount', selectedRows.length);
        for (var i = 0; i < selectedRows.length; i++){
            console.log("You selected: " + selectedRows[i].Id);
            console.log("The selected record : " + JSON.stringify(selectedRows[i]));
            component.set('v.selectedRowId', selectedRows[i].Id);
            component.set('v.selectedRelatedPartyCIF', selectedRows[i].CIF);
            component.set('v.idType', selectedRows[i].IDType);
            component.set('v.idNumber', selectedRows[i].IDNumber);
            component.set('v.passportNumber', selectedRows[i].PassportNumber);
            component.set('v.selectedName',selectedRows[i].Name);
            console.log("Get related Party full Name : " + component.get("v.selectedName"));


        }
    },

    handleOpportunityLoad: function(component, event, helper) {
        var eventParams = event.getParams();
        if(eventParams.changeType === "LOADED") {
            console.log("Client CIF loaded " + component.get("v.opportunityRecord.Account.CIF__c"));
            var clientCIF = component.get("v.opportunityRecord.Account.CIF__c");
            component.set('v.clientCIF', clientCIF);
            console.log("SET client CIF number: " + component.get('v.clientCIF'));
        }
    },

    //LIST PREF PRODUCT FOR CLIENT
    selectedClientProduct : function (component, event) {
        var clientProdSelectedRows = event.getParam('selectedRows');
        component.find("productListId").set("v.disabled", false);
        for (var i = 0; i < clientProdSelectedRows.length; i++){
            //component.set('v.productType', clientProdSelectedRows[i].prodType);
            component.set('v.productCode', clientProdSelectedRows[i].prodCode);
            component.set('v.productBrand', clientProdSelectedRows[i].prodBrand);
            //component.set('v.selectedAccountNumber', clientProdSelectedRows[i].accountNumber);
        }
    },
    //PRODUCT BRAND LIST
    selectedBrandProduct : function (component, event) {
        var brandProdSelectedRows = event.getParam('selectedRows');
        component.find("brandListId").set("v.disabled", false);
        for (var i = 0; i < brandProdSelectedRows.length; i++){
            component.set('v.selectedBrandNumber', brandProdSelectedRows[i].Brand_Number__c);
            component.set('v.selectedBrandProduct', brandProdSelectedRows[i].MasterLabel);
        }
    },

    //START OF THE NEXT BUTTON
    goToStepTwo : function(component, event, helper) {
        component.set("v.progressIndicatorFlag", "step2");
        component.set("v.isStepTwo", "true");
        component.set("v.isStepOne", "false");
        helper.relatedPartyAddress(component, event, helper);
    },

    goToStepThree : function(component, event, helper) {
        component.set("v.progressIndicatorFlag", "step3");
        component.set("v.isStepTwo", "false");
        component.set("v.isStepThree", "true");
        var secCIF = component.get("v.selectedRelatedPartyCIF");
        if(!secCIF){
            helper.createMiniCIF(component, event, helper);
        }

        //get account number
        helper.opportunityLineItems(component, event, helper);
        helper.opportunityLineItemDetails(component, event, helper);
        
    },

    goToStepFour : function(component, event, helper) {

        //START OF THE INPUT FIELD VALIDATION
        var validationError = false;
        var validationMessage = '';
        var applicationFormInputs = component.get("v.applicationProduct");
        var persInd = applicationFormInputs.Personalised_Indicator__c;
        var cardDeliveryMethod = applicationFormInputs.Card_Delivery_Method__c;
        var cardType = applicationFormInputs.Card_Type__c;


        //variables related to the pers Indicator
        var debitCardNum = applicationFormInputs.Debit_Card_Number__c;
        var nameInd = applicationFormInputs.Name_Indicator__c;
        var deliveryAddress1 = applicationFormInputs.Delivery_Address_1__c;
        var suburb = applicationFormInputs.Suburb__c;
        var postalCode = applicationFormInputs.Postal_code__c;
        var deliveryAddress2 = applicationFormInputs.Delivery_Address_2__c;
        var town = applicationFormInputs.Town__c;
        var country = applicationFormInputs.Country__c;
        var personName = applicationFormInputs.Name__c;

        if (
            $A.util.isEmpty(persInd) ||
            $A.util.isEmpty(cardDeliveryMethod) ||
            $A.util.isEmpty(cardType)) {
            validationError = true;
            validationMessage = "Please complete the Mandatory fields";

        }else if (persInd == 'N' && $A.util.isEmpty(debitCardNum)) {

            console.log("The Card Number field is BLANK");
            validationError = true;
            validationMessage = "Please provide the Card number";

        }else if (persInd == 'Y' && ($A.util.isEmpty(nameInd) //||
                                    //$A.util.isEmpty(deliveryAddress1) ||
                                    //$A.util.isEmpty(suburb) ||
                                    //$A.util.isEmpty(postalCode) ||
                                    //$A.util.isEmpty(deliveryAddress2) ||
                                    //$A.util.isEmpty(town) ||
                                    //$A.util.isEmpty(country)
                                    )) {
            console.log("The name Indicator and Address fields are BLANK");
            validationError = true;
            validationMessage = "Name Indicator and Address are Required"; 

        }else if (persInd == 'N' && cardDeliveryMethod == 'Courier') {

            console.log("The Card Delivery Method should be Branch");
            validationError = true;
            validationMessage = "Card Delivery Method should be Branch if Personalised Indicator is N"; 

        }else if(persInd == 'Y' && cardDeliveryMethod == 'Branch'){

            console.log("The Card Delivery Method should be Courier");
            validationError = true;
            validationMessage = "Card Delivery Method should be Courier if Personalised Indicator is Y";

        }else if(nameInd == 'free format name' && $A.util.isEmpty(personName)){

            console.log("Please enter Name to be embossed");
            validationError = true;
            validationMessage = "Please enter Name to be embossed";
        }

        if(!validationError){

            component.set("v.progressIndicatorFlag", "step4");
            component.set("v.isStepThree", "false");
            component.set("v.isStepFour", "true");
            component.find("createCardOrdering").submit();
            //helper.cclistPrefProductsForClient(component, event, helper);
            helper.staticBrandNumbers(component, event, helper);

        }else{

            component.find('applicationFormError').setError(validationMessage);
        }
    },

    goToStepFive : function(component, event, helper) {
        component.set("v.progressIndicatorFlag", "step5");
        component.set("v.isStepFour", "false");
        component.set("v.isStepFive", "true");
        console.log('Application record Id : ' + component.get("v.newApplicationId"));
        
        var applicationProdRecord = component.get("v.applicationProduct");
        if(applicationProdRecord.Personalised_Indicator__c == 'Y'){

            helper.bbcombiCardIssue(component, event, helper);

        }else{
            helper.combiCardIssue(component, event, helper);
        }
    },

    /*goToStepSix : function(component, event, helper) {
        component.set("v.progressIndicatorFlag", "step6");
        component.set("v.isStepFive", "false");
        component.set("v.isStepSix", "true");
           
    },*/
    
    //START OF THE BACK BUTTON
    goBackToStepOne : function(component, event, helper) {
        component.set("v.progressIndicatorFlag", "step1");
        component.set("v.isStepTwo", "false");
        component.set("v.isStepOne", "true");
    },
    goBackToStepTwo : function(component, event, helper) {
        component.set("v.progressIndicatorFlag", "step2");
        component.set("v.isStepTwo", "true");
        component.set("v.isStepThree", "false");
    },
    
    goBackToStepThree : function(component, event, helper) {
        component.set("v.progressIndicatorFlag", "step3");
        component.set("v.isStepFour", "false");
        component.set("v.isStepThree", "true");

    },
    
    goBackToStepFour : function(component, event, helper) {
        component.set("v.progressIndicatorFlag", "step4");
        component.set("v.isStepFour", "true");
        component.set("v.isStepFive", "false");
        //submit the address edit form
        //component.find("addressEditForm").submit();
    },
    
    /*goBackToStepFive : function(component, event, helper) {
        component.set("v.progressIndicatorFlag", "step5");
        component.set("v.isStepFive", "true");
        component.set("v.isStepSix", "false");
    },*/
	
    //CLOSE THE WIZARD MODAL
    closedebitCardOrderingModel: function(component, event, helper) {
        component.set("v.showdebitCardOrderingModel", "false");
    },
    
    
    handlePersIndOnChange: function(component, event, helper) {
        
        var appProdRecord = component.get("v.applicationProduct");
        
        if($A.util.isEmpty(appProdRecord.Personalised_Indicator__c) || appProdRecord.Personalised_Indicator__c == 'N'){
            component.set("v.showCardNumber", "true");
            component.set("v.showAddress", "false");
        }else{
            component.set("v.showCardNumber", "false");
            component.set("v.showAddress", "true");
        }
        
    },
    
    
    
    handleNameIndChange: function(component, event, helper) {
	
        var appProdRec = component.get("v.applicationProduct");
        
        switch (appProdRec.Name_Indicator__c) {
            case 'cardholder name':
                component.set("v.nameIndicator","C");
                component.set("v.personFullName","false");
                console.log("Selected nameIndicator "+ component.get("v.nameIndicator"));
                break;
            case 'free format name':
                component.set("v.nameIndicator","F");
                component.set("v.personFullName","true");
                console.log("Selected nameIndicator "+ component.get("v.nameIndicator"));
                break;
            case 'Blank':
                component.set("v.nameIndicator","B");
                component.set("v.personFullName","false");
                console.log("Selected nameIndicator "+ component.get("v.nameIndicator"));
                break;
            default:
                console.log("Value not found");
        }
        
    },
    
        handleCardDeliveryChange: function(component, event, helper) {
	
        var appProdRec = component.get("v.applicationProduct");
        
        switch (appProdRec.Card_Delivery_Method__c) {
            case 'Branch':
                component.set("v.cardDeliveryMethod","B");
                console.log("Selected Delivery Methods "+ component.get("v.cardDeliveryMethod"));
                break;
            case 'Courier':
                component.set("v.cardDeliveryMethod","F");
                console.log("Selected Delivery Methods "+ component.get("v.cardDeliveryMethod"));
                break;
            default:
                console.log("Value not found");
        }
        
    },
    
    handleCheckboxChange: function(component, event, helper) {
        var appProductRec = component.get("v.applicationProduct");
        console.log("replacement value : "+ appProductRec.Replacement_Card__c);
        //component.set("v.showCardFees", appProductRec.Replacement_Card__c);

        var replacementCard = component.find("replacementCardField").get("v.value");
        console.log("GET replacement card : "+ replacementCard);
       
        if(replacementCard == true) {
            component.set("v.showCardFees", replacementCard);
            console.log("value of the replacement Card : "+ replacementCard);

        }else{
            console.log("value of the replacement Card : "+ replacementCard);
            component.set("v.showCardFees", replacementCard);
        }
    },
    
    handleSubmit: function(component, event, helper) {
        //event.preventDefault();  
        component.set("v.showdebitCardOrderingModel", "false");
        //var fields = event.getParam('fields');
        //component.find("createCardOrdering").submit();
        //calling the daily limit update.
        helper.dailyLimitUpdate(component, event, helper);

        //Selected values from the Services.
        var applicationProductUpdate = component.get("v.applicationProduct");
        applicationProductUpdate.Product_Type__c = component.get("v.productType");
        applicationProductUpdate.Product_Code__c = component.get("v.productCode");
        applicationProductUpdate.Product_Brand__c = component.get("v.selectedBrandProduct");
        applicationProductUpdate.Product_Account_Number__c = component.get("v.selectedAccountNumber");
        applicationProductUpdate.Brand_Number__c = component.get("v.selectedBrandNumber");
        applicationProductUpdate.Opportunity__c = component.get("v.recordId");
        applicationProductUpdate.Combi_Card_Number__c = component.get("v.combiCardNumber");

        component.set("v.applicationProduct", applicationProductUpdate);
        console.log("Updated Application Record : "+ JSON.stringify(component.get("v.applicationProduct")));

        //Create the application record.
        helper.createApplicationProd(component, applicationProductUpdate);

        //submit form
        //component.find("formSubmit").submit()
        
    },

    handleSuccess : function(component, event, helper) {
        var record = event.getParam("response");
        var apiName = record.apiName;
        var myRecordId = record.id; // ID of updated or created record
        component.set("v.newApplicationId", myRecordId);
        console.log('Record : '+ record);
        console.log('apiname: '+apiName);
        console.log('myRecordId: '+myRecordId);

        var toast = this.getToast("Success", myRecordId , "Success");
        toast.fire();
    }

})