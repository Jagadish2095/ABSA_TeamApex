({
    getQuoteBuilderData : function(component, event, helper) {
        this.showSpinner(component);
        component.set("v.errorMessage", null);
        component.set("v.activeSections", component.get('v.defaultActiveSections'));
        var action = component.get("c.getQuoteBuilderData");
        action.setParams({
            "opportunityId": component.get("v.recordId"),
            "quoteType": component.get("v.quoteType")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var resp = response.getReturnValue();
                console.log("getQuoteBuilderData resp: " + resp);
                var respBean = JSON.parse(resp);

                if(respBean != null && respBean.productName != null){

					if(component.get("v.quoteType") == component.get("v.merchantOnboarding")){
						//If productName is not null, then the OpportunityLineItems have been created
						component.find("productSelect").set("v.value", respBean.productName);
						//Hardcoded for now - show the franchise section
						if(respBean.productName == "Mobile - SmartPay" || respBean.productName == "Mobile - Ingenico Move 3500" || respBean.productName == "Desktop - X4"){
							component.set("v.showFranchiseGroupSection", true);
						}else{
							component.set("v.showFranchiseGroupSection", false);
						}
					}
                    //Set Opportunity Id for Merchant Class cmp
                    if(respBean != null && respBean.opportunityLineItemId != null){
                        component.set("v.opportunityLineItemId", respBean.opportunityLineItemId);
                    }
                    var hasDetailedValues = this.checkIfDataExistInDetailedSection(component, helper, respBean);
                    component.set("v.hasDetailedSection", hasDetailedValues);
                    this.createAllUI(component, helper, respBean, hasDetailedValues);
                    this.mapFieldsToDataTable(component, helper, respBean);
                }else{
                    component.set('v.isFormReadOnly', true);
                    this.showError(component, "Please choose a Product before trying to Quote");
                }
                this.hideSpinner(component);

            } else if(state === "ERROR"){
                this.hideSpinner(component);
                component.set('v.isFormReadOnly', true);
                var errors = response.getError();
                this.showError(component, "getQuoteBuilderData: Apex error: [" + JSON.stringify(errors) + "].");
            } else {
                this.hideSpinner(component);
                component.set('v.isFormReadOnly', true);
                this.showError(component, "getQuoteBuilderData: Apex error.");
            }
        });
        // Send action off to be executed
        $A.enqueueAction(action);
    },

    //W-004117 JQUEV
    //Method that goes through the priceSchemeEntryMap to check if we have any keys that are not of the Transaction Type: [All]
    //And if they have a value in them.
    //Then Display the Detailed Detailed section and return the boolean to be used
    //2021-06-11
    checkIfDataExistInDetailedSection: function(component, helper, respBean) {
        //Go through all keys from the map
        for(var key in respBean.priceSchemeEntryMap) {
            //If the Map includes keys that are not of the Transaction Type [All]
            if(!key.includes("]:[All]")){
                //If there is an existing value
                if(respBean.priceSchemeEntryMap[key].existingValue){
                    //Display the Detailed Section
                    component.set("v.showDetailedSection", true);
                    return true;
                }
            }
        }
        component.set("v.showDetailedSection", false);
        return false;
    },

    //W-004117 JQUEV
    //Method that creates all the User Interfaces that are needed
    createAllUI: function(component, helper, respBean, createDetailedSection) {
        //Clear arrayAuraIdsToBeValidated and both divs
        component.set("v.arrayAuraIdsToBeValidated", []);
        component.find("mainBodyDiv").set("v.body", []);//clear v.body
        component.find("detailedBodyDiv").set("v.body", []);//clear v.body
        if(createDetailedSection){
            this.createUI(component, helper, respBean, "mainBodyDiv", false);
            this.createUI(component, helper, respBean, "detailedBodyDiv", true);
        }else{
            this.createUI(component, helper, respBean, "mainBodyDiv", false);
        }
        this.mapDataToUIFields(component, helper, respBean);
    },

    //JQUEV
    //Method which created the dynamic UI based on the Field Visibility mtd.
    //It also populates picklist options, Actions, Attributes, Help Text, label
    createUI: function(component, helper, respBean, divAuraId, isDetailedBody) {

        component.set("v.pricingBean", respBean);
        var finalArray = [];
        var arrayAuraIdsToBeValidated = component.get("v.arrayAuraIdsToBeValidated");
        var layout = ["lightning:layout", {"multipleRows": true}];
        var layoutItem = ["lightning:layoutItem", {"size": "6","padding": "around-small"}];//Default Layout size unless specified in mdt
        finalArray.push(layout);
        //Get value of Detailed Section toggle
        var showDetailed = component.get("v.showDetailedSection");
        var createField;//Boolean value used to exclude field creation if it was specified in FilterCategory
        var filterCategory = component.get("v.filterCategory");
        console.log('createUI filterCategory: ' + filterCategory);
        var categoryList;
        if(!$A.util.isEmpty(filterCategory)){
            categoryList = filterCategory.split(";");
        }

        //For Each Metadata Record
        respBean.fieldVisibilityMdtList.forEach(function (item) {
            var additionalAttributes = JSON.parse(item.Additional_Attributes__c);
            createField = true;
            //Check if Filter Category is not empty for both the metadata and the attribute
            if(!$A.util.isEmpty(categoryList) && !$A.util.isEmpty(additionalAttributes.FilterCategory)){
                console.log('createUI additionalAttributes.FilterCategory: ' + additionalAttributes.FilterCategory);
                var mdtCategoryList = additionalAttributes.FilterCategory.split(";");
                //For each Filter Category passed in
                categoryList.forEach(function (item) {
                    //Cannot use .includes() on the string because it will find Discretionary in Non-Discretionary
                    //if(additionalAttributes.FilterCategory.includes(item)){
                        //createField = false;
                    //}
                    //For each Filter Category in the Metadata
                    mdtCategoryList.forEach(function (mdtItem) {
                        if(item == mdtItem){
                            createField = false;
                        }
                    });
                });
            }
            if(createField){
                var picklistOptions;
                var isDisabled;
    
                var isCorrectFieldType = false;
                if(isDetailedBody){
                    if(additionalAttributes.fieldType == "detailed"){
                        isCorrectFieldType = true;
                    }
                }else{
                    if($A.util.isEmpty(additionalAttributes.fieldType) || (additionalAttributes.fieldType == "rollup" && !showDetailed)){
                        isCorrectFieldType = true;
                    }
                }
                if(isCorrectFieldType){
    
                    if(item.Is_Disabled__c
                        || (!$A.util.isEmpty(additionalAttributes.priceSchemeEntryMapKey)
                        && !$A.util.isEmpty(respBean.priceSchemeEntryMap[additionalAttributes.priceSchemeEntryMapKey])
                        && !respBean.priceSchemeEntryMap[additionalAttributes.priceSchemeEntryMapKey].isNegotiable)) {
    
                        isDisabled = true;
                    } else {
                        isDisabled = component.getReference('v.isFormReadOnly');
                    }
    
                    //Check if Required - Add to arrayAuraIdsToBeValidated
                    if(item.Is_Required__c){
                        arrayAuraIdsToBeValidated.push(item.Field_Name__c);
                    }
                    //Destroy Field if it already exists
                    if(!$A.util.isEmpty(component.find(item.Field_Name__c))){
                        component.find(item.Field_Name__c).destroy();
                    }
                    //Create Field
                    var currentField = [item.Component_Type__c,{"aura:id": item.Field_Name__c,"label": item.Field_Label__c, "value": component.getReference('v.metadataNameToValueMap.' + item.DeveloperName),"required": item.Is_Required__c, "disabled": isDisabled}];
    
                    //Set Field Attributes
                    if(!$A.util.isEmpty(additionalAttributes.attributes)){
                        additionalAttributes.attributes.forEach(function (att) {
                            currentField[1][att.name] = att.value;
                        });
                    }
                    //Set Field Actions
                    if(!$A.util.isEmpty(additionalAttributes.actions)){
                        additionalAttributes.actions.forEach(function (act) {
                            currentField[1][act.action] = component.getReference(act.method);
                        });
                    }
                    finalArray.push(currentField);
    
                    //Check if Select List - to create the Options
                    if(item.Component_Type__c == "lightning:select" && !$A.util.isEmpty(additionalAttributes.picklistOptionsPath)){
                        //Add '--- None ---'
                        var nonePicklistOption = ["option", {"label": "--- None ---","value": "", "selected": "true", "class":"optionClass"}];
                        finalArray.push(nonePicklistOption);
    
                        picklistOptions = helper.getDeep(respBean, additionalAttributes.picklistOptionsPath);
                        //Add Options
                        picklistOptions.forEach(function(opt){
                            var picklistOption = ["option", {"label": opt,"value": opt, "class":"optionClass"}];
                            finalArray.push(picklistOption);
                        });
                    }
    
                    //Help Text
                    if(!$A.util.isEmpty(additionalAttributes.helpTxt)){
                        var helpTxt = ["lightning:helptext",{"aura:id": item.Field_Name__c + "HelpTxt","content": additionalAttributes.helpTxt}];
                        finalArray.push(helpTxt);
                    }
    
                    //Create label for ui:outputText
                    if(item.Component_Type__c == "ui:outputText"){
                        //Create <label> tag
                        var label = ["aura:HTML", {"tag": "label", "HTMLAttributes":{"class": "slds-form-element__label"}}]
                        finalArray.push(label);
                        //Create text to set as the body of the <label>
                        var labelText = ["ui:outputText", {"aura:id": item.Field_Name__c + "Label", "value":item.Field_Label__c}]
                        finalArray.push(labelText);
                    }
                    //Check if LayoutItem Size is in Mdt, then use the size specified
                    if(!$A.util.isEmpty(additionalAttributes.layoutItemSize)){
                        layoutItem = ["lightning:layoutItem", {"size": additionalAttributes.layoutItemSize,"padding": "around-small"}];
                    }
                    //Add Layout Item
                    finalArray.push(layoutItem);
                }
            }
        });
        //Set AuraIdsToBeValidated Array
        component.set("v.arrayAuraIdsToBeValidated", arrayAuraIdsToBeValidated);

        //Create Components
        $A.createComponents(finalArray,function(components, status, errorMessage){
            //Add the new button to the body array
            if (status === "SUCCESS") {

                var layoutCmp = components[0];
                components.shift(); //removes the first array element and "shifts" all other elements to a lower index.
                var layoutItemsArray = [];
                var fieldsArray = [];
                var helpTxtMap = new Map();
                var labelList = [];
                var labelTextList = [];
                var divElement = component.find(divAuraId);
                divElement.set("v.body", []);//clear v.body

                components.forEach(function(item, index, arr){

                    if(item.toString().includes("markup://lightning:layoutItem")){
                        //LayoutItem
                        layoutItemsArray.push(item);

                    }else if(item.toString().includes("markup://ui:outputText") || item.toString().includes("markup://lightning:input")){

                        //Check if aura:id contains "label" because we use ui:outputText field as the label body
                        if(item.getLocalId().toString().includes("Label")){
                            labelTextList.push(item);
                        }else{
                            fieldsArray.push(item);
                        }

                    }else if(item.toString().includes("markup://lightning:select")){
                        //Select Field
                        var optionsArray = [];
                        var optionIndex = index + 1;
                        var nextElementIsOption = false;
                        //Check if next element is 'aura' which means it is an Option
                        if(arr[optionIndex].toString().includes("markup://aura:html")){
                            nextElementIsOption = true;
                        }

                        while (nextElementIsOption){
                            optionsArray.push(arr[optionIndex]);//Add it to Option Array
                            arr.splice(optionIndex, 1);//Remove from main Array
                            //Check if next element is also an Option. After the Options the next element would be a lightning:layoutItem
                            if(!arr[optionIndex].toString().includes("markup://aura:html")){
                                nextElementIsOption = false;
                            }
                        }
                        //Set the Select List's v.body to the Options
                        item.set("v.body", optionsArray);
                        fieldsArray.push(item);
                    }else if(item.toString().includes("markup://lightning:helptext")){
                        //Add HelpText to the Map
                        helpTxtMap[item.getLocalId()] = item;
                    }else{
                        //It should only go in here if the type is markup://aura:html
                        //Therefor we can assume its a Label
                        labelList.push(item);
                    }
                });
                //Add each field to a LayoutItem
                fieldsArray.forEach(function(item, index){
                    var layoutItemBody = layoutItemsArray[index].get("v.body");

                    //If the field is a ui:outputText we need to set the label
                    if(item.toString().includes("markup://ui:outputText")){
                        var label = labelList[0];
                        var labelText = labelTextList[0];
                        labelList.shift(); //removes the first array element and "shifts" all other elements to a lower index.
                        labelTextList.shift(); //removes the first array element and "shifts" all other elements to a lower index.
                        //Set Label body
                        label.set("v.body", labelText);
                        //Add Label to LayoutItem
                        layoutItemBody.push(label);
                    }
                    //If Field has HelpText
                    if(!$A.util.isEmpty(helpTxtMap[item.getLocalId() + "HelpTxt"])){
                        layoutItemBody.push(helpTxtMap[item.getLocalId() + "HelpTxt"]);
                    }
                    //Add Field to LayoutItem
                    layoutItemBody.push(item);
                    layoutItemsArray[index].set("v.body", layoutItemBody);
                });
                var layoutBody = layoutCmp.get("v.body");
                //Add each LayoutItem to the Layout
                layoutItemsArray.forEach(function(item, index){
                    layoutBody.push(item);
                });
                //Set Layout Body
                layoutCmp.set( "v.body", layoutBody);
                //Set Component Body
                divElement.set("v.body", layoutCmp);
                //component.set(componentBody, layoutCmp);
            }else if (status === "INCOMPLETE") {
                console.log("No response from server or client is offline.");
                component.set("v.errorMessage", "No response from server or client is offline.");
            }else if (status === "ERROR") {
                var errorMessage = response.getError();
                console.log("Error: " + errorMessage + ". " + JSON.stringify(errorMessage));
                component.set("v.errorMessage", "MerchantQuoteBuilderHelper.createUI: Error: [" + JSON.stringify(errorMessage) + "]. ");
            }else{
                console.log("Error Unknown State: " + status);
                component.set("v.errorMessage", "MerchantQuoteBuilderHelper.createUI:  Error Unknown State: " + status);
            }
        });
    },

    //JQUEV
    //Method which sets the current data on the page based on the Pricing Bean's current values.
    //It also sets the visibility
    mapDataToUIFields: function(component, helper, respBean){

        component.set("v.pricingBean", respBean);
        var metadataNameToValueMap = component.get("v.metadataNameToValueMap");
        var showDetailedSection = component.get("v.showDetailedSection");
        var rentalAmountMdt;
        var PSEKeyToMetadataMap = new Map();

        //Add app the Price Scheme Entry Mdt to a map against their Price Scheme Entry Map Key.
        //Non Rollup fields would not use map keys
        //Therefor they can be ignored as this map is used to get the corresponding rollup field to a detailed field
        if(showDetailedSection){
            respBean.fieldVisibilityMdtList.forEach(function (item) {
                var additionalAttributes = JSON.parse(item.Additional_Attributes__c);
                if(!$A.util.isEmpty(additionalAttributes.priceSchemeEntryMapKey) && additionalAttributes.priceSchemeEntryMapKey.includes(":[All]")){
                    PSEKeyToMetadataMap[additionalAttributes.priceSchemeEntryMapKey] = item;
                }
            });
        }
        //For Each Metadata Record
        respBean.fieldVisibilityMdtList.forEach(function (item) {

            var additionalAttributes = JSON.parse(item.Additional_Attributes__c);
            //If we are not rendering the detailed section & the current field is a detailed field
            if(!showDetailedSection && additionalAttributes.fieldType == "detailed"){
                //Nullify the detailed field in the map
                metadataNameToValueMap[item.DeveloperName] = null;
                //If we are rendering the detailed section & the current field is a detailed field
            }else if(showDetailedSection && additionalAttributes.fieldType == "detailed"){

                //Get value from rollup field
                if(!$A.util.isEmpty(additionalAttributes.priceSchemeEntryMapKey)){
                    var transactionGroup = additionalAttributes.priceSchemeEntryMapKey.substr(additionalAttributes.priceSchemeEntryMapKey.indexOf("["), additionalAttributes.priceSchemeEntryMapKey.indexOf("]") + 1);
                    var rollupFieldMdt = PSEKeyToMetadataMap[transactionGroup + ":[All]"];
                    //Map contains key
                    if(rollupFieldMdt){
                        //Get value from metadataNameToValueMap
                        var rollupValueFromMdtNameToValMap = metadataNameToValueMap[rollupFieldMdt.DeveloperName];

                        if(rollupValueFromMdtNameToValMap){
                            //Assign value to detailed field
                            metadataNameToValueMap[item.DeveloperName] = rollupValueFromMdtNameToValMap;
                        }else{
                            //If no value in metadataNameToValueMap, then use the value form the bean
                            var rollupAddAttributes = JSON.parse(rollupFieldMdt.Additional_Attributes__c);
                            if(!$A.util.isEmpty(rollupAddAttributes.valueReadPath)){
                                metadataNameToValueMap[item.DeveloperName] = helper.getDeep(respBean, rollupAddAttributes.valueReadPath);
                            }
                        }
                    }else{
                        //No Rollup field Mdt found, Nullify the field
                        metadataNameToValueMap[item.DeveloperName] = null;
                    }
                }
            }else{
                //Normal Field (Non detailed)
                //If no Value found in the metadataNameToValueMap
                if(!metadataNameToValueMap[item.DeveloperName]){
                    //Normal field, Get value from bean
                    if(!$A.util.isEmpty(additionalAttributes.valueReadPath)){
                        metadataNameToValueMap[item.DeveloperName] = helper.getDeep(respBean, additionalAttributes.valueReadPath);
                    }
                }
            }
            //find monthlyRental mdt to do calculation with.
            //Needs to be done after all other values have already been mapped.
            if(item.Field_Name__c == "monthlyRental"){
                rentalAmountMdt = item;
            }
        });
        //Calculate Monthly Total if applicable
        if(!$A.util.isEmpty(rentalAmountMdt)){
            metadataNameToValueMap[rentalAmountMdt.DeveloperName] = this.calculateMonthlyTotal(component);
        }
        //Populate Value Added Services
        component.set('v.allComponentProducts', respBean.componentProductDataList);
    },

    //JQUEV
    //Method that gets the values for all the fields on the quote builder and maps them to the Pricing Bean JSON Structure
    mapUIFieldsToJSON: function(component, helper){
        var respBean = component.get('v.pricingBean');
        var quoteNumber = respBean.quoteNumber;
        //Create Quote number
        if ($A.util.isEmpty(quoteNumber)) {
            respBean.quoteNumber = component.get("v.recordId").substring(0, 15).toUpperCase() + '-Q1';
        } else {
            var quoteNumberIncrement = parseInt(quoteNumber.substring(17)) + 1;
            if (isNaN(quoteNumberIncrement)) {
                respBean.quoteNumber = component.get("v.recordId").substring(0, 15).toUpperCase() + '-Q1';
            } else {
                respBean.quoteNumber = quoteNumber.substring(0, 15).toUpperCase() + '-Q' + quoteNumberIncrement;
            }
        }
        if(respBean.quoteGenerationDate == null){
            respBean.quoteGenerationDate = new Date().toISOString();
        }

        var metadataNameToValueMap = component.get("v.metadataNameToValueMap");

        respBean.fieldVisibilityMdtList.forEach(function (item) {
            var value = metadataNameToValueMap[item.DeveloperName];
            var additionalAttributes = JSON.parse(item.Additional_Attributes__c);

            //parse value as a Float if is it a number
            value = additionalAttributes.dataType == "number" ? parseFloat(value) : value;

            //Set value in bean
            if (additionalAttributes.valueWritePath) {
                respBean = helper.setDeep(respBean, additionalAttributes.valueWritePath, value);
            } else if (additionalAttributes.valueReadPath) {
                respBean = helper.setDeep(respBean, additionalAttributes.valueReadPath, value);
            }
        });
        return JSON.stringify(respBean);
    },

    mapFieldsToDataTable: function(component, helper, respBean) {

        if(respBean.quoteStatus !== 'Pending'){
            this.setNoActions(component);
        } else {
            this.setAllActions(component);
        }

        var data = [{
            quoteNumber: respBean.quoteNumber,
            serviceName: respBean.productName,
            quantity: respBean.selectedQuantity,
            monthlyRental: this.calculateMonthlyTotal(component),
            status: respBean.quoteStatus,
            date: respBean.quoteGenerationDate,
        }];
        component.set("v.data", data);
    },

    generateMerchantQuote: function(component, helper){
        this.showSpinner(component);
        var stringBean = this.mapUIFieldsToJSON(component, helper);
        var action = component.get("c.saveQuoteBuilderData");
        component.set("v.activeSections", component.get('v.defaultActiveSections'));
        var onlySaveUpdatedData = component.get("v.saveOnlyUpdatedData");
        action.setParams({
			"jsonString": stringBean,
			"saveOnlyUpdatedData": onlySaveUpdatedData
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('State Muvhuso:' + state);
            if (component.isValid() && state === "SUCCESS") {
                var resp = response.getReturnValue();
                var respBean = JSON.parse(resp);
                this.mapDataToUIFields(component, helper, respBean);

                if(component.get("v.quoteType") == component.get("v.merchantOnboarding")){

                    var documentGenerationMap = this.populateDocumentGeneration(component, respBean);
                    var action = component.get("c.generateMerchantQuoteDocument");
                    action.setParams({
                        "documentGenerationMap": documentGenerationMap
                    });
                    action.setCallback(this, function(response) {
                        if (response.getState() == "SUCCESS") {
                            var responseValue = response.getReturnValue();
                            if (responseValue === 'success') {
                                //Set Quote Number and Quote Generation Date
                                component.find("oppQuoteNumber").set("v.value", respBean.quoteNumber);
                                component.find("oppQuoteGenerationDate").set("v.value", respBean.quoteGenerationDate);
                                component.find("opportunityForm").submit();
                                this.mapFieldsToDataTable(component, helper, respBean);

                                component.set('v.isFormReadOnly', true);
                                component.set("v.errorMessage", null);
                                this.fireToast("Success", "Quote document generated successfully", "success");
                            } else {
                                component.set("v.errorMessage", "MerchantQuoteBuilderHelper.generateMerchantQuote: Service response error: [" + responseValue + "]. ");
                            }
                        } else if(response.getState() === "ERROR"){
                            var errors = response.getError();
                            component.set("v.errorMessage", "MerchantQuoteBuilderHelper.generateMerchantQuote: Apex error: [" + JSON.stringify(errors) + "]. ");
                        } else {
                            component.set("v.errorMessage", "MerchantQuoteBuilderHelper.generateMerchantQuote: Apex error. ");
                        }
                        this.hideSpinner(component);
                    });
                    $A.enqueueAction(action);

                    //Temporary for testing
                    /*component.find("oppQuoteNumber").set("v.value", respBean.quoteNumber);
                    component.find("oppQuoteGenerationDate").set("v.value", respBean.quoteGenerationDate);
                    component.find("opportunityForm").submit();
                    this.mapFieldsToDataTable(component, helper, respBean);
                    this.hideSpinner(component);
                    component.set('v.isFormReadOnly', true);
                    component.set("v.errorMessage", null);
                    this.fireToast("Success", "Quote document generated successfully", "success");*/
                }else{
                    var action = component.get("c.sendEmailSPM");
                    var stringBean = this.mapUIFieldsToJSON(component, helper);
                    console.log("stringBean: " + stringBean);
                    action.setParams({
                        "jsonString": stringBean,
                        "recId" : component.get("v.recordId")
                    });
                    action.setCallback(this, function(response) {
                        console.log('State :' + response.getState());
                        if (response.getState() == "SUCCESS") {
                            var responseValue = response.getReturnValue();
                            console.log("Response Value : " + responseValue);
                            if (responseValue.includes("success")) {
                                //Set Quote Number and Quote Generation Date
                                component.find("oppQuoteNumber").set("v.value", respBean.quoteNumber);
                                component.find("oppQuoteGenerationDate").set("v.value", respBean.quoteGenerationDate);
                                component.find("opportunityForm").submit();
                                this.mapFieldsToDataTable(component, helper, respBean);
            
                                component.set('v.isFormReadOnly', true);
                                component.set("v.errorMessage", null);
                                this.fireToast("Success", "Fees saved successfully. ", "success");
                                this.hideSpinner(component);
                            } else {
                                console.log('Set opportunity stage');
                                component.find("oppStageName").set("v.value", 'Additional Product Details');
                                component.find("opportunityForm").submit();
                                //component.set("v.errorMessage", "QuoteBuilderHelper.sendEmailSPM: Service response error: [" + responseValue + "]. ");
                            }
                        } else if(response.getState() === "ERROR"){
                            var errors = response.getError();
                            component.set("v.errorMessage", "QuoteBuilderHelper.sendEmailSPM: Apex error: [" + JSON.stringify(errors) + "]. ");
                        } else {
                            component.set("v.errorMessage", "QuoteBuilderHelper.sendEmailSPM: Apex error. ");
                        }
                        this.hideSpinner(component);
                    });
                    $A.enqueueAction(action);
                }
            } else if(state === "ERROR"){
                this.hideSpinner(component);
                var errors = response.getError();
                this.fireToast("Error", "Error: " + JSON.stringify(errors), "error");
                component.set('v.isFormReadOnly', false);
            } else {
                this.hideSpinner(component);
                this.fireToast("Error", "Apex error.", "error");
                component.set('v.isFormReadOnly', false);
            }
        });
        // Send action off to be executed
        $A.enqueueAction(action);
    },

    // PJAIN: 20200724
    populateDocumentGeneration: function(component, respBean) {
        var documentGenerationMap = new Map();
        var quoteGenerationDate = new Date(respBean.quoteGenerationDate);
        var quoteExpirationDate = new Date(respBean.quoteGenerationDate);
        quoteExpirationDate.setDate(quoteGenerationDate.getDate() + 10); // Add 10 days to the quote generation date

        // Use the Field visibility Mdt and Resp Bean to be Generic
        // Populate fixed values in the documentGenerationMap
        documentGenerationMap['inputType'] = 'fieldValues';
        documentGenerationMap['quoteNumber'] = respBean.quoteNumber;
        documentGenerationMap['opportunityId'] = respBean.opportunityId;
        documentGenerationMap['accountName'] = respBean.accountName;
        documentGenerationMap['productName'] = respBean.productName;
        documentGenerationMap['selectedQuantity'] = respBean.selectedQuantity;
        documentGenerationMap['quoteGenerationDate'] = quoteGenerationDate;
        documentGenerationMap['quoteGeneratedBy'] = $A.get("$SObjectType.CurrentUser.Email");
        documentGenerationMap['quoteExpirationDate'] = quoteExpirationDate;
        // Start Tinashe bug to display the contract duration
        if(!$A.util.isEmpty(respBean.selectedContractDurationType)){
            if (respBean.selectedContractDurationType.includes('12')) {
                documentGenerationMap['selectedContractDurationType'] = '12';
            } else if (respBean.selectedContractDurationType.includes('24')) {
                documentGenerationMap['selectedContractDurationType'] = '24';
            } else if (respBean.selectedContractDurationType.includes('36')) {
                documentGenerationMap['selectedContractDurationType'] = '36';
            } else {
                documentGenerationMap['selectedContractDurationType'] = '1';
            }
        }
// end Tinashe bug to display the contract duration

        // Populate dynamic values from priceSchemeEntryMap in the documentGenerationMap
        for (var key in respBean.priceSchemeEntryMap) {
            documentGenerationMap[key] = respBean.priceSchemeEntryMap[key].updatedValue;
        }

        return documentGenerationMap;
    },

    reviseQuote: function(component, helper) {
        this.showSpinner(component);
        component.set('v.isFormReadOnly', false);
        component.find("oppQuoteGenerationDate").set("v.value", null);
        component.find("opportunityForm").submit();
        this.fireToast("Success", "Quote revised successfully", "success");
    },

    acceptQuote : function(component, helper) {
        var opportunityId = component.get("v.recordId");
        var respBean = component.get('v.pricingBean');
        var metadataNameToValueMap = component.get("v.metadataNameToValueMap");
        var action = component.get("c.createApplicationRecords");
        component.set("v.errorMessage", null);
        action.setParams({
            "pricingBeanString" : JSON.stringify(respBean),
            "metadataNameToValueMap" : metadataNameToValueMap
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var resp = response.getReturnValue();
                var error = resp['error'];

                if (error) {
                    this.fireToast("Error", error, "error");
                } else {
                    var applicationId = resp['applicationId'];
                    var applicationProductMerchantId = resp['applicationProductMerchantId'];

                    if ($A.util.isEmpty(applicationId) || $A.util.isEmpty(applicationProductMerchantId)) {
                        this.fireToast("Error", "Application creation failed. Quote not accepted. Please contact administrator.", "error");
                    } else {
                        this.showSpinner(component);
                        component.find("oppStageName").set("v.value", 'Apply Product');
                        component.find("oppQuoteStatus").set("v.value", 'Accepted');
                        component.set("v.pricingBean.quoteStatus", "Accepted");
                        component.find("opportunityForm").submit();

                        var appEvent = $A.get("e.c:onboardingOpportunityIdsCreated");
                        appEvent.setParams({
                            "sourceComponent" : "MerchantQuoteBuilder",
                            "opportunityId" : opportunityId,
                            "opportunityProductId" : respBean.opportunityLineItemId,
                            "applicationId" : applicationId,
                            "applicationProductMerchantId" : applicationProductMerchantId
                        });
                        appEvent.fire();
                        this.fireToast("Success!", "Quote accepted successfully.", "success");
                        this.mapFieldsToDataTable(component, helper, component.get("v.pricingBean"));
                    }
                }
            } else if(state === "ERROR"){
                var errors = response.getError();
                this.showError(component, "acceptQuote: Apex error: [" + JSON.stringify(errors) + "].");
            } else {
                this.showError(component, "acceptQuote: Apex error.");
            }
        });
        // Send action off to be executed
        $A.enqueueAction(action);
    },

    //JQUEV 20200818
    changeSelectedProduct : function(component, event, helper, productName) {
        this.showSpinner(component);
        var opportunityId = component.get("v.recordId");
        var action = component.get("c.changeSelectedProduct");
        component.set("v.errorMessage", null);
        action.setParams({
            "opportunityId" : opportunityId,
            "productName" : productName
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            this.hideSpinner(component);
            if (component.isValid() && state === "SUCCESS") {
                var resp = response.getReturnValue();
                var error = resp['error'];
                if(error){
                    this.fireToast("Error", error, "error");
                }else{
                    var opportunityProductId = resp['opportunityProductId'];
                    if($A.util.isEmpty(opportunityProductId)){
                        //OpportunityLineItem Id is null
                        this.fireToast("Error", "OpportunityLineItem Id is blank. ", "error");
                    }else{
                        //Clear all values in metadataNameToValueMap as product was changed and new values need to be loaded
                        component.set("v.metadataNameToValueMap", {});
                        //Success - get Pricing Bean and build UI
                        this.getQuoteBuilderData(component, event, helper);

                        // Fire onboardingOpportunityIdsCreated Event
                        var appEvent = $A.get("e.c:onboardingOpportunityIdsCreated");
                        appEvent.setParams({
                            "sourceComponent" : "MerchantQuoteBuilder",
                            "opportunityId" : component.get("v.recordId"),
                            "opportunityProductId" : opportunityProductId
                        });
                        appEvent.fire();
                        this.fireToast("Success!", "Product has been changed successfully. ", "success");
                    }

                }
            } else if(state === "ERROR"){
                var errors = response.getError();
                this.showError(component, "acceptQuote: Apex error: [" + JSON.stringify(errors) + "].");
            } else {
                this.showError(component, "acceptQuote: Apex error.");
            }
        });
        // Send action off to be executed
        $A.enqueueAction(action);
    },

    //W-005082 JQUEV
    openRejectQuoteModal: function(component, helper) {

        //Pre set the close loss values in order to populate the Loss Reason dependent picklist
        component.find("oppStageName").set("v.value", "Closed Lost");
        component.find("oppLossReasonType").set("v.value", "Customer declined Proposal");
        //Set Loss Reason to Required
        component.find("oppLossReason").set("v.required", true);
        helper.openModal(component, "lossReasonModal");
    },

    //W-005082 JQUEV
    openModal: function(component, modalAuraId) {
        var cmpTarget = component.find(modalAuraId);
        var cmpBack = component.find('Modalbackdrop');
        $A.util.addClass(cmpTarget, 'slds-fade-in-open');
        $A.util.addClass(cmpBack, 'slds-backdrop--open');
    },

    //W-005082 JQUEV
    closeModal : function(component, modalAuraId){
        var cmpTarget = component.find(modalAuraId);
        var cmpBack = component.find('Modalbackdrop');
        $A.util.removeClass(cmpBack,'slds-backdrop--open');
        $A.util.removeClass(cmpTarget, 'slds-fade-in-open');
    },


    calculateMonthlyTotal : function(component) {
        var metadataNameToValueMap = component.get("v.metadataNameToValueMap");
        var pricingBean = component.get("v.pricingBean");
        var quantity, rentalAmount, monthlyTotal;

        pricingBean.fieldVisibilityMdtList.forEach(function (item) {
            var additionalAttributes = JSON.parse(item.Additional_Attributes__c);
            if(additionalAttributes.fieldAPIName == "Quantity"){
                quantity = metadataNameToValueMap[item.DeveloperName];
            }
            if(additionalAttributes.fieldAPIName == "UnitPrice"){
                rentalAmount = metadataNameToValueMap[item.DeveloperName];
            }
        });
        if(!$A.util.isEmpty(quantity) && !$A.util.isEmpty(rentalAmount)){
            monthlyTotal = quantity * rentalAmount;
        }
        return monthlyTotal;
    },

    setAllActions: function(component) {
        var actions = [
            { label: 'Revise', name: 'revise' },
            { label: 'Accept', name: 'accept' },
            { label: 'Reject', name: 'reject' },
            { label: 'Email', name: 'email' }, //Story W-004373 - Tinashe Shoko
            { label: 'Download', name: 'download' }, //Story W-004373 - Tinashe Shoko
            { label: 'E-Sign', name: 'esign' } //Story W-004373 - Tinashe Shoko
        ];
        this.setColumns(component, actions);
    },

    setNoActions: function(component) {
        var actions = [
            { label: 'Action already performed', name: 'doNothing' }
        ];
        this.setColumns(component, actions);
    },

    setColumns: function(component, actions) {
        component.set('v.columns', [
            {label: 'Quote Number', fieldName: 'quoteNumber', type: 'text'},
            {label: 'Service', fieldName: 'serviceName', type: 'text'},
            {label: 'Quantity', fieldName: 'quantity', type: 'number', cellAttributes: { alignment: 'left' }},
            {label: 'Monthly Rental', fieldName: 'monthlyRental', type: 'currency', typeAttributes: { currencyCode: 'ZAR', maximumSignificantDigits: 5 }, cellAttributes: { alignment: 'left' }},
            {label: 'Status', fieldName: 'status', type: 'text'},
            {label: 'Date', fieldName: 'date', type: 'date', typeAttributes: {
                                                                    day: 'numeric',
                                                                    month: 'numeric',
                                                                    year: 'numeric',
                                                                    hour: '2-digit',
                                                                    minute: '2-digit',
                                                                    hour12: false
                                                                }},
            { type: 'action', typeAttributes: { rowActions: actions }}
        ]);
    },

    showError: function(component, message){
        console.log("Error: " + message);
        var errorMsgCmp = component.get("v.errorMessage");
        if($A.util.isEmpty(errorMsgCmp)){
            component.set("v.errorMessage", message);
        } else {
            component.set("v.errorMessage", errorMsgCmp + message);
        }

    },

    showSpinner: function(component) {
        component.set("v.isSpinner",true);
    },

    hideSpinner: function(component) {
        component.set("v.isSpinner",false);
    },

    // PJAIN: 20200505
    // Method to validate all fields
    // showErrorFlag - Boolean value to display errors on the field
    // Use case 1:  showErrorFlag would be true when calling this method from save as you would want to display errors
    // Use case 2:  showErrorFlag would be false when calling this method on load to check if the fields are complete to mark the form as VaidToSubmit
    allFieldsValid: function(component, showErrorFlag) {

        var arrayAuraIdsToBeValidated = component.get("v.arrayAuraIdsToBeValidated");
        var arrayFields = [];

        for (var i = 0; i < arrayAuraIdsToBeValidated.length; i++) {
            arrayFields.push(component.find(arrayAuraIdsToBeValidated[i]));
        }

        // Show error messages if required fields are blank
        var allValid = arrayFields.reduce(function (validFields, inputCmp) {
            if (showErrorFlag) {
                inputCmp.showHelpMessageIfInvalid();
            }

            return validFields && inputCmp.get('v.validity').valid;
        }, true);

        return allValid;
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
    },

    // eSign the doc //Story W-004373 - Tinashe Shoko - START
    fetchSignatories: function (component) {
        //this.showSpinner(component);
        var opportunityId = component.get("v.recordId");
        var action = component.get("c.getSignatoriesData");
        action.setParams({
            "opportunityId" : opportunityId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                component.set("v.signatoriesOutput", data);
                for (var i = 0; i < data.length; i++) {
                    if (data[i].Mobile_Phone == '' || data[i].Email == '' || data[i].Title == '') {
                        // Tinashe - further coding downstream will fail if any one of these values is null
                        component.set("v.isButtonSignatureDisabled", true);
                    }  else {
                        if (component.get("v.isButtonSignatureDisabled") != true) {
                            component.set("v.isButtonSignatureDisabled", false);
                        }
                    }
                }
            }
            else {
                console.log("Failed with state: " + state);
            }
            //this.hideSpinner(component);
        });
        $A.enqueueAction(action);
    },

    ////Story W-004373 - Tinashe Shoko
    checkIfDocumentRestricted : function(component, event, helper, method, signatories){
        var opportunityId = component.get("v.recordId");
        var respBean = component.get('v.pricingBean');

        var action = component.get("c.documentRestricted");
        action.setParams({
            "opportunityId" : opportunityId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" ) {
                if(response.getReturnValue()) {
                    component.set("v.inProgressOrSignedRequestExists", true);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams ({
                        "title": "Error!",
                        "message": "This document cannot be submitted to Impression for E-Signature.",
                        "type": "error"
                    });
                    toastEvent.fire();
                } else if (method == 'sign') {
                    component.set("v.showESignatureDataTable", true);
                    this.fetchSignatories(component);
                } else if (method == 'sendForSignature') {
                    this.sendForSignature(component, signatories);
                    component.set("v.showESignatureDataTable", false);
                    this.fetchImpressionRequest(component);
                }
            }
            //this.hideSpinner(component);
        });
        // Send action off to be executed
        $A.enqueueAction(action);
    },

    updateSignatories: function (component, signatoriesOutput) {
        this.showSpinner(component);
        var action = component.get("c.getUpdatedSignatoriesData");
        action.setParams({
            "opportunityId": component.get("v.recordId"),
            //"documentId": component.get("v.documentId"),
            "signatoryId": component.get("v.signatoryId"),
            "signatoriesInput": signatoriesOutput,
            "method": component.get("v.selectedMethod"),
            "mobile": component.get("v.selectedMobileSignatory"),
            "email": component.get("v.selectedEmailSignatory")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                component.set("v.signatoriesOutput", data);
                for (var i = 0; i < data.length; i++) {
                    if (data[i].Mobile_Phone == '' || data[i].Email == '' | data[i].Title == '') {
                        component.set("v.isButtonSignatureDisabled", true);
                    }  else {
                        if (component.get("v.isButtonSignatureDisabled") != true) {
                            component.set("v.isButtonSignatureDisabled", false);
                        }
                    }
                }
            }
            else {
                console.log("Failed with state: " + state);
            }
            this.hideSpinner(component);
        });
        $A.enqueueAction(action);
    },

    fetchAllClientEmailsSignature: function (component) {
        var action = component.get("c.getAllClientEmailsSignature");
        action.setParams({
            "opportunityId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                var opts = [];
                //Set first list value
                component.set("v.selectedEmail", data[0]);
                for (var i = 0; i < data.length; i++) {
                     opts.push({
                        class: "optionClass",
                        label: data[i],
                        value: data[i]
                    });
                }
                component.set("v.emailOptions", opts);
            }
        });
        $A.enqueueAction(action);
    },

    getMobile: function (component) {
        var action = component.get("c.getMobile");
        action.setParams({
            "opportunityId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                var opts = [];
                //Set first list value
                if (data.length > 0) {
                    component.set("v.selectedMobile", data[0]);
                }

                for (var i = 0; i < data.length; i++) {
                     opts.push({
                        class: "optionClass",
                        label: data[i],
                        value: data[i]
                    });
                }
                component.set("v.mobileOptions", opts);
            }
        });
        $A.enqueueAction(action);
    },

    fetchMethodPickListVal : function(component, fieldName, row) {
        var action = component.get("c.getDigitalSignatorySelectOptions");
            action.setParams({
            "fld": fieldName
        });

        var opts = [];
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                var data = response.getReturnValue();
                if (data != undefined && data.length > 0) {
                    opts.push({class: "optionClass", label: row.Method, value: row.Method});
                    for (var i = 0; i < data.length; i++) {
                        if(row.Method != data[i]) {
                            opts.push({class: "optionClass", label: data[i], value: data[i]});
                        }
                    }
                }
                component.set("v.methodOptions", opts);
            }
        });
        $A.enqueueAction(action);
    },

    refreshSignatories: function (component) {
        this.showSpinner(component);
        var action = component.get("c.getSignatoriesData");
        action.setParams({
            "opportunityId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                component.set("v.signatoriesOutput", data);
                for (var i = 0; i < data.length; i++) {
                    if (data[i].Mobile_Phone == '' || data[i].Email == '' || data[i].Title == '') {
                        // Tinashe - further coding downstream will fail if any one of these values is null
                        component.set("v.isButtonSignatureDisabled", true);
                    } else {
                        if (component.get("v.isButtonSignatureDisabled") != true) {
                            component.set("v.isButtonSignatureDisabled", false);
                        }
                    }
                }
            }
            else {
                console.log("Failed with state: " + state);
            }
            this.hideSpinner(component);
        });
        $A.enqueueAction(action);
    },

    sendForSignature: function (component, signatoriesOutput) {
        this.showSpinner(component);
        console.log(' console ' + signatoriesOutput);
        var action = component.get("c.sendForImpressionSignature");
        action.setParams({
            "opportunityId": component.get("v.recordId"),
            "signatories": signatoriesOutput
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "Document sent to Impression for signing.",
                    "type":"success"
                });
                toastEvent.fire();
            }
            else {
                console.log("Failed with state: " + state);
            }
            this.hideSpinner(component);
        });
        $A.enqueueAction(action);
    },

    fetchImpressionRequest: function (component) {
        //this.showSpinner(component);
        var action = component.get("c.fetchImpressionRequest");
        action.setParams({
            "opportunityId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var records = response.getReturnValue();
                records.forEach(function(record){
                    record.linkName = '/'+record.Id;
                });
                component.set("v.impressionRequestData", records);

            }
            else {
                console.log("Failed with state: " + state);
            }
            //this.hideSpinner(component);
        });
        $A.enqueueAction(action);
    },

    download: function (component, docName) {
        this.showSpinner(component);
        var action = component.get('c.getDocumentContent');
        action.setParams({
            "opportunityId": component.get("v.recordId"),
            "sharingMethod": 'Download',
            "clientEmail": ''
        });
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                var element = document.createElement('a');
                element.setAttribute('href', 'data:application/octet-stream;content-disposition:attachment;base64,' + data);
                element.setAttribute('download', docName);
                element.style.display = 'none';
                document.body.appendChild(element);
                element.click();
                document.body.removeChild(element);

                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "Document(s) Successfully Downloaded to the Desktop.",
                    "type":"success"
                });
                toastEvent.fire();

            } else {
                console.log("Download failed ...");
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Failed Downloaded Document(s) to the Desktop.",
                    "type":"error"
                });
                toastEvent.fire();
            }
            this.hideSpinner(component);
        }));
        $A.enqueueAction(action);
    },

    getDocName: function(component) {
        var action = component.get('c.getQuoteDocumentName');
        action.setParams({
            "opportunityId": component.get("v.recordId")
        });
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.documentId", response.getReturnValue());
                this.download(component, response.getReturnValue());
            } else {
                console.log("Download failed ...");
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Failed to get Quote Document Name.",
                    "type":"error"
                });
                toastEvent.fire();
            }
        }));
        $A.enqueueAction(action);
    },

    emailSharing: function (component) {
        this.showSpinner(component);
        var rows = component.get('v.data');
        var action = component.get("c.sendDocumentSharingEmail");
        action.setParams({
            "opportunityId": component.get("v.recordId"),
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "Documents Successfully Emailed to the Client.",
                    "type":"success"
                });
                toastEvent.fire();
            }
            else {
                console.log("Failed with state: " + state);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Error with Emailing Documents to the Client.",
                    "type":"error"
                });
                toastEvent.fire();
            }
            this.hideSpinner(component);
        });
        $A.enqueueAction(action);
    },
    // eSign the doc //Story W-004373 - Tinashe Shoko - END

    // Dynamically sets a deeply nested value in an object. Creates the path if its undefined.
    // @param {!object} obj  - The object which contains the value you want to change/set.
    // @param {!string} path  - The path to the value you want to change/set. e.g. 'level1.level2.fieldToSet'
    // @param {!mixed} value - The value you want to set it to.
    setDeep : function(obj, path, value) {
        const pList = path.split('.');
        const key = pList.pop();
        const pointer = pList.reduce(function(accumulator, currentValue) {
            if (typeof accumulator[currentValue] !== "object" || Array.isArray(accumulator[currentValue])) {
                accumulator[currentValue] = {};
            }
            return accumulator[currentValue];
        }, obj);
        pointer[key] = value;
        return obj;
    },

    // Dynamically gets a deeply nested value in an object.
    // @param {!object} obj  - The object which contains the value you want to get.
    // @param {!string} path  - The path to the value you want to get. e.g. 'level1.level2.fieldToSet'
    getDeep : function(obj, path) {
        const pList = path.split('.');
        const key = pList.pop();
        const pointer = pList.reduce(function(accumulator, currentValue) {
            if (accumulator[currentValue] === undefined)
                accumulator[currentValue] = {};
            return accumulator[currentValue];
        }, obj);
        return pointer[key];
    }
})