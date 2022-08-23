drop table Regular;
create table regular
(/*正规式配置*/
  regularID   int          not null auto_increment,
  regularName varchar(255) not null,
  paragraph   varchar(255) not null,
  charset     varchar(20)  not null comment '字符集',
  warnKeyword varchar(255) not null comment '报警关键字',
  settingTime TIMESTAMP DEFAULT now() COMMENT '设置时间',
  pattern     json COMMENT '指向Pattern',
  CONSTRAINT PK_regularID PRIMARY KEY (regularID)
) engine = MyISAM;
insert into regular(regularName, charset, regex, paragraph)
values ('默认', 'UTF-8', '{}', '(?:<div class=\"text\">)(?<paragraph>[\\s|\\S]+?)(?:</div>)', '<a href=\"tel:(?<qq>\\d+?)\">\\k<qq></a>',
        '<a href=\"https://t.me/(?<telegram2>\\w+?)\">(?<telegram>@\\w+?)</a>');
values
('默认', 'UTF-8', '{}', '(?:<div class=\"text\">)(?<paragraph>[\\s|\\S]+?)(?:</div>)', '<a href=\"tel:(?<qq>\\d+?)\">\\k<qq></a>',
  '<a href=\"https://t.me/(?<telegram2>\\w+?)\">(?<telegram>@\\w+?)</a>');

DROP TABLE source;
CREATE TABLE source /*源文件，只接受压缩文件zip、7z、rar*/
(
  sourceID       int          NOT NULL AUTO_INCREMENT COMMENT '唯一标识',
  source         VARCHAR(255) NULL COMMENT '搜集来源，上传时人工输入',
  regularID      int references regular (regularID),
  filename       VARCHAR(255) NOT NULL COMMENT '文件名',
  path           VARCHAR(255) NOT NULL COMMENT '路径',
  size           int COMMENT '文件尺寸',
  htmlCount      int comment 'html文件数',
  uploadTime     TIMESTAMP DEFAULT now() COMMENT '上传时间',
  serverPath     varchar(255) null COMMENT '服务器保存路径',
  serverFilename varchar(255) null COMMENT '服务器保存文件名',
  fragmentCount  int       default 0 COMMENT '分析段落数',
  parseTime      int       default 0 comment '解析耗时',
  uploadUser     varchar(50),
  parseStatus    int,
  checkCode      varchar(64) unique comment '校验是否已经处理过，可以MD5或SHA256',
  errmsg         varchar(8191) comment '进行正规式解析过程的错误消息',
  CONSTRAINT PK_source PRIMARY KEY (sourceID)
) engine = MyISAM;
DROP TABLE html;
CREATE TABLE html /*源文件*/
(
  htmlID        int           NOT NULL AUTO_INCREMENT COMMENT '唯一标识',
  sourceID      int references source (sourceID),
  filename      VARCHAR(255)  NOT NULL COMMENT '文件名',
  path          VARCHAR(1023) NULL COMMENT '路径',
  size          int COMMENT '文件尺寸',
  fragmentCount int default 0 COMMENT '分析段落数',
  parseStatus   int,
  checkCode     varchar(64) unique comment '校验是否已经处理过，可以MD5或SHA256',
  CONSTRAINT PK_html PRIMARY KEY (htmlID)
) engine = MyISAM;

drop table paragraph;
create table paragraph /*分析段落*/
(
  paragraphID   int           not null auto_increment COMMENT '唯一标识',
  sourceID      int references source (sourceID),
  htmlID        int references html (htmlID),
  body          varchar(8191) null,
  publisher     varchar(100) default '' COMMENT '发布者',
  publishTime   TIMESTAMP     null COMMENT '发布时间',
  link          json          null,
  qq            varchar(100) default '',
  wx            varchar(100) default '',
  email         varchar(100) default '',
  tiktok        varchar(100) default '' COMMENT '抖音',
  phone         varchar(100) default '' COMMENT '电话号码',
  telegram      varchar(100) default '' COMMENT '飞机',
  twitter       varchar(100) default '' COMMENT '推特',
  facebook      varchar(100) default '',
  skype         varchar(100) default '',
  bodyCheckCode varchar(64)  default '',
  insertTime    TIMESTAMP    DEFAULT now() COMMENT '分析时间',
  warnLevel     int,
  repeatCount   int,
  CONSTRAINT PK_fragment PRIMARY KEY (paragraphID)
) engine = MyISAM;

alter table paragraph
  add index idx_check_html (bodyCheckCode, htmlID);


CREATE TABLE `pattern`
(
  `expressionID`     int(11)                                                       NOT NULL AUTO_INCREMENT,
  `expressionName`   varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `capturingName` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci  NULL DEFAULT NULL,
  `expression`    varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `orderID`       int(11)                                                       NULL DEFAULT NULL,
  PRIMARY KEY (`expressionID`) USING BTREE
) ENGINE = MyISAM
  AUTO_INCREMENT = 6
  CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_general_ci
  ROW_FORMAT = Dynamic;
create table regularpattern
(
  rpID      int auto_increment primary key,
  regularID int references regular,
  expressionID int references Pattern
) engine = MyISAM;

INSERT INTO `pattern` (expressionName, capturingName, expression, orderID)
VALUES ('qq1', 'qq', '<a href=\"tel:(?<qq>d{5,10}?)\">k<qq></a>', 1);
INSERT INTO `pattern` (expressionName, capturingName, expression, orderID)
VALUES ('qq2', 'qq', '(?:企鹅|qq|扣扣|加q|🐧🐧)s*[:：]?s*(?<qq>d{5,10}?)D', 2);
INSERT INTO `pattern` (expressionName, capturingName, expression, orderID)
VALUES ('telegram', 'telegram', '<a href=\"https://t.me/(?:w{5,100}?)\">(?<telegram>(?:@|(https://t.me/))w{5,100}?)</a>', 1);
INSERT INTO `pattern` (expressionName, capturingName, expression, orderID)
VALUES ('微信', 'wx', '(?:wx|wechat|微信)\s*[:：]\s*(?<wx>[\w:.@]{5,100}?)\s', 1);
INSERT INTO `pattern`(expressionName, capturingName, expression, orderID)
VALUES ('skype', 'skype', 'sky(pe)?s*[:：]?s*(?<skype>[w:.]{3,100})s+', 1);

