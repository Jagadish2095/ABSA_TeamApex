({
    doInit: function (component, event, helper) {
        alert();
      //  helper.executeInitiateDebiCheck(component, event);
        helper.executeCompleteTwoHelper(component, event);
    },
    handleChange: function (component, event, helper) {

    },
    handleNavigate: function (component, event, helper) {
        var navigate = component.get('v.navigateFlow');
        var actionClicked = event.getParam('action');
        navigate(actionClicked);
    },
})