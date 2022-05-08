({
	handleInit : function(component) {
		var action = component.get("c.getTriadRelationshipData");
		var applicationId = component.get("v.appId");
        component.set("v.sectionLabel", "Relationship - Loading...");

		action.setParams({
			"applicationId":applicationId
		});
		action.setCallback(this, function(response){
			var state = response.getState();

			if(state === "SUCCESS"){
                var responseData = response.getReturnValue();
                component.set("v.triadRelationship", responseData);


			} else if (state === "ERROR") {
                var errors = response.getError();
				if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Triad Relationship: " + errors[0].message);
                    }
                } else {
                    console.log("Triad Relationship: Unknown error");
                }
			}
        	component.set("v.sectionLabel", "Relationship");
		});
        $A.enqueueAction(action);
	},
    handleOnRender : function(component){
    	var triadRelationship = component.get("v.triadRelationship");
        var previousName = '';
        var triadRelationshipTableBody = '';
        var rowSpanPlaceHolder = 'rowSpanPlaceHolder';
        var rowSpanValue = 1;
        var lastRefresh;

        if(triadRelationship && triadRelationship != null){
            for(var i = 0; i < triadRelationship.length; i++){
                if(lastRefresh == null){
                    lastRefresh = Date.parse(triadRelationship[i].lastUpdatedDate)
                } else{
                    if(lastRefresh < Date.parse(triadRelationship[i].lastUpdatedDate)){
                        lastRefresh = Date.parse(triadRelationship[i].lastUpdatedDate);
                    }
                }
                console.log('triadRelationship[i].clientName'+triadRelationship[i].clientName);
                if(triadRelationship[i].clientName == previousName){
                    //rowSpanValue++;
                    triadRelationshipTableBody += '<tr>';
                    triadRelationshipTableBody += '<td> ' + triadRelationship[i].clientName + ' </td>';
                    triadRelationshipTableBody += '<td> ' + triadRelationship[i].clientCode + ' </td>';
                    triadRelationshipTableBody += '<td> ' + triadRelationship[i].monthsSinceOldestRel + ' </td>';
                    triadRelationshipTableBody += '<td> ' + triadRelationship[i].monthsSinceOldestAcc + ' </td>';
                    triadRelationshipTableBody += '<td> ' + triadRelationship[i].monthsSinceOldestChqAcc + ' </td>';
                    triadRelationshipTableBody += '<td> ' + triadRelationship[i].monthsSinceOldestSavAcc + ' </td>';
                    triadRelationshipTableBody += '<td> ' + triadRelationship[i].dateFirstRel + ' </td>';
                    triadRelationshipTableBody += '<td> ' + triadRelationship[i].dateOldestAccOpened + ' </td>';
                    triadRelationshipTableBody += '<td> ' + triadRelationship[i].dateOldestChqAccOpened + ' </td>';
                    triadRelationshipTableBody += '<td> ' + triadRelationship[i].dateOldestSavAccOpened + ' </td>';
                    triadRelationshipTableBody += '</tr>';
                } else{
                    if(previousName != ''){
                        triadRelationshipTableBody = String(triadRelationshipTableBody).replace("rowSpanPlaceHolder", rowSpanValue);
                        rowSpanValue = 1;
                    }

                    previousName = triadRelationship[i].clientName;
                    console.log('previousName'+previousName);
                    triadRelationshipTableBody += '<tr>';
                    triadRelationshipTableBody += '<td rowspan="rowSpanPlaceHolder" class="clientNameCodeCols"> ' + triadRelationship[i].clientName + ' </td>';
                    triadRelationshipTableBody += '<td> ' + triadRelationship[i].clientCode + ' </td>';
                    triadRelationshipTableBody += '<td> ' + triadRelationship[i].monthsSinceOldestRel + ' </td>';
                    triadRelationshipTableBody += '<td> ' + triadRelationship[i].monthsSinceOldestAcc + ' </td>';
                    triadRelationshipTableBody += '<td> ' + triadRelationship[i].monthsSinceOldestChqAcc + ' </td>';
                    triadRelationshipTableBody += '<td> ' + triadRelationship[i].monthsSinceOldestSavAcc + ' </td>';
                    triadRelationshipTableBody += '<td> ' + triadRelationship[i].dateFirstRel + ' </td>';
                    triadRelationshipTableBody += '<td> ' + triadRelationship[i].dateOldestAccOpened + ' </td>';
                    triadRelationshipTableBody += '<td> ' + triadRelationship[i].dateOldestChqAccOpened + ' </td>';
                    triadRelationshipTableBody += '<td> ' + triadRelationship[i].dateOldestSavAccOpened + ' </td>';
                    triadRelationshipTableBody += '</tr>';
                }
            }
            component.set("v.lastRefresh", lastRefresh);

            if(previousName != ''){
                triadRelationshipTableBody = String(triadRelationshipTableBody).replace("rowSpanPlaceHolder", rowSpanValue);
                triadRelationshipTableBody = String(triadRelationshipTableBody).replace(/undefined/g, "");
            }

            if(document.getElementById("triadRelationshipTableBody")){
                document.getElementById("triadRelationshipTableBody").innerHTML = triadRelationshipTableBody;
            }
        }
    }
})