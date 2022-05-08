({
    doInit: function (component, event, helper) {
        helper.getColumns(component);
        helper.getDataHelper(component, event);
    },

    //Function to handle search when the search button is clicked
    handleSearch: function (component, event, helper) {
        component.set("v.showLoadingSpinner", true);
        helper.search(component);
    },

    //Function for handling next when Next button is clicked
    handleNext: function (component, event, helper) {
        component.set("v.showLoadingSpinner", true);
        var pageNumber = component.get("v.pageNumber");
        component.set("v.pageNumber", pageNumber + 1);
        helper.getDataHelper(component, event);
    },

    //Function for handling next when next Previous button is clicked
    handlePrev: function (component, event, helper) {
        component.set("v.showLoadingSpinner", true);
        var pageNumber = component.get("v.pageNumber");
        component.set("v.pageNumber", pageNumber - 1);
        helper.getDataHelper(component, event);
    }
});