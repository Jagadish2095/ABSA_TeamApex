({
    init: function(component, event, helper) {
        
    },
    CellphoneBankingSection: function (component, event) {
        
    },
    CellphoneBankingButtonIcon: function (component, event) {
        if (component.get('v.CellphoneBankingSelected'))
        {
            component.set('v.CellphoneBankingSelected', false);
            component.set('v.CellphoneBankingIconName', 'utility:add');
        }
        else {
            component.set('v.CellphoneBankingSelected', true);
            component.set('v.CellphoneBankingIconName', 'utility:success');
        }
    },
})