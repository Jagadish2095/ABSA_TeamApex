({
    removeLeaseRecord: function (component, event) {
        var rowindex = component.get("v.rowindex");
        var currentLeaseRecord = component.get("v.currentLeaseRecord");
        var otherLeaseRecordList = component.get("v.otherLeaseRecordList");

        otherLeaseRecordList.splice(rowindex, 1);
        component.set("v.otherLeaseRecordList", otherLeaseRecordList);

        if (currentLeaseRecord.Id) {
            var deletedLeaseRecordList = component.get("v.deletedLeaseRecordList");
            deletedLeaseRecordList.push(currentLeaseRecord);
            component.set("v.deletedLeaseRecordList", deletedLeaseRecordList);
        }
    }
});