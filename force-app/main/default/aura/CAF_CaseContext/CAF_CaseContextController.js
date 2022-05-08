({
	doInt : function(cmp, event, helper) {
        helper.getOppId(cmp);
	},
    openOpp : function(cmp, event, helper){          
        var urlEvent = $A.get("e.force:navigateToURL");	
        urlEvent.setParams({
            "url" : '/' + cmp.get('v.oppId')                      
        });
        urlEvent.fire(); 
    }
})