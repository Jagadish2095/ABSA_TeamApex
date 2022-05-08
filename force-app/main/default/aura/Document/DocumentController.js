({
    init: function (cmp, event, helper) {
        helper.fetchData(cmp);
    },
    
    download: function(cmp, event, helper) {
    	var row = event.getParam('row');
        var actionName = event.getParam('action').name;
        helper.download(cmp, row);
    },
    
    refresh: function (cmp, event, helper) {
    	helper.refresh(cmp);
	}
})