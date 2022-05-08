({
    refreshAndNavigate : function(component, event, helper) {
        $A.get('e.force:refreshView').fire();
        //var navigate = cmp.get('v.navigateFlow');
        //navigate("NEXT");
    }
})