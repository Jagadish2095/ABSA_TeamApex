({
    setActionsAvailable : function(component) {
        var availableActions = component.get('v.availableActions');
        this.addValueToMap(component, 'v.cancelButton', 'available', false);
        this.addValueToMap(component, 'v.saveButton', 'available', false);
        for (var i = 0; i < availableActions.length; i++) {
            if ((availableActions[i] == 'PAUSE') && (this.getValueFromMap(component, 'v.pauseButton', 'visible'))) {
                this.addValueToMap(component, 'v.pauseButton', 'available', true);
            } else if ((availableActions[i] == 'BACK') && (this.getValueFromMap(component, 'v.backButton', 'visible'))) {
                this.addValueToMap(component, 'v.backButton', 'available', true);
            } else if ((availableActions[i] == 'NEXT') && (this.getValueFromMap(component, 'v.nextButton', 'visible'))) {
                this.addValueToMap(component, 'v.nextButton', 'available', true);
            } else if ((availableActions[i] == 'FINISH') && (this.getValueFromMap(component, 'v.finishButton', 'visible'))) {
                this.addValueToMap(component, 'v.finishButton', 'available', true);
            } else if ((availableActions[i] == 'CANCEL') && (this.getValueFromMap(component, 'v.cancelButton', 'visible'))) {
                this.addValueToMap(component, 'v.cancelButton', 'available', true);
            } else if ((availableActions[i] == 'SAVE') && (this.getValueFromMap(component, 'v.saveButton', 'visible'))) {
                this.addValueToMap(component, 'v.saveButton', 'available', true);
            }
        }
    },

    fireEvent : function(event) {
        var actionClicked = event.getSource().getLocalId();
        var myEvent = $A.get("e.c:BranchNavigateFlow");
        myEvent.setParam('action', actionClicked);
        myEvent.fire();
    }
})