({
    changePDFDataReceivedStatus: function(component, helper) {
        component.set("v.pdfDataReceivedStatus", true);
        component.set("v.showSpinner", false);
    },

    errorHandle: function(component) {
        component.set("v.showSpinner", false);
        component.set("v.pdfDataReceivedErrorStatus", true);
    },

    closeFocusedTab : function(component, event, helper) {
        let workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            let focusedTabId = response.tabId;
            workspaceAPI.closeTab({tabId: focusedTabId});
        })
        .catch(function(error) {
            console.log(error);
        });
    },

    restartEnquiry: function (component) {
        let navigate = component.get("v.navigateFlow");
        navigate("NEXT");
    },
})