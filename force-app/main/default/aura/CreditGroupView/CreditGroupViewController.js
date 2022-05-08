({
	doInit: function (component, event, helper) {
		helper.getAccount(component, event, helper);

		component.set("v.columns", [
			{ label: "Primary Client", fieldName: "PrimaryClient", type: "String" },
			{ label: "Group Member", fieldName: "GroupMember", type: "String" },
			{ label: "Client Code", fieldName: "ClientCode", type: "String" },
			{ label: "Status Indicator", fieldName: "StatusIndicator", type: "String" }
		]);

		helper.getCreditGrpVw(component, event, helper);
	},

	handleClick: function (component, event, helper) {
		$A.enqueueAction(component.get("c.doInit"));
	}
});