({
    checkCreditLife: function(component) {
        var returnValue = true;
        this.removeValidation(component, 'CreditLifeFnBsDiv');
        
        if (component.get(" v.creditLifeSelected" )) {
            var creditLifeFnBsChecked = component.get(" v.creditLifeFnBsChecked" );
            
            if (!creditLifeFnBsChecked) {
                this.addValidation(component, 'CreditLifeFnBsDiv', 'Please select to confirm.');
                returnValue = false;
            }
        }
        
        return returnValue;
    },
    
    addValidation: function(component, componentAuraId, errorMsg) {
        var styleClass= 'slds-form-element__help validationCss';
        var errorComponent = component.find(componentAuraId);
        $A.util.addClass(errorComponent, 'slds-has-error');
        
        var globalId = component.getGlobalId();
        var elementId = (globalId + '_' + componentAuraId);
        var validationElementId = (elementId + '_Error');
        
        var errorElement = document.getElementById(elementId)
        var validationElement = document.createElement('div');
        validationElement.setAttribute('id', validationElementId);
        validationElement.setAttribute('class', styleClass);
        validationElement.textContent = errorMsg;
        
        errorElement.appendChild(validationElement);
    },
    
    removeValidation: function(component, componentAuraId) {
        var globalId = component.getGlobalId();
        var validationElementId = (globalId + '_' + componentAuraId + '_Error');
        
        var errorComponent = component.find(componentAuraId);
        $A.util.removeClass(errorComponent, 'slds-has-error');
        
        if(document.getElementById(validationElementId))
        {
            var errorElement = document.getElementById(validationElementId);
            errorElement.parentNode.removeChild(errorElement);
        } 
    }
})