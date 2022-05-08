({
	setCAFRegion: function (component, event, helper) {
        var caf = component.find("siteCode").get("v.value");
        if (caf!=null){
            component.set("v.cafsiteC", true);
        }
        else{
            component.set("v.cafsiteC", false);
        }
    }
})