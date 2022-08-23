/*
 Navicat Premium Data Transfer

 Source Server         : 192.168.0.21
 Source Server Type    : MySQL
 Source Server Version : 80023
 Source Host           : 192.168.0.21:3307
 Source Schema         : filter

 Target Server Type    : MySQL
 Target Server Version : 80023
 File Encoding         : 65001

 Date: 26/02/2021 13:21:48
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for expression
-- ----------------------------
DROP TABLE IF EXISTS `expression`;
CREATE TABLE `expression`  (
  `expressionID` int(0) NOT NULL AUTO_INCREMENT,
  `expressionName` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `capturingName` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `exp` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `orderID` int(0) NULL DEFAULT NULL,
  PRIMARY KEY (`expressionID`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of expression
-- ----------------------------
INSERT INTO `expression` VALUES (1, 'qq', 'qq', '<a href=\"tel:(?<qq>\\d{5,10}?)\">\\k<qq></a>', 0);
INSERT INTO `expression` VALUES (2, 'qq', 'qq', '(?:企鹅|qq|扣扣|加q)\\s*[:：]?\\s*(?<qq>\\d{5,10}?)\\D', 0);
INSERT INTO `expression` VALUES (3, '飞机', 'telegram', '<a href=\"https://t.me/(?<telegram>\\w{5,100}?)\">(?:@|https://t.me/)\\k<telegram></a>', 0);
INSERT INTO `expression` VALUES (4, '微信', 'wx', '(?:wx|wechat|微信|加微)\\s*[:：]\\s*(?<wx>[\\w:.@]{5,100}?)\\s', 0);
INSERT INTO `expression` VALUES (5, 'skype', 'skype', 'sky(pe)?\\s*[:：]?\\s*(?<skype>[\\w:.]{3,100})\\s+', 0);

-- ----------------------------
-- Table structure for persistent_logins
-- ----------------------------
DROP TABLE IF EXISTS `persistent_logins`;
CREATE TABLE `persistent_logins`  (
  `username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `series` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `token` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `last_used` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
  PRIMARY KEY (`series`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of persistent_logins
-- ----------------------------
INSERT INTO `persistent_logins` VALUES ('dongtian', 'HLmc2y0yzQ0kTgP83sTWUQ==', 'KaCdRYMa9km9PIR8pDZ2jw==', '2021-02-11 11:14:47');
INSERT INTO `persistent_logins` VALUES ('dongtian', 'XvmSEu/dVrHbORk4iNQwUQ==', 'FFLYtKGjf5xkVzI1yq6pww==', '2021-02-10 10:58:34');
INSERT INTO `persistent_logins` VALUES ('dongtian', 'FaJyRoqlq05oTSHwQJ+I4A==', 'n3gvLoBT7A87F17ZKhebIg==', '2021-02-08 17:18:00');
INSERT INTO `persistent_logins` VALUES ('dongtian', 'z6DV8OGIS9gnE0jXDWJIcg==', 'Of8D+7l0jWAL4Y0LQfb7Ng==', '2021-02-22 00:53:58');

-- ----------------------------
-- Table structure for regular
-- ----------------------------
DROP TABLE IF EXISTS `regular`;
CREATE TABLE `regular`  (
  `regularID` int(0) NOT NULL AUTO_INCREMENT,
  `regularName` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `paragraph` varchar(1023) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `charset` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '字符集',
  `settingTime` timestamp(0) NULL DEFAULT CURRENT_TIMESTAMP COMMENT '设置时间',
  `warnKeyword` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `expression` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL,
  PRIMARY KEY (`regularID`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of regular
-- ----------------------------
INSERT INTO `regular` VALUES (1, '默认', '<div class=\"pull_right date details\" title=\"(?<day>\\d{2})\\.(?<month>\\d{2})\\.(?<year>\\d{4}) (?<time>\\d{2}:\\d{2}:\\d{2})\">[\\s\\S]+?<div class=\"from_name\">\\s*(?<publisher>[ \\S]+?)\\s*</div>[\\s\\S]+?<div class=\"text\">(?<paragraph>[\\s\\S]{1,8191}?)</div>', 'UTF-8', '2020-10-05 11:06:49', NULL, '[{\"exp\": \"<a href=\\\"tel:(?<qq>\\\\d{5,10}?)\\\">\\\\k<qq></a>\", \"orderID\": 0, \"expressionID\": 1, \"capturingName\": \"qq\", \"expressionName\": \"qq\"}, {\"exp\": \"(?:企鹅|qq|扣扣|加q|??)\\\\s*[:：]?\\\\s*(?<qq>\\\\d{5,10}?)\\\\D\", \"orderID\": 0, \"expressionID\": 2, \"capturingName\": \"qq\", \"expressionName\": \"qq\"}, {\"exp\": \"sky(pe)?\\\\s*[:：]?\\\\s*(?<skype>[\\\\w:.]{3,100})\\\\s+\", \"orderID\": 0, \"expressionID\": 5, \"capturingName\": \"skype\", \"expressionName\": \"skype\"}, {\"exp\": \"<a href=\\\"https://t.me/(?:\\\\w{5,100}?)\\\">(?<telegram>(?:@|(https://t.me/))\\\\w{5,100}?)</a>\", \"orderID\": 0, \"expressionID\": 3, \"capturingName\": \"telegram\", \"expressionName\": \"飞机\"}, {\"exp\": \"(?:wx|wechat|微信|加微)\\\\s*[:：]\\\\s*(?<wx>[\\\\w:.@]{5,100}?)\\\\s\", \"orderID\": 0, \"expressionID\": 4, \"capturingName\": \"wx\", \"expressionName\": \"微信\"}]');
INSERT INTO `regular` VALUES (6, '测试', 'abcasdfsdf', 'ANSI', '2020-10-02 06:18:01', NULL, NULL);

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user`  (
  `userID` int(0) NOT NULL AUTO_INCREMENT,
  `loginName` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `password` varchar(40) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `accountNonLocked` bit(1) NULL DEFAULT b'1',
  `name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `link` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL,
  `createDate` timestamp(0) NULL DEFAULT CURRENT_TIMESTAMP,
  `note` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `groupID` int(0) NULL DEFAULT NULL,
  `orderID` int(0) NULL DEFAULT 1,
  `expiredDate` timestamp(0) NULL DEFAULT NULL,
  `lockedIP` varchar(40) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `lockedLoginIP` bit(1) NULL DEFAULT b'0',
  `lastLoginTime` timestamp(0) NULL DEFAULT NULL,
  `lastLoginIP` varchar(40) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `allowSynLogin` bit(1) NULL DEFAULT b'1',
  `failureLogin` int(0) NULL DEFAULT 0,
  `succeedLogin` int(0) NULL DEFAULT 0,
  `updateTime` timestamp(0) NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP(0),
  `roleID` int(0) NULL DEFAULT NULL,
  `roles` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '',
  PRIMARY KEY (`userID`) USING BTREE,
  UNIQUE INDEX `loginName`(`loginName`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 8 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES (1, 'dongtian', '7e1eaeb9693038db20d8db780fb3975238cfaa3e', b'1', 'admin', NULL, '2019-04-15 22:50:02', NULL, NULL, 1, NULL, NULL, b'0', '2021-02-26 13:18:05', '172.17.0.1', b'1', 0, 754, '2021-02-26 05:18:04', 3, 'ADMIN');
INSERT INTO `sys_user` VALUES (7, 'admin', 'a7bd3162f5a68d6fdab8a279fb1865c07d539f30', b'1', 'hhy', NULL, '2020-09-08 11:44:09', NULL, NULL, NULL, NULL, NULL, b'0', '2021-01-30 00:18:43', '192.168.0.160', b'1', 2, 223, '2021-02-26 05:14:37', NULL, 'ADMIN');
 

-- ----------------------------
-- Table structure for body
-- ----------------------------
DROP TABLE IF EXISTS `body`;
CREATE TABLE `body`  (
  `bodyID` int(0) NOT NULL AUTO_INCREMENT,
  `content` varchar(8191) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `checkCode` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`bodyID`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for html
-- ----------------------------
DROP TABLE IF EXISTS `html`;
CREATE TABLE `html`  (
  `htmlID` int(0) NOT NULL AUTO_INCREMENT COMMENT '唯一标识',
  `sourceID` int(0) NULL DEFAULT NULL,
  `filename` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '文件名',
  `size` int(0) NULL DEFAULT NULL COMMENT '文件尺寸',
  `fragmentCount` int(0) NULL DEFAULT 0 COMMENT '分析段落数',
  `parseStatus` int(0) NULL DEFAULT NULL,
  `checkCode` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '校验是否已经处理过，可以MD5或SHA256',
  `parseTime` timestamp(0) NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP(0),
  `beginTime` timestamp(0) NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`htmlID`) USING BTREE,
  UNIQUE INDEX `checkCode`(`checkCode`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 9458 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for paragraph
-- ----------------------------
DROP TABLE IF EXISTS `paragraph`;
CREATE TABLE `paragraph`  (
  `paragraphID` int(0) NOT NULL AUTO_INCREMENT COMMENT '唯一标识',
  `sourceID` int(0) NULL DEFAULT NULL,
  `body` varchar(8191) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `publisher` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '发布者',
  `publishTime` timestamp(0) NULL DEFAULT NULL COMMENT '发布时间',
  `insertTime` timestamp(0) NULL DEFAULT CURRENT_TIMESTAMP COMMENT '分析时间',
  `link` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL,
  `warnLevel` int(0) NULL DEFAULT NULL,
  `htmlID` int(0) NULL DEFAULT NULL,
  `repeatCount` int(0) NULL DEFAULT NULL,
  `bodyCheckCode` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '',
  PRIMARY KEY (`paragraphID`) USING BTREE,
  INDEX `idx_check_html`(`bodyCheckCode`, `htmlID`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 10359652 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for source
-- ----------------------------
DROP TABLE IF EXISTS `source`;
CREATE TABLE `source`  (
  `sourceID` int(0) NOT NULL AUTO_INCREMENT COMMENT '唯一标识',
  `source` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '搜集来源，上传时人工输入',
  `regularID` int(0) NULL DEFAULT NULL,
  `filename` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '文件名',
  `path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '路径',
  `size` int(0) NULL DEFAULT NULL COMMENT '文件尺寸',
  `uploadTime` timestamp(0) NULL DEFAULT CURRENT_TIMESTAMP COMMENT '上传时间',
  `serverPath` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '服务器保存路径',
  `serverFilename` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '服务器保存文件名',
  `fragmentCount` int(0) NULL DEFAULT 0 COMMENT '分析段落数',
  `uploadUser` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `parseStatus` int(0) NULL DEFAULT NULL,
  `checkCode` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '校验是否已经处理过，可以MD5或SHA256',
  `htmlCount` int(0) NULL DEFAULT NULL,
  `parseTime` int(0) NULL DEFAULT 0,
  `errmsg` varchar(8191) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '',
  `indexTime` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  PRIMARY KEY (`sourceID`) USING BTREE,
  UNIQUE INDEX `checkCode`(`checkCode`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 56 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

SET FOREIGN_KEY_CHECKS = 1;
