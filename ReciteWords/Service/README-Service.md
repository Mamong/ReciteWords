#  Service

## 组成

包括网络、模型转换、缓存、数据库、图片、键盘管理等第三方服务，应该plugin化。

## 缓存
文件、内存、keychain、userdefaults

## 数据库
SQLite

## 网络
HTTP client
HTTP server
Reachability：https://github.com/ashleymills/Reachability.swift
Socket:

## Localization

## 地图与定位

## 三方登录

## 分享

## 推送

## 应用分析

## 日志

## 支付


## 键盘管理
IQKeyboardManager


## 职能

为业务层提供常用的服务，价值在于接口封装。Service接口设计良好，可以比较容易切换第三方，而无需改动业务层代码。

