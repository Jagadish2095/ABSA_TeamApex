({
    removeLeaseRecord: function (component, event) {
        var rowindex = component.get("v.rowindex");
        var currentLeaseRecord = component.get("v.currentLeaseRecord");
        var leaseRecordList = component.get("v.leaseRecordList");

        leaseRecordList.splice(rowindex, 1);
        component.set("v.leaseRecordList", leaseRecordList);

        if (currentLeaseRecord.Id) {
            var deletedLeaseRecordList = component.get("v.deletedLeaseRecordList");
            deletedLeaseRecordList.push(currentLeaseRecord);
            component.set("v.deletedLeaseRecordList", deletedLeaseRecordList);
        }
    }
});