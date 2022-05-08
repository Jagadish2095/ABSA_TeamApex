({
	doInit : function(component, event, helper) {
        helper.doInit(component);
    },

    dispDebitOrder : function(component, event, helper) {
        var fDate = component.find("fDate").get('v.value');
        var tDate = component.find("tDate").get('v.value');
        if((fDate != '') && (tDate != ''))
        {
            helper.getDebitOrder1(component);
        }
    },

    getSelectedName: function (component, event) {
        var selectedRows = event.getParam('selectedRows');
        for (var i = 0; i < selectedRows.length; i++){
            if(selectedRows.length > 0){
                var selectedRow=selectedRows[i];
                selectedRow.actionDate = selectedRow.actionDate;
                selectedRow.userCode = selectedRow.userCode;
                selectedRow.userSeq = selectedRow.userSeq;
                component.set("v.proName", selectedRow.actionDate);
                component.set("v.proType", selectedRow.userCode);
                component.set("v.procount", selectedRow.userSeq);
            }
        }
    },

    filterRefData: function(component, event, helper) {
        helper.filterRefDataView(component, event, helper);
    },

    filterAmtData: function(component, event, helper) {
        helper.filterAmtDataView(component, event, helper);
    },

    updateColumnSorting: function(component, event, helper) {
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        component.set("v.sortedBy", fieldName);
        component.set("v.sortedDirection", sortDirection);
        helper.sortData(component, fieldName, sortDirection);
    },

    getDebitOrder : function(component, event, helper) {
        helper.getDebitOrderList(component);
    },

    updateSelectList: function(component, event, helper) {
        var selectedList = [];
        var sourceId = event.getSource().get("v.id");
        if(event.getSource().get("v.checked")){
            selectedList.push(sourceId);
        }
        component.set("v.selectedDBList", selectedList);
    },
    
    deleteDebitOrder: function(component, event, helper) {
        helper.deleteDebitOrderHelper(component, event, helper, component.get("v.actionItem"));
    }
})