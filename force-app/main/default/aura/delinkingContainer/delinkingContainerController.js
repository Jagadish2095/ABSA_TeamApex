({
    doInit : function(component, event, helper) {
        
        let flow = component.find('delinkingFlow');
        let accountId = component.get('v.accountId');
        let clientKey = component.get('v.clientKey');
        let idNumber = component.get('v.idNumber');
        let skipBiometrics = component.get('v.useBiometrics') == true ? false: true;

        accountId = accountId == null ? '' : accountId;

        let inputVariables = [
            {name: "accountId", type: "String", value: accountId },
            {name: "clientKey", type: "String", value: clientKey},
            {name: "idNumber", type: "String", value: idNumber},
            {name: "skipBiometrics", type: "Boolean", value: skipBiometrics}
        ];
        
        flow.startFlow('Delinking_Account_From_a_Package_Flow', inputVariables);
    }
})