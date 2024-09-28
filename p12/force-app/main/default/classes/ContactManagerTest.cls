@IsTest
public class ContactManagerTest {

    @IsTest
    static void testCreateContactWithNoExistingEmail() {

        // Création d'un contact
        Contact testContact = TestDataFactory.createContact();
        Id recordId = testContact.Id;

        // Vérification de la création du contact et de ses attributs
        Contact createdContact = [SELECT Id, FirstName, LastName, Email FROM Contact WHERE Id = :recordId];
        Assert.AreEqual('Test', createdContact.FirstName);
        Assert.AreEqual('User', createdContact.LastName);
        Assert.AreEqual('test@openclassroom.com', createdContact.Email);

        // Simuler une requête HTTP POST
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        // Préparer un contact JSON
        String jsonContact = '{"attributes": {"type": "Contact"}, "LastName": "Lozier", "FirstName": "Sebastien", "Email": "seb@openclassroom.com"}';

        // Simuler la requête REST
        req.requestBody = Blob.valueOf(jsonContact);
        RestContext.request = req;       
        RestContext.response = res;

        Test.startTest();

        ID contactId = ContactManager.createContact();

        Test.stopTest();

        // Vérification que l'enregistrement a été créé
        Contact createdRecord = [SELECT Id, FirstName, LastName, Email FROM Contact WHERE Id = :contactId];
        Assert.AreEqual('Sebastien', createdRecord.FirstName);
        Assert.AreEqual('Lozier', createdRecord.LastName);
        Assert.AreEqual('seb@openclassroom.com', createdRecord.Email);
    }

    @IsTest
    static void testCreateContactWithExistingEmail() {

        // Création d'un contact
        Contact testContact = TestDataFactory.createContact();
        Id recordId = testContact.Id;

        // Vérification de la création du contact et de ses attributs
        Contact createdContact = [SELECT Id, FirstName, LastName, Email FROM Contact WHERE Id = :recordId];
        Assert.AreEqual('Test', createdContact.FirstName);
        Assert.AreEqual('User', createdContact.LastName);
        Assert.AreEqual('test@openclassroom.com', createdContact.Email);

        // Simuler une requête HTTP POST avec un contact ayant le même email
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        // Préparer un contact JSON
        String jsonContact = '{"attributes": {"type": "Contact"}, "LastName": "Lozier", "FirstName": "Sebastien", "Email": "test@openclassroom.com"}';

        // Simuler la requête REST
        req.requestBody = Blob.valueOf(jsonContact);
        RestContext.request = req;       
        RestContext.response = res;

        Test.startTest();
		
        Boolean hasError = false;
        String errorMessage = '';
        try{
            
           ContactManager.createContact();
            
        }catch(Exception e){
            hasError = true;
            errorMessage = e.getMessage();                     
        }
        
        Test.stopTest();
              
        // Vérification qu'une erreur a été générée et que l'id est bien dans le message
        List<Contact> ExistingContact = [Select id, Email from contact where Email = 'test@openclassroom.com' LIMIT 1];
        
        Assert.areEqual(true, hasError);
        Assert.isTrue(errorMessage.contains(ExistingContact[0].id));

    }

    @IsTest
    static void testUpdateContact() {

        Contact testContact = TestDataFactory.createContact();
        Id recordId = testContact.Id;

        // Vérification de la création du contact et de ses attributs
        Contact createdContact = [SELECT Id, FirstName, LastName, Email FROM Contact WHERE Id = :recordId];
        Assert.AreEqual('Test', createdContact.FirstName);
        Assert.AreEqual('User', createdContact.LastName);
        Assert.AreEqual('test@openclassroom.com', createdContact.Email);

        // Simuler une requête HTTP POST
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        // Préparer un contact JSON
        String jsonContact = '{"attributes": {"type": "Contact"}, "LastName": "Lozier", "FirstName": "Sebastien", "Email": "test@openclassroom.com"}';

        // Simuler la requête REST
        req.requestBody = Blob.valueOf(jsonContact);
        RestContext.request = req;       
        RestContext.response = res;

        Test.startTest();

        ID contactId = ContactManager.updateContact();

        Test.stopTest();

        // Vérification si l'enregistrement a bien été modifié
        Contact updatedContact = [SELECT Id, FirstName, LastName, Email FROM Contact WHERE id = :contactId];
        Assert.AreEqual('Sebastien', updatedContact.FirstName);
        Assert.AreEqual('Lozier', updatedContact.LastName);
        Assert.AreEqual('test@openclassroom.com', updatedContact.Email);
    }

    @IsTest
    static void testDeleteContact() {

        Contact testContact = TestDataFactory.createContact();

        Contact existingContactId = [SELECT Id FROM Contact WHERE Email = 'test@openclassroom.com'];
        ID recordId = existingContactId.Id;

        // Vérification de la création du contact et de ses attributs
        Contact createdContact = [SELECT Id, FirstName, LastName, Email FROM Contact WHERE Id = :recordId];
        Assert.AreEqual('Test', createdContact.FirstName);
        Assert.AreEqual('User', createdContact.LastName);
        Assert.AreEqual('test@openclassroom.com', createdContact.Email);

        // Simuler une requête HTTP POST
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        // Préparer un contact JSON
        String jsonContact = '{"attributes": {"type": "Contact"}, "Email": "test@openclassroom.com"}';

        // Simuler la requête REST
        req.requestBody = Blob.valueOf(jsonContact);
        RestContext.request = req;       
        RestContext.response = res;

        Test.startTest();

        ContactManager.deleteContact();

        Test.stopTest();

        // Vérification que l'enregistrement n'a pas été supprimé mais bien mis à jour
        Contact deletedContact = [SELECT Id, isDesactivated__c FROM Contact WHERE Id = :recordId];     
        Assert.AreEqual(deletedContact.id, recordId);
        Assert.AreEqual(true, deletedContact.isDesactivated__c);
    }
}