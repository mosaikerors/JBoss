/*==============================================================*/
/* DBMS name:      MySQL 5.0                                    */
/* Created on:     19-5-8 13:34:04                              */
/*==============================================================*/


drop table if exists Administrator;

drop table if exists BanRecord;

drop table if exists Battle;

drop table if exists Card;

drop table if exists Collect;

drop table if exists Compose;

drop table if exists Deck;

drop table if exists Player;

drop table if exists User;

/*==============================================================*/
/* Table: Administrator                                         */
/*==============================================================*/
create table Administrator
(
   userId               int not null,
   primary key (userId)
);

/*==============================================================*/
/* Table: BanRecord                                             */
/*==============================================================*/
create table BanRecord
(
   adminId              int not null,
   playerId             int not null,
   liftBanAt            datetime not null,
   primary key (adminId, playerId)
);

/*==============================================================*/
/* Table: Battle                                                */
/*==============================================================*/
create table Battle
(
   playerA              int not null,
   playerB              int not null,
   time                 datetime not null,
   winner               int not null,
   primary key (playerA, playerB, time)
);

/*==============================================================*/
/* Table: Card                                                  */
/*==============================================================*/
create table Card
(
   cardId               int not null,
   cardname             varchar(45) not null,
   description          text,
   type                 varchar(45) not null,
   rarity               varchar(45) not null,
   primary key (cardId)
);

/*==============================================================*/
/* Table: Collect                                               */
/*==============================================================*/
create table Collect
(
   userId               int not null,
   cardId               int not null,
   number               int not null,
   primary key (userId, cardId)
);

/*==============================================================*/
/* Table: Compose                                               */
/*==============================================================*/
create table Compose
(
   userId               int not null,
   deckId               int not null,
   cardId               int not null,
   primary key (userId, deckId, cardId)
);

/*==============================================================*/
/* Table: Deck                                                  */
/*==============================================================*/
create table Deck
(
   userId               int not null,
   deckId               int not null,
   primary key (userId, deckId)
);

/*==============================================================*/
/* Table: Player                                                */
/*==============================================================*/
create table Player
(
   userId               int not null,
   nickname             varchar(45) not null,
   `rank`                 int not null,
   recharge             float not null,
   streak               int not null,
   primary key (userId)
);

/*==============================================================*/
/* Table: User                                                  */
/*==============================================================*/
create table User
(
   userId               int not null,
   username             varchar(45) not null,
   password             varchar(45) not null,
   email                varchar(45),
   phone                varchar(45),
   primary key (userId)
);

alter table Administrator add constraint FK_Inheritance_1 foreign key (userId)
      references User (userId) on delete restrict on update restrict;

alter table BanRecord add constraint FK_BanRecord foreign key (adminId)
      references Administrator (userId) on delete restrict on update restrict;

alter table BanRecord add constraint FK_BanRecord2 foreign key (playerId)
      references Player (userId) on delete restrict on update restrict;

alter table Battle add constraint FK_Battle foreign key (playerA)
      references Player (userId) on delete restrict on update restrict;

alter table Battle add constraint FK_Battle2 foreign key (playerB)
      references Player (userId) on delete restrict on update restrict;

alter table Collect add constraint FK_Collect foreign key (userId)
      references Player (userId) on delete restrict on update restrict;

alter table Collect add constraint FK_Collect2 foreign key (cardId)
      references Card (cardId) on delete restrict on update restrict;

alter table Compose add constraint FK_Compose foreign key (userId, deckId)
      references Deck (userId, deckId) on delete restrict on update restrict;

alter table Compose add constraint FK_Compose2 foreign key (cardId)
      references Card (cardId) on delete restrict on update restrict;

alter table Deck add constraint FK_Build foreign key (userId)
      references Player (userId) on delete restrict on update restrict;

alter table Player add constraint FK_Inheritance_2 foreign key (userId)
      references User (userId) on delete restrict on update restrict;

