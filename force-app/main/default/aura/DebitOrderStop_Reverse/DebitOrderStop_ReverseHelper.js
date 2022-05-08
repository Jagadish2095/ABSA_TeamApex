({
    doInit : function(component, event, helper) {
        var today = new Date();
        component.set('v.toDate1', today.getFullYear() + "-" + (today.getMonth() + 1) + "-" + today.getDate());
        var result = new Date();
        result.setDate(result.getDate() - 40);
        component.set('v.fromDate1', result.getFullYear() + "-" + (result.getMonth() + 1) + "-" + result.getDate());
    },

    sortData: function (component, fieldName, sortDirection) {
        var data = component.get("v.ViewDebitList.debitCreditList");
        var reverse = sortDirection !== 'asc';
        data.sort(this.sortBy(fieldName, reverse))
        component.set("v.ViewDebitList.debitCreditList", data);
    },

    sortBy: function (field, reverse, primer) {
        var key = primer ? function(x) {return primer(x[field])} : function(x) {return x[field]};
        reverse = !reverse ? 1 : -1;
        return function (a, b) {
            return a = key(a), b = key(b), reverse * ((a > b) - (b > a));
        }
    },

    filterRefDataView: function(component, event, helper) {
    var data = component.get("v.ViewDebitList.debitCreditList"),
        term = component.get("v.filterRef"),
        results = data, regex;
        var data1 =JSON.stringify(data);
         regex = new RegExp(term, "i");

        if(results!=null){
        results = data.filter(row => regex.test(row.userRef));
        }
        if((term != '') && (data != null)){
        component.set("v.ViewDebitList.debitCreditList", results);
        }else{
            this.getDebitOrderList(component);
        }
    },

    filterAmtDataView: function(component, event, helper) {
    var data = component.get("v.ViewDebitList.debitCreditList"),
        term = component.get("v.filterAmount"),
        results = data, regex;
        var data1 =JSON.stringify(data);
        regex = new RegExp(term, "i");
        if(results!=null){
            results = data.filter(row => regex.test(row.amount));
            }
        if((term != '' )&& (data != null)){
        component.set("v.ViewDebitList.debitCreditList", results);
        }else{
            this.getDebitOrderList(component);
        }
    },

    getDebitOrderList : function(component, event, helper) {
        component.set("v.noDBList",false);
        var action = component.get("c.viewDebitOrderDetails");
        var selectedAccountValue = component.get('v.SelectedAccNumberFromFlow');
        var frmdte = component.find("fDate").get("v.value");
        var fromdatestr =frmdte.toString();
        var fromdate = fromdatestr.replace(/-/g,"");
        debugger;
        action.setParams({
			'AccountId': selectedAccountValue,
            'FrmDate' : fromdate

        });
		action.setCallback(this, function(response) {
            var state = response.getState();
			if (state === "SUCCESS") {
                if(response.getReturnValue()){
                    var resObj = response.getReturnValue();
                    component.set("v.response",resObj);
                    component.set("v.ViewDebitList",resObj.debitCreditList);
                    component.set('v.columns', [
                        {label: 'ACTION DATE', fieldName: 'actionDate', type: 'text'},
                        {label: 'USER CODE', fieldName: 'userCode', type: 'text', sortable: true},
                        {label: 'USER SEQ', fieldName: 'userSeq', type: 'text', sortable: true},
                        {label: 'USER REFERENCE', fieldName: 'userRef', type: 'text', sortable: true},
                        {label: 'AMOUNT', fieldName: 'amount', type: 'text', sortable: true},
                        {label: 'TRAN GRP', fieldName: 'trnGrp', type: 'text', sortable: true},
                        {label: 'STAT', fieldName: 'status', type: 'text', sortable: true}
                    ]);
                    if(resObj.respCode == '47' && resObj.debitCreditList == ''){
                        alert('enter');
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Error!",
                            "type":"error",
                            "message": "Please select valid Check or Savings Account Number"
                        });
                        toastEvent.fire();
                    }else if($A.util.isUndefinedOrNull(resObj.debitCreditList) ){
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Error!",
                            "type":"error",
                            "message": "There are currently no debit orders available to display."
                        });
                        toastEvent.fire();
                        component.set("v.noDBList",true);
                    }
                }
            }
		});
		$A.enqueueAction(action);
    },

    deleteDebitOrderHelper  : function(component, event, helper, actionItem) {
        var reasonCode = component.find("reason").get("v.value");
        var action = component.get("c.deleteDebitOrderDetails");
        action.setParams({
            'response': component.get("v.response"),
            'selectedValues' : component.get("v.selectedDBList"),
            'accountNumber' :component.get('v.SelectedAccNumberFromFlow'),
            'actionItem' : actionItem,
            'actionReason': reasonCode,
            'caseId' : component.get("v.caseId")
        });
		action.setCallback(this, function(response) {
            var state = response.getState();
			if (state === "SUCCESS") {
                if(response.getReturnValue().state =='success'){
                    this.showToast(response.getReturnValue().state, response.getReturnValue().message,response.getReturnValue().state);
                    component.set("v.isFirstScreen", false);
                    //DBOOYSEN. W-008306
					//Create the charge log by calling aura method from child component "ChargeTransaction"
					//Only create a charge log for debit order reversal not stopping a debit order
					if (actionItem == "ReverseDebitOrder") {
						var chargeComponent = component.find("chargeTransactionCmp");
						chargeComponent.createChargeLog("TC016"); //Debit Order Reversal
					}
                }else{
                    this.showToast(response.getReturnValue().state, response.getReturnValue().message,response.getReturnValue().state);
                }
            }else{
                this.showToast('error', 'got Error','error');
            }
		});
		$A.enqueueAction(action);

    },

    showToast : function(type, message, title){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type" : type,
            "title": title,
            "message": message
        });
        toastEvent.fire();
    }
})