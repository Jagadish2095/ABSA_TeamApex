({
    init : function(component, event, helper) {
        debugger;
        var IsAddingRelatedParty = component.get("v.IsAddingRelatedParty");
        var IsDeletingRelatedParty = component.get("v.IsDeletingRelatedParty");
        var caseId = component.get("v.CaseId");
        
        if(IsAddingRelatedParty == true)
        {
            component.set("v.IsDeletingRelatedParty", true);
            component.set("v.displayMessage", 'added');            
        }
        else if(IsDeletingRelatedParty == true)
        {
            component.set("v.displayMessage", 'deleted');            
        }
        else if(IsAddingRelatedParty == true && IsDeletingRelatedParty == true)
        {
           component.set("v.displayMessage", 'added and deleted');            
        }        
		var promise = helper.CloseCaseStatus(component, event, helper).then(
			$A.getCallback(function (result) {
				
			}),
			$A.getCallback(function (error) {
				component.find("branchFlowFooter").set("v.heading", "Error executeCompleteTwo");
				component.find("branchFlowFooter").set("v.message", error);
				component.find("branchFlowFooter").set("v.showDialog", true);
			})
		);
    },
    
    handleNavigate: function(component, event, helper) {
        var navigate = component.get("v.navigateFlow");
        var actionClicked = event.getParam("action");
        var finshFlow="home/home.jsp"
        switch(actionClicked)
        {
            case "NEXT": 
            case "FINISH":
                { 
                   helper.navHome(component, event, helper);
                    break;   
                }
            case "BACK":
                {
                    navigate(event.getParam("action"));
                    break;
                }
            case "PAUSE":
                {
                    navigate(event.getParam("action"));
                    break;
                }
        }
    }
	
})