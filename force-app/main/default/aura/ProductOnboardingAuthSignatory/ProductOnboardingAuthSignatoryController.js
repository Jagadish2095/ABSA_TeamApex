({
    initialize : function(component, event, helper) {

        //Setting the DataTable Headers
        component.set('v.mycolumns', [
            {label: 'Select Signatory', fieldName: 'Name', type: 'Text', wrapText: true, initialWidth: 300},
            {label: 'Operational Role', fieldName: 'Roles', type: 'text', wrapText: true}]);

         component.set('v.existingSignatoryHeader', [
            {label: 'Product Name', editable : 'true',fieldName: 'Product_Name__c', type: 'text'},
            {label: 'Signatory Name',editable : 'true', fieldName: 'Name', type: 'Text'}]);
        helper.loadparentAccountRecord(component, event, helper);
       // helper.fetchApplicationProductMerchantId(component, event, helper);
        helper.fetchAccountContactRelation(component, event, helper);
        helper.loadOppProductRecords(component, event, helper);
        //helper.loadExistingProductSignatoryRecords(component, event, helper);
    },

    onload : function(component, event, helper){
        $A.util.addClass(component.find("spinner"), "slds-hide");
        var val = component.find('authorisedSignatory').get('v.value');
        component.set("v.selectedRows", val);
    },

    handleSuccess : function(component, event, helper){
        //hide spinner
        $A.enqueueAction(component.get('c.onload'));
        // Show toast
        helper.fireToast("Success!", "Authorised signatory have been updated successfully.", "success");
        helper.loadExistingProductSignatoryRecords(component, event, helper); //Load Existing Signatory
        component.set('v.isButtonActive',true);
    },

    UpdateSelectedRows: function (component, event, helper) {
        component.set('v.isButtonActive',false);
        var selectedRows = event.getParam("selectedRows");
        var selectedValue = selectedRows[0].Id;
        component.set("v.isDelButtonActive",false);
        component.set("v.recIdToDel",selectedValue);
        var selectedSignatory = selectedRows[0].Name;
        var emailMap = component.get("v.emailMap");
        var mobileMap = component.get("v.mobileMap");
        console.log('the list is selectedValue a butted ' + selectedValue + ' keys ' + emailMap.keys());
        console.log('Selected person is :'+selectedSignatory);
        component.set('v.selectedSignatoryName',selectedSignatory);
        component.set('v.selectedRecordRelationshipId',selectedValue);
        var existingSignatorylist = component.get("v.existingSignatorylist");
        if (!$A.util.isUndefinedOrNull(existingSignatorylist) && existingSignatorylist.length > 0) {
        console.log("existingSignatorylist"+JSON.stringify(existingSignatorylist));
        console.log(existingSignatorylist[0].Name.includes(selectedSignatory));
        debugger;
        console.log("Existing Signatory "+existingSignatorylist[0].Name);
        console.log('Nominated Signatory :'+selectedSignatory);
        var i;
          for (i = 0; i < existingSignatorylist.length; i++) {
              console.log("selected Signatory item "+i+" : " +existingSignatorylist[i].Name);
              if(existingSignatorylist[i].Name.includes(selectedSignatory)){
                  console.log("Nominated Signatory 1:" + selectedSignatory+" Existing Signatory 1 : "+ existingSignatorylist[i].Name);
                  alert(selectedSignatory+" has  been captured already , Please Choose another one");
                  component.set('v.isButtonActive',true);
                  // var toastEvent = helper.getToast("Error", "You cannot add Existing Signatory Again", "error");
              //toastEvent.fire();
             }
           }
          }
        if (emailMap.get(selectedValue) != null && emailMap.get(selectedValue) != ""
           && mobileMap.get(selectedValue) != null && mobileMap.get(selectedValue) != "") {
           //component.set('v.isButtonActive',false);
            if (selectedValue != component.find('authorisedSignatory').get('v.value')) {
                //component.find('authorisedSignatory').set('v.value', selectedValue);
                component.set('v.selectedSignatoryName',selectedSignatory);
                component.set('v.selectedRecordRelationshipId',selectedValue);
            }
        } else {
            //component.set('v.isButtonActive',false);//testing false
        }

    },

    UpdateSelectedRowsExist : function (component, event, helper) {
        var selectedRows = event.getParam("selectedRows");
        if (selectedRows != '') {
            var selectedValue = selectedRows[0].Id;
            component.set("v.isDelButtonActive",false);
            component.set("v.recIdToDel",selectedValue);
        }
    },
    handleOnSubmit: function (component, event, helper) {
        event.preventDefault();// to avoid standard lds submission event

        var optionsMap  = component.get("v.opportunityProductMap")
        var productslist = component.get("v.nameOfProductsAdded");
        var selectedproduct = component.find("iproductID") != undefined ? component.find("iproductID").get("v.value") : undefined;
        if(!selectedproduct){ selectedproduct = productslist[0] }

        console.log('selectedproduct 67 :'+selectedproduct);
        console.log('Oli map value  :'+optionsMap[selectedproduct].Id);
        console.log('Account Value :'+ component.get("v.parentAccountRecord").Id);

        var fields = event.getParam("fields");
        fields["Product_Name__c"] = selectedproduct;
        fields["PrimaryAccountId__c"] = component.get("v.parentAccountRecord").Id;
        fields["Name"] = component.get("v.selectedSignatoryName");
        fields["AccountContactRelationshipId__c"] = component.get("v.selectedRecordRelationshipId");
        fields["OpportunityProductId__c"] = optionsMap[selectedproduct].Id;
        if (component.get("v.productOnboardingROA") == true) {
			fields["PrimaryAccountId__c"] = component.get("v.recordId");
		}
        component.find("authorisedSignatoriesForm").submit(fields);

    },

    selectProductforSignatory: function (component, event, helper) {
        console.log('product Value is :'+component.get("v.nameOfProductsAdded")[0]);
        console.log('Account Value :'+ component.get("v.parentAccountRecord").Id);
    },

    deleteRecords: function (component, event, helper) {
        var action = component.get("c.deleteProdConSigRel");
        action.setParams({
            "recId": component.get("v.recIdToDel")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var responseValue = response.getReturnValue();
                component.set("v.isDelButtonActive",false);
                helper.loadExistingProductSignatoryRecords(component, event, helper);
            } else if(state === "ERROR"){
                var errors = response.getError();
                console.log('Callback to deleteProdConSigRel Failed. Error : [' + JSON.stringify(errors) + ']');
                component.set('v.isButtonActive',true);
            } else {
                console.log('Callback to deleteProdConSigRel Failed.');
            }
        });
        $A.enqueueAction(action);
    }
})