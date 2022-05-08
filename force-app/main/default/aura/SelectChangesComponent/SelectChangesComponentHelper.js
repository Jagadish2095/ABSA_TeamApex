({
    saveChange:function(component,SelectedOption){
        var CaseId=component.get("v.recordId");
        var action=component.get("c.saveClientChanges");
        action.setParams({
            lstOfSelectedOptions:SelectedOption,
            recordId:CaseId
        });
        action.setCallback(this,function(e){
            console.log("STATE : "+e.getState());
            if(e.getState()=='SUCCESS'){
                var result=e.getReturnValue();
                if(result!=''){
                    alert(result);
                }
                else{
                    alert('Response Saved successfully');     
                     $A.get("e.force:refreshView").fire();
                }
            } 
            else{
                console.log("ERROR : "+JSON.stringify(e.getError()));
            }
        });
        $A.enqueueAction(action);
    }
 })