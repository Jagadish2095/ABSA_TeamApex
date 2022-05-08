({
    doInit: function (component, event, helper) {

        var designationOptions = [{ value: 'ACCOUNTANT', label: 'ACCOUNTANT' }, { value: 'ADMINISTRATOR', label: 'ADMINISTRATOR' },
        { value: 'CHAIRMAN', label: 'CHAIRMAN' }, { value: 'CURATOR', label: 'CURATOR' },
        { value: 'DIRECTOR', label: 'DIRECTOR' }, { value: 'LIQUIDATOR', label: 'LIQUIDATOR' },
        { value: 'MANAGER', label: 'MANAGER' }, { value: 'MEMBER', label: 'MEMBER' },
        { value: 'PARTNER', label: 'PARTNER' }, { value: 'PRESIDENT', label: 'PRESIDENT' },
        { value: 'PRINCIPAL', label: 'PRINCIPAL' }, { value: 'SECRETARY', label: 'SECRETARY' },
        { value: 'TOWN CLERK', label: 'TOWN CLERK' }, { value: 'TREASURER', label: 'TREASURER' },
        { value: 'TRUSTEE', label: 'TRUSTEE' }, { value: 'SIGNATORY', label: 'SIGNATORY' },
        { value: 'PARENT', label: 'PARENT' }, { value: 'GUARDIAN', label: 'GUARDIAN' },
        { value: 'OWNER', label: 'OWNER' }, { value: 'SHAREHOLDER', label: 'SHAREHOLDER' },
        ];
        component.set('v.existingAddresscolumns', [
            { label: 'Address Type', fieldName: 'Address_Type__c', type: 'text' },
            { label: 'Street', fieldName: 'Shipping_Street__c', type: 'text' },
            { label: 'Suburb', fieldName: 'Shipping_Suburb__c', type: 'Text' },
            { label: 'Postal Code', fieldName: 'Shipping_Zip_Postal_Code__c', type: 'Text' },
            { label: 'City', fieldName: 'Shipping_City__c', type: 'Text' },
            { label: 'Province', fieldName: 'Shipping_State_Province__c', type: 'Text' },
            { label: 'Country', fieldName: 'Shipping_Country__c', type: 'Text' }]);

        component.set("v.DesignationOptions", designationOptions);
        var actions = [
            { label: 'Edit', name: 'Edit' },
            { label: 'Delete', name: 'Delete' }];
        component.set('v.columns', [
            { label: 'First Name and Surname', fieldName: 'FName', type: 'text' },
            { label: 'Action Required', fieldName: 'ActionRequired', type: 'text', wrapText: true },
            { label: 'Credit Limit', fieldName: 'CreditLimit', type: 'text', wrapText: true },
            { type: "action", typeAttributes: { rowActions: actions } }
        ]);

        var opportunityId = component.get("v.recordId");
        var applicationprodId = component.get("v.appProductId");
        var action = component.get("c.getRelatedParties");
        action.setParams({
            "oppId": opportunityId,
            "appProductId": applicationprodId
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var plValues = [];
                var plValues2 = [];
                for (var i = 0; i < result.length; i++) {
                    if (result[i].AuthUserId != null) {
                        plValues.push(result[i]);
                        console.log('gggggg' + result[i].AppProductId);
                    }
                    else {
                        plValues2.push(result[i]);
                        console.log('gggggg' + result[i].AppProductId);
                    }
                }
                if (plValues.length > 0) {
                    component.set("v.AssignedUsersTableList", plValues);
                    component.set("v.showAfterConfirmUsers", true);
                }

                component.set("v.RelatedPartiesList", plValues2);

            }
            else {
                helper.showError(response, "getRelatedParties");
            }
        });

        $A.enqueueAction(action);
    },
    handleRelatedPartiesChange: function (component, event, helper) {

        var selectedValues = event.getParam("value");

        component.set("v.selectedRelatedPartiesList", selectedValues);
    },
    confirmUsers: function (component, event, helper) {
        var result = component.get("v.selectedRelatedPartiesList");
        var allList = component.get("v.RelatedPartiesList");
        if (component.get("v.AssignedUsersTableList") == null) {
            var plValues = [];
        }
        else {
            var plValues = component.get("v.AssignedUsersTableList");
        }
        var Idvar = '';
        for (var i = 0; i < result.length; i++) {
            Idvar = result[i];
            for (var j = 0; j < allList.length; j++) {
                if (allList[j].value == Idvar) {
                    /*plValues.push({Ids:allList[i].Ids,
                                   FName:allList[i].FName,ActionRequired:allList[i].ActionRequired,
                                   Passport:allList[i].Passport,NameCard:allList[i].NameCard,
                                   CASA:allList[i].CASA,CreditLimit:allList[i].CreditLimit,
                                   FacilityRequired:allList[i].FacilityRequired,
                                   ClientCode:allList[i].ClientCode,
                                   AccountId:allList[i].AccountId,BranchName:allList[i].BranchName,
                                   Address:allList[i].Address}); */
                    plValues.push(allList[j]);
                }

            }

        }
        component.set("v.AssignedUsersTableList", plValues);
        component.set("v.showAfterConfirmUsers", true);

    },
    handleRowAction: function (component, event, helper) {

        var action = event.getParam('action');
        var row = event.getParam('row');
        var recId = row.Id;

        switch (action.name) {
            case 'Edit':
                if (row.DeliveryMethodValue != null && row.DeliveryMethodValue != 'To another address') {
                    var selectedrec = {
                        Ids: row.Ids, AppproductId: row.AppproductId, FName: row.FName,
                        ClientCode: row.ClientCode, CASA: row.CASA, AuthUserId: row.AuthUserId,
                        Passport: row.Passport, NameCard: row.NameCard,
                        ActionRequired: row.ActionRequired, CreditLimit: row.CreditLimit,
                        FacilityRequired: row.FacilityRequired,
                        AccountId: row.AccountId, BranchName: row.BranchName,
                        Address: row.Address, ClientType: row.ClientType,
                        CardType: row.CardType, AircraftRegNo: row.AircraftRegNo,
                        Designation: row.Designation, DeliveryMethodValue: row.DeliveryMethodValue
                    };
                }
                else {
                    var selectedrec = {
                        Ids: row.Ids, FName: row.FName, AppproductId: row.AppproductId,
                        ClientCode: row.ClientCode, CASA: row.CASA, AuthUserId: row.AuthUserId,
                        Passport: row.Passport, NameCard: row.NameCard,
                        ActionRequired: row.ActionRequired,
                        FacilityRequired: row.FacilityRequired,
                        AccountId: row.AccountId, BranchName: row.BranchName,
                        Address: row.Address, ClientType: row.ClientType, CreditLimit: row.CreditLimit,
                        CardType: row.CardType, AircraftRegNo: row.AircraftRegNo,
                        Designation: row.Designation, DeliveryMethodValue: row.DeliveryMethodValue,
                        DeliveryAddressLine1: row.DeliveryAddressLine1, DeliveryAddressLine2: row.DeliveryAddressLine2,
                        DeliveryAddressSuburb: row.DeliveryAddressSuburb, DeliveryAddressTown: row.DeliveryAddressTown,
                        DeliveryAddressPostalCode: row.DeliveryAddressPostalCode,
                        DeliveryAddressCountry: row.DeliveryAddressCountry
                    };
                }
                var oppRecord = component.get("v.oppRecord");
                component.set("v.CurrentRecordToEdit", selectedrec);
                helper.getAddresses(component, event, helper, row.AccountId, null);
                helper.getAddresses(component, event, helper, oppRecord.AccountId, 'Client');
                component.set("v.showAfterEditUsers", true);

                break;
            case 'Delete':
                var selectedrec = { Ids: row.Ids, AuthUserId: row.AuthUserId };
                component.set("v.CurrentRecordToDelete", selectedrec);
                component.set("v.isModalOpen", true);
                break;
        }
    },
    ChangeFacility: function (component, event, helper) {
        var facilityval = component.find("FacilityReq").get("v.value");
        component.set("v.showCreditLimit", true);
        if (facilityval == 'Aviation') {
            component.set("v.CreditLimitLabel", "Credit limit required for Aviation");
        }
        else if (facilityval == 'Business and Garage Card') {
            component.set("v.CreditLimitLabel", "Credit limit required for Business and Garage Card");
        }
        else if (facilityval == 'Business Card Only') {
            component.set("v.CreditLimitLabel", "Credit limit required for Business Card");
        }
        else if (facilityval == 'Garage Card Only') {
            component.set("v.CreditLimitLabel", "Credit limit required for Garage card");
        }
        else {
            component.set("v.showCreditLimit", false);
        }
    },
    handleDeliveryMethodChange: function (component, event, helper) {

        var selectedValues = event.getParam("value");

        var currec = component.get("v.CurrentRecordToEdit");
        currec.DeliveryMethodValue = selectedValues;
        component.set("v.CurrentRecordToEdit", currec);
        console.log('selectedValues' + selectedValues);
    },
    UpdateSelectedRows: function (component, event, helper) {
        var selectedRows = event.getParam("selectedRows");
        var selectedValue = selectedRows[0].Id;
        console.log('selectedValueU' + selectedValue);

        var currec = component.get("v.CurrentRecordToEdit");
        currec.Address = selectedValue;
        component.set("v.CurrentRecordToEdit", currec);

    },
    saveAU: function (component, event, helper) {
        var currec = component.get("v.CurrentRecordToEdit");
        if (currec.DeliveryMethodValue == 'Branch' && component.get("v.selectedSiteRecord") != null) {
            currec.BranchName = component.get("v.selectedSiteRecord").Name;
            component.set("v.CurrentRecordToEdit", currec);
        }

        console.log('AppProductId' + JSON.stringify(currec));
        var opportunityId = component.get("v.recordId");
        var action = component.get("c.saveAuthorizedUsers");
        action.setParams({
            "wrapRec": currec,
            "oppId": opportunityId
        });
        action.setCallback(this, function (res) {
            var state = res.getState();
            if (state === "SUCCESS") {

                // component.set("v.addressList",res.getReturnValue());  

                var recordtoupdate = component.get("v.CurrentRecordToEdit");
                recordtoupdate.AuthUserId = res.getReturnValue();
                component.set("v.CurrentRecordToEdit", recordtoupdate);
                var toastEvent = helper.getToast('Success' + '!', 'Authorized Users Updated Successfully', 'success');
                toastEvent.fire();
                console.log('<<<success>>' + res.getReturnValue());
            } else if (state === "ERROR") {
                var errors = res.getError();
                console.log('Callback to save Failed. Error : [' + JSON.stringify(errors) + ']');
            } else {
                console.log('Callback to save Failed.');
            }
        });
        $A.enqueueAction(action);
    },
    closeModal: function (component, event, helper) {

        component.set("v.isModalOpen", false);
    },
    OpenModal: function (component, event, helper) {

        component.set("v.isModalOpen", true);
    },
    deleterecord: function (component, event, helper) {
        var currec = component.get("v.CurrentRecordToDelete");
        var tablelist = component.get("v.AssignedUsersTableList");
        var list1 = [];
        if (currec.AuthUserId != null) {
            var toastEvent = helper.getToast('Error' + '!', 'To remove an existing user, use the Action field', 'error');
            toastEvent.fire();
            component.set("v.isModalOpen", false);
        }
        else {
            for (var p = 0; p < tablelist.length; p++) {
                if (tablelist[p].Ids != currec.Ids) {
                    list1.push(tablelist[p]);
                }
            }
            component.set("v.AssignedUsersTableList", list1);
            component.set("v.isModalOpen", false);
            var toastEvent = helper.getToast('Success' + '!', 'Removed from the list', 'success');
            toastEvent.fire();
            component.set("v.isModalOpen", false);
        }
    }
})