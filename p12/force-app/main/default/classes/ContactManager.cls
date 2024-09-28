@RestResource(urlMapping='/Contact/*')
global with sharing class ContactManager {
    
    // Définition d'une exception personnalisée
    public class CustomException extends Exception {}
    
    @HttpPost
    global static ID createContact() {
        RestRequest req = RestContext.request;
        String requestBody = req.requestBody.toString();
        Contact contact = (Contact) JSON.deserialize(requestBody, SObject.class);
        String email = contact.Email;
        
        List<Contact> existingEmailFromContacts = [
            SELECT Id, Email 
            FROM Contact 
            WHERE Email = :email 
            LIMIT 1
        ];
        
        if (!existingEmailFromContacts.isEmpty()) {
            throw new CustomException('Cette adresse email existe deja sur l\'enregistrement ID = ' + existingEmailFromContacts[0].Id);
          
        } else {
            insert contact;
            return contact.Id;          
        }    
    }    
    
    @HttpPatch
    global static ID updateContact() {
        RestRequest req = RestContext.request;
        String requestBody = req.requestBody.toString();
        Contact contact = (Contact) JSON.deserialize(requestBody, SObject.class);
        String email = contact.Email;
        
        Contact existingEmailFromContacts = [
            SELECT Id, Email 
            FROM Contact 
            WHERE Email = :email
        ];
            
        contact.Id = existingEmailFromContacts.Id;      
        update contact;
        return contact.Id;
    }
      
    @HttpDelete
    global static ID deleteContact() {
        RestRequest req = RestContext.request;
        String requestBody = req.requestBody.toString();
        Contact contact = (Contact) JSON.deserialize(requestBody, SObject.class);
        String email = contact.Email;
        
        Contact existingEmailFromContacts = [
            SELECT Id, Email, isDesactivated__c 
            FROM Contact 
            WHERE Email = :email
        ];
        
        existingEmailFromContacts.isDesactivated__c = true;    
        update existingEmailFromContacts;
        return existingEmailFromContacts.Id;
    }
}