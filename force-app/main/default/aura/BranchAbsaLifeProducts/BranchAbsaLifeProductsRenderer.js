({
    rerender : function(component, helper){
        this.superRerender();
        helper.UpdateVisuals(component);
    }, 
    render : function(component, helper) {
        var ret = this.superRender();
        helper.UpdateVisuals(component);
        return ret;
    },
})