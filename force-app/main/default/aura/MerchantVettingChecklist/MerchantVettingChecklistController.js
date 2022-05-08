({
    doInit : function(component, event, helper){
        var param = {};
        helper.component = component ;
        helper.callServer('getQAtemplateRecord', param, false, function(resp){
            if(resp.isSuccess){
                component.set('v.qaList', resp.objectList);
            }
            else{
                helper.showMsg(component, event, 'Error', 'error', resp.message);
                console.log('message',resp.message);
            }
        });
    },

    setQAValue: function (component, event, helper) {
        var templateId = component.find("qaSelect").get("v.value");
		var caseId = component.get("v.recordId");

        if(templateId){
            helper.navigateToCaseForm(component, event, 'lscCaseQaForm', templateId, caseId);
        }
    }
})