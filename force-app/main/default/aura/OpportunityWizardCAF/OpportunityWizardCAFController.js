({
    //Initialization action
    doInit: function(component, event, helper) {

        helper.getOpportunityRecordTypesList(component);

    },

    //Get selected client from client finder
    handleClientSelectionEvent: function(component, event, helper) {

        var selectedClient = event.getParam("accountValue");        
        if (selectedClient != null && selectedClient != "" && selectedClient != undefined) {
            component.set("v.accountData", selectedClient);
        }

    },

    //Get selected product from client finder
    handleProductSelectionEvent: function(component, event, helper) {

            var accountNumber = event.getParam("accountNumber");
            var accountStatus = event.getParam("accountStatus");
            var accountProduct = event.getParam("accountProduct");
            var selectedProduct = {accountNumber: accountNumber, accountStatus: accountStatus, accountProduct: accountProduct};

            if (selectedProduct != null && selectedProduct != "" && selectedProduct != undefined) {

                if (selectedProduct.accountProduct === "WILL" && selectedProduct.accountStatus !== "CLOSED") {

                    component.set("v.productData", selectedProduct);
                    component.set("v.showWillTypeSelection", true);
                    helper.getWillDetails(component);
                }

            }

        },

    handleLoad: function(component, event, helper) {
        //Any actions to perform when record creation form is loaded
    },

    //Any actions to perform when record creation form is submitted
    handleSubmit: function(component, event, helper) {

    },

    //Actions for when record create form is successfully submitted
    handleSuccess: function(component, event, helper) {

        var recordId = event.getParams().response.id;

        component.set("v.recordFormSubmitted", true);
        component.set("v.recordId", recordId);
        component.set("v.showOpportunitySummary", true);
    },

    //Handles all changes on changeable markup
    handleChange: function(component, event, helper) {

        switch (event.getSource().getLocalId()) {
            case "opportunityRecordTypeGroup":
                //Set the opportunity recordTypeId
                component.set("v.selectedOpportunityRecordTypeId", event.getSource().get("v.value"));

                for (var i = 0; i < component.get("v.opportunityRecordTypesList").length; i ++) {
                    if (event.getSource().get("v.value") === component.get("v.opportunityRecordTypesList")[i].value) {

                        component.set("v.selectedOpportunityRecordTypeName", component.get("v.opportunityRecordTypesList")[i].label);

                        break;

                    }

                }

                helper.getSelectedOpportunityRecordTypeFields(component);

                break;
            case "willTypeRadioGroup":
                component.set("v.willTypeValue", event.getSource().get("v.value"));
                break;
        }
    },

    //Navigates to the previous tab depending on select criteria
    previousTab: function(component, event, helper) {

        if (component.get("v.showOppotunityRecordTypeSelection")) {

            component.set("v.showOppotunityRecordTypeSelection", false);
            component.set("v.showClientFinder", true);

        }  else if (component.get("v.showOpportunitySummary")) {

            component.set("v.showOpportunitySummary", false);

        }
    },

    //Navigates to the next tab depending on select criteria
    nextTab: function(component, event, helper) {

        if (component.get("v.showClientFinder")) {

            component.set("v.showClientFinder", false);
            component.set("v.showOppotunityRecordTypeSelection", true);
            //Create selected client
            var client = component.get("v.accountData");
            if (client != null && client != "" && client != undefined) {

                var clientCif = client.CIF__c;

                if (clientCif != null && clientCif != "" && clientCif != undefined) {

                    helper.createClientCIF(component);

                }

            }

        } else if (component.get("v.showOppotunityRecordTypeSelection")) {
		component.set("v.showClientFinder", false);
            if (component.get("v.selectedOpportunityRecordTypeId") != null || component.get("v.selectedOpportunityRecordTypeId") != undefined) {
                component.set("v.showOppotunityRecordTypeSelection", false);
                
                //component.set("v.showSpinner", true);
                helper.createOpplineitem(component);
                component.set("v.showOpportunitySummary", true);
                //helper.generateFormInputFields(component);
            } else {
                //Show error message
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "An Opportunity Record Type must be selected.",
                    "type": "error"
                });
                toastEvent.fire();
            }

        } 
        
        
    },

    //Action when opportunity creation is cancelled
    cancel: function(component, event, helper) {

        if (component.get("v.recordId") != null) {
            component.set("v.showSpinner", true);
            helper.deleteOpportunity(component);

            var homeEvent = $A.get("e.force:navigateToObjectHome");
            homeEvent.setParams({
                "scope": "Opportunity"
            });

            //Close current tab
            var workspaceAPI = component.find("workspace");

            workspaceAPI.getFocusedTabInfo().then(function(response) {

                var focusedTabId = response.tabId;

                workspaceAPI.closeTab({tabId: focusedTabId});

            })
            .catch(function(error) {

                console.log(error);

            });

            //Fire navigation event
            homeEvent.fire();

        } else {

            var homeEvent = $A.get("e.force:navigateToObjectHome");

            homeEvent.setParams({
                "scope": "Opportunity"
            });

            //Close current tab
            var workspaceAPI = component.find("workspace");

            workspaceAPI.getFocusedTabInfo().then(function(response) {

                var focusedTabId = response.tabId;

                workspaceAPI.closeTab({tabId: focusedTabId});

            })
            .catch(function(error) {

                console.log(error);

            });

            //Fire navigation event
            homeEvent.fire();

        }

    },

    finish: function(component, event, helper) {

        component.set("v.showSpinner", true);

        helper.updateOpportunity(component);

        var sObjectEvent = $A.get("e.force:navigateToSObject");
        var recordId = component.get("v.recordId");

        if (recordId != null && recordId != '') {
            //Close current tab
            var workspaceAPI = component.find("workspace");

            workspaceAPI.getFocusedTabInfo().then(function(response) {

                var focusedTabId = response.tabId;

                //Open created opportunity tab
                workspaceAPI.openTab({
                    url: '/lightning/r/Opportunity/' + recordId + '/view'
                })
                .then(function(response) {

                    workspaceAPI.closeTab({tabId: focusedTabId});
                    workspaceAPI.focusTab({tabId : response});

                })
                .catch(function(error) {

                    console.log(error);

                });

            })
            .catch(function(error) {

                console.log(error);

            });

        }

    }

})