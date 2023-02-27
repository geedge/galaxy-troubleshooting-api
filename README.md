
# galaxy-troubleshooting-api

使用Postman组件，基于Rest API接口对TSG OLAP 进行功能验证。包括组件健康检查，功能集成测试及故障诊断。

## Release 23.02 (28 FEB 2023)

###### New Features
* 增加Traffic Shaping 相关统计接口

###### Update
* 会话日志增加列common_shaping_rule_ids
* 会话与安全事件日志增加列common_server_domain
* 会话与安全事件日志增加列common_flags_identify_info

## Release 23.01 (31 JAN 2023)
###### Update
* 会话与安全事件日志增加列common_server_fqdn
* 会话与安全事件日志增加列common_app_full_path

## Release 22.12 (30 DEC 2022)
###### New Features
* 新增Dashboards-增加App推荐
* 新增系统报告-会话日志Flags统计
* 新增系统报告-会话日志Flags占比

###### Update
* 会话与安全事件日志增加common_flags列
* 自定义IP映射-增加对ASN函数

## Release 22.11 (30 NOV 2022)
###### Update
* 会话与安全事件日志增加ssl_ja3s_hash列

## Release 22.10 (30 OCT 2022)
###### New Features
* 06其它-功能验证-Traffic Summary增加Throughput接口 
###### Update
* 更新原有查询，将VSYS ID作为默认查询条件

## Release 22.09 (30 SEP 2022)

###### Update
* 会话与安全事件日志增加common_tunnel_endpoint_a_desc, common_tunnel_endpoint_b_desc,dtls_sni 列


## Release 22.08 (31 AUG 2022)

###### New Features
* 其它-查询网关-Live Charts 总带宽流量校验
* 增加检查数据流-SQL执行计划
* 增加检查数据流-SQL查看表结构
* 增加检查数据推荐-推荐IMSI到TEID关系
* 增加检查数据推荐-推荐IMEI到TEID关系
* 增加检查数据推荐-推荐Phone Number到TEID关系
* 增加检查数据推荐-推荐apn到TEID关系
* 增加检查数据推荐-实时查询任务-提交查询任务(实时统计)
* 增加检查数据推荐-实时查询任务-获取任务结果(实时统计)
* 增加检查数据推荐-知识库列表
* 增加预处理检查-检测预处理延迟
* 增加预处理检查-已关闭会话日志延迟分布



## Release 22.07 (30 JUL 2022)

###### New Features
* 增加检查数据推荐-Top Server IP流量概况评估
* 增加检查数据推荐-Top SNI 流量概况评估

## Release 22.06 (30 JUE 2022)

###### New Features

* 检查数据流-增加存储配额一致性检查

###### Update

* 系统报告检查-增加与CM默认VSYSID=1参数

## Release 22.05 (29 APR 2022)

###### New Features

###### Update
* 检查日志-会话日志/安全事件日志增加RDP类型校验

## Release 22.04 (29 APR 2022)

###### New Features

###### Update
* 预处理检查-是否有数据验证，改为通过console后台打印日志
* Dashboards Top部分功能增加device_group, data_center维度校验

## Release 22.03 (21 MAR 2022)

###### New Features
* 增加数据预处理检查，为每类日志增加多个测试用例，区分功能或无数据问题

###### Update
* 其它-评估日志预处理，增加ETL处理时延和写入Kafka时延指标
* 检查日志模块对会话，安全和代理事件日志基于具体字段查询

###### Delete
* 删除检查数据流，关于Topic的测试用例


## Release 22.02 (8 MAR 2022)

###### New Features

*  检查数据流-元数据检查 增加schema评价文件事件日志

## Release 22.01 (27 JAN 2022)

###### New Features

*   检查数据流-TopN计算 增加Application接口验证
    

###### Update

*   重新梳理分类，删除无用接口
*   重新排列分类，将系统自检放到首位

## Release 21.12 (1 Dec 2021)
###### New Features

*   新增数据推荐查询-实时查询任务
*   新增数据推荐查询-推荐Subscriber ID 到IP关系
*   新增数据推荐查询-推荐APP活跃客户端IP
*   新增数据推荐查询-推荐TopN Server IP
*   新增数据推荐查询-推荐TopN SNI
*   新增常用快捷功能-查询网关，增加优化查询测试集
    *   Top 查询优化
    *   Calcite 缓存查询
    *   自定义时间函数补全功能

## Release 21.11 (5 Nov 2021)
###### New Features
* 新增实时推荐SubscribeID与IP映射接口 
###### Delete 
* 删除AppID列表接口
###### Update 
* 修改报告查询接口(由查询mariadb方式变更为API接口)
* 修改规范“数据推荐查询”所有接口的命名

## Release 21.10 (28 OCT 2021)
###### New Features
* 新增HOS健康状态检测接口
* 新增Druid任务健康状态检查接口
###### Delete 
* 删除原ClickHouse/Druid/ArangoDB 状态检查接口


## Release 21.09 (23 SEP 2021)
###### New Features
* 新增DNS放大攻击Resolver接口
###### Update 
* 删除分布式调度任务，5分钟TOPN校验，交由FLink统计
* 原始日志表名进行重命名，相关查询接口更新
* 修正DNS分析的SQL数据集

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

