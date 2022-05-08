({
            
    
    	handleNavigate: function(cmp, event) {
   			var navigate = cmp.get("v.navigateFlow");
            cmp.set("v.OutcomeToFlow",event.getParam("outcome"));
            console.log('event.getParam("outcome")',event.getParam("outcome"));
   			navigate(event.getParam("action"));
		}
})