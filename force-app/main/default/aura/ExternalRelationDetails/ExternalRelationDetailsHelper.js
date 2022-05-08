({
    setDeletedExtRel: function (component, deletedItems, fireEvent) {
        var item = [];
        item.push(deletedItems);
        var setEvent = component.getEvent("saveItems");

        setEvent.setParams({
            "deletedExtRelationDet": item
        });

        if (fireEvent) {
            setEvent.fire();
        }
    }
})