({
    fadeOutCloseDialog : function(component){
        $A.util.removeClass(component.find('modalId'), 'slds-fade-in-open');
        $A.util.removeClass(component.find('backdropId'), 'slds-fade-in-open');
        $A.util.addClass(component.find('modalId'), 'slds-fade-in-hide');
        $A.util.addClass(component.find('backdropId'), 'slds-fade-in-hide');
    },

    fadeInOpenDialog : function(component){
        $A.util.removeClass(component.find('modalId'), 'slds-fade-in-hide');
        $A.util.removeClass(component.find('backdropId'), 'slds-fade-in-hide');
        $A.util.addClass(component.find('backdropId'), 'slds-fade-in-open');
        $A.util.addClass(component.find('modalId'), 'slds-fade-in-open');
    }
})