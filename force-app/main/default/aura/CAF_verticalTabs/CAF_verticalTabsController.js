({
    doInit: function (component, event, helper) {
        var pageRecordId = component.get("v.recordId");
        if(pageRecordId.startsWith('006')){
        component.set("v.isNotCase", true);}
        helper.helperToggleClass(component, event, helper);
        helper.fetchApplications(component, event, helper);
        helper.fetchAccAndOpp(component, event, helper);
      //  if(!pageRecordId.startsWith('006')){
       //     helper.updateApplicationsTable(component, event, helper);}
            
    },
    isRefreshed: function(component, event, helper) {
        //helper.fetchApplications(component, event, helper);
    },
    newApplication: function (component, event, helper) {
        var sanctioningStatus = component.get("v.opportunityRecord2.CAF_Sanctioning_Status__c");
        console.log("sanctioningStatus 2 " + sanctioningStatus);

        if (sanctioningStatus == "Submitted" || sanctioningStatus == "Allocated To Sanctioner") {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                type: "error",
                title: "Error!",
                message: "This opportunity is currently awaiting sanctioning, please wait for the decision before making changes."
            });
            toastEvent.fire();
        } else {
            component.set("v.showSpinner", true);
            var oppId = component.get("v.recordId");
            var action = component.get("c.createNewApplication");
            action.setParams({
                oppId: oppId
            });
            action.setCallback(this, function (response) {
                var state = response.getState();

                if (state === "SUCCESS") {
                    $A.get("e.force:refreshView").fire();
                    var results = response.getReturnValue();
                    helper.successMsg(component, results);

                    console.log("results in origination---", results);
                    component.set("v.showSpinner", false);
                    component.set("v.showAppList", true);
                    helper.fetchApplications(component, event, helper);
                } else {
                    console.log("Failed with state in orignation vertical: " + JSON.stringify(response));
                }
            });

            $A.enqueueAction(action);
        }
    },
    /*trying to init the cmp on Attest popup for Lazy loading
     Handler for applicationEvent */
    handleApplicationEvent: function (component, event, helper) {
        var sourceComponent = event.getParam("sourceComponent");
        var opportunityId = event.getParam("opportunityId");
        console.log("within the application event handler raised from " + sourceComponent);
        // Condition to not handle self raised event
        if ((sourceComponent == "CobAttestationPopup" || sourceComponent == "NonScoredApprovedFacilities") && opportunityId != null && opportunityId != "") {
            //calling Init on App Event
            var a = component.get("c.doInit");
            $A.enqueueAction(a);
        }
    },

    toggleClass: function (component, event, helper) {
        helper.hideChildCmp(component, event); // Hide all components and show only selected child component
        var selectedvalue = component.get("v.selectedItem");
        console.log("value is" + selectedvalue);
        if (selectedvalue == "TabOne") {
            var divChild = component.find("div1");
            $A.util.removeClass(divChild, "slds-hide");
        } else if (selectedvalue == "creditCard") {
            var divChild = component.find("creditCard");
            $A.util.removeClass(divChild, "slds-hide");
        } else {
            //  block of code to be executed if the condition1 is false and condition2 is false
        }
    },
    handleOnSubmitFromChild: function (component, event, helper) {
        component.set("v.showSpinner", true);
        component.find("apcRecordForm").submit();
    },
    handleOnSubmit: function (component, event, helper) {
        console.log("In Submit");
        component.set("v.showSpinner", true);
    },
    handleOnload: function (component, event, helper) {
        var fields = event.getParams("recordUi").recordUi.record.fields;
        console.log('fields 93 '+JSON.stringify(fields));
        component.set("v.fieldsData", fields);
        component.set("v.salesBranch",fields.Sales_branch__c.value);
        component.set("v.agreeTermsAndConditions",fields.Agree_Term_and_Condition__c.value);
    },
    handleSuccess: function (component, event, helper) {
        console.log("In Success");
        var appId = component.get("v.appId");
        helper.updateApplicationsTable(component, event, helper);
        helper.fetchApplicationToView(component, event, helper, appId);
        //helper.move2NextOppStage(component, event, helper, "Sanctioning");
        component.set("v.showSpinner", false);
        helper.successMsg(component, "Application saved successfully");
        var salesBranch = component.get("v.salesBranch");
        if(salesBranch != undefined && salesBranch != null && salesBranch != ''){
            component.set("v.isCreateBtnDisabled",false);
        }
    },
    handleRowAction: function (cmp, event, helper, recId) {
        var action = event.getParam("action");
        var row = event.getParam("row");
        var recId = row.Id; //'00k3N000006lsaxQAA';

        switch (action.name) {
            case "edit":
                helper.editApplication(cmp, event, helper, recId);
                var contractExtras = cmp.find("IdContractExtras");
                contractExtras.callChildExtras(recId);

                var valueAddedProducts = cmp.find("IdValueAddedProducts");
                valueAddedProducts.callChildVaps(recId);
                //cmp.set("v.openNewExtraBlockValue","Yes");
				cmp.set("v.salesBranch",'');
                cmp.set("v.isCreateBtnDisabled",true);
                cmp.set("v.sectionRefresher",false);
                cmp.set("v.sectionRefresher",true);
                break;
            case "duplicate":
                cmp.set("v.isOpen", true);
                break;
            case "delete":
                break;
        }
    },
    openClonePriorAppModel: function (component, event, helper) {
        var sanctioningStatus = component.get("v.opportunityRecord2.CAF_Sanctioning_Status__c");
        console.log("sanctioningStatus 2 " + sanctioningStatus);

        if (sanctioningStatus == "Submitted" || sanctioningStatus == "Allocated To Sanctioner") {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                type: "error",
                title: "Error!",
                message: "This opportunity is currently awaiting sanctioning, please wait for the decision before making changes."
            });
            toastEvent.fire();
        } else {
            component.set("v.isOpen", true);
        }
    },

    handleError: function (component, event, helper) {
        console.log("In Error");
        component.set("v.showSpinner", false);
        helper.errorMsg("Error saving the recordEditForm in CAF_verticalTabs component. Look for detailed error at the bottom of the page.");
        component.set("v.errorMessage", "Error Message: " + JSON.stringify(event.getParam("error")));
    },

    handleSelect : function(component, event, helper) { 
      helper.handleSelectOption(component, event, helper);
    },
});