/**
 * @Author: Mbuyiseni Mbhokane
 */
({
    //GET RELATED PARTIES
    relatedParties :function (component, event, helper){
          this.showSpinner(component);
        component.set('v.mycolumns', [
            {label: 'FirstName', fieldName: 'FirstName', type: 'text'},
            {label: 'LastName', fieldName: 'LastName', type: 'text'},
            {label: 'CIF', fieldName: 'CIF', type: 'text'}
        ]);
        
        var action = component.get("c.getRelatedParties");
        console.log("Opportunity Id " + component.get("v.recordId"));
        action.setParams({"oppId": component.get("v.recordId")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var relatedParties = response.getReturnValue();
                console.log("Related size : "+ relatedParties.length);
                //Use the if statement to check the related party length
                if(relatedParties.length > 0){

                    console.log("Related Parties " + JSON.stringify(relatedParties));
                    component.set("v.relatedParties", relatedParties);
                    for (var i = 0; i < relatedParties.length; i++){
                       component.set("v.selectedRelatedPartyCIF", relatedParties[0].CIF); 
                    }

                }else{

                    var toast = this.getToast("Error", "The Account Doesnt have the related Parties", "error");
                    toast.fire();
                    //disable the Next button
                    if(component.find("relatedPartiesListId") != undefined) {
                        component.find("relatedPartiesListId").set("v.disabled", true);
                    }
                }
            }
            else {
                console.log("Failed with state: " + JSON.stringify(response));
            }
            this.hideSpinner(component);
        });
        $A.enqueueAction(action);
        

    },
     
    //STATIC BRAND NUMBERS DATA
        staticBrandNumbers :function (component, event, helper){
            this.showSpinner(component);

          component.set('v.staticBrandColumns', [
              {label: 'Brand Name', fieldName: 'MasterLabel', type: 'text'},
              {label: 'Brand Number', fieldName: 'Brand_Number__c', type: 'text'}
          ]);
          
          var action = component.get("c.brandNumbers");
          //console.log("Opportunity Id " + component.get("v.recordId"));
          //action.setParams({"oppId": component.get("v.recordId")});

          action.setCallback(this, function(response) {
              var state = response.getState();
              if (state === "SUCCESS") {
                  var returnedBrandNumbers = response.getReturnValue();

                  if(returnedBrandNumbers.length > 0){

                    console.log("Stringified returnedBrandNumbers: " + JSON.stringify(returnedBrandNumbers));
                    console.log("Returned Brand Data Size : "+ returnedBrandNumbers.length);
                    component.set("v.staticBrandNums", returnedBrandNumbers);

                  }else{

                    var toast = this.getToast("Error", "No Brand Numbers were returned", "error");
                    toast.fire();
                    //disable the Next button
                    component.find("brandListId").set("v.disabled", true);
                  }

              }
              else {
                  console.log("Failed with state: " + JSON.stringify(response));
              }
              this.hideSpinner(component);
          });
          $A.enqueueAction(action);
  
      },

    //Get opportunityLineItem Details
    opportunityLineItemDetails :function (component, event, helper){
        
        var action = component.get("c.getOpportunityLineItemDetails");
        console.log("Opportunity Id " + component.get("v.recordId"));
        action.setParams({"opportunityId": component.get("v.recordId")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var opportunityLineItemDetails = response.getReturnValue();
                console.log("OpportunityLineItem Details " + JSON.stringify(opportunityLineItemDetails));
                for (var i = 0; i < opportunityLineItemDetails.length; i++){
                    //console.log('Policy Number/Account Number '+ opportunityLineItemDetails[0].Policy_Number__c);
                    if(opportunityLineItemDetails[0].Policy_Number__c != null){

                        component.set("v.clientAccNumber", opportunityLineItemDetails[0].Policy_Number__c);
                        component.set('v.productType', opportunityLineItemDetails[0].Product_Family__c);
                        component.set('v.productCode', opportunityLineItemDetails[0].ProductCode);

                        

                    }else{

                        var toast = this.getToast("Error", "No Account Number for this Opportunity : ", "error");
                        toast.fire();
                        component.find("relatedPartiesListId").set("v.disabled", true);
                        
                    }  
                }
                component.set("v.opportunityLineItemDetails", opportunityLineItemDetails);    
            }
            else {
                console.log("Failed with state: " + JSON.stringify(response));
            }
        });
        $A.enqueueAction(action);
    },
    
    //GET OPPORTUNITYLINEITEMS
    opportunityLineItems :function (component, event, helper){
        var action = component.get("c.getOpportunityLineItems");
        console.log("Opportunity Id " + component.get("v.recordId"));
        action.setParams({"opportunityId": component.get("v.recordId")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var oppLineItems = response.getReturnValue();
                console.log("customer product " + JSON.stringify(oppLineItems));
                component.set("v.productCodeList", oppLineItems);
            }
            else {
                console.log("Failed with state: " + JSON.stringify(response));
            }
        });
        $A.enqueueAction(action);
    },

        //GET RELATED PARTY ADDRESS
        relatedPartyAddress :function (component, event, helper){
            var action = component.get("c.selectedRelatedPartyAddress");
            action.setParams({"accountId": component.get("v.selectedRowId")});
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var selectedRelatedPartyAddress = response.getReturnValue();
                    console.log("Returned Address Size:  " + selectedRelatedPartyAddress.length);
                    if (selectedRelatedPartyAddress.length > 0) {
                        //set the address fields
                        component.set("v.street",selectedRelatedPartyAddress[0].Shipping_Street__c);
                        component.set("v.suburb",selectedRelatedPartyAddress[0].Shipping_Suburb__c);
                        component.set("v.province",selectedRelatedPartyAddress[0].Shipping_State_Province__c);
                        component.set("v.city",selectedRelatedPartyAddress[0].Shipping_City__c);
                        component.set("v.country",selectedRelatedPartyAddress[0].Shipping_Country__c);
                        component.set("v.postalCode",selectedRelatedPartyAddress[0].Shipping_Zip_Postal_Code__c);
                        component.set("v.addressId", selectedRelatedPartyAddress[0].Id);
                        console.log("The selected address ID: "+ selectedRelatedPartyAddress[0].Id);
                    } else {

                        var toast = this.getToast("warning", "No Residential address for selected Related Party", "warning");
                        toast.fire();
                    }

                }
                else {
                    console.log("Failed with state: " + JSON.stringify(response));
                    var toast = this.getToast("Error", "Something went wrong : "+ JSON.stringify(response), "error");
                    toast.fire();
                }
            });
            $A.enqueueAction(action);
        },

    //CALL SERVICE CClistPrefProductForClientV2
    /*cclistPrefProductsForClient :function (component, event, helper){
        this.showSpinner(component);

        //Set client CIF number
        component.set("v.clientCIF",component.find("clientCodeField").get("v.value"));
    
        switch (component.find("cardTypeField").get("v.value")) {
            case 'Combi':
                component.set("v.selectedCardType","C");
                break;
            case 'Internet':
                component.set("v.selectedCardType","I");
                break;
            case 'Credit Card':
                component.set("v.selectedCardType","R");
                break;
            case 'Priority Pass':
                component.set("v.selectedCardType","P");
                break;
            case 'Multi application':
                component.set("v.selectedCardType","L");
                break;
            default:
                console.log("Value not found");
        }

        //cclistPrefProductForClient service call
        var action = component.get("c.productForClient");
        console.log('client CIF : '+ component.get("v.clientCIF"));
        console.log('account number: '+ component.get("v.clientAccNumber"));
        console.log('Card type: '+ component.get("v.selectedCardType"));

        action.setParams({"clientCode": component.get("v.clientCIF"),
                          "accountNumber": component.get("v.clientAccNumber"),
                          "cardType": component.get("v.selectedCardType")
                        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                //nbrProdRet
                var productsForClient = JSON.parse(response.getReturnValue());
                console.log('the product list for client :'+ productsForClient);
                console.log('the product list for client version 2 :'+ JSON.stringify(response.getReturnValue()));
                if (productsForClient.statusCode == 200) {
                    
                    //add all returned products
                    var returnedProdList = productsForClient.CCS317O.outputCopybook.productListTable;
                    
                    //filter by Account Number
                    var listOfProducts = returnedProdList.filter(function (product){
                        return product.accountNumber != "0";
                    });
                     
                    //FILTER BY PRODUCT CODE
                    var filterByProdCode = returnedProdList.filter(function (productCode){
                        return productCode.prodCode != "0";
                    });
                    
                    
                    if (listOfProducts.length > 0) {

                        console.log('Filtered List of Products: '+ JSON.stringify(listOfProducts));
                        component.set("v.products", listOfProducts);
                        component.set("v.sbuCode",productsForClient.CCS317O.outputCopybook.sbuCode);

                    }else{

                        if (productsForClient.NBSMSGO3.outputErrorMessage.errorMessageTable[0].errorMessageText != "") {
                            
                            var toast = this.getToast("Error", "Error: " +  JSON.stringify(productsForClient.NBSMSGO3.outputErrorMessage.errorMessageTable[0].errorMessageText) , "error");
                            toast.fire();
                            //disable the Next button
                            component.find("productListId").set("v.disabled", true);
                            
                        } else {
                            
                            //THIS LOGIC WAS ADDED AS WORK AROUND BECAUSE THE PREFPRODLIST SERVICE WAS GIVING ERRORS.
                            filterByProdCode[0].accountNumber = component.get("v.clientAccNumber");
                            component.set("v.products", filterByProdCode[0]);
                            component.set("v.sbuCode",productsForClient.CCS317O.outputCopybook.sbuCode);
                        }

                    }
                }else{

                    var toast = this.getToast("Error", "Server Connection Error Code : " +  JSON.stringify(productsForClient.statusCode) , "error");
                    toast.fire();
                    //disable the Next button
                    component.find("productListId").set("v.disabled", true);
                }

            }
            else {

                console.log("Failed with state: " + JSON.stringify(response));
                var toast = this.getToast("Error", response , "error");
                toast.fire();

                //disable the Next button
                component.find("productListId").set("v.disabled", true);
            }

            this.hideSpinner(component);
        });
        $A.enqueueAction(action);
        
        component.set('v.productcolumns', [
            {label: 'Product Type', fieldName: 'prodType', type: 'text'},
            {label: 'Product Code', fieldName: 'prodCode', type: 'text'},
            {label: 'Account Number', fieldName: 'accountNumber', type: 'text'},
            {label: 'Product Brand', fieldName: 'prodBrand', type: 'text'}
        ]);
    },*/
    
    //CALL SERVICE : CCLISTCOMBIBRANDSFORPREFPROD
  /* listCombiBrandsForPrefProd :function (component, event, helper){
       this.showSpinner(component);
       
       var action = component.get("c.cclistCombiBrandsForPrefProd");
        action.setParams({"prodType": component.get("v.productType"),
                          "prodCode": component.get("v.productCode"),
                          "cardType": component.get("v.selectedCardType")});
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {

                console.log("Brand List : "+ response.getReturnValue());
                var productBrandListdata = JSON.parse(response.getReturnValue());

                    if (productBrandListdata.message == null) {
                    
                    console.log("productBrandListdata.ccp306o : "+ productBrandListdata.ccp306o);
                    console.log("productBrandListdata.ccp306o.nbrBrandRet: "+ productBrandListdata.ccp306o.nbrBrandRet);
                    //console.log("productBrandListdata.nbsmsgo.msgEntry.msgTxt : "+ productBrandListdata.nbsmsgo.msgEntry.msgTxt);

                    if (productBrandListdata.ccp306o.nbrBrandRet > 0) {

                        component.set("v.productBrandList", productBrandListdata.ccp306o.prdBrandDetails.prdBrandLst);
                        
                    } else {

                        var toast = this.getToast("Error", productBrandListdata.nbsmsgo.msgEntry.msgTxt, "error");
                        toast.fire();
                        component.find("brandListId").set("v.disabled", true);
                        
                    }

                } else {

                    var toast = this.getToast("Error", 'Error Code: '+productBrandListdata.statusCode +' - '+ productBrandListdata.message, "error");
                    toast.fire();
                    component.find("brandListId").set("v.disabled", true);
                        
                }
                  
            }
            else {

                console.log("Failed with state: " + JSON.stringify(response));
                var toast = this.getToast("Error", response , "error");
                toast.fire();
                component.find("brandListId").set("v.disabled", true);
            }
            this.hideSpinner(component);
        });
        $A.enqueueAction(action);
        
        component.set('v.productBrandColumns', [
            {label: 'Brand Type', fieldName: 'brandType', type: 'text'},
            {label: 'Brand Sub Type', fieldName: 'brandSubType', type: 'text'},
            {label: 'Brand Number', fieldName: 'brandNbr', type: 'text'}
        ]);
    },*/
    
    //CALL COMBI CARD ISSUE SERVICE
    combiCardIssue :function (component, event, helper){
        this.showSpinner(component);
        console.log("Selected brand Number : " + component.get("v.selectedBrandNumber"));
        console.log("Selected Account Number : " + component.get("v.clientAccNumber"));
        console.log("Client Code : " + component.get("v.clientCIF"));
        console.log("productCode: "+ component.get("v.productCode"));
        var appProd = component.get("v.applicationProduct");
        var accRecord = component.get("v.accountRecord");
        
        var cardNumber = appProd.Debit_Card_Number__c;
        console.log("Provided Account Number: "+ appProd.Debit_Card_Number__c);

        switch (component.get("v.idType")) {
            case 'SA Identity Document':
                component.set("v.idPspInd","I");
                console.log("Selected Id Type "+ component.get("v.idPspInd"));
                break;
            case 'Passport':
                component.set("v.idPspInd","P");
                console.log("Selected Id Type "+ component.get("v.idPspInd"));
                break;
            default:
                console.log("Value not found");
        }

        var idPspNbr = component.get("v.idNumber") !=null ? component.get("v.idNumber") : component.get("v.passportNumber");
        console.log("Id or Passport number : "+ idPspNbr);
        console.log("Card Number : " + cardNumber);
        console.log("Id Type: "+ component.get("v.idType"));
        console.log("ID Number : "+ component.get("v.idNumber"));
        console.log("Passport: "+ component.get("v.passportNumber"));
        console.log("idPspNbr : " + idPspNbr);
        //var chequeAccountNumber = component.get("v.selectedAccountNumber").startsWith("404",0) ? component.get("v.selectedAccountNumber") : '0'; 
        //var savingsAccountNumber = component.get("v.selectedAccountNumber").startsWith("90", 0) ? component.get("v.selectedAccountNumber") : '0';
        
        var chequeAccountNumber = component.get("v.productType") == 'Cheque' ? component.get("v.clientAccNumber") : '0';
        var savingsAccountNumber = component.get("v.productType") == 'Savings' ? component.get("v.clientAccNumber") : '0';
        console.log("cheque Account : "+ chequeAccountNumber);
        console.log("savings Account : "+ savingsAccountNumber);

        /*Set the person name */
        var personName;
        if (component.get("v.nameIndicator") == 'C') {
            personName = component.get("v.selectedName");
        }else if(component.get("v.nameIndicator") == 'F'){
            personName = appProd.Name__c;
        }else{
            personName = '';
        }

        //this.showSpinner(component);
        var action = component.get("c.ccIssueCard");

                         action.setParams({
                            "agencyCode": '6003', 
                            "cardReqdIndicator": 'N', 
                            "persIndicator": appProd.Personalised_Indicator__c, 
                            "persName": personName, //person name
                            "cardNumber": appProd.Debit_Card_Number__c, 
                            "clientCode": component.get("v.clientCIF"), 
                            "brandNumber": component.get("v.selectedBrandNumber"), 
                            "prodCode": component.get("v.productCode"), 
                            "autoLink": 'N', 
                            "nomCheq": chequeAccountNumber, 
                            "nomSavs": savingsAccountNumber, 
                            "nomCred": '0', 
                            "pinReqdIndicator": 'N', 
                            "cardFee": appProd.Card_Fee__c, 
                            "lostFee": appProd.Lost_Fee__c, 
                            "idPspIndicator": component.get("v.idPspInd"), 
                            "idPspNumber": idPspNbr, 
                            "cardTypeIndicator": component.get("v.selectedCardType")
                         });
        
        action.setCallback(this, function(response) {

            var state = response.getState();
            if (state === "SUCCESS") {

                console.log("Raw Returned Responses : "+ response.getReturnValue());
                var combiCardResponse = JSON.parse(response.getReturnValue());

                if (combiCardResponse.statusCode == 200) {
                    
                    if (combiCardResponse.CCS311O.outputCopybook.combiNumber != "0") {

                        component.set("v.combiCardNumber", combiCardResponse.CCS311O.outputCopybook.combiNumber);
                        var toast = this.getToast("Success", "Combi Card Number Created : " + JSON.stringify(combiCardResponse.CCS311O.outputCopybook.combiNumber), "Success");
                        toast.fire();
                    }else{

                        component.set("v.combiCardNumber", combiCardResponse.CCS311O.outputCopybook.combiNumber);
                        var toast = this.getToast("Error", 'Failed to create the Combi Card Number: '+ JSON.stringify(combiCardResponse.NBSMSGO3.outputErrorMessage.errorMessageTable[0].errorMessageText) , "error");
                        toast.fire();

                        component.find("submitCardOrdering").set("v.disabled", true);
                    }

                }else{

                    var toast = this.getToast("Error", 'Server Connection Error Code : '+ JSON.stringify(combiCardResponse.statusCode) , "error");
                    toast.fire();

                    component.find("submitCardOrdering").set("v.disabled", true);
                }

            }
            else {

                console.log("Failed with state: " + JSON.stringify(response));
                var toast = this.getToast("Error", response , "error");
                toast.fire();

                component.find("submitCardOrdering").set("v.disabled", true);
            }
            this.hideSpinner(component);
        });
        $A.enqueueAction(action);
    },
    
    //CALL BBCOMBI CARD
    bbcombiCardIssue: function (component, event, helper) {
        this.showSpinner(component);
        var applicationProduct = component.get("v.applicationProduct");
        var oppRecordData = component.get("v.opportunityRecord");
        //var nomCheque = component.get("v.selectedAccountNumber").startsWith("404",0) ? component.get("v.selectedAccountNumber") : '0';
        //var nomSavings = component.get("v.selectedAccountNumber").startsWith("90", 0) ? component.get("v.selectedAccountNumber") : '0';
        var nomCheque = component.get("v.productType") == 'Cheque' ? component.get("v.clientAccNumber") : '0';
        var nomSavings = component.get("v.productType") == 'Savings' ? component.get("v.clientAccNumber") : '0';
        
        console.log('nomCheque: '+ nomCheque);
        console.log('nomSavings : '+ nomSavings);

        //console logs to check the parameters:
        console.log("clntCode : " + component.get("v.clientCIF"));
        console.log("acctNbr :" + component.get("v.clientAccNumber"));
        console.log("prodCode :"+  component.get("v.productCode"));
        console.log("brandNbr : "+ component.get("v.selectedBrandNumber"));
        console.log("sbuCode : " + component.get("v.sbuCode"));
        console.log("secClntCde : "+ component.get("v.selectedRelatedPartyCIF"));
        console.log("persInd : " + applicationProduct.Personalised_Indicator__c);
        console.log("nameInd :" +component.get("v.nameIndicator"));
        console.log("nomCheq :" + nomCheque);
        console.log("nomSavs :" +nomSavings);
        console.log("delvMethod : "+ component.get("v.cardDeliveryMethod"));
        console.log("issueBranch : " + applicationProduct.Card_Delivery_Site_Code__c);
        console.log("Selected Related Party Name: "+ component.get("v.selectedName"));
        
        /*Set the person name */
        var personName;
        if (component.get("v.nameIndicator") == 'F') {         
            personName = applicationProduct.Name__c;
        } else {           
            personName = '';           
        }

        console.log('personName : '+ personName);
        //End of the parameters

        var action = component.get("c.ccIssueCombiCard");

        action.setParams({
            "consumerID": 'ESP', 
            "clientCode": component.get("v.clientCIF"), 
            "accountNumber": component.get("v.clientAccNumber"), 
            "productCode": component.get("v.productCode"), 
            "brandNumber": component.get("v.selectedBrandNumber"), 
            "issueBranch": applicationProduct.Card_Delivery_Site_Code__c, 
            "sbuCode": 'H',//component.get("v.sbuCode"), 
            "secClientCode": component.get("v.selectedRelatedPartyCIF"), 
            "nameIndicator": component.get("v.nameIndicator"), 
            "persName": personName,//applicationProduct.Name__c, 
            "nomCheq": nomCheque, 
            "nomSavs": nomSavings, 
            "deliveryMethod": component.get("v.cardDeliveryMethod"), 
            "persIndicator": applicationProduct.Personalised_Indicator__c
        });
        action.setCallback(this, function (response) {           
            var state = response.getState();
    
            if (state === "SUCCESS") {

                console.log("Raw data from ccIssueBBCombiCard : "+ response.getReturnValue());

                var bbcombiCardResponse = JSON.parse(response.getReturnValue());

                //stringify the response
                console.log(JSON.stringify(response.getReturnValue()));
                if (bbcombiCardResponse.statusCode == 200) {
                    if(bbcombiCardResponse != null && bbcombiCardResponse.CCS868O != null) {
                        if (bbcombiCardResponse.CCS868O.outputCopybook.newCombiNumber != "0") {
                            
                            component.set("v.combiCardNumber", bbcombiCardResponse.CCS868O.outputCopybook.newCombiNumber);
                            component.set("v.deliveryFeeAmount", bbcombiCardResponse.CCS868O.outputCopybook.deliveryFeeAmount);
                            component.set("v.cardFeeAmount", bbcombiCardResponse.CCS868O.outputCopybook.cardFeeAmount);
                            
                            var toast = this.getToast("Success", "Combi Card Number created : " + JSON.stringify(bbcombiCardResponse.CCS868O.outputCopybook.newCombiNumber), "Success");
                            toast.fire();
                            
                            component.find("backButton").set("v.disabled", true);
                            
                        }else{
                            
                            component.set("v.combiCardNumber", bbcombiCardResponse.CCS868O.outputCopybook.newCombiNumber);
                            component.set("v.deliveryFeeAmount", bbcombiCardResponse.CCS868O.outputCopybook.deliveryFeeAmount);
                            component.set("v.cardFeeAmount", bbcombiCardResponse.CCS868O.outputCopybook.cardFeeAmount);
                            
                            var toast = this.getToast("Error", JSON.stringify(bbcombiCardResponse.NBSMSGO3.outputErrorMessage.errorMessageTable[0].errorMessageText) , "error");
                            toast.fire();
                            
                            component.find("submitCardOrdering").set("v.disabled", true);
                        }
                    }

                }else{

                    var toast = this.getToast("Error", "Server Connection Error Code: " + JSON.stringify(bbcombiCardResponse.statusCode) , "error");
                    toast.fire();

                    component.find("submitCardOrdering").set("v.disabled", true);
                }

            }
            else {

                console.log("Failed with state: " + JSON.stringify(response));
                var toast = this.getToast("Error", response , "error");
                toast.fire();
                component.find("submitCardOrdering").set("v.disabled", true);
            }
            this.hideSpinner(component);
        });
        $A.enqueueAction(action);
    },

    //daily limit method
    dailyLimitUpdate :function (component, event, helper){
    this.showSpinner(component);
    var dailylimitInputs = component.get("v.applicationProduct");
    //address details
    var addressUpdate = component.get("v.addressRecord");
    console.log("Address Details : "+ JSON.stringify(addressUpdate));

    if($A.util.isEmpty(addressUpdate.Shipping_Street__c)){
        console.log("ADDRESS HAS NOT BEEN CHANGED!!");
    }else{
        console.log("ADDRESS HAS BEEN CHANGED!!");
    }
    console.log("Address Street : "+ addressUpdate.Shipping_Street__c);
    //Check parameters
    console.log("cardCshLim : " + dailylimitInputs.Card_Cash_Limit__c);
    console.log("cardTrfLim : " + dailylimitInputs.Card_Transfer_Limit__c);
    console.log("cardPosLim : "+ dailylimitInputs.Card_POS_Limit__c);
    console.log("savsCshLim : " + dailylimitInputs.Savings_Cash_Limit__c);
    console.log("savsTrfLim : " + dailylimitInputs.Savings_Transfer_Limit__c);
    console.log("savsPosLim : " + dailylimitInputs.Savings_POS_Limit__c);
    console.log("Combi Card Number : " + component.get("v.combiCardNumber"));
    //End of Parameters

        var action = component.get("c.updateDailyLimits");
        action.setParams({"combiNbr": component.get("v.combiCardNumber"),
                          "cardCshLim": dailylimitInputs.Card_Cash_Limit__c,
                          "cardTrfLim": dailylimitInputs.Card_Transfer_Limit__c,
                          "cardPosLim": dailylimitInputs.Card_POS_Limit__c,
                          "cardCntLim": '0',
                          "cheqNomAcc": '0',
                          "cheqApplNo": '0',
                          "cheqCshLim": '0',
                          "cheqTrfLim": '0',
                          "cheqPosLim": '0',
                          "savsNomAcc": '0',
                          "savsApplNo": '0',
                          "savsCshLim": dailylimitInputs.Savings_Cash_Limit__c,
                          "savsTrfLim": dailylimitInputs.Savings_Transfer_Limit__c,
                          "savsPosLim": dailylimitInputs.Savings_POS_Limit__c});
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {

                console.log("Raw data from dailylimitupdate service : "+ response.getReturnValue());
                var dailyLimitResult = JSON.parse(response.getReturnValue());
                if (dailyLimitResult.message == null) {
                    if(dailyLimitResult.nbsmsgo.nbrUserMsgs != 1 && dailyLimitResult.nbsmsgo.nbrUserErrs != 1){
                        console.log("Successful!!!");

                        var toast = this.getToast("Success", "Application has been successfully Created", "Success");
                        toast.fire();
                        
                    }else{
                        var toast = this.getToast("Error", +  dailyLimitResult.nbsmsgo.msgEntry.msgTxt , "error");
                        toast.fire();

                        console.log("Returned Message : "+ dailyLimitResult.nbsmsgo.msgEntry.msgTxt);
                    }
                    
                } else {
                    console.log("StatusCode: "+ dailyLimitResult.statusCode);
                    console.log("Message : "+ dailyLimitResult.message);

                    var toast = this.getToast("Error", + "Status Code: " +dailyLimitResult.statusCode +" - "+ dailyLimitResult.message, "error");
                    toast.fire();
                }

                //console.log("Daily Limit " + JSON.stringify(dailyLimitResult));
                //component.set("v.relatedParties", dailyLimitResult);
                
            }
            else {
                console.log("Failed with state: " + JSON.stringify(response));
            }
            this.hideSpinner(component);
        });
        $A.enqueueAction(action);
        
    },
    
    //Tdb - Call method to create Mini CIF if no CIF provided
    createMiniCIF : function(component, event, helper) {
        this.showSpinner(component);
        var action = component.get("c.createCIFMiniClient");
        action.setParams({
            "accId": component.get("v.selectedRowId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state == "SUCCESS") {
                var respmsg = response.getReturnValue();
                console.log('respmsg '+JSON.stringify(respmsg));
                if(respmsg.errormsglist!=null){
                    var errormsgs='';
                    var i;
                    for (i in respmsg.errormsglist) {
                        errormsgs += respmsg.errormsglist[i] + ";";
                    }
                    var toast = this.getToast("Error", errormsgs, "error");
                    toast.fire();
                }
                
                if(respmsg.cifoutputerror!=null){
                    var toast = this.getToast("Error", respmsg.cifoutputerror, "error");
                    toast.fire();
                    component.find("applicationFormId").set("v.disabled", true);
                }
                
                if(respmsg.cifoutput!=null){
                    component.set("v.selectedRelatedPartyCIF",respmsg.cifoutput); 
                    var toast = this.getToast("Success", "Mini CIF created : " + component.get("v.selectedRelatedPartyCIF"), "Success");
                    toast.fire();
                }
            } else{
                var toast = this.getToast("Error", "An unknown error occurred. Please Contact System Administrator", "error");
                    toast.fire();

                    component.find("applicationFormId").set("v.disabled", true);
            }
            this.hideSpinner(component);
        });
        $A.enqueueAction(action);
    },
    
     //Function to show spinner when loading
      showSpinner: function(component) {
        component.set("v.showSpinner2",true); 
      },
    
      //Function to hide spinner after loading
      hideSpinner: function(component) {
        component.set("v.showSpinner2",false); 
      },
    
    //Lightning toastie
    getToast : function(title, msg, type) {
		 var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title":title,
                "message":msg,
                "type":type
         });
        return toastEvent;
	},
    //Method to create
    createApplicationProd: function(component, applicationProductUpdate) {
        console.log("Passed Through List Of Records :"+ JSON.stringify(applicationProductUpdate));

        var action = component.get("c.createApplicationProductRecord");
        action.setParams({
            "applcationProductRecord": applicationProductUpdate,
            "opportunityId": component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log("Product Application Has been Created!!");
                console.log(JSON.stringify(response.getReturnValue()));
            }else{
                console.log("Product Application was NOT Created!!");
            }
        });
        $A.enqueueAction(action);
    },
    //W-008562
    getOpportunityRec: function(component, event,helper) {
       
        var action = component.get("c.getOpportunity");
        action.setParams({
            "opportunityId": component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(JSON.stringify(response.getReturnValue()));
                //var OpportunityResp = response.getReturnValue();
                component.set("v.opportunityRecord",response.getReturnValue());
                component.set("v.oppStageName",component.get("v.opportunityRecord.StageName"));
                console.log('########'+component.get("v.opportunityRecord.StageName"));
            }else{
                console.log("System error please contact administrator!!");
            }
        });
        $A.enqueueAction(action);
    },
    
})