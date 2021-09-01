# galaxy-troubleshooting-api

## Release 21.08 (15 AUG 2021)
###### New Features
* 新增“Dashboard查询-DoS Threat Map”功能列表，显示DoS检测地图接口
* 新增“原始日志查询-DoS事件日志”，显示DoS攻击检测日志
* 新增“原始日志查询-DoS事件日志-Summary”，显示DoS攻击趋势统计
* 新增“原始日志查询-DoS事件日志-Destination IP Traffic Trend”，显示受害者IP历史流量趋势
* 新增“基数统计-实体“流量分析
###### Update 
* 迁移“Dashboard查询”liveCharts接口，放到“Live Charts”目录中统一管理。
* 对DNS分析，增加一些查询样例

## Release 21.07 (5 JUL 2021)

###### New Features

* 增加”常用快捷功能-基数统计“，用于分析日志分布情况
* 增加”常用快捷功能-DNS放大攻击“，查询特征数据集
* 增加”通用检查-对象存储-获取某个文件“，用于文件获取验证


###### Update 
* 为所有接口增加Tests脚本，对接口进行批量验证测试
* 修正部分接口查询异常


## Release 21.06 (7 JUN 2021)

###### New Features
* Environments 增加环境变量domain、client_ip、server_ip、l7_protocol和PT1M_TIME
* 常用快捷功能增加某域名下钻、某IP下钻、协议下钻和DNS分析功能

###### Update 
* 原始日志查询，基于Druid近1小时日志变化粒度从5分钟改为1分钟。包含通联、策略和代理日志。


## Release 21.05 (6 MAY 2021)

###### New Features
* 新增“GTP-C日志”功能，辅助故障诊断
* 新增“事务日志”功能，辅助故障诊断
* 新增“活跃会话日志”功能，辅助故障诊断
* 新增“07.常用快捷功能-评估写入日志量”，查看当前系统的吞吐


###### Update 
* 修改"01.通用检查-数据存储检查"，增加事务、活跃及GTP-C 检测


## Release 21.04 (3 APR 2021)

###### New Features
* 增加“VoIP日志”功能，辅助故障诊断
* 增加“元数据检查”分类目录
* 增加“HOS对象存储”目录，用于定位对象存储


###### Update 

* 修改“SQL语法检查”为“SQL语法验证”，支持SQL语句的静态分析和数据库语义验证
* 迁移功能项位置，方便问题定位

###### Delete
* 删除“系统检查-查询引擎SQL测试集[过时]”功能，由“故障诊断-sql性能测试”替代。


## Release 21.03 (2 MAR 2021)

###### New Features

* 增加故障诊断-元数据功能，可分析日志字段是否与schema一致
* 增加故障诊断-sql性能测试，可对查询引擎进行功能性验证和POC性能测试 

###### Update 

*  对查询引擎SQL测试集标记过时


## Release 21.02 (1 FEB 2021)


###### Update 

* 改善内部测试集，应对新的功能修改






## Release 20.11.rc3 (11 DEC 2020)

###### New Features

* 增加常用快捷功能- 安装证书独立客户端IP数据趋势
* 增加常用快捷功能-访问速度最慢TOP20 域名
* 增加常用快捷功能-报告预置Metrics
* 增加原始日志查询-安全策略-动作命中计数
* 增加原始日志查询-代理策略-动作命中计数
* 增加原始日志查询-通联-流量计数(now)

###### Update 

* 改善Dashboard查询-基础统计-新建、活跃（计数）-now
* 改善Dashboard查询-新建、活跃（趋势）
* 目录增加编号，便于管理
* 修改分布式调度任务-5分钟TOPN-hot表验证表名
* 部分Action为post 改为 get，便于导出命令行

[帮助文档]: https://docs.geedge.net/pages/viewpage.action?pageId=19896569

