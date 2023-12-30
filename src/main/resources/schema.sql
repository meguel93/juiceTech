create schema if not exists securecapita;

set names UTF8MB4;

USE securecapita;

DROP TABLE IF EXISTS Users;

CREATE TABLE Users
(
    id         BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    first_name varchar(50)     not null,
    last_name  varchar(50)     not null,
    email      varchar(100)    not null,
    password   varchar(255)    not null,
    address    varchar(255)    not null,
    phone      varchar(30)     not null,
    title      varchar(50)     not null,
    bio        varchar(255)    not null,
    enabled    boolean      default false,
    non_locked boolean      default true,
    using_mfa  boolean      default false,
    created_at DATETIME     DEFAULT CURRENT_TIMESTAMP,
    image_url  varchar(255) default 'https://cdn-icons-png.flaticon.com/512/149/149071.png',
    constraint UQ_Users_Email unique (email)
);

DROP TABLE IF EXISTS Roles;

CREATE TABLE Roles
(
    id         BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name       varchar(50)     not null,
    permission varchar(255)    not null,
    constraint UQ_Roles_Name unique (name)
);

DROP TABLE IF EXISTS UserRoles;

CREATE TABLE UserRoles
(
    id      BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT UNSIGNED NOT NULL,
    role_id BIGINT UNSIGNED NOT NULL,
    foreign key (user_id) references Users (id) on delete cascade on update cascade,
    foreign key (role_id) references Roles (id) on delete restrict on update cascade,
    constraint UQ_UserRoles_User_Id unique (user_id)
);

DROP TABLE IF EXISTS Events;

CREATE TABLE Events
(
    id          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    type        varchar(50)     not null check ( type in
                                                 ('LOGIN_ATTEMPT', 'LOGIN_ATTEMPT_FAILURE', 'LOGIN_ATTEMPT_SUCCESS',
                                                  'PROFILE_UPDATE', 'PROFILE_PICTURE_UPDATE', 'ROLE_UPDATE',
                                                  'ACCOUNT_SETTINGS_UPDATE', 'PASSWORD_UPDATE', 'MFA_UPDATE') ),
    description varchar(255)    not null,
    constraint UQ_Events_Type unique (type)
);

DROP TABLE IF EXISTS UserEvents;

CREATE TABLE UserEvents
(
    id         BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_id    BIGINT UNSIGNED NOT NULL,
    event_id   BIGINT UNSIGNED NOT NULL,
    device     varchar(100) default null,
    ip_address varchar(100) default null,
    created_at DATETIME     DEFAULT CURRENT_TIMESTAMP,
    foreign key (user_id) references Users (id) ON DELETE CASCADE ON UPDATE CASCADE,
    foreign key (event_id) references Events (id) ON DELETE RESTRICT ON UPDATE CASCADE
);

DROP TABLE IF EXISTS AccountVerifications;

CREATE TABLE AccountVerifications
(
    id      BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT UNSIGNED NOT NULL,
    url     varchar(255)    not NULL,
    foreign key (user_id) references Users (id) ON DELETE CASCADE ON UPDATE CASCADE,
    constraint UQ_AccountVerifications_User_Id unique (user_id),
    constraint UQ_AccountVerifications_Url unique (url)

);

DROP TABLE IF EXISTS ResetPasswordVerifications;

CREATE TABLE ResetPasswordVerifications
(
    id              BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_id         BIGINT UNSIGNED NOT NULL,
    url             varchar(255)    not NULL,
    expiration_date datetime        not null,
    foreign key (user_id) references Users (id) ON DELETE CASCADE ON UPDATE CASCADE,
    constraint UQ_ResetPasswordVerifications_User_Id unique (user_id),
    constraint UQ_ResetPasswordVerifications_Url unique (url)

);

DROP TABLE IF EXISTS TwoFactorVerifications;

CREATE TABLE TwoFactorVerifications
(
    id              BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_id         BIGINT UNSIGNED NOT NULL,
    code            varchar(10)     not NULL,
    expiration_date datetime        not null,
    foreign key (user_id) references Users (id) ON DELETE CASCADE ON UPDATE CASCADE,
    constraint UQ_TwoFactorVerifications_User_Id unique (user_id),
    constraint UQ_TwoFactorVerifications_Code unique (code)

);








































