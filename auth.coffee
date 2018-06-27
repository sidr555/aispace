###
 * Author: Dmitry Sidorov
 * Email: sidr@sidora.net
 * Date: 06.03.17
###

module.exports = {};
return; 

passport = require('passport');
LocalStrategy = require('passport-local').Strategy;
md5 = require "md5"

Auth = {
    passport: passport
}

Auth.init = (app) ->
    #User = require('./models/user_model.coffee');
    User = app.models.User

    passport.use (new LocalStrategy {
        usernameField: "email",
        passwordField: "password"
    }, (email, password, next) ->
        console.log("AUTH: ", email, password);

        user = User.find {where: {
            email: email
            password: md5 password
        }}, (err, user) ->
            console.log "pasport use find user", err, user
            next err
#        user = new User {email: email}
#        user.checkPassword password, (err, user) ->
#            if err
#                next err
#            else
#                user.load next
    )

    passport.serializeUser (user, next) ->
        console.log "serializeUser", user
        next null, {
            id: user.id
            email: user.email
            #role: user.role
            name: user.name
        }

    passport.deserializeUser (user, next) ->
        console.log "passport.deserializeUser", user
        next null, user


Auth.login = (req, res, next) ->
    console.log "auth.login2", req.body, req.method
    (passport.authenticate 'local', (err, user, info) ->
        console.log "passport authenticate", err, user, info
        if err
            res.error err.message

        else if user
            req.logIn user, (err) ->
                if err
                    res.error err.message
                else
                    console.log "Logged in user", user
                    res.json user
        else
            res.error "???"
    )(req, res, next)


Auth.register = (req, res, next) ->
    user = new User {
        email: req.body.email
    }
    console.log "Register user", user

    user.save {
        email: req.body.email
        password: req.body.password
    }, (err) ->
        if err
            res.error err.message

        else
            req.logIn user, (err) ->
                if err
                    res.error err.message
                else
                    console.log "Registered user", user
                    res.json user

                res.redirect "/"


Auth.remember = (req, res, next) ->
    console.log "Ремембер пассворд"
    user = new User {
        email: req.body.email
    }
    console.log "Remember password", user
    new_pass = "12345"

    user.save {
        email: req.body.email
        password: new_pass
    }, (err) ->
        if err
            req.flash "error", err.message

        else
            req.flash "Пароль изменен на " + new_pass

    res.redirect "/auth/login"




Auth.isUser = (req, res, next) ->
    console.log "isUser?"
    if req.isAuthenticated()
        do next
    else
        req.flash "Для продолжения необходимо авторизоваться"
        res.redirect "/auth/login"

Auth.isAdmin = (req, res, next) ->
    console.log "isSuperAdmin?"
    if req.isAuthenticated()    #and req.isAdmin
        do next
    else
        req.flash "Нужны права администратора магазина"
        res.redirect "/auth/login"

Auth.isSuperAdmin = (req, res, next) ->
    console.log "isSuperAdmin?"
    if req.isAuthenticated() #and req.isAdmin
        do next
    else
        req.flash "Нужны права администратора"
        res.redirect "/auth/login"




module.exports = Auth;