({
    init : function(component,event,helper) {
        var listType = component.get('v.questionListType');
        helper.knockoutHelper(component,listType);
    },

     atestationChange: function (component, event,helper) {
         helper.SelectionCallback(component, event);
    }

})