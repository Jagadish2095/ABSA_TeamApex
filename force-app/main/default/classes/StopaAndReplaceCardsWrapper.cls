/*
Wrapper to display cards along with transactions
*
* @author  Madhava Palla : Absa
* @version v1.0
* @since   2019-10-31
*/

Public Class StopaAndReplaceCardsWrapper {
       @AuraEnabled Public String productName;
       @AuraEnabled Public String productType;
       @AuraEnabled Public String plasticCardNum;
       @AuraEnabled Public List<PlasticCardDetils> plasticCardsList;
       @AuraEnabled Public List<TransactionsDetails> transcactionList;
        Public Class PlasticCardDetils{
             Public String plasticCardNumber;
             Public String plasticCardHolderName;
        }
        Public Class TransactionsDetails{
            Public String transactionDescription;
            Public String transactionDate;
            Public String transactionAmount;
        }
        
        public static StopaAndReplaceCardsWrapper dummyWrapperResponse(){
            StopaAndReplaceCardsWrapper wrapper = new StopaAndReplaceCardsWrapper();
            wrapper.plasticCardNum ='12345';
            wrapper.productName ='CA';
            wrapper.productType ='CA';
            StopaAndReplaceCardsWrapper.PlasticCardDetils plsDet = new StopaAndReplaceCardsWrapper.PlasticCardDetils();
            plsDet.plasticCardNumber='12345';
            plsDet.plasticCardHolderName='test';
            StopaAndReplaceCardsWrapper.TransactionsDetails traDet = new StopaAndReplaceCardsWrapper.TransactionsDetails();
            traDet.transactionDescription='12345';
            traDet.transactionDate='20190909';
            traDet.transactionAmount='1234';
            //wrapper.plasticCardsList
            return wrapper;
        }
}