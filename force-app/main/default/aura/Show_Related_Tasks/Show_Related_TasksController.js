({
	init : function(component, event, helper) {
        //show spinner
		console.log('init');
        component.set('v.myCols', [
            {label: 'Created', fieldName: 'createdDate', type: 'text'},
            {label: 'Subject', fieldName: 'subject', type: 'text'}
        ]);
        console.log(component.get('v.myCols'));
        var urlAsList = window.location.pathname.split('/');
        var rid = urlAsList[urlAsList.length-2]
        console.log(rid);
        var action = component.get('c.getRelatedTasks');
        action.setParams({'context': rid});
        action.setCallback(this, function(resp){
            var tasks = resp.getReturnValue();
            console.log(tasks);
            component.set('v.tasks', JSON.parse(tasks));
            //hide spinner
        })
        $A.enqueueAction(action);
	}
})