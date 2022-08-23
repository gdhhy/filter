create table wxTarget
(
  targetID   int not null auto_increment,
  wxNo       varchar(100),
  wxName     varchar(255),
  introduce  varchar(1023),
  createTime timestamp,
  lastTime   timestamp
);
create table wxArticle
(
  articleID   int not null auto_increment,
  targetID    int references wxTarget,
  url         varchar(1023),
  title       varchar(255),
  body        text,
  publishTime timestamp
);