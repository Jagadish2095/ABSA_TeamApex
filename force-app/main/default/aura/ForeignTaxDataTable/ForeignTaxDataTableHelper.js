({
    setupData : function(component){
        component.set("v.isLoading", true);
        var data = component.get("v.data");
        var cols = component.get("v.columns");
        if ((data) && (cols)) {
            var tableData = [];
            data.forEach(function(value, index) {
                var row = {};
                var fields = [];
                cols.forEach(function(col) {
                    var field = {};
                    field.name = col.fieldName;
                    field.value = value[col.fieldName];
                    field.recordId = value["Id"];
                    field.type = col.type ? col.type : "text";
                    if (field.type === "picklist") {
                        field.isEditSpecialType = true;
                        field.selectOptions = col.selectOptions;
                    }
                    field.editable = col.editable ? col.editable : false;
                    field.tdClassName = field.editable === true ? "slds-cell-edit" : "";
                    field.mode = "edit";
                    field.disabled = false;
                    fields.push(field);
                });
                row.id = value.Id;
                row.fields = fields;
                tableData.push(row);
            });
            component.set("v.tableData", tableData);
            this.disableTaxData(component);
        }
        component.set("v.isLoading", false);
    },

    updateTable : function(component, colName, colValue){
        var rowIndex = colName.split("~")[0];
        var colIndex = colName.split("~")[1];
        var fieldName = colName.split("~")[2];
        var data = component.get("v.data");
        data.forEach(function(value, index) {
            if (index == rowIndex) {
                value[fieldName] = colValue;
            }
        });
    },

    newTaxDocument : function(component) {
        var recordId = component.get("v.recordId");
        this.callApex(component, "c.newTaxDocument", { recordId: recordId, recordType: "Foreign Tax" }, this.doneNewTaxDocument);
    },

    doneNewTaxDocument: function(component, returnValue) {
        if(returnValue){
            var data = component.get("v.data");
            data.push(returnValue);
            if (data.length == 4) {
                component.set("v.addForeignTaxDisabled", true);
            }
            component.set("v.data", data);
        }
    },

    removeTaxDocument : function(component, rowIndex) {
        var tableData = component.get("v.tableData");
        var data = component.get("v.data");
        var deleteData = component.get("v.deleteData");
        if ($A.util.isUndefinedOrNull(deleteData)) {
            deleteData = [];
        }
        var rowId = tableData[rowIndex].id;
        var deleteIndex = -1;
        data.forEach(function(value, index) {
            if (value.Id == rowId) {
                deleteIndex = index;
            }
        });
        if (deleteIndex > -1) {
            if (!$A.util.isUndefinedOrNull(rowId)) {
                deleteData.push(data[deleteIndex]);
                component.set("v.deleteData", deleteData);
            }
            data.splice(deleteIndex, 1);
            if (data.length < 4) {
                component.set("v.addForeignTaxDisabled", false);
            }
            component.set("v.data", data);
        }
        component.set("v.isLoading", false);
    },

    disableTaxData : function(component){
        var tableData = component.get("v.tableData");
        for (var indexId in tableData) {
            if (tableData[indexId].fields.length == 3) {
                var numberValue = tableData[indexId].fields[1].value;
                var reasonValue = tableData[indexId].fields[2].value;
                numberValue = $A.util.isUndefinedOrNull(numberValue) ? "" : numberValue;
                reasonValue = $A.util.isUndefinedOrNull(reasonValue) ? "" : reasonValue;
                if (numberValue != "" && reasonValue == "") {
                    tableData[indexId].fields[2].disabled = true;
                }
                if (numberValue == "" && reasonValue != "") {
                    tableData[indexId].fields[1].disabled = true;
                }
                if (numberValue == "" && reasonValue == "") {
                    tableData[indexId].fields[1].disabled = false;
                    tableData[indexId].fields[2].disabled = false;
                }
            }

        }
        component.set("v.tableData", tableData);
    },

    verityTaxData : function(component){
        this.removeTaxValidation(component);
        var returnValue = "pass";
        var tableData = component.get("v.tableData");
        for (var indexId in tableData) {
            var countryValue = tableData[indexId].fields[0].value;
            var numberValue = tableData[indexId].fields[1].value;
            var reasonValue = tableData[indexId].fields[2].value;
            countryValue = $A.util.isUndefinedOrNull(countryValue) ? "" : countryValue;
            numberValue = $A.util.isUndefinedOrNull(numberValue) ? "" : numberValue;
            reasonValue = $A.util.isUndefinedOrNull(reasonValue) ? "" : reasonValue;
            if (countryValue == "" && numberValue == "" && reasonValue == "") {
                returnValue = "fail";
                tableData[indexId].fields[0].tdClassName = "slds-has-error";
                tableData[indexId].fields[1].tdClassName = "slds-has-error";
                tableData[indexId].fields[2].tdClassName = "slds-has-error";
                this.addTaxValidation(component, "Please enter a Foreign Income Tax Information");
            } else if (countryValue == "" && (numberValue != "" || reasonValue != "")) {
                returnValue = "fail";
                tableData[indexId].fields[0].tdClassName = "slds-has-error";
                this.addTaxValidation(component, "Please select a Foreign Income Tax country");
            } else if (numberValue == "" && reasonValue == "") {
                returnValue = "fail";
                tableData[indexId].fields[1].tdClassName = "slds-has-error";
                tableData[indexId].fields[2].tdClassName = "slds-has-error";
                this.addTaxValidation(component, "Please enter a Foreign Income Tax Number OR select a reason why a foreign Income Tax Number has not been supplied");
            }
        }
        component.set("v.tableData", tableData);
        return returnValue;
    },

    addTaxValidation : function(component, errorMsg) {
        var styleClass= "slds-form-element__help validationCss";
        var globalId = component.getGlobalId();
        var elementId = (globalId + "_foreignTaxDataTableView");
        var validationElementId = (elementId + "_Error");
        var errorElement = document.getElementById(elementId)
        var validationElement = document.createElement("div");
        validationElement.setAttribute("id", validationElementId);
        validationElement.setAttribute("class", styleClass);
        validationElement.textContent = errorMsg;
        errorElement.appendChild(validationElement);
    },

    removeTaxValidation : function(component) {
        var globalId = component.getGlobalId();
        var validationElementId = (globalId + "_" + "foreignTaxDataTableView" + "_Error");
        var tableData = component.get("v.tableData");
        for (var indexId in tableData) {
            tableData[indexId].fields[0].tdClassName = "";
            tableData[indexId].fields[1].tdClassName = "";
            tableData[indexId].fields[2].tdClassName = "";
        }
        for (var i = 0; i < 4; i++) {
            if(document.getElementById(validationElementId)) {
                var errorElement = document.getElementById(validationElementId);
                errorElement.parentNode.removeChild(errorElement);
            }
        }
        component.set("v.tableData", tableData);
    },
})