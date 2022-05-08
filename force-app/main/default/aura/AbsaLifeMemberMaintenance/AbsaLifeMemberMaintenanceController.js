({
	doInit : function(component, event, helper) {
        helper.showSpinner(component);
		helper.getPolicyData(component);

        var actions = [
            { label : "Show Details", name : "show"},
            { label : "Delete", name : "delete"}
        ];

        var columns = [
			{ label: "Name", fieldName: "firstName", type: "text" },
			{ label: "Surname", fieldName: "surname", type: "Text" },
			{ label: "Benefit Type", fieldName: "benefitType", type: "text" },
			{ label: "Date Of Birth", fieldName: "dateOfBirth", type: "text" },
            { label: "Cover Option", fieldName: "cover", type: "text" },
            { label: "Premium", fieldName: "premium", type: "text" },
            { type: "action", typeAttributes: {rowActions: actions}}
		];
		component.set("v.memberListColumns", columns);
	},

	handleRowAction: function (component, event, helper) {
		var row = event.getParam("row");
        component.set("v.rowData", row);

		var actionName = event.getParam("action").name;
		if (actionName == "show") {
            component.set("v.showMemberDetails", true);
        }else if (actionName == "delete") {
			component.set("v.confirmDeleteMember", true);
        }
    },

    closeMemberDetails: function (component, event, helper) {
		component.set("v.showMemberDetails", false);
    },

    handleDeleteMember: function (component, event, helper) {
        component.set("v.confirmDeleteMember", true);
        component.set("v.showMemberDetails", false);
    },

    cancelDeleteMember: function (component, event, helper) {
		component.set("v.confirmDeleteMember", false);
        component.set("v.showMemberDetails", false);
    },

    confirmDeleteMember: function (component, event, helper) {
        helper.deleteMember(component, event, helper);
    }
})