({
    doInit: function (component, event, helper) {

    },

    onCheckedRemoveDetails: function (component, event, helper) {
        var chkBoxCmp = component.find("chkRemoveLoan");
        var value = chkBoxCmp.get("v.value")

        component.set("v.isActiveExtRelDetails", value);
    },

    removeExternalRelation: function (component, event, helper) {
        var iterItems = component.get("v.newExtRelationDet");
        var accUniqueID = component.find("uniqueID").get("v.value");
        var fireEvent = true;
        var deletedExtRel;
        var itemRemoved;

        if (iterItems != null) {
            for (var i = 0; i < iterItems.length; i++) {
                var item = iterItems[i];

                if (item.UqId == accUniqueID) {
                    var index = iterItems.indexOf(iterItems[i]);
                    itemRemoved = iterItems[i].UqId;
                    deletedExtRel = iterItems[i];

                    //always fire submitMethod only when data has been saved before, ie Id will be populated from salesforce
                    if (item.Id == null) {
                        fireEvent = false;
                    }

                    iterItems.splice(index, 1);
                }
            }

            //change numbering on items remaining
            for (var i = 0; i < iterItems.length; i++) {
                var idCur = iterItems[i].UqId;
                var idPrv;

                if (iterItems.length >= 1 && idCur > 1) {
                    var idNew = --idCur;
                    if (idPrv != idNew) {
                        iterItems[i].UqId = idNew;
                    }
                }

                idPrv = iterItems[i].UqId;
            }
        }

        helper.setDeletedExtRel(component, deletedExtRel, fireEvent);

        component.set("v.newExtRelationDet", iterItems);
        console.log("newExtRelationDet: " + JSON.stringify(component.get("v.newExtRelationDet")));
    }
})