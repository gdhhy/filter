DROP TABLE sys_user;
CREATE TABLE Sys_User /*用户表*/
(
  userID           serial,                      --用户唯一标识
  loginName        VARCHAR(20) UNIQUE NOT NULL, --登陆名
  password         VARCHAR(32)        NOT NULL, --密码
  accountNonLocked BOOLEAN   DEFAULT TRUE,
  name             VARCHAR(100)       NULL,     --姓名
  link             JSONB,                       --联系地址
  createDate       TIMESTAMP DEFAULT now(),     --用户创建日期
  note             VARCHAR(255)       NULL,     --备注
  groupID          INT                NULL,     --部门ID
  orderID          INT       DEFAULT 1,         --用户在部门内的排序
  expiredDate      TIMESTAMP,                   --过期时间
  lockedIP         VARCHAR(40),                 --是否限制登陆ip
  lockedLoginIP    BOOLEAN   DEFAULT FALSE,     --是否限制登陆ip
  lastLoginTime    TIMESTAMP,                   --最后一次登录时间
  lastLoginIP      VARCHAR(40),                 --最后一次登录的IP地址，ipv6 40位
  allowSynLogin    BOOLEAN   DEFAULT TRUE,      --允许多次登录
  failureLogin     INT,
  succeedLogin     INT,
  updateTime       TIMESTAMP,                   --过期时间
  roles            varchar(255),
  CONSTRAINT PK_User PRIMARY KEY (userID)
);
INSERT INTO  sys_user  (loginName, password, accountNonLocked, name, link, createDate, note, groupID, orderID, expiredDate, lockedIP, lockedLoginIP, lastLoginTime,
                        lastLoginIP,
                        allowSynLogin, failureLogin, succeedLogin, updateTime, roles)
VALUES ('dongtian', '96967f32873e975683971e19a7f5ddd81f8e239d', true, 'admin', NULL, now(), NULL, NULL, 1, NULL, NULL, false, to_timestamp( '2029-10-10 10:42:48','yyyy-MM-dd hh24:mi:ss'),  '', true, 0, 0, now(), 'ADMIN');
CREATE TABLE persistent_logins
(
  username  VARCHAR(64) NOT NULL,
  series    VARCHAR(64) NOT NULL,
  token     VARCHAR(64) NOT NULL,
  last_used TIMESTAMP   NOT NULL,
  PRIMARY KEY (series)
);

