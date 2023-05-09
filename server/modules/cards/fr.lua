return {
    home = [==[{
        "$schema": "http://adaptivecards.io/schemas/adaptive-card.json",
        "type": "AdaptiveCard",
        "version": "1.4",
        "body": [
            {
                "type": "TextBlock",
                "text": "Connexion au serveur",
                "weight": "Bolder",
                "size": "Large"
            },
            {
                "type": "TextBlock",
                "text": "Bienvenue sur le serveur, veuillez vous connecter ou créer un nouveau compte!",
                "wrap": true
            },
            {
                "type": "Input.Text",
                "id": "username",
                "placeholder": "Nom d'utilisateur",
                "isVisible": true
            },
            {
                "type": "Input.Text",
                "id": "password",
                "placeholder": "Mot de passe",
                "isPassword": true,
                "isVisible": true
            }
        ],
        "actions": [
            {
                "id": "login",
                "type": "Action.Submit",
                "title": "Se connecter"
            },
            {
                "id": "register",
                "type": "Action.Submit",
                "title": "Créer un compte"
            },
            {
                "id": "quit",
                "type": "Action.Submit",
                "title": "Quitter"
            }
        ]
    }]==],
    register = [==[{
        "$schema": "http://adaptivecards.io/schemas/adaptive-card.json",
        "type": "AdaptiveCard",
        "version": "1.4",
        "body": [
            {
                "type": "TextBlock",
                "text": "Créer un compte",
                "weight": "Bolder",
                "size": "Large"
            },
            {
                "type": "TextBlock",
                "text": "Veuillez entrer vos informations de connexion ou créer un nouveau compte",
                "wrap": true
            },
            {
                "type": "Input.Text",
                "id": "username",
                "placeholder": "Nom d'utilisateur",
                "isVisible": true
            },
            {
                "type": "Input.Text",
                "id": "password",
                "placeholder": "Mot de passe",
                "isPassword": true,
                "isVisible": true
            },
            {
                "type": "Input.Text",
                "id": "confirm_password",
                "placeholder": "Confirmer le mot de passe",
                "isPassword": true,
                "isVisible": true
            }
        ],
        "actions": [
            {
                "type": "Action.Submit",
                "title": "Soumettre",
                "data": {
                    "submit_type": "register"
                }
            },
            {
                "type": "Action.Submit",
                "title": "Annuler",
                "data": {
                    "submit_type": "cancel"
                }
            }
        ]
    }]==]
}