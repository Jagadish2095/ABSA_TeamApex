({
	doInit: function (component, event, helper) {
        console.log('Inside doInit function of controller...');
		helper.getAccount(component, event, helper);
        helper.getAppRec(component, event, helper);
		helper.getCreditGrpVw(component, event, helper);
	},

	handleClientSelectionEvent: function (component, event, helper) {
		var selectedClient = event.getParam("accountValue");
		if (selectedClient != null && selectedClient != "" && selectedClient != undefined) {
			component.set("v.accountDataFrmCltFinder", selectedClient);
			component.set("v.showModal", false);
			if (component.get("v.isGroupSel")) {
				helper.addGroupToStructure(component, event, helper);
			} else {
				helper.addGroupMemberToGroup(component, event, helper);
			}
		}
	},
    handleRowAction: function (component, event, helper) {
        var action = event.getParam("action");
        switch (action.name) {
            case "Add Group Member":
                var row = event.getParam("row");
                component.set("v.grpMemberKey", row.Key);
                component.set("v.rowGrpClientCode", row.ClientCode);
                component.set("v.isGroupSel", false);
                component.set("v.showModal", true);
                break;
                
            case "Add This Client As Group":
                var row = event.getParam("row");
                helper.addGroupToStructure(component, event, helper, row);
                break;
                
            case "Delink":
                var row = event.getParam("row");
                helper.delinkGroupMembers(component, event, helper, row);
                break;
        }
    },

	handleClick: function (component, event, helper) {
		alert("Warning : You Are About To Refresh From CMS, You Need to Add the Interim Group Members Again After Refresh..");
		//$A.enqueueAction(component.get("c.doInit"));
		helper.refreshCreditGrpVw(component, event, helper);
	},

	submitToCreditLens: function (component, event, helper) {
		//alert("Submitted Successfully");
        helper.startCreditLens(component);
	},

	showClientFinderModal: function (component, event, helper) {
		component.set("v.isGroupSel", true);
		component.set("v.showModal", true);
	},

	closeClientFinderModal: function (component, event, helper) {
		component.set("v.showModal", false);
	},

	expandAllRows: function (component, event) {
		var tree = component.find("mytree");
		tree.expandAll();
	},
	collapseAllRows: function (component, event) {
		var tree = component.find("mytree");
		tree.collapseAll();
	},
    
    closeModel : function(component, event, helper) {
        component.set("v.isOpen",false);
        
    },
});