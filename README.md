# micasend
système de transfert de message dans le terminale pour les MIC A !!
il suffit juste de télécharger le fichier "micasend_client.sh", de le rendre executable ou de le mettre dans le /bin pour l'utiliser sur toute la machine.

## Configuration
Il est nécessaire d'avoir curl sur sa machine pour faire fonctionner le script
```bash
apt install curl
```
dans le fichier "micasend.sh" :
```bash
host="le serveur distant communiqué par votre administrateur"
user="votre nom d'utilisateur"
```
On peut également ajouter le token si on a un compte sur l'instance
```bash
token="token donné par votre administrateur correspondant a votre pseudo si vous êtes un utilisateur vérifié"
```

## Utilisation
En tant que modérateur, lancer le script avec l'argument -m vous permet d'acceder au modérator mode
Si vous êtes modérateur les commandes :
```bash
#supprimer un message avec son id
/delmsg 33

#ajouter un utilisateur, le 0 correspond au grade : 0 à 10 rien, 11 bot, 15 admin 
/adduser un_nom_d_utilisateur 0

#voir les utilisateurs
/showuser

#modifier une valeur dans la table utilisateur (par exemple le nouveau pseudo de l'utilisateur dont l'id est 3 seras pseudo)
/upuser 3 pseudo nouveau pseudo
```
