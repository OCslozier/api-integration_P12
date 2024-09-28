@IsTest
public class ContactTriggerTest {

    @IsTest
    static void testUpdateUuidOnContactInsert() {

        // Création d'un contact sans l'insérer immédiatement
        Contact testContact = new Contact(
            FirstName = 'Test',
            LastName = 'User',
            Email = 'test@openclassroom.com',
            UUID__c = null
        );

        Test.startTest();
        insert testContact; // exécution du trigger before insert
        Test.stopTest();

        // Récupération du contact inséré pour vérification
        Contact insertedContact = [SELECT Id, UUID__c FROM Contact WHERE Id = :testContact.Id];

        // Vérifier si UUID__c est alimenté
        Assert.isNotNull(insertedContact.UUID__c, 'UUID__c doit être renseigné.');
        Assert.AreEqual(36, insertedContact.UUID__c.length(), 'UUID__c doit être composé de 36 caractères');
    }
}