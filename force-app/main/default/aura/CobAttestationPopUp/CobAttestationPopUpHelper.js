({
	    loadOpportunity: function(component, event, helper){
        var OpportunityId = component.get("v.recordId");
        var userId = $A.get( "$SObjectType.CurrentUser.Id" );
        var action = component.get("c.loadOppRecord");
        action.setParams({
            oppId : OpportunityId
        });
        action.setCallback(this,function(res){
            var state = res.getState();
            if(state==="SUCCESS"){
            var oppRec = res.getReturnValue();
            component.set('v.oppRecord',oppRec);
                if(oppRec && userId == oppRec.OwnerId && oppRec.StageName != 'Closed'){
                    component.set("v.showAttestationModal",true);
                    var today = new Date();
                    var date = today.getFullYear()+'-'+(today.getMonth()+1)+'-'+today.getDate()+' '+today.getHours() + ":" + today.getMinutes() + ":" + today.getSeconds();
                    component.find("oDateTime").set("v.value", date);
                    component.set("v.oDateTime",date);
                    component.find("attestHistory").set("v.value", date);
                }
            }
        });       
        $A.enqueueAction(action);
    },
})