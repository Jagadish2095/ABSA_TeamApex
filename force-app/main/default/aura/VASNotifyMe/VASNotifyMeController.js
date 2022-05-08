({
	init: function(component, event, helper) {
		helper.NotifyMeCall(component, event);
      },
    NotifyMeSection: function (component, event) {

    },
    NotifyMeButtonIcon: function (component, event, helper) {
		helper.RegisterNotifyMe (component, event);
    }
})