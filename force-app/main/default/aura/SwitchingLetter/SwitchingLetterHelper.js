({
    showSpinner: function (component) {
        var spinner = component.find("TheSpinner");
        component.set("v.HideSpinner" , true);
    },
    hideSpinner: function (component) {
        var spinner = component.find("TheSpinner");
        component.set("v.HideSpinner" , false);
    },
})