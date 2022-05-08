({
	handleBrachCodeComponentEvent: function (component, event, helper) {
		var selectedBranchCodeFromEvent = event.getParam("recordBranchCodeEvent");
		component.set("v.branchCode", selectedBranchCodeFromEvent);
	},
    
    uncheckFTFCheckbox: function (component, event, helper) {
        if(component.get("v.isSelectedBranch")){
            component.set("v.isSelectedFTF",false);
            component.set("v.cardCollectionMethod",'B');
        }
	},
    
    uncheckBranchCheckbox: function (component, event, helper) {
        if(component.get("v.isSelectedFTF")){
            component.set("v.isSelectedBranch",false);
            component.set("v.cardCollectionMethod",'S');
        }
	},
    
    uncheckWAandOtherCheckbox: function (component, event, helper) {
        if(component.get("v.isResAddSelected")){
            component.set("v.isWorkAddSelected",false);
            component.set("v.isOtherSelected",false);
        }
	},
    
    uncheckRSandOtherCheckbox: function (component, event, helper) {
        if(component.get("v.isWorkAddSelected")){
            component.set("v.isResAddSelected",false);
            component.set("v.isOtherSelected",false);
        }
	},
    
    uncheckWAandRSCheckbox: function (component, event, helper) {
        if(component.get("v.isOtherSelected")){
            component.set("v.isResAddSelected",false);
            component.set("v.isWorkAddSelected",false);
        }
	},
})