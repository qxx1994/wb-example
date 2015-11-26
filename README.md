# wb-example
webbuilder示例项目

#配置
首次运行，需要修改config/dataSource/dataSource.properties里的jdbc配置。目前只支持mysql数据库


#目录结构
-----config
-------|------cache------------缓存配置
-------|--------|-----local----本地缓存支持
-------|--------|-----redis----redis缓存支持
-------|------custom------------自定义表支持，用于自动维护tables中以html定义的数据库表结构
-------|------dataSource--------数据源以及事务配置
-------|------mybatis-----------mybatis基础配置
-------|------spring------------spring主配置
-------|------web------------springMVC主配置
#webapp
视图采用freemarker，对应文件地址:WEB-INF/ftl

#新建一个功能
第一步、在tables/mysql/business 新建目录和文件，文件格式参照其他html文件。
第二步、重启服务或者调用链接 /api/initTable进行初始化表信息
第三步、进入权限管理，添加权限，注意此权限的ID需要和表名相同
第三步、分配权限给角色
#使用新建的功能
使用restful，通过ajax调用链接: /api/cf/{tableName}进行对应的操作。
GET 对应查询 POST新增 PUT修改 DELETE删除

具体功能请看:[wb-sql-util](https://github.com/wb-goup/webbuilder/blob/master/wb-sql-util)


