({
    //unless specified on parent component to call child controllers, it will not be called
    loadRecord : function(component, event, helper) {
        helper.childComponentMethod(component);
    },
    childComponentMethod : function(component){
        console.log('Now we can handle additional processing here in ' + component.getName());
    }
})