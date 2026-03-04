import Foundation

struct Livre {
    var titre: String
    var auteur: String
    var codeISBN: String
    var disponible: Bool = true
}

struct Utilisateur {
    var nom: String
    var id: String
    var livresEmpruntes: [String] = []

    mutating func livreEmprunte(isbn: String) {
        livresEmpruntes.append(isbn)
    }

    mutating func livreRetour(isbn: String) {
        if let index = livresEmpruntes.firstIndex(of: isbn) {
            livresEmpruntes.remove(at: index)
        }
    }
}

struct Bibliotheque {

    var livres: [String: Livre] = [:]
    var utilisateurs: [String: Utilisateur] = [:]

    mutating func ajoutLivre(livre: Livre) {
        if livres[livre.codeISBN] != nil {
            print("Erreur : le livre (ISBN \(livre.codeISBN)) existe déjà.")
            return
        }
        livres[livre.codeISBN] = livre
        print("Livre ajouté : \(livre.titre)")
    }

    mutating func enregistrerUtilisateur(utilisateur: Utilisateur) {
        if utilisateurs[utilisateur.id] != nil {
            print("Erreur : l'utilisateur (ID \(utilisateur.id)) existe déjà.")
            return
        }
        utilisateurs[utilisateur.id] = utilisateur
        print("Utilisateur enregistré : \(utilisateur.nom)")
    }

    mutating func prendreLivre(isbn: String, utilisateurId: String) {

        guard var livre = livres[isbn] else {
            print("Erreur : livre introuvable (ISBN \(isbn)).")
            return
        }

        guard var user = utilisateurs[utilisateurId] else {
            print("Erreur : utilisateur introuvable (ID \(utilisateurId)).")
            return
        }

        if !livre.disponible {
            print("Erreur : livre non disponible.")
            return
        }

        user.livreEmprunte(isbn: isbn)
        livre.disponible = false

        // update dictionnaires
        livres[isbn] = livre
        utilisateurs[utilisateurId] = user

        print("\(user.nom) a emprunté « \(livre.titre) »")
    }

    mutating func livreRetour(isbn: String, utilisateurId: String) {

        guard var livre = livres[isbn] else {
            print("Erreur : livre introuvable (ISBN \(isbn)).")
            return
        }

        guard var user = utilisateurs[utilisateurId] else {
            print("Erreur : utilisateur introuvable (ID \(utilisateurId)).")
            return
        }

        guard user.livresEmpruntes.contains(isbn) else {
            print("Erreur : ce livre n'a pas été emprunté par cet utilisateur.")
            return
        }


        //mise à jour des données dans les structures
        user.livreRetour(isbn: isbn)
        livre.disponible = true

        //update les données dans les dictionnaires
        livres[isbn] = livre
        utilisateurs[utilisateurId] = user

        print("\(user.nom) a retourné « \(livre.titre) »")
    }





    func listerLivresDisponibles() {
        print("Livres disponibles :")
        for (_, livre) in livres where livre.disponible {
            print("- \(livre.titre) | \(livre.auteur) | ISBN: \(livre.codeISBN)")
        }
    }



    func listerLivresEmpruntes(utilisateurId: String) {
        guard let user = utilisateurs[utilisateurId] else {
            print("Erreur : utilisateur introuvable (ID \(utilisateurId)).")
            return
        }

        print("Livres empruntés par \(user.nom) :")
        if user.livresEmpruntes.isEmpty {
            print("Aucun livre emprunté.")
            return
        }

        for isbn in user.livresEmpruntes {
            if let livre = livres[isbn] {
                print("- \(livre.titre) | ISBN: \(isbn)")
            } else {
                print("- ISBN: \(isbn) (introuvable)")
            }
        }
    }
}

func lire(_ message: String) -> String {
    print(message, terminator: "")
    return readLine() ?? ""
}

var biblio = Bibliotheque()





biblio.ajoutLivre(livre: Livre(
    titre: "Catalogue Mercedes 230 CE / 280 CE W123",
    auteur: "Mercedes-Benz",
    codeISBN: "MB-W123-1979"
))

biblio.ajoutLivre(livre: Livre(
    titre: "Brochure Mercedes Classe E W124",
    auteur: "Mercedes-Benz",
    codeISBN: "MB-W124-1985"
))

biblio.ajoutLivre(livre: Livre(
    titre: "Catalogue Mercedes 300D W123",
    auteur: "Mercedes-Benz",
    codeISBN: "MB-W123-300D"
))

biblio.ajoutLivre(livre: Livre(
    titre: "Brochure Mercedes 190E W201",
    auteur: "Mercedes-Benz",
    codeISBN: "MB-W201-190E"
))

biblio.enregistrerUtilisateur(utilisateur: Utilisateur(nom: "Ihab", id: "U001"))
biblio.enregistrerUtilisateur(utilisateur: Utilisateur(nom: "Pape", id: "U002"))



while true {
    print("""
    \n========== CinqoCars ==========
    1) Ajouter un livre
    2) Enregistrer un utilisateur
    3) Emprunter un livre
    4) Retourner un livre
    5) Lister les livres disponibles
    6) Lister les livres empruntés (user)
    0) Quitter
    """)

    let choix = lire("Votre choix: ")

    switch choix {
    case "1":
        let titre = lire("Titre: ")
        let auteur = lire("Auteur: ")
        let isbn = lire("ISBN: ")
        biblio.ajoutLivre(livre: Livre(titre: titre, auteur: auteur, codeISBN: isbn))

    case "2":
        let nom = lire("Nom: ")
        let id = lire("ID: ")
        biblio.enregistrerUtilisateur(utilisateur: Utilisateur(nom: nom, id: id))

    case "3":
        let userId = lire("ID utilisateur: ")
        let isbn = lire("ISBN du catalogue: ")
        biblio.prendreLivre(isbn: isbn, utilisateurId: userId)

    case "4":
        let userId = lire("ID utilisateur: ")
        let isbn = lire("ISBN du catalogue: ")
        biblio.livreRetour(isbn: isbn, utilisateurId: userId)

    case "5":
        biblio.listerLivresDisponibles()

    case "6":
        let userId = lire("ID utilisateur: ")
        biblio.listerLivresEmpruntes(utilisateurId: userId)

    case "0":
        print("Adios !")
        break

    default:
        print("Choix invalide.")
    }

    if choix == "0" { break }
}


