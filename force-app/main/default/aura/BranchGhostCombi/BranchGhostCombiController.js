({
    init : function(component, event, helper) {
        debugger;
        //var initialAnswerId = component.get("v.initialAnswerId");
        component.set("v.showSpinner", true);
        component.find('branchFlowFooter').set('v.nextDisabled', 'true');
        
        let promise =  helper.fetchData(component,  helper)
        .then(
            $A.getCallback(function(result) {   
                helper.executeIssueGhost(component,  helper);
            }),
            $A.getCallback(function(error) {         
                component.set("v.showSpinner", false);
                component.find('branchFlowFooter').set('v.heading', 'Error: executeIssueGhost');
                component.find('branchFlowFooter').set('v.message', error);
                component.find('branchFlowFooter').set('v.showDialog', true);
            })
        )
    },
    
    handleNavigate: function(component, event, helper) {
        var navigate = component.get('v.navigateFlow');
        var actionClicked = event.getParam('action');
        
        switch(actionClicked) {
            case 'NEXT':
            case 'FINISH':
            case 'BACK':
                navigate(actionClicked);
                break;
        }
    }
})