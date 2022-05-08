({
    handleRangeChange : function(component, event, helper) {        
        component.set("v.update",false);
    },
    handleUpdate: function(component, event, helper){        
        component.set('v.creditLimitOffered',component.get('v.value'));
        component.set('v.counter',component.get('v.counter')+1);
        var counter = component.get('v.counter');
        if(counter >= 3){
            component.set("v.update",true);
            component.set("v.sliderDisabled",true);
        }
    },
    handleNavigate: function(component, event, helper) {
        var navigate = component.get('v.navigateFlow');
        var actionClicked = event.getParam('action');
        navigate(actionClicked);
    }
})