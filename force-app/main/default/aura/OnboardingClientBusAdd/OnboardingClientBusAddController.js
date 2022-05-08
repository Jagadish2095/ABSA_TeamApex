({
     init: function (component, event, helper) {
         var actions = [
             { label: 'Edit Address', name: 'edit_address' }
         ];
         component.set('v.columns', [
             {label: 'Street', fieldName: 'Shipping_Street__c', type: 'text' ,editable: false},
             {label: 'Street 2', fieldName: 'Shipping_Street_2__c', type: 'text' ,editable: false},
             {label: 'Suburb', fieldName: 'Shipping_Suburb__c', type: 'text' ,editable: false},
             {label: 'City', fieldName: 'Shipping_City__c', type: 'text' ,editable: false},
           //{label: 'State/Province', fieldName: 'Shipping_State_Province__c', type: 'text' ,editable: false},//W-006583
             {label: 'Country', fieldName: 'Shipping_Country__c', type: 'text' ,editable: false},
             {label: 'Zip Postal code', fieldName: 'Shipping_Zip_Postal_Code__c', type: 'text' ,editable: false},
             {label: 'Address Type', fieldName: 'Address_Type__c', type: 'text' ,editable: false},
             { type: 'action', typeAttributes: { rowActions: actions }}

              ]);

        helper.getAddresses(component,event, helper);
        helper.getAccountDetails(component,event, helper,'Yes');
    },

    doAction : function(component, event, helper) {
        // PJAIN: 20200530: Minor logic change
        var methodArguments = event.getParam('arguments');

        if (methodArguments) {
            var accRecId = methodArguments.accId; //params
            component.set("v.accRecId", accRecId);
            helper.getAddresses(component, event, helper);
            helper.fetchProcessType(component,event, helper);
        }
    },

    setClientType : function(component, event, helper) {
         var methodParam = event.getParam('arguments');
         var clientTypeChangedVal;

        if(methodParam) {
            clientTypeChangedVal = methodParam.clientTypeVal;//params

            //alert('setClientType : ' + clientTypeChangedVal);

            component.set("v.accountClientType",clientTypeChangedVal); 
        	component.set("v.addressRecord.Client_Entity_Type__c",clientTypeChangedVal);  
        }
    },
    setProcessType : function(component, event, helper) {
        var methodParam = event.getParam('arguments');
        var processTypeChangedVal;
        if(methodParam) {
            processTypeChangedVal = methodParam.processTypeVal;//params
            //alert('setClientType : ' + clientTypeChangedVal);
            //component.set("v.accountClientType",clientTypeChangedVal);
            component.set("v.addressRecord.Client_Entity_Type__c",processTypeChangedVal);
        }
    },

    handleSave : function(component, event, helper) {
        helper.handleSaveEdition(component, event, helper);
    },

    createAddressRecord : function (component, event, helper) {
        component.set("v.addressRecord.Account__c", component.get("v.accRecId"));
       /* var addressTypeVal = component.get("v.addressRecord.Address_Type__c");
        if(!addressTypeVal) {
            var toast = helper.getToast('Required field', 'Address Type is required', 'error');
            toast.fire();
            return null;
        }*/
         var addressRec = component.get("v.addressRecord");
        var flag = false;
        var process = component.get("v.processType");
        if(process != 'Lite Onboarding'){
        var selectedAddressType = component.find("addressType").get("v.value");
        }
        //addressRec.Shipping_Country__c != '' && addressRec.Shipping_Country__c != undefined && addressRec.Shipping_Country__c != null &&
        if(addressRec.Address_Type__c != '' && addressRec.Address_Type__c != undefined && addressRec.Address_Type__c != null &&
          addressRec.Shipping_Street__c != '' && addressRec.Shipping_Street__c != undefined && addressRec.Shipping_Street__c != null &&
          addressRec.Shipping_Suburb__c != '' && addressRec.Shipping_Suburb__c != undefined && addressRec.Shipping_Suburb__c != null &&
          addressRec.Shipping_City__c != '' && addressRec.Shipping_City__c != undefined && addressRec.Shipping_City__c != null &&
          addressRec.Shipping_Zip_Postal_Code__c != '' && addressRec.Shipping_Zip_Postal_Code__c != undefined && addressRec.Shipping_Zip_Postal_Code__c != null
          ){
            flag = true;
        }
           if(!flag){
            var toast = helper.getToast('Required field', 'Please fill all required fields.', 'error');
            toast.fire();
            return null;
        }
		 var newAddressRecord = component.get("v.addressRecord");
        //Calling the Apex Function to create Contact
        var createAddressAction = component.get("c.createNewAddress");
        //Setting the Apex Parameter
        createAddressAction.setParams({
          	newAddressRecord: newAddressRecord,
            addressTypes : selectedAddressType
        });

        //Setting the Callback
        createAddressAction.setCallback(this, function(response) {
          var stateCase = response.getState();
          if (stateCase === "SUCCESS") {
           		var addressList = response.getReturnValue();
                component.set("v.addList",addressList);

               component.set("v.showNewAddressModal", false);
              var toastEvent = helper.getToast("Success!", 'Address successfully created', "Success");
            toastEvent.fire();

          } else if (stateCase === "ERROR") {
            var message = "";
            var errors = response.getError();
            if (errors) {
              for (var i = 0; i < errors.length; i++) {
                for (
                  var j = 0;
                  errors[i].pageErrors && j < errors[i].pageErrors.length;
                  j++
                ) {
                  message +=
                    (message.length > 0 ? "\n" : "") +
                    errors[i].pageErrors[j].message;
                }
                if (errors[i].fieldErrors) {
                  for (var fieldError in errors[i].fieldErrors) {
                    var thisFieldError = errors[i].fieldErrors[fieldError];
                    for (var j = 0; j < thisFieldError.length; j++) {
                      message +=
                        (message.length > 0 ? "\n" : "") +
                        thisFieldError[j].message;
                    }
                  }
                }
                if (errors[i].message) {
                  message += (message.length > 0 ? "\n" : "") + errors[i].message;
                }
              }
            } else {
              message += (message.length > 0 ? "\n" : "") + "Unknown error";
            }

            // show Error message
            var toastEvent = helper.getToast("Error!", message, "Error");
            toastEvent.fire();

            //helper.hideSpinner(component);
          }
        });

        //adds the server-side action to the queue
        $A.enqueueAction(createAddressAction);
	},

    openNewAddressModal : function(component, event, helper) {
        component.set("v.addressRecord");
        //component.set("v.showNewAddressModal", true);
            console.log('accRecId : ' +  component.get("v.accRecId"));
        helper.getAccountDetails(component,event, helper,'No');
    },

    closeNewAddressModal : function(component, event, helper) {
        component.set("v.showNewAddressModal", false);
    },

    // PJAIN: 20200530: Added method to set attribute whenever the selection changes
    handleRowSelectionChange : function(component, event, helper) {
        var selectedRows = event.getParam('selectedRows');
        component.set('v.selectedRows', selectedRows);
    },
    handleRowAction: function (component, event, helper) {
        var action = event.getParam('action');
        switch (action.name) {
            case 'edit_address':
                var row = event.getParam('row');
                /*var editRecordEvent = $A.get("e.force:editRecord");
                editRecordEvent.setParams({
                    "recordId": row.Id
                });
                editRecordEvent.fire();  */
                component.set("v.addressEditRecId",row.Id);
                component.set("v.showEditAddressModal",true);

            	break;

        }
    },
    refreshAddresses : function (component, event, helper) {
        helper.getAddresses(component,event, helper);
    },
    editAddressRecord: function (component, event, helper) {
        var clientType = component.find("clientType").get("v.value");
        var addType = component.find("addType").get("v.value");
        var shippingStreet = component.find("shippingStreet").get("v.value");
        var shippingSuburb = component.find("shippingSuburb").get("v.value");
        var shippingCity = component.find("shippingCity").get("v.value");
      //var shippingState = component.find("shippingState").get("v.value");//W-006583
        var shippingCountry = component.find("shippingCountry").get("v.value");
        var postalCode = component.find("postalCode").get("v.value");

        var flag = false;
        if(clientType != null && clientType != undefined && clientType !='' &&
          addType != null && addType != undefined && addType !='' &&
          shippingStreet != null && shippingStreet != undefined && shippingStreet !='' &&
          shippingSuburb != null && shippingSuburb != undefined && shippingSuburb !='' &&
          shippingCity != null && shippingCity != undefined && shippingCity !='' &&
        //shippingState != null && shippingState != undefined && shippingState !='' && //W-006583
          shippingCountry != null && shippingCountry != undefined && shippingCountry !='' &&
          postalCode != null && postalCode != undefined && postalCode !=''){
            flag = true;
        }
        if(!flag){
            var toast = helper.getToast('Required field', 'Please fill all required fields.', 'error');
            toast.fire();
            return null;
        }
        var editForm = component.find("editAddressForm");
        editForm.submit();
    },
    closeEditAddressModal: function (component, event, helper) {
         component.set("v.showEditAddressModal",false);
    },
    handleOnSuccess: function (component, event, helper) {
        component.set("v.showEditAddressModal",false);
        var toastEvent = helper.getToast("Success!", 'Address successfully updated', "Success");
        toastEvent.fire();
    },
    handleOnLoad: function (component, event, helper) {
        let entityTypeValue = component.get('v.addressRecord.Client_Entity_Type__c');
        //helper.getAddressTypes(component, event,entityTypeValue);
        console.log('entityTypeValue>>'+entityTypeValue);
        var process = component.get("v.processType");
         if(process =='Lite Onboarding'){
             component.set('v.addressTypeList', [
                 {'label': 'Business Address', 'value': 'Business Address'}
             ]);
         }
        else{
        if(entityTypeValue=='Private Company' || entityTypeValue=='Close Corporation'|| entityTypeValue=='Trusts' || entityTypeValue=='Public Listed Company'|| 
           entityTypeValue=='Foreign Listed Company'|| entityTypeValue=='Non Profit Organizations (NGO)' || entityTypeValue == 'Non Profit Organizations (NGO\'s)' 
           || entityTypeValue=='Non Profit Companies' || entityTypeValue == 'Co-operative' || entityTypeValue == 'Incorporated Company' || entityTypeValue == 'Foreign Company'
          || entityTypeValue == 'Clubs/Societies/Associations/Other Informal Bodies' || entityTypeValue == 'Organs of State and Institutions of Higher Learning'){

            component.set('v.addressTypeList', [
                {'label': 'Postal Address', 'value': 'Postal'},
                {'label': 'Head Office Address', 'value': 'Head Office'},
                {'label': 'Registered Address', 'value': 'Registered'},
                {'label': 'Business Address', 'value': 'Business Address'}

            ]);
        } else if(entityTypeValue=='Sole Trader' || entityTypeValue=='Private Individual'){
            component.set('v.addressTypeList', [
                {'label': 'Postal Address', 'value': 'Postal'},
                {'label': 'Physical Address', 'value': 'Physical Address'},
                {'label': 'Business Address', 'value': 'Business Address'}
            ]);
        } else if(entityTypeValue=='Individual'){
            component.set('v.addressTypeList', [
                {'label': 'Employers', 'value': 'Employers'},
                {'label': 'Physical Address', 'value': 'Physical Address'},
                {'label': 'Postal', 'value': 'Postal'},
                {'label': 'Residential', 'value': 'Residential'},
            ]);
                }
                }

        var isFromEditRelatedParty  = component.get("v.isFromEditRelatedParty");
        var isFromNonIndividualRelatedParty = component.get("v.isFromNonIndividualRelatedParty");
        //alert(isFromNonIndividualRelatedParty);
        if(isFromEditRelatedParty){
            if(component.find("clientTypeNew") != undefined){
                component.find("clientTypeNew").set("v.value",'Individual Related Party');
                }
                if(component.find("clientType") != undefined){ 
                component.find("clientType").set("v.value",'Individual Related Party');
                }
                }else{
                if(component.find("clientTypeNew") != undefined){
                var clientTypeReturned = component.get("v.accountClientType"); 
                component.find("clientTypeNew").set("v.value",clientTypeReturned);
                }
                if(component.find("clientTypeNew") != undefined){
                if(process =='Lite Onboarding'){
                component.find("clientTypeNew").set("v.value",'Non Individual');
                }
                }
                }
                if(isFromNonIndividualRelatedParty){
                    //alert(component.get("v.accountClientType"));
                    var ReturnclientType = component.get("v.accountClientType");
                    if(ReturnclientType == 'Trusts' || ReturnclientType =='Foreign Trust'){
                        var addressRecord = component.get("v.addressRecord");
                        addressRecord.Client_Entity_Type__c = 'Trusts Related Party';
                        component.set("v.addressRecord",addressRecord);
                    }
                    /*if(ReturnclientType == 'Private Company'){
                    var addressRecord = component.get("v.addressRecord");
                    addressRecord.Client_Entity_Type__c = 'Private Related Party';
                    component.set("v.addressRecord",addressRecord);
                    }*/
                    if(ReturnclientType == 'Foreign Listed Companies' || ReturnclientType == 'Foreign Companies' || ReturnclientType == 'Funds'  || ReturnclientType =='Clubs/Societies/Associations/Other Informal Bodies'||
                    ReturnclientType == 'Co-operative' || ReturnclientType == 'Public Listed Company' || ReturnclientType == 'Private Company' ||
                ReturnclientType == 'Close Corporation' || ReturnclientType == 'Non Profit Companies' || ReturnclientType == 'Non Profit Organizations (NGO)'){
                        var addressRecord = component.get("v.addressRecord");
                console.log('addressRecord : ' + addressRecord);
                        addressRecord.Client_Entity_Type__c = 'Non-Individual Related Party';
                        component.set("v.addressRecord",addressRecord);
                    }

                entityTypeValue = component.get('v.addressRecord.Client_Entity_Type__c');
                }

                helper.getAddressTypes(component, event,entityTypeValue);
                },
     handleAddTypeChange: function (component, event, helper) {
        var selectedval = event.getSource().get("v.value");
        var allTypeList = component.get("v.allTypeList");
        var sortedList = [];
        for(var i in allTypeList){
            if(allTypeList[i].value != selectedval){
                sortedList.push(allTypeList[i]);
            }
        }
        component.set("v.addressTypeList",sortedList);

    },
    handleClientTypeChange: function (component, event, helper) {
        var selectedval = event.getSource().get("v.value");
        helper.getAddressTypes(component, event, selectedval);
    }
})