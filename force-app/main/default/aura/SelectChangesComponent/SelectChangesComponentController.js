({
    getSelectedChanges : function(component, event,helper) { 
        var selectedId='';
        selectedId = event.target.getAttribute('id');
        if(document.getElementById(selectedId).checked && component.get("v.SelectedOption").indexOf(selectedId) < 0)
            component.get('v.SelectedOption').push(selectedId);
        else{
            var index = component.get("v.SelectedOption").indexOf(selectedId);
            if (index > -1) {
                component.get("v.SelectedOption").splice(index, 1); 
            }
        }
    },
    
    saveChanges:function(component,event,helper){
        var SelectedOption=component.get("v.SelectedOption");
        if(SelectedOption.length>0){
            helper.saveChange(component,SelectedOption);
        }
        else{
            alert('please select option to save.')
        }
    },
 })