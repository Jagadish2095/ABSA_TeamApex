({
    handleInit: function (component) {
        var action = component.get("c.getTriadBehaviourData");
        var applicationId = component.get("v.appId");
        component.set("v.sectionLabel", "Behaviour - Loading...");

        action.setParams({
            "applicationId": applicationId
        });
        action.setCallback(this, function (response) {
            var state = response.getState();

            if (state === "SUCCESS") {
                var responseData = response.getReturnValue();
                component.set("v.triadBehaviour", responseData);
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Triad Behaviour: " + errors[0].message);
                    }
                } else {
                    console.log("Triad Behaviour: Unknown error");
                }
            }
            component.set("v.sectionLabel", "Behaviour");
        });
        $A.enqueueAction(action);
    },

    handleOnRender: function (component) {
        var triadBehaviour = component.get("v.triadBehaviour");
        var previousName = '';
        var triadBehaviourTableBody = '';
        var rowSpanPlaceHolder = 'rowSpanPlaceHolder';
        var rowSpanValue = 1;
        var lastRefresh;

        if (triadBehaviour && triadBehaviour != null) {
            for (var i = 0; i < triadBehaviour.length; i++) {
                if (lastRefresh == null) {
                    lastRefresh = Date.parse(triadBehaviour[i].lastUpdatedDate)
                } else {
                    if (lastRefresh < Date.parse(triadBehaviour[i].lastUpdatedDate)) {
                        lastRefresh = Date.parse(triadBehaviour[i].lastUpdatedDate);
                    }
                }

                if (triadBehaviour[i].clientName == previousName) {
                    //rowSpanValue++;
                    triadBehaviourTableBody += '<tr>';
                    triadBehaviourTableBody += '<td> ' + triadBehaviour[i].clientName + ' </td>';
                    triadBehaviourTableBody += '<td> ' + triadBehaviour[i].clientCode + ' </td>';
                    triadBehaviourTableBody += '<td> ' + triadBehaviour[i].custAlignScore + ' </td>';
                    triadBehaviourTableBody += '<td> ' + triadBehaviour[i].chequeScore + ' </td>';
                    triadBehaviourTableBody += '<td> ' + triadBehaviour[i].creditCardScore + ' </td>';
                    triadBehaviourTableBody += '<td> ' + triadBehaviour[i].mortgageScore + ' </td>';
                    triadBehaviourTableBody += '<td> ' + triadBehaviour[i].avafScore + ' </td>';
                    triadBehaviourTableBody += '<td> ' + triadBehaviour[i].loanScore + ' </td>';
                    triadBehaviourTableBody += '</tr>';
                } else {
                    if (previousName != '') {
                        triadBehaviourTableBody = String(triadBehaviourTableBody).replace("rowSpanPlaceHolder", rowSpanValue);
                        rowSpanValue = 1;
                    }

                    previousName = triadBehaviour[i].clientName;
                    triadBehaviourTableBody += '<tr>';
                    triadBehaviourTableBody += '<td rowspan="rowSpanPlaceHolder" class="clientNameCodeCols"> ' + triadBehaviour[i].clientName + ' </td>';
                    triadBehaviourTableBody += '<td> ' + triadBehaviour[i].clientCode + ' </td>';
                    triadBehaviourTableBody += '<td> ' + triadBehaviour[i].custAlignScore + ' </td>';
                    triadBehaviourTableBody += '<td> ' + triadBehaviour[i].chequeScore + ' </td>';
                    triadBehaviourTableBody += '<td> ' + triadBehaviour[i].creditCardScore + ' </td>';
                    triadBehaviourTableBody += '<td> ' + triadBehaviour[i].mortgageScore + ' </td>';
                    triadBehaviourTableBody += '<td> ' + triadBehaviour[i].avafScore + ' </td>';
                    triadBehaviourTableBody += '<td> ' + triadBehaviour[i].loanScore + ' </td>';
                    triadBehaviourTableBody += '</tr>';
                }
            }
            component.set("v.lastRefresh", lastRefresh);

            if (previousName != '') {
                triadBehaviourTableBody = String(triadBehaviourTableBody).replace("rowSpanPlaceHolder", rowSpanValue);
                triadBehaviourTableBody = String(triadBehaviourTableBody).replace(/undefined/g, "");
            }

            document.getElementById("triadBehaviourTableBody").innerHTML = triadBehaviourTableBody;
        }
    }
})