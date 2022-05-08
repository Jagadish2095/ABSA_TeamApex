@isTest
private class DocumentSelectorTest {

    @isTest
    private static void testSelectById() {
        DocumentSelector docSelect = new DocumentSelector();
        Set<Id> idSet = new Set<Id>();
        List<Document> docList = docSelect.selectById(idSet);
        System.assertEquals(0,docList.size());
    }

    @isTest
    private static void testSelectAll() {
        DocumentSelector docSelect = new DocumentSelector();
        List<Document> docList = docSelect.selectAll();
        System.assertEquals(0,docList.size());
    }

    @isTest
    private static void testselectByName() {
        DocumentSelector docSelect = new DocumentSelector();
        Set<String> stringSet = new Set<String>();
        List<Document> docList = docSelect.selectByName(stringSet);
        System.assertEquals(0,docList.size());
    }
}