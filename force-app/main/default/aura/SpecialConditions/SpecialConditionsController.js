({
    doInit:function(component,event, helper) {
        
        var opportunityId = component.get("v.recordId");    
       var action = component.get("c.getRelatedParties");
        action.setParams({
            "oppId": opportunityId
        }); 
        
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var result = response.getReturnValue();
                var plValues = [];
                var str = '';
                for(var i = 0; i < result.length; i++) {
                    str= result[i].Contact.FirstName+' '+result[i].Contact.LastName;
                    plValues.push({label:str,value:str});
                }
                component.set("v.RelatedPartiesList",plValues);
                
            }
            else {
                helper.showError(response, "getRelatedParties");
            }
        });
        
        $A.enqueueAction(action);
        helper.getSpecialCondition(component,event,helper);
        
    },
    
    handleRelatedPartiesChange:function(component, event, helper) {
        
        var selectedValues = event.getParam("value");
        
        component.set("v.selectedRelatedPartiesList",selectedValues);
        
        
    },
    onRadioChange: function (component, event, helper) {
        var value = event.getParam("value");
        if(value=="Yes"){
            component.set("v.showCOG",true);
        }
        else{
            component.set("v.showCOG",false);
        }
    },
    getSelectedRelatedParties: function(component,event, helper){
        var selectedValues = component.get("v.selectedRelatedPartiesList");
        console.log('Selectd Genre-' + selectedValues);
        
        
    },
    saveSC : function(component, event, helper) {
		var values = component.get("v.values");
        var checkk = false;
        var errors = false;
        console.log('checkkk'+component.get("v.values"));
        var selectedRelatedParties = component.get("v.selectedRelatedPartiesList");
        
        if(selectedRelatedParties!=null){
            //var listselectedRelatedParties = [];
            //listselectedRelatedParties.push(selectedRelatedParties.split(";"));
            var newList ='';
            for(var k=0;k<selectedRelatedParties.length;k++){
                if(k==0){
                   newList += selectedRelatedParties[k]; 
                }
                else{
                    newList += ','+selectedRelatedParties[k];
                }
                
            }
            component.set("v.ShareholderDirectorVal",newList);
        }
        helper.saveSC(component, event, helper,values);
       
	},
    
    
})