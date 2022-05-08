({
    doInit : function(component, event, helper){
        helper.loadRecord(component);//call base helper first

        //Here we control what can be overridden and what cannot be, without below code piece, child controller/
        //helper will not be called
        var childComponent = component.getConcreteComponent();
        if(!$A.util.isUndefined(childComponent.loadRecord)){
            childComponent.loadRecord();
        }
    }
})