/*
 Navicat Premium Data Transfer

 Source Server         : mysql_3310
 Source Server Type    : MySQL
 Source Server Version : 80011
 Source Host           : 192.168.1.212:3310
 Source Schema         : security

 Target Server Type    : MySQL
 Target Server Version : 80011
 File Encoding         : 65001

 Date: 12/10/2019 11:33:53
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user`  (
  `userID` int(11) NOT NULL AUTO_INCREMENT,
  `loginName` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `password` varchar(40) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `accountNonLocked` bit(1) NULL DEFAULT b'1',
  `name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `link` json NULL,
  `createDate` timestamp(0) NULL DEFAULT CURRENT_TIMESTAMP,
  `note` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `groupID` int(11) NULL DEFAULT NULL,
  `orderID` int(11) NULL DEFAULT 1,
  `expiredDate` timestamp(0) NULL DEFAULT NULL,
  `lockedIP` varchar(40) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `lockedLoginIP` bit(1) NULL DEFAULT b'0',
  `lastLoginTime` timestamp(0) NULL DEFAULT NULL,
  `lastLoginIP` varchar(40) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `allowSynLogin` bit(1) NULL DEFAULT b'1',
  `failureLogin` int(11) NULL DEFAULT 0,
  `succeedLogin` int(11) NULL DEFAULT 0,
  `updateTime` timestamp(0) NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP(0),
  `roleID` int(11) NULL DEFAULT NULL,
  `roles` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '',
  PRIMARY KEY (`userID`) USING BTREE,
  UNIQUE INDEX `loginName`(`loginName`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 7 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES (1, 'dongtian', 'a7bd3162f5a68d6fdab8a279fb1865c07d539f30', b'1', 'admin', NULL, '2019-04-16 10:50:02', NULL, NULL, 1, NULL, NULL, b'0', '2019-10-10 10:42:48', '192.168.1.234', b'1', 0, 529, '2019-10-10 10:42:46', 3, 'ADMIN');
INSERT INTO `sys_user` VALUES (2, 'abc', '42542bb7b09689489cafa59bc30b51a91dd4472d', b'1', '张三', NULL, '2019-04-16 11:40:01', NULL, 1, NULL, NULL, NULL, b'0', '2019-10-06 21:55:30', '0:0:0:0:0:0:0:1', b'1', 0, 19, '2019-10-06 21:55:28', NULL, 'DEVELOP');
INSERT INTO `sys_user` VALUES (5, '456', '22ec1032a5f6abf3a39fca34439b4bb9e9f94302', b'1', '科学的', NULL, '2019-04-16 14:21:31', NULL, 2, NULL, NULL, NULL, b'0', '2019-07-25 17:52:33', '0:0:0:0:0:0:0:1', b'1', 0, 1, '2019-10-06 14:46:20', 3, 'USER');

SET FOREIGN_KEY_CHECKS = 1;
