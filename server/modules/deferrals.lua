local home <const> = [==[{
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
}]==]

local register <const> = [==[{
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

local awaiting <const> = [==[{

}]==]

local function RegisterCard(d, callback)
    Wait(50)
    d.presentCard(register, function(rdata, raw)
        print(json.encode(data, { indent = true }))
        if rdata.submit_type == 'cancel' then callback(d) end
        if rdata.submit_type == 'register' then
            local username, password, cpassword = rdata.username, rdata.password, rdata.confirm_password

            if not username or not password or not cpassword then
                d.update("Veuillez remplir tous les champs")
                Wait(1000)
                return RegisterCard(d, callback)
            end

            if password ~= cpassword then
                d.update("Les mots de passe ne correspondent pas")
                Wait(1000)
                return RegisterCard(d, callback)
            end

            ---@todo SQL method to check if user exists
        end
    end)
end

local function HomeCard(d)
    Wait(100)
    d.presentCard(home, function(data, raw)
        if not data or data.submitId == 'quit' then
            d.done("Merci de la visite, à bientôt !")
            return CancelEvent()
        end

        if data.submitId == 'login' then
            ---@todo SQL method to check if user exists
        elseif data.submitId == 'register' then
            Wait(50)
            RegisterCard(d, HomeCard)
        end

        print(json.encode(data, { indent = true }))
    end)
end

return function(_source, name, setKickReason, d)
    d.defer()
    Wait(500)
    HomeCard(d)
end
