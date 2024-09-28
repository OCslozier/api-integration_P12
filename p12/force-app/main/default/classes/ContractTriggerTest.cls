@IsTest
public class ContractTriggerTest {

    @IsTest
    static void testUpdateUuidOnContractInsert() {
        
        Account testAccount = TestDataFactory.createAccount();
        Id recordID = TestAccount.Id;  

        // Création d'un contrat sans l'insérer immédiatement
        Contract testContract = new Contract(
            AccountId = recordID,
            Status = 'Draft',
            StartDate = Date.valueOf('2024-04-29'),
            ContractTerm = 36,
            UUID__c = null
        );

        Test.startTest();
        insert testContract; // exécution du trigger before insert
        Test.stopTest();

        // Récupération du contact inséré pour vérification
        Contract insertedContract = [SELECT Id, UUID__c FROM Contract WHERE Id = :testContract.Id];

        // Vérifier si UUID__c est alimenté
        Assert.isNotNull(insertedContract.UUID__c, 'UUID__c doit être renseigné.');
        Assert.AreEqual(36, insertedContract.UUID__c.length(), 'UUID__c doit être composé de 36 caractères');
    }
}