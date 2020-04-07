# MobLink For Flutter

### 本插件是基于MobLink 对Flutter进行插件扩充支持。目的是方便Flutter开发者更方便地集成使用MobLink。

## 开始

1. Flutter集成文档 [MobLink-For-Flutter 在线文档](https://www.mob.com/wiki/detailed?wiki=MobLink_for_Flutter&id=34)

2. iOS平台设置参考[iOS集成文档](https://www.mob.com/wiki/detailed?wiki=Moblink_ios_major_first&id=34) 

	* 实现其中的第一点：进行官网后台配置
	* 第三点的第1.2条，URL Scheme和Universal link配置，
	* 第三点的第1.3条，MobAppkey和MobAppsecret的配置。

3. Android平台设置参考[Android集成文档](https://www.mob.com/wiki/detailed?wiki=MobLink_for_Android_gradle_quick&id=34)
	* 实现第一点完成官网后台配置
	* 在第二点中的第2条，替换appKey、appSecret为您自己的配置
	* 同时在第二点中的第2条中，需要在MobLink{}内配置以下两项 
	* uriScheme  "mlink://com.mob.moblink.demo"
	* appLinkHost  "z.t4m.cn"

4. Web平台设置参考[Web端集成文档](https://www.mob.com/wiki/detailed?wiki=MobLink_for_Web&id=34)
